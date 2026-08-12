import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example calendar_demo -> CalendarDemoExample
class CalendarDemoExample extends StatefulWidget {
  const CalendarDemoExample({super.key});

  @override
  State<CalendarDemoExample> createState() => _CalendarDemoExampleState();
}

class _CalendarDemoExampleState extends State<CalendarDemoExample> {
  DateTime? _day;

  @override
  Widget build(BuildContext context) {
    // The grid is one tab stop: Tab lands on it, the arrow keys move within it,
    // and Enter picks. Nothing is selected until Enter or a press says so.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxCalendar(
          selected: _day,
          onChanged: (day) => setState(() => _day = day),
        ),
        AstryxText(
          _day == null ? 'Nothing picked' : 'Picked ${_day!.day}/${_day!.month}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example calendar_range -> CalendarRangeExample
class CalendarRangeExample extends StatefulWidget {
  const CalendarRangeExample({super.key});

  @override
  State<CalendarRangeExample> createState() => _CalendarRangeExampleState();
}

class _CalendarRangeExampleState extends State<CalendarRangeExample> {
  AstryxDateRange? _range;

  @override
  Widget build(BuildContext context) {
    // Two presses make a range, and the second may be the earlier of the two —
    // a user who has pressed twice has said which days they mean.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxCalendar.range(
          range: _range,
          onRangeChanged: (range) => setState(() => _range = range),
        ),
        AstryxText(
          _range == null ? 'No span yet' : '${_range!.days} days',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example calendar_bounds -> CalendarBoundsExample
class CalendarBoundsExample extends StatefulWidget {
  const CalendarBoundsExample({super.key});

  @override
  State<CalendarBoundsExample> createState() => _CalendarBoundsExampleState();
}

class _CalendarBoundsExampleState extends State<CalendarBoundsExample> {
  DateTime? _day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Days outside the bounds, and weekends inside them, are dimmed rather than
    // hidden: the grid keeps its shape, and a user can see why a date is out of
    // reach instead of wondering where it went.
    return AstryxCalendar(
      selected: _day,
      firstDate: today,
      lastDate: DateTime(today.year, today.month + 2, today.day),
      selectableDayPredicate: (day) =>
          day.weekday != DateTime.saturday && day.weekday != DateTime.sunday,
      onChanged: (day) => setState(() => _day = day),
    );
  }
}
// #end
