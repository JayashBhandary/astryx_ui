/// The playground: the example picker, the theme editor's value, the export
/// and the share link.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/snippets.g.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/docs_ui/playground/playground_page.dart';
import 'package:example/docs_ui/playground/playground_theme.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Some examples animate forever (spinners, progress), so the playground
/// never settles: pump a fixed stretch instead.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  const edited = PlaygroundTheme(
    name: 'Ocean Breeze',
    base: DocsTheme.matcha,
    accent: '#0F62FE',
    neutralStyle: AstryxNeutralStyle.warm,
    colors: <String, PlaygroundColor>{
      '--color-background-card': PlaygroundColor(light: '#fafafa'),
    },
    headingFont: 'Fraunces',
    typeBase: 16,
    typeRatio: 1.25,
    radiusMultiplier: 1.5,
    spacingScale: 1.25,
    elementScale: 1.25,
    motion: 2,
  );

  group('PlaygroundTheme', () {
    test('an untouched theme is the base theme', () {
      const value = PlaygroundTheme(base: DocsTheme.stone);
      expect(value.isEdited, isFalse);
      final built = value.build();
      for (final token in <String>[
        '--color-accent',
        '--radius-element',
        '--spacing-4',
      ]) {
        expect(
          built.tokens[token],
          DocsTheme.stone.theme.tokens[token],
          reason: token,
        );
      }
    });

    test('every edit reaches the resolved tokens', () {
      final tokens = edited.build().tokens;
      expect(tokens['--radius-element'], '12px'); // 4 × 2 × 1.5
      expect(tokens['--spacing-4'], '20px'); // 16 × 1.25
      expect(tokens['--size-element-md'], '40px'); // 32 × 1.25
      expect(tokens['--font-family-heading'], contains('Fraunces'));
      expect(tokens['--duration-medium'], contains('350'));
      // A light-only override keeps the base theme's dark half.
      final (light, dark) = splitLightDark(tokens['--color-background-card']);
      expect(light, '#fafafa');
      expect(
        dark,
        splitLightDark(
          DocsTheme.matcha.theme.tokens['--color-background-card'],
        ).$2,
      );
    });

    test('survives the share link unchanged', () {
      final round = PlaygroundTheme.decode(edited.encode())!;
      expect(round.toJson(), edited.toJson());
      expect(PlaygroundTheme.decode('not base64!'), isNull);
    });

    test('exports Dart that names everything it changed', () {
      final source = edited.toDartSource();
      expect(source, contains('final AstryxDefinedTheme oceanBreezeTheme'));
      expect(source, contains('extendsTheme: matchaTheme'));
      expect(source, contains("accent: '#0F62FE'"));
      expect(source, contains('AstryxNeutralStyle.warm'));
      expect(source, contains('base: 16, ratio: 1.25'));
      expect(source, contains('multiplier: 1.5'));
      expect(source, contains("'--spacing-4': AstryxTokenValue('20px')"));
      expect(source, contains("family: 'Fraunces'"));
      expect(source, isNot(contains('\n\n')));
    });

    test('splitLightDark keeps commas inside a half', () {
      expect(
        splitLightDark('light-dark(rgba(0, 0, 0, 0.1), #fff)'),
        ('rgba(0, 0, 0, 0.1)', '#fff'),
      );
      expect(splitLightDark('#123456'), ('#123456', '#123456'));
    });
  });

  test('every example on offer has a preview and its source', () {
    expect(playgroundExamples, isNotEmpty);
    for (final example in playgroundExamples) {
      expect(docPreviews.containsKey(example.id), isTrue, reason: example.id);
      expect(docSnippets.containsKey(example.id), isTrue, reason: example.id);
    }
    expect(
      playgroundExamples.map((e) => e.id),
      contains(playgroundDefaultExample),
    );
  });

  Future<DocsController> pumpPlayground(
    WidgetTester tester, {
    Size size = const Size(1440, 1000),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();
    final controller = DocsScope.of(tester.element(find.byType(DocsShell)))
      ..goPlayground();
    await settle(tester);
    return controller;
  }

  testWidgets('the playground renders and follows the edited theme', (
    tester,
  ) async {
    final controller = await pumpPlayground(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(DocsPlayground), findsOneWidget);

    controller.playgroundTheme = edited;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    final provider = tester.widget<AstryxThemeProvider>(
      find
          .descendant(
            of: find.byType(DocsPlayground),
            matching: find.byType(AstryxThemeProvider),
          )
          .first,
    );
    expect(provider.theme!.tokens['--spacing-4'], '20px');
  });

  testWidgets('the theme editor opens and every section renders', (
    tester,
  ) async {
    await pumpPlayground(tester);
    await tester.tap(find.text('Theme editor'));
    await settle(tester);
    expect(find.byType(PlaygroundThemeEditor), findsOneWidget);
    for (final section in <String>['Type & motion', 'Advanced']) {
      await tester.tap(find.text(section));
      await settle(tester);
      expect(tester.takeException(), isNull, reason: section);
    }
  });

  testWidgets('a sample of examples renders inside the playground', (
    tester,
  ) async {
    final controller = await pumpPlayground(tester);
    final sample = <String>{
      playgroundExamples.first.id,
      playgroundExamples[playgroundExamples.length ~/ 2].id,
      playgroundExamples.last.id,
      playgroundDefaultExample,
    };
    for (final id in sample) {
      controller.playgroundExample = id;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull, reason: id);
    }
  });

  testWidgets('the narrow layout stacks without overflow', (tester) async {
    await pumpPlayground(tester, size: const Size(420, 1200));
    expect(tester.takeException(), isNull);
  });
}
