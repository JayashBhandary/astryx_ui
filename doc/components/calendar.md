---
title: AstryxCalendar
description: A month grid for picking a date, keyboard-navigable.
component: true
group: Date & time
source: lib/src/components/date_time/calendar.dart
upstream: Calendar
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxCalendar(
  selected: _due,
  firstDate: DateTime.now(),
  onChanged: (day) => setState(() => _due = day),
)
```

A bare calendar belongs on a page that is *about* dates — availability, a schedule, a booking wall. For one date inside a form, reach for [AstryxDateInput](date_input.md) instead: it shows the value as text, accepts typing, and keeps the grid behind a button.

**Six rows, always.** A month that needs five still reserves six, because a grid that changes height as the user pages through it moves everything below it — and inside a popover, moves the popover.

## Keyboard

**The grid is one tab stop.** Tab moves onto it and off it again; the arrow keys move within it. Thirty-one tab stops between a user and the next field is not navigation. Roving focus is also separate from selection, so arrowing around picks nothing until `Enter` says so — which is what lets a keyboard user look before they commit.

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the grid, and off it. |
| `←` / `→` | One day back or forward. Mirrored under RTL. |
| `↑` / `↓` | One week back or forward. |
| `Home` / `End` | The first or last day of that week. |
| `Page Up` / `Page Down` | One month back or forward. |
| `Shift` + `Page Up` / `Page Down` | One **year** back or forward — the difference between reaching a birthday and pressing "previous month" ninety times. |
| `Enter` / `Space` | Picks the day focus is on. |

## Ranges

`AstryxCalendar.range` picks two days instead of one. Two presses make a range, and the second may be the *earlier* of the two — someone who has already pressed twice has said which two days they mean, so the range completes backwards rather than starting over.

`onRangeChanged` does not fire for the first press. Half a range is a state the calendar owns, so no caller has to model "start but no end".

```dart
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
```


## Bounds

| Property | Does |
| --- | --- |
| `firstDate` / `lastDate` | The range of acceptable days. Outside it, a day is **dimmed rather than hidden** — the grid keeps its shape, and a user can see why a date is out of reach. |
| `selectableDayPredicate` | Rules out individual days inside the bounds — weekends, a holiday, a day already booked. Called for every cell a month shows, so keep it cheap. |

```dart
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
```


> **Accessibility**
>
> Every cell announces its full date — "Tuesday, 4 August 2026" — because a grid of bare numbers is unusable through a screen reader. Today is **named as well as ringed**, and the ends of a range say which end they are: colour is never the only signal.

> **Note**
>
> Pass `today` to fix what the calendar treats as the current day. That is what makes a widget test — and a screenshot — reproducible.

### AstryxCalendar

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `selected` | `DateTime?` | — | The chosen day. Only its date is read. |
| `onChanged` | `ValueChanged<DateTime>?` | — | Called with the chosen day, at midnight. Null makes the grid a read-only display. |
| `range` | `AstryxDateRange?` | — | The chosen span. `AstryxCalendar.range` only. |
| `onRangeChanged` | `ValueChanged<AstryxDateRange>?` | — | Called once both ends have been pressed. `AstryxCalendar.range` only. |
| `month` | `DateTime?` | — | The month on show. Null lets the calendar page itself. |
| `onMonthChanged` | `ValueChanged<DateTime>?` | — | Called with the first day of the month now on show. |
| `firstDate` | `DateTime?` | — | The earliest selectable day. |
| `lastDate` | `DateTime?` | — | The latest selectable day. |
| `selectableDayPredicate` | `AstryxDayPredicate?` | — | Rules out individual days inside the bounds. |
| `firstDayOfWeek` | `AstryxWeekday` | `AstryxWeekday.monday` | Which day the week starts on. |
| `label` | `String?` | — | An accessible name for the grid. |
| `enabled` | `bool` | `true` | Whether the grid accepts presses. |
| `today` | `DateTime?` | — | What counts as today. Defaults to the system clock. |
| `focusNode` | `FocusNode?` | — | The grid’s focus node. |
| `autofocus` | `bool` | `false` | Whether the grid takes focus when first built. |


### AstryxDateRange

A span of days, inclusive at both ends. Both ends are normalised to midnight, so a range picked at teatime equals the same range picked at breakfast. `DateTimeRange` lives in `package:flutter/material`, which this package is built to do without.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `start` *(required)* | `DateTime` | — | The first day, at midnight. |
| `end` *(required)* | `DateTime` | — | The last day, at midnight. Inclusive. |
| `days` | `int` | — | How many days the span covers, both ends counted. |
| `isSingleDay` | `bool` | — | Whether it covers exactly one day. |
| `contains(day)` | `bool` | — | Whether `day` falls inside it. |


## Related

- [AstryxDateInput](date_input.md) — one date in a form.
- [AstryxDateRangeInput](date_range_input.md) — a span in a form.

---

Something wrong with `AstryxCalendar`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCalendar&component=AstryxCalendar) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCalendar&area=AstryxCalendar) — both templates arrive with the component filled in.
