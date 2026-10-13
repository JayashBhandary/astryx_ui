import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `AstryxInputTheme`: the input chrome, app-wide and per widget.
///
/// The Material equivalent is `InputDecorationTheme`. What is pinned here is
/// that the shared input container reads it — so a text input and a selector
/// trigger change together — that a widget's own `theme:` wins, and that an
/// empty theme paints exactly what the tokens did before.
void main() {
  const red = Color(0xFFFF0000);
  const green = Color(0xFF00FF00);
  const blue = Color(0xFF0000FF);

  const appInput = AstryxInputTheme(
    backgroundColor: red,
    borderColor: green,
    borderWidth: 3,
    borderRadius: Radius.zero,
    contentPadding: EdgeInsets.all(5),
    gap: 11,
    textStyle: TextStyle(fontSize: 21),
    placeholderStyle: TextStyle(color: blue),
    cursorColor: blue,
    selectionColor: green,
  );

  /// The decoration the input container under [of] paints.
  BoxDecoration decorationIn(WidgetTester tester, Finder of) =>
      tester
              .widgetList<AnimatedContainer>(
                find.descendant(
                  of: of,
                  matching: find.byType(AnimatedContainer),
                ),
              )
              .first
              .decoration!
          as BoxDecoration;

  /// The padding the input container under [of] applies.
  EdgeInsetsGeometry? paddingIn(WidgetTester tester, Finder of) => tester
      .widgetList<AnimatedContainer>(
        find.descendant(of: of, matching: find.byType(AnimatedContainer)),
      )
      .first
      .padding;

  Border borderOf(BoxDecoration decoration) => decoration.border! as Border;

  Future<AstryxThemeData> pumpApp(
    WidgetTester tester,
    Widget child, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
  }) async {
    late AstryxThemeData seen;
    await tester.pumpWidget(
      AstryxApp(
        componentThemes: componentThemes,
        home: Center(
          child: SizedBox(
            width: 300,
            child: Builder(
              builder: (context) {
                seen = AstryxTheme.of(context);
                return child;
              },
            ),
          ),
        ),
      ),
    );
    return seen;
  }

  group('AstryxInputTheme', () {
    test('every field defaults to null', () {
      const theme = AstryxInputTheme();
      expect(theme.backgroundColor, isNull);
      expect(theme.borderColor, isNull);
      expect(theme.borderRadius, isNull);
      expect(theme.textStyle, isNull);
      expect(theme.cursorColor, isNull);
    });

    test('copyWith replaces only the given fields', () {
      final copy = appInput.copyWith(borderColor: blue, gap: 2);
      expect(copy.borderColor, blue);
      expect(copy.gap, 2);
      expect(copy.backgroundColor, red);
      expect(copy.borderRadius, Radius.zero);
      expect(appInput.copyWith(), appInput);
    });

    test('merge applies non-null fields and keeps the rest', () {
      final merged = appInput.merge(
        const AstryxInputTheme(
          borderColor: blue,
          focusBorderColor: red,
          errorBorderColor: green,
          disabledBackgroundColor: blue,
        ),
      );
      expect(merged.borderColor, blue);
      expect(merged.focusBorderColor, red);
      expect(merged.errorBorderColor, green);
      expect(merged.disabledBackgroundColor, blue);
      expect(merged.backgroundColor, red);
      expect(merged.borderWidth, 3);
      expect(merged.contentPadding, const EdgeInsets.all(5));
      expect(appInput.merge(null), same(appInput));
    });

    test('merge merges text styles rather than replacing them', () {
      final merged = appInput.merge(
        const AstryxInputTheme(
          textStyle: TextStyle(color: red),
          placeholderStyle: TextStyle(fontSize: 9),
        ),
      );
      expect(merged.textStyle!.fontSize, 21);
      expect(merged.textStyle!.color, red);
      expect(merged.placeholderStyle!.color, blue);
      expect(merged.placeholderStyle!.fontSize, 9);
    });

    test('lerp interpolates and treats null as absent', () {
      expect(AstryxInputTheme.lerp(null, null, 0.5), isNull);

      const a = AstryxInputTheme(
        borderWidth: 1,
        borderRadius: Radius.circular(4),
        backgroundColor: Color(0xFF000000),
      );
      const b = AstryxInputTheme(
        borderWidth: 3,
        borderRadius: Radius.circular(8),
        backgroundColor: Color(0xFFFFFFFF),
        gap: 10,
      );
      final mid = AstryxInputTheme.lerp(a, b, 0.5)!;
      expect(mid.borderWidth, 2);
      expect(mid.borderRadius, const Radius.circular(6));
      expect(
        mid.backgroundColor,
        Color.lerp(a.backgroundColor, b.backgroundColor, 0.5),
      );
      // One-sided values snap at the midpoint rather than growing from zero.
      expect(AstryxInputTheme.lerp(a, b, 0.25)!.gap, isNull);
      expect(AstryxInputTheme.lerp(a, b, 0.75)!.gap, 10);
      expect(AstryxInputTheme.lerp(a, b, 0), a);
      expect(AstryxInputTheme.lerp(a, b, 1), b);
    });

    test('== and hashCode compare by value', () {
      const twin = AstryxInputTheme(
        backgroundColor: red,
        borderColor: green,
        borderWidth: 3,
        borderRadius: Radius.zero,
        contentPadding: EdgeInsets.all(5),
        gap: 11,
        textStyle: TextStyle(fontSize: 21),
        placeholderStyle: TextStyle(color: blue),
        cursorColor: blue,
        selectionColor: green,
      );
      expect(twin, appInput);
      expect(twin.hashCode, appInput.hashCode);
      expect(appInput.copyWith(cursorColor: red), isNot(appInput));
      expect(const AstryxInputTheme(), const AstryxInputTheme());
    });

    test('is carried by AstryxComponentThemes', () {
      const themes = AstryxComponentThemes(input: appInput);
      expect(themes.input, appInput);
    });
  });

  group('defaults', () {
    testWidgets('an unthemed text input paints the token chrome', (
      tester,
    ) async {
      final data = await pumpApp(
        tester,
        const AstryxTextInput(placeholder: 'Name'),
      );
      final input = find.byType(AstryxTextInput);
      final decoration = decorationIn(tester, input);
      expect(
        decoration.color,
        data.color(AstryxColorToken.backgroundSurface),
      );
      expect(
        borderOf(decoration).top.color,
        data.color(AstryxColorToken.borderEmphasized),
      );
      expect(borderOf(decoration).top.width, data.borderWidth());
      expect(
        decoration.borderRadius,
        BorderRadius.all(
          Radius.circular(data.radius(AstryxRadiusToken.element)),
        ),
      );
      expect(
        paddingIn(tester, input),
        EdgeInsetsDirectional.symmetric(
          horizontal: data.spacing(AstryxSpacingToken.spacing2),
        ),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.cursorColor, data.color(AstryxColorToken.accent));
      expect(
        editable.style,
        data
            .textStyle(AstryxTypeRole.body)
            .copyWith(color: data.color(AstryxColorToken.textPrimary)),
      );
    });

    testWidgets('an empty input theme paints the same as no theme', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AstryxSelector<int>(
          options: <AstryxSelectorEntry<int>>[
            AstryxSelectorOption(value: 1, label: 'One'),
          ],
          value: null,
        ),
      );
      final plain = decorationIn(tester, find.byType(AstryxSelector<int>));

      await pumpApp(
        tester,
        const AstryxSelector<int>(
          options: <AstryxSelectorEntry<int>>[
            AstryxSelectorOption(value: 1, label: 'One'),
          ],
          value: null,
          theme: AstryxInputTheme(),
        ),
        // Explicit on purpose: the point is an empty theme set at both levels.
        // ignore: avoid_redundant_argument_values
        componentThemes: const AstryxComponentThemes(
          // Explicit on purpose, as above.
          // ignore: avoid_redundant_argument_values
          input: AstryxInputTheme(),
        ),
      );
      expect(decorationIn(tester, find.byType(AstryxSelector<int>)), plain);
    });
  });

  group('app-wide input theme', () {
    testWidgets('restyles a text input', (tester) async {
      await pumpApp(
        tester,
        const AstryxTextInput(placeholder: 'Name'),
        componentThemes: const AstryxComponentThemes(input: appInput),
      );
      final input = find.byType(AstryxTextInput);
      final decoration = decorationIn(tester, input);
      expect(decoration.color, red);
      expect(borderOf(decoration).top.color, green);
      expect(borderOf(decoration).top.width, 3);
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(paddingIn(tester, input), const EdgeInsets.all(5));

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.cursorColor, blue);
      expect(editable.selectionColor, green);
      expect(editable.style.fontSize, 21);

      final placeholder = tester.widget<Text>(find.text('Name'));
      expect(placeholder.style!.color, blue);
      expect(placeholder.style!.fontSize, 21);
    });

    testWidgets('restyles a selector trigger through the shared container', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AstryxSelector<int>(
          options: <AstryxSelectorEntry<int>>[
            AstryxSelectorOption(value: 1, label: 'One'),
          ],
          value: 1,
        ),
        componentThemes: const AstryxComponentThemes(input: appInput),
      );
      final decoration = decorationIn(
        tester,
        find.byType(AstryxSelector<int>),
      );
      expect(decoration.color, red);
      expect(borderOf(decoration).top.color, green);
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(tester.widget<Text>(find.text('One')).style!.fontSize, 21);
    });

    testWidgets('restyles a number input', (tester) async {
      await pumpApp(
        tester,
        const AstryxNumberInput(value: 3),
        componentThemes: const AstryxComponentThemes(input: appInput),
      );
      final decoration = decorationIn(
        tester,
        find.byType(AstryxNumberInput),
      );
      expect(decoration.color, red);
      expect(borderOf(decoration).top.color, green);
    });

    testWidgets('applies under AstryxComponentTheme for a subtree', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AstryxComponentTheme(
          data: AstryxComponentThemes(input: appInput),
          child: AstryxTextInput(),
        ),
      );
      expect(decorationIn(tester, find.byType(AstryxTextInput)).color, red);
    });

    testWidgets('colours the focus and error borders', (tester) async {
      const themed = AstryxComponentThemes(
        input: AstryxInputTheme(focusBorderColor: red, errorBorderColor: blue),
      );
      await pumpApp(
        tester,
        const AstryxTextInput(status: AstryxFieldStatus.error('Required')),
        componentThemes: themed,
      );
      expect(
        borderOf(decorationIn(tester, find.byType(AstryxTextInput))).top.color,
        blue,
      );

      await pumpApp(tester, const AstryxTextInput(), componentThemes: themed);
      await tester.tap(find.byType(AstryxTextInput));
      await tester.pumpAndSettle();
      expect(
        borderOf(decorationIn(tester, find.byType(AstryxTextInput))).top.color,
        red,
      );
    });

    testWidgets('a disabled input keeps the disabled text colour', (
      tester,
    ) async {
      final data = await pumpApp(
        tester,
        const AstryxTextInput(enabled: false),
        componentThemes: const AstryxComponentThemes(
          input: AstryxInputTheme(
            textStyle: TextStyle(color: red),
            disabledBackgroundColor: green,
          ),
        ),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.style.color, data.color(AstryxColorToken.textDisabled));
      expect(decorationIn(tester, find.byType(AstryxTextInput)).color, green);
    });
  });

  group('widget theme', () {
    testWidgets('wins over the app-wide theme on a text input', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AstryxTextInput(
          theme: AstryxInputTheme(backgroundColor: blue, cursorColor: red),
        ),
        componentThemes: const AstryxComponentThemes(input: appInput),
      );
      final decoration = decorationIn(tester, find.byType(AstryxTextInput));
      expect(decoration.color, blue);
      // Fields the widget theme leaves null still come from the app.
      expect(borderOf(decoration).top.color, green);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).cursorColor,
        red,
      );
    });

    testWidgets('wins on a number input and a selector', (tester) async {
      await pumpApp(
        tester,
        const Column(
          children: <Widget>[
            AstryxNumberInput(
              value: 1,
              theme: AstryxInputTheme(borderColor: red),
            ),
            AstryxSelector<int>(
              options: <AstryxSelectorEntry<int>>[
                AstryxSelectorOption(value: 1, label: 'One'),
              ],
              value: null,
              theme: AstryxInputTheme(borderColor: blue),
            ),
          ],
        ),
        componentThemes: const AstryxComponentThemes(input: appInput),
      );
      expect(
        borderOf(
          decorationIn(tester, find.byType(AstryxNumberInput)),
        ).top.color,
        red,
      );
      expect(
        borderOf(
          decorationIn(tester, find.byType(AstryxSelector<int>)),
        ).top.color,
        blue,
      );
    });

    testWidgets('reaches a text area', (tester) async {
      await pumpApp(
        tester,
        const AstryxTextArea(theme: AstryxInputTheme(backgroundColor: red)),
      );
      expect(decorationIn(tester, find.byType(AstryxTextArea)).color, red);
    });
  });
}
