import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The three pieces of page structure: the titled band, the drag target
/// between two regions, and the table of contents that follows the reader.
void main() {
  group('AstryxSection', () {
    /// The level [AstryxHeading] was actually given.
    int levelOf(WidgetTester tester, String title) => tester
        .widget<AstryxHeading>(
          find.ancestor(
            of: find.text(title),
            matching: find.byType(AstryxHeading),
          ),
        )
        .level;

    testWidgets('nesting sets the heading level', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSection(
          title: 'Environments',
          child: AstryxSection(
            title: 'Production',
            child: AstryxSection(title: 'Regions', child: AstryxText('…')),
          ),
        ),
        surfaceSize: const Size(500, 400),
      );

      // A page assembled from parts nobody wrote together still produces an
      // outline a screen reader can navigate.
      expect(levelOf(tester, 'Environments'), 2);
      expect(levelOf(tester, 'Production'), 3);
      expect(levelOf(tester, 'Regions'), 4);
    });

    testWidgets('an explicit level wins, and the nesting resumes from it', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSection(
          title: 'Environments',
          level: 4,
          child: AstryxSection(title: 'Production', child: AstryxText('…')),
        ),
        surfaceSize: const Size(500, 400),
      );

      expect(levelOf(tester, 'Environments'), 4);
      expect(levelOf(tester, 'Production'), 5);
    });

    testWidgets('the level stops where headings stop meaning anything', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSection(
          title: 'Deep',
          level: 6,
          child: AstryxSection(title: 'Deeper', child: AstryxText('…')),
        ),
        surfaceSize: const Size(500, 400),
      );

      expect(levelOf(tester, 'Deeper'), 6);
    });

    testWidgets('description and actions sit in the heading row', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxSection(
          title: 'Environments',
          description: 'Where this project is deployed.',
          actions: <Widget>[AstryxButton(label: 'New', onPressed: () {})],
          child: const AstryxText('Body'),
        ),
        surfaceSize: const Size(500, 400),
      );

      final title = tester.getRect(find.text('Environments'));
      expect(
        tester.getRect(find.text('New')).center.dx,
        greaterThan(title.center.dx),
      );
      expect(
        tester.getRect(find.text('Body')).top,
        greaterThan(title.bottom),
      );
    });
  });

  group('AstryxResizeHandle', () {
    testWidgets('a drag reports the new size, clamped', (tester) async {
      final sizes = <double>[];

      await pumpAstryxWidget(
        tester,
        Row(
          children: <Widget>[
            SizedBox(width: 200, child: Container()),
            AstryxResizeHandle(
              label: 'Resize the filters',
              size: 200,
              min: 120,
              max: 240,
              onResize: sizes.add,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );

      await tester.drag(
        find.byType(AstryxResizeHandle),
        const Offset(60, 0),
      );
      await tester.pump();

      // A panel at the start grows as the handle moves away from it, and stops
      // at `max` rather than running past it.
      expect(sizes, isNotEmpty);
      expect(sizes.last, 240);
    });

    testWidgets('the drag direction mirrors under RTL', (tester) async {
      for (final direction in TextDirection.values) {
        final sizes = <double>[];
        await pumpAstryxWidget(
          tester,
          Row(
            children: <Widget>[
              AstryxResizeHandle(
                label: 'Resize',
                size: 200,
                max: 400,
                onResize: sizes.add,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          textDirection: direction,
        );

        await tester.drag(
          find.byType(AstryxResizeHandle),
          const Offset(40, 0),
        );
        await tester.pump();

        // The same physical drag grows the panel under LTR and shrinks it
        // under RTL, because "away from the start edge" changed sides.
        expect(
          sizes.last > 200,
          direction == TextDirection.ltr,
          reason: '$direction reported ${sizes.last}',
        );
      }
    });

    testWidgets('the arrow keys move it, and Home and End reach the ends', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final sizes = <double>[];

      await pumpAstryxWidget(
        tester,
        Row(
          children: <Widget>[
            AstryxResizeHandle(
              label: 'Resize',
              focusNode: node,
              autofocus: true,
              size: 200,
              min: 120,
              max: 400,
              onResize: sizes.add,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(sizes.last, 216);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(sizes.last, 120);
    });

    testWidgets('it announces itself as a slider carrying the size', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        Row(
          children: <Widget>[
            AstryxResizeHandle(
              label: 'Resize the filters',
              size: 200,
              onResize: (_) {},
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxResizeHandle));
      expect(node.label, 'Resize the filters');
      expect(node.value, '200');
      expect(node.flagsCollection.isSlider, isTrue);
      expect(node.getSemanticsData().hasAction(SemanticsAction.increase), true);
      handle.dispose();
    });

    testWidgets('a null callback leaves it inert', (tester) async {
      await pumpAstryxWidget(
        tester,
        const Row(
          children: <Widget>[
            AstryxResizeHandle(label: 'Resize', size: 200),
            Expanded(child: SizedBox()),
          ],
        ),
      );

      await tester.drag(
        find.byType(AstryxResizeHandle),
        const Offset(40, 0),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('AstryxOutline', () {
    testWidgets('marks the entry the caller says is active', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxOutline(
          label: 'On this page',
          activeId: 'usage',
          entries: <AstryxOutlineEntry>[
            AstryxOutlineEntry(id: 'setup', label: 'Setup'),
            AstryxOutlineEntry(id: 'usage', label: 'Usage'),
          ],
        ),
        surfaceSize: const Size(300, 300),
      );

      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Usage'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Setup'))
            .flagsCollection
            .isSelected,
        Tristate.none,
      );
      handle.dispose();
    });

    testWidgets('a press scrolls to the anchor', (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      final usage = GlobalKey();

      await pumpAstryxWidget(
        tester,
        Row(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: AstryxOutline(
                controller: scroll,
                entries: <AstryxOutlineEntry>[
                  const AstryxOutlineEntry(id: 'setup', label: 'Setup'),
                  AstryxOutlineEntry(
                    id: 'usage',
                    label: 'Usage',
                    anchor: usage,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 800),
                    AstryxHeading('Usage', key: usage),
                    const SizedBox(height: 800),
                  ],
                ),
              ),
            ),
          ],
        ),
        surfaceSize: const Size(600, 400),
      );

      expect(scroll.offset, 0);
      await tester.tap(find.text('Usage').first);
      await tester.pumpAndSettle();

      expect(scroll.offset, greaterThan(0));
    });

    testWidgets('it follows the reader down the page', (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      final setup = GlobalKey();
      final usage = GlobalKey();

      await pumpAstryxWidget(
        tester,
        Row(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: AstryxOutline(
                controller: scroll,
                entries: <AstryxOutlineEntry>[
                  AstryxOutlineEntry(
                    id: 'setup',
                    label: 'Setup',
                    anchor: setup,
                  ),
                  AstryxOutlineEntry(
                    id: 'usage',
                    label: 'Usage',
                    anchor: usage,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: <Widget>[
                    AstryxHeading('Setup', key: setup),
                    const SizedBox(height: 600),
                    AstryxHeading('Usage', key: usage),
                    const SizedBox(height: 600),
                  ],
                ),
              ),
            ),
          ],
        ),
        surfaceSize: const Size(600, 400),
      );
      await tester.pumpAndSettle();

      final handle = tester.ensureSemantics();

      /// The outline's own row for [label] — the page's heading says the same
      /// words, and a bare label finder matches both.
      Finder row(String label) => find.descendant(
        of: find.byType(AstryxOutline),
        matching: find.bySemanticsLabel(label),
      );

      expect(
        tester.getSemantics(row('Setup')).flagsCollection.isSelected,
        Tristate.isTrue,
      );

      // Past the second heading, which is the fact the outline is tracking —
      // not the scroll offset, which means nothing on its own.
      scroll.jumpTo(700);
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(row('Usage')).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      handle.dispose();
    });
  });
}
