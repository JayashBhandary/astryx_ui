import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example date_input_demo -> DateInputDemoExample
class DateInputDemoExample extends StatefulWidget {
  const DateInputDemoExample({super.key});

  @override
  State<DateInputDemoExample> createState() => _DateInputDemoExampleState();
}

class _DateInputDemoExampleState extends State<DateInputDemoExample> {
  DateTime? _due;

  @override
  Widget build(BuildContext context) {
    // Typing comes first — `4-8-26` commits and is rewritten as `04/08/2026`.
    // The calendar is the second way in, not the only one.
    return SizedBox(
      width: 260,
      child: AstryxDateInput(
        label: 'Due date',
        description: 'Anything the field cannot read is refused.',
        value: _due,
        showClear: true,
        onChanged: (date) => setState(() => _due = date),
      ),
    );
  }
}
// #end

// #example date_input_bounds -> DateInputBoundsExample
class DateInputBoundsExample extends StatefulWidget {
  const DateInputBoundsExample({super.key});

  @override
  State<DateInputBoundsExample> createState() => _DateInputBoundsExampleState();
}

class _DateInputBoundsExampleState extends State<DateInputBoundsExample> {
  DateTime? _start;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // The bounds apply to typing as well as to the grid: a day the calendar
    // will not let you press is a day the field will not accept.
    return SizedBox(
      width: 260,
      child: AstryxDateInput(
        label: 'Start date',
        value: _start,
        required: true,
        firstDate: today,
        lastDate: DateTime(today.year + 1, today.month, today.day),
        selectableDayPredicate: (day) =>
            day.weekday != DateTime.saturday && day.weekday != DateTime.sunday,
        onChanged: (date) => setState(() => _start = date),
      ),
    );
  }
}
// #end

// #example date_input_formats -> DateInputFormatsExample
class DateInputFormatsExample extends StatefulWidget {
  const DateInputFormatsExample({super.key});

  @override
  State<DateInputFormatsExample> createState() =>
      _DateInputFormatsExampleState();
}

class _DateInputFormatsExampleState extends State<DateInputFormatsExample> {
  DateTime? _iso;
  DateTime? _us;

  @override
  Widget build(BuildContext context) {
    // The placeholder is the pattern, and it is the only thing on screen that
    // says which of the two ambiguous orders a field wants.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 260,
          child: AstryxDateInput(
            label: 'Effective from',
            value: _iso,
            format: AstryxDateFormat.yearMonthDay,
            onChanged: (date) => setState(() => _iso = date),
          ),
        ),
        SizedBox(
          width: 260,
          child: AstryxDateInput(
            label: 'Invoice date',
            value: _us,
            format: AstryxDateFormat.monthDayYear,
            // No grid at all, for a form where dates are transcribed from
            // somewhere else and the calendar is in the way.
            showCalendar: false,
            onChanged: (date) => setState(() => _us = date),
          ),
        ),
      ],
    );
  }
}
// #end
