/// Two dates as one field.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/date_time/calendar.dart';
import 'package:astryx_ui/src/components/date_time/date_input.dart';
import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/input_group.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// A span of days as one control: two date fields and one calendar.
///
/// Two fields rather than one, because a single box holding "04/08/2026 –
/// 11/08/2026" is a box nobody can edit half of. They are joined into one
/// bordered control by `AstryxInputGroup`, share one label, and share one
/// validation message — which is the point: **the error belongs to the range,
/// not to either date.** An end before its start is not a bad date, it is a bad
/// pair, and reporting it on one of the two fields blames the wrong one.
///
/// Nothing is reported until both ends are readable and in order. A half-filled
/// range is a state this widget owns, so a caller never has to model
/// "start but no end".
///
/// {@tool snippet}
/// ```dart
/// AstryxDateRangeInput(
///   label: 'Reporting period',
///   value: _period,
///   onChanged: (range) => setState(() => _period = range),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxDateInput`, for one date.
///  * [AstryxCalendar.range], the grid this opens.
class AstryxDateRangeInput extends StatefulWidget {
  /// Creates a range field.
  const AstryxDateRangeInput({
    required this.label,
    required this.value,
    super.key,
    this.onChanged,
    this.description,
    this.status,
    this.startLabel,
    this.endLabel,
    this.format = AstryxDateFormat.dayMonthYear,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.firstDayOfWeek = AstryxWeekday.monday,
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
  /// Names the pair. The two halves take their own names from [startLabel] and
  /// [endLabel], which are announced but not shown.
  final String label;

  /// The committed span, or null while it is incomplete.
  final AstryxDateRange? value;

  /// Called once both ends are readable and in order, or with null when either
  /// is cleared.
  final ValueChanged<AstryxDateRange?>? onChanged;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  ///
  /// A status set here wins over the widget's own "end before start" message,
  /// so a caller's server-side error is not replaced by a local one.
  final AstryxFieldStatus? status;

  /// The accessible name of the first field. Defaults to "Start date".
  final String? startLabel;

  /// The accessible name of the second field. Defaults to "End date".
  final String? endLabel;

  /// The order the parts of each date are written and read in.
  final AstryxDateFormat format;

  /// The earliest acceptable day. Null for no floor.
  final DateTime? firstDate;

  /// The latest acceptable day. Null for no ceiling.
  final DateTime? lastDate;

  /// Rules out individual days at either end.
  final AstryxDayPredicate? selectableDayPredicate;

  /// Which day the calendar's week starts on.
  final AstryxWeekday firstDayOfWeek;

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
  State<AstryxDateRangeInput> createState() => _AstryxDateRangeInputState();
}

class _AstryxDateRangeInputState extends State<AstryxDateRangeInput> {
  final AstryxOverlayController _overlay = AstryxOverlayController();

  /// The two ends as the user has them, which is not always a range.
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.value?.start;
    _end = widget.value?.end;
  }

  @override
  void didUpdateWidget(AstryxDateRangeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _start = widget.value?.start;
      _end = widget.value?.end;
    }
  }

  @override
  void dispose() {
    _overlay.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  /// Whether the two ends are in the wrong order.
  bool get _reversed =>
      _start != null && _end != null && _end!.isBefore(_start!);

  bool _accepts(DateTime day) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    final at = astryxStartOfDay(day);
    if (first != null && at.isBefore(astryxStartOfDay(first))) return false;
    if (last != null && at.isAfter(astryxStartOfDay(last))) return false;
    return widget.selectableDayPredicate?.call(at) ?? true;
  }

  void _setStart(DateTime? day) {
    setState(() => _start = day);
    _report();
  }

  void _setEnd(DateTime? day) {
    setState(() => _end = day);
    _report();
  }

  void _apply(AstryxDateRange range) {
    setState(() {
      _start = range.start;
      _end = range.end;
    });
    _report();
  }

  /// Reports the pair, but only when it is a range.
  void _report() {
    final onChanged = widget.onChanged;
    if (onChanged == null) return;

    final start = _start;
    final end = _end;
    if (start == null || end == null) {
      if (widget.value != null) onChanged(null);
      return;
    }
    // Reversed is reported as *no* range, and the message below says why. The
    // alternative — silently swapping the ends — changes the answer to a
    // question the user has not finished asking.
    if (end.isBefore(start)) {
      if (widget.value != null) onChanged(null);
      return;
    }

    final range = AstryxDateRange(start: start, end: end);
    if (range != widget.value) onChanged(range);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    final status =
        widget.status ??
        (_reversed ? AstryxFieldStatus.error(l10n.dateRangeInvalid) : null);

    if (!widget.showCalendar) {
      return _buildGroup(context, l10n, status, null);
    }

    return AstryxPopover(
      controller: _overlay,
      label: widget.label,
      align: AstryxOverlayAlign.start,
      content: AstryxCalendar.range(
        range: _start != null && _end != null && !_reversed
            ? AstryxDateRange(start: _start!, end: _end!)
            : null,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        selectableDayPredicate: widget.selectableDayPredicate,
        firstDayOfWeek: widget.firstDayOfWeek,
        today: widget.today,
        enabled: _interactive,
        autofocus: true,
        onRangeChanged: (range) {
          _apply(range);
          _overlay.hide();
        },
      ),
      triggerBuilder: (context, controller) =>
          _buildGroup(context, l10n, status, controller),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    AstryxLocalizations l10n,
    AstryxFieldStatus? status,
    AstryxOverlayController? controller,
  ) => AstryxInputGroup(
    label: widget.label,
    description: widget.description,
    status: status,
    size: widget.size,
    enabled: widget.enabled,
    required: widget.required,
    optional: widget.optional,
    labelHidden: widget.labelHidden,
    width: widget.width,
    children: <Widget>[
      Expanded(
        child: AstryxDateTextField(
          value: _start,
          format: widget.format,
          accepts: _accepts,
          label: widget.startLabel ?? l10n.dateRangeStartLabel,
          labelHidden: true,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: _interactive ? _setStart : null,
        ),
      ),
      // A dash, not the word "to": the affix is decorative and excluded from
      // semantics, and the two fields already announce which end they are.
      const AstryxInputGroupText('–'),
      Expanded(
        child: AstryxDateTextField(
          value: _end,
          format: widget.format,
          accepts: _accepts,
          label: widget.endLabel ?? l10n.dateRangeEndLabel,
          labelHidden: true,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: _interactive ? _setEnd : null,
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
    ],
  );
}
