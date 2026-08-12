import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The two primitives behind the traversal and overflow hooks:
/// `AstryxRovingFocus` and `AstryxScrollOverflow`.
void main() {
  group('AstryxRovingFocus.list', () {
    /// A strip that records where the focus is and what was activated.
    Widget build({
      int length = 4,
      Axis orientation = Axis.horizontal,
      bool wrap = true,
      bool Function(int index)? isEnabled,
      required List<int> moves,
      required List<int> activated,
      FocusNode? node,
    }) => AstryxRovingFocus.list(
      length: length,
      orientation: orientation,
      wrap: wrap,
      isEnabled: isEnabled,
      focusNode: node,
      autofocus: true,
      label: 'Filters',
      onActiveChanged: moves.add,
      onActivate: activated.add,
      itemBuilder: (context, item) => SizedBox(
        width: 40,
        height: 24,
        child: AstryxText(
          '${item.index}${item.isActive ? '*' : ''}',
        ),
      ),
    );

    testWidgets('the arrows move the active item, and Enter activates it', (
      tester,
    ) async {
      final moves = <int>[];
      final activated = <int>[];

      await pumpAstryxWidget(
        tester,
        build(moves: moves, activated: activated),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      expect(find.text('0*'), findsOneWidget, reason: 'starts on the first');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('1*'), findsOneWidget);
      expect(moves, <int>[1]);

      // Moving is not selecting: nothing was activated by arrowing there.
      expect(activated, isEmpty);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(activated, <int>[1]);
    });

    testWidgets('movement wraps at the ends when asked', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(moves: <int>[], activated: <int>[]),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(find.text('3*'), findsOneWidget, reason: 'wrapped to the end');
    });

    testWidgets('and stops at the end when it does not', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(wrap: false, moves: <int>[], activated: <int>[]),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(find.text('0*'), findsOneWidget, reason: 'stayed put');
    });

    testWidgets('a disabled item is skipped, not landed on', (tester) async {
      final moves = <int>[];

      await pumpAstryxWidget(
        tester,
        build(
          isEnabled: (index) => index != 1,
          moves: moves,
          activated: <int>[],
        ),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      expect(find.text('2*'), findsOneWidget);
      expect(moves, <int>[2]);
    });

    testWidgets('Home and End reach the ends of the group', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(moves: <int>[], activated: <int>[]),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(find.text('3*'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(find.text('0*'), findsOneWidget);
    });

    testWidgets('the inline arrows mirror under RTL', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(moves: <int>[], activated: <int>[]),
        surfaceSize: const Size(400, 120),
        textDirection: TextDirection.rtl,
      );
      await tester.pumpAndSettle();

      // Right is "back" in a right-to-left strip.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('3*'), findsOneWidget);
    });

    testWidgets('the group is the only focusable node in it', (tester) async {
      final group = FocusNode(debugLabel: 'group');
      addTearDown(group.dispose);

      await pumpAstryxWidget(
        tester,
        build(node: group, moves: <int>[], activated: <int>[]),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      // One tab stop is a structural property, and this is it: the group takes
      // the focus, and nothing inside it can. Four focusable items would be
      // four tab stops — the thing the ARIA composite pattern exists to avoid.
      expect(group.hasFocus, isTrue);
      expect(
        group.descendants.where((node) => node.canRequestFocus),
        isEmpty,
        reason: 'an item that can take focus would add a tab stop',
      );
    });
  });

  group('AstryxRovingFocus.grid', () {
    Widget build({required List<int> moves}) => AstryxRovingFocus.grid(
      length: 9,
      columns: 3,
      autofocus: true,
      label: 'Days',
      onActiveChanged: moves.add,
      itemBuilder: (context, item) => SizedBox(
        width: 32,
        height: 24,
        child: AstryxText('${item.index}${item.isActive ? '*' : ''}'),
      ),
    );

    testWidgets('the block arrows move a row at a time', (tester) async {
      final moves = <int>[];

      await pumpAstryxWidget(
        tester,
        build(moves: moves),
        surfaceSize: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('3*'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('4*'), findsOneWidget);
      expect(moves, <int>[3, 4]);
    });

    testWidgets('a grid does not wrap off the end of a row', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(moves: <int>[]),
        surfaceSize: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      // From index 2 — the end of the first row — right must stop rather than
      // silently jumping to the next row.
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(find.text('2*'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('2*'), findsOneWidget);
    });

    testWidgets('Home and End are the ends of the row, not of the grid', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(moves: <int>[]),
        surfaceSize: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();

      expect(find.text('5*'), findsOneWidget, reason: 'end of the second row');
    });
  });

  group('AstryxScrollOverflow', () {
    /// A strip wider than its box, reporting its edges into [seen].
    Widget build({required List<AstryxScrollEdges> seen, double width = 200}) =>
        SizedBox(
          width: width,
          height: 60,
          child: AstryxScrollOverflow(
            onChanged: seen.add,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var i = 0; i < 20; i++)
                  SizedBox(width: 60, child: AstryxText('$i')),
              ],
            ),
          ),
        );

    testWidgets('reports more at the end, then at both, then at the start', (
      tester,
    ) async {
      final seen = <AstryxScrollEdges>[];

      await pumpAstryxWidget(
        tester,
        build(seen: seen),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      expect(seen.last.overflows, isTrue);
      expect(seen.last.hasMoreAtStart, isFalse);
      expect(seen.last.hasMoreAtEnd, isTrue);

      await tester.drag(find.byType(ListView), const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(seen.last.hasMoreAtStart, isTrue);
      expect(seen.last.hasMoreAtEnd, isTrue);

      await tester.drag(find.byType(ListView), const Offset(-2000, 0));
      await tester.pumpAndSettle();
      expect(seen.last.hasMoreAtStart, isTrue);
      expect(seen.last.hasMoreAtEnd, isFalse);
    });

    testWidgets('content that fits overflows in neither direction', (
      tester,
    ) async {
      final seen = <AstryxScrollEdges>[];

      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 300,
          height: 60,
          child: AstryxScrollOverflow(
            onChanged: seen.add,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const <Widget>[SizedBox(width: 40)],
            ),
          ),
        ),
        surfaceSize: const Size(400, 120),
      );
      await tester.pumpAndSettle();

      // Either nothing was reported, or what was reported says so.
      final edges = seen.isEmpty ? AstryxScrollEdges.none : seen.last;
      expect(edges.overflows, isFalse);
      expect(edges.hasMoreAtStart, isFalse);
      expect(edges.hasMoreAtEnd, isFalse);
    });

    testWidgets('the builder is handed the edges', (tester) async {
      AstryxScrollEdges? given;

      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 200,
          height: 60,
          child: AstryxScrollOverflow(
            builder: (context, edges, child) {
              given = edges;
              return child;
            },
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var i = 0; i < 20; i++) const SizedBox(width: 60),
              ],
            ),
          ),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      expect(given?.hasMoreAtEnd, isTrue);
    });

    testWidgets('a fade never eats a press meant for the row', (tester) async {
      var pressed = 0;

      await pumpAstryxWidget(
        tester,
        SizedBox(
          width: 200,
          height: 60,
          child: AstryxScrollOverflow(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var i = 0; i < 20; i++)
                  SizedBox(
                    width: 60,
                    child: AstryxButton(
                      label: 'Item $i',
                      onPressed: () => pressed++,
                    ),
                  ),
              ],
            ),
          ),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      // The last visible item sits under the end fade.
      await tester.tap(find.bySemanticsLabel('Item 2'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(pressed, 1);
    });
  });
}
