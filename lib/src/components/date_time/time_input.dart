/// A field that holds a time of day.
library;

import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/foundation/semantics.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A field that holds a time of day.
///
/// A text field, not a wheel: `0930`, `9:30`, `9.30` and `9:30 am` all commit
/// half past nine, on either clock. Upstream's `TimeInput` is an
/// `<input type="time">`, which a browser gives keyboard stepping and a strict
/// parser for free; both are built by hand here, and the arrow keys move the
/// value by [stepMinutes].
///
/// **An unreadable time is refused, not guessed** — the same contract as
/// `AstryxDateInput` and `AstryxNumberInput`. On blur the field puts the
/// committed value back and announces the rejection.
///
/// {@tool snippet}
/// ```dart
/// AstryxTimeInput(
///   label: 'Starts at',
///   value: _start,
///   stepMinutes: 15,
///   onChanged: (time) => setState(() => _start = time),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxDateTimeInput`, for a day and a time together.
class AstryxTimeInput extends StatefulWidget {
  /// Creates a time field.
  const AstryxTimeInput({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.format = AstryxTimeFormat.h24,
    this.earliest,
    this.latest,
    this.stepMinutes = 1,
    this.showIcon = true,
    this.showClear = false,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.focusNode,
    this.autofocus = false,
  }) : assert(stepMinutes > 0, 'stepMinutes must be positive');

  /// The committed time, or null for an empty field.
  final AstryxTime? value;

  /// Called with a newly committed time, or null when the field is cleared.
  ///
  /// Fires on an arrow key, and on blur or Enter after typing — not on every
  /// keystroke, because `9:` is not a time.
  final ValueChanged<AstryxTime?>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown when the field is empty. Defaults to [format]'s pattern.
  final String? placeholder;

  /// Whether the time is written on a twelve- or twenty-four-hour clock.
  ///
  /// Only affects what is *written*: both clocks are always accepted on the way
  /// in, so a user who types "2pm" into a 24-hour field gets 14:00 rather than
  /// a rejection.
  final AstryxTimeFormat format;

  /// The earliest acceptable time. Null for no floor.
  final AstryxTime? earliest;

  /// The latest acceptable time. Null for no ceiling.
  final AstryxTime? latest;

  /// How far an arrow key moves the value, in minutes.
  ///
  /// One by default. Set it to 15 or 30 for a field that books something, where
  /// every intermediate minute is a value nobody wants to arrow past.
  final int stepMinutes;

  /// Whether to show the clock glyph before the text.
  final bool showIcon;

  /// Whether to show a button that empties the field.
  final bool showClear;

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

  /// {@macro AstryxField.width}
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  @override
  State<AstryxTimeInput> createState() => _AstryxTimeInputState();
}

class _AstryxTimeInputState extends State<AstryxTimeInput> {
  TextEditingController? _controller;
  FocusNode? _internalFocusNode;

  /// The last rejection, for the live region.
  String? _rejected;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The controller's first text needs the localisations — the `am` suffix
    // comes from there — so it is built here rather than in `initState`.
    _controller ??= TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(AstryxTimeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
    if ((widget.value != oldWidget.value ||
            widget.format != oldWidget.format) &&
        !_focusNode.hasFocus) {
      _controller?.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  String _format(AstryxTime? value) => value == null
      ? ''
      : formatAstryxTime(
          value,
          widget.format,
          AstryxLocalizations.of(context),
        );

  bool _accepts(AstryxTime time) {
    final earliest = widget.earliest;
    final latest = widget.latest;
    if (earliest != null && time.isBefore(earliest)) return false;
    if (latest != null && time.isAfter(latest)) return false;
    return true;
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  void _commit() {
    if (!_interactive) return;

    final l10n = AstryxLocalizations.of(context);
    final text = _controller?.text ?? '';

    if (text.trim().isEmpty) {
      _announce(null);
      if (widget.value != null) widget.onChanged!(null);
      return;
    }

    final parsed = parseAstryxTime(text, l10n);
    if (parsed == null || !_accepts(parsed)) {
      _announce(l10n.timeInputRejected(text.trim()));
      _controller?.text = _format(widget.value);
      return;
    }

    _announce(null);
    // Rewritten in the field's own clock, so a value typed as "2pm" is shown
    // back as "14:00" and the user can see what was understood.
    _controller?.text = _format(parsed);
    if (parsed != widget.value) widget.onChanged!(parsed);
  }

  void _announce(String? message) {
    if (_rejected == message) return;
    setState(() => _rejected = message);
  }

  /// Steps by [direction] × [AstryxTimeInput.stepMinutes], from the typed value
  /// if there is one.
  void _step(int direction) {
    if (!_interactive) return;

    final l10n = AstryxLocalizations.of(context);
    final from =
        parseAstryxTime(_controller?.text ?? '', l10n) ??
        widget.value ??
        widget.earliest ??
        AstryxTime.midnight;

    final next = from.plusMinutes(widget.stepMinutes * direction);
    // Refused at the boundary rather than wrapped past it: a field with a
    // floor of 09:00 stepping down from there should stop, not jump to 23:59.
    if (!_accepts(next)) return;

    _announce(null);
    _controller?.text = _format(next);
    if (next != widget.value) widget.onChanged!(next);
  }

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
    final field = AstryxTextInput(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder ?? widget.format.hint,
      size: widget.size,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      required: widget.required,
      optional: widget.optional,
      labelHidden: widget.labelHidden,
      showClear: widget.showClear,
      width: widget.width,
      autofocus: widget.autofocus,
      leading: widget.showIcon
          ? const AstryxIcon(
              AstryxIconName.clock,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            )
          : null,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _commit(),
    );

    final rejected = _rejected;

    return Focus(
      // Above the input's own node, so the arrows are seen before the text
      // field consumes them for caret movement — the same arrangement
      // `AstryxNumberInput` uses for its steppers.
      onKeyEvent: _handleKey,
      canRequestFocus: false,
      skipTraversal: true,
      child: rejected == null
          ? field
          : Stack(
              children: <Widget>[
                field,
                AstryxVisuallyHidden(
                  liveRegion: true,
                  child: Text(rejected),
                ),
              ],
            ),
    );
  }
}
