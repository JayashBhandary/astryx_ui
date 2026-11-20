/// The sidebar: an alphabetical list of components, families folded under
/// their root, the hooks and providers in two folding sections at the end.
///
/// Each behaviour is checked here because each is the kind of thing that
/// quietly stops working: a family that opens itself, a search that hides its
/// match inside a closed family, a scrollbar that throws on desktop.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/categories.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/docs_ui/docs_sidebar.dart';
import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Pumps the app wide enough for the sidebar, on the components overview.
  Future<DocsController> pumpDocs(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    final controller = DocsScope.of(tester.element(find.byType(DocsShell)))
      ..goComponents();
    await tester.pumpAndSettle();
    return controller;
  }

  /// The sidebar row with [label].
  Finder row(String label) => find.byWidgetPredicate(
    (widget) => widget is DocsNavRow && widget.label == label,
  );

  final components = docPages
      .where((page) => docsSectionOf(page) == DocsSection.components)
      .where((page) => docCategory(page) != null);
  final families = docsComponentFamilies(components);
  final family = families.firstWhere((entry) => entry.children.isNotEmpty);
  final member = family.children.first;

  test('a family is folded under the shortest name it starts with', () {
    final button = families.firstWhere((entry) => entry.name == 'Button');
    final names = button.children.map(docDisplayName);
    expect(names, contains('Button Group'));
    // `Toggle Button Group` belongs to `Toggle Button`, not to `Button`.
    expect(names, isNot(contains('Toggle Button Group')));
  });

  test('the families are alphabetical', () {
    final names = families.map((entry) => entry.name).toList();
    expect(names, List<String>.of(names)..sort());
  });

  test('display names drop the Astryx prefix and space the words', () {
    final page = docPages.firstWhere((page) => page.id == 'button_group');
    expect(docDisplayName(page), 'Button Group');
  });

  testWidgets('families start folded', (tester) async {
    await pumpDocs(tester);

    expect(row(family.name), findsOneWidget);
    expect(row(docDisplayName(member)), findsNothing);
  });

  testWidgets('pressing a family opens it', (tester) async {
    await pumpDocs(tester);

    await tester.tap(row(family.name));
    await tester.pumpAndSettle();

    expect(row(docDisplayName(member)), findsOneWidget);
  });

  testWidgets('the family holding the current page is drawn open', (
    tester,
  ) async {
    final controller = await pumpDocs(tester);

    controller.pageId = member.id;
    await tester.pumpAndSettle();

    expect(row(docDisplayName(member)), findsOneWidget);
    // Drawn open, not opened: leaving the page folds it again.
    expect(controller.isGroupOpen('family:${family.name}'), isFalse);
  });

  testWidgets('a query lists matches inside folded families', (tester) async {
    final controller = await pumpDocs(tester);
    expect(row(docDisplayName(member)), findsNothing);

    controller.query = docDisplayName(member);
    await tester.pumpAndSettle();

    expect(row(docDisplayName(member)), findsOneWidget);
  });

  testWidgets('the sidebar follows the section', (tester) async {
    final controller = await pumpDocs(tester);
    expect(row('Overview'), findsOneWidget);

    controller.pageId = 'installation';
    await tester.pumpAndSettle();

    expect(row('Overview'), findsNothing);
    final guide = docPages.firstWhere(
      (page) => docsSectionOf(page) == DocsSection.docs,
    );
    expect(row(docDisplayName(guide)), findsOneWidget);
  });

  for (final platform in <TargetPlatform>[
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  ]) {
    testWidgets('the sidebar scrolls without a scrollbar error on $platform', (
      tester,
    ) async {
      // On a desktop or web target `PrimaryScrollController.shouldInherit` is
      // false, so a scroll view left to inherit does not attach while a
      // scrollbar left to inherit still looks there and throws. The default
      // test platform is Android, where both agree, so this has to be forced.
      debugDefaultTargetPlatformOverride = platform;
      try {
        final controller = await pumpDocs(tester);
        expect(tester.takeException(), isNull);

        for (final entry in families.where((e) => e.children.isNotEmpty)) {
          controller.toggleGroup('family:${entry.name}');
        }
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(DocsSidebar),
          const Offset(0, -400),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }

  testWidgets('the narrow layout lists only the written pages', (tester) async {
    await tester.binding.setSurfaceSize(const Size(700, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is AstryxIconButton && w.label == 'All pages',
      ),
    );
    await tester.pumpAndSettle();

    final placeholder = docPages.firstWhere((page) => !page.isWritten);
    expect(find.text(docDisplayName(placeholder)), findsNothing);
    expect(find.text('Components overview'), findsOneWidget);
  });
}
