import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxToggleButton` and `AstryxToggleButtonGroup`.
///
/// The behaviour pinned here is upstream's, checked against
/// `packages/core/src/ToggleButton/ToggleButton.test.tsx`: which state the
/// button reports, who owns the state inside a group, that single-select can be
/// emptied by pressing the button that is already on, and the two places where
/// the port deliberately differs.
void main() {
  /// The decoration the button paints.
  BoxDecoration decorationOf(WidgetTester tester) =>
      tester
              .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
              .first
              .decoration!
          as BoxDecoration;

  group('AstryxToggleButton', () {
    testWidgets('renders its label and reports the next state', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(label: 'Bold', onChanged: reported.add),
      );

      expect(find.text('Bold'), findsWidgets);
      await tester.tap(find.byType(AstryxToggleButton));
      await tester.pump();
      expect(reported, <bool>[true]);
    });

    testWidgets('a pressed button reports false next', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(
          label: 'Bold',
          pressed: true,
          onChanged: reported.add,
        ),
      );

      await tester.tap(find.byType(AstryxToggleButton));
      await tester.pump();
      expect(reported, <bool>[false]);
    });

    testWidgets('carries the pressed state to assistive technology', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(label: 'Bold', onChanged: (_) {}),
      );
      expect(
        tester
            .getSemantics(find.byType(AstryxToggleButton))
            .flagsCollection
            .isSelected,
        Tristate.isFalse,
        reason: 'an unpressed toggle is selected: false, not absent',
      );

      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(label: 'Bold', pressed: true, onChanged: (_) {}),
      );
      expect(
        tester
            .getSemantics(find.byType(AstryxToggleButton))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );

      handle.dispose();
    });

    testWidgets('a plain button has no selected state at all', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxButton(label: 'Save', onPressed: () {}),
      );

      // Not `selected: false` — absent. A reader should not be told a Save
      // button is "not selected".
      expect(
        tester
            .getSemantics(find.byType(AstryxButton))
            .flagsCollection
            .isSelected,
        Tristate.none,
      );
      handle.dispose();
    });

    testWidgets('pressed paints the overlay-pressed fill', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(label: 'Bold', onChanged: (_) {}),
      );
      // Ghost: transparent until it is on.
      expect(decorationOf(tester).color!.a, 0);

      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(label: 'Bold', pressed: true, onChanged: (_) {}),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester).color!.a, greaterThan(0));
    });

    testWidgets('swaps to pressedIcon only while pressed', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxToggleButton(
          label: 'Filter',
          icon: AstryxIcon(AstryxIconName.funnel),
          pressedIcon: AstryxIcon(AstryxIconName.check),
        ),
      );
      expect(
        tester.widget<AstryxIcon>(find.byType(AstryxIcon)).name,
        AstryxIconName.funnel,
      );

      await pumpAstryxWidget(
        tester,
        const AstryxToggleButton(
          label: 'Filter',
          pressed: true,
          icon: AstryxIcon(AstryxIconName.funnel),
          pressedIcon: AstryxIcon(AstryxIconName.check),
        ),
      );
      expect(
        tester.widget<AstryxIcon>(find.byType(AstryxIcon)).name,
        AstryxIconName.check,
      );
    });

    testWidgets('falls back to icon when there is no pressedIcon', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxToggleButton(
          label: 'Filter',
          pressed: true,
          icon: AstryxIcon(AstryxIconName.funnel),
        ),
      );

      expect(
        tester.widget<AstryxIcon>(find.byType(AstryxIcon)).name,
        AstryxIconName.funnel,
      );
    });

    testWidgets('does not report while disabled', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(
          label: 'Bold',
          enabled: false,
          onChanged: reported.add,
        ),
      );

      await tester.tap(find.byType(AstryxToggleButton), warnIfMissed: false);
      await tester.pump();
      expect(reported, isEmpty);
    });

    testWidgets('reserves the width its pressed weight needs', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(
          label: 'Strikethrough',
          onChanged: (_) {},
        ),
      );
      final unpressed = tester.getSize(find.byType(AstryxToggleButton));

      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(
          label: 'Strikethrough',
          pressed: true,
          onChanged: (_) {},
        ),
      );
      final pressed = tester.getSize(find.byType(AstryxToggleButton));

      // The label goes semibold when pressed, which is wider. Reserving that
      // width up front is what stops a toolbar shuffling sideways as toggles
      // are pressed.
      expect(pressed.width, unpressed.width);
    });

    testWidgets('labelHidden keeps the name, drops the text, squares the '
        'button and tooltips itself', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxToggleButton(
          label: 'Bold',
          labelHidden: true,
          icon: AstryxIcon(AstryxIconName.check),
        ),
      );

      expect(find.text('Bold'), findsNothing);
      final size = tester.getSize(find.byType(AstryxToggleButton));
      expect(size.width, size.height);
      // Upstream gives an icon-only toggle a tooltip from its label.
      expect(find.byType(AstryxTooltip), findsOneWidget);
    });

    testWidgets('a loading toggle cannot be pressed', (tester) async {
      final reported = <bool>[];
      await pumpAstryxWidget(
        tester,
        AstryxToggleButton(
          label: 'Bold',
          loading: true,
          onChanged: reported.add,
        ),
      );

      expect(find.byType(AstryxSpinner), findsOneWidget);
      await tester.tap(find.byType(AstryxToggleButton), warnIfMissed: false);
      await tester.pump();
      expect(reported, isEmpty);
    });
  });

  group('AstryxToggleButtonGroup — single', () {
    Widget group({
      required String? value,
      required ValueChanged<String?> onChanged,
      bool enabled = true,
    }) => AstryxToggleButtonGroup.single(
      label: 'View mode',
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      children: const <Widget>[
        AstryxToggleButton(value: 'list', label: 'List'),
        AstryxToggleButton(value: 'grid', label: 'Grid'),
      ],
    );

    testWidgets('marks the selected child, and only it', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        group(value: 'grid', onChanged: (_) {}),
      );

      final buttons = find.byType(AstryxToggleButton);
      expect(
        tester.getSemantics(buttons.first).flagsCollection.isSelected,
        Tristate.isFalse,
      );
      expect(
        tester.getSemantics(buttons.last).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      handle.dispose();
    });

    testWidgets('selects another value on press', (tester) async {
      final reported = <String?>[];
      await pumpAstryxWidget(
        tester,
        group(value: 'list', onChanged: reported.add),
      );

      await tester.tap(find.text('Grid'));
      await tester.pump();
      expect(reported, <String?>['grid']);
    });

    testWidgets('pressing the selected value clears the group', (tester) async {
      final reported = <String?>[];
      await pumpAstryxWidget(
        tester,
        group(value: 'grid', onChanged: reported.add),
      );

      await tester.tap(find.text('Grid'));
      await tester.pump();
      // Upstream allows deselection: "none" stays reachable.
      expect(reported, <String?>[null]);
    });

    testWidgets('the group owns enablement, overriding its children', (
      tester,
    ) async {
      final reported = <String?>[];
      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: null,
          onChanged: reported.add,
          enabled: false,
          children: const <Widget>[
            // Deliberately enabled: upstream's group wins either way.
            AstryxToggleButton(value: 'list', label: 'List'),
          ],
        ),
      );

      await tester.tap(find.text('List'), warnIfMissed: false);
      await tester.pump();
      expect(reported, isEmpty);
    });

    testWidgets('the group cascades its size', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: null,
          size: AstryxButtonSize.lg,
          onChanged: (_) {},
          children: const <Widget>[
            AstryxToggleButton(value: 'list', label: 'List'),
            // An explicit size beats the group's.
            AstryxToggleButton(
              value: 'grid',
              label: 'Grid',
              size: AstryxButtonSize.sm,
            ),
          ],
        ),
      );

      final buttons = find.byType(AstryxToggleButton);
      final inherited = tester.getSize(buttons.first).height;
      final explicit = tester.getSize(buttons.last).height;
      expect(inherited, greaterThan(explicit));
    });

    testWidgets('names itself to assistive technology', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        group(value: null, onChanged: (_) {}),
      );

      expect(
        find.bySemanticsLabel('View mode'),
        findsOneWidget,
        reason: 'a set of controls has to say what set it is',
      );
      handle.dispose();
    });
  });

  group('AstryxToggleButtonGroup — multiple', () {
    Widget group({
      required Set<String> values,
      required ValueChanged<Set<String>> onChanged,
    }) => AstryxToggleButtonGroup.multiple(
      label: 'Text formatting',
      values: values,
      onChanged: onChanged,
      children: const <Widget>[
        AstryxToggleButton(value: 'bold', label: 'Bold'),
        AstryxToggleButton(value: 'italic', label: 'Italic'),
      ],
    );

    testWidgets('marks every selected child', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        group(values: const <String>{'bold', 'italic'}, onChanged: (_) {}),
      );

      final buttons = find.byType(AstryxToggleButton);
      for (final button in <Finder>[buttons.first, buttons.last]) {
        expect(
          tester.getSemantics(button).flagsCollection.isSelected,
          Tristate.isTrue,
        );
      }
      handle.dispose();
    });

    testWidgets('adds a value, and does not disturb the others', (
      tester,
    ) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        group(values: const <String>{'bold'}, onChanged: reported.add),
      );

      await tester.tap(find.text('Italic'));
      await tester.pump();
      expect(reported, <Set<String>>[
        <String>{'bold', 'italic'},
      ]);
    });

    testWidgets('removes a value that is already on', (tester) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        group(
          values: const <String>{'bold', 'italic'},
          onChanged: reported.add,
        ),
      );

      await tester.tap(find.text('Bold'));
      await tester.pump();
      expect(reported, <Set<String>>[
        <String>{'italic'},
      ]);
    });

    testWidgets('never mutates the set it was given', (tester) async {
      final original = <String>{'bold'};
      Set<String>? next;
      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.multiple(
          label: 'Text formatting',
          values: original,
          onChanged: (value) => next = value,
          children: const <Widget>[
            AstryxToggleButton(value: 'italic', label: 'Italic'),
          ],
        ),
      );

      await tester.tap(find.text('Italic'));
      await tester.pump();
      expect(original, <String>{'bold'}, reason: 'the caller owns its set');
      expect(next, <String>{'bold', 'italic'});
    });
  });

  group('the group and the button together', () {
    testWidgets('the group beats a child’s own pressed and onChanged', (
      tester,
    ) async {
      final fromChild = <bool>[];
      final fromGroup = <String?>[];

      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: null,
          onChanged: fromGroup.add,
          children: <Widget>[
            AstryxToggleButton(
              value: 'list',
              label: 'List',
              // Both ignored inside a group, as upstream ignores them.
              pressed: true,
              onChanged: fromChild.add,
            ),
          ],
        ),
      );

      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.byType(AstryxToggleButton))
            .flagsCollection
            .isSelected,
        Tristate.isFalse,
        reason: 'the group says nothing is selected',
      );
      handle.dispose();

      await tester.tap(find.text('List'));
      await tester.pump();
      expect(fromChild, isEmpty);
      expect(fromGroup, <String?>['list']);
    });

    testWidgets('an empty group paints nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.multiple(
          label: 'Text formatting',
          values: const <String>{},
          onChanged: (_) {},
          children: const <Widget>[],
        ),
      );

      expect(find.byType(AstryxToggleButton), findsNothing);
    });

    testWidgets('a vertical group shares one width', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: null,
          axis: Axis.vertical,
          onChanged: (_) {},
          children: const <Widget>[
            AstryxToggleButton(value: 'list', label: 'List'),
            AstryxToggleButton(value: 'grid', label: 'A much longer label'),
          ],
        ),
      );

      final buttons = find.byType(AstryxToggleButton);
      expect(
        tester.getSize(buttons.first).width,
        tester.getSize(buttons.last).width,
      );
    });
  });
}
