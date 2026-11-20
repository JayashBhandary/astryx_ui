/// The Themes page: a picker of drawn theme cards, and Studio rendered in the
/// picked theme while the site keeps its own.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/docs_ui/studio_showcase.dart';
import 'package:example/docs_ui/themes_page.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<DocsController> pumpThemes(
    WidgetTester tester, {
    Size size = const Size(1440, 1000),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();
    final controller = DocsScope.of(tester.element(find.byType(DocsShell)))
      ..pageId = docsThemesPageId;
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets('the page shows a card per theme and the Studio preview', (
    tester,
  ) async {
    await pumpThemes(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(DocsThemesPage), findsOneWidget);
    expect(find.byType(DocsThemeCard), findsNWidgets(DocsTheme.values.length));
    expect(find.byType(StudioShowcase), findsOneWidget);
  });

  testWidgets('picking a card re-themes the preview, not the site', (
    tester,
  ) async {
    final controller = await pumpThemes(tester);
    final siteTheme = controller.theme;

    final matcha = find.byWidgetPredicate(
      (w) => w is DocsThemeCard && w.theme == DocsTheme.matcha,
    );
    await tester.ensureVisible(matcha);
    await tester.pumpAndSettle();
    await tester.tap(matcha);
    await tester.pumpAndSettle();

    expect(controller.previewTheme, DocsTheme.matcha);
    expect(controller.theme, siteTheme);
    final provider = tester.widget<AstryxThemeProvider>(
      find
          .ancestor(
            of: find.byType(StudioShowcase),
            matching: find.byType(AstryxThemeProvider),
          )
          .first,
    );
    expect(provider.theme, DocsTheme.matcha.theme);
  });

  testWidgets('every theme renders the preview in both modes', (tester) async {
    final controller = await pumpThemes(tester);
    for (final mode in <AstryxColorMode>[
      AstryxColorMode.light,
      AstryxColorMode.dark,
    ]) {
      controller.previewMode = mode;
      for (final theme in DocsTheme.values) {
        controller.previewTheme = theme;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull, reason: '$theme $mode');
      }
    }
  });

  testWidgets('the narrow layout stacks without overflow', (tester) async {
    await pumpThemes(tester, size: const Size(420, 1400));
    expect(tester.takeException(), isNull);
    expect(find.byType(StudioShowcase), findsOneWidget);
  });

  test('the install line names the shipped theme', () {
    expect(docsUseThemeSnippet(DocsTheme.matcha), contains('matchaTheme'));
    expect(docsUseThemeSnippet(DocsTheme.acme), contains('defineTheme'));
  });
}
