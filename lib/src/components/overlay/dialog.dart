/// A modal panel, anchored to the viewport rather than to a trigger.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/heading.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A modal panel.
///
/// Unlike the anchored overlays this one is **not anchored** — it centres in
/// the viewport, so the positioner has nothing to do. What it needs instead is
/// the full modal contract, which it gets from [AstryxOverlay]:
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
///
/// See also:
///
///  * `AstryxAlertDialog`, for a decision that must be made before anything
///    else can happen.
class AstryxDialog extends StatelessWidget {
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

  void _dismiss() {
    controller.hide();
    onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) => AstryxOverlay(
    controller: controller,
    label: title,
    debugLabel: 'AstryxDialog',
    barrierDismissible: barrierDismissible,
    escapeDismissible: escapeDismissible,
    onDismiss: onDismiss,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: _DialogPanel(
        title: title,
        description: description,
        footer: footer,
        showCloseButton: showCloseButton,
        onClose: _dismiss,
        child: child,
      ),
    ),
  );
}

/// Drives an [AstryxDialog].
///
/// An [AstryxOverlayController] under a name that says what it drives, so a
/// dialog's open state reads as a dialog's open state at the call site.
class AstryxDialogController extends AstryxOverlayController {}

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
