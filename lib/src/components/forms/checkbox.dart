/// A checkbox, including the indeterminate state.
library;

import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/selection_indicator.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The three states a checkbox can be in.
///
/// Upstream types the value as `boolean | 'indeterminate'`. A nullable `bool`
/// would say the same thing in Dart but reads as "unknown", which is exactly
/// the wrong story: indeterminate is a *definite* third state, and a parent
/// checkbox sitting in it is showing something true about its children.
enum AstryxCheckboxValue {
  /// Off.
  unchecked,

  /// On.
  checked,

  /// Partially on — some, but not all, of what this checkbox governs.
  indeterminate;

  /// Whether the box is filled, which the checked and indeterminate states
  /// share.
  bool get isFilled => this != AstryxCheckboxValue.unchecked;

  /// What a press should produce.
  ///
  /// Indeterminate resolves to checked, matching both the HTML behaviour and
  /// the expectation that pressing a half-filled "select all" selects all.
  AstryxCheckboxValue get toggled => this == AstryxCheckboxValue.checked
      ? AstryxCheckboxValue.unchecked
      : AstryxCheckboxValue.checked;
}

/// A checkbox with a label.
///
/// {@tool snippet}
/// ```dart
/// AstryxCheckbox(
///   label: 'Accept terms',
///   value: _accepted,
///   onChanged: (value) => setState(() => _accepted = value),
/// )
/// ```
/// {@end-tool}
///
/// For a tri-state checkbox use [AstryxCheckbox.tristate], whose value is an
/// [AstryxCheckboxValue] rather than a `bool`.
///
/// See also:
///
///  * `AstryxRadioList`, for a choice of one option among several.
///  * `AstryxSwitch`, for a setting that takes effect immediately.
class AstryxCheckbox extends StatefulWidget {
  /// Creates a two-state checkbox.
  AstryxCheckbox({
    required this.label,
    required bool value,
    super.key,
    ValueChanged<bool>? onChanged,
    this.description,
    this.status,
    this.size = AstryxToggleSize.md,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.labelHidden = false,
    this.focusNode,
    this.autofocus = false,
  }) : value = value
           ? AstryxCheckboxValue.checked
           : AstryxCheckboxValue.unchecked,
       onChanged = onChanged == null
           ? null
           : ((v) => onChanged(v == AstryxCheckboxValue.checked));

  /// Creates a checkbox that can also be indeterminate.
  const AstryxCheckbox.tristate({
    required this.label,
    required this.value,
    super.key,
    this.onChanged,
    this.description,
    this.status,
    this.size = AstryxToggleSize.md,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.labelHidden = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// The visible text, and the control's accessible name.
  ///
  /// Required, unlike on most controls: an unlabelled checkbox is unusable
  /// with a screen reader, and upstream requires it for the same reason.
  final String label;

  /// The current state.
  final AstryxCheckboxValue value;

  /// Called with the state a press would produce.
  ///
  /// Null makes the checkbox non-interactive without dimming it — for a
  /// checkbox reflecting state the user changes elsewhere.
  final ValueChanged<AstryxCheckboxValue>? onChanged;

  /// Helper text below the label.
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The control size.
  final AstryxToggleSize size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the state is shown but cannot be changed.
  ///
  /// Unlike [enabled], this does not dim the control — the value is still
  /// meaningful, it is simply not the user's to change here.
  final bool readOnly;

  /// Whether a change is in flight, which shows a spinner in the box.
  final bool loading;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxCheckbox> createState() => _AstryxCheckboxState();
}

class _AstryxCheckboxState extends State<AstryxCheckbox>
    with AstryxToggleStateMixin<AstryxCheckbox> {
  bool get _interactive =>
      widget.enabled &&
      !widget.readOnly &&
      !widget.loading &&
      widget.onChanged != null;

  void _toggle() {
    if (!_interactive) return;
    widget.onChanged!(widget.value.toggled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final enabled = widget.enabled && (scope?.enabled ?? true);
    final status = widget.status ?? scope?.status;

    final box = _CheckboxBox(
      value: widget.value,
      size: widget.size,
      enabled: enabled,
      loading: widget.loading,
      hovered: hoverApplies(context) && _interactive,
      theme: theme,
    );

    final row = AstryxToggleRow(
      control: AstryxFocusRing(
        focused: focusVisible(context),
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
        child: box,
      ),
      label: widget.label,
      size: widget.size,
      description: widget.description,
      labelHidden: widget.labelHidden,
      enabled: enabled,
      onTap: _toggle,
    );

    return Semantics(
      container: true,
      checked: widget.value == AstryxCheckboxValue.checked,
      // The tri-state flag, not a second "mixed" label: a screen reader that
      // understands mixed says so, and one that does not would otherwise hear
      // the word twice.
      mixed: widget.value == AstryxCheckboxValue.indeterminate,
      enabled: enabled,
      label: widget.label,
      hint: _hint(scope, status),
      onTap: _interactive ? _toggle : null,
      child: ExcludeSemantics(
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          canRequestFocus: enabled,
          onFocusChange: handleFocusChange,
          onKeyEvent: _handleKey,
          child: withHover(row),
        ),
      ),
    );
  }

  /// Space activates the checkbox, as it does on the native control.
  ///
  /// Enter deliberately does not: in a form, Enter submits, and a checkbox
  /// that swallows it breaks that.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;
    _toggle();
    return KeyEventResult.handled;
  }

  String? _hint(AstryxFieldScope? scope, AstryxFieldStatus? status) {
    final parts = <String>[
      if (widget.description != null) widget.description!,
      if (status?.message != null) status!.message!,
    ];
    return parts.isEmpty ? scope?.semanticsHint : parts.join('. ');
  }
}

/// The square itself.
///
/// The box, its fill and its hover tints are
/// [AstryxSelectionIndicator]'s — shared with the radio and the selectable
/// card. What belongs to a checkbox is the mark inside it.
class _CheckboxBox extends StatelessWidget {
  const _CheckboxBox({
    required this.value,
    required this.size,
    required this.enabled,
    required this.loading,
    required this.hovered,
    required this.theme,
  });

  final AstryxCheckboxValue value;
  final AstryxToggleSize size;
  final bool enabled;
  final bool loading;
  final bool hovered;
  final AstryxThemeData theme;

  @override
  Widget build(BuildContext context) {
    final filled = value.isFilled;

    final mark = loading
        ? AstryxSpinner(
            size: AstryxSpinnerSize.sm,
            color: filled
                ? theme.color(AstryxColorToken.onAccent)
                : theme.color(AstryxColorToken.accent),
          )
        : switch (value) {
            AstryxCheckboxValue.checked => AstryxCheckmark(
              extent: size == AstryxToggleSize.sm ? 12 : 14,
              color: theme.color(AstryxColorToken.onAccent),
            ),
            AstryxCheckboxValue.indeterminate => Container(
              width: size == AstryxToggleSize.sm ? 10 : 12,
              height: 2,
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.onAccent),
                borderRadius: theme.borderRadius(AstryxRadiusToken.full),
              ),
            ),
            AstryxCheckboxValue.unchecked => const SizedBox.shrink(),
          };

    return AstryxSelectionIndicator(
      shape: AstryxSelectionIndicatorShape.square,
      filled: filled,
      extent: AstryxToggleRow.extent(size),
      enabled: enabled,
      hovered: hovered,
      theme: theme,
      child: mark,
    );
  }
}
