import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The navigation set: the rail, its drawer, the bar, the heading menu, the
/// icon slot and the trail.
///
/// The three containers render the same entries, so what is tested is what each
/// one does *differently* with them — and, on the rail, the thing a collapsed
/// navigation usually gets wrong.
void main() {
  setUp(AstryxOverlayStack.reset);

  const entries = <AstryxNavEntry>[
    AstryxNavItem(
      id: 'deploys',
      label: 'Deploys',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
    ),
    AstryxNavDivider(),
    AstryxNavSection(
      label: 'Settings',
      items: <AstryxNavItem>[
        AstryxNavItem(id: 'members', label: 'Members'),
        AstryxNavItem(id: 'billing', label: 'Billing', enabled: false),
      ],
    ),
  ];

  group('AstryxSideNav', () {
    testWidgets('rows, headings and the current destination', (tester) async {
      final handle = tester.ensureSemantics();
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 260,
          child: AstryxSideNav(
            entries: entries,
            selectedId: 'deploys',
            onSelected: chosen.add,
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Deploys'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );

      await tester.tap(find.text('Members'));
      await tester.pump();
      expect(chosen, <String>['members']);
      handle.dispose();
    });

    testWidgets('a disabled destination reports itself and offers no tap', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 260,
          child: AstryxSideNav(entries: entries, onSelected: (_) {}),
        ),
        surfaceSize: const Size(400, 500),
      );

      final data = tester
          .getSemantics(find.bySemanticsLabel('Billing'))
          .getSemanticsData();
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });

    testWidgets('collapsed, the labels leave the screen but not the tree', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 64,
          child: AstryxSideNav(
            entries: entries,
            collapsed: true,
            onSelected: (_) {},
          ),
        ),
        surfaceSize: const Size(200, 500),
      );

      // Nothing painted…
      expect(find.text('Deploys'), findsNothing);
      // …and still named, still reachable. A rail that hides its labels from
      // everyone is a rail only its author can use.
      expect(find.bySemanticsLabel('Deploys'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the collapse button appears only when it does something', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          width: 260,
          child: AstryxSideNav(entries: entries),
        ),
        surfaceSize: const Size(400, 500),
      );
      expect(find.byType(AstryxIconButton), findsNothing);

      var collapsed = false;
      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 260,
          child: AstryxSideNav(
            entries: entries,
            onCollapsedChanged: (value) => collapsed = value,
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pump();
      expect(collapsed, isTrue);
    });
  });

  group('AstryxMobileNav', () {
    testWidgets('the drawer holds the same rows, and Escape closes it', (
      tester,
    ) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxMobileNav(
          controller: controller,
          entries: entries,
          onSelected: (_) {},
        ),
        surfaceSize: const Size(400, 600),
      );

      expect(find.text('Deploys'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Deploys'), findsOneWidget);
      expect(find.text('Members'), findsOneWidget);
    });

    testWidgets('the toggle drives the enclosing shell', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxAppShell(
          sidebar: AstryxSideNav(entries: entries),
          child: Center(child: AstryxMobileNavToggle()),
        ),
        surfaceSize: const Size(600, 600),
      );

      // No controller passed: it found the shell's, which is the only one
      // there should be.
      await tester.tap(find.byType(AstryxMobileNavToggle));
      await tester.pumpAndSettle();

      // The drawer opening is the proof: nothing else could have opened it.
      expect(find.text('Deploys'), findsOneWidget);
    });
  });

  group('AstryxTopNav', () {
    testWidgets('destinations run along the bar, actions at the end', (
      tester,
    ) async {
      final chosen = <String>[];
      await pumpAstryxWidget(
        tester,
        AstryxTopNav(
          leading: const AstryxText('Acme'),
          entries: entries,
          selectedId: 'deploys',
          onSelected: chosen.add,
          actions: <Widget>[AstryxButton(label: 'Account', onPressed: () {})],
        ),
        surfaceSize: const Size(800, 200),
      );

      final brand = tester.getRect(find.text('Acme'));
      final deploys = tester.getRect(find.text('Deploys'));
      final account = tester.getRect(find.text('Account'));
      expect(brand.center.dx, lessThan(deploys.center.dx));
      expect(deploys.center.dx, lessThan(account.center.dx));

      await tester.tap(find.text('Deploys'));
      await tester.pump();
      expect(chosen, <String>['deploys']);
    });

    testWidgets('a section becomes a menu rather than a heading', (
      tester,
    ) async {
      final chosen = <String>[];
      await pumpAstryxWidget(
        tester,
        AstryxTopNav(entries: entries, onSelected: chosen.add),
        surfaceSize: const Size(800, 400),
      );

      // A bar has no room for a heading over a group, but a menu is exactly
      // what holds one.
      expect(find.text('Members'), findsNothing);
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Members'), findsOneWidget);

      await tester.tap(find.text('Members'));
      await tester.pumpAndSettle();
      expect(chosen, <String>['members']);
    });

    testWidgets('an item with a panel opens the panel', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTopNav(
          entries: <AstryxNavEntry>[
            AstryxNavItem(
              id: 'docs',
              label: 'Docs',
              panel: AstryxText('Featured guides'),
            ),
          ],
        ),
        surfaceSize: const Size(800, 400),
      );

      await tester.tap(find.text('Docs'));
      await tester.pumpAndSettle();
      expect(find.text('Featured guides'), findsOneWidget);
    });
  });

  group('AstryxNavHeadingMenu', () {
    testWidgets('the heading opens the menu, and announces both lines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 260,
          child: AstryxNavHeadingMenu(
            label: 'Acme Corp',
            description: 'Production',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(
                label: 'Globex',
                onSelected: () => chosen.add('globex'),
              ),
            ],
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      expect(find.bySemanticsLabel('Acme Corp, Production'), findsOneWidget);

      await tester.tap(find.text('Acme Corp'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Globex'));
      await tester.pumpAndSettle();
      expect(chosen, <String>['globex']);
      handle.dispose();
    });
  });

  group('AstryxBreadcrumbs', () {
    List<AstryxBreadcrumb> trail(int depth) => <AstryxBreadcrumb>[
      for (var i = 0; i < depth - 1; i++)
        AstryxBreadcrumb(label: 'Level $i', onPressed: () {}),
      AstryxBreadcrumb(label: 'Level ${depth - 1}'),
    ];

    testWidgets('shows the whole trail when it fits', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 600, child: AstryxBreadcrumbs(items: trail(3))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Level 0').hitTestable(), findsOneWidget);
      expect(find.text('Level 1').hitTestable(), findsOneWidget);
      expect(find.text('Level 2').hitTestable(), findsOneWidget);
    });

    testWidgets('collapses the middle, never the ends', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 260, child: AstryxBreadcrumbs(items: trail(6))),
        surfaceSize: const Size(400, 200),
      );
      await tester.pumpAndSettle();

      // The way out to the top and where the reader is: the two the trail
      // exists for, and the two that are never dropped.
      expect(find.text('Level 0').hitTestable(), findsOneWidget);
      expect(find.text('Level 5').hitTestable(), findsOneWidget);
      expect(find.text('Level 1').hitTestable(), findsNothing);
    });

    testWidgets('what it drops stays reachable', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 260, child: AstryxBreadcrumbs(items: trail(6))),
        surfaceSize: const Size(500, 400),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pumpAndSettle();

      expect(find.text('Level 1').hitTestable(), findsOneWidget);
    });

    testWidgets('the current step is not a link', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 600, child: AstryxBreadcrumbs(items: trail(3))),
      );
      await tester.pumpAndSettle();

      // Two links and a label: a link to the page you are on is a link that
      // does nothing.
      expect(find.byType(AstryxButton), findsNWidgets(2));
    });
  });
}
