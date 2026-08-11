import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxStatusDot`, checked against
/// `packages/core/src/StatusDot/StatusDot.tsx`.
void main() {
  /// The dot's painted decoration.
  BoxDecoration decorationOf(WidgetTester tester) =>
      tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
          as BoxDecoration;

  testWidgets('is a fixed 8px circle', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(AstryxStatusDotVariant.success, label: 'Online'),
    );

    expect(
      tester.getSize(find.byType(AstryxStatusDot)),
      const Size(AstryxStatusDot.extent, AstryxStatusDot.extent),
    );
    expect(decorationOf(tester).shape, BoxShape.circle);
  });

  testWidgets('every variant paints its own token', (tester) async {
    final colours = <AstryxStatusDotVariant, Color>{};
    for (final variant in AstryxStatusDotVariant.values) {
      await pumpAstryxWidget(
        tester,
        AstryxStatusDot(variant, label: variant.name),
      );
      colours[variant] = decorationOf(tester).color!;
    }

    // Five variants, five distinct fills: a dot whose colour repeated would be
    // a state nobody could tell from another.
    expect(colours.values.toSet(), hasLength(AstryxStatusDotVariant.values.length));
  });

  testWidgets('the label is the accessible name, and it is an image', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(AstryxStatusDotVariant.error, label: 'Offline'),
    );

    final node = tester.getSemantics(find.byType(AstryxStatusDot));
    expect(node.label, 'Offline');
    // Upstream's `role="img"`: described, not read or operated.
    expect(node.flagsCollection.isImage, isTrue);
    handle.dispose();
  });

  testWidgets('a tooltip does not repeat the name', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(
        AstryxStatusDotVariant.warning,
        label: 'Degraded',
        tooltip: 'Two of three replicas are responding',
      ),
    );

    expect(find.byType(AstryxTooltip), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(AstryxStatusDot)).label,
      'Degraded',
      reason: 'the tooltip is excluded from semantics',
    );
    handle.dispose();
  });

  testWidgets('pulsing fades, and a still dot does not', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(AstryxStatusDotVariant.success, label: 'Live'),
    );
    expect(find.byType(FadeTransition), findsNothing);

    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(
        AstryxStatusDotVariant.success,
        label: 'Live',
        pulsing: true,
      ),
    );

    final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
    expect(fade.opacity.value, 1);
    await tester.pump(const Duration(seconds: 1));
    expect(fade.opacity.value, lessThan(1), reason: 'it has faded');
  });

  testWidgets('reduced motion holds it still at full opacity', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxStatusDot(
        AstryxStatusDotVariant.success,
        label: 'Live',
        pulsing: true,
      ),
      disableAnimations: true,
    );

    final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
    await tester.pump(const Duration(seconds: 1));
    // Still legible, and still there: the package's rule for a looping
    // indicator is that it settles rather than disappearing.
    expect(fade.opacity.value, 1);
  });

  testWidgets('it survives being switched between the two', (tester) async {
    Future<void> pump({required bool pulsing}) => pumpAstryxWidget(
      tester,
      AstryxStatusDot(
        AstryxStatusDotVariant.accent,
        label: 'Deploying',
        pulsing: pulsing,
      ),
    );

    await pump(pulsing: true);
    await tester.pump(const Duration(milliseconds: 500));
    await pump(pulsing: false);
    await tester.pump();

    expect(find.byType(FadeTransition), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
