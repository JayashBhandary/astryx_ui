import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Component themes for the surfaces: `AstryxCardTheme`,
/// `AstryxBadgeTheme` and `AstryxBannerTheme`.
///
/// For each, the value-type contract (`merge`, `copyWith`, `lerp`, `==`) and
/// the resolution order — the widget's own `theme:` over the app-wide
/// `AstryxComponentThemes` over the tokens.
void main() {
  const red = Color(0xFFFF0000);
  const blue = Color(0xFF0000FF);
  const square = BorderRadius.zero;
  const round = BorderRadius.all(Radius.circular(20));

  Future<void> pumpApp(
    WidgetTester tester,
    Widget child, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
  }) => tester.pumpWidget(
    AstryxApp(
      componentThemes: componentThemes,
      home: Center(child: SizedBox(width: 360, child: child)),
    ),
  );

  AstryxThemeData themeOf(WidgetTester tester, Finder finder) =>
      AstryxTheme.of(tester.element(finder));

  BoxDecoration cardDecoration(WidgetTester tester, Type type) =>
      tester
              .widget<AnimatedContainer>(
                find
                    .descendant(
                      of: find.byType(type),
                      matching: find.byType(AnimatedContainer),
                    )
                    .first,
              )
              .decoration!
          as BoxDecoration;

  /// The card's own padding: the nearest [Padding] above its body text.
  EdgeInsetsGeometry cardPadding(WidgetTester tester, String text) => tester
      .widget<Padding>(
        find
            .ancestor(of: find.text(text), matching: find.byType(Padding))
            .first,
      )
      .padding;

  Container badgeBox(WidgetTester tester) => tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AstryxBadge),
          matching: find.byType(Container),
        )
        .first,
  );

  Container bannerHeader(WidgetTester tester) => tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AstryxBanner),
          matching: find.byType(Container),
        )
        .first,
  );

  group('AstryxCardTheme', () {
    const full = AstryxCardTheme(
      backgroundColor: red,
      selectedBackgroundColor: red,
      borderColor: red,
      selectedBorderColor: red,
      borderWidth: 2,
      borderRadius: square,
      padding: EdgeInsets.all(4),
      gap: 4,
      shadows: <AstryxShadow>[],
    );

    test('merge applies non-null fields of other', () {
      const base = AstryxCardTheme(borderColor: red, borderWidth: 2);
      final merged = base.merge(
        const AstryxCardTheme(borderColor: blue, gap: 8),
      );
      expect(merged.borderColor, blue);
      expect(merged.borderWidth, 2);
      expect(merged.gap, 8);
      expect(base.merge(null), same(base));
      expect(const AstryxCardTheme().merge(full), full);
    });

    test('copyWith replaces only the given fields', () {
      final next = full.copyWith(borderColor: blue);
      expect(next.borderColor, blue);
      expect(next.copyWith(borderColor: red), full);
      expect(full.copyWith(), full);
    });

    test('lerp interpolates and snaps absent values', () {
      expect(AstryxCardTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxCardTheme.lerp(
        const AstryxCardTheme(borderWidth: 0, borderColor: red),
        const AstryxCardTheme(borderWidth: 2, borderColor: blue, gap: 8),
        0.5,
      )!;
      expect(mid.borderWidth, 1);
      expect(mid.borderColor, Color.lerp(red, blue, 0.5));
      expect(mid.gap, 8);
      expect(AstryxCardTheme.lerp(full, full, 0.3), full);
    });

    test('== and hashCode compare by value, shadows deeply', () {
      const a = AstryxCardTheme(
        shadows: <AstryxShadow>[
          AstryxShadow(color: red, offset: Offset(0, 1), blurRadius: 2),
        ],
      );
      // A distinct, non-const list with the same layers.
      final b = AstryxCardTheme(shadows: List.of(a.shadows!));
      expect(identical(a.shadows, b.shadows), isFalse);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const AstryxCardTheme()));
      expect(const AstryxCardTheme(), const AstryxCardTheme());
    });

    testWidgets('defaults are unchanged', (tester) async {
      await pumpApp(tester, const AstryxCard(child: AstryxText('Body')));
      final data = themeOf(tester, find.byType(AstryxCard));
      final decoration = cardDecoration(tester, AstryxCard);
      final border = decoration.border! as Border;

      expect(
        decoration.borderRadius,
        data.borderRadius(AstryxRadiusToken.container),
      );
      expect(decoration.color, data.color(AstryxColorToken.backgroundCard));
      expect(border.top.color, data.color(AstryxColorToken.border));
      expect(border.top.width, data.borderWidth());
      expect(decoration.boxShadow, isNull);
      expect(
        cardPadding(tester, 'Body'),
        EdgeInsets.all(data.spacing(AstryxSpacingToken.spacing4)),
      );
    });

    testWidgets('app-wide theme changes the painted card', (tester) async {
      await pumpApp(
        tester,
        const AstryxCard(child: AstryxText('Body')),
        componentThemes: const AstryxComponentThemes(
          card: AstryxCardTheme(
            backgroundColor: red,
            borderColor: blue,
            borderWidth: 3,
            borderRadius: square,
            padding: EdgeInsets.all(2),
            shadows: <AstryxShadow>[
              AstryxShadow(color: red, offset: Offset(0, 1), blurRadius: 2),
            ],
          ),
        ),
      );
      final decoration = cardDecoration(tester, AstryxCard);
      final border = decoration.border! as Border;

      expect(decoration.color, red);
      expect(decoration.borderRadius, square);
      expect(border.top.color, blue);
      expect(border.top.width, 3);
      expect(decoration.boxShadow, hasLength(1));
      expect(cardPadding(tester, 'Body'), const EdgeInsets.all(2));
    });

    testWidgets('backgroundColor leaves non-standard variants alone', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AstryxCard(
          variant: AstryxCardVariant.muted,
          child: AstryxText('Body'),
        ),
        componentThemes: const AstryxComponentThemes(
          card: AstryxCardTheme(backgroundColor: red),
        ),
      );
      final data = themeOf(tester, find.byType(AstryxCard));
      expect(
        cardDecoration(tester, AstryxCard).color,
        data.color(AstryxColorToken.backgroundMuted),
      );
    });

    testWidgets("the widget's own theme and params win", (tester) async {
      await pumpApp(
        tester,
        const AstryxCard(
          padding: AstryxSpacingToken.spacing1,
          elevation: AstryxElevation.none,
          theme: AstryxCardTheme(borderRadius: round),
          child: AstryxText('Body'),
        ),
        componentThemes: const AstryxComponentThemes(
          card: AstryxCardTheme(
            borderRadius: square,
            padding: EdgeInsets.all(2),
            shadows: <AstryxShadow>[
              AstryxShadow(color: red, offset: Offset(0, 1), blurRadius: 2),
            ],
          ),
        ),
      );
      final data = themeOf(tester, find.byType(AstryxCard));
      final decoration = cardDecoration(tester, AstryxCard);

      expect(decoration.borderRadius, round);
      expect(decoration.boxShadow, isNull);
      expect(
        cardPadding(tester, 'Body'),
        EdgeInsets.all(data.spacing(AstryxSpacingToken.spacing1)),
      );
    });

    testWidgets('AstryxComponentTheme scopes a subtree', (tester) async {
      await pumpApp(
        tester,
        const AstryxComponentTheme(
          data: AstryxComponentThemes(
            card: AstryxCardTheme(borderRadius: square),
          ),
          child: AstryxCard(child: AstryxText('Body')),
        ),
      );
      expect(cardDecoration(tester, AstryxCard).borderRadius, square);
    });

    group('on AstryxSelectableCard', () {
      Widget selectable({required bool selected, AstryxCardTheme? theme}) =>
          AstryxSelectableCard(
            label: 'Pro',
            selected: selected,
            onSelectedChanged: (_) {},
            theme: theme,
            child: const AstryxText('Pro'),
          );

      testWidgets('defaults are unchanged', (tester) async {
        await pumpApp(tester, selectable(selected: true));
        final data = themeOf(tester, find.byType(AstryxSelectableCard));
        final decoration = cardDecoration(tester, AstryxSelectableCard);
        final border = decoration.border! as Border;

        expect(decoration.color, data.color(AstryxColorToken.accentMuted));
        expect(border.top.color, data.color(AstryxColorToken.accent));
        expect(
          decoration.borderRadius,
          data.borderRadius(AstryxRadiusToken.container),
        );
      });

      testWidgets('app-wide theme styles the selected state', (tester) async {
        await pumpApp(
          tester,
          selectable(selected: true),
          componentThemes: const AstryxComponentThemes(
            card: AstryxCardTheme(
              selectedBackgroundColor: red,
              selectedBorderColor: blue,
              borderRadius: square,
            ),
          ),
        );
        final decoration = cardDecoration(tester, AstryxSelectableCard);
        expect(decoration.color, red);
        expect((decoration.border! as Border).top.color, blue);
        expect(decoration.borderRadius, square);
      });

      testWidgets('app-wide theme styles the unselected state', (
        tester,
      ) async {
        await pumpApp(
          tester,
          selectable(selected: false),
          componentThemes: const AstryxComponentThemes(
            card: AstryxCardTheme(
              backgroundColor: red,
              borderColor: blue,
              padding: EdgeInsets.all(3),
            ),
          ),
        );
        final decoration = cardDecoration(tester, AstryxSelectableCard);
        expect(decoration.color, red);
        expect((decoration.border! as Border).top.color, blue);
        expect(
          cardPadding(tester, 'Pro'),
          const EdgeInsets.all(3),
        );
      });

      testWidgets("the widget's own theme wins", (tester) async {
        await pumpApp(
          tester,
          selectable(
            selected: true,
            theme: const AstryxCardTheme(selectedBorderColor: red),
          ),
          componentThemes: const AstryxComponentThemes(
            card: AstryxCardTheme(selectedBorderColor: blue),
          ),
        );
        final decoration = cardDecoration(tester, AstryxSelectableCard);
        expect((decoration.border! as Border).top.color, red);
      });
    });
  });

  group('AstryxBadgeTheme', () {
    const full = AstryxBadgeTheme(
      borderRadius: square,
      border: BorderSide(color: red),
      padding: EdgeInsets.all(2),
      minHeight: 30,
      gap: 3,
      textStyle: TextStyle(letterSpacing: 1),
      iconSize: 10,
    );

    test('merge applies non-null fields and merges textStyle', () {
      const base = AstryxBadgeTheme(
        minHeight: 30,
        textStyle: TextStyle(letterSpacing: 1),
      );
      final merged = base.merge(
        const AstryxBadgeTheme(gap: 4, textStyle: TextStyle(fontSize: 9)),
      );
      expect(merged.minHeight, 30);
      expect(merged.gap, 4);
      expect(merged.textStyle!.letterSpacing, 1);
      expect(merged.textStyle!.fontSize, 9);
      expect(base.merge(null), same(base));
      expect(const AstryxBadgeTheme().merge(full), full);
    });

    test('copyWith replaces only the given fields', () {
      expect(full.copyWith(), full);
      expect(full.copyWith(gap: 9).gap, 9);
      expect(full.copyWith(gap: 9).minHeight, 30);
    });

    test('lerp interpolates', () {
      expect(AstryxBadgeTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxBadgeTheme.lerp(
        const AstryxBadgeTheme(minHeight: 20, iconSize: 10),
        const AstryxBadgeTheme(minHeight: 30, iconSize: 20),
        0.5,
      )!;
      expect(mid.minHeight, 25);
      expect(mid.iconSize, 15);
      expect(AstryxBadgeTheme.lerp(full, full, 0.7), full);
    });

    test('== and hashCode compare by value', () {
      expect(full, full.copyWith());
      expect(full.hashCode, full.copyWith().hashCode);
      expect(full, isNot(const AstryxBadgeTheme()));
    });

    testWidgets('defaults are unchanged', (tester) async {
      await pumpApp(tester, const AstryxBadge('Active'));
      final data = themeOf(tester, find.byType(AstryxBadge));
      final box = badgeBox(tester);
      final decoration = box.decoration! as BoxDecoration;

      expect(
        decoration.borderRadius,
        data.borderRadius(AstryxRadiusToken.full),
      );
      expect(decoration.border, isNull);
      expect(
        decoration.color,
        data.color(AstryxBadgeVariant.neutral.backgroundToken),
      );
      expect(
        box.padding,
        EdgeInsets.symmetric(
          horizontal: data.spacing(AstryxSpacingToken.spacing2),
        ),
      );
      expect(
        box.constraints!.minHeight,
        data.spacing(AstryxSpacingToken.spacing5),
      );
    });

    testWidgets('app-wide theme changes the painted badge', (tester) async {
      await pumpApp(
        tester,
        const AstryxBadge('Active', variant: AstryxBadgeVariant.success),
        componentThemes: const AstryxComponentThemes(
          badge: AstryxBadgeTheme(
            borderRadius: square,
            border: BorderSide(color: blue),
            padding: EdgeInsets.all(2),
            minHeight: 30,
            textStyle: TextStyle(letterSpacing: 2),
          ),
        ),
      );
      final data = themeOf(tester, find.byType(AstryxBadge));
      final box = badgeBox(tester);
      final decoration = box.decoration! as BoxDecoration;

      expect(decoration.borderRadius, square);
      expect((decoration.border! as Border).top.color, blue);
      expect(box.padding, const EdgeInsets.all(2));
      expect(box.constraints!.minHeight, 30);
      // The variant keeps its colours: the theme has no fill to flatten them.
      expect(
        decoration.color,
        data.color(AstryxBadgeVariant.success.backgroundToken),
      );
      final style = tester.widget<Text>(find.text('Active')).style!;
      expect(style.letterSpacing, 2);
      expect(
        style.color,
        data.color(AstryxBadgeVariant.success.foregroundToken),
      );
    });

    testWidgets("the widget's own theme wins", (tester) async {
      await pumpApp(
        tester,
        const AstryxBadge(
          'Active',
          theme: AstryxBadgeTheme(borderRadius: round),
        ),
        componentThemes: const AstryxComponentThemes(
          badge: AstryxBadgeTheme(borderRadius: square, minHeight: 30),
        ),
      );
      final box = badgeBox(tester);
      expect((box.decoration! as BoxDecoration).borderRadius, round);
      expect(box.constraints!.minHeight, 30);
    });
  });

  group('AstryxBannerTheme', () {
    const full = AstryxBannerTheme(
      borderRadius: square,
      padding: EdgeInsets.all(2),
      contentPadding: EdgeInsets.all(3),
      gap: 4,
      iconSize: 12,
      titleStyle: TextStyle(letterSpacing: 1),
      descriptionStyle: TextStyle(letterSpacing: 2),
      contentBackgroundColor: red,
      contentBorder: BorderSide(color: blue),
    );

    test('merge applies non-null fields and merges text styles', () {
      const base = AstryxBannerTheme(
        gap: 4,
        titleStyle: TextStyle(letterSpacing: 1),
      );
      final merged = base.merge(
        const AstryxBannerTheme(
          iconSize: 12,
          titleStyle: TextStyle(fontSize: 20),
        ),
      );
      expect(merged.gap, 4);
      expect(merged.iconSize, 12);
      expect(merged.titleStyle!.letterSpacing, 1);
      expect(merged.titleStyle!.fontSize, 20);
      expect(base.merge(null), same(base));
      expect(const AstryxBannerTheme().merge(full), full);
    });

    test('copyWith replaces only the given fields', () {
      expect(full.copyWith(), full);
      expect(full.copyWith(gap: 9).gap, 9);
      expect(full.copyWith(gap: 9).iconSize, 12);
    });

    test('lerp interpolates', () {
      expect(AstryxBannerTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxBannerTheme.lerp(
        const AstryxBannerTheme(gap: 0, contentBackgroundColor: red),
        const AstryxBannerTheme(gap: 8, contentBackgroundColor: blue),
        0.25,
      )!;
      expect(mid.gap, 2);
      expect(mid.contentBackgroundColor, Color.lerp(red, blue, 0.25));
      expect(AstryxBannerTheme.lerp(full, full, 0.4), full);
    });

    test('== and hashCode compare by value', () {
      expect(full, full.copyWith());
      expect(full.hashCode, full.copyWith().hashCode);
      expect(full, isNot(const AstryxBannerTheme()));
    });

    testWidgets('defaults are unchanged', (tester) async {
      await pumpApp(
        tester,
        const AstryxBanner(title: 'Heads up', announce: false),
      );
      final data = themeOf(tester, find.byType(AstryxBanner));
      final header = bannerHeader(tester);
      final decoration = header.decoration! as BoxDecoration;

      expect(
        decoration.borderRadius,
        data.borderRadius(AstryxRadiusToken.container),
      );
      expect(
        decoration.color,
        data.color(AstryxBannerStatus.info.background),
      );
      expect(
        header.padding,
        EdgeInsets.symmetric(
          vertical: data.spacing(AstryxSpacingToken.spacing3),
          horizontal: data.spacing(AstryxSpacingToken.spacing4),
        ),
      );
      expect(
        tester.getSize(find.byType(Icon)).width,
        AstryxIconSize.sm.pixels,
      );
    });

    testWidgets('app-wide theme changes the painted banner', (tester) async {
      await pumpApp(
        tester,
        const AstryxBanner(
          title: 'Heads up',
          description: 'Detail',
          announce: false,
          content: AstryxText('More'),
        ),
        componentThemes: const AstryxComponentThemes(
          banner: AstryxBannerTheme(
            borderRadius: round,
            padding: EdgeInsets.all(2),
            iconSize: 30,
            titleStyle: TextStyle(letterSpacing: 3),
            descriptionStyle: TextStyle(letterSpacing: 4),
            contentBackgroundColor: red,
            contentBorder: BorderSide(color: blue, width: 2),
            contentPadding: EdgeInsets.all(5),
          ),
        ),
      );
      final data = themeOf(tester, find.byType(AstryxBanner));
      final header = bannerHeader(tester);
      final decoration = header.decoration! as BoxDecoration;

      expect(header.padding, const EdgeInsets.all(2));
      expect(
        decoration.borderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      );
      // The status fill is not themeable, so it survives.
      expect(
        decoration.color,
        data.color(AstryxBannerStatus.info.background),
      );
      expect(tester.getSize(find.byType(Icon)).width, 30);
      expect(
        tester.widget<Text>(find.text('Heads up')).style!.letterSpacing,
        3,
      );
      expect(
        tester.widget<Text>(find.text('Detail')).style!.letterSpacing,
        4,
      );

      final panel = tester.widget<DecoratedBox>(
        find
            .ancestor(
              of: find.text('More'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final panelDecoration = panel.decoration as BoxDecoration;
      expect(panelDecoration.color, red);
      expect(
        (panelDecoration.border! as Border).bottom,
        const BorderSide(color: blue, width: 2),
      );
      expect(
        tester
            .widget<Padding>(
              find
                  .ancestor(
                    of: find.text('More'),
                    matching: find.byType(Padding),
                  )
                  .first,
            )
            .padding,
        const EdgeInsets.all(5),
      );
    });

    testWidgets("the widget's own theme wins", (tester) async {
      await pumpApp(
        tester,
        const AstryxBanner(
          title: 'Heads up',
          announce: false,
          theme: AstryxBannerTheme(padding: EdgeInsets.all(7)),
        ),
        componentThemes: const AstryxComponentThemes(
          banner: AstryxBannerTheme(
            padding: EdgeInsets.all(2),
            borderRadius: square,
          ),
        ),
      );
      final header = bannerHeader(tester);
      expect(header.padding, const EdgeInsets.all(7));
      expect((header.decoration! as BoxDecoration).borderRadius, square);
    });
  });
}
