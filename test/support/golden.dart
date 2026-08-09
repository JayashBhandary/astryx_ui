/// Golden-test harness for `astryx_ui`.
///
/// ## Where golden tests live
///
/// Golden tests must live directly in `test/goldens/`, and their images in
/// `test/goldens/files/`. `matchesGoldenFile` resolves relative paths against
/// the *test file's* directory, so keeping every golden test at one depth is
/// what lets this helper use a single fixed path prefix.
///
/// ```text
/// test/
///   components/button_test.dart          behaviour
///   goldens/button_golden_test.dart      appearance
///   goldens/files/button.light.ltr.png   the image
/// ```
///
/// ## The matrix
///
/// A widget is rendered once per combination of the requested axes, and each
/// combination gets its own file:
///
/// ```text
/// <name>.<brightness>.<direction>.png
/// ```
///
/// Brightness is always exercised — light and dark are not optional for a
/// design system. Direction defaults to LTR only; widgets with asymmetric
/// layout opt into RTL explicitly, so the file count stays proportional to the
/// risk.
///
/// Density becomes a third axis in Phase 4 (`P4-10`), once `AstryxDensity`
/// exists and there is a theme scope to feed it into.
///
/// ## Fonts
///
/// Text renders with the test environment's fallback font, which is stable for
/// a given Flutter version but not across versions. CI pins the Flutter version
/// for exactly this reason — see `.github/workflows/ci.yml`. Regenerate goldens
/// with `flutter test --update-goldens` on the pinned version, never ad hoc.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders [child] across the brightness × direction matrix and compares each
/// combination against its golden file.
///
/// [name] is the file stem and should match the widget under test, lowercased:
/// `'button'`, `'button.loading'`, `'text_input.error'`.
Future<void> expectAstryxGolden(
  WidgetTester tester,
  Widget child, {
  required String name,
  Size surfaceSize = const Size(400, 300),
  Set<Brightness> brightnesses = const {Brightness.light, Brightness.dark},
  Set<TextDirection> directions = const {TextDirection.ltr},
}) async {
  assert(brightnesses.isNotEmpty, 'At least one brightness is required');
  assert(directions.isNotEmpty, 'At least one direction is required');

  for (final brightness in brightnesses) {
    for (final direction in directions) {
      await pumpAstryxWidget(
        tester,
        child,
        brightness: brightness,
        textDirection: direction,
        surfaceSize: surfaceSize,
      );

      await expectLater(
        find.byKey(astryxGoldenRootKey),
        matchesGoldenFile(
          'files/$name.${brightness.name}.${direction.name}.png',
        ),
      );
    }
  }
}

/// Pumps [child] inside the standard test harness.
///
/// Use directly in behaviour tests that need the same environment a golden gets
/// but do not compare an image.
Future<void> pumpAstryxWidget(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  TextDirection textDirection = TextDirection.ltr,
  Size surfaceSize = const Size(400, 300),
  double textScaleFactor = 1,
  bool disableAnimations = false,
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    _AstryxTestHarness(
      brightness: brightness,
      textDirection: textDirection,
      surfaceSize: surfaceSize,
      textScaleFactor: textScaleFactor,
      disableAnimations: disableAnimations,
      child: child,
    ),
  );
}

/// Identifies the harness root, so goldens capture the harness rather than the
/// whole surface.
const Key astryxGoldenRootKey = ValueKey<String>('astryx.golden.root');

/// Minimal environment a widget needs to render outside an app.
///
/// Phase 3 adds `AstryxThemeProvider` here, at which point the hard-coded
/// background colours below come from `--color-background-body` instead.
class _AstryxTestHarness extends StatelessWidget {
  const _AstryxTestHarness({
    required this.brightness,
    required this.textDirection,
    required this.surfaceSize,
    required this.textScaleFactor,
    required this.disableAnimations,
    required this.child,
  });

  final Brightness brightness;
  final TextDirection textDirection;
  final Size surfaceSize;
  final double textScaleFactor;
  final bool disableAnimations;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Placeholder surface colours until Phase 3. Chosen to match Astryx's
    // --color-background-body so goldens do not shift when the theme lands.
    final background = brightness == Brightness.light
        ? const Color(0xFFF1F4F7)
        : const Color(0xFF111112);

    return MediaQuery(
      data: MediaQueryData(
        size: surfaceSize,
        platformBrightness: brightness,
        textScaler: TextScaler.linear(textScaleFactor),
        disableAnimations: disableAnimations,
      ),
      child: Directionality(
        textDirection: textDirection,
        child: Container(
          key: astryxGoldenRootKey,
          width: surfaceSize.width,
          height: surfaceSize.height,
          color: background,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
