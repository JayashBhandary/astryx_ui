import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Theme interpolation and the animated theme switch.
///
/// The Material equivalents are `ThemeData.lerp` and `AnimatedTheme`; what is
/// pinned here is that a mode or theme change cross-fades instead of
/// snapping, and that it still snaps when it should.
void main() {
  final light = AstryxThemeData.resolve(mode: AstryxThemeMode.light);
  final dark = AstryxThemeData.resolve(mode: AstryxThemeMode.dark);
  final accent = AstryxColorToken.accent;
  final body = AstryxColorToken.backgroundBody;

  group('AstryxThemeData.lerp', () {
    test('returns the ends unchanged at 0 and 1', () {
      expect(AstryxThemeData.lerp(light, dark, 0), same(light));
      expect(AstryxThemeData.lerp(light, dark, 1), same(dark));
      expect(AstryxThemeData.lerp(light, light, 0.5), same(light));
    });

    test('blends colours, lengths and text styles', () {
      final mid = AstryxThemeData.lerp(light, dark, 0.5);
      expect(
        mid.color(body),
        Color.lerp(light.color(body), dark.color(body), 0.5),
      );
      expect(
        mid.color(accent),
        Color.lerp(light.color(accent), dark.color(accent), 0.5),
      );

      final roomy = AstryxThemeData.resolve(
        mode: AstryxThemeMode.light,
        theme: stoneTheme,
      );
      const radius = AstryxRadiusToken.container;
      final halfway = AstryxThemeData.lerp(light, roomy, 0.25);
      expect(
        halfway.radius(radius),
        closeTo(
          light.radius(radius) +
              (roomy.radius(radius) - light.radius(radius)) * 0.25,
          1e-9,
        ),
      );
      expect(halfway.textStyle(AstryxTypeRole.body), isNotNull);
    });

    test('switches what cannot blend at the midpoint', () {
      expect(
        AstryxThemeData.lerp(light, dark, 0.4).mode,
        AstryxThemeMode.light,
      );
      expect(AstryxThemeData.lerp(light, dark, 0.6).mode, AstryxThemeMode.dark);
      expect(
        AstryxThemeData.lerp(light, dark, 0.4).brightness,
        Brightness.light,
      );
    });

    test('interpolates component themes', () {
      final a = light.copyWith(
        components: const AstryxComponentThemes(
          divider: AstryxDividerTheme(thickness: 1),
        ),
      );
      final b = light.copyWith(
        components: const AstryxComponentThemes(
          divider: AstryxDividerTheme(thickness: 3),
        ),
      );
      expect(AstryxThemeData.lerp(a, b, 0.5).divider.thickness, 2);
    });

    test('equality distinguishes interpolation steps', () {
      final a = AstryxThemeData.lerp(light, dark, 0.3);
      expect(a, AstryxThemeData.lerp(light, dark, 0.3));
      expect(a.hashCode, AstryxThemeData.lerp(light, dark, 0.3).hashCode);
      expect(a, isNot(AstryxThemeData.lerp(light, dark, 0.7)));
      expect(a, isNot(light));
    });

    test('copyWith of components keeps the blended values', () {
      final mid = AstryxThemeData.lerp(light, dark, 0.5);
      final merged = mid.mergeComponents(
        const AstryxComponentThemes(divider: AstryxDividerTheme(thickness: 4)),
      );
      expect(merged.color(body), mid.color(body));
      expect(merged.divider.thickness, 4);
    });
  });

  group('AstryxThemeProvider theme animation', () {
    Color? seen;

    Widget app(
      AstryxColorMode mode, {
      Duration? duration,
      bool reducedMotion = false,
    }) => MediaQuery(
      data: MediaQueryData(disableAnimations: reducedMotion),
      child: AstryxThemeProvider(
        mode: mode,
        themeAnimationDuration: duration,
        child: Builder(
          builder: (context) {
            seen = AstryxTheme.of(context).color(body);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    testWidgets('a mode change cross-fades instead of snapping', (
      tester,
    ) async {
      await tester.pumpWidget(app(AstryxColorMode.light));
      expect(seen, light.color(body));

      await tester.pumpWidget(app(AstryxColorMode.dark));
      // The first frame of the change is still the old theme.
      expect(seen, light.color(body));

      await tester.pump(
        light.duration(AstryxDurationToken.fastMax) ~/ 2,
      );
      expect(seen, isNot(light.color(body)));
      expect(seen, isNot(dark.color(body)));

      await tester.pumpAndSettle();
      expect(seen, dark.color(body));
    });

    testWidgets('Duration.zero switches in one frame', (tester) async {
      await tester.pumpWidget(
        app(AstryxColorMode.light, duration: Duration.zero),
      );
      await tester.pumpWidget(
        app(AstryxColorMode.dark, duration: Duration.zero),
      );
      await tester.pump();
      expect(seen, dark.color(body));
    });

    testWidgets('reduced motion switches in one frame', (tester) async {
      await tester.pumpWidget(app(AstryxColorMode.light, reducedMotion: true));
      await tester.pumpWidget(app(AstryxColorMode.dark, reducedMotion: true));
      await tester.pump();
      expect(seen, dark.color(body));
    });

    testWidgets('AstryxApp takes the duration too', (tester) async {
      Color? color;
      Widget build(AstryxColorMode mode) => AstryxApp(
        mode: mode,
        themeAnimationDuration: const Duration(seconds: 1),
        home: Builder(
          builder: (context) {
            color = AstryxTheme.of(context).color(body);
            return const SizedBox.shrink();
          },
        ),
      );

      await tester.pumpWidget(build(AstryxColorMode.light));
      await tester.pumpWidget(build(AstryxColorMode.dark));
      await tester.pump(const Duration(milliseconds: 500));
      expect(color, isNot(dark.color(body)));
      await tester.pump(const Duration(milliseconds: 600));
      expect(color, dark.color(body));
    });
  });

  testWidgets('AstryxAnimatedTheme animates a subtree', (tester) async {
    Color? seen;
    Widget build(AstryxThemeData data) => AstryxAnimatedTheme(
      data: data,
      duration: const Duration(milliseconds: 100),
      child: Builder(
        builder: (context) {
          seen = AstryxTheme.of(context).color(accent);
          return const SizedBox.shrink();
        },
      ),
    );

    await tester.pumpWidget(build(light));
    await tester.pumpWidget(build(dark));
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      seen,
      Color.lerp(light.color(accent), dark.color(accent), 0.5),
    );
    await tester.pumpAndSettle();
    expect(seen, dark.color(accent));
  });
}
