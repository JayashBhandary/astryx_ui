/// A numeric field, with steppers and a range.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/semantics.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A field that holds a number.
///
/// Upstream is an `<input type="number">`, so a browser hands it three things
/// for free that have to be built by hand here: the arrow keys stepping the
/// value, the spinner buttons, and the refusal to accept letters. All three
/// are below, and the [steppers] are drawn rather than left to the platform:
/// nothing important may live behind a hover, and a thumb has no arrow keys.
///
/// **Out-of-range input is rejected, not clamped.** Typing 200 into a field
/// whose [max] is 100 leaves the value alone: on blur the text reverts to the
/// committed value and the rejection is announced. That is upstream's
/// `parseNumberInput`, which returns null rather than the nearest legal
/// number: silently changing what somebody typed is worse than refusing it.
///
/// {@tool snippet}
/// ```dart
/// AstryxNumberInput(
///   label: 'Replicas',
///   value: _replicas,
///   min: 1,
///   max: 20,
///   onChanged: (value) => setState(() => _replicas = value),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxTextInput`, which this is built on.
class AstryxNumberInput extends StatefulWidget {
  /// Creates a number field.
  const AstryxNumberInput({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.min,
    this.max,
    this.step = 1,
    this.integerOnly = false,
    this.units,
    this.steppers = true,
    this.showClear = false,
    this.placeholder,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.leading,
    this.width,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
         min == null || max == null || min <= max,
         'min must not be greater than max',
       ),
       assert(step > 0, 'step must be positive');

  /// The committed value, or null for an empty field.
  final num? value;

  /// Called with a newly committed value, or null when the field is cleared.
  ///
  /// Fires on a stepper, on an arrow key, and on blur or Enter after typing —
  /// not on every keystroke, because half a number is not a number.
  final ValueChanged<num?>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The smallest accepted value. Null for no floor.
  final num? min;

  /// The largest accepted value. Null for no ceiling.
  final num? max;

  /// How much a stepper or an arrow key moves the value.
  final num step;

  /// Whether to refuse anything that is not a whole number.
  final bool integerOnly;

  /// A suffix inside the field — `kg`, `ms`, `%`.
  ///
  /// Shown after the number and announced with it, so a screen reader says
  /// "12 kilobytes per second" rather than reading a stray word.
  final String? units;

  /// Whether to draw the increment and decrement buttons.
  ///
  /// True by default, which is what a browser's number input shows upstream.
  /// Turn them off for a field where a keyboard is the only sensible input —
  /// a year, an ID — and the arrow keys still work.
  final bool steppers;

  /// Whether to show a button that empties the field.
  ///
  /// Emptying commits null, so a nullable value stays reachable.
  final bool showClear;

  /// {@macro AstryxTextInput.placeholder}
  final String? placeholder;

  /// {@macro AstryxButton.size}
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the value can be read but not changed.
  final bool readOnly;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Content before the number — usually an `AstryxIcon`.
  final Widget? leading;

  /// A fixed width for the whole field.
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  @override
  State<AstryxNumberInput> createState() => _AstryxNumberInputState();
}

class _AstryxNumberInputState extends State<AstryxNumberInput> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  /// The last rejection, for the live region. Cleared by the next valid entry.
  String? _rejected;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AstryxNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
    // A value that changed underneath us — a reset button, a server round
    // trip — is shown, unless the user is mid-edit in the field.
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  /// How a committed value is written into the field.
  ///
  /// An integral double is written without its `.0`: a step of 1 on a `double`
  /// field should not turn "3" into "3.0" under the caret.
  String _format(num? value) {
    if (value == null) return '';
    if (value is int) return '$value';
    return value == value.roundToDouble() ? '${value.toInt()}' : '$value';
  }

  /// Upstream's `parseNumberInput`: null for anything it will not accept.
  ///
  /// Out of range is *not accepted*, rather than pulled to the boundary.
  num? _parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed == '-') return null;

    final parsed = num.tryParse(trimmed);
    if (parsed == null || !parsed.isFinite) return null;
    if (widget.integerOnly && parsed != parsed.roundToDouble()) return null;
    if (widget.min != null && parsed < widget.min!) return null;
    if (widget.max != null && parsed > widget.max!) return null;

    return parsed;
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  /// Commits what is typed, or puts the committed value back.
  void _commit() {
    if (!_interactive) return;

    final text = _controller.text;
    final l10n = AstryxLocalizations.of(context);

    if (text.trim().isEmpty) {
      // An emptied field commits null when it is allowed to be empty, and
      // otherwise reverts — upstream's clearable contract.
      if (widget.showClear) {
        _announce(null);
        if (widget.value != null) widget.onChanged!(null);
        return;
      }
      _controller.text = _format(widget.value);
      return;
    }

    final parsed = _parse(text);
    if (parsed == null) {
      // Reverting silently would leave a screen-reader user with no idea their
      // entry was thrown away — WCAG 3.3.1. Hence the live region below.
      _announce(l10n.numberInputRejected(text));
      _controller.text = _format(widget.value);
      return;
    }

    _announce(null);
    _controller.text = _format(parsed);
    if (parsed != widget.value) widget.onChanged!(parsed);
  }

  void _announce(String? message) {
    if (_rejected == message) return;
    setState(() => _rejected = message);
  }

  /// Steps by [direction] × `step`, from the typed value if there is one.
  void _step(int direction) {
    if (!_interactive) return;

    final from = _parse(_controller.text) ?? widget.value ?? _stepBase();
    final next = from + widget.step * direction;
    // A step is the one place a boundary is *not* a rejection: pressing "up"
    // at the maximum should stop there, as a browser's spinner does, rather
    // than doing nothing for a reason nobody can see.
    final clamped = _clamp(next);
    if (clamped == widget.value) return;

    _announce(null);
    _controller.text = _format(clamped);
    widget.onChanged!(clamped);
  }

  /// Where stepping starts in an empty field: the floor, or zero.
  num _stepBase() => widget.min ?? 0;

  num _clamp(num value) {
    var result = value;
    if (widget.min != null && result < widget.min!) result = widget.min!;
    if (widget.max != null && result > widget.max!) result = widget.max!;
    if (widget.integerOnly) result = result.round();
    return result;
  }

  bool get _canIncrease =>
      _interactive &&
      (widget.max == null || (widget.value ?? _stepBase()) < widget.max!);

  bool get _canDecrease =>
      _interactive &&
      (widget.min == null || (widget.value ?? _stepBase()) > widget.min!);

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        _step(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _step(-1);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    final field = AstryxTextInput(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      size: widget.size,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      required: widget.required,
      optional: widget.optional,
      labelHidden: widget.labelHidden,
      showClear: widget.showClear,
      width: widget.width,
      autofocus: widget.autofocus,
      leading: widget.leading,
      trailing: _buildTrailing(context, l10n),
      // A numeric keyboard on a phone, signed only where a negative value is
      // legal — the range is known, so the wrong half of the keypad need not
      // be offered.
      keyboardType: TextInputType.numberWithOptions(
        decimal: !widget.integerOnly,
        signed: widget.min == null || widget.min! < 0,
      ),
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          RegExp(widget.integerOnly ? r'[\d\-]' : r'[\d\-\.]'),
        ),
      ],
      // Enter commits without waiting for focus to leave, which is what a form
      // keyboard user expects.
      onSubmitted: (_) => _commit(),
    );

    final rejected = _rejected;

    return Focus(
      // Above the input's own node, so the arrows are seen before the text
      // field consumes them for caret movement — which is what a browser's
      // number input does, and what makes stepping work from the keyboard.
      onKeyEvent: _handleKey,
      canRequestFocus: false,
      skipTraversal: true,
      child: rejected == null
          ? field
          : Stack(
              children: <Widget>[
                field,
                // Announced, never painted: the field has already put the old
                // value back, so there is nothing to show.
                AstryxVisuallyHidden(
                  liveRegion: true,
                  child: Text(rejected),
                ),
              ],
            ),
    );
  }

  Widget? _buildTrailing(BuildContext context, AstryxLocalizations l10n) {
    final units = widget.units;
    final items = <Widget>[
      if (units != null)
        AstryxText(
          units,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      if (widget.steppers) ...<Widget>[
        AstryxIconButton(
          icon: AstryxIconName.arrowDown,
          label: l10n.numberInputDecrement(widget.label ?? ''),
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: _canDecrease ? () => _step(-1) : null,
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowUp,
          label: l10n.numberInputIncrement(widget.label ?? ''),
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: _canIncrease ? () => _step(1) : null,
        ),
      ],
    ];

    if (items.isEmpty) return null;
    if (items.length == 1) return items.first;
    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}
