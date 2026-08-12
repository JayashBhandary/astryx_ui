import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The command and search group: the typeahead engine, the styled field, the
/// palette, and the filter bar.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxBaseTypeahead', () {
    late TextEditingController query;
    late List<String> picked;
    late List<String> queried;

    setUp(() {
      query = TextEditingController();
      picked = <String>[];
      queried = <String>[];
    });

    tearDown(() => query.dispose());

    Widget build({
      Duration debounce = Duration.zero,
      int minQueryLength = 1,
      Future<List<String>> Function(String)? source,
    }) => AstryxBaseTypeahead<String>(
      controller: query,
      debounce: debounce,
      minQueryLength: minQueryLength,
      onSelected: picked.add,
      onQueryChanged: queried.add,
      source: source ??
          (text) async => <String>[
            for (final city in <String>['Aberdeen', 'Adelaide', 'Almería'])
              if (city.toLowerCase().contains(text.toLowerCase())) city,
          ],
      fieldBuilder: (context, state) => AstryxTextInput(
        label: 'City',
        controller: state.controller,
        focusNode: state.focusNode,
      ),
      itemBuilder: (context, city, state) => AstryxItem(
        label: city,
        selected: state.isActive(state.suggestions.indexOf(city)),
        onPressed: () => state.select(city),
      ),
    );

    testWidgets('searches after the debounce and shows what came back', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'ad');
      await tester.pumpAndSettle();

      expect(queried, <String>['ad']);
      expect(find.text('Adelaide'), findsOneWidget);
      expect(find.text('Almería'), findsNothing);
    });

    testWidgets('the arrows move an active row and the field keeps focus', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pumpAndSettle();

      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.focusNode.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // The caret stays put: this is the ARIA combobox pattern, not a list that
      // takes over.
      expect(field.focusNode.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(picked, <String>['Aberdeen']);
    });

    testWidgets('Enter with nothing highlighted is left to the form', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // A typeahead must not swallow the key that submits the search.
      expect(picked, isEmpty);
    });

    testWidgets('Escape closes the list and nothing else', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pumpAndSettle();
      expect(find.text('Aberdeen'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Aberdeen'), findsNothing);
      expect(query.text, 'a', reason: 'Escape closes; it does not clear');
    });

    testWidgets('a short query calls nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(minQueryLength: 3),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'ab');
      await tester.pumpAndSettle();

      expect(queried, isEmpty);
      expect(find.text('Aberdeen'), findsNothing);
    });

    testWidgets('a stale response cannot overwrite a newer one', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(
          source: (text) async {
            // The first query is slow, the second fast — the ordering that
            // produces the "stale results" bug.
            await Future<void>.delayed(
              Duration(milliseconds: text == 'a' ? 300 : 10),
            );
            return <String>['result for $text'];
          },
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump(const Duration(milliseconds: 20));
      await tester.enterText(find.byType(EditableText), 'ab');
      await tester.pumpAndSettle(const Duration(milliseconds: 400));

      expect(find.text('result for ab'), findsOneWidget);
      expect(find.text('result for a'), findsNothing);
    });

    testWidgets('a source that throws leaves an empty list, not a crash', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(source: (text) async => throw StateError('offline')),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'ab');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Twice: the surface says it, and so does the live region.
      expect(find.text('No matches'), findsWidgets);
    });

    testWidgets('the result count is announced', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(400, 500),
      );

      await tester.enterText(find.byType(EditableText), 'ad');
      await tester.pumpAndSettle();

      // A dropdown appearing is silent to a screen reader, so the count is
      // spoken instead.
      expect(find.text('1 result'), findsOneWidget);
    });
  });

  group('AstryxTypeahead', () {
    testWidgets('puts the chosen label in the field', (tester) async {
      final query = TextEditingController();
      addTearDown(query.dispose);
      final picked = <String>[];

      await pumpAstryxWidget(
        tester,
        AstryxTypeahead<String>(
          label: 'Project',
          controller: query,
          debounce: Duration.zero,
          onSelected: picked.add,
          source: (text) async => <AstryxTypeaheadItem<String>>[
            const AstryxTypeaheadItem(
              value: 'atlas',
              label: 'Atlas',
              description: 'The scheduler',
            ),
          ],
        ),
        surfaceSize: const Size(500, 500),
      );

      await tester.enterText(find.byType(EditableText), 'atl');
      await tester.pumpAndSettle();

      expect(find.text('The scheduler'), findsOneWidget);

      await tester.tap(find.text('Atlas'));
      await tester.pumpAndSettle();

      expect(picked, <String>['atlas']);
      // The label, not the fragment that found it: a field left holding "atl"
      // reads as a failed search.
      expect(query.text, 'Atlas');
    });

    testWidgets('clearOnSelect empties it instead', (tester) async {
      final query = TextEditingController();
      addTearDown(query.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTypeahead<String>(
          label: 'Go to',
          controller: query,
          debounce: Duration.zero,
          clearOnSelect: true,
          onSelected: (_) {},
          source: (text) async => const <AstryxTypeaheadItem<String>>[
            AstryxTypeaheadItem(value: 'atlas', label: 'Atlas'),
          ],
        ),
        surfaceSize: const Size(500, 500),
      );

      await tester.enterText(find.byType(EditableText), 'atl');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Atlas'));
      await tester.pumpAndSettle();

      expect(query.text, isEmpty);
    });
  });

  group('AstryxCommandPalette', () {
    late AstryxOverlayController controller;
    late List<String> ran;

    setUp(() {
      controller = AstryxOverlayController();
      ran = <String>[];
    });

    tearDown(() => controller.dispose());

    Widget build() => AstryxCommandPalette(
      controller: controller,
      groups: <AstryxCommandGroup>[
        AstryxCommandGroup(
          label: 'Navigate',
          items: <AstryxCommandItem>[
            AstryxCommandItem(
              label: 'Go to deploys',
              onSelected: () => ran.add('deploys'),
              hotkey: const AstryxHotkey.mod(LogicalKeyboardKey.keyD),
            ),
            AstryxCommandItem(
              label: 'Go to settings',
              keywords: const <String>['preferences'],
              onSelected: () => ran.add('settings'),
            ),
          ],
        ),
        AstryxCommandGroup(
          label: 'Deploy',
          items: <AstryxCommandItem>[
            AstryxCommandItem(
              label: 'Roll back',
              onSelected: () => ran.add('rollback'),
            ),
          ],
        ),
      ],
    );

    testWidgets('renders nothing until it is opened', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );

      expect(find.text('Go to deploys'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();

      expect(find.text('Go to deploys'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
    });

    testWidgets('the query filters, keywords included', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      // Found by a word that is not in its label — a palette is only as good as
      // its synonyms.
      await tester.enterText(find.byType(EditableText), 'preferences');
      await tester.pumpAndSettle();

      expect(find.text('Go to settings'), findsOneWidget);
      expect(find.text('Go to deploys'), findsNothing);
      expect(find.text('Deploy'), findsNothing, reason: 'empty group hidden');
    });

    testWidgets('Enter runs the highlighted command and closes', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(ran, hasLength(1));
      expect(controller.isOpen, isFalse);
    });

    testWidgets('the first runnable row is active on open', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      // Enter straight away runs the obvious thing rather than a heading.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(ran, <String>['deploys']);
    });

    testWidgets('a command draws the shortcut it is actually bound to', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      expect(find.text('⌘'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('a query that matches nothing says so', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('No commands match'), findsOneWidget);
    });

    testWidgets('closing clears the query', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(800, 600),
      );
      controller.show();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'roll');
      await tester.pumpAndSettle();

      controller.hide();
      await tester.pumpAndSettle();
      controller.show();
      await tester.pumpAndSettle();

      // A palette reopened on last week's half-typed query has to be cleared
      // before it is useful.
      expect(find.text('Go to deploys'), findsOneWidget);
    });
  });

  group('AstryxPowerSearch', () {
    const options = <AstryxSearchFilterOption>[
      AstryxSearchFilterOption(
        field: 'status',
        label: 'Status',
        values: <String>['failed', 'running'],
      ),
    ];

    testWidgets('text and filters are reported together', (tester) async {
      var query = const AstryxSearchQuery();

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxPowerSearch(
            query: query,
            options: options,
            onChanged: (next) => setState(() => query = next),
          ),
        ),
        surfaceSize: const Size(700, 400),
      );

      await tester.enterText(find.byType(EditableText), 'bind');
      await tester.pumpAndSettle();
      expect(query.text, 'bind');

      await tester.tap(find.bySemanticsLabel('Add a filter'));
      await tester.pumpAndSettle();
      // The values are sections in one menu, not flyouts behind a hover.
      expect(find.text('Status'), findsOneWidget);
      await tester.tap(find.text('failed'));
      await tester.pumpAndSettle();

      expect(query.filters, hasLength(1));
      expect(query.filters.single.field, 'status');
      expect(query.text, 'bind', reason: 'a filter does not eat the text');
      expect(find.text('status:failed'), findsOneWidget);
    });

    testWidgets('a filter is removed from its chip', (tester) async {
      var query = const AstryxSearchQuery(
        filters: <AstryxSearchFilter>[
          AstryxSearchFilter(field: 'status', value: 'failed'),
        ],
      );

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxPowerSearch(
            query: query,
            options: options,
            onChanged: (next) => setState(() => query = next),
          ),
        ),
        surfaceSize: const Size(700, 400),
      );

      await tester.tap(find.bySemanticsLabel('Remove status:failed'));
      await tester.pumpAndSettle();

      expect(query.filters, isEmpty);
    });

    testWidgets('backspace on empty text takes the last filter back', (
      tester,
    ) async {
      var query = const AstryxSearchQuery(
        filters: <AstryxSearchFilter>[
          AstryxSearchFilter(field: 'status', value: 'failed'),
          AstryxSearchFilter(field: 'owner', value: 'ada'),
        ],
      );

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxPowerSearch(
            query: query,
            options: options,
            autofocus: true,
            onChanged: (next) => setState(() => query = next),
          ),
        ),
        surfaceSize: const Size(700, 400),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(query.filters, hasLength(1));
      expect(query.filters.single.field, 'status');
    });

    testWidgets('clearing takes the text and the filters', (tester) async {
      var query = const AstryxSearchQuery(
        text: 'bind',
        filters: <AstryxSearchFilter>[
          AstryxSearchFilter(field: 'status', value: 'failed'),
        ],
      );

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxPowerSearch(
            query: query,
            options: options,
            onChanged: (next) => setState(() => query = next),
          ),
        ),
        surfaceSize: const Size(700, 400),
      );

      await tester.tap(find.bySemanticsLabel('Clear the search'));
      await tester.pumpAndSettle();

      expect(query.isEmpty, isTrue);
    });

    testWidgets('the applied filters are announced as a count', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxPowerSearch(
          query: AstryxSearchQuery(
            filters: <AstryxSearchFilter>[
              AstryxSearchFilter(field: 'status', value: 'failed'),
              AstryxSearchFilter(field: 'owner', value: 'ada'),
            ],
          ),
          options: options,
        ),
        surfaceSize: const Size(700, 400),
      );

      // So a reader knows the field is narrowed before wondering why their
      // search found nothing.
      expect(
        tester.getSemantics(find.bySemanticsLabel('Search').first).value,
        '2 filters',
      );
      handle.dispose();
    });
  });
}
