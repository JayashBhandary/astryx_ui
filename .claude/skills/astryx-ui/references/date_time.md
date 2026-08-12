# Date & time

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxCalendar

`lib/src/components/date_time/calendar.dart` · upstream `Calendar`

A month grid for picking a date, keyboard-navigable.

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

**Rules**

- **Accessibility:** Every cell announces its full date — "Tuesday, 4 August 2026" — because a grid of bare numbers is unusable through a screen reader. Today is **named as well as ringed**, and the ends of a range say which end they are: colour is never the only signal.
- **Note:** Pass `today` to fix what the calendar treats as the current day. That is what makes a widget test — and a screenshot — reproducible.

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the grid, and off it. |
| `←` / `→` | One day back or forward. Mirrored under RTL. |
| `↑` / `↓` | One week back or forward. |
| `Home` / `End` | The first or last day of that week. |
| `Page Up` / `Page Down` | One month back or forward. |
| `Shift` + `Page Up` / `Page Down` | One **year** back or forward — the difference between reaching a birthday and pressing "previous month" ninety times. |
| `Enter` / `Space` | Picks the day focus is on. |

| Property | Does |
| --- | --- |
| `firstDate` / `lastDate` | The range of acceptable days. Outside it, a day is **dimmed rather than hidden** — the grid keeps its shape, and a user can see why a date is out of reach. |
| `selectableDayPredicate` | Rules out individual days inside the bounds — weekends, a holiday, a day already booked. Called for every cell a month shows, so keep it cheap. |

### AstryxCalendar

| Property | Type | Default | Notes |
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

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `start` **(required)** | `DateTime` | — | The first day, at midnight. |
| `end` **(required)** | `DateTime` | — | The last day, at midnight. Inclusive. |
| `days` | `int` | — | How many days the span covers, both ends counted. |
| `isSingleDay` | `bool` | — | Whether it covers exactly one day. |
| `contains(day)` | `bool` | — | Whether `day` falls inside it. |

---

## AstryxDateInput

`lib/src/components/date_time/date_input.dart` · upstream `DateInput`

A text field that parses and formats a single date.

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

**Rules**

- **Careful:** A date that cannot be read is **refused, not guessed**. `31/02/2026` reverts to the committed value rather than quietly becoming the 3rd of March; so does a real date outside `firstDate` and `lastDate`. Silently moving a date somebody typed is the worse failure — `AstryxNumberInput` takes the same line, for the same reason.
- **Accessibility:** A rejection is **announced**, not just undone — the field has already put the old value back, so a screen-reader user would otherwise have no idea their entry was thrown away (WCAG 3.3.1). The calendar button carries a name of its own, and the panel traps focus and returns it to the trigger when it closes.

| `AstryxDateFormat` | Writes | For |
| --- | --- | --- |
| `dayMonthYear` | `04/08/2026` | Most of the world. |
| `monthDayYear` | `08/04/2026` | The United States. |
| `yearMonthDay` | `2026-08-04` | ISO-8601. Sorts as text, and is never ambiguous. |

| Property | Does |
| --- | --- |
| `firstDate` / `lastDate` | The range of acceptable days. Outside it, a day is **dimmed rather than hidden** — the grid keeps its shape, and a user can see why a date is out of reach. |
| `selectableDayPredicate` | Rules out individual days inside the bounds — weekends, a holiday, a day already booked. Called for every cell a month shows, so keep it cheap. |

### AstryxDateInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `DateTime?` | — | The committed date, or null for an empty field. |
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

---

## AstryxDateRangeInput

`lib/src/components/date_time/date_range_input.dart` · upstream `DateRangeInput`

Two dates as one field, with the range validated across them.

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

**Rules**

- **Careful:** Reversed ends are **not** silently swapped. Swapping changes the answer to a question the user has not finished asking — they may be halfway through moving both ends.
- **Accessibility:** Each half keeps its own accessible name — "Start date" and "End date", or whatever `startLabel` and `endLabel` say — because a reader landing in the second field needs to know which end it is. The dash between them is decorative and announced as nothing.

### AstryxDateRangeInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | Names the pair. |
| `value` **(required)** | `AstryxDateRange?` | — | The committed span, or null while it is incomplete. |
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

---

## AstryxDateTimeInput

`lib/src/components/date_time/date_time_input.dart` · upstream `DateTimeInput`

A date and a time in one field.

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

**Rules**

- **Note:** That asymmetry is deliberate. "The 4th" is a thing people mean; "half past two, some day" is not.

### AstryxDateTimeInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | Names the pair. |
| `value` **(required)** | `DateTime?` | — | The committed instant, or null for an empty field. |
| `onChanged` | `ValueChanged<DateTime?>?` | — | Called with a newly committed instant, or null when the date is cleared. |
| `dateLabel` | `String?` | — | The date half’s accessible name. Defaults to "Date". |
| `timeLabel` | `String?` | — | The time half’s accessible name. Defaults to "Time". |
| `dateFormat` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order the parts of the date are written in. |
| `timeFormat` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock the time is written on. |
| `defaultTime` | `AstryxTime` | `AstryxTime.midnight` | The time a date picked on its own is committed at. |
| `stepMinutes` | `int` | `1` | How far an arrow key moves the time. |
| `firstDate` | `DateTime?` | — | The earliest acceptable day. |
| `lastDate` | `DateTime?` | — | The latest acceptable day. |

---

## AstryxTimeInput

`lib/src/components/date_time/time_input.dart` · upstream `TimeInput`

A text field for a time of day.

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

| Typed | Committed |
| --- | --- |
| `9` | 09:00 |
| `930`, `0930`, `9:30`, `9.30` | 09:30 |
| `2:30 pm`, `2:30pm` | 14:30 |
| `12am` / `12pm` | 00:00 / 12:00 |
| `25:00`, `9:60`, `13:00 pm` | refused |

### AstryxTimeInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `AstryxTime?` | — | The committed time, or null for an empty field. |
| `onChanged` | `ValueChanged<AstryxTime?>?` | — | Called with a newly committed time, or null when the field is cleared. |
| `label` | `String?` | — | The field’s label and accessible name. |
| `format` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock the value is **written** on. Both are always accepted on the way in. |
| `earliest` | `AstryxTime?` | — | The earliest acceptable time. |
| `latest` | `AstryxTime?` | — | The latest acceptable time. |
| `stepMinutes` | `int` | `1` | How far an arrow key moves the value. |
| `showIcon` | `bool` | `true` | Whether to show the clock glyph before the text. |
| `showClear` | `bool` | `false` | Whether to show a button that empties the field. |

### AstryxTime

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `hour` **(required)** | `int` | — | The hour on a 24-hour clock, 0–23. |
| `minute` **(required)** | `int` | — | The minute, 0–59. |
| `minutesSinceMidnight` | `int` | — | How far into the day this is. |
| `hour12` | `int` | — | The hour on a 12-hour clock, 1–12. |
| `isBeforeNoon` | `bool` | — | Whether this is the `am` half. |
| `plusMinutes(n)` | `AstryxTime` | — | This time moved by `n`, wrapping at midnight either way. |
| `onDate(date)` | `DateTime` | — | This time on `date`, as an instant. |

---

## AstryxTimestamp

`lib/src/components/date_time/timestamp.dart` · upstream `Timestamp`

An absolute time rendered relative — "3 minutes ago" — and re-rendered as it ages.

```dart
class TimestampDemoExample extends StatelessWidget {
  const TimestampDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Relative, and re-rendered as it ages: "just now" becomes "5 minutes ago"
    // without the caller rebuilding anything. Past a week it writes the date
    // instead, because "43 days ago" is arithmetic nobody asked for.
    return AstryxMetadataList(
      items: <AstryxMetadataItem>[
        AstryxMetadataItem(
          label: 'Deployed',
          value: AstryxTimestamp(now.subtract(const Duration(seconds: 20))),
        ),
        AstryxMetadataItem(
          label: 'Last error',
          value: AstryxTimestamp(now.subtract(const Duration(minutes: 42))),
        ),
        AstryxMetadataItem(
          label: 'Created',
          value: AstryxTimestamp(now.subtract(const Duration(days: 3))),
        ),
        AstryxMetadataItem(
          label: 'Certificate issued',
          value: AstryxTimestamp(now.subtract(const Duration(days: 40))),
        ),
        AstryxMetadataItem(
          label: 'Next run',
          value: AstryxTimestamp(now.add(const Duration(hours: 6))),
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** Pass `live: false` in a long list that is rebuilt often anyway, and `now` to fix the clock — which is what makes a test of a relative stamp deterministic.
- **Accessibility:** The exact instant is the widget’s **accessible name** — "Tuesday, 4 August 2026, 14:27" — so a screen reader never gets only a relative phrase whose anchor it cannot see. It is in the tooltip for everybody else, and the relative text stays visible either way: a tooltip is never the only source of a fact.

| `AstryxTimestampFormat` | Writes |
| --- | --- |
| `relative` | "just now", "42 minutes ago", "in 6 hours" — then a date past the threshold. |
| `date` | `04/08/2026` |
| `time` | `14:30` |
| `dateTime` | `04/08/2026 14:30` |

### AstryxTimestamp

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `DateTime` | — | The instant being written. |
| `format` | `AstryxTimestampFormat` | `AstryxTimestampFormat.relative` | How to write it. |
| `dateFormat` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order the parts of a date are written in. |
| `timeFormat` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock a time is written on. |
| `threshold` | `Duration` | `Duration(days: 7)` | How old a relative stamp may get before it is written as a date. |
| `tooltip` | `bool` | `true` | Whether to show the exact instant on hover, focus or long-press. |
| `live` | `bool` | `true` | Whether to re-render as the instant ages. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The type-scale role of the rendered text. |
| `now` | `DateTime?` | — | What counts as now. Passing one also stops the ticking. |

---

