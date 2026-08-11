/// The label / description / status wrapper around an input.
library;

import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/form_layout.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// Everything a control needs from its enclosing field.
///
/// Passed down so the input can build its *own* semantics with the label and
/// error already folded in — which is the whole point of the widget. HTML has
/// `<label for>`; Flutter has no such association, so the strings have to
/// reach the control that owns the semantics node.
@immutable
class AstryxFieldScope extends InheritedWidget {
  /// Creates a field scope.
  const AstryxFieldScope({
    required this.label,
    required super.child,
    super.key,
    this.description,
    this.status,
    this.required = false,
    this.enabled = true,
  });

  /// The field's visible label, and the control's accessible name.
  final String label;

  /// Helper text below the label.
  final String? description;

  /// The validation state, if any.
  final AstryxFieldStatus? status;

  /// Whether the field must be filled in.
  final bool required;

  /// Whether the field accepts input.
  final bool enabled;

  /// The hint a control should carry: its description, then its status message.
  ///
  /// Both matter to a screen-reader user and neither is reachable any other
  /// way, so they are joined rather than one winning.
  String? get semanticsHint {
    final parts = <String>[
      if (description != null && description!.isNotEmpty) description!,
      if (status?.message != null && status!.message!.isNotEmpty)
        status!.message!,
    ];
    return parts.isEmpty ? null : parts.join('. ');
  }

  /// The field configuration at [context], or null outside a field.
  static AstryxFieldScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxFieldScope>();

  @override
  bool updateShouldNotify(AstryxFieldScope oldWidget) =>
      label != oldWidget.label ||
      description != oldWidget.description ||
      status != oldWidget.status ||
      required != oldWidget.required ||
      enabled != oldWidget.enabled;
}

/// Wraps an input with its label, description and validation message.
///
/// **Accessibility is the point of this widget.** HTML associates a label with
/// an input through `<label for>`; Flutter has no equivalent, so a label
/// rendered merely *next to* a control is invisible to a screen reader. This
/// widget publishes its label, description and status through an
/// [AstryxFieldScope], and each Astryx input folds them into the `Semantics`
/// node it already owns.
///
/// A status message is also **announced when it first appears** — an error that
/// only changes a colour tells a non-visual user nothing.
///
/// {@tool snippet}
/// ```dart
/// AstryxField(
///   label: 'Email',
///   description: 'We only use this to sign you in.',
///   required: true,
///   status: const AstryxFieldStatus.error('That address is not valid'),
///   child: AstryxTextInput(controller: _email),
/// )
/// ```
/// {@end-tool}
///
/// Every Astryx input takes the same label, description and status parameters
/// directly and wraps itself in one of these, so reaching for `AstryxField` by
/// hand is only needed around a non-Astryx control.
class AstryxField extends StatefulWidget {
  /// Creates a field.
  const AstryxField({
    required this.label,
    required this.child,
    super.key,
    this.description,
    this.status,
    this.required = false,
    this.optional = false,
    this.enabled = true,
    this.labelHidden = false,
    this.width,
  }) : assert(
         !(required && optional),
         'A field is required or optional, not both',
       );

  /// {@template AstryxField.label}
  /// The field's name, shown above the control and used as its accessible
  /// name.
  /// {@endtemplate}
  final String label;

  /// The control this field describes.
  final Widget child;

  /// {@template AstryxField.description}
  /// Helper text between the label and the control.
  /// {@endtemplate}
  final String? description;

  /// {@template AstryxField.status}
  /// The validation state, shown below the control.
  /// {@endtemplate}
  final AstryxFieldStatus? status;

  /// {@template AstryxField.required}
  /// Whether the field must be filled in.
  ///
  /// Shows a "Required" marker *and* sets the semantics flag — the marker
  /// alone is a visual convention a screen reader cannot infer.
  /// {@endtemplate}
  final bool required;

  /// {@template AstryxField.optional}
  /// Whether to mark the field as optional.
  ///
  /// Mutually exclusive with [required]. Useful in a form where most fields
  /// are mandatory and the exceptions are worth calling out.
  /// {@endtemplate}
  final bool optional;

  /// {@template AstryxField.enabled}
  /// Whether the field accepts input.
  /// {@endtemplate}
  final bool enabled;

  /// {@template AstryxField.labelHidden}
  /// Whether to hide the label visually.
  ///
  /// It still names the control. For a field whose purpose is obvious from
  /// context — a search box beside a magnifier — where a visible label would
  /// be redundant to a sighted user but its absence would leave a screen
  /// reader with nothing.
  /// {@endtemplate}
  final bool labelHidden;

  /// {@template AstryxField.width}
  /// A fixed width. Null fills the available space.
  /// {@endtemplate}
  final double? width;

  @override
  State<AstryxField> createState() => _AstryxFieldState();
}

class _AstryxFieldState extends State<AstryxField> {
  @override
  void didUpdateWidget(AstryxField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final status = widget.status;
    if (status == null || status == oldWidget.status) return;
    final message = status.message;
    if (message == null || message.isEmpty) return;

    // Announced only on *change*, and only when there is something to say. A
    // colour change conveys nothing to a screen-reader user, and re-announcing
    // an unchanged message on every rebuild would be worse than silence.
    // The view-scoped form, not the deprecated `announce` — the latter guesses
    // at a single window and is wrong in a multi-window app.
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
      assertiveness: status.type.isAssertive
          ? Assertiveness.assertive
          : Assertiveness.polite,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final status = widget.status;

    final marker = widget.required
        ? l10n.fieldRequired
        : (widget.optional ? l10n.fieldOptional : null);

    // A label-left form puts the label beside the control rather than above
    // it — see `AstryxFormLayout`. Nothing else about the field changes, and
    // outside such a form the scope is absent and this is false.
    final labelBeside =
        !widget.labelHidden && AstryxFormLayoutScope.labelsBesideAt(context);

    final labelBlock = widget.labelHidden
        ? null
        // The label is decorative *here*, because the control carries it as
        // its accessible name. Announcing it twice is the classic mistake.
        : ExcludeSemantics(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    Flexible(
                      child: AstryxText(
                        widget.label,
                        type: AstryxTextType.label,
                        color: widget.enabled
                            ? AstryxTextColor.primary
                            : AstryxTextColor.disabled,
                      ),
                    ),
                    if (marker != null)
                      AstryxText(
                        marker,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                  ],
                ),
                if (widget.description != null)
                  AstryxText(
                    widget.description!,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
              ],
            ),
          );

    var field = labelBeside
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: theme.spacing(AstryxSpacingToken.spacing4),
            children: <Widget>[
              SizedBox(
                // A number, not the widest label in the form: CSS grid sizes
                // that column for upstream, and Flutter would have to lay every
                // label out twice to match it.
                width:
                    AstryxFormLayoutScope.maybeOf(context)?.labelWidth ?? 160,
                child: labelBlock,
              ),
              Expanded(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    widget.child,
                    if (status?.message != null && status!.message!.isNotEmpty)
                      ExcludeSemantics(
                        child: _StatusMessage(
                          status: status,
                          enabled: widget.enabled,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )
        : AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              // The label block uses `Flexible`, so a long label wraps rather
              // than overflowing: at 200% text scale a thirteen-character
              // label is already wider than a 320px field (ADR-042).
              ?labelBlock,
              widget.child,
              if (status?.message != null && status!.message!.isNotEmpty)
                ExcludeSemantics(
                  child: _StatusMessage(
                    status: status,
                    enabled: widget.enabled,
                  ),
                ),
            ],
          );

    if (widget.width != null) {
      field = SizedBox(width: widget.width, child: field);
    }

    return AstryxFieldScope(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      enabled: widget.enabled,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: theme.color(AstryxColorToken.textPrimary),
        ),
        child: field,
      ),
    );
  }
}

/// The icon and text below a control.
class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.status, required this.enabled});

  final AstryxFieldStatus status;
  final bool enabled;

  @override
  Widget build(BuildContext context) => AstryxHStack(
    gap: AstryxSpacingToken.spacing1,
    align: AstryxStackAlign.start,
    children: <Widget>[
      AstryxIcon(
        status.type.icon,
        size: AstryxIconSize.xsm,
        color: enabled ? _iconColorFor(status.type) : AstryxIconColor.disabled,
      ),
      Flexible(
        child: AstryxText(
          status.message!,
          type: AstryxTextType.supporting,
          // `AstryxTextColor` has no status entries — they are field-specific
          // rather than part of the text vocabulary — so the colour comes
          // through `style`, which is the documented escape hatch.
          color: AstryxTextColor.inherit,
          style: TextStyle(
            color: AstryxTheme.of(context).color(
              enabled ? status.type.color : AstryxColorToken.textDisabled,
            ),
          ),
        ),
      ),
    ],
  );

  static AstryxIconColor _iconColorFor(AstryxFieldStatusType type) =>
      switch (type) {
        AstryxFieldStatusType.error => AstryxIconColor.error,
        AstryxFieldStatusType.warning => AstryxIconColor.warning,
        AstryxFieldStatusType.success => AstryxIconColor.success,
      };
}
