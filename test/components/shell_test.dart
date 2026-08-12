import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The app shell and the page inside it.
///
/// Both are frames, so what is tested is where things end up: which side the
/// navigation is on at a given width, what the drawer does with focus, and
/// which parts of a page hold still while the rest of it scrolls.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxAppShell', () {
    Widget build({
      double compactBelow = 900,
      AstryxAppShellController? controller,
      Widget? sidebar = const AstryxText('Navigation'),
    }) => AstryxAppShell(
      controller: controller,
      compactBelow: compactBelow,
      navLabel: 'Sections',
      header: const AstryxText('Acme'),
      sidebar: sidebar,
      child: const AstryxText('Content'),
    );

    testWidgets('wide, the navigation sits beside the content', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(1200, 700),
      );

      expect(find.text('Navigation'), findsOneWidget);
      final nav = tester.getRect(find.text('Navigation'));
      final content = tester.getRect(find.text('Content'));
      expect(nav.center.dx, lessThan(content.center.dx));
      // And below the header, which spans the whole window.
      expect(tester.getRect(find.text('Acme')).bottom, lessThan(nav.top));
    });

    testWidgets('narrow, it is behind a drawer that is not built yet', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 700),
      );

      expect(find.text('Content'), findsOneWidget);
      // Not merely off screen: a closed overlay builds nothing at all.
      expect(find.text('Navigation'), findsNothing);
    });

    testWidgets('the controller opens the drawer, and Escape closes it', (
      tester,
    ) async {
      final controller = AstryxAppShellController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller: controller),
        surfaceSize: const Size(600, 700),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Navigation'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Navigation'), findsNothing);
      expect(controller.isOpen, isFalse);
    });

    testWidgets('the drawer closes itself when the window grows', (
      tester,
    ) async {
      final controller = AstryxAppShellController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller: controller),
        surfaceSize: const Size(600, 700),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.binding.setSurfaceSize(const Size(1200, 700));
      await tester.pumpAndSettle();

      // Otherwise the drawer would be a second copy of the navigation now
      // sitting beside the content.
      expect(controller.isOpen, isFalse);
      expect(find.text('Navigation'), findsOneWidget);
    });

    testWidgets('a descendant can read the shell and drive the drawer', (
      tester,
    ) async {
      late AstryxAppShellScope seen;

      await pumpAstryxWidget(
        tester,
        AstryxAppShell(
          sidebar: const AstryxText('Navigation'),
          child: Builder(
            builder: (context) {
              seen = AstryxAppShell.of(context);
              return AstryxButton(
                label: 'Menu',
                onPressed: seen.controller.toggle,
              );
            },
          ),
        ),
        surfaceSize: const Size(600, 700),
      );

      expect(seen.compact, isTrue);

      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      expect(find.text('Navigation'), findsOneWidget);
    });

    testWidgets('with no sidebar there is no drawer at any width', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(sidebar: null),
        surfaceSize: const Size(600, 700),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('AstryxLayout', () {
    Widget build({
      Widget? panel,
      AstryxLayoutPanelSide panelSide = AstryxLayoutPanelSide.end,
      bool scrollable = true,
    }) => AstryxLayout(
      header: const AstryxText('Deploys'),
      footer: const AstryxText('Save'),
      panel: panel,
      panelSide: panelSide,
      scrollable: scrollable,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (var i = 0; i < 30; i++) AstryxText('Row $i'),
        ],
      ),
    );

    testWidgets('the header and footer hold still while the body scrolls', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 400),
      );

      final header = tester.getRect(find.text('Deploys'));
      final footer = tester.getRect(find.text('Save'));
      final firstRow = tester.getRect(find.text('Row 0'));

      await tester.drag(find.text('Row 0'), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(tester.getRect(find.text('Deploys')), header);
      expect(tester.getRect(find.text('Save')), footer);
      // The body did move, or the test above proves nothing.
      expect(tester.getRect(find.text('Row 0')).top, lessThan(firstRow.top));
    });

    testWidgets('the panel takes the edge it is given, in both directions', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        for (final side in AstryxLayoutPanelSide.values) {
          await pumpAstryxWidget(
            tester,
            build(panel: const AstryxText('Details'), panelSide: side),
            textDirection: direction,
            surfaceSize: const Size(700, 400),
          );

          final panel = tester.getRect(find.text('Details'));
          final body = tester.getRect(find.text('Row 0'));
          final leading = panel.center.dx < body.center.dx;
          final atStart = side == AstryxLayoutPanelSide.start;
          expect(
            leading,
            direction == TextDirection.ltr ? atStart : !atStart,
            reason: '$direction, $side',
          );
        }
      }
    });

    testWidgets('the panel scrolls on its own', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(panel: const AstryxText('Details')),
        surfaceSize: const Size(700, 400),
      );

      // A panel tied to the body's scroll position is a panel that disappears
      // while you are reading it.
      expect(find.byType(Scrollable), findsNWidgets(2));
    });

    testWidgets('scrollable: false leaves the scrolling to the body', (
      tester,
    ) async {
      // A body that manages its own scrolling — a table with a pinned header
      // row, a transcript that stays at the bottom. Two scroll views inside
      // one another is one too many.
      await pumpAstryxWidget(
        tester,
        const AstryxLayout(
          header: AstryxText('Deploys'),
          scrollable: false,
          child: AstryxText('Row 0'),
        ),
        surfaceSize: const Size(600, 400),
      );

      expect(find.byType(Scrollable), findsNothing);
    });

    testWidgets('a caller-owned controller drives the body', (tester) async {
      // What an `AstryxOutline` in the panel needs: the body's scroll position
      // belongs to the layout, and tracking the reader is impossible without
      // it.
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxLayout(
          header: const AstryxText('Deploys'),
          scrollController: controller,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (var i = 0; i < 40; i++) AstryxText('Row $i'),
            ],
          ),
        ),
        surfaceSize: const Size(600, 400),
      );

      expect(controller.offset, 0);

      controller.jumpTo(120);
      await tester.pump();

      expect(controller.offset, 120);
      expect(tester.getRect(find.text('Row 0')).top, lessThan(0));
    });
  });
}
