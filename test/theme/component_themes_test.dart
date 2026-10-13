import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// App-wide and subtree component themes.
///
/// The Material equivalent is `MaterialApp(theme: ThemeData(buttonTheme: …))`
/// and `Theme(data: Theme.of(context).copyWith(…))`. What is pinned here is
/// that the same two things work without hand-building an `AstryxTheme`.
void main() {
  const squareButtons = AstryxComponentThemes(
    button: AstryxButtonTheme(borderRadius: BorderRadius.zero),
  );

  /// The decoration the first button under [tester] paints.
  BoxDecoration buttonDecoration(WidgetTester tester) =>
      tester
              .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
              .first
              .decoration!
          as BoxDecoration;

  /// Pumps [child] under a provider and returns the theme a widget there sees.
  Future<AstryxThemeData> themeUnder(
    WidgetTester tester, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
    AstryxComponentThemes? darkComponentThemes,
    AstryxColorMode mode = AstryxColorMode.light,
  }) async {
    late AstryxThemeData seen;
    await tester.pumpWidget(
      AstryxThemeProvider(
        mode: mode,
        componentThemes: componentThemes,
        darkComponentThemes: darkComponentThemes,
        child: Builder(
          builder: (context) {
            seen = AstryxTheme.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    // A mode change between calls cross-fades; read the settled theme.
    await tester.pumpAndSettle();
    return seen;
  }

  group('AstryxComponentThemes', () {
    test('defaults to empty slots', () {
      const empty = AstryxComponentThemes();
      expect(empty.button, const AstryxButtonTheme());
      expect(empty.text, const AstryxTextTheme());
      expect(empty.heading, const AstryxTextTheme());
      expect(empty.divider, const AstryxDividerTheme());
      expect(empty.icon, const AstryxIconTheme());
    });

    test('merge applies non-null fields slot by slot', () {
      const outer = AstryxComponentThemes(
        button: AstryxButtonTheme(height: 40),
        divider: AstryxDividerTheme(thickness: 2),
      );
      const inner = AstryxComponentThemes(
        button: AstryxButtonTheme(borderRadius: BorderRadius.zero),
      );
      final merged = outer.merge(inner);

      expect(merged.button.height, 40);
      expect(merged.button.borderRadius, BorderRadius.zero);
      expect(merged.divider.thickness, 2);
      expect(outer.merge(null), same(outer));
    });

    test('copyWith replaces a slot wholesale', () {
      const base = AstryxComponentThemes(
        button: AstryxButtonTheme(height: 40),
      );
      final next = base.copyWith(
        button: const AstryxButtonTheme(borderRadius: BorderRadius.zero),
      );
      expect(next.button.height, isNull);
      expect(next.button.borderRadius, BorderRadius.zero);
    });

    test('lerp interpolates each slot', () {
      const a = AstryxComponentThemes(
        divider: AstryxDividerTheme(thickness: 0),
      );
      const b = AstryxComponentThemes(
        divider: AstryxDividerTheme(thickness: 4),
      );
      expect(AstryxComponentThemes.lerp(a, b, 0.5)!.divider.thickness, 2);
      expect(AstryxComponentThemes.lerp(a, a, 0.5), same(a));
      expect(AstryxComponentThemes.lerp(null, null, 0.5), isNull);
    });

    test('equality is by value', () {
      // Not a constant, so the two instances are not canonicalised into one.
      final two = double.parse('2');
      expect(
        const AstryxComponentThemes(divider: AstryxDividerTheme(thickness: 2)),
        AstryxComponentThemes(divider: AstryxDividerTheme(thickness: two)),
      );
      expect(
        const AstryxComponentThemes().hashCode,
        const AstryxComponentThemes().hashCode,
      );
      expect(squareButtons, isNot(const AstryxComponentThemes()));
    });
  });

  group('AstryxThemeData', () {
    final light = AstryxThemeData.resolve(mode: AstryxThemeMode.light);

    test('components bundles the slots it carries', () {
      final data = light.copyWith(button: squareButtons.button);
      expect(data.components.button, squareButtons.button);
      expect(data.components.divider, const AstryxDividerTheme());
    });

    test('copyWith(components:) sets every slot; a named slot wins', () {
      const themes = AstryxComponentThemes(
        button: AstryxButtonTheme(height: 40),
        divider: AstryxDividerTheme(thickness: 2),
      );
      final data = light.copyWith(
        components: themes,
        button: const AstryxButtonTheme(height: 50),
      );
      expect(data.divider.thickness, 2);
      expect(data.button.height, 50);
    });

    test('a component-only copy keeps every resolved value', () {
      final data = light.copyWith(components: squareButtons);
      for (final token in AstryxColorToken.values) {
        expect(data.color(token), light.color(token), reason: token.cssName);
      }
      for (final role in AstryxTypeRole.values) {
        expect(data.textStyle(role), light.textStyle(role));
      }
      expect(data.mode, light.mode);
      expect(data.tokens, light.tokens);
    });

    test('changing the mode still reconverts', () {
      final dark = light.copyWith(
        mode: AstryxThemeMode.dark,
        components: squareButtons,
      );
      expect(dark.mode, AstryxThemeMode.dark);
      expect(
        dark.color(AstryxColorToken.backgroundBody),
        isNot(light.color(AstryxColorToken.backgroundBody)),
      );
      expect(dark.button, squareButtons.button);
    });

    test('mergeComponents keeps the fields the override leaves null', () {
      final base = light.copyWith(
        button: const AstryxButtonTheme(height: 40),
      );
      final merged = base.mergeComponents(squareButtons);
      expect(merged.button.height, 40);
      expect(merged.button.borderRadius, BorderRadius.zero);
      expect(base.mergeComponents(null), same(base));
    });
  });

  group('AstryxThemeProvider.componentThemes', () {
    testWidgets('reaches AstryxTheme.of below it', (tester) async {
      final data = await themeUnder(tester, componentThemes: squareButtons);
      expect(data.button.borderRadius, BorderRadius.zero);
    });

    testWidgets('an unset provider carries empty component themes', (
      tester,
    ) async {
      final data = await themeUnder(tester);
      expect(data.components, const AstryxComponentThemes());
    });

    testWidgets('darkComponentThemes applies in dark mode only', (
      tester,
    ) async {
      const lightThemes = AstryxComponentThemes(
        divider: AstryxDividerTheme(thickness: 1),
      );
      const darkThemes = AstryxComponentThemes(
        divider: AstryxDividerTheme(thickness: 3),
      );

      final inLight = await themeUnder(
        tester,
        componentThemes: lightThemes,
        darkComponentThemes: darkThemes,
      );
      expect(inLight.divider.thickness, 1);

      final inDark = await themeUnder(
        tester,
        componentThemes: lightThemes,
        darkComponentThemes: darkThemes,
        mode: AstryxColorMode.dark,
      );
      expect(inDark.divider.thickness, 3);
    });

    testWidgets('dark mode falls back to componentThemes', (tester) async {
      final data = await themeUnder(
        tester,
        componentThemes: squareButtons,
        mode: AstryxColorMode.dark,
      );
      expect(data.button.borderRadius, BorderRadius.zero);
    });

    testWidgets('system mode picks the dark bundle on a dark platform', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      late AstryxThemeData seen;
      await tester.pumpWidget(
        MediaQuery.fromView(
          view: tester.view,
          child: AstryxThemeProvider(
            componentThemes: const AstryxComponentThemes(
              divider: AstryxDividerTheme(thickness: 1),
            ),
            darkComponentThemes: const AstryxComponentThemes(
              divider: AstryxDividerTheme(thickness: 3),
            ),
            child: Builder(
              builder: (context) {
                seen = AstryxTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(seen.mode, AstryxThemeMode.dark);
      expect(seen.divider.thickness, 3);
    });

    testWidgets('a real button paints with the app-wide theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: squareButtons,
          home: Center(
            child: AstryxButton(label: 'Save', onPressed: () {}),
          ),
        ),
      );
      expect(buttonDecoration(tester).borderRadius, BorderRadius.zero);
    });

    testWidgets('the default button is not square, so the test means it', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          home: Center(
            child: AstryxButton(label: 'Save', onPressed: () {}),
          ),
        ),
      );
      expect(buttonDecoration(tester).borderRadius, isNot(BorderRadius.zero));
    });

    testWidgets('a widget-level theme still wins over the app-wide one', (
      tester,
    ) async {
      final round = BorderRadius.circular(20);
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: squareButtons,
          home: Center(
            child: AstryxButton(
              label: 'Save',
              theme: AstryxButtonTheme(borderRadius: round),
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(buttonDecoration(tester).borderRadius, round);
    });
  });

  group('AstryxComponentTheme', () {
    testWidgets('merges over the enclosing themes for its subtree', (
      tester,
    ) async {
      late AstryxThemeData outside;
      late AstryxThemeData inside;
      await tester.pumpWidget(
        AstryxThemeProvider(
          mode: AstryxColorMode.dark,
          componentThemes: const AstryxComponentThemes(
            button: AstryxButtonTheme(height: 40),
          ),
          child: Builder(
            builder: (context) {
              outside = AstryxTheme.of(context);
              return AstryxComponentTheme(
                data: squareButtons,
                child: Builder(
                  builder: (context) {
                    inside = AstryxTheme.of(context);
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(outside.button.borderRadius, isNull);
      expect(inside.button.borderRadius, BorderRadius.zero);
      // Merged, not replaced.
      expect(inside.button.height, 40);
      // Tokens and mode carry through.
      expect(inside.mode, AstryxThemeMode.dark);
      expect(
        inside.color(AstryxColorToken.accent),
        outside.color(AstryxColorToken.accent),
      );
    });

    testWidgets('keeps the density and icon registry in effect', (
      tester,
    ) async {
      late AstryxDensity density;
      late AstryxIconRegistry icons;
      final registry = AstryxIconRegistry.defaults.copyWith(
        <AstryxIconName, IconData>{AstryxIconName.close: const IconData(0x41)},
      );

      await tester.pumpWidget(
        AstryxThemeProvider(
          density: AstryxDensity.touch,
          platform: TargetPlatform.macOS,
          icons: registry,
          child: AstryxComponentTheme(
            data: squareButtons,
            child: Builder(
              builder: (context) {
                density = AstryxTheme.densityOf(context);
                icons = AstryxTheme.iconsOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(density, AstryxDensity.touch);
      expect(icons, same(registry));
    });

    testWidgets('nested scopes stack', (tester) async {
      late AstryxThemeData seen;
      await tester.pumpWidget(
        AstryxThemeProvider(
          child: AstryxComponentTheme(
            data: const AstryxComponentThemes(
              divider: AstryxDividerTheme(thickness: 2),
            ),
            child: AstryxComponentTheme(
              data: squareButtons,
              child: Builder(
                builder: (context) {
                  seen = AstryxTheme.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      expect(seen.divider.thickness, 2);
      expect(seen.button.borderRadius, BorderRadius.zero);
    });

    testWidgets('a real button below it paints square', (tester) async {
      await tester.pumpWidget(
        AstryxApp(
          home: Center(
            child: AstryxComponentTheme(
              data: squareButtons,
              child: AstryxButton(label: 'Save', onPressed: () {}),
            ),
          ),
        ),
      );
      expect(buttonDecoration(tester).borderRadius, BorderRadius.zero);
    });

    testWidgets('throws the usual fix-it with no theme above', (tester) async {
      await tester.pumpWidget(
        const AstryxComponentTheme(
          data: AstryxComponentThemes(),
          child: SizedBox.shrink(),
        ),
      );
      expect(tester.takeException(), isA<FlutterError>());
    });
  });
}
