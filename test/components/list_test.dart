import 'dart:ui' show SemanticsRole, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The data-display lists: the row, the list, the tree, the overflow row, the
/// metadata pairs and the empty state.
///
/// Each is tested on what makes it different from the widget it resembles — a
/// tree that is one tab stop rather than forty, an overflow row that keeps what
/// it hides reachable, an empty state that is deliberately *not* an alert.
void main() {
  group('AstryxItem', () {
    testWidgets('an inert row is not a button', (tester) async {
      await pumpAstryxWidget(tester, const AstryxItem(label: 'Ada'));

      expect(
        find.descendant(
          of: find.byType(AstryxItem),
          matching: find.byWidgetPredicate(
            (w) => w is Semantics && (w.properties.button ?? false),
          ),
        ),
        findsNothing,
      );
    });

    testWidgets('onPressed makes it a button, and it fires', (tester) async {
      final handle = tester.ensureSemantics();
      var pressed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxItem(
          label: 'Ada',
          description: 'Owner',
          onPressed: () => pressed++,
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxItem));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.label, 'Ada');
      expect(node.hint, 'Owner');

      await tester.tap(find.byType(AstryxItem));
      await tester.pump();
      expect(pressed, 1);
      handle.dispose();
    });

    testWidgets('Enter and Space activate it', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var pressed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxItem(
          label: 'Ada',
          focusNode: node,
          autofocus: true,
          onPressed: () => pressed++,
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressed, 2);
    });

    testWidgets('selection is announced, and absent when there is none', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      for (final selected in <bool>[true, false]) {
        await pumpAstryxWidget(
          tester,
          AstryxItem(label: 'Ada', selected: selected, onPressed: () {}),
        );

        expect(
          tester
              .getSemantics(find.byType(AstryxItem))
              .flagsCollection
              .isSelected,
          // Absent rather than false: a list of links has nothing to say about
          // selection, and "not selected" on every row is noise.
          selected ? Tristate.isTrue : Tristate.none,
          reason: 'selected: $selected',
        );
      }
      handle.dispose();
    });

    testWidgets('a disabled row reports itself disabled and offers no tap', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxItem(label: 'Ada', enabled: false, onPressed: () {}),
      );

      final data = tester
          .getSemantics(find.byType(AstryxItem))
          .getSemanticsData();
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('the enclosing list sets the density', (tester) async {
      double heightOf(AstryxItemDensity density) {
        return tester.getSize(find.byType(AstryxItem).first).height;
      }

      await pumpAstryxWidget(
        tester,
        const AstryxList(children: <Widget>[AstryxItem(label: 'Ada')]),
        // The row's padding animates, so a measurement taken a frame after the
        // density changed would still be reading the old one.
        disableAnimations: true,
      );
      final balanced = heightOf(AstryxItemDensity.balanced);

      await pumpAstryxWidget(
        tester,
        const AstryxList(
          density: AstryxItemDensity.compact,
          children: <Widget>[AstryxItem(label: 'Ada')],
        ),
        disableAnimations: true,
      );
      final compact = heightOf(AstryxItemDensity.compact);

      expect(compact, lessThan(balanced));
    });
  });

  group('AstryxList', () {
    testWidgets('announces itself as a list, with a name', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxList(
          label: 'Team',
          children: <Widget>[
            AstryxItem(label: 'Ada'),
            AstryxItem(label: 'Alan'),
          ],
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxList));
      expect(node.role, SemanticsRole.list);
      expect(node.label, 'Team');
      handle.dispose();
    });

    testWidgets('draws a rule between rows, never before the first', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxList(
          showDividers: true,
          children: <Widget>[
            AstryxItem(label: 'Ada'),
            AstryxItem(label: 'Alan'),
            AstryxItem(label: 'Grace'),
          ],
        ),
      );

      expect(find.byType(AstryxDivider), findsNWidgets(2));
    });

    testWidgets('shows the empty widget instead of nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxList(
          empty: AstryxEmptyState(title: 'No one here'),
          children: <Widget>[],
        ),
      );

      expect(find.text('No one here'), findsOneWidget);
    });
  });

  group('AstryxTreeList', () {
    const nodes = <AstryxTreeNode>[
      AstryxTreeNode(
        id: 'lib',
        label: 'lib',
        children: <AstryxTreeNode>[
          AstryxTreeNode(id: 'main', label: 'main.dart'),
          AstryxTreeNode(id: 'app', label: 'app.dart'),
        ],
      ),
      AstryxTreeNode(id: 'readme', label: 'README.md'),
    ];

    testWidgets('a collapsed branch builds none of its children', (
      tester,
    ) async {
      await pumpAstryxWidget(tester, const AstryxTreeList(nodes: nodes));

      expect(find.text('lib'), findsOneWidget);
      expect(find.text('main.dart'), findsNothing);
    });

    testWidgets('initiallyExpanded opens a branch', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTreeList(
          nodes: nodes,
          initiallyExpanded: <String>{'lib'},
        ),
      );

      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('pressing a branch opens it and chooses it', (tester) async {
      final chosen = <String>[];
      await pumpAstryxWidget(
        tester,
        AstryxTreeList(nodes: nodes, onSelectedChanged: chosen.add),
      );

      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();

      expect(find.text('main.dart'), findsOneWidget);
      expect(chosen, <String>['lib']);
    });

    testWidgets('the whole tree is one tab stop', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTreeList(
          nodes: nodes,
          initiallyExpanded: <String>{'lib'},
        ),
      );

      // Four visible rows, one focusable node. A tree whose every row were its
      // own tab stop would take four presses to walk past.
      final stops = tester
          .widgetList<Focus>(find.byType(Focus))
          .where((focus) => focus.canRequestFocus && !focus.skipTraversal)
          .length;
      expect(stops, 1);
    });

    testWidgets('the arrows move, open and close', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        AstryxTreeList(
          nodes: nodes,
          focusNode: node,
          autofocus: true,
          onSelectedChanged: chosen.add,
        ),
      );
      await tester.pump();

      // Right opens the branch the roving focus starts on.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('main.dart'), findsOneWidget);

      // Right again steps into it; Enter chooses what is there.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(chosen, <String>['main']);

      // Left steps back out to the parent, and Left again closes it.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('main.dart'), findsNothing);
    });

    testWidgets('the arrows mirror under RTL', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTreeList(nodes: nodes, focusNode: node, autofocus: true),
        textDirection: TextDirection.rtl,
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('a branch reports whether it is open; a leaf says nothing', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxTreeList(
          nodes: nodes,
          initiallyExpanded: <String>{'lib'},
        ),
      );

      expect(
        tester
            .getSemantics(find.bySemanticsLabel('lib'))
            .flagsCollection
            .isExpanded,
        Tristate.isTrue,
      );
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('README.md'))
            .flagsCollection
            .isExpanded,
        Tristate.none,
      );
      handle.dispose();
    });

    testWidgets('a controlled tree does not open itself', (tester) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        AstryxTreeList(
          nodes: nodes,
          expanded: const <String>{},
          onExpandedChanged: reported.add,
        ),
      );

      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();

      // The caller was told, and nothing moved until they say so.
      expect(reported, <Set<String>>[
        <String>{'lib'},
      ]);
      expect(find.text('main.dart'), findsNothing);
    });
  });

  group('AstryxOverflowList', () {
    List<AstryxOverflowItem> items(int count) => <AstryxOverflowItem>[
      for (var i = 0; i < count; i++)
        AstryxOverflowItem(
          label: 'Item $i',
          child: SizedBox(width: 100, height: 24, child: AstryxText('Item $i')),
        ),
    ];

    testWidgets('shows everything when there is room', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 400, child: AstryxOverflowList(items: items(3))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Item 2').hitTestable(), findsOneWidget);
      // Not an invisible one, either: with nothing hidden there is no trigger
      // in the tree at all.
      expect(find.textContaining('more'), findsNothing);
    });

    testWidgets('moves the tail into a menu when it does not', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 260, child: AstryxOverflowList(items: items(5))),
      );
      await tester.pumpAndSettle();

      // The trigger names what it swallowed, and the swallowed items are no
      // longer on the row: not painted, and not hit-testable.
      expect(find.text('+4 more').hitTestable(), findsOneWidget);
      expect(find.text('Item 4').hitTestable(), findsNothing);
    });

    testWidgets('a hidden item is not read twice', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 260, child: AstryxOverflowList(items: items(5))),
      );
      await tester.pumpAndSettle();

      // Without the semantics walk skipping them, a screen reader would read
      // the items that did not fit *and* the menu rows standing in for them.
      expect(find.bySemanticsLabel('Item 4'), findsNothing);
      handle.dispose();
    });

    testWidgets('what it hides is still reachable', (tester) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 260, child: AstryxOverflowList(items: items(5))),
        surfaceSize: const Size(400, 400),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('+4 more'));
      await tester.pumpAndSettle();

      // Unreachable on the row, reachable in the menu — the whole difference
      // between this and clipping.
      expect(find.text('Item 4').hitTestable(), findsOneWidget);
    });

    testWidgets('minVisible keeps a row from collapsing to nothing', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 60, child: AstryxOverflowList(items: items(4))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Item 0').hitTestable(), findsOneWidget);
    });
  });

  group('AstryxMetadataList', () {
    testWidgets('reads a pair as one fact', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxMetadataList(
          items: <AstryxMetadataItem>[
            AstryxMetadataItem.text(label: 'Owner', value: 'Ada Lovelace'),
          ],
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Owner'));
      expect(node.value, 'Ada Lovelace');
      handle.dispose();
    });

    testWidgets('a widget value announces what the caller says it is', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxMetadataList(
          items: <AstryxMetadataItem>[
            AstryxMetadataItem(
              label: 'Status',
              value: AstryxBadge('Live'),
              semanticsValue: 'Live',
            ),
          ],
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Status')).value,
        'Live',
      );
      handle.dispose();
    });

    testWidgets('inline puts the label beside the value', (tester) async {
      for (final direction in AstryxMetadataListDirection.values) {
        await pumpAstryxWidget(
          tester,
          SizedBox(
            width: 360,
            child: AstryxMetadataList(
              direction: direction,
              items: <AstryxMetadataItem>[
                AstryxMetadataItem.text(label: 'Owner', value: 'Ada'),
              ],
            ),
          ),
        );

        final label = tester.getRect(find.text('Owner'));
        final value = tester.getRect(find.text('Ada'));
        expect(
          value.top >= label.bottom,
          direction == AstryxMetadataListDirection.stacked,
          reason: '$direction',
        );
      }
    });
  });

  group('AstryxEmptyState', () {
    testWidgets('shows the title, the reason and the way out', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxEmptyState(
          title: 'No deploys yet',
          description: 'Ship something and it will show up here.',
          icon: const AstryxIcon(AstryxIconName.search),
          actions: <Widget>[AstryxButton(label: 'Deploy', onPressed: () {})],
        ),
        surfaceSize: const Size(500, 500),
      );

      expect(find.text('No deploys yet'), findsOneWidget);
      expect(find.text('Ship something and it will show up here.'), findsOne);
      expect(find.text('Deploy'), findsOneWidget);
    });

    testWidgets('is not an alert, and its icon is not read', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxEmptyState(
          title: 'No deploys yet',
          icon: AstryxIcon(AstryxIconName.search, label: 'Search'),
        ),
        surfaceSize: const Size(500, 500),
      );

      // Nothing has gone wrong when a new project has no deploys, so nothing
      // announces itself and the decorative icon stays out of the tree.
      expect(find.bySemanticsLabel('Search'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.liveRegion ?? false),
        ),
        findsNothing,
      );
      handle.dispose();
    });
  });
}
