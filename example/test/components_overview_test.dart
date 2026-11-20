/// The `/components` overview and the component page tabs.
library;

import 'package:example/docs/categories.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/components_overview.dart';
import 'package:example/docs_ui/doc_page_view.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every written component page has an overview category', () {
    // A component page with no category has no tile, and nobody browsing the
    // overview would find it. Guides, hooks, providers and templates are not
    // components, so they are exempt.
    const exempt = <String>{
      DocGroup.gettingStarted,
      DocGroup.hooks,
      DocGroup.providers,
      DocGroup.templates,
    };
    final missing = writtenDocPages
        .where((page) => !exempt.contains(page.group))
        .where((page) => docCategory(page) == null)
        .map((page) => page.id)
        .toList();
    expect(missing, isEmpty, reason: 'Add these to docCategoryOf.');
  });

  test('every categorised id is a real page', () {
    final ids = <String>{for (final page in docPages) page.id};
    expect(docCategoryOf.keys.where((id) => !ids.contains(id)), isEmpty);
  });

  test('categories follow upstream order and every tile has a preview', () {
    final tiles = docsOverviewTiles();
    expect(
      tiles.keys.toList(),
      DocCategory.all.where(tiles.containsKey).toList(),
    );
    final noExample = <String>[
      for (final list in tiles.values)
        for (final tile in list)
          if (tile.example == null) tile.page.id,
    ];
    expect(noExample, isEmpty, reason: 'These tiles would be blank.');
  });

  testWidgets('every tile renders without overflowing its canvas', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final failed = <String>[];
    for (final list in docsOverviewTiles().values) {
      for (final tile in list) {
        await tester.pumpWidget(
          DocsPreviewHarness(
            child: SizedBox(width: 340, child: DocsComponentTile(tile)),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        final error = tester.takeException();
        if (error != null) {
          failed.add('${tile.page.id}: ${'$error'.split('\n').first}');
        }
      }
    }
    expect(
      failed,
      isEmpty,
      reason: 'Give these a larger canvas in docsTileCanvasOverrides.',
    );
  });

  testWidgets('the overview renders, and a tile opens its page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();
    final controller = DocsScope.of(tester.element(find.byType(DocsShell)))
      ..goComponents();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(DocsComponentsOverview), findsOneWidget);
    expect(find.text('Browse the library'), findsOneWidget);
    expect(find.text(DocCategory.action), findsOneWidget);

    await tester.tap(find.byType(DocsComponentTile).first);
    await tester.pumpAndSettle();

    expect(controller.onComponentsOverview, isFalse);
    expect(docCategory(controller.page.page), isNotNull);
  });

  testWidgets('the overview scrolls through every category cleanly', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();
    DocsScope.of(tester.element(find.byType(DocsShell))).goComponents();
    await tester.pumpAndSettle();

    for (var i = 0; i < 40; i++) {
      await tester.drag(
        find.byType(DocsComponentsOverview),
        const Offset(0, -600),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull, reason: 'scroll step $i');
    }
  });

  group('page tabs', () {
    test('API tables go to Properties, keyboard notes to Accessibility', () {
      final button = docPages.firstWhere((page) => page.id == 'button');
      final split = docsSplitTabs(button.blocks);

      expect(split[DocsPageTab.properties]!.whereType<DocApi>(), isNotEmpty);
      expect(split[DocsPageTab.overview]!.whereType<DocApi>(), isEmpty);
      // Nothing lost and nothing duplicated.
      expect(
        split.values.fold<int>(0, (sum, list) => sum + list.length),
        button.blocks.length,
      );
    });

    testWidgets('a component page shows the tabs, a guide does not', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const DocsApp());
      await tester.pumpAndSettle();
      final controller = DocsScope.of(tester.element(find.byType(DocsShell)))
        ..pageId = 'button';
      await tester.pumpAndSettle();

      expect(find.text('Overview'), findsWidgets);
      expect(find.text('Properties'), findsOneWidget);

      await tester.tap(find.text('Properties'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      controller.pageId = 'installation';
      await tester.pumpAndSettle();
      expect(find.text('Properties'), findsNothing);
    });
  });
}
