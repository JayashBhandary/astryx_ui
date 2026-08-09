import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden.dart';

/// Behavioural tests for the golden harness.
///
/// Untagged on purpose: these verify that the harness honours its arguments,
/// which is worth checking on every Flutter version in the CI matrix, not only
/// the one that owns the golden images.
void main() {
  testWidgets('applies the requested surface size', (tester) async {
    await pumpAstryxWidget(
      tester,
      const SizedBox.shrink(),
      surfaceSize: const Size(321, 123),
    );

    expect(
      tester.getSize(find.byKey(astryxGoldenRootKey)),
      const Size(321, 123),
    );
  });

  testWidgets('propagates brightness and text direction', (tester) async {
    late BuildContext captured;

    await pumpAstryxWidget(
      tester,
      Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
      brightness: Brightness.dark,
      textDirection: TextDirection.rtl,
    );

    expect(MediaQuery.platformBrightnessOf(captured), Brightness.dark);
    expect(Directionality.of(captured), TextDirection.rtl);
  });

  testWidgets('defaults to light and LTR', (tester) async {
    late BuildContext captured;

    await pumpAstryxWidget(
      tester,
      Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(MediaQuery.platformBrightnessOf(captured), Brightness.light);
    expect(Directionality.of(captured), TextDirection.ltr);
  });

  testWidgets('can disable animations', (tester) async {
    late BuildContext captured;

    await pumpAstryxWidget(
      tester,
      Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
      disableAnimations: true,
    );

    expect(MediaQuery.disableAnimationsOf(captured), isTrue);
  });

  testWidgets('applies text scaling', (tester) async {
    late BuildContext captured;

    await pumpAstryxWidget(
      tester,
      Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
      textScaleFactor: 2,
    );

    expect(MediaQuery.textScalerOf(captured).scale(10), 20);
  });
}
