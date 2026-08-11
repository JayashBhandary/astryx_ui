/// A modal that interrupts to confirm one consequential action.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/dialog.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A modal that asks one question and takes one answer.
///
/// The difference from [AstryxDialog] is not visual, it is behavioural: an
/// alert dialog exists because something **irreversible** is about to happen,
/// so it is deliberately harder to leave by accident.
///
///  * The barrier does **not** dismiss it. A stray click beside a confirmation
///    is the single most common way people answer a question they did not read.
///  * There is no close button — the two buttons are the only ways out, plus
///    Escape, which means cancel.
///  * Focus starts on **cancel**, not on the confirming action, so a user who
///    hits Enter out of habit does not delete anything.
///
/// {@tool snippet}
/// ```dart
/// AstryxAlertDialog(
///   controller: _confirm,
///   title: 'Delete project',
///   description: 'Atlas and its 4,102 requests will be removed. This cannot '
///       'be undone.',
///   confirmLabel: 'Delete project',
///   destructive: true,
///   onConfirm: _delete,
/// )
/// ```
/// {@end-tool}
///
/// Reach for [AstryxDialog] instead whenever the user is doing something rather
/// than confirming something — a form, a picker, anything with more than one
/// outcome. An alert dialog used for ordinary work trains people to dismiss the
/// one that matters.
class AstryxAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  const AstryxAlertDialog({
    required this.controller,
    required this.title,
    required this.description,
    required this.confirmLabel,
    super.key,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.destructive = false,
    this.width = 420,
    this.showCancel = true,
    this.barrierDismissible = false,
    this.escapeDismissible = true,
    this.child,
  });

  /// The open/closed state.
  ///
  /// The same controller type a dialog takes, because an alert dialog *is* a
  /// dialog with the answers built in.
  final AstryxDialogController controller;

  /// The question, as a statement. It also names the dialog for a screen
  /// reader.
  final String title;

  /// What confirming will do, in one or two sentences.
  ///
  /// Required, unlike a dialog's: a confirmation whose consequence is left to
  /// the title is a confirmation nobody can give informed consent to.
  final String description;

  /// The label on the confirming button.
  ///
  /// Name the action — "Delete project", not "OK". A button labelled with the
  /// verb can be read on its own, which is how it is read by anyone tabbing to
  /// it.
  final String confirmLabel;

  /// Called after the dialog closes on confirm.
  final VoidCallback? onConfirm;

  /// The label on the cancelling button. Defaults to the localised "Cancel".
  final String? cancelLabel;

  /// Called when the user cancels — by the button, by Escape, or by the
  /// barrier where it is dismissible.
  final VoidCallback? onCancel;

  /// Whether confirming is destructive, which colours that button with
  /// `--color-error`.
  final bool destructive;

  /// The dialog's width. Narrower than a dialog's: there is less in it.
  final double width;

  /// Whether to offer a cancelling button at all.
  ///
  /// False for an acknowledgement — a single "Got it" for something the user
  /// cannot decline. Escape still closes it unless [escapeDismissible] is off.
  final bool showCancel;

  /// Whether a press on the barrier cancels.
  ///
  /// Off by default, which is the whole point of the component.
  final bool barrierDismissible;

  /// Whether Escape cancels.
  final bool escapeDismissible;

  /// Extra content below the description — a list of what will be removed, a
  /// checkbox for "don't ask again".
  final Widget? child;

  void _confirm() {
    // Close first, then act. The callback may open another overlay or push a
    // route, and a confirmation still on screen behind it reads as ignored.
    controller.hide();
    onConfirm?.call();
  }

  void _cancel() {
    controller.hide();
    onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    return AstryxDialog(
      controller: controller,
      title: title,
      width: width,
      showCloseButton: false,
      barrierDismissible: barrierDismissible,
      escapeDismissible: escapeDismissible,
      onDismiss: onCancel,
      footer: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          if (showCancel)
            AstryxButton(
              label: cancelLabel ?? l10n.alertDialogCancel,
              // The safe answer holds focus when the dialog opens. Everything
              // else about this component follows from that decision.
              autofocus: true,
              onPressed: _cancel,
            ),
          AstryxButton(
            label: confirmLabel,
            variant: destructive
                ? AstryxButtonVariant.destructive
                : AstryxButtonVariant.primary,
            autofocus: !showCancel,
            onPressed: _confirm,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AstryxText(description),
          if (child != null)
            Padding(
              padding: EdgeInsets.only(
                top: theme.spacing(AstryxSpacingToken.spacing3),
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
