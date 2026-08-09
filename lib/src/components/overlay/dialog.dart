/// A modal panel, anchored to the viewport rather than to a trigger.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/heading.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/focus_trap.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/overlay_stack.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A modal panel.
///
/// Unlike the other overlays this one is **not anchored** — it centres in the
/// viewport, so the positioner has nothing to do. What it needs instead is the
/// full modal contract:
///
///  * focus trapped inside while open, and **restored to whatever opened it**;
///  * Escape closes it — and only it, never a layer beneath;
///  * a barrier that dims what is behind and closes on a press;
///  * content taller than the viewport scrolls rather than overflowing.
///
/// {@tool snippet}
/// ```dart
/// AstryxDialog(
///   controller: _dialog,
///   title: 'Delete project',
///   child: const AstryxText('This cannot be undone.'),
///   footer: AstryxButtonGroup(
///     children: <Widget>[
///       AstryxButton(label: 'Cancel', onPressed: _dialog.hide),
///       AstryxButton(
///         label: 'Delete',
///         variant: AstryxButtonVariant.destructive,
///         onPressed: _delete,
///       ),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// The widget renders nothing until [controller] opens it, so it can sit in a
/// build method next to whatever opens it.
class AstryxDialog extends StatefulWidget {
  /// Creates a dialog.
  const AstryxDialog({
    required this.controller,
    required this.child,
    super.key,
    this.title,
    this.description,
    this.footer,
    this.width = 480,
    this.showCloseButton = true,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
    this.onDismiss,
  });

  /// The open/closed state.
  final AstryxDialogController controller;

  /// The body.
  final Widget child;

  /// The heading, which also names the dialog for a screen reader.
  final String? title;

  /// Supporting text below the title.
  final String? description;

  /// The action row, pinned below the scrolling body.
  final Widget? footer;

  /// The dialog's width. It never exceeds the viewport minus its padding.
  final double width;

  /// Whether to show a close button in the header.
  final bool showCloseButton;

  /// Whether a press on the barrier closes it.
  ///
  /// Set false for a dialog whose choice must be made — but be sure it must.
  final bool barrierDismissible;

  /// Whether Escape closes it.
  final bool escapeDismissible;

  /// Called when the dialog dismisses itself.
  final VoidCallback? onDismiss;

  @override
  State<AstryxDialog> createState() => _AstryxDialogState();
}

/// Drives an [AstryxDialog].
class AstryxDialogController extends ChangeNotifier {
  bool _open = false;

  /// Whether the dialog is showing.
  bool get isOpen => _open;

  /// Shows the dialog.
  void show() {
    if (_open) return;
    _open = true;
    notifyListeners();
  }

  /// Hides the dialog.
  void hide() {
    if (!_open) return;
    _open = false;
    notifyListeners();
  }
}

class _AstryxDialogState extends State<AstryxDialog>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();

  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final AstryxDismissible _dismissEntry = _dismiss;

  bool _registered = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
    _animation.addStatusListener(_handleAnimationStatus);
    if (widget.controller.isOpen) _open();
  }

  @override
  void didUpdateWidget(AstryxDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChange);
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _unregister();
    widget.controller.removeListener(_handleControllerChange);
    _animation.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (!mounted) return;
    widget.controller.isOpen ? _open() : _close();
  }

  void _open() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.controller.isOpen) _open();
      });
      return;
    }
    _portal.show();
    if (widget.escapeDismissible && !_registered) {
      AstryxOverlayStack.push(_dismissEntry);
      _registered = true;
    }
    _animation
      ..duration = AstryxMotion.of(
        context,
      ).duration(AstryxDurationToken.mediumMax)
      ..forward();
  }

  void _close() {
    _unregister();
    _animation.reverse();
  }

  void _unregister() {
    if (!_registered) return;
    AstryxOverlayStack.remove(_dismissEntry);
    _registered = false;
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && _portal.isShowing) {
      _portal.hide();
    }
  }

  void _dismiss() {
    widget.controller.hide();
    widget.onDismiss?.call();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (!widget.escapeDismissible || !widget.controller.isOpen) {
      return KeyEventResult.ignored;
    }
    if (!AstryxOverlayStack.isTopmost(_dismissEntry)) {
      return KeyEventResult.ignored;
    }
    _dismiss();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _portal,
    overlayChildBuilder: _buildOverlay,
    child: const SizedBox.shrink(),
  );

  Widget _buildOverlay(BuildContext overlayContext) {
    final theme = AstryxTheme.of(context);
    final animate = AstryxMotionAccess.animate(context);

    final curved = CurvedAnimation(
      parent: _animation,
      curve: AstryxMotion.of(context).curve(),
    );

    Widget panel = _DialogPanel(
      title: widget.title,
      description: widget.description,
      footer: widget.footer,
      showCloseButton: widget.showCloseButton,
      onClose: _dismiss,
      child: widget.child,
    );

    panel = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.width),
      child: panel,
    );

    if (animate) {
      panel = FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: panel,
        ),
      );
    }

    return Focus(
      autofocus: true,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleKey,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.barrierDismissible ? _dismiss : null,
              child: animate
                  ? FadeTransition(
                      opacity: curved,
                      child: ColoredBox(
                        color: theme.color(AstryxColorToken.overlay),
                      ),
                    )
                  : ColoredBox(color: theme.color(AstryxColorToken.overlay)),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing4),
              ),
              child: Center(
                child: AstryxFocusTrap(
                  debugLabel: 'AstryxDialog',
                  child: Semantics(
                    // `scopesRoute` is what tells a screen reader the rest of
                    // the page is inert; `namesRoute` makes the title the
                    // dialog's name rather than just its first line of text.
                    scopesRoute: true,
                    namesRoute: true,
                    explicitChildNodes: true,
                    label: widget.title,
                    child: panel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The panel: header, scrolling body, pinned footer.
class _DialogPanel extends StatelessWidget {
  const _DialogPanel({
    required this.title,
    required this.description,
    required this.footer,
    required this.showCloseButton,
    required this.onClose,
    required this.child,
  });

  final String? title;
  final String? description;
  final Widget? footer;
  final bool showCloseButton;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final pad = theme.spacing(AstryxSpacingToken.spacing4);

    final header = title == null && !showCloseButton
        ? null
        : Padding(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (title != null)
                        // Excluded: the dialog's own `namesRoute` semantics
                        // already announce it, and hearing the title twice on
                        // open is the classic modal-dialog annoyance.
                        ExcludeSemantics(
                          child: AstryxHeading(
                            title!,
                            type: AstryxHeadingType.display3,
                          ),
                        ),
                      if (description != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: theme.spacing(AstryxSpacingToken.spacing1),
                          ),
                          child: AstryxText(
                            description!,
                            type: AstryxTextType.supporting,
                            color: AstryxTextColor.secondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showCloseButton)
                  AstryxIconButton(
                    icon: AstryxIconName.close,
                    label: l10n.dialogClose,
                    variant: AstryxButtonVariant.ghost,
                    size: AstryxButtonSize.sm,
                    onPressed: onClose,
                  ),
              ],
            ),
          );

    return AstryxOverlaySurface(
      shadow: AstryxShadowToken.high,
      background: AstryxColorToken.backgroundSurface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ?header,
          // Only the body scrolls. A dialog whose footer scrolls away is a
          // dialog whose primary action can be lost off the bottom.
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.all(pad),
              child: child,
            ),
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: footer,
              ),
            ),
        ],
      ),
    );
  }
}
