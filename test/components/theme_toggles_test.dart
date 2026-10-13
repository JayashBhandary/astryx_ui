import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The per-widget themes of the selection controls: checkbox, radio, switch.
///
/// The Material equivalents are `CheckboxThemeData`, `RadioThemeData` and
/// `SwitchThemeData`. What is pinned here is the class contract, that the
/// app-wide slot reaches the painted control, that the widget's own `theme:`
/// wins over it, and that an empty theme paints exactly the token defaults.
void main() {
  const red = Color(0xFFFF0000);
  const green = Color(0xFF00FF00);
  const blue = Color(0xFF0000FF);

  group('AstryxCheckboxTheme', () {
    const a = AstryxCheckboxTheme(fillColor: red, size: 10, borderWidth: 1);
    const b = AstryxCheckboxTheme(fillColor: blue, size: 20);

    test('merge applies non-null fields of the other', () {
      final merged = a.merge(const AstryxCheckboxTheme(checkColor: green));
      expect(merged.fillColor, red);
      expect(merged.checkColor, green);
      expect(merged.size, 10);
      expect(a.merge(b).fillColor, blue);
      expect(a.merge(b).borderWidth, 1);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only the given fields', () {
      final next = a.copyWith(borderRadius: BorderRadius.zero);
      expect(next.borderRadius, BorderRadius.zero);
      expect(next.fillColor, red);
      expect(next.size, 10);
    });

    test('lerp interpolates and treats null as absent', () {
      final mid = AstryxCheckboxTheme.lerp(a, b, 0.5)!;
      expect(mid.size, 15);
      expect(mid.fillColor, Color.lerp(red, blue, 0.5));
      expect(mid.borderWidth, isNull);
      expect(AstryxCheckboxTheme.lerp(a, b, 0.2)!.borderWidth, 1);
      expect(AstryxCheckboxTheme.lerp(null, null, 0.5), isNull);
    });

    test('== and hashCode compare by value', () {
      expect(
        a,
        const AstryxCheckboxTheme(fillColor: red, size: 10).copyWith(
          borderWidth: 1,
        ),
      );
      expect(
        a.hashCode,
        const AstryxCheckboxTheme(
          fillColor: red,
          size: 10,
          borderWidth: 1,
        ).hashCode,
      );
      expect(a, isNot(b));
    });
  });

  group('AstryxRadioTheme', () {
    const a = AstryxRadioTheme(selectedColor: red, dotSize: 4);
    const b = AstryxRadioTheme(selectedColor: blue, dotSize: 8, size: 30);

    test('merge applies non-null fields of the other', () {
      final merged = a.merge(b);
      expect(merged.selectedColor, blue);
      expect(merged.size, 30);
      expect(a.merge(const AstryxRadioTheme(dotColor: green)).dotSize, 4);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only the given fields', () {
      final next = a.copyWith(borderColor: green);
      expect(next.borderColor, green);
      expect(next.selectedColor, red);
    });

    test('lerp interpolates and treats null as absent', () {
      final mid = AstryxRadioTheme.lerp(a, b, 0.5)!;
      expect(mid.dotSize, 6);
      expect(mid.selectedColor, Color.lerp(red, blue, 0.5));
      expect(mid.size, 30);
      expect(AstryxRadioTheme.lerp(a, b, 0.4)!.size, isNull);
      expect(AstryxRadioTheme.lerp(null, null, 0.5), isNull);
    });

    test('== and hashCode compare by value', () {
      expect(a, const AstryxRadioTheme(selectedColor: red, dotSize: 4));
      expect(
        a.hashCode,
        const AstryxRadioTheme(selectedColor: red, dotSize: 4).hashCode,
      );
      expect(a, isNot(b));
    });
  });

  group('AstryxSwitchTheme', () {
    const a = AstryxSwitchTheme(activeTrackColor: red, trackWidth: 40);
    const b = AstryxSwitchTheme(activeTrackColor: blue, trackWidth: 60);

    test('merge applies non-null fields of the other', () {
      final merged = a.merge(const AstryxSwitchTheme(thumbColor: green));
      expect(merged.activeTrackColor, red);
      expect(merged.thumbColor, green);
      expect(a.merge(b).trackWidth, 60);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only the given fields', () {
      final next = a.copyWith(thumbSize: 12);
      expect(next.thumbSize, 12);
      expect(next.trackWidth, 40);
    });

    test('lerp interpolates and treats null as absent', () {
      final mid = AstryxSwitchTheme.lerp(a, b, 0.5)!;
      expect(mid.trackWidth, 50);
      expect(mid.activeTrackColor, Color.lerp(red, blue, 0.5));
      expect(AstryxSwitchTheme.lerp(null, b, 0.4)!.trackWidth, isNull);
      expect(AstryxSwitchTheme.lerp(null, b, 0.6)!.trackWidth, 60);
      expect(AstryxSwitchTheme.lerp(null, null, 0.5), isNull);
    });

    test('== and hashCode compare by value', () {
      expect(a, const AstryxSwitchTheme(activeTrackColor: red, trackWidth: 40));
      expect(
        a.hashCode,
        const AstryxSwitchTheme(activeTrackColor: red, trackWidth: 40).hashCode,
      );
      expect(a, isNot(b));
    });
  });

  /// The [AnimatedContainer]s under the first [T], outermost first.
  List<AnimatedContainer> containersIn<T>(WidgetTester tester) => tester
      .widgetList<AnimatedContainer>(
        find.descendant(
          of: find.byType(T),
          matching: find.byType(AnimatedContainer),
        ),
      )
      .toList();

  BoxDecoration decorationOf(AnimatedContainer c) =>
      c.decoration! as BoxDecoration;

  /// The theme the first [T] in the tree resolves against.
  AstryxThemeData themeOf<T>(WidgetTester tester) =>
      AstryxTheme.of(tester.element(find.byType(T).first));

  Future<void> pumpApp(
    WidgetTester tester,
    Widget child, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
  }) => tester.pumpWidget(
    AstryxApp(
      componentThemes: componentThemes,
      home: Center(child: child),
    ),
  );

  group('AstryxCheckbox', () {
    Widget checkbox({AstryxCheckboxTheme? theme, bool value = true}) =>
        AstryxCheckbox(
          label: 'Accept',
          value: value,
          theme: theme,
          onChanged: (_) {},
        );

    BoxDecoration box(WidgetTester tester) =>
        decorationOf(containersIn<AstryxCheckbox>(tester).single);

    testWidgets('an empty theme paints the token defaults', (tester) async {
      await pumpApp(tester, checkbox());
      final theme = themeOf<AstryxCheckbox>(tester);
      final decoration = box(tester);
      expect(decoration.color, theme.color(AstryxColorToken.accent));
      expect(
        decoration.borderRadius,
        theme.borderRadius(AstryxRadiusToken.inner),
      );
      expect(decoration.border!.top.width, theme.borderWidth());
      expect(tester.getSize(find.byType(AnimatedContainer).first).width, 24);

      await pumpApp(tester, checkbox(value: false));
      expect(
        box(tester).border!.top.color,
        theme.color(AstryxColorToken.borderEmphasized),
      );
    });

    testWidgets('the app-wide theme reaches the box', (tester) async {
      await pumpApp(
        tester,
        checkbox(),
        componentThemes: const AstryxComponentThemes(
          checkbox: AstryxCheckboxTheme(
            fillColor: red,
            borderRadius: BorderRadius.zero,
            borderWidth: 3,
            size: 30,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final decoration = box(tester);
      expect(decoration.color, red);
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(decoration.border!.top.width, 3);
      expect(
        tester
            .getSize(
              find.descendant(
                of: find.byType(AstryxCheckbox),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .width,
        30,
      );
    });

    testWidgets('the widget theme wins over the app-wide one', (tester) async {
      await pumpApp(
        tester,
        checkbox(theme: const AstryxCheckboxTheme(fillColor: blue)),
        componentThemes: const AstryxComponentThemes(
          checkbox: AstryxCheckboxTheme(fillColor: red, borderWidth: 3),
        ),
      );
      final decoration = box(tester);
      expect(decoration.color, blue);
      expect(decoration.border!.top.width, 3);
    });

    testWidgets('unchecked colours and the tick colour apply', (tester) async {
      await pumpApp(
        tester,
        checkbox(
          value: false,
          theme: const AstryxCheckboxTheme(
            backgroundColor: green,
            borderColor: red,
          ),
        ),
      );
      final decoration = box(tester);
      expect(decoration.color, green);
      expect(decoration.border!.top.color, red);

      await pumpApp(
        tester,
        AstryxCheckbox.tristate(
          label: 'All',
          value: AstryxCheckboxValue.indeterminate,
          theme: const AstryxCheckboxTheme(checkColor: green),
          onChanged: (_) {},
        ),
      );
      // The indeterminate bar: the only borderless decorated container in
      // the box (the box's own container carries the outline).
      final bar = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AstryxCheckbox),
              matching: find.byType(Container),
            ),
          )
          .lastWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).border == null,
          );
      expect((bar.decoration! as BoxDecoration).color, green);
    });

    testWidgets('disabledOpacity applies to a disabled box', (tester) async {
      await pumpApp(
        tester,
        AstryxCheckbox(
          label: 'Off',
          value: true,
          enabled: false,
          theme: const AstryxCheckboxTheme(disabledOpacity: 0.3),
        ),
      );
      final opacity = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.byType(AnimatedContainer),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0.3);
    });

    testWidgets('AstryxCheckboxList threads its theme to every row', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AstryxCheckboxList<int>(
          options: const <AstryxCheckboxOption<int>>[
            AstryxCheckboxOption(value: 1, label: 'One'),
            AstryxCheckboxOption(value: 2, label: 'Two'),
          ],
          values: const <int>{1, 2},
          theme: const AstryxCheckboxTheme(fillColor: red),
          onChanged: (_) {},
        ),
      );
      final colors = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(AstryxCheckbox),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .map((c) => decorationOf(c).color);
      expect(colors, <Color>[red, red]);
    });
  });

  group('AstryxRadioList', () {
    Widget radios({AstryxRadioTheme? theme}) => AstryxRadioList<int>(
      value: 1,
      theme: theme,
      onChanged: (_) {},
      options: const <AstryxRadioOption<int>>[
        AstryxRadioOption(value: 1, label: 'One'),
        AstryxRadioOption(value: 2, label: 'Two'),
      ],
    );

    List<BoxDecoration> circles(WidgetTester tester) =>
        containersIn<AstryxRadioList<int>>(tester).map(decorationOf).toList();

    BoxDecoration dot(WidgetTester tester) =>
        tester
                .widgetList<Container>(
                  find.descendant(
                    of: find.byType(AnimatedScale),
                    matching: find.byType(Container),
                  ),
                )
                .first
                .decoration!
            as BoxDecoration;

    testWidgets('an empty theme paints the token defaults', (tester) async {
      await pumpApp(tester, radios());
      final theme = themeOf<AstryxRadioList<int>>(tester);
      final [selected, unselected] = circles(tester);
      expect(selected.color, theme.color(AstryxColorToken.accent));
      expect(
        unselected.border!.top.color,
        theme.color(AstryxColorToken.borderEmphasized),
      );
      expect(dot(tester).color, theme.color(AstryxColorToken.onAccent));
    });

    testWidgets('the app-wide theme reaches the radios', (tester) async {
      await pumpApp(
        tester,
        radios(),
        componentThemes: const AstryxComponentThemes(
          radio: AstryxRadioTheme(
            selectedColor: red,
            borderColor: green,
            dotColor: blue,
            size: 30,
            dotSize: 12,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final [selected, unselected] = circles(tester);
      expect(selected.color, red);
      expect(unselected.border!.top.color, green);
      expect(dot(tester).color, blue);
      final circle = find
          .descendant(
            of: find.byType(AstryxRadioList<int>),
            matching: find.byType(AnimatedContainer),
          )
          .first;
      expect(tester.getSize(circle), const Size(30, 30));
    });

    testWidgets('the widget theme wins over the app-wide one', (tester) async {
      await pumpApp(
        tester,
        radios(theme: const AstryxRadioTheme(selectedColor: blue)),
        componentThemes: const AstryxComponentThemes(
          radio: AstryxRadioTheme(selectedColor: red, borderWidth: 3),
        ),
      );
      final [selected, _] = circles(tester);
      expect(selected.color, blue);
      expect(selected.border!.top.width, 3);
    });
  });

  group('AstryxSwitch', () {
    Widget toggle({AstryxSwitchTheme? theme, bool value = true}) =>
        AstryxSwitch(
          label: 'Notify',
          value: value,
          theme: theme,
          onChanged: (_) {},
        );

    testWidgets('an empty theme paints the token defaults', (tester) async {
      await pumpApp(tester, toggle());
      final theme = themeOf<AstryxSwitch>(tester);
      final [track, thumb] = containersIn<AstryxSwitch>(tester);
      expect(decorationOf(track).color, theme.color(AstryxColorToken.accent));
      expect(
        decorationOf(thumb).color,
        theme.color(AstryxColorToken.backgroundSurface),
      );
      final finder = find.descendant(
        of: find.byType(AstryxSwitch),
        matching: find.byType(AnimatedContainer),
      );
      expect(tester.getSize(finder.first), const Size(40, 24));

      await pumpApp(tester, toggle(value: false));
      await tester.pumpAndSettle();
      expect(
        decorationOf(containersIn<AstryxSwitch>(tester).first).color,
        theme.color(AstryxColorToken.backgroundGray),
      );
    });

    testWidgets('the app-wide theme reaches the track and thumb', (
      tester,
    ) async {
      await pumpApp(
        tester,
        toggle(),
        componentThemes: const AstryxComponentThemes(
          switchTheme: AstryxSwitchTheme(
            activeTrackColor: red,
            thumbColor: green,
            trackWidth: 52,
            trackHeight: 28,
            activeThumbSize: 18,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final [track, thumb] = containersIn<AstryxSwitch>(tester);
      expect(decorationOf(track).color, red);
      expect(decorationOf(thumb).color, green);
      final finder = find.descendant(
        of: find.byType(AstryxSwitch),
        matching: find.byType(AnimatedContainer),
      );
      expect(tester.getSize(finder.first), const Size(52, 28));
      expect(tester.getSize(finder.last), const Size(18, 18));
    });

    testWidgets('the widget theme wins over the app-wide one', (tester) async {
      await pumpApp(
        tester,
        toggle(
          value: false,
          theme: const AstryxSwitchTheme(trackColor: blue),
        ),
        componentThemes: const AstryxComponentThemes(
          switchTheme: AstryxSwitchTheme(trackColor: red, thumbColor: green),
        ),
      );
      final [track, thumb] = containersIn<AstryxSwitch>(tester);
      expect(decorationOf(track).color, blue);
      expect(decorationOf(thumb).color, green);
    });
  });
}
