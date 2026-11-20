/// The front page, which is the one page most readers see.
///
/// Three things it has been wrong about before, each cheap to check and none
/// of them caught by "the app boots": the version it quotes, whether the two
/// links off the site are findable, and whether the whole thing survives a
/// phone's width.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/version.g.dart';
import 'package:example/docs_ui/docs_landing.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the install command quotes the generated version', (
    tester,
  ) async {
    // Typed by hand, the hero once said `0.0.6-dev` two releases after that
    // stopped being true. An install command is the one place on the page
    // where being out of date resolves to the wrong package.
    expect(installCommand, contains(astryxVersion));

    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    expect(find.text(installCommand), findsWidgets);
    expect(find.textContaining(astryxVersion), findsWidgets);
  });

  testWidgets('pub.dev and GitHub say where they go', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    // The footer's buttons are glyphs, so the semantics are the whole of
    // what a screen-reader user gets: the destination, and that it leaves.
    for (final host in const <String>[
      'pub.dev/packages/astryx_ui',
      'github.com/JayashBhandary/astryx_ui',
    ]) {
      expect(
        find.bySemanticsLabel(RegExp('Opens $host in a new tab')),
        findsWidgets,
        reason: host,
      );
    }
  });

  testWidgets('the hero cycles themes and the dots pick one', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    String accent() => tester
        .widget<AstryxThemeProvider>(
          find
              .descendant(
                of: find.byType(LandingHero),
                matching: find.byType(AstryxThemeProvider),
              )
              .first,
        )
        .theme!
        .name;

    expect(accent(), landingHeroSlides.first.$1.theme.name);
    await tester.pump(LandingHero.slideDuration);
    await tester.pumpAndSettle();
    expect(accent(), landingHeroSlides[1].$1.theme.name);

    final last = landingHeroSlides.last.$1;
    await tester.tap(find.bySemanticsLabel('Show ${last.label}'));
    await tester.pumpAndSettle();
    expect(accent(), last.theme.name);
    expect(tester.takeException(), isNull);
  });

  test('release notes are cut from the changelog', () {
    final latest = landingLatest;
    expect(latest.notes, isNotEmpty);
    for (final note in latest.notes) {
      expect(note.title, isNot(contains('**')));
      expect(note.title, isNotEmpty);
    }
    expect(
      landingNote('**Bold title.** And the rest.'),
      (title: 'Bold title', body: 'And the rest.'),
    );
  });

  test('every landing template has a preview', () {
    for (final id in landingTemplateIds) {
      expect(landingTemplateSnippet(id), isNotNull, reason: id);
    }
  });

  testWidgets('every count on the page is read from the registry', (
    tester,
  ) async {
    // Not the figures themselves — those change every release — but that they
    // were counted at all. A zero here means the groups were renamed and the
    // page is quietly claiming the package is empty.
    expect(landingCounts.components, greaterThan(0));
    expect(landingCounts.templates, greaterThan(0));
    expect(landingCounts.hooks, greaterThan(0));
    expect(landingCounts.themes, greaterThan(0));
  });

  for (final width in const <double>[820, 1100, 1440]) {
    testWidgets('the landing page lays out at $width', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const DocsApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the landing page survives a phone', (tester) async {
    // Tall, because the check is for an overflowing row rather than for what
    // is above the fold, and a widget that is never laid out cannot overflow.
    await tester.binding.setSurfaceSize(const Size(390, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    expect(find.byType(DocsLanding), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
