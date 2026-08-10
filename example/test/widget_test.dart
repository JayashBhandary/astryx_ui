import 'package:example/docs/pages.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/snippets.g.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the docs app boots on the first page', (tester) async {
    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    expect(find.text(docPages.first.title), findsWidgets);
  });

  test('every example referenced by a page exists', () {
    final referenced = <String>{
      for (final page in docPages)
        for (final block in page.blocks)
          if (block is DocExample) block.snippetId,
    };

    for (final id in referenced) {
      expect(
        docSnippets.containsKey(id),
        isTrue,
        reason: 'No snippet for "$id". Run `dart run tool/gen_snippets.dart`.',
      );
      expect(
        docPreviews.containsKey(id),
        isTrue,
        reason: 'No preview for "$id". Run `dart run tool/gen_snippets.dart`.',
      );
    }
  });

  test('every extracted example is documented somewhere', () {
    final referenced = <String>{
      for (final page in docPages)
        for (final block in page.blocks)
          if (block is DocExample) block.snippetId,
    };

    expect(
      docSnippets.keys.toSet().difference(referenced),
      isEmpty,
      reason: 'These examples compile but no page shows them.',
    );
  });

  test('page ids are unique', () {
    final ids = docPages.map((page) => page.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  testWidgets('every page renders in the wide layout', (tester) async {
    // Wide enough for the sidebar, which the default 800×600 surface hides.
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    final controller = DocsScope.of(
      tester.element(find.byType(DocsShell)),
    );

    for (final page in docPages) {
      controller.pageId = page.id;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull, reason: page.id);
    }
  });

  testWidgets('every preview builds', (tester) async {
    // The cheapest possible check that 150-odd examples are not just
    // well-typed but actually renderable.
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final entry in docPreviews.entries) {
      await tester.pumpWidget(
        DocsPreviewHarness(child: Builder(builder: entry.value)),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });
}
