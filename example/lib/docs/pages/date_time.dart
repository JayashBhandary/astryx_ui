import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Dates and times: the grid, the four fields that write into it, and the
/// timestamp that reads one back out.
final List<DocPage> dateTimePages = <DocPage>[
  _calendar,
  _dateInput,
  _dateRangeInput,
  _dateTimeInput,
  _timeInput,
  _timestamp,
];

const String _group = DocGroup.dateTime;

/// The rows every field in this group shares.
const List<List<String>> _boundsRows = <List<String>>[
  <String>[
    '`firstDate` / `lastDate`',
    'The range of acceptable days. Outside it, a day is **dimmed rather than '
        'hidden** — the grid keeps its shape, and a user can see why a date is '
        'out of reach.',
  ],
  <String>[
    '`selectableDayPredicate`',
    'Rules out individual days inside the bounds — weekends, a holiday, a day '
        'already booked. Called for every cell a month shows, so keep it '
        'cheap.',
  ],
];

const DocPage _calendar = DocPage(
  id: 'calendar',
  title: 'AstryxCalendar',
  group: _group,
  description: 'A month grid for picking a date, keyboard-navigable.',
  source: 'lib/src/components/date_time/calendar.dart',
  upstream: 'Calendar',
  upstreamPath: '/components/Calendar',
  blocks: <DocBlock>[
    DocExample('calendar_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxCalendar(
  selected: _due,
  firstDate: DateTime.now(),
  onChanged: (day) => setState(() => _due = day),
)'''),
    DocProse(
      'A bare calendar belongs on a page that is *about* dates — availability, '
      'a schedule, a booking wall. For one date inside a form, reach for '
      '[AstryxDateInput](date_input) instead: it shows the value as text, '
      'accepts typing, and keeps the grid behind a button.',
    ),
    DocProse(
      '**Six rows, always.** A month that needs five still reserves six, '
      'because a grid that changes height as the user pages through it moves '
      'everything below it — and inside a popover, moves the popover.',
    ),
    DocHeading('Keyboard'),
    DocProse(
      '**The grid is one tab stop.** Tab moves onto it and off it again; the '
      'arrow keys move within it. Thirty-one tab stops between a user and the '
      'next field is not navigation. Roving focus is also separate from '
      'selection, so arrowing around picks nothing until `Enter` says so — '
      'which is what lets a keyboard user look before they commit.',
    ),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves onto the grid, and off it.'],
        <String>[
          '`←` / `→`',
          'One day back or forward. Mirrored under RTL.',
        ],
        <String>['`↑` / `↓`', 'One week back or forward.'],
        <String>['`Home` / `End`', 'The first or last day of that week.'],
        <String>['`Page Up` / `Page Down`', 'One month back or forward.'],
        <String>[
          '`Shift` + `Page Up` / `Page Down`',
          'One **year** back or forward — the difference between reaching a '
              'birthday and pressing "previous month" ninety times.',
        ],
        <String>['`Enter` / `Space`', 'Picks the day focus is on.'],
      ],
    ),
    DocHeading('Ranges'),
    DocProse(
      '`AstryxCalendar.range` picks two days instead of one. Two presses make '
      'a range, and the second may be the *earlier* of the two — someone who '
      'has already pressed twice has said which two days they mean, so the '
      'range completes backwards rather than starting over.',
    ),
    DocProse(
      '`onRangeChanged` does not fire for the first press. Half a range is a '
      'state the calendar owns, so no caller has to model "start but no end".',
    ),
    DocExample('calendar_range', align: DocExampleAlign.start),
    DocHeading('Bounds'),
    DocTable(headers: <String>['Property', 'Does'], rows: _boundsRows),
    DocExample('calendar_bounds', align: DocExampleAlign.start),
    DocCallout.accessibility(
      'Every cell announces its full date — "Tuesday, 4 August 2026" — because '
      'a grid of bare numbers is unusable through a screen reader. Today is '
      '**named as well as ringed**, and the ends of a range say which end they '
      'are: colour is never the only signal.',
    ),
    DocCallout.note(
      'Pass `today` to fix what the calendar treats as the current day. That '
      'is what makes a widget test — and a screenshot — reproducible.',
    ),
    DocApi('AstryxCalendar', <DocProp>[
      DocProp(
        'selected',
        'DateTime?',
        'The chosen day. Only its date is read.',
      ),
      DocProp(
        'onChanged',
        'ValueChanged<DateTime>?',
        'Called with the chosen day, at midnight. Null makes the grid a '
            'read-only display.',
      ),
      DocProp(
        'range',
        'AstryxDateRange?',
        'The chosen span. `AstryxCalendar.range` only.',
      ),
      DocProp(
        'onRangeChanged',
        'ValueChanged<AstryxDateRange>?',
        'Called once both ends have been pressed. `AstryxCalendar.range` only.',
      ),
      DocProp(
        'month',
        'DateTime?',
        'The month on show. Null lets the calendar page itself.',
      ),
      DocProp(
        'onMonthChanged',
        'ValueChanged<DateTime>?',
        'Called with the first day of the month now on show.',
      ),
      DocProp('firstDate', 'DateTime?', 'The earliest selectable day.'),
      DocProp('lastDate', 'DateTime?', 'The latest selectable day.'),
      DocProp(
        'selectableDayPredicate',
        'AstryxDayPredicate?',
        'Rules out individual days inside the bounds.',
      ),
      DocProp(
        'firstDayOfWeek',
        'AstryxWeekday',
        'Which day the week starts on.',
        defaultValue: 'AstryxWeekday.monday',
      ),
      DocProp('label', 'String?', 'An accessible name for the grid.'),
      DocProp(
        'enabled',
        'bool',
        'Whether the grid accepts presses.',
        defaultValue: 'true',
      ),
      DocProp(
        'today',
        'DateTime?',
        'What counts as today. Defaults to the system clock.',
      ),
      DocProp('focusNode', 'FocusNode?', 'The grid’s focus node.'),
      DocProp(
        'autofocus',
        'bool',
        'Whether the grid takes focus when first built.',
        defaultValue: 'false',
      ),
    ]),
    DocApi(
      'AstryxDateRange',
      <DocProp>[
        DocProp(
          'start',
          'DateTime',
          'The first day, at midnight.',
          required: true,
        ),
        DocProp(
          'end',
          'DateTime',
          'The last day, at midnight. Inclusive.',
          required: true,
        ),
        DocProp(
          'days',
          'int',
          'How many days the span covers, both ends '
              'counted.',
        ),
        DocProp('isSingleDay', 'bool', 'Whether it covers exactly one day.'),
        DocProp('contains(day)', 'bool', 'Whether `day` falls inside it.'),
      ],
      description:
          'A span of days, inclusive at both ends. Both ends are normalised to '
          'midnight, so a range picked at teatime equals the same range picked '
          'at breakfast. `DateTimeRange` lives in `package:flutter/material`, '
          'which this package is built to do without.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDateInput](date_input) — one date in a form.',
      '[AstryxDateRangeInput](date_range_input) — a span in a form.',
    ]),
  ],
);

const DocPage _dateInput = DocPage(
  id: 'date_input',
  title: 'AstryxDateInput',
  group: _group,
  description: 'A text field that parses and formats a single date.',
  source: 'lib/src/components/date_time/date_input.dart',
  upstream: 'DateInput',
  upstreamPath: '/components/DateInput',
  blocks: <DocBlock>[
    DocExample('date_input_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxDateInput(
  label: 'Due date',
  value: _due,
  firstDate: DateTime.now(),
  onChanged: (date) => setState(() => _due = date),
)'''),
    DocProse(
      '**Typing comes first.** A date picker that can only be clicked is '
      'slower than a keyboard for anybody who already knows the date they '
      'want, so this is a text field with a calendar attached rather than a '
      'button that opens one. `showCalendar: false` drops the grid entirely, '
      'for a form where dates are transcribed from somewhere else.',
    ),
    DocHeading('Parsing'),
    DocProse(
      'Deliberately forgiving about shape and strict about meaning. Any run of '
      'non-digits separates the parts, and a two-digit year is read as this '
      'century — so `4-8-26`, `04/08/2026` and `4 8 2026` all land on the same '
      'day. What is committed is then **written back in the field’s own '
      'format**, so the user can see what was understood.',
    ),
    DocCallout.warning(
      'A date that cannot be read is **refused, not guessed**. `31/02/2026` '
      'reverts to the committed value rather than quietly becoming the 3rd of '
      'March; so does a real date outside `firstDate` and `lastDate`. Silently '
      'moving a date somebody typed is the worse failure — `AstryxNumberInput` '
      'takes the same line, for the same reason.',
    ),
    DocHeading('Formats'),
    DocProse(
      'The placeholder is the pattern — `DD/MM/YYYY` — because it is the only '
      'thing on screen that says which of the two ambiguous orders a field '
      'wants. The order is the field’s own decision rather than the locale’s: '
      'the place a form is used is not always the place its data came from.',
    ),
    DocTable(
      headers: <String>['`AstryxDateFormat`', 'Writes', 'For'],
      rows: <List<String>>[
        <String>['`dayMonthYear`', '`04/08/2026`', 'Most of the world.'],
        <String>['`monthDayYear`', '`08/04/2026`', 'The United States.'],
        <String>[
          '`yearMonthDay`',
          '`2026-08-04`',
          'ISO-8601. Sorts as text, and is never ambiguous.',
        ],
      ],
    ),
    DocExample('date_input_formats', align: DocExampleAlign.start),
    DocHeading('Bounds'),
    DocTable(headers: <String>['Property', 'Does'], rows: _boundsRows),
    DocProse(
      'Both apply to typing as well as to the grid: a day the calendar will '
      'not let you press is a day the field will not accept.',
    ),
    DocExample('date_input_bounds', align: DocExampleAlign.start),
    DocCallout.accessibility(
      'A rejection is **announced**, not just undone — the field has already '
      'put the old value back, so a screen-reader user would otherwise have no '
      'idea their entry was thrown away (WCAG 3.3.1). The calendar button '
      'carries a name of its own, and the panel traps focus and returns it to '
      'the trigger when it closes.',
    ),
    DocApi('AstryxDateInput', <DocProp>[
      DocProp(
        'value',
        'DateTime?',
        'The committed date, or null for an empty field.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<DateTime?>?',
        'Called with a newly committed date, or null when the field is '
            'cleared. Fires on a calendar press and on blur or Enter — never '
            'per keystroke, because half a date is not a date.',
      ),
      DocProp('label', 'String?', 'The field’s label and accessible name.'),
      DocProp('description', 'String?', 'Helper text below the label.'),
      DocProp('status', 'AstryxFieldStatus?', 'The validation state.'),
      DocProp(
        'placeholder',
        'String?',
        'Shown when empty. Defaults to the format’s pattern.',
      ),
      DocProp(
        'format',
        'AstryxDateFormat',
        'The order the parts are written and read in.',
        defaultValue: 'AstryxDateFormat.dayMonthYear',
      ),
      DocProp('firstDate', 'DateTime?', 'The earliest acceptable date.'),
      DocProp('lastDate', 'DateTime?', 'The latest acceptable date.'),
      DocProp(
        'selectableDayPredicate',
        'AstryxDayPredicate?',
        'Rules out individual days.',
      ),
      DocProp(
        'showCalendar',
        'bool',
        'Whether to offer the calendar button.',
        defaultValue: 'true',
      ),
      DocProp(
        'showClear',
        'bool',
        'Whether to show a button that empties the field.',
        defaultValue: 'false',
      ),
      DocProp('size', 'AstryxInputSize?', 'The control height.'),
      DocProp(
        'readOnly',
        'bool',
        'Whether the value can be read but not changed. Not the same as '
            '`enabled: false`, which dims it.',
        defaultValue: 'false',
      ),
      DocProp(
        'today',
        'DateTime?',
        'What the calendar treats as today. Defaults to the system clock.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCalendar](calendar) — the grid this opens.',
      '[AstryxDateRangeInput](date_range_input) — two dates as one field.',
      '[AstryxDateTimeInput](date_time_input) — a date and a time.',
    ]),
  ],
);

const DocPage _dateRangeInput = DocPage(
  id: 'date_range_input',
  title: 'AstryxDateRangeInput',
  group: _group,
  description: 'Two dates as one field, with the range validated across them.',
  source: 'lib/src/components/date_time/date_range_input.dart',
  upstream: 'DateRangeInput',
  upstreamPath: '/components/DateRangeInput',
  blocks: <DocBlock>[
    DocExample('date_range_input_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxDateRangeInput(
  label: 'Reporting period',
  value: _period,
  onChanged: (range) => setState(() => _period = range),
)'''),
    DocHeading('Composition'),
    DocTree('''
AstryxDateRangeInput
├── label            ← names the pair
├── start field      ← "Start date", announced, not shown
├── –                ← an affix, excluded from semantics
├── end field        ← "End date", and the calendar button
└── status           ← belongs to the range, not to either date'''),
    DocProse(
      'Two fields rather than one, because a single box holding "04/08/2026 – '
      '11/08/2026" is a box nobody can edit half of. They are joined into one '
      'bordered control by [AstryxInputGroup](input_group), share one label, '
      'and share one validation message.',
    ),
    DocHeading('Validation across the pair'),
    DocProse(
      '**The error belongs to the range, not to either date.** An end before '
      'its start is not a bad date, it is a bad pair, and reporting it on one '
      'of the two fields blames the wrong one. So the message sits under the '
      'whole group, and `onChanged` reports null until the pair is in order.',
    ),
    DocCallout.warning(
      'Reversed ends are **not** silently swapped. Swapping changes the answer '
      'to a question the user has not finished asking — they may be halfway '
      'through moving both ends.',
    ),
    DocProse(
      'Nothing is reported until both ends are readable and in order, so a '
      'caller never has to model "start but no end". A status passed in wins '
      'over the widget’s own message, so a server-side error is not replaced '
      'by a local one.',
    ),
    DocExample('date_range_input_bounds', align: DocExampleAlign.start),
    DocCallout.accessibility(
      'Each half keeps its own accessible name — "Start date" and "End date", '
      'or whatever `startLabel` and `endLabel` say — because a reader landing '
      'in the second field needs to know which end it is. The dash between '
      'them is decorative and announced as nothing.',
    ),
    DocApi('AstryxDateRangeInput', <DocProp>[
      DocProp('label', 'String', 'Names the pair.', required: true),
      DocProp(
        'value',
        'AstryxDateRange?',
        'The committed span, or null while it is incomplete.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<AstryxDateRange?>?',
        'Called once both ends are readable and in order, or with null when '
            'either is cleared.',
      ),
      DocProp('description', 'String?', 'Helper text below the label.'),
      DocProp(
        'status',
        'AstryxFieldStatus?',
        'Wins over the widget’s own "end before start" message.',
      ),
      DocProp(
        'startLabel',
        'String?',
        'The first field’s accessible name. Defaults to "Start date".',
      ),
      DocProp(
        'endLabel',
        'String?',
        'The second field’s accessible name. Defaults to "End date".',
      ),
      DocProp(
        'format',
        'AstryxDateFormat',
        'The order each date is written and read in.',
        defaultValue: 'AstryxDateFormat.dayMonthYear',
      ),
      DocProp('firstDate', 'DateTime?', 'The earliest acceptable day.'),
      DocProp('lastDate', 'DateTime?', 'The latest acceptable day.'),
      DocProp(
        'selectableDayPredicate',
        'AstryxDayPredicate?',
        'Rules out individual days at either end.',
      ),
      DocProp(
        'showCalendar',
        'bool',
        'Whether to offer the calendar button.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCalendar](calendar) — `AstryxCalendar.range` is the grid this '
          'opens.',
      '[AstryxDateInput](date_input) — one date, and where the parsing rules '
          'are documented.',
    ]),
  ],
);

const DocPage _dateTimeInput = DocPage(
  id: 'date_time_input',
  title: 'AstryxDateTimeInput',
  group: _group,
  description: 'A date and a time in one field.',
  source: 'lib/src/components/date_time/date_time_input.dart',
  upstream: 'DateTimeInput',
  upstreamPath: '/components/DateTimeInput',
  blocks: <DocBlock>[
    DocExample('date_time_input_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxDateTimeInput(
  label: 'Publish at',
  value: _publishAt,
  defaultTime: const AstryxTime(hour: 9, minute: 0),
  stepMinutes: 15,
  onChanged: (at) => setState(() => _publishAt = at),
)'''),
    DocProse(
      'Two controls in one bordered group, because a date and a time are typed '
      'differently and corrected differently — and a single box holding '
      '"04/08/2026 14:30" makes fixing the hour an exercise in caret '
      'placement.',
    ),
    DocHeading('A date without a time'),
    DocProse(
      '**A date on its own is still an answer.** Picking the 4th of August and '
      'leaving the time alone commits `defaultTime`, which is midnight unless '
      'you say otherwise. A time on its own commits nothing, because there is '
      'no instant to report.',
    ),
    DocCallout.note(
      'That asymmetry is deliberate. "The 4th" is a thing people mean; "half '
      'past two, some day" is not.',
    ),
    DocProse(
      'Each half keeps its own format, and `firstDate` and `lastDate` apply to '
      'the date half — an instant is out of range because of its day.',
    ),
    DocExample('date_time_input_clock', align: DocExampleAlign.start),
    DocApi('AstryxDateTimeInput', <DocProp>[
      DocProp('label', 'String', 'Names the pair.', required: true),
      DocProp(
        'value',
        'DateTime?',
        'The committed instant, or null for an empty field.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<DateTime?>?',
        'Called with a newly committed instant, or null when the date is '
            'cleared.',
      ),
      DocProp(
        'dateLabel',
        'String?',
        'The date half’s accessible name. Defaults to "Date".',
      ),
      DocProp(
        'timeLabel',
        'String?',
        'The time half’s accessible name. Defaults to "Time".',
      ),
      DocProp(
        'dateFormat',
        'AstryxDateFormat',
        'The order the parts of the date are written in.',
        defaultValue: 'AstryxDateFormat.dayMonthYear',
      ),
      DocProp(
        'timeFormat',
        'AstryxTimeFormat',
        'Which clock the time is written on.',
        defaultValue: 'AstryxTimeFormat.h24',
      ),
      DocProp(
        'defaultTime',
        'AstryxTime',
        'The time a date picked on its own is committed at.',
        defaultValue: 'AstryxTime.midnight',
      ),
      DocProp(
        'stepMinutes',
        'int',
        'How far an arrow key moves the time.',
        defaultValue: '1',
      ),
      DocProp('firstDate', 'DateTime?', 'The earliest acceptable day.'),
      DocProp('lastDate', 'DateTime?', 'The latest acceptable day.'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDateInput](date_input) — when the time of day does not matter.',
      '[AstryxTimeInput](time_input) — when the day does not.',
    ]),
  ],
);

const DocPage _timeInput = DocPage(
  id: 'time_input',
  title: 'AstryxTimeInput',
  group: _group,
  description: 'A text field for a time of day.',
  source: 'lib/src/components/date_time/time_input.dart',
  upstream: 'TimeInput',
  upstreamPath: '/components/TimeInput',
  blocks: <DocBlock>[
    DocExample('time_input_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxTimeInput(
  label: 'Starts at',
  value: _start,
  stepMinutes: 15,
  onChanged: (time) => setState(() => _start = time),
)'''),
    DocHeading('Parsing'),
    DocProse(
      'A text field, not a wheel. Every one of these commits half past nine, '
      'and **both clocks are accepted whichever one is shown** — somebody who '
      'types "2pm" into a 24-hour field means 14:00, and refusing that would '
      'be pedantry.',
    ),
    DocTable(
      headers: <String>['Typed', 'Committed'],
      rows: <List<String>>[
        <String>['`9`', '09:00'],
        <String>['`930`, `0930`, `9:30`, `9.30`', '09:30'],
        <String>['`2:30 pm`, `2:30pm`', '14:30'],
        <String>['`12am` / `12pm`', '00:00 / 12:00'],
        <String>['`25:00`, `9:60`, `13:00 pm`', 'refused'],
      ],
    ),
    DocProse(
      'What is committed is written back on the field’s own clock, so a value '
      'typed as "2pm" is shown as `14:30` and the user can see what was '
      'understood. An unreadable time reverts and is announced — the same '
      'contract as [AstryxDateInput](date_input).',
    ),
    DocHeading('Stepping'),
    DocProse(
      'The arrow keys move the value by `stepMinutes`. One by default; set it '
      'to 15 or 30 for a field that books something, where every intermediate '
      'minute is a value nobody wants to arrow past. A step that would leave '
      '`earliest`–`latest` is **refused rather than wrapped**, so a field with '
      'a floor of 09:00 stops there instead of jumping to 23:45.',
    ),
    DocExample('time_input_bounds', align: DocExampleAlign.start),
    DocApi('AstryxTimeInput', <DocProp>[
      DocProp(
        'value',
        'AstryxTime?',
        'The committed time, or null for an empty field.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<AstryxTime?>?',
        'Called with a newly committed time, or null when the field is '
            'cleared.',
      ),
      DocProp('label', 'String?', 'The field’s label and accessible name.'),
      DocProp(
        'format',
        'AstryxTimeFormat',
        'Which clock the value is **written** on. Both are always accepted on '
            'the way in.',
        defaultValue: 'AstryxTimeFormat.h24',
      ),
      DocProp('earliest', 'AstryxTime?', 'The earliest acceptable time.'),
      DocProp('latest', 'AstryxTime?', 'The latest acceptable time.'),
      DocProp(
        'stepMinutes',
        'int',
        'How far an arrow key moves the value.',
        defaultValue: '1',
      ),
      DocProp(
        'showIcon',
        'bool',
        'Whether to show the clock glyph before the text.',
        defaultValue: 'true',
      ),
      DocProp(
        'showClear',
        'bool',
        'Whether to show a button that empties the field.',
        defaultValue: 'false',
      ),
    ]),
    DocApi(
      'AstryxTime',
      <DocProp>[
        DocProp(
          'hour',
          'int',
          'The hour on a 24-hour clock, 0–23.',
          required: true,
        ),
        DocProp('minute', 'int', 'The minute, 0–59.', required: true),
        DocProp('minutesSinceMidnight', 'int', 'How far into the day this is.'),
        DocProp('hour12', 'int', 'The hour on a 12-hour clock, 1–12.'),
        DocProp('isBeforeNoon', 'bool', 'Whether this is the `am` half.'),
        DocProp(
          'plusMinutes(n)',
          'AstryxTime',
          'This time moved by `n`, wrapping at midnight either way.',
        ),
        DocProp(
          'onDate(date)',
          'DateTime',
          'This time on `date`, as an '
              'instant.',
        ),
      ],
      description:
          'An hour and a minute with no day attached — a shift start, an '
          'office closing time. `TimeOfDay` lives in '
          '`package:flutter/material`, which this package is built to do '
          'without.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDateTimeInput](date_time_input) — a day and a time together.',
      '[AstryxNumberInput](number_input) — the field this borrows its '
          'reject-rather-than-clamp contract from.',
    ]),
  ],
);

const DocPage _timestamp = DocPage(
  id: 'timestamp',
  title: 'AstryxTimestamp',
  group: _group,
  description:
      'An absolute time rendered relative — "3 minutes ago" — and re-rendered '
      'as it ages.',
  source: 'lib/src/components/date_time/timestamp.dart',
  upstream: 'Timestamp',
  upstreamPath: '/components/Timestamp',
  blocks: <DocBlock>[
    DocExample('timestamp_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('AstryxTimestamp(deployedAt)'),
    DocProse(
      '"3 minutes ago" is the right answer for something that just happened '
      'and the wrong one for something from March, so a relative timestamp '
      '**falls back to a date** once it is older than `threshold` — a week by '
      'default.',
    ),
    DocHeading('Staying current'),
    DocProse(
      'A relative stamp re-renders as it ages: a row that said "just now" when '
      'the page loaded says "5 minutes ago" five minutes later, without the '
      'caller rebuilding anything. The timer is a single shot that re-books '
      'itself at a distance matching how fast the text can change — 30 seconds '
      'while the stamp is minutes old, an hour once it is days old — because a '
      'stamp from last March cannot change this minute, and a list of two '
      'hundred rows should not wake the framework two hundred times a second '
      'to prove it.',
    ),
    DocCallout.note(
      'Pass `live: false` in a long list that is rebuilt often anyway, and '
      '`now` to fix the clock — which is what makes a test of a relative '
      'stamp deterministic.',
    ),
    DocHeading('Formats'),
    DocTable(
      headers: <String>['`AstryxTimestampFormat`', 'Writes'],
      rows: <List<String>>[
        <String>[
          '`relative`',
          '"just now", "42 minutes ago", "in 6 hours" — then a date past the '
              'threshold.',
        ],
        <String>['`date`', '`04/08/2026`'],
        <String>['`time`', '`14:30`'],
        <String>['`dateTime`', '`04/08/2026 14:30`'],
      ],
    ),
    DocExample('timestamp_formats', align: DocExampleAlign.start),
    DocCallout.accessibility(
      'The exact instant is the widget’s **accessible name** — "Tuesday, 4 '
      'August 2026, 14:27" — so a screen reader never gets only a relative '
      'phrase whose anchor it cannot see. It is in the tooltip for everybody '
      'else, and the relative text stays visible either way: a tooltip is '
      'never the only source of a fact.',
    ),
    DocApi('AstryxTimestamp', <DocProp>[
      DocProp(
        'value',
        'DateTime',
        'The instant being written.',
        required: true,
      ),
      DocProp(
        'format',
        'AstryxTimestampFormat',
        'How to write it.',
        defaultValue: 'AstryxTimestampFormat.relative',
      ),
      DocProp(
        'dateFormat',
        'AstryxDateFormat',
        'The order the parts of a date are written in.',
        defaultValue: 'AstryxDateFormat.dayMonthYear',
      ),
      DocProp(
        'timeFormat',
        'AstryxTimeFormat',
        'Which clock a time is written on.',
        defaultValue: 'AstryxTimeFormat.h24',
      ),
      DocProp(
        'threshold',
        'Duration',
        'How old a relative stamp may get before it is written as a date.',
        defaultValue: 'Duration(days: 7)',
      ),
      DocProp(
        'tooltip',
        'bool',
        'Whether to show the exact instant on hover, focus or long-press.',
        defaultValue: 'true',
      ),
      DocProp(
        'live',
        'bool',
        'Whether to re-render as the instant ages.',
        defaultValue: 'true',
      ),
      DocProp(
        'type',
        'AstryxTextType',
        'The type-scale role of the rendered text.',
        defaultValue: 'AstryxTextType.body',
      ),
      DocProp(
        'now',
        'DateTime?',
        'What counts as now. Passing one also stops the ticking.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxMetadataList](metadata_list) — where most timestamps end up.',
      '[AstryxTable](table) — a column of these needs `live: false` more often '
          'than not.',
    ]),
  ],
);
