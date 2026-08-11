/// The scrim-and-layer primitive every modal is built on.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/foundation/focus_trap.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/overlay_stack.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A layer above the page, with a scrim behind it.
///
/// This is the modal contract with **no opinion about what is on the layer**:
///
///  * a scrim that dims the page and closes on a press;
///  * focus trapped inside while open, and restored to whatever opened it;
///  * Escape closes it — and only it, never a layer beneath;
///  * an entry and exit animation that honours reduced motion.
///
/// `AstryxDialog` is this widget plus a header, a scrolling body and a footer.
/// Reach for [AstryxOverlay] directly when that shape is wrong — a media
/// lightbox, a command palette, a sheet — and you want the contract without the
/// panel.
///
/// Like every overlay here it is a **widget in the tree**, not a `showDialog`
/// call: it renders nothing until [controller] opens it, so it can sit next to
/// whatever opens it and there is no `BuildContext` to smuggle across an async
/// gap.
///
/// {@tool snippet}
/// ```dart
/// AstryxOverlay(
///   controller: _lightbox,
///   label: 'Preview',
///   child: AstryxCard(child: Image.network(url)),
/// )
/// ```
/// {@end-tool}
class AstryxOverlay extends StatefulWidget {
  /// Creates an overlay layer.
  const AstryxOverlay({
    required this.controller,
    required this.child,
    super.key,
    this.alignment = Alignment.center,
    this.padding,
    this.showScrim = true,
    this.scrimColor,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
    this.trapFocus = true,
    this.restoreFocus = true,
    this.transition = AstryxOverlayTransition.scale,
    this.duration = AstryxDurationToken.mediumMax,
    this.label,
    this.scopesRoute = true,
    this.onDismiss,
    this.debugLabel,
  });

  /// The open/closed state.
  final AstryxOverlayController controller;

  /// What sits on the layer.
  final Widget child;

  /// Where [child] sits in the viewport.
  final AlignmentGeometry alignment;

  /// The inset between [child] and the viewport edge.
  ///
  /// Defaults to `--spacing-4`, which is what stops a full-height panel meeting
  /// the screen edge on a phone.
  final EdgeInsetsGeometry? padding;

  /// Whether to dim the page behind the layer.
  ///
  /// False for a layer that must not imply the page is inert — but note that
  /// focus is still trapped unless [trapFocus] is also false, and a layer that
  /// looks non-modal while behaving modally is worse than either.
  final bool showScrim;

  /// The scrim's colour. Defaults to `--color-overlay`.
  final AstryxColorToken? scrimColor;

  /// Whether a press on the scrim closes it.
  final bool barrierDismissible;

  /// Whether Escape closes it.
  final bool escapeDismissible;

  /// Whether focus is trapped inside while open.
  final bool trapFocus;

  /// Whether focus returns to whatever opened it on close.
  final bool restoreFocus;

  /// How the layer enters and leaves.
  ///
  /// [AstryxOverlayTransition.slide] has no meaning here — there is no anchor
  /// to slide from — and is treated as a fade.
  final AstryxOverlayTransition transition;

  /// How long the entry and exit take.
  final AstryxDurationToken duration;

  /// The layer's accessible name.
  final String? label;

  /// Whether the layer is announced as a route that makes the page behind it
  /// inert.
  ///
  /// True for anything modal. False for a layer that is merely floating — a
  /// screen reader user should not be told the page is unavailable when it is.
  final bool scopesRoute;

  /// Called when the layer dismisses itself.
  final VoidCallback? onDismiss;

  /// A label for the debug focus tree.
  final String? debugLabel;

  @override
  State<AstryxOverlay> createState() => _AstryxOverlayState();
}

class _AstryxOverlayState extends State<AstryxOverlay>
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
  void didUpdateWidget(AstryxOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChange);
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    // Unregistering here is what stops a disposed layer from swallowing the
    // next Escape long after the widget that owned it is gone.
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
    // `OverlayPortalController.show()` asserts if called during build, and a
    // legitimate caller does exactly that — opening a layer because a parent
    // rebuilt. Deferring one frame is the fix, and it is invisible.
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
      ..duration = AstryxMotion.of(context).duration(widget.duration)
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
    // The portal stays mounted through the exit animation and comes down only
    // when it finishes — otherwise closing is a disappearance, not an exit.
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
    // Only the top-most layer responds. A popover inside a dialog closes the
    // popover; the dialog stays.
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

    var layer = widget.child;

    if (animate) {
      final faded = FadeTransition(opacity: curved, child: layer);
      layer = switch (widget.transition) {
        AstryxOverlayTransition.scale => ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: faded,
        ),
        // Nothing to slide from: a viewport layer has no anchor.
        AstryxOverlayTransition.slide || AstryxOverlayTransition.fade => faded,
      };
    }

    Widget positioned = Align(alignment: widget.alignment, child: layer);

    if (widget.trapFocus) {
      positioned = AstryxFocusTrap(
        debugLabel: widget.debugLabel ?? 'AstryxOverlay',
        restoreFocus: widget.restoreFocus,
        child: positioned,
      );
    }

    positioned = Semantics(
      // `scopesRoute` is what tells a screen reader the rest of the page is
      // inert; `namesRoute` makes the label the layer's name rather than just
      // its first line of text.
      scopesRoute: widget.scopesRoute,
      namesRoute: widget.scopesRoute,
      explicitChildNodes: true,
      label: widget.label,
      child: positioned,
    );

    final scrim = ColoredBox(
      color: theme.color(widget.scrimColor ?? AstryxColorToken.overlay),
    );

    return Focus(
      autofocus: true,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleKey,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              // Opaque, so a press on the scrim cannot reach the page behind
              // it. A modal that lets clicks through is not a modal.
              behavior: widget.showScrim
                  ? HitTestBehavior.opaque
                  : HitTestBehavior.translucent,
              onTap: widget.barrierDismissible ? _dismiss : null,
              child: !widget.showScrim
                  ? const SizedBox.expand()
                  : (animate
                        ? FadeTransition(opacity: curved, child: scrim)
                        : scrim),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding:
                  widget.padding ??
                  EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
              child: positioned,
            ),
          ),
        ],
      ),
    );
  }
}
