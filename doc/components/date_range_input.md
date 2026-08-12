---
title: AstryxDateRangeInput
description: Two dates as one field, with the range validated across them.
component: true
group: Date & time
source: lib/src/components/date_time/date_range_input.dart
upstream: DateRangeInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DateRangeInputDemoExample extends StatefulWidget {
  const DateRangeInputDemoExample({super.key});

  @override
  State<DateRangeInputDemoExample> createState() =>
      _DateRangeInputDemoExampleState();
}

class _DateRangeInputDemoExampleState extends State<DateRangeInputDemoExample> {
  AstryxDateRange? _period;

  @override
  Widget build(BuildContext context) {
    // Two fields, one border, one label. Nothing is reported until both ends
    // are readable and in order — try an end date before the start.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 340,
          child: AstryxDateRangeInput(
            label: 'Reporting period',
            value: _period,
            onChanged: (range) => setState(() => _period = range),
          ),
        ),
        AstryxText(
          _period == null
              ? 'No period yet'
              : '${_period!.days} days selected',
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
AstryxDateRangeInput(
  label: 'Reporting period',
  value: _period,
  onChanged: (range) => setState(() => _period = range),
)
```

## Composition

```text
AstryxDateRangeInput
├── label            ← names the pair
├── start field      ← "Start date", announced, not shown
├── –                ← an affix, excluded from semantics
├── end field        ← "End date", and the calendar button
└── status           ← belongs to the range, not to either date
```

Two fields rather than one, because a single box holding "04/08/2026 – 11/08/2026" is a box nobody can edit half of. They are joined into one bordered control by [AstryxInputGroup](input_group.md), share one label, and share one validation message.

## Validation across the pair

**The error belongs to the range, not to either date.** An end before its start is not a bad date, it is a bad pair, and reporting it on one of the two fields blames the wrong one. So the message sits under the whole group, and `onChanged` reports null until the pair is in order.

> **Careful**
>
> Reversed ends are **not** silently swapped. Swapping changes the answer to a question the user has not finished asking — they may be halfway through moving both ends.

Nothing is reported until both ends are readable and in order, so a caller never has to model "start but no end". A status passed in wins over the widget’s own message, so a server-side error is not replaced by a local one.

```dart
class DateRangeInputBoundsExample extends StatefulWidget {
  const DateRangeInputBoundsExample({super.key});

  @override
  State<DateRangeInputBoundsExample> createState() =>
      _DateRangeInputBoundsExampleState();
}

class _DateRangeInputBoundsExampleState
    extends State<DateRangeInputBoundsExample> {
  AstryxDateRange? _period;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // The bounds and the label overrides apply to both halves. The two names
    // are announced rather than shown: the visible label names the pair.
    return SizedBox(
      width: 340,
      child: AstryxDateRangeInput(
        label: 'Booking',
        description: 'Up to ninety days out.',
        value: _period,
        startLabel: 'Arrival',
        endLabel: 'Departure',
        firstDate: today,
        lastDate: DateTime(today.year, today.month, today.day + 90),
        onChanged: (range) => setState(() => _period = range),
      ),
    );
  }
}
```


> **Accessibility**
>
> Each half keeps its own accessible name — "Start date" and "End date", or whatever `startLabel` and `endLabel` say — because a reader landing in the second field needs to know which end it is. The dash between them is decorative and announced as nothing.

### AstryxDateRangeInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | Names the pair. |
| `value` *(required)* | `AstryxDateRange?` | — | The committed span, or null while it is incomplete. |
| `onChanged` | `ValueChanged<AstryxDateRange?>?` | — | Called once both ends are readable and in order, or with null when either is cleared. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | Wins over the widget’s own "end before start" message. |
| `startLabel` | `String?` | — | The first field’s accessible name. Defaults to "Start date". |
| `endLabel` | `String?` | — | The second field’s accessible name. Defaults to "End date". |
| `format` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order each date is written and read in. |
| `firstDate` | `DateTime?` | — | The earliest acceptable day. |
| `lastDate` | `DateTime?` | — | The latest acceptable day. |
| `selectableDayPredicate` | `AstryxDayPredicate?` | — | Rules out individual days at either end. |
| `showCalendar` | `bool` | `true` | Whether to offer the calendar button. |


## Related

- [AstryxCalendar](calendar.md) — `AstryxCalendar.range` is the grid this opens.
- [AstryxDateInput](date_input.md) — one date, and where the parsing rules are documented.

