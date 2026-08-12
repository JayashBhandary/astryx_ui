import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example date_time_input_demo -> DateTimeInputDemoExample
class DateTimeInputDemoExample extends StatefulWidget {
  const DateTimeInputDemoExample({super.key});

  @override
  State<DateTimeInputDemoExample> createState() =>
      _DateTimeInputDemoExampleState();
}

class _DateTimeInputDemoExampleState extends State<DateTimeInputDemoExample> {
  DateTime? _publishAt;

  @override
  Widget build(BuildContext context) {
    // A date on its own is still an answer: picking a day with the time left
    // alone commits `defaultTime` — 09:00 here. A time on its own commits
    // nothing, because there is no instant to report.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 340,
          child: AstryxDateTimeInput(
            label: 'Publish at',
            value: _publishAt,
            defaultTime: const AstryxTime(hour: 9, minute: 0),
            stepMinutes: 15,
            onChanged: (at) => setState(() => _publishAt = at),
          ),
        ),
        AstryxText(
          _publishAt == null ? 'Not scheduled' : _publishAt!.toIso8601String(),
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example date_time_input_clock -> DateTimeInputClockExample
class DateTimeInputClockExample extends StatefulWidget {
  const DateTimeInputClockExample({super.key});

  @override
  State<DateTimeInputClockExample> createState() =>
      _DateTimeInputClockExampleState();
}

class _DateTimeInputClockExampleState extends State<DateTimeInputClockExample> {
  DateTime? _startsAt;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Each half keeps its own format, and the bounds apply to the date half
    // only — an instant is out of range because of its day.
    return SizedBox(
      width: 360,
      child: AstryxDateTimeInput(
        label: 'Maintenance window',
        value: _startsAt,
        dateFormat: AstryxDateFormat.yearMonthDay,
        timeFormat: AstryxTimeFormat.h12,
        firstDate: today,
        lastDate: DateTime(today.year, today.month, today.day + 30),
        stepMinutes: 30,
        onChanged: (at) => setState(() => _startsAt = at),
      ),
    );
  }
}
// #end
