import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The date and time group: the calendar, the four fields that write into it,
/// and the timestamp that reads one back out.
///
/// The parsing tests come first and carry the most weight, because parsing is
/// where a date field is either honest or quietly wrong. Every widget test
/// below is about the thing that makes its widget different from a text input:
/// a grid that moves under the arrow keys, a pair that validates across two
/// fields, a stamp that ages.
void main() {
  setUp(AstryxOverlayStack.reset);

  const l10n = AstryxLocalizations();

  group('parseAstryxDate', () {
    test('reads the order the format asks for', () {
      expect(
        parseAstryxDate('04/08/2026', AstryxDateFormat.dayMonthYear),
        DateTime(2026, 8, 4),
      );
      expect(
        parseAstryxDate('04/08/2026', AstryxDateFormat.monthDayYear),
        DateTime(2026, 4, 8),
      );
      expect(
        parseAstryxDate('2026-08-04', AstryxDateFormat.yearMonthDay),
        DateTime(2026, 8, 4),
      );
    });

    test('is forgiving about separators and about a two-digit year', () {
      expect(
        parseAstryxDate('4-8-26', AstryxDateFormat.dayMonthYear),
        DateTime(2026, 8, 4),
      );
      expect(
        parseAstryxDate(' 4 . 8 . 2026 ', AstryxDateFormat.dayMonthYear),
        DateTime(2026, 8, 4),
      );
    });

    test('refuses a day that does not exist rather than rolling it over', () {
      // `DateTime(2026, 2, 31)` is a real object pointing at the 3rd of March.
      // Returning it would be the field silently changing what was typed.
      expect(parseAstryxDate('31/02/2026', AstryxDateFormat.dayMonthYear),
          isNull);
      expect(parseAstryxDate('00/08/2026', AstryxDateFormat.dayMonthYear),
          isNull);
      // Month first here, so a thirteenth month is the invalid part.
      expect(parseAstryxDate('13/04/2026', AstryxDateFormat.monthDayYear),
          isNull);
    });

    test('refuses anything that is not three numbers', () {
      expect(parseAstryxDate('', AstryxDateFormat.dayMonthYear), isNull);
      expect(parseAstryxDate('tomorrow', AstryxDateFormat.dayMonthYear),
          isNull);
      expect(parseAstryxDate('04/08', AstryxDateFormat.dayMonthYear), isNull);
    });

    test('round-trips what it formats', () {
      for (final format in AstryxDateFormat.values) {
        final written = formatAstryxDate(DateTime(2026, 8, 4), format);
        expect(parseAstryxDate(written, format), DateTime(2026, 8, 4));
      }
    });
  });

  group('parseAstryxTime', () {
    test('reads every shape a user types', () {
      expect(parseAstryxTime('9', l10n), const AstryxTime(hour: 9, minute: 0));
      expect(
        parseAstryxTime('930', l10n),
        const AstryxTime(hour: 9, minute: 30),
      );
      expect(
        parseAstryxTime('0930', l10n),
        const AstryxTime(hour: 9, minute: 30),
      );
      expect(
        parseAstryxTime('9:30', l10n),
        const AstryxTime(hour: 9, minute: 30),
      );
      expect(
        parseAstryxTime('9.30', l10n),
        const AstryxTime(hour: 9, minute: 30),
      );
      expect(
        parseAstryxTime('14:30', l10n),
        const AstryxTime(hour: 14, minute: 30),
      );
    });

    test('accepts a twelve-hour clock on either kind of field', () {
      expect(
        parseAstryxTime('2:30 pm', l10n),
        const AstryxTime(hour: 14, minute: 30),
      );
      expect(
        parseAstryxTime('2:30pm', l10n),
        const AstryxTime(hour: 14, minute: 30),
      );
      expect(parseAstryxTime('12am', l10n), AstryxTime.midnight);
      expect(parseAstryxTime('12pm', l10n), AstryxTime.noon);
    });

    test('refuses what is not a time', () {
      expect(parseAstryxTime('25:00', l10n), isNull);
      expect(parseAstryxTime('9:60', l10n), isNull);
      expect(parseAstryxTime('13:00 pm', l10n), isNull);
      expect(parseAstryxTime('soon', l10n), isNull);
    });

    test('writes on the clock it is asked for', () {
      const time = AstryxTime(hour: 14, minute: 5);
      expect(formatAstryxTime(time, AstryxTimeFormat.h24, l10n), '14:05');
      expect(formatAstryxTime(time, AstryxTimeFormat.h12, l10n), '2:05 pm');
      expect(
        formatAstryxTime(AstryxTime.midnight, AstryxTimeFormat.h12, l10n),
        '12:00 am',
      );
    });
  });

  group('the value types', () {
    test('a time wraps at midnight in both directions', () {
      expect(
        const AstryxTime(hour: 23, minute: 50).plusMinutes(20),
        const AstryxTime(hour: 0, minute: 10),
      );
      expect(
        const AstryxTime(hour: 0, minute: 10).plusMinutes(-20),
        const AstryxTime(hour: 23, minute: 50),
      );
    });

    test('a range counts both of its ends', () {
      final range = AstryxDateRange(
        start: DateTime(2026, 8, 4, 13),
        end: DateTime(2026, 8, 6, 9),
      );
      expect(range.days, 3);
      // Both ends are normalised, so a range picked at teatime equals the same
      // range picked at breakfast.
      expect(range.start, DateTime(2026, 8, 4));
      expect(range.contains(DateTime(2026, 8, 5, 23, 59)), isTrue);
      expect(range.contains(DateTime(2026, 8, 7)), isFalse);
      expect(AstryxDateRange.day(DateTime(2026, 8, 4)).isSingleDay, isTrue);
    });

    test('a month step clamps the day instead of rolling over', () {
      expect(
        astryxAddMonths(DateTime(2026, 1, 31), 1),
        DateTime(2026, 2, 28),
      );
      expect(
        astryxAddMonths(DateTime(2026, 3, 15), -3),
        DateTime(2025, 12, 15),
      );
    });
  });

  group('AstryxCalendar', () {
    testWidgets('shows the month it is given and pages from the header', (
      tester,
    ) async {
      final months = <DateTime>[];

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(
          today: DateTime(2026, 8, 4),
          onChanged: (_) {},
          onMonthChanged: months.add,
        ),
        surfaceSize: const Size(420, 480),
      );

      expect(find.text('August 2026'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pumpAndSettle();

      expect(find.text('September 2026'), findsOneWidget);
      expect(months.single, DateTime(2026, 9));
    });

    testWidgets('a press reports the day at midnight', (tester) async {
      final picked = <DateTime>[];

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(today: DateTime(2026, 8, 4), onChanged: picked.add),
        surfaceSize: const Size(420, 480),
      );

      await tester.tap(
        find.bySemanticsLabel(RegExp('Thursday, 6 August 2026')),
      );
      await tester.pumpAndSettle();

      expect(picked.single, DateTime(2026, 8, 6));
    });

    testWidgets('the arrow keys move a roving focus, and Enter picks', (
      tester,
    ) async {
      final picked = <DateTime>[];
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(
          today: DateTime(2026, 8, 4),
          focusNode: node,
          autofocus: true,
          onChanged: picked.add,
        ),
        surfaceSize: const Size(420, 480),
      );
      await tester.pumpAndSettle();

      // Focus starts on today; two days to the right, then a week down.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(picked.single, DateTime(2026, 8, 13));
    });

    testWidgets('Page Down moves the month without picking anything', (
      tester,
    ) async {
      final picked = <DateTime>[];
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(
          today: DateTime(2026, 8, 4),
          focusNode: node,
          autofocus: true,
          onChanged: picked.add,
        ),
        surfaceSize: const Size(420, 480),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pumpAndSettle();

      expect(find.text('September 2026'), findsOneWidget);
      expect(picked, isEmpty);
    });

    testWidgets('a day out of bounds is shown, announced, and inert', (
      tester,
    ) async {
      final picked = <DateTime>[];

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(
          today: DateTime(2026, 8, 4),
          firstDate: DateTime(2026, 8, 4),
          onChanged: picked.add,
        ),
        surfaceSize: const Size(420, 480),
      );

      // Shown rather than hidden: the grid keeps its shape, and a user can see
      // why they cannot reach the date.
      final earlier = find.bySemanticsLabel(
        RegExp('Monday, 3 August 2026'),
      );
      expect(earlier, findsOneWidget);

      await tester.tap(earlier);
      await tester.pumpAndSettle();

      expect(picked, isEmpty);
    });

    testWidgets('a predicate rules out a day inside the bounds', (
      tester,
    ) async {
      final picked = <DateTime>[];

      await pumpAstryxWidget(
        tester,
        AstryxCalendar(
          today: DateTime(2026, 8, 4),
          selectableDayPredicate: (day) => day.weekday != DateTime.saturday,
          onChanged: picked.add,
        ),
        surfaceSize: const Size(420, 480),
      );

      await tester.tap(
        find.bySemanticsLabel(RegExp('Saturday, 8 August 2026')),
      );
      await tester.pumpAndSettle();

      expect(picked, isEmpty);
    });

    testWidgets('today is named as well as ringed', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxCalendar(today: DateTime(2026, 8, 4), onChanged: (_) {}),
        surfaceSize: const Size(420, 480),
      );

      expect(
        find.bySemanticsLabel('Tuesday, 4 August 2026, today'),
        findsOneWidget,
      );
    });

    testWidgets('a range takes two presses, in either order', (tester) async {
      final ranges = <AstryxDateRange>[];

      await pumpAstryxWidget(
        tester,
        AstryxCalendar.range(
          today: DateTime(2026, 8, 4),
          onRangeChanged: ranges.add,
        ),
        surfaceSize: const Size(420, 480),
      );

      await tester.tap(
        find.bySemanticsLabel(RegExp('Thursday, 6 August 2026')),
      );
      await tester.pumpAndSettle();
      // Half a range is not reported: the calendar owns that state.
      expect(ranges, isEmpty);

      // The second press is *earlier*, which completes the range backwards
      // rather than starting over.
      await tester.tap(
        find.bySemanticsLabel(RegExp('Tuesday, 4 August 2026')),
      );
      await tester.pumpAndSettle();

      expect(ranges.single.start, DateTime(2026, 8, 4));
      expect(ranges.single.end, DateTime(2026, 8, 6));
    });
  });

  group('AstryxDateInput', () {
    testWidgets('commits on blur, and rewrites the text in its own format', (
      tester,
    ) async {
      DateTime? value;
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateInput(
            label: 'Due date',
            value: value,
            focusNode: node,
            onChanged: (date) => setState(() => value = date),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      await tester.enterText(find.byType(EditableText), '4-8-26');
      node.unfocus();
      await tester.pumpAndSettle();

      expect(value, DateTime(2026, 8, 4));
      expect(find.text('04/08/2026'), findsOneWidget);
    });

    testWidgets('reverts and announces a date it cannot read', (tester) async {
      DateTime? value = DateTime(2026, 8, 4);
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateInput(
            label: 'Due date',
            value: value,
            focusNode: node,
            onChanged: (date) => setState(() => value = date),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      await tester.enterText(find.byType(EditableText), '31/02/2026');
      node.unfocus();
      await tester.pumpAndSettle();

      expect(value, DateTime(2026, 8, 4), reason: 'the old value comes back');
      expect(find.text('04/08/2026'), findsOneWidget);
      // The rejection is announced, because reverting silently tells a
      // screen-reader user nothing — WCAG 3.3.1.
      expect(find.text('31/02/2026 is not a date'), findsOneWidget);
    });

    testWidgets('refuses a real date that is out of bounds', (tester) async {
      DateTime? value;
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateInput(
            label: 'Due date',
            value: value,
            focusNode: node,
            firstDate: DateTime(2026, 8, 4),
            onChanged: (date) => setState(() => value = date),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      await tester.enterText(find.byType(EditableText), '01/08/2026');
      node.unfocus();
      await tester.pumpAndSettle();

      expect(value, isNull);
    });

    testWidgets('the calendar button opens the grid, and a press commits', (
      tester,
    ) async {
      DateTime? value;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateInput(
            label: 'Due date',
            value: value,
            today: DateTime(2026, 8, 4),
            onChanged: (date) => setState(() => value = date),
          ),
        ),
        surfaceSize: const Size(480, 560),
      );

      await tester.tap(find.bySemanticsLabel('Choose a date for Due date'));
      await tester.pumpAndSettle();

      expect(find.text('August 2026'), findsOneWidget);

      await tester.tap(
        find.bySemanticsLabel(RegExp('Thursday, 6 August 2026')),
      );
      await tester.pumpAndSettle();

      expect(value, DateTime(2026, 8, 6));
      // Picking closes the panel: the answer is given, so the grid is in the
      // way.
      expect(find.text('August 2026'), findsNothing);
      expect(find.text('06/08/2026'), findsOneWidget);
    });
  });

  group('AstryxTimeInput', () {
    testWidgets('accepts a twelve-hour entry and writes it back on the '
        'field’s own clock', (tester) async {
      AstryxTime? value;
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTimeInput(
            label: 'Starts at',
            value: value,
            focusNode: node,
            onChanged: (time) => setState(() => value = time),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      await tester.enterText(find.byType(EditableText), '2:30 pm');
      node.unfocus();
      await tester.pumpAndSettle();

      expect(value, const AstryxTime(hour: 14, minute: 30));
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('the arrow keys step by stepMinutes', (tester) async {
      AstryxTime? value = const AstryxTime(hour: 9, minute: 0);
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTimeInput(
            label: 'Starts at',
            value: value,
            focusNode: node,
            stepMinutes: 15,
            onChanged: (time) => setState(() => value = time),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      node.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();

      expect(value, const AstryxTime(hour: 9, minute: 15));
    });

    testWidgets('a step stops at the floor rather than wrapping past it', (
      tester,
    ) async {
      AstryxTime? value = const AstryxTime(hour: 9, minute: 0);
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTimeInput(
            label: 'Starts at',
            value: value,
            focusNode: node,
            earliest: const AstryxTime(hour: 9, minute: 0),
            stepMinutes: 15,
            onChanged: (time) => setState(() => value = time),
          ),
        ),
        surfaceSize: const Size(420, 240),
      );

      node.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(value, const AstryxTime(hour: 9, minute: 0));
    });
  });

  group('AstryxDateRangeInput', () {
    testWidgets('reports nothing until both ends are readable', (tester) async {
      AstryxDateRange? value;
      final start = FocusNode();
      final end = FocusNode();
      addTearDown(start.dispose);
      addTearDown(end.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateRangeInput(
            label: 'Reporting period',
            value: value,
            onChanged: (range) => setState(() => value = range),
          ),
        ),
        surfaceSize: const Size(560, 240),
      );

      final fields = find.byType(EditableText);
      await tester.enterText(fields.first, '04/08/2026');
      await tester.pump();
      // Focus moves to the second field, which blurs and commits the first.
      await tester.tap(fields.last);
      await tester.pumpAndSettle();

      expect(value, isNull, reason: 'half a range is not a range');

      await tester.enterText(fields.last, '06/08/2026');
      await tester.tap(fields.first);
      await tester.pumpAndSettle();

      expect(value?.start, DateTime(2026, 8, 4));
      expect(value?.end, DateTime(2026, 8, 6));
    });

    testWidgets('an end before its start is an error on the pair', (
      tester,
    ) async {
      AstryxDateRange? value;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateRangeInput(
            label: 'Reporting period',
            value: value,
            onChanged: (range) => setState(() => value = range),
          ),
        ),
        surfaceSize: const Size(560, 280),
      );

      final fields = find.byType(EditableText);
      await tester.enterText(fields.first, '06/08/2026');
      await tester.tap(fields.last);
      await tester.pumpAndSettle();
      await tester.enterText(fields.last, '04/08/2026');
      await tester.tap(fields.first);
      await tester.pumpAndSettle();

      expect(value, isNull);
      expect(
        find.text('The end date is before the start date'),
        findsOneWidget,
      );
    });
  });

  group('AstryxDateTimeInput', () {
    testWidgets('a date on its own commits at the default time', (
      tester,
    ) async {
      DateTime? value;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateTimeInput(
            label: 'Publish at',
            value: value,
            defaultTime: const AstryxTime(hour: 9, minute: 0),
            onChanged: (at) => setState(() => value = at),
          ),
        ),
        surfaceSize: const Size(560, 240),
      );

      await tester.enterText(find.byType(EditableText).first, '04/08/2026');
      await tester.tap(find.byType(EditableText).last);
      await tester.pumpAndSettle();

      expect(value, DateTime(2026, 8, 4, 9));
    });

    testWidgets('a time on its own commits nothing', (tester) async {
      DateTime? value;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxDateTimeInput(
            label: 'Publish at',
            value: value,
            onChanged: (at) => setState(() => value = at),
          ),
        ),
        surfaceSize: const Size(560, 240),
      );

      await tester.enterText(find.byType(EditableText).last, '14:30');
      await tester.tap(find.byType(EditableText).first);
      await tester.pumpAndSettle();

      expect(value, isNull);
    });
  });

  group('AstryxTimestamp', () {
    final now = DateTime(2026, 8, 4, 14, 30);

    testWidgets('writes a recent instant relatively', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(
          now.subtract(const Duration(minutes: 3)),
          now: now,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(find.text('3 minutes ago'), findsOneWidget);
    });

    testWidgets('rounds the last few seconds to "just now"', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(
          now.subtract(const Duration(seconds: 20)),
          now: now,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(find.text('just now'), findsOneWidget);
    });

    testWidgets('says which way a future instant points', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(now.add(const Duration(hours: 2)), now: now),
        surfaceSize: const Size(300, 120),
      );

      expect(find.text('in 2 hours'), findsOneWidget);
    });

    testWidgets('falls back to a date once it is older than the threshold', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(
          now.subtract(const Duration(days: 40)),
          now: now,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(find.text('25/06/2026'), findsOneWidget);
    });

    testWidgets('the exact instant is the accessible name', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(
          now.subtract(const Duration(minutes: 3)),
          now: now,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(
        find.bySemanticsLabel('Tuesday, 4 August 2026, 14:27'),
        findsOneWidget,
      );
    });

    testWidgets('an absolute format writes what it is asked for', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxTimestamp(
          now,
          format: AstryxTimestampFormat.dateTime,
          timeFormat: AstryxTimeFormat.h12,
          now: now,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(find.text('04/08/2026 2:30 pm'), findsOneWidget);
    });
  });
}
