/// A field that holds one date, typed or picked.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/date_time/calendar.dart';
import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/foundation/semantics.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// A date field: typed into, or picked from a calendar.
///
/// Typing comes first. A date picker that can only be *clicked* is slower than
/// a keyboard for anybody who knows the date they want, and upstream's
/// `DateInput` is a text input for that reason — the calendar is the second way
/// in, not the only one.
///
/// **A date that cannot be read is refused, not guessed.** On blur or Enter the
/// text is parsed; if it is not a date, or falls outside [firstDate] and
/// [lastDate], the field puts the committed value back and announces the
/// rejection. Quietly moving what somebody typed is the worse failure — see
/// `AstryxNumberInput`, which takes the same line.
///
/// {@tool snippet}
/// ```dart
/// AstryxDateInput(
///   label: 'Due date',
///   value: _due,
///   firstDate: DateTime.now(),
///   onChanged: (date) => setState(() => _due = date),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxCalendar], the grid this opens.
///  * `AstryxDateRangeInput`, for two dates.
///  * `AstryxDateTimeInput`, for a date and a time.
class AstryxDateInput extends StatefulWidget {
  /// Creates a date field.
  const AstryxDateInput({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.format = AstryxDateFormat.dayMonthYear,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.firstDayOfWeek = AstryxWeekday.monday,
    this.showCalendar = true,
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
    this.today,
  });

  /// The committed date, or null for an empty field. Only its date part is
  /// read.
  final DateTime? value;

  /// Called with a newly committed date, at midnight, or null when the field is
  /// cleared.
  ///
  /// Fires on a calendar press, and on blur or Enter after typing — not on
  /// every keystroke, because half a date is not a date.
  final ValueChanged<DateTime?>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown when the field is empty. Defaults to [format]'s pattern.
  ///
  /// The default is deliberate: `DD/MM/YYYY` is the only thing on screen that
  /// tells a user which of the two ambiguous orders this field wants.
  final String? placeholder;

  /// The order the parts are written and read in.
  final AstryxDateFormat format;

  /// The earliest acceptable date. Null for no floor.
  final DateTime? firstDate;

  /// The latest acceptable date. Null for no ceiling.
  final DateTime? lastDate;

  /// Rules out individual days — weekends, holidays, days already taken.
  ///
  /// Applies to typing as well as to the calendar: a day the grid will not let
  /// you press is a day the field will not accept.
  final AstryxDayPredicate? selectableDayPredicate;

  /// Which day the calendar's week starts on.
  final AstryxWeekday firstDayOfWeek;

  /// Whether to offer the calendar button.
  ///
  /// False leaves a typing-only field, for a form where dates are transcribed
  /// from somewhere else and the grid is in the way.
  final bool showCalendar;

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

  /// What the calendar treats as today. Defaults to the system clock.
  final DateTime? today;

  @override
  State<AstryxDateInput> createState() => _AstryxDateInputState();
}

class _AstryxDateInputState extends State<AstryxDateInput> {
  final AstryxOverlayController _overlay = AstryxOverlayController();

  @override
  void dispose() {
    _overlay.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  bool _accepts(DateTime day) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    final at = astryxStartOfDay(day);
    if (first != null && at.isBefore(astryxStartOfDay(first))) return false;
    if (last != null && at.isAfter(astryxStartOfDay(last))) return false;
    return widget.selectableDayPredicate?.call(at) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    if (!widget.showCalendar) return _buildField(context, l10n, null);

    return AstryxPopover(
      controller: _overlay,
      label: widget.label ?? l10n.calendarLabel,
      align: AstryxOverlayAlign.start,
      content: AstryxCalendar(
        selected: widget.value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        selectableDayPredicate: widget.selectableDayPredicate,
        firstDayOfWeek: widget.firstDayOfWeek,
        today: widget.today,
        enabled: _interactive,
        autofocus: true,
        onChanged: (day) {
          widget.onChanged?.call(day);
          _overlay.hide();
        },
      ),
      triggerBuilder: (context, controller) =>
          _buildField(context, l10n, controller),
    );
  }

  Widget _buildField(
    BuildContext context,
    AstryxLocalizations l10n,
    AstryxOverlayController? controller,
  ) => AstryxDateTextField(
    value: widget.value,
    onChanged: widget.onChanged,
    format: widget.format,
    accepts: _accepts,
    label: widget.label,
    description: widget.description,
    status: widget.status,
    placeholder: widget.placeholder,
    showClear: widget.showClear,
    size: widget.size,
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    required: widget.required,
    optional: widget.optional,
    labelHidden: widget.labelHidden,
    width: widget.width,
    focusNode: widget.focusNode,
    autofocus: widget.autofocus,
    trailing: controller == null
        ? null
        : AstryxIconButton(
            icon: AstryxIconName.calendar,
            label: l10n.dateInputOpenCalendar(widget.label ?? ''),
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            enabled: _interactive,
            onPressed: controller.toggle,
          ),
  );
}

/// The text half of every date field.
///
/// Shared by `AstryxDateInput`, `AstryxDateRangeInput` and
/// `AstryxDateTimeInput`: three fields that parse the same way, revert the same
/// way and announce the same way. Duplicating that is how two of them end up
/// disagreeing about what `4/8` means.
@internal
class AstryxDateTextField extends StatefulWidget {
  /// Creates a date text field.
  const AstryxDateTextField({
    required this.value,
    required this.format,
    super.key,
    this.onChanged,
    this.accepts,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.leading,
    this.trailing,
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
  });

  /// The committed date, or null.
  final DateTime? value;

  /// The order the parts are written and read in.
  final AstryxDateFormat format;

  /// Called with a newly committed date, or null when the field is emptied.
  final ValueChanged<DateTime?>? onChanged;

  /// Whether a parsed date is acceptable. Null accepts every real date.
  final bool Function(DateTime day)? accepts;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown when empty. Defaults to the format's pattern.
  final String? placeholder;

  /// Content before the text.
  final Widget? leading;

  /// Content after the text — normally the calendar button.
  final Widget? trailing;

  /// Whether to show a button that empties the field.
  final bool showClear;

  /// The control height.
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

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxDateTextField> createState() => _AstryxDateTextFieldState();
}

class _AstryxDateTextFieldState extends State<AstryxDateTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );
  FocusNode? _internalFocusNode;

  /// The last rejection, for the live region. Cleared by the next valid entry.
  String? _rejected;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AstryxDateTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
    // A value that changed underneath us — the calendar, a preset, a server
    // round trip — is shown, unless the user is mid-edit in the field.
    if (!astryxIsSameDay(widget.value, oldWidget.value) &&
        !_focusNode.hasFocus) {
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

  String _format(DateTime? value) =>
      value == null ? '' : formatAstryxDate(value, widget.format);

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  void _commit() {
    if (!_interactive) return;

    final text = _controller.text;
    final l10n = AstryxLocalizations.of(context);

    if (text.trim().isEmpty) {
      _announce(null);
      if (widget.value != null) widget.onChanged!(null);
      return;
    }

    final parsed = parseAstryxDate(text, widget.format);
    if (parsed == null || !(widget.accepts?.call(parsed) ?? true)) {
      _announce(l10n.dateInputRejected(text.trim()));
      _controller.text = _format(widget.value);
      return;
    }

    _announce(null);
    // Rewritten in the field's own format, so "4-8-26" becomes "04/08/2026"
    // and the user can see what was understood.
    _controller.text = _format(parsed);
    if (!astryxIsSameDay(parsed, widget.value)) widget.onChanged!(parsed);
  }

  void _announce(String? message) {
    if (_rejected == message) return;
    setState(() => _rejected = message);
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
      leading: widget.leading,
      trailing: widget.trailing,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      // Enter commits without waiting for focus to leave, which is what a form
      // keyboard user expects.
      onSubmitted: (_) => _commit(),
    );

    final rejected = _rejected;
    if (rejected == null) return field;

    return Stack(
      children: <Widget>[
        field,
        // Announced, never painted: the field has already put the old value
        // back, so there is nothing to show.
        AstryxVisuallyHidden(liveRegion: true, child: Text(rejected)),
      ],
    );
  }
}
