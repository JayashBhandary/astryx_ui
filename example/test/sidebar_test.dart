/// The sidebar's behaviour at two hundred pages.
///
/// Most of the registry is placeholders, so the sidebar has to do three things
/// a flat list did not: stay collapsed, say which pages are empty, and let
/// someone hide the empty ones. Each is checked here, because each is the kind
/// of thing that quietly stops working.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Pumps the app wide enough for the sidebar to exist.
  Future<DocsController> pumpDocs(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    return DocsScope.of(tester.element(find.byType(DocsShell)));
  }

  /// Expands [group] if it is not already open.
  ///
  /// Not `toggleGroup`: the group holding the current page starts open, so
  /// toggling it blindly closes it and the test asserts against an empty
  /// sidebar.
  Future<void> ensureOpen(
    WidgetTester tester,
    DocsController controller,
    String group,
  ) async {
    if (!controller.isGroupOpen(group)) controller.toggleGroup(group);
    await tester.pumpAndSettle();
  }

  /// A page in a group that starts collapsed, and the group it is in.
  ({DocPage page, String group}) aCollapsedPage() {
    final open = docPages.first.group;
    final page = docPages.firstWhere((page) => page.group != open);
    return (page: page, group: page.group);
  }

  testWidgets('a group other than the current one starts collapsed', (
    tester,
  ) async {
    await pumpDocs(tester);
    final target = aCollapsedPage();

    // The heading is there; its pages are not.
    expect(find.text(target.group), findsOneWidget);
    expect(find.text(target.page.title), findsNothing);
  });

  testWidgets('pressing a group heading reveals its pages', (tester) async {
    final controller = await pumpDocs(tester);
    final target = aCollapsedPage();

    await ensureOpen(tester, controller, target.group);

    expect(find.text(target.page.title), findsWidgets);
  });

  testWidgets('navigating to a page opens the group holding it', (
    tester,
  ) async {
    final controller = await pumpDocs(tester);
    final target = aCollapsedPage();

    expect(controller.isGroupOpen(target.group), isFalse);

    controller.pageId = target.page.id;
    await tester.pumpAndSettle();

    expect(controller.isGroupOpen(target.group), isTrue);
    expect(find.text(target.page.title), findsWidgets);
  });

  testWidgets('exactly the visible placeholders are badged', (tester) async {
    final controller = await pumpDocs(tester);

    // A `planned` page specifically, not merely an unwritten one: `Getting
    // started` holds three `notPlanned` placeholders and no `planned` ones, so
    // opening the first unwritten page's group can open a group with nothing to
    // count.
    final placeholder = docPages.firstWhere(
      (page) => page.status == DocStatus.planned,
    );
    controller.writtenOnly = false;
    await ensureOpen(tester, controller, placeholder.group);

    // `Soon` badges a page upstream has and this port does not. Counting them
    // rather than asserting "some exist" is what catches a badge leaking onto
    // a written page, or the group filter dropping one.
    final expected = docPages
        .where(
          (page) =>
              controller.isGroupOpen(page.group) &&
              page.status == DocStatus.planned,
        )
        .length;

    expect(expected, greaterThan(0));
    expect(find.text('Soon'), findsNWidgets(expected));
  });

  testWidgets('written-only hides the placeholders', (tester) async {
    final controller = await pumpDocs(tester);
    final placeholder = docPages.firstWhere((page) => !page.isWritten);

    await ensureOpen(tester, controller, placeholder.group);
    expect(find.text(placeholder.title), findsWidgets);

    controller.writtenOnly = true;
    await tester.pumpAndSettle();
    expect(find.text(placeholder.title), findsNothing);
  });

  testWidgets('a query reveals matches inside collapsed groups', (
    tester,
  ) async {
    final controller = await pumpDocs(tester);
    final target = aCollapsedPage();

    expect(find.text(target.page.title), findsNothing);

    controller.query = target.page.title;
    await tester.pumpAndSettle();

    // Found without anyone having expanded the group it lives in.
    expect(controller.isGroupOpen(target.group), isFalse);
    expect(find.text(target.page.title), findsWidgets);
  });

  for (final platform in <TargetPlatform>[
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  ]) {
    testWidgets('the sidebar scrolls without a scrollbar error on $platform', (
      tester,
    ) async {
      // The bug this guards: on a desktop or web target
      // `PrimaryScrollController.shouldInherit` is false, so a scroll view left
      // to inherit does not attach — while a scrollbar left to inherit still
      // looks there and throws *The Scrollbar's ScrollController has no
      // ScrollPosition attached*. The default test platform is Android, where
      // both inherit and the pair agrees, which is why the rest of the suite
      // never saw it.
      // Reset inside the body, not in `addTearDown`: the framework asserts the
      // foundation debug variables are unset before tear-downs run.
      debugDefaultTargetPlatformOverride = platform;
      try {
        final controller = await pumpDocs(tester);
        expect(tester.takeException(), isNull);

        // Enough pages on screen to actually overflow, then scroll it.
        for (final group in <String>{for (final page in docPages) page.group}) {
          await ensureOpen(tester, controller, group);
        }
        await tester.drag(
          find.byType(AstryxSwitch),
          const Offset(0, -200),
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

    await tester.tap(find.byType(AstryxIconButton).first);
    await tester.pumpAndSettle();

    final placeholder = docPages.firstWhere((page) => !page.isWritten);
    expect(find.text(placeholder.title), findsNothing);
    expect(find.text(docPages.first.title), findsWidgets);
  });
}
