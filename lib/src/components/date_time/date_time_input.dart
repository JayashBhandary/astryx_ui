/// A date and a time in one field.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/date_time/calendar.dart';
import 'package:astryx_ui/src/components/date_time/date_input.dart';
import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/date_time/time_input.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/input_group.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// One instant, as a date beside a time.
///
/// Two controls in one bordered group, because a date and a time are typed
/// differently and corrected differently — and a single box holding
/// "04/08/2026 14:30" makes fixing the hour an exercise in caret placement.
///
/// **A date with no time is still an answer.** Picking the 4th of August and
/// leaving the time alone commits midnight, or whatever [defaultTime] says; a
/// time with no date commits nothing, because there is no instant to report.
/// That asymmetry is deliberate — "the 4th" is a thing people mean, "half past
/// two, some day" is not.
///
/// {@tool snippet}
/// ```dart
/// AstryxDateTimeInput(
///   label: 'Publish at',
///   value: _publishAt,
///   stepMinutes: 15,
///   onChanged: (at) => setState(() => _publishAt = at),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxDateInput`, when the time of day does not matter.
///  * `AstryxTimeInput`, when the day does not.
class AstryxDateTimeInput extends StatefulWidget {
  /// Creates a date-and-time field.
  const AstryxDateTimeInput({
    required this.label,
    required this.value,
    super.key,
    this.onChanged,
    this.description,
    this.status,
    this.dateLabel,
    this.timeLabel,
    this.dateFormat = AstryxDateFormat.dayMonthYear,
    this.timeFormat = AstryxTimeFormat.h24,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.firstDayOfWeek = AstryxWeekday.monday,
    this.defaultTime = AstryxTime.midnight,
    this.stepMinutes = 1,
    this.showCalendar = true,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.today,
  });

  /// {@macro AstryxField.label}
  ///
  /// Names the pair. The halves take their own names from [dateLabel] and
  /// [timeLabel], which are announced but not shown.
  final String label;

  /// The committed instant, or null for an empty field.
  final DateTime? value;

  /// Called with a newly committed instant, or null when the date is cleared.
  final ValueChanged<DateTime?>? onChanged;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The accessible name of the date half. Defaults to "Date".
  final String? dateLabel;

  /// The accessible name of the time half. Defaults to "Time".
  final String? timeLabel;

  /// The order the parts of the date are written and read in.
  final AstryxDateFormat dateFormat;

  /// Whether the time is written on a twelve- or twenty-four-hour clock.
  final AstryxTimeFormat timeFormat;

  /// The earliest acceptable day. Null for no floor.
  final DateTime? firstDate;

  /// The latest acceptable day. Null for no ceiling.
  final DateTime? lastDate;

  /// Rules out individual days.
  final AstryxDayPredicate? selectableDayPredicate;

  /// Which day the calendar's week starts on.
  final AstryxWeekday firstDayOfWeek;

  /// The time a date picked on its own is committed at. Midnight by default.
  final AstryxTime defaultTime;

  /// How far an arrow key moves the time, in minutes.
  final int stepMinutes;

  /// Whether to offer the calendar button.
  final bool showCalendar;

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

  /// What the calendar treats as today. Defaults to the system clock.
  final DateTime? today;

  @override
  State<AstryxDateTimeInput> createState() => _AstryxDateTimeInputState();
}

class _AstryxDateTimeInputState extends State<AstryxDateTimeInput> {
  final AstryxOverlayController _overlay = AstryxOverlayController();

  DateTime? _date;
  AstryxTime? _time;

  @override
  void initState() {
    super.initState();
    _adopt(widget.value);
  }

  @override
  void didUpdateWidget(AstryxDateTimeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _adopt(widget.value);
  }

  @override
  void dispose() {
    _overlay.dispose();
    super.dispose();
  }

  void _adopt(DateTime? value) {
    _date = value == null ? null : astryxStartOfDay(value);
    _time = value == null ? null : AstryxTime.fromDateTime(value);
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

  void _setDate(DateTime? day) {
    setState(() => _date = day);
    _report();
  }

  void _setTime(AstryxTime? time) {
    setState(() => _time = time);
    _report();
  }

  void _report() {
    final onChanged = widget.onChanged;
    if (onChanged == null) return;

    final date = _date;
    if (date == null) {
      if (widget.value != null) onChanged(null);
      return;
    }

    final combined = (_time ?? widget.defaultTime).onDate(date);
    if (combined != widget.value) onChanged(combined);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    if (!widget.showCalendar) return _buildGroup(context, l10n, null);

    return AstryxPopover(
      controller: _overlay,
      label: widget.label,
      align: AstryxOverlayAlign.start,
      content: AstryxCalendar(
        selected: _date,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        selectableDayPredicate: widget.selectableDayPredicate,
        firstDayOfWeek: widget.firstDayOfWeek,
        today: widget.today,
        enabled: _interactive,
        autofocus: true,
        onChanged: (day) {
          _setDate(day);
          _overlay.hide();
        },
      ),
      triggerBuilder: (context, controller) =>
          _buildGroup(context, l10n, controller),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    AstryxLocalizations l10n,
    AstryxOverlayController? controller,
  ) => AstryxInputGroup(
    label: widget.label,
    description: widget.description,
    status: widget.status,
    size: widget.size,
    enabled: widget.enabled,
    required: widget.required,
    optional: widget.optional,
    labelHidden: widget.labelHidden,
    width: widget.width,
    children: <Widget>[
      Expanded(
        child: AstryxDateTextField(
          value: _date,
          format: widget.dateFormat,
          accepts: _accepts,
          label: widget.dateLabel ?? l10n.dateTimeInputDateLabel,
          labelHidden: true,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: _interactive ? _setDate : null,
          trailing: controller == null
              ? null
              : AstryxIconButton(
                  icon: AstryxIconName.calendar,
                  label: l10n.dateInputOpenCalendar(widget.label),
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  enabled: _interactive,
                  onPressed: controller.toggle,
                ),
        ),
      ),
      Expanded(
        child: AstryxTimeInput(
          value: _time,
          format: widget.timeFormat,
          stepMinutes: widget.stepMinutes,
          label: widget.timeLabel ?? l10n.dateTimeInputTimeLabel,
          labelHidden: true,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: _interactive ? _setTime : null,
        ),
      ),
    ],
  );
}
