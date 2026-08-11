import 'dart:ui' show CheckedState;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxSelectableCard`.
///
/// Tested on what makes it different from the two widgets it sits between: it
/// is a card that reports a *selection* rather than a press, and a checkbox
/// whose contents a screen reader still has to be able to read. Appearance
/// lives in `test/goldens/surface_golden_test.dart`.
void main() {
  Widget build({
    bool selected = false,
    ValueChanged<bool>? onSelectedChanged,
    AstryxSelectableCardControl control = AstryxSelectableCardControl.checkbox,
    bool enabled = true,
    String? hint,
    FocusNode? focusNode,
    bool autofocus = false,
  }) => AstryxSelectableCard(
    label: 'Pro plan',
    selected: selected,
    onSelectedChanged: onSelectedChanged,
    control: control,
    enabled: enabled,
    semanticsHint: hint,
    focusNode: focusNode,
    autofocus: autofocus,
    child: const AstryxText('Unlimited projects'),
  );

  group('selection', () {
    testWidgets('a tap anywhere in the card reports the new value', (
      tester,
    ) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        build(onSelectedChanged: reported.add),
      );

      // The content, not the control — the whole card is the target.
      await tester.tap(find.text('Unlimited projects'));
      await tester.pump();

      expect(reported, <bool>[true]);
    });

    testWidgets('a checkbox card deselects on a second press', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        build(selected: true, onSelectedChanged: reported.add),
      );

      await tester.tap(find.byType(AstryxSelectableCard));
      await tester.pump();

      expect(reported, <bool>[false]);
    });

    testWidgets('a radio card reports nothing when already selected', (
      tester,
    ) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        build(
          selected: true,
          control: AstryxSelectableCardControl.radio,
          onSelectedChanged: reported.add,
        ),
      );

      await tester.tap(find.byType(AstryxSelectableCard));
      await tester.pump();

      // A choice out of several cannot be un-made by pressing it again, which
      // is what a native radio does and what stops a group ending up empty.
      expect(reported, isEmpty);
    });

    testWidgets('Enter and Space both activate it', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final reported = <bool>[];

      await pumpAstryxWidget(
        tester,
        build(
          focusNode: node,
          autofocus: true,
          onSelectedChanged: reported.add,
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(reported, <bool>[true, true]);
    });

    testWidgets('a null callback leaves it inert', (tester) async {
      await pumpAstryxWidget(tester, build());

      await tester.tap(find.byType(AstryxSelectableCard));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a disabled card reports nothing', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        build(enabled: false, onSelectedChanged: reported.add),
      );

      await tester.tap(find.byType(AstryxSelectableCard));
      await tester.pump();

      expect(reported, isEmpty);
    });
  });

  group('semantics', () {
    testWidgets('announces its own name, not its contents', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build(onSelectedChanged: (_) {}, hint: r'$20 per month'),
      );

      final node = tester.getSemantics(find.byType(AstryxSelectableCard));
      expect(node.label, 'Pro plan');
      expect(node.hint, r'$20 per month');
      handle.dispose();
    });

    testWidgets('carries the checked flag', (tester) async {
      final handle = tester.ensureSemantics();

      for (final selected in <bool>[false, true]) {
        await pumpAstryxWidget(
          tester,
          build(selected: selected, onSelectedChanged: (_) {}),
        );

        expect(
          tester
              .getSemantics(find.byType(AstryxSelectableCard))
              .flagsCollection
              .isChecked,
          selected ? CheckedState.isTrue : CheckedState.isFalse,
          reason: 'selected: $selected',
        );
      }
      handle.dispose();
    });

    testWidgets('a radio card is in a mutually exclusive group', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      for (final control in AstryxSelectableCardControl.values) {
        await pumpAstryxWidget(
          tester,
          build(control: control, onSelectedChanged: (_) {}),
        );

        expect(
          tester
              .getSemantics(find.byType(AstryxSelectableCard))
              .flagsCollection
              .isInMutuallyExclusiveGroup,
          control == AstryxSelectableCardControl.radio,
          reason: '$control',
        );
      }
      handle.dispose();
    });

    testWidgets('the content keeps its own node', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, build(onSelectedChanged: (_) {}));

      // Unlike a checkbox, whose label is the whole of it, a card holds text
      // the user has to be able to read after being told what the card is.
      expect(
        find.bySemanticsLabel('Unlimited projects'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('meets the touch tap-target guideline', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build(onSelectedChanged: (_) {}),
        density: AstryxDensity.touch,
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });

  group('layout', () {
    testWidgets('the control sits at the reading-start edge', (tester) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          SizedBox(width: 320, child: build(onSelectedChanged: (_) {})),
          textDirection: direction,
        );

        final card = tester.getRect(find.byType(AstryxSelectableCard));
        final content = tester.getRect(find.text('Unlimited projects'));
        final onLeft = content.center.dx > card.center.dx;
        expect(
          onLeft,
          direction == TextDirection.ltr,
          reason: '$direction put the content at ${content.center.dx}',
        );
      }
    });

    testWidgets('fills a bounded width and shrinks to fit an unbounded one', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        SizedBox(width: 340, child: build(onSelectedChanged: (_) {})),
      );
      expect(tester.getSize(find.byType(AstryxSelectableCard)).width, 340);

      // A selectable card in a row is handed an unbounded width; the content
      // fills the card, so without the block-width rule it would assert.
      await pumpAstryxWidget(
        tester,
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[build(onSelectedChanged: (_) {})],
        ),
      );

      expect(tester.takeException(), isNull);
      final width = tester.getSize(find.byType(AstryxSelectableCard)).width;
      expect(width, greaterThan(0));
      expect(width, lessThan(400));
    });
  });
}
