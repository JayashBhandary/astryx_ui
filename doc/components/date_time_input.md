---
title: AstryxDateTimeInput
description: A date and a time in one field.
component: true
group: Date & time
source: lib/src/components/date_time/date_time_input.dart
upstream: DateTimeInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxDateTimeInput(
  label: 'Publish at',
  value: _publishAt,
  defaultTime: const AstryxTime(hour: 9, minute: 0),
  stepMinutes: 15,
  onChanged: (at) => setState(() => _publishAt = at),
)
```

Two controls in one bordered group, because a date and a time are typed differently and corrected differently — and a single box holding "04/08/2026 14:30" makes fixing the hour an exercise in caret placement.

## A date without a time

**A date on its own is still an answer.** Picking the 4th of August and leaving the time alone commits `defaultTime`, which is midnight unless you say otherwise. A time on its own commits nothing, because there is no instant to report.

> **Note**
>
> That asymmetry is deliberate. "The 4th" is a thing people mean; "half past two, some day" is not.

Each half keeps its own format, and `firstDate` and `lastDate` apply to the date half — an instant is out of range because of its day.

```dart
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
```


### AstryxDateTimeInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | Names the pair. |
| `value` *(required)* | `DateTime?` | — | The committed instant, or null for an empty field. |
| `onChanged` | `ValueChanged<DateTime?>?` | — | Called with a newly committed instant, or null when the date is cleared. |
| `dateLabel` | `String?` | — | The date half’s accessible name. Defaults to "Date". |
| `timeLabel` | `String?` | — | The time half’s accessible name. Defaults to "Time". |
| `dateFormat` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order the parts of the date are written in. |
| `timeFormat` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock the time is written on. |
| `defaultTime` | `AstryxTime` | `AstryxTime.midnight` | The time a date picked on its own is committed at. |
| `stepMinutes` | `int` | `1` | How far an arrow key moves the time. |
| `firstDate` | `DateTime?` | — | The earliest acceptable day. |
| `lastDate` | `DateTime?` | — | The latest acceptable day. |


## Related

- [AstryxDateInput](date_input.md) — when the time of day does not matter.
- [AstryxTimeInput](time_input.md) — when the day does not.

