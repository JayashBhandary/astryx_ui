---
title: AstryxTimeInput
description: A text field for a time of day.
component: true
group: Date & time
source: lib/src/components/date_time/time_input.dart
upstream: TimeInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TimeInputDemoExample extends StatefulWidget {
  const TimeInputDemoExample({super.key});

  @override
  State<TimeInputDemoExample> createState() => _TimeInputDemoExampleState();
}

class _TimeInputDemoExampleState extends State<TimeInputDemoExample> {
  AstryxTime? _at = const AstryxTime(hour: 9, minute: 30);

  @override
  Widget build(BuildContext context) {
    // `0930`, `9:30`, `9.30` and `9:30 am` all commit half past nine. The arrow
    // keys move the value; both clocks are accepted whichever one is shown.
    return SizedBox(
      width: 220,
      child: AstryxTimeInput(
        label: 'Starts at',
        description: 'Arrow keys step by 15 minutes.',
        value: _at,
        stepMinutes: 15,
        onChanged: (time) => setState(() => _at = time),
      ),
    );
  }
}
```


## Usage

```dart
AstryxTimeInput(
  label: 'Starts at',
  value: _start,
  stepMinutes: 15,
  onChanged: (time) => setState(() => _start = time),
)
```

## Parsing

A text field, not a wheel. Every one of these commits half past nine, and **both clocks are accepted whichever one is shown** — somebody who types "2pm" into a 24-hour field means 14:00, and refusing that would be pedantry.

| Typed | Committed |
| --- | --- |
| `9` | 09:00 |
| `930`, `0930`, `9:30`, `9.30` | 09:30 |
| `2:30 pm`, `2:30pm` | 14:30 |
| `12am` / `12pm` | 00:00 / 12:00 |
| `25:00`, `9:60`, `13:00 pm` | refused |

What is committed is written back on the field’s own clock, so a value typed as "2pm" is shown as `14:30` and the user can see what was understood. An unreadable time reverts and is announced — the same contract as [AstryxDateInput](date_input.md).

## Stepping

The arrow keys move the value by `stepMinutes`. One by default; set it to 15 or 30 for a field that books something, where every intermediate minute is a value nobody wants to arrow past. A step that would leave `earliest`–`latest` is **refused rather than wrapped**, so a field with a floor of 09:00 stops there instead of jumping to 23:45.

```dart
class TimeInputBoundsExample extends StatefulWidget {
  const TimeInputBoundsExample({super.key});

  @override
  State<TimeInputBoundsExample> createState() => _TimeInputBoundsExampleState();
}

class _TimeInputBoundsExampleState extends State<TimeInputBoundsExample> {
  AstryxTime? _open = const AstryxTime(hour: 9, minute: 0);
  AstryxTime? _close = const AstryxTime(hour: 17, minute: 30);

  @override
  Widget build(BuildContext context) {
    // On a twelve-hour clock, and bounded: a step that would leave the window
    // is refused rather than wrapped round midnight.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        SizedBox(
          width: 180,
          child: AstryxTimeInput(
            label: 'Opens',
            value: _open,
            format: AstryxTimeFormat.h12,
            earliest: const AstryxTime(hour: 6, minute: 0),
            latest: AstryxTime.noon,
            stepMinutes: 30,
            onChanged: (time) => setState(() => _open = time),
          ),
        ),
        SizedBox(
          width: 180,
          child: AstryxTimeInput(
            label: 'Closes',
            value: _close,
            format: AstryxTimeFormat.h12,
            earliest: AstryxTime.noon,
            latest: const AstryxTime(hour: 23, minute: 30),
            stepMinutes: 30,
            onChanged: (time) => setState(() => _close = time),
          ),
        ),
      ],
    );
  }
}
```


### AstryxTimeInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `AstryxTime?` | — | The committed time, or null for an empty field. |
| `onChanged` | `ValueChanged<AstryxTime?>?` | — | Called with a newly committed time, or null when the field is cleared. |
| `label` | `String?` | — | The field’s label and accessible name. |
| `format` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock the value is **written** on. Both are always accepted on the way in. |
| `earliest` | `AstryxTime?` | — | The earliest acceptable time. |
| `latest` | `AstryxTime?` | — | The latest acceptable time. |
| `stepMinutes` | `int` | `1` | How far an arrow key moves the value. |
| `showIcon` | `bool` | `true` | Whether to show the clock glyph before the text. |
| `showClear` | `bool` | `false` | Whether to show a button that empties the field. |


### AstryxTime

An hour and a minute with no day attached — a shift start, an office closing time. `TimeOfDay` lives in `package:flutter/material`, which this package is built to do without.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `hour` *(required)* | `int` | — | The hour on a 24-hour clock, 0–23. |
| `minute` *(required)* | `int` | — | The minute, 0–59. |
| `minutesSinceMidnight` | `int` | — | How far into the day this is. |
| `hour12` | `int` | — | The hour on a 12-hour clock, 1–12. |
| `isBeforeNoon` | `bool` | — | Whether this is the `am` half. |
| `plusMinutes(n)` | `AstryxTime` | — | This time moved by `n`, wrapping at midnight either way. |
| `onDate(date)` | `DateTime` | — | This time on `date`, as an instant. |


## Related

- [AstryxDateTimeInput](date_time_input.md) — a day and a time together.
- [AstryxNumberInput](number_input.md) — the field this borrows its reject-rather-than-clamp contract from.

