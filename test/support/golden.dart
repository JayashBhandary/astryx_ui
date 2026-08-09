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
/// <name>.<brightness>.<direction>[.<density>].png
/// ```
///
/// Brightness is always exercised — light and dark are not optional for a
/// design system. Direction defaults to LTR only, and density to pointer only;
/// widgets with asymmetric layout or a touch-dependent hit region opt in, so
/// the file count stays proportional to the risk. The density suffix is omitted
/// when only one density is requested, which keeps the Phase 0 filenames valid.
///
/// ## What the harness provides
///
/// Since `P4-10` this is a real `AstryxThemeProvider`, not a stand-in: the
/// theme, density, focus-visible scope, icon registry and localisations a
/// widget sees here are the ones it sees in an app. A golden that passes is
/// evidence about the app, not about the harness.
///
/// ## Fonts
///
/// Text renders with the test environment's fallback font, which is stable for
/// a given Flutter version but not across versions. CI pins the Flutter version
/// for exactly this reason — see `.github/workflows/ci.yml`. Regenerate goldens
/// with `flutter test --update-goldens` on the pinned version, never ad hoc.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders [child] across the brightness × direction × density matrix and
/// compares each combination against its golden file.
///
/// [name] is the file stem and should match the widget under test, lowercased:
/// `'button'`, `'button.loading'`, `'text_input.error'`.
///
/// For an animated widget, choose one of three: [disableAnimations] to capture
/// the reduced-motion rendering, [settle] to let a finite animation finish, or
/// [animationFraction] to advance a loop to a named point in [animationCycle].
/// Without one of those the captured frame depends on timing and the golden
/// will flake.
///
/// [beforeCapture] runs after each cell is pumped and before its frame is
/// taken. An overlay has no appearance until something opens it, so its golden
/// needs a step between "build" and "capture" that no earlier phase did.
Future<void> expectAstryxGolden(
  WidgetTester tester,
  Widget child, {
  required String name,
  Size surfaceSize = const Size(400, 300),
  Set<Brightness> brightnesses = const {Brightness.light, Brightness.dark},
  Set<TextDirection> directions = const {TextDirection.ltr},
  Set<AstryxDensity> densities = const {AstryxDensity.pointer},
  AstryxDefinedTheme? theme,
  bool disableAnimations = false,
  bool settle = false,
  double? animationFraction,
  Duration animationCycle = const Duration(milliseconds: 1000),
  AstryxToastController? toastController,
  Future<void> Function(WidgetTester tester)? beforeCapture,
}) async {
  assert(brightnesses.isNotEmpty, 'At least one brightness is required');
  assert(directions.isNotEmpty, 'At least one direction is required');
  assert(densities.isNotEmpty, 'At least one density is required');

  // Omitted for a single density so the existing filenames stay valid; a
  // widget that opts into both gets the axis in its name.
  final includeDensity = densities.length > 1;

  for (final brightness in brightnesses) {
    for (final direction in directions) {
      for (final density in densities) {
        await pumpAstryxWidget(
          tester,
          child,
          brightness: brightness,
          textDirection: direction,
          density: density,
          surfaceSize: surfaceSize,
          theme: theme,
          disableAnimations: disableAnimations,
          toastController: toastController,
        );

        // Phase 9 added this: an overlay has no appearance until it is open,
        // so the widget under test has to be *driven* before the frame is
        // captured. It runs once per matrix cell, after the pump, because
        // each cell is a fresh tree.
        await beforeCapture?.call(tester);

        // An animated widget has no stable frame on its own. Two ways to get
        // one: let a finite animation finish, or advance a looping one to a
        // named fraction of its own cycle. A fraction survives a duration
        // token changing; a hard-coded millisecond count does not.
        if (settle) {
          await tester.pumpAndSettle();
        } else if (animationFraction != null) {
          await tester.pump(animationCycle * animationFraction);
        }

        final suffix = includeDensity ? '.${density.name}' : '';
        await expectLater(
          find.byKey(astryxGoldenRootKey),
          matchesGoldenFile(
            'files/$name.${brightness.name}.${direction.name}$suffix.png',
          ),
        );
      }
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
  AstryxDensity density = AstryxDensity.pointer,
  Size surfaceSize = const Size(400, 300),
  double textScaleFactor = 1,
  bool disableAnimations = false,
  AstryxDefinedTheme? theme,
  TargetPlatform platform = TargetPlatform.macOS,
  AstryxToastController? toastController,
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    _AstryxTestHarness(
      brightness: brightness,
      textDirection: textDirection,
      density: density,
      surfaceSize: surfaceSize,
      textScaleFactor: textScaleFactor,
      disableAnimations: disableAnimations,
      theme: theme,
      platform: platform,
      toastController: toastController,
      child: child,
    ),
  );
}

/// Identifies the harness root, so goldens capture the harness rather than the
/// whole surface.
const Key astryxGoldenRootKey = ValueKey<String>('astryx.golden.root');

/// The environment a widget needs to render outside an app.
///
/// This is a real [AstryxThemeProvider]. The surface colour comes from
/// `--color-background-body`, so the harness and the app agree by construction
/// rather than by a hard-coded constant kept in sync by hand.
class _AstryxTestHarness extends StatelessWidget {
  const _AstryxTestHarness({
    required this.brightness,
    required this.textDirection,
    required this.density,
    required this.surfaceSize,
    required this.textScaleFactor,
    required this.disableAnimations,
    required this.platform,
    required this.child,
    this.theme,
    this.toastController,
  });

  final Brightness brightness;
  final TextDirection textDirection;
  final AstryxDensity density;
  final Size surfaceSize;
  final double textScaleFactor;
  final bool disableAnimations;
  final AstryxDefinedTheme? theme;
  final TargetPlatform platform;
  final AstryxToastController? toastController;
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQueryData(
      size: surfaceSize,
      platformBrightness: brightness,
      textScaler: TextScaler.linear(textScaleFactor),
      disableAnimations: disableAnimations,
    ),
    child: Directionality(
      textDirection: textDirection,
      child: AstryxThemeProvider(
        theme: theme,
        // `system` deliberately, so the `MediaQuery` above is what selects the
        // mode — the same path an app takes.
        density: density,
        platform: platform,
        toastController: toastController,
        child: Builder(
          builder: (context) {
            final data = AstryxTheme.of(context);
            return DefaultTextStyle(
              style: data
                  .textStyle(AstryxTypeRole.body)
                  .copyWith(color: data.color(AstryxColorToken.textPrimary)),
              child: ColoredBox(
                color: data.color(AstryxColorToken.backgroundBody),
                child: SizedBox(
                  key: astryxGoldenRootKey,
                  width: surfaceSize.width,
                  height: surfaceSize.height,
                  // An `Overlay`, because an app always has one: `AstryxApp`
                  // gets it from `WidgetsApp`'s navigator. Without it
                  // `EditableText` cannot build its selection handles and
                  // `OverlayPortal` — which the selector's dropdown uses —
                  // throws outright. A single full-surface entry, so layout is
                  // unchanged and the pre-Phase-8 goldens stay valid.
                  // `Overlay.wrap`, not `Overlay(initialEntries: …)`: the
                  // latter builds its entries once, so a second
                  // `pumpAstryxWidget` in the same test would keep showing
                  // the first widget.
                  child: Overlay.wrap(child: Center(child: child)),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
