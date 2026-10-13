import 'dart:ui' show PointerDeviceKind;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/gestures.dart' show kSecondaryMouseButton;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Component themes for menus, tooltips and toasts.
///
/// The Material equivalents are `MenuThemeData`, `TooltipThemeData` and
/// `SnackBarThemeData`. What is pinned here is the class contract, that the
/// app-wide slot reaches what is painted, that a widget's own `theme:` wins
/// over it, and that an empty theme leaves the token defaults alone.
void main() {
  setUp(AstryxOverlayStack.reset);

  const red = Color(0xFFFF0000);
  const green = Color(0xFF00FF00);
  const blue = Color(0xFF0000FF);
  const shadow = <AstryxShadow>[
    AstryxShadow(color: Color(0x33000000), blurRadius: 4),
  ];

  /// Every painted [BoxDecoration] whose fill is [color].
  ///
  /// [DecoratedBox] only: a `Container` paints through one, so matching both
  /// would count every decoration twice.
  Finder decoratedWith(Color color) => find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == color,
  );

  BoxDecoration decorationOf(WidgetTester tester, Finder finder) =>
      tester.widgetList<DecoratedBox>(finder).first.decoration as BoxDecoration;

  /// The theme a widget under [tester]'s app sees.
  AstryxThemeData themeOf(WidgetTester tester, Finder finder) =>
      AstryxTheme.of(tester.element(finder));

  Future<void> pumpApp(
    WidgetTester tester,
    Widget home, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
    AstryxDensity density = AstryxDensity.pointer,
  }) async {
    await tester.binding.setSurfaceSize(const Size(600, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      AstryxApp(
        mode: AstryxColorMode.light,
        density: density,
        componentThemes: componentThemes,
        home: home,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AstryxMenuTheme', () {
    const a = AstryxMenuTheme(
      backgroundColor: red,
      iconSize: 10,
      itemTextStyle: TextStyle(fontSize: 10),
      shadows: shadow,
    );
    const b = AstryxMenuTheme(
      backgroundColor: blue,
      iconSize: 20,
      itemTextStyle: TextStyle(fontWeight: FontWeight.w700),
      dividerColor: green,
    );

    test('merge applies non-null fields and merges text styles', () {
      final merged = a.merge(b);
      expect(merged.backgroundColor, blue);
      expect(merged.iconSize, 20);
      expect(merged.dividerColor, green);
      expect(merged.shadows, shadow);
      expect(merged.itemTextStyle?.fontSize, 10);
      expect(merged.itemTextStyle?.fontWeight, FontWeight.w700);
      expect(a.merge(null), same(a));
      expect(const AstryxMenuTheme().merge(a), a);
    });

    test('copyWith replaces only what it is given', () {
      final copy = a.copyWith(iconColor: green);
      expect(copy.iconColor, green);
      expect(copy.backgroundColor, red);
      expect(copy.copyWith(), copy);
    });

    test('lerp interpolates and snaps a one-sided field', () {
      expect(AstryxMenuTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxMenuTheme.lerp(a, b, 0.5)!;
      expect(mid.iconSize, 15);
      expect(mid.backgroundColor, Color.lerp(red, blue, 0.5));
      expect(mid.dividerColor, green, reason: 'past halfway, b wins');
      expect(AstryxMenuTheme.lerp(a, b, 0.25)!.dividerColor, isNull);
    });

    test('== and hashCode compare deeply', () {
      const twin = AstryxMenuTheme(
        backgroundColor: red,
        iconSize: 10,
        itemTextStyle: TextStyle(fontSize: 10),
        shadows: <AstryxShadow>[
          AstryxShadow(color: Color(0x33000000), blurRadius: 4),
        ],
      );
      expect(twin, a);
      expect(twin.hashCode, a.hashCode);
      expect(a, isNot(b));
      expect(const AstryxMenuTheme(), const AstryxMenuTheme());
    });
  });

  group('AstryxTooltipTheme', () {
    const a = AstryxTooltipTheme(
      backgroundColor: red,
      maxWidth: 100,
      waitDuration: Duration(milliseconds: 100),
      textStyle: TextStyle(fontSize: 10),
    );
    const b = AstryxTooltipTheme(
      maxWidth: 300,
      waitDuration: Duration(milliseconds: 300),
      textStyle: TextStyle(color: green),
      gap: 8,
    );

    test('merge applies non-null fields and merges text styles', () {
      final merged = a.merge(b);
      expect(merged.backgroundColor, red);
      expect(merged.maxWidth, 300);
      expect(merged.gap, 8);
      expect(merged.waitDuration, const Duration(milliseconds: 300));
      expect(merged.textStyle?.fontSize, 10);
      expect(merged.textStyle?.color, green);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only what it is given', () {
      final copy = a.copyWith(showDuration: const Duration(seconds: 3));
      expect(copy.showDuration, const Duration(seconds: 3));
      expect(copy.maxWidth, 100);
    });

    test('lerp interpolates widths and durations', () {
      expect(AstryxTooltipTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxTooltipTheme.lerp(a, b, 0.5)!;
      expect(mid.maxWidth, 200);
      expect(mid.waitDuration, const Duration(milliseconds: 200));
      expect(mid.backgroundColor, isNull, reason: 'past halfway, b wins');
    });

    test('== and hashCode', () {
      expect(a, a.copyWith());
      expect(a.hashCode, a.copyWith().hashCode);
      expect(a, isNot(b));
    });
  });

  group('AstryxToastTheme', () {
    const a = AstryxToastTheme(
      backgroundColor: red,
      maxWidth: 300,
      duration: Duration(seconds: 2),
      shadows: shadow,
    );
    const b = AstryxToastTheme(
      errorBackgroundColor: blue,
      maxWidth: 500,
      duration: Duration(seconds: 4),
      spacing: 6,
    );

    test('merge applies non-null fields', () {
      final merged = a.merge(b);
      expect(merged.backgroundColor, red);
      expect(merged.errorBackgroundColor, blue);
      expect(merged.maxWidth, 500);
      expect(merged.spacing, 6);
      expect(merged.duration, const Duration(seconds: 4));
      expect(merged.shadows, shadow);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only what it is given', () {
      final copy = a.copyWith(margin: EdgeInsets.zero);
      expect(copy.margin, EdgeInsets.zero);
      expect(copy.backgroundColor, red);
    });

    test('lerp interpolates', () {
      expect(AstryxToastTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxToastTheme.lerp(a, b, 0.5)!;
      expect(mid.maxWidth, 400);
      expect(mid.duration, const Duration(seconds: 3));
    });

    test('== and hashCode compare deeply', () {
      final twin = a.copyWith(
        shadows: <AstryxShadow>[
          const AstryxShadow(color: Color(0x33000000), blurRadius: 4),
        ],
      );
      expect(twin, a);
      expect(twin.hashCode, a.hashCode);
      expect(a, isNot(b));
    });
  });

  group('menus', () {
    Widget dropdown({AstryxMenuTheme? theme}) => Center(
      child: AstryxDropdownMenu(
        theme: theme,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Edit', onSelected: () {}),
          const AstryxMenuDivider(),
          AstryxMenuItem(label: 'Delete', destructive: true, onSelected: () {}),
        ],
        triggerBuilder: (context, controller) =>
            AstryxButton(label: 'Actions', onPressed: controller.toggle),
      ),
    );

    Future<void> open(WidgetTester tester) async {
      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);
    }

    testWidgets('an empty theme keeps the token defaults', (tester) async {
      await pumpApp(tester, dropdown());
      await open(tester);

      final theme = themeOf(tester, find.text('Edit'));
      final surface = decoratedWith(
        theme.color(AstryxColorToken.backgroundPopover),
      );
      expect(surface, findsOneWidget);
      final decoration = decorationOf(tester, surface);
      expect(
        decoration.borderRadius,
        theme.borderRadius(AstryxRadiusToken.container),
      );
      expect(decoration.boxShadow, theme.boxShadows(AstryxShadowToken.low));
      expect(
        decoration.border,
        Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      );
    });

    testWidgets('the app-wide slot reaches the surface and rows', (
      tester,
    ) async {
      await pumpApp(
        tester,
        dropdown(),
        componentThemes: const AstryxComponentThemes(
          menu: AstryxMenuTheme(
            backgroundColor: red,
            borderRadius: BorderRadius.zero,
            border: BorderSide.none,
            shadows: shadow,
            itemHighlightColor: green,
            itemPadding: EdgeInsets.all(13),
            dividerColor: blue,
          ),
        ),
      );
      await open(tester);

      final surface = decoratedWith(red);
      expect(surface, findsOneWidget);
      final decoration = decorationOf(tester, surface);
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, <BoxShadow>[shadow.single.toBoxShadow()]);

      expect(
        find.byWidgetPredicate(
          (w) => w is Container && w.padding == const EdgeInsets.all(13),
        ),
        findsNWidgets(2),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is AstryxDivider && w.theme?.color == blue,
        ),
        findsOneWidget,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(decoratedWith(green), findsOneWidget, reason: 'the highlight');
    });

    testWidgets('the widget theme wins over the app-wide slot', (
      tester,
    ) async {
      await pumpApp(
        tester,
        dropdown(theme: const AstryxMenuTheme(backgroundColor: blue)),
        componentThemes: const AstryxComponentThemes(
          menu: AstryxMenuTheme(
            backgroundColor: red,
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
      await open(tester);

      expect(decoratedWith(red), findsNothing);
      final surface = decoratedWith(blue);
      expect(surface, findsOneWidget);
      expect(
        decorationOf(tester, surface).borderRadius,
        BorderRadius.zero,
        reason: 'fields the widget leaves unset still come from the app',
      );
    });

    testWidgets('a themed label colour spares destructive rows', (
      tester,
    ) async {
      await pumpApp(
        tester,
        dropdown(
          theme: const AstryxMenuTheme(itemTextStyle: TextStyle(color: green)),
        ),
      );
      await open(tester);

      AstryxText label(String text) => tester.widget<AstryxText>(
        find.ancestor(of: find.text(text), matching: find.byType(AstryxText)),
      );
      expect(label('Edit').style?.color, green);
      expect(
        label('Delete').style?.color,
        themeOf(tester, find.text('Delete')).color(AstryxColorToken.error),
      );
    });

    testWidgets('AstryxContextMenu takes the slot and its own theme', (
      tester,
    ) async {
      Widget build({AstryxMenuTheme? theme}) => Center(
        child: AstryxContextMenu(
          theme: theme,
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(label: 'Rename', onSelected: () {}),
          ],
          child: const SizedBox(width: 200, height: 100),
        ),
      );

      await pumpApp(
        tester,
        build(),
        componentThemes: const AstryxComponentThemes(
          menu: AstryxMenuTheme(backgroundColor: red),
        ),
      );
      await tester.tapAt(
        tester.getCenter(find.byType(SizedBox).last),
        buttons: kSecondaryMouseButton,
      );
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget);
      expect(decoratedWith(red), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      await pumpApp(
        tester,
        build(theme: const AstryxMenuTheme(backgroundColor: blue)),
        componentThemes: const AstryxComponentThemes(
          menu: AstryxMenuTheme(backgroundColor: red),
        ),
      );
      await tester.tapAt(
        tester.getCenter(find.byType(SizedBox).last),
        buttons: kSecondaryMouseButton,
      );
      await tester.pumpAndSettle();
      expect(decoratedWith(blue), findsOneWidget);
      expect(decoratedWith(red), findsNothing);
    });
  });

  group('tooltips', () {
    Widget build({AstryxTooltipTheme? theme, double? maxWidth}) => Center(
      child: AstryxTooltip(
        message: 'Archive this conversation',
        theme: theme,
        maxWidth: maxWidth,
        child: AstryxButton(label: 'Archive', onPressed: () {}),
      ),
    );

    Future<void> reveal(WidgetTester tester) async {
      await tester.longPress(find.text('Archive'));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsOneWidget);
    }

    double bubbleMaxWidth(WidgetTester tester) => tester
        .widgetList<ConstrainedBox>(
          find.ancestor(
            of: find.text('Archive this conversation'),
            matching: find.byType(ConstrainedBox),
          ),
        )
        .map((box) => box.constraints.maxWidth)
        .where((w) => w.isFinite)
        .first;

    testWidgets('an empty theme keeps the token defaults', (tester) async {
      await pumpApp(tester, build());
      await reveal(tester);

      final theme = themeOf(tester, find.text('Archive'));
      final bubble = decoratedWith(theme.color(AstryxColorToken.textPrimary));
      expect(bubble, findsOneWidget);
      expect(
        decorationOf(tester, bubble).borderRadius,
        theme.borderRadius(AstryxRadiusToken.container),
      );
      expect(
        tester.widget<Text>(find.text('Archive this conversation')).style,
        theme
            .textStyle(AstryxTypeRole.body)
            .copyWith(color: theme.color(AstryxColorToken.backgroundSurface)),
      );
      expect(bubbleMaxWidth(tester), 300);
    });

    testWidgets('the app-wide slot reaches the bubble', (tester) async {
      await pumpApp(
        tester,
        build(),
        componentThemes: const AstryxComponentThemes(
          tooltip: AstryxTooltipTheme(
            backgroundColor: red,
            borderRadius: BorderRadius.zero,
            textStyle: TextStyle(color: green, fontSize: 20),
            maxWidth: 120,
            padding: EdgeInsets.all(11),
          ),
        ),
      );
      await reveal(tester);

      final bubble = decoratedWith(red);
      expect(bubble, findsOneWidget);
      expect(decorationOf(tester, bubble).borderRadius, BorderRadius.zero);
      final style = tester
          .widget<Text>(find.text('Archive this conversation'))
          .style!;
      expect(style.color, green);
      expect(style.fontSize, 20);
      expect(bubbleMaxWidth(tester), 120);
      expect(
        find.ancestor(
          of: find.text('Archive this conversation'),
          matching: find.byWidgetPredicate(
            (w) => w is Padding && w.padding == const EdgeInsets.all(11),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the widget theme, then explicit arguments, win', (
      tester,
    ) async {
      await pumpApp(
        tester,
        build(
          theme: const AstryxTooltipTheme(backgroundColor: blue, maxWidth: 150),
          maxWidth: 180,
        ),
        componentThemes: const AstryxComponentThemes(
          tooltip: AstryxTooltipTheme(backgroundColor: red, maxWidth: 120),
        ),
      );
      await reveal(tester);

      expect(decoratedWith(red), findsNothing);
      expect(decoratedWith(blue), findsOneWidget);
      expect(bubbleMaxWidth(tester), 180);
    });

    testWidgets('the theme sets the hover delay', (tester) async {
      await pumpApp(
        tester,
        build(),
        componentThemes: const AstryxComponentThemes(
          tooltip: AstryxTooltipTheme(waitDuration: Duration(seconds: 1)),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('Archive')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(
        find.text('Archive this conversation'),
        findsNothing,
        reason: 'the default 200ms has passed; the theme says a second',
      );

      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsOneWidget);
    });
  });

  group('toasts', () {
    late BuildContext inner;
    final home = Builder(
      builder: (context) {
        inner = context;
        return const SizedBox.expand();
      },
    );

    Future<void> show(WidgetTester tester, AstryxToast toast) async {
      AstryxToastScope.of(inner).show(toast);
      await tester.pumpAndSettle();
      expect(find.text(toast.message), findsOneWidget);
    }

    testWidgets('an empty theme keeps the token defaults', (tester) async {
      await pumpApp(tester, home);
      await show(
        tester,
        const AstryxToast(message: 'Saved', duration: Duration.zero),
      );

      final theme = AstryxTheme.of(inner);
      final card = decoratedWith(
        theme.color(AstryxColorToken.backgroundInverted),
      );
      expect(card, findsOneWidget);
      final decoration = decorationOf(tester, card);
      expect(
        decoration.borderRadius,
        theme.borderRadius(AstryxRadiusToken.container),
      );
      expect(decoration.boxShadow, theme.boxShadows(AstryxShadowToken.med));
    });

    testWidgets('the app-wide slot reaches the card, per type', (
      tester,
    ) async {
      await pumpApp(
        tester,
        home,
        componentThemes: const AstryxComponentThemes(
          toast: AstryxToastTheme(
            backgroundColor: red,
            errorBackgroundColor: blue,
            borderRadius: BorderRadius.zero,
            shadows: shadow,
            maxWidth: 250,
            textStyle: TextStyle(fontSize: 21),
          ),
        ),
      );
      await show(
        tester,
        const AstryxToast(message: 'Saved', duration: Duration.zero),
      );
      await show(
        tester,
        const AstryxToast(
          message: 'Failed',
          type: AstryxToastType.error,
          duration: Duration.zero,
        ),
      );

      final neutral = decorationOf(tester, decoratedWith(red));
      expect(neutral.borderRadius, BorderRadius.zero);
      expect(neutral.boxShadow, <BoxShadow>[shadow.single.toBoxShadow()]);
      expect(decoratedWith(blue), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is Container && w.constraints?.maxWidth == 250,
        ),
        findsNWidgets(2),
      );
      expect(
        tester
            .widget<AstryxText>(
              find.ancestor(
                of: find.text('Saved'),
                matching: find.byType(AstryxText),
              ),
            )
            .style
            ?.fontSize,
        21,
      );
    });

    testWidgets("a toast's own theme wins", (tester) async {
      await pumpApp(
        tester,
        home,
        componentThemes: const AstryxComponentThemes(
          toast: AstryxToastTheme(backgroundColor: red),
        ),
      );
      await show(
        tester,
        const AstryxToast(
          message: 'Saved',
          duration: Duration.zero,
          theme: AstryxToastTheme(backgroundColor: green),
        ),
      );

      expect(decoratedWith(red), findsNothing);
      expect(decoratedWith(green), findsOneWidget);
    });

    testWidgets('the theme sets the default timeout', (tester) async {
      await pumpApp(
        tester,
        home,
        componentThemes: const AstryxComponentThemes(
          toast: AstryxToastTheme(duration: Duration(milliseconds: 500)),
        ),
      );
      await show(tester, const AstryxToast(message: 'Saved'));

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsNothing);

      // An explicit duration still wins over the theme.
      await show(
        tester,
        const AstryxToast(message: 'Pinned', duration: Duration.zero),
      );
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expect(find.text('Pinned'), findsOneWidget);
    });
  });
}
