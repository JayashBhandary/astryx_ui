import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxStepper`, checked against `packages/core/src/Stepper/`.
void main() {
  const steps = <AstryxStep>[
    AstryxStep(label: 'Account'),
    AstryxStep(label: 'Profile'),
    AstryxStep(label: 'Review'),
  ];

  /// The semantics node of the step whose name starts with [label].
  SemanticsNode nodeFor(WidgetTester tester, String label) =>
      tester.getSemantics(find.bySemanticsLabel(RegExp(RegExp.escape(label))));

  testWidgets('every step is rendered, in order', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(activeStep: 1, steps: steps),
      surfaceSize: const Size(600, 300),
    );

    for (final step in steps) {
      expect(find.text(step.label), findsOneWidget);
    }
  });

  testWidgets('the numbers are painted, and the passed steps take a check', (
    tester,
  ) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(activeStep: 1, steps: steps),
      surfaceSize: const Size(600, 300),
    );

    // Step 1 is behind the flow, so `auto` has swapped its badge for a check.
    expect(find.text('1'), findsNothing);
    // The current and the upcoming step keep their numbers.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('a step announces where it sits and how far the flow has got', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(activeStep: 1, steps: steps),
      surfaceSize: const Size(600, 300),
    );

    expect(nodeFor(tester, 'Step 1 of 3').label, contains('Completed'));
    expect(nodeFor(tester, 'Step 2 of 3').label, contains('Current step'));

    // The current step is the selected one, which is what a screen reader
    // reads as `aria-current`.
    expect(
      nodeFor(tester, 'Step 2 of 3').flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(
      nodeFor(tester, 'Step 3 of 3').flagsCollection.isSelected,
      Tristate.isFalse,
    );

    handle.dispose();
  });

  testWidgets('a description and an optional note reach the name', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(
        activeStep: 0,
        steps: <AstryxStep>[
          AstryxStep(
            label: 'Profile',
            description: 'Name and photo',
            optional: true,
          ),
        ],
      ),
      surfaceSize: const Size(600, 300),
    );

    final label = nodeFor(tester, 'Step 1 of 1').label;
    expect(label, contains('Name and photo'));
    expect(label, contains('Optional'));

    handle.dispose();
  });

  testWidgets('a status glyph is announced as a word', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(
        activeStep: 1,
        steps: <AstryxStep>[
          AstryxStep(label: 'Upload', status: AstryxStepStatus.error),
          AstryxStep(label: 'Review'),
        ],
      ),
      surfaceSize: const Size(600, 300),
    );

    // Colour is never the only signal: the glyph is decorative, so the word is
    // in the accessible name.
    expect(nodeFor(tester, 'Step 1 of 2').label, contains('error'));

    handle.dispose();
  });

  testWidgets('nothing is pressable without onStepPressed', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(activeStep: 1, steps: steps),
      surfaceSize: const Size(600, 300),
    );

    expect(nodeFor(tester, 'Step 1 of 3').flagsCollection.isButton, isFalse);

    handle.dispose();
  });

  testWidgets('onStepPressed reports the index pressed', (tester) async {
    final pressed = <int>[];
    await pumpAstryxWidget(
      tester,
      AstryxStepper(
        activeStep: 1,
        steps: steps,
        onStepPressed: pressed.add,
      ),
      surfaceSize: const Size(600, 300),
    );

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    expect(pressed, <int>[2]);
  });

  testWidgets('a disabled step reports no press', (tester) async {
    final pressed = <int>[];
    await pumpAstryxWidget(
      tester,
      AstryxStepper(
        activeStep: 0,
        steps: const <AstryxStep>[
          AstryxStep(label: 'Account'),
          AstryxStep(label: 'Billing', enabled: false),
        ],
        onStepPressed: pressed.add,
      ),
      surfaceSize: const Size(600, 300),
    );

    await tester.tap(find.text('Billing'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(pressed, isEmpty);
  });

  testWidgets('the indicator presets change what is drawn', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(
        activeStep: 2,
        steps: <AstryxStep>[
          AstryxStep(label: 'One', indicator: AstryxStepIndicator.number),
          AstryxStep(label: 'Two', indicator: AstryxStepIndicator.none),
          AstryxStep(label: 'Three'),
        ],
      ),
      surfaceSize: const Size(600, 300),
    );

    // `number` keeps its badge even though the flow has passed it.
    expect(find.text('1'), findsOneWidget);
    // `none` draws nothing at all.
    expect(find.text('2'), findsNothing);
  });

  testWidgets('both orientations and both indicator positions lay out', (
    tester,
  ) async {
    for (final orientation in AstryxStepperOrientation.values) {
      for (final position in AstryxStepperIndicatorPosition.values) {
        await pumpAstryxWidget(
          tester,
          AstryxStepper(
            activeStep: 1,
            steps: steps,
            orientation: orientation,
            indicatorPosition: position,
          ),
          surfaceSize: const Size(600, 400),
        );
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isNull,
          reason: '$orientation with $position overflowed or threw',
        );
      }
    }
  });

  testWidgets('a step with content renders it below the label', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(
        activeStep: 0,
        orientation: AstryxStepperOrientation.vertical,
        steps: <AstryxStep>[
          AstryxStep(label: 'Details', content: AstryxText('the fields')),
          AstryxStep(label: 'Review'),
        ],
      ),
      surfaceSize: const Size(600, 400),
    );

    expect(find.text('the fields'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('the fields')).dy,
      greaterThan(tester.getTopLeft(find.text('Details')).dy),
    );
  });

  testWidgets('a stepper past its last step is all complete', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStepper(activeStep: 3, steps: steps),
      surfaceSize: const Size(600, 300),
    );

    // Every badge has become a check.
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);
    expect(find.text('3'), findsNothing);
  });
}
