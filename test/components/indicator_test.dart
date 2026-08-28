import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The three stateful control visuals, checked against
/// `packages/core/src/Indicator/`.
void main() {
  /// The chrome's painted decoration.
  BoxDecoration decorationOf(WidgetTester tester) =>
      tester
              .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
              .first
              .decoration!
          as BoxDecoration;

  testWidgets('a checkbox indicator fills only when it is on', (tester) async {
    final fills = <AstryxIndicatorState, Color>{};
    for (final state in AstryxIndicatorState.values) {
      await pumpAstryxWidget(tester, AstryxCheckboxIndicator(state: state));
      // The chrome cross-fades between states, so let it land before reading
      // the colour off it.
      await tester.pumpAndSettle();
      fills[state] = decorationOf(tester).color!;
    }

    // Indeterminate fills too — a partially checked parent is not an unchecked
    // one — so the two on states agree and the off state differs.
    expect(
      fills[AstryxIndicatorState.checked],
      fills[AstryxIndicatorState.indeterminate],
    );
    expect(
      fills[AstryxIndicatorState.unchecked],
      isNot(fills[AstryxIndicatorState.checked]),
    );
  });

  testWidgets('a radio indicator is a circle, a checkbox is not', (
    tester,
  ) async {
    await pumpAstryxWidget(
      tester,
      const AstryxRadioIndicator(state: AstryxIndicatorState.checked),
    );
    expect(decorationOf(tester).shape, BoxShape.circle);

    await pumpAstryxWidget(
      tester,
      const AstryxCheckboxIndicator(state: AstryxIndicatorState.checked),
    );
    expect(decorationOf(tester).shape, BoxShape.rectangle);
  });

  testWidgets('both sizes match the control sizes they sit beside', (
    tester,
  ) async {
    for (final size in AstryxIndicatorSize.values) {
      await pumpAstryxWidget(
        tester,
        AstryxCheckboxIndicator(
          state: AstryxIndicatorState.checked,
          size: size,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(AstryxCheckboxIndicator)),
        Size.square(size.extent),
      );
    }
  });

  testWidgets('a radio indicator refuses the indeterminate state', (
    tester,
  ) async {
    expect(
      () => AstryxRadioIndicator(
        state: AstryxIndicatorState.indeterminate,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('a check indicator draws a mark only when chosen, in a fixed '
      'slot', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxCheckIndicator(state: AstryxIndicatorState.unchecked),
    );
    final empty = tester.getSize(find.byType(AstryxCheckIndicator));
    expect(find.byType(AstryxIcon), findsNothing);

    await pumpAstryxWidget(
      tester,
      const AstryxCheckIndicator(state: AstryxIndicatorState.checked),
    );
    expect(find.byType(AstryxIcon), findsOneWidget);

    // The slot does not move when the mark appears — the point of reserving it.
    expect(tester.getSize(find.byType(AstryxCheckIndicator)), empty);
    expect(empty, Size.square(AstryxCheckIndicator.extent));
  });

  testWidgets('all three are hidden from assistive technology', (tester) async {
    final handle = tester.ensureSemantics();

    await pumpAstryxWidget(
      tester,
      const AstryxVStack(
        children: <Widget>[
          AstryxCheckboxIndicator(state: AstryxIndicatorState.checked),
          AstryxRadioIndicator(state: AstryxIndicatorState.checked),
          AstryxCheckIndicator(state: AstryxIndicatorState.checked),
        ],
      ),
    );

    // An indicator announced beside the control that owns the name is the same
    // thing said twice.
    expect(
      tester.semantics.find(find.byType(AstryxVStack)).childrenCount,
      0,
      reason: 'an indicator is decoration and owns no semantics',
    );

    handle.dispose();
  });

  testWidgets('a child stands in for the state mark', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxCheckboxIndicator(
        state: AstryxIndicatorState.checked,
        child: AstryxSpinner(size: AstryxSpinnerSize.sm),
      ),
    );

    expect(find.byType(AstryxSpinner), findsOneWidget);
  });
}
