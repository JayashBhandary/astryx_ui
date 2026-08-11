import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxFormLayout`, `AstryxInputGroup`, `AstryxSlider`,
/// `AstryxComplexSelector` and `AstryxMultiSelector`.
void main() {
  group('AstryxFormLayout', () {
    testWidgets('stacks by default and columns horizontally', (tester) async {
      Future<Rect> rectOf(AstryxFormLayoutDirection direction) async {
        await pumpAstryxWidget(
          tester,
          AstryxFormLayout(
            direction: direction,
            children: const <Widget>[
              AstryxText('one'),
              AstryxText('two'),
            ],
          ),
          surfaceSize: const Size(700, 400),
        );
        return tester.getRect(find.text('two'));
      }

      final stacked = await rectOf(AstryxFormLayoutDirection.vertical);
      final columned = await rectOf(AstryxFormLayoutDirection.horizontal);

      final first = tester.getRect(find.text('one'));
      expect(columned.top, first.top, reason: 'columns share a baseline');
      expect(stacked.top, greaterThan(first.top));
    });

    testWidgets('horizontal-labels puts the label beside its control', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxFormLayout(
          direction: AstryxFormLayoutDirection.horizontalLabels,
          children: <Widget>[
            AstryxTextInput(label: 'Display name', onChanged: (_) {}),
          ],
        ),
        surfaceSize: const Size(700, 300),
      );

      final label = tester.getRect(find.text('Display name'));
      final control = tester.getRect(find.byType(EditableText));
      expect(control.left, greaterThan(label.left));
      expect(label.top, lessThan(control.bottom));
    });

    testWidgets('and collapses back to a stack on a narrow surface', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxFormLayout(
          direction: AstryxFormLayoutDirection.horizontalLabels,
          children: <Widget>[
            AstryxTextInput(label: 'Display name', onChanged: (_) {}),
          ],
        ),
        // Below upstream's own 480px threshold.
        surfaceSize: const Size(390, 300),
      );

      final label = tester.getRect(find.text('Display name'));
      final control = tester.getRect(find.byType(EditableText));
      expect(label.bottom, lessThanOrEqualTo(control.top));
    });

    testWidgets('an empty layout paints nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxFormLayout(children: <Widget>[]),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('AstryxInputGroup', () {
    testWidgets('labels the group once and squares the joins', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxInputGroup(
          label: 'Project URL',
          children: <Widget>[
            const AstryxInputGroupText('https://'),
            Expanded(
              child: AstryxTextInput(
                label: 'Project URL',
                labelHidden: true,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
        surfaceSize: const Size(500, 200),
      );

      // One label for the row, not one per child.
      expect(find.text('Project URL'), findsOneWidget);
      expect(find.text('https://'), findsOneWidget);

      final radius =
          tester
                  .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
                  .first
                  .decoration!
              as BoxDecoration;
      // The field is the last child, so its start corners meet the affix.
      expect(radius.borderRadius, isA<BorderRadiusDirectional>());
    });

    testWidgets('positions come from the child count', (tester) async {
      expect(
        AstryxInputGroupPosition.of(0, 1),
        AstryxInputGroupPosition.only,
      );
      expect(
        AstryxInputGroupPosition.of(0, 3),
        AstryxInputGroupPosition.start,
      );
      expect(
        AstryxInputGroupPosition.of(1, 3),
        AstryxInputGroupPosition.middle,
      );
      expect(AstryxInputGroupPosition.of(2, 3), AstryxInputGroupPosition.end);
    });

    testWidgets('an affix says nothing to a screen reader', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxInputGroup(
          label: 'Price',
          children: <Widget>[
            const AstryxInputGroupText(r'$'),
            Expanded(
              child: AstryxTextInput(
                label: 'Price',
                labelHidden: true,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
        surfaceSize: const Size(400, 200),
      );

      // The affix is decoration: the group's label already says what the field
      // is, and a stray "$" node would be read as content.
      expect(find.bySemanticsLabel(r'$'), findsNothing);
      handle.dispose();
    });
  });

  group('AstryxSlider', () {
    testWidgets('reports a value and announces it', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxSlider(
          label: 'Threshold',
          value: 40,
          formatValue: (value) => '$value%',
          onChanged: (_) {},
        ),
        surfaceSize: const Size(400, 200),
      );

      // The formatted value, so a reader hears what the page shows.
      expect(
        tester.getSemantics(find.bySemanticsLabel('Threshold')).value,
        '40%',
      );
      handle.dispose();
    });

    testWidgets('the arrow keys, Page keys and Home/End move the thumb', (
      tester,
    ) async {
      num value = 50;
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxSlider(
            label: 'Threshold',
            value: value,
            step: 2,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
        surfaceSize: const Size(400, 200),
      );

      final track = tester.getRect(find.byType(AstryxSlider));
      await tester.tapAt(Offset(track.center.dx, track.bottom - 8));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      final afterRight = value;

      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.pump();
      expect(value - afterRight, 20, reason: 'a page is ten steps');

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(value, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(value, 100);
    });

    testWidgets('values snap to the step grid', (tester) async {
      final reported = <num>[];
      await pumpAstryxWidget(
        tester,
        AstryxSlider(
          label: 'Threshold',
          value: 0,
          step: 25,
          onChangeEnd: reported.add,
        ),
        surfaceSize: const Size(400, 200),
      );

      // A press a third of the way along lands on 25, not 33.
      final rect = tester.getRect(find.byType(AstryxSlider));
      await tester.tapAt(Offset(rect.left + rect.width / 3, rect.bottom - 8));
      await tester.pump();
      expect(reported.single % 25, 0);
    });

    testWidgets('a range keeps its thumbs in order and apart', (tester) async {
      (num, num) values = (20, 80);
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxSlider.range(
            label: 'Band',
            values: values,
            minStepsBetweenThumbs: 10,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(400, 200),
      );

      // Drive the low thumb up past the high one: it stops at the gap.
      final low = find.bySemanticsLabel('Band, start');
      final handle = tester.ensureSemantics();
      for (var i = 0; i < 100; i++) {
        // Driving the thumb through its semantics action rather than a drag:
        // the gap is what is under test, not the gesture arena.
        // ignore: deprecated_member_use
        tester.binding.pipelineOwner.semanticsOwner!.performAction(
          tester.getSemantics(low).id,
          SemanticsAction.increase,
        );
        await tester.pump();
      }
      handle.dispose();

      expect(values.$1, lessThanOrEqualTo(values.$2 - 10));
      expect(values.$2, 80, reason: 'the other thumb did not move');
    });

    testWidgets('a disabled slider refuses the keyboard', (tester) async {
      final reported = <num>[];
      await pumpAstryxWidget(
        tester,
        AstryxSlider(
          label: 'Threshold',
          value: 50,
          enabled: false,
          onChanged: reported.add,
        ),
        surfaceSize: const Size(400, 200),
      );

      final disabled = tester.getRect(find.byType(AstryxSlider));
      await tester.tapAt(Offset(disabled.center.dx, disabled.bottom - 8));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(reported, isEmpty);
    });

    testWidgets('valueDisplay text shows the number, none shows nothing', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSlider(
          label: 'Threshold',
          value: 40,
          valueDisplay: AstryxSliderValueDisplay.text,
        ),
        surfaceSize: const Size(400, 200),
      );
      expect(find.text('40'), findsOneWidget);

      await pumpAstryxWidget(
        tester,
        const AstryxSlider(
          label: 'Threshold',
          value: 40,
          valueDisplay: AstryxSliderValueDisplay.none,
        ),
        surfaceSize: const Size(400, 200),
      );
      expect(find.text('40'), findsNothing);
    });
  });

  group('AstryxComplexSelector', () {
    testWidgets('opens its own surface and reports through it', (tester) async {
      var value = 'one';
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxComplexSelector<String>(
            label: 'Shape',
            value: value,
            triggerLabel: AstryxText(value),
            onChanged: (next) => setState(() => value = next),
            surfaceBuilder: (context, state) => AstryxButton(
              label: 'Pick two',
              onPressed: () {
                state.onChanged('two');
                state.close();
              },
            ),
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      expect(find.text('Pick two'), findsNothing);
      await tester.tap(find.text('one'));
      await tester.pumpAndSettle();
      expect(find.text('Pick two'), findsOneWidget);

      await tester.tap(find.text('Pick two'));
      await tester.pumpAndSettle();
      expect(value, 'two');
      expect(find.text('Pick two'), findsNothing, reason: 'close() closed it');
    });

    testWidgets('shows the placeholder when there is nothing to show', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxComplexSelector<String?>(
          label: 'Shape',
          value: null,
          placeholder: 'Choose a shape',
          onChanged: (_) {},
          surfaceBuilder: (context, state) => const AstryxText('surface'),
        ),
      );

      expect(find.text('Choose a shape'), findsOneWidget);
    });

    testWidgets('a null onChanged leaves it shut', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxComplexSelector<String>(
          label: 'Shape',
          value: 'one',
          triggerLabel: const AstryxText('one'),
          surfaceBuilder: (context, state) => const AstryxText('surface'),
        ),
      );

      await tester.tap(find.text('one'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('surface'), findsNothing);
    });
  });

  group('AstryxMultiSelector', () {
    const options = <AstryxSelectorEntry<String>>[
      AstryxSelectorSection<String>('People'),
      AstryxSelectorOption<String>(value: 'ada', label: 'Ada Lovelace'),
      AstryxSelectorOption<String>(value: 'alan', label: 'Alan Turing'),
      AstryxSelectorOption<String>(value: 'grace', label: 'Grace Hopper'),
    ];

    Widget selector({
      required Set<String> values,
      required ValueChanged<Set<String>>? onChanged,
      bool showSearch = false,
      bool showSelectAll = false,
      int maxBadges = 3,
      AstryxMultiSelectorTriggerDisplay display =
          AstryxMultiSelectorTriggerDisplay.badges,
    }) => AstryxMultiSelector<String>(
      label: 'Reviewers',
      options: options,
      values: values,
      onChanged: onChanged,
      showSearch: showSearch,
      showSelectAll: showSelectAll,
      maxBadges: maxBadges,
      triggerDisplay: display,
    );

    testWidgets('stays open as options are ticked', (tester) async {
      var values = <String>{};
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => selector(
            values: values,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.text('Select…'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ada Lovelace'));
      await tester.pump();
      expect(values, <String>{'ada'});
      // The whole difference from a single selector: the list survives a tick.
      expect(find.text('Alan Turing'), findsOneWidget);

      await tester.tap(find.text('Alan Turing'));
      await tester.pump();
      expect(values, <String>{'ada', 'alan'});
    });

    testWidgets('ticking a chosen option removes it', (tester) async {
      var values = <String>{'ada'};
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => selector(
            values: values,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.text('Ada Lovelace'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ada Lovelace').last);
      await tester.pump();
      expect(values, isEmpty);
    });

    testWidgets('the trigger shows badges, then a tail', (tester) async {
      await pumpAstryxWidget(
        tester,
        selector(
          values: const <String>{'ada', 'alan', 'grace'},
          onChanged: (_) {},
          maxBadges: 2,
        ),
        surfaceSize: const Size(500, 300),
      );

      expect(find.text('+1 more'), findsOneWidget);
    });

    testWidgets('or a count, when asked', (tester) async {
      await pumpAstryxWidget(
        tester,
        selector(
          values: const <String>{'ada', 'alan'},
          onChanged: (_) {},
          display: AstryxMultiSelectorTriggerDisplay.count,
        ),
      );

      expect(find.text('2 selected'), findsOneWidget);
    });

    testWidgets('select all ticks everything, then clears it', (tester) async {
      var values = <String>{};
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => selector(
            values: values,
            showSelectAll: true,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.text('Select…'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select all'));
      await tester.pump();
      expect(values, <String>{'ada', 'alan', 'grace'});

      await tester.tap(find.text('Select all'));
      await tester.pump();
      expect(values, isEmpty);
    });

    testWidgets('search filters the options and drops empty headings', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        selector(
          values: const <String>{},
          showSearch: true,
          onChanged: (_) {},
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.text('Select…'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText).first, 'grace');
      await tester.pumpAndSettle();

      expect(find.text('Grace Hopper'), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsNothing);
      expect(find.text('People'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).first, 'nobody');
      await tester.pumpAndSettle();
      expect(find.text('No matches'), findsOneWidget);
      expect(find.text('People'), findsNothing, reason: 'no options under it');
    });

    testWidgets('clearing empties the selection', (tester) async {
      var values = <String>{'ada'};
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => selector(
            values: values,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(500, 300),
      );

      await tester.tap(find.bySemanticsLabel('Clear Reviewers'));
      await tester.pump();
      expect(values, isEmpty);
    });

    testWidgets('announces which options are chosen, not how many', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        selector(values: const <String>{'ada', 'grace'}, onChanged: (_) {}),
        surfaceSize: const Size(500, 300),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Reviewers')).value,
        'Ada Lovelace, Grace Hopper',
      );
      handle.dispose();
    });

    testWidgets('a null onChanged leaves it shut', (tester) async {
      await pumpAstryxWidget(
        tester,
        selector(values: const <String>{}, onChanged: null),
      );

      await tester.tap(find.text('Select…'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsNothing);
    });
  });
}
