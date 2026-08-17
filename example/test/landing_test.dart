/// The front page, which is the one page most readers see.
///
/// Three things it has been wrong about before, each cheap to check and none
/// of them caught by "the app boots": the version it quotes, whether the two
/// links off the site are findable, and whether the whole thing survives a
/// phone's width.
library;

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

    // The cards are the tap target, so the semantics are the whole of what a
    // screen-reader user gets: the destination, and that it leaves the site.
    for (final host in const <String>[
      'pub.dev/packages/astryx_ui',
      'github.com/JayashBhandary/astryx_ui',
    ]) {
      expect(find.text(host), findsOneWidget, reason: host);
      expect(
        find.bySemanticsLabel(RegExp('Opens $host in a new tab')),
        findsOneWidget,
        reason: host,
      );
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
