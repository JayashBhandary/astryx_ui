---
title: AstryxDateInput
description: A text field that parses and formats a single date.
component: true
group: Date & time
source: lib/src/components/date_time/date_input.dart
upstream: DateInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxDateInput(
  label: 'Due date',
  value: _due,
  firstDate: DateTime.now(),
  onChanged: (date) => setState(() => _due = date),
)
```

**Typing comes first.** A date picker that can only be clicked is slower than a keyboard for anybody who already knows the date they want, so this is a text field with a calendar attached rather than a button that opens one. `showCalendar: false` drops the grid entirely, for a form where dates are transcribed from somewhere else.

## Parsing

Deliberately forgiving about shape and strict about meaning. Any run of non-digits separates the parts, and a two-digit year is read as this century — so `4-8-26`, `04/08/2026` and `4 8 2026` all land on the same day. What is committed is then **written back in the field’s own format**, so the user can see what was understood.

> **Careful**
>
> A date that cannot be read is **refused, not guessed**. `31/02/2026` reverts to the committed value rather than quietly becoming the 3rd of March; so does a real date outside `firstDate` and `lastDate`. Silently moving a date somebody typed is the worse failure — `AstryxNumberInput` takes the same line, for the same reason.

## Formats

The placeholder is the pattern — `DD/MM/YYYY` — because it is the only thing on screen that says which of the two ambiguous orders a field wants. The order is the field’s own decision rather than the locale’s: the place a form is used is not always the place its data came from.

| `AstryxDateFormat` | Writes | For |
| --- | --- | --- |
| `dayMonthYear` | `04/08/2026` | Most of the world. |
| `monthDayYear` | `08/04/2026` | The United States. |
| `yearMonthDay` | `2026-08-04` | ISO-8601. Sorts as text, and is never ambiguous. |

```dart
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
```


## Bounds

| Property | Does |
| --- | --- |
| `firstDate` / `lastDate` | The range of acceptable days. Outside it, a day is **dimmed rather than hidden** — the grid keeps its shape, and a user can see why a date is out of reach. |
| `selectableDayPredicate` | Rules out individual days inside the bounds — weekends, a holiday, a day already booked. Called for every cell a month shows, so keep it cheap. |

Both apply to typing as well as to the grid: a day the calendar will not let you press is a day the field will not accept.

```dart
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
```


> **Accessibility**
>
> A rejection is **announced**, not just undone — the field has already put the old value back, so a screen-reader user would otherwise have no idea their entry was thrown away (WCAG 3.3.1). The calendar button carries a name of its own, and the panel traps focus and returns it to the trigger when it closes.

### AstryxDateInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `DateTime?` | — | The committed date, or null for an empty field. |
| `onChanged` | `ValueChanged<DateTime?>?` | — | Called with a newly committed date, or null when the field is cleared. Fires on a calendar press and on blur or Enter — never per keystroke, because half a date is not a date. |
| `label` | `String?` | — | The field’s label and accessible name. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `placeholder` | `String?` | — | Shown when empty. Defaults to the format’s pattern. |
| `format` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order the parts are written and read in. |
| `firstDate` | `DateTime?` | — | The earliest acceptable date. |
| `lastDate` | `DateTime?` | — | The latest acceptable date. |
| `selectableDayPredicate` | `AstryxDayPredicate?` | — | Rules out individual days. |
| `showCalendar` | `bool` | `true` | Whether to offer the calendar button. |
| `showClear` | `bool` | `false` | Whether to show a button that empties the field. |
| `size` | `AstryxInputSize?` | — | The control height. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. Not the same as `enabled: false`, which dims it. |
| `today` | `DateTime?` | — | What the calendar treats as today. Defaults to the system clock. |


## Related

- [AstryxCalendar](calendar.md) — the grid this opens.
- [AstryxDateRangeInput](date_range_input.md) — two dates as one field.
- [AstryxDateTimeInput](date_time_input.md) — a date and a time.

---

Something wrong with `AstryxDateInput`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxDateInput&component=AstryxDateInput) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxDateInput&area=AstryxDateInput) — both templates arrive with the component filled in.
