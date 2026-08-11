/// A group of checkboxes sharing one label and one validation state.
library;

import 'package:astryx_ui/src/components/forms/checkbox.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How much room a [AstryxCheckboxList] gives each row.
enum AstryxCheckboxListDensity {
  /// Tight rows and the small control, for a long list in a dense screen.
  compact(AstryxToggleSize.sm, AstryxSpacingToken.spacing1),

  /// The default.
  balanced(AstryxToggleSize.md, AstryxSpacingToken.spacing2);

  const AstryxCheckboxListDensity(this.toggleSize, this.gap);

  /// The control size rows take at this density.
  final AstryxToggleSize toggleSize;

  /// The space between rows.
  final AstryxSpacingToken gap;
}

/// One row of a [AstryxCheckboxList].
@immutable
class AstryxCheckboxOption<T> {
  /// Creates an option.
  const AstryxCheckboxOption({
    required this.value,
    required this.label,
    this.description,
    this.trailing,
    this.enabled = true,
    this.loading = false,
  });

  /// What checking this row puts in the selection.
  final T value;

  /// The visible text, and this row's accessible name.
  final String label;

  /// Helper text below the label.
  final String? description;

  /// Content after the label — a badge, a price, a count.
  ///
  /// Upstream's `endContent`. It is not part of the row's accessible name, so
  /// anything it says that the label does not belongs in [description] too.
  final Widget? trailing;

  /// Whether this row can be checked.
  final bool enabled;

  /// Whether this row is waiting on something.
  ///
  /// Shows a spinner in place of the control and refuses the toggle. Upstream
  /// drives this itself from a pending `changeAction`; here the caller owns it,
  /// as with every other control in this package.
  final bool loading;
}

/// A checkbox group: any number of independent choices under one label.
///
/// Not a radio group and not keyboarded like one. Each row is its own tab stop
/// and Space toggles it — the ARIA checkbox pattern, and the opposite of
/// `AstryxRadioList`, whose whole group is one stop with the arrow keys moving
/// inside it. Getting this wrong is the most common mistake in a hand-built
/// group: a checkbox list that swallows Tab traps the keyboard.
///
/// {@tool snippet}
/// ```dart
/// AstryxCheckboxList<String>(
///   label: 'Notifications',
///   values: _channels,
///   onChanged: (values) => setState(() => _channels = values),
///   options: const <AstryxCheckboxOption<String>>[
///     AstryxCheckboxOption(value: 'email', label: 'Email'),
///     AstryxCheckboxOption(value: 'sms', label: 'SMS'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxCheckbox`, for one independent choice.
///  * `AstryxRadioList`, for one choice among several.
class AstryxCheckboxList<T> extends StatelessWidget {
  /// Creates a checkbox group.
  const AstryxCheckboxList({
    required this.options,
    required this.values,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.density = AstryxCheckboxListDensity.balanced,
    this.dividers = false,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
  });

  /// The rows, in order.
  final List<AstryxCheckboxOption<T>> options;

  /// The values currently checked.
  final Set<T> values;

  /// Called with the new selection.
  ///
  /// A **new set** each time; the one passed in is never edited. Null makes the
  /// whole group inert.
  final ValueChanged<Set<T>>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  ///
  /// One status for the group, not one per row — which is the reason this
  /// widget exists rather than a column of checkboxes.
  final AstryxFieldStatus? status;

  /// How much room each row gets.
  final AstryxCheckboxListDensity density;

  /// Whether to draw a rule between rows.
  final bool dividers;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the selection can be read but not changed.
  ///
  /// Unlike [enabled], a read-only group is not dimmed: the values are the
  /// point, and fading them makes them harder to read for no reason.
  final bool readOnly;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// A fixed width for the whole field, label and status included.
  final double? width;

  /// The selection after toggling [option].
  Set<T> _toggled(AstryxCheckboxOption<T> option) =>
      values.contains(option.value)
      ? (<T>{...values}..remove(option.value))
      : <T>{...values, option.value};

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final groupEnabled = enabled && (scope?.enabled ?? true);
    final interactive = groupEnabled && !readOnly && onChanged != null;

    final rows = <Widget>[
      for (var i = 0; i < options.length; i++) ...<Widget>[
        if (dividers && i > 0) const AstryxDivider(),
        _CheckboxRow<T>(
          option: options[i],
          checked: values.contains(options[i].value),
          density: density,
          enabled: groupEnabled && options[i].enabled,
          readOnly: readOnly,
          onChanged: interactive && options[i].enabled
              ? () => onChanged!(_toggled(options[i]))
              : null,
        ),
      ],
    ];

    final group = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(density.gap),
      children: rows,
    );

    // Named as a set, with the rows keeping their own nodes: each is separately
    // focusable and separately checked, so flattening them would lose which.
    final named = Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? scope?.label,
      child: group,
    );

    if (label == null) {
      return width == null ? named : SizedBox(width: width, child: named);
    }

    return AstryxField(
      label: label!,
      description: description,
      status: status,
      required: required,
      optional: optional,
      enabled: enabled,
      labelHidden: labelHidden,
      width: width,
      child: named,
    );
  }
}

/// One row: the checkbox, and the tint that marks it checked.
class _CheckboxRow<T> extends StatelessWidget {
  const _CheckboxRow({
    required this.option,
    required this.checked,
    required this.density,
    required this.enabled,
    required this.readOnly,
    this.onChanged,
  });

  final AstryxCheckboxOption<T> option;
  final bool checked;
  final AstryxCheckboxListDensity density;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final checkbox = AstryxCheckbox(
      label: option.label,
      description: option.description,
      value: checked,
      size: density.toggleSize,
      enabled: enabled,
      readOnly: readOnly,
      loading: option.loading,
      onChanged: onChanged == null ? null : (_) => onChanged!(),
    );

    final trailing = option.trailing;
    final content = trailing == null
        ? checkbox
        : Row(
            children: <Widget>[
              Expanded(child: checkbox),
              SizedBox(width: theme.spacing(AstryxSpacingToken.spacing2)),
              // Excluded from the row's name: the checkbox already carries it,
              // and a badge read as part of the label makes every row announce
              // twice as much as it says.
              ExcludeSemantics(child: trailing),
            ],
          );

    // Upstream tints a checked row with `--color-accent-muted`, and not when
    // the row is disabled or read-only: a tint that survives those reads as an
    // affordance the row does not have.
    final tinted = checked && enabled && !readOnly;
    final inset = theme.spacing(AstryxSpacingToken.spacing2);

    // The inset is paid whether the row is tinted or not. Padding only the
    // checked row would shift every label sideways as it was ticked.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tinted ? theme.color(AstryxColorToken.accentMuted) : null,
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: inset, vertical: inset / 2),
        child: content,
      ),
    );
  }
}
