import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 5 — layout and typography.
///
/// These eight widgets set the conventions the next five phases copy, so the
/// behaviours pinned here are the ones every later widget is expected to share:
/// semantic API over raw values, tokens over numbers, and decorative content
/// kept out of the semantics tree.
void main() {
  /// The resolved style of the single [Text] under [finder].
  TextStyle styleOf(WidgetTester tester, Finder finder) => tester
      .widget<Text>(
        find.descendant(of: finder, matching: find.byType(Text)).first,
      )
      .style!;

  group('P5-1 — AstryxText', () {
    testWidgets('renders its data at the body role by default', (tester) async {
      await pumpAstryxWidget(tester, const AstryxText('Hello'));

      expect(find.text('Hello'), findsOneWidget);
      final style = tester.widget<Text>(find.byType(Text)).style!;
      expect(style.fontSize, 14); // --font-size-base
      expect(style.fontWeight, FontWeight.w400);
      expect(style.height, closeTo(1.4286, 1e-9));
    });

    testWidgets('every type resolves to its own role', (tester) async {
      for (final type in AstryxTextType.values) {
        await pumpAstryxWidget(tester, AstryxText('x', type: type));
        final style = tester.widget<Text>(find.byType(Text)).style!;
        expect(style.fontSize, isNotNull, reason: type.name);
        expect(style.height, isNotNull, reason: type.name);
      }
    });

    testWidgets('colour comes from the semantic token', (tester) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxText('x', color: AstryxTextColor.secondary);
          },
        ),
      );
      expect(
        tester.widget<Text>(find.byType(Text)).style!.color,
        data.color(AstryxColorToken.textSecondary),
      );
    });

    testWidgets('inherit leaves the colour unset, so the parent wins', (
      tester,
    ) async {
      // `copyWith(color: null)` would *not* clear a colour — null means keep —
      // so this pins that `inherit` is the absence of a colour, not a reset.
      await pumpAstryxWidget(
        tester,
        const AstryxText('x', color: AstryxTextColor.inherit),
      );
      expect(tester.widget<Text>(find.byType(Text)).style!.color, isNull);
    });

    testWidgets('weight and size override the role', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxText(
          'x',
          weight: AstryxTextWeight.bold,
          size: AstryxTextSizeToken.twoXl,
        ),
      );
      final style = tester.widget<Text>(find.byType(Text)).style!;
      expect(style.fontWeight, FontWeight.w700);
      expect(style.fontSize, 24);
    });

    testWidgets('maxLines implies ellipsis', (tester) async {
      await pumpAstryxWidget(tester, const AstryxText('x', maxLines: 1));
      expect(
        tester.widget<Text>(find.byType(Text)).overflow,
        TextOverflow.ellipsis,
      );
      await pumpAstryxWidget(tester, const AstryxText('x'));
      expect(
        tester.widget<Text>(find.byType(Text)).overflow,
        TextOverflow.clip,
      );
    });

    testWidgets('strikethrough and tabular numbers apply', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxText('1234', strikethrough: true, tabularNumbers: true),
      );
      final style = tester.widget<Text>(find.byType(Text)).style!;
      expect(style.decoration, TextDecoration.lineThrough);
      expect(
        style.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });

    testWidgets('justify is logical, so it flips under RTL', (tester) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          const AstryxText('x', justify: AstryxTextJustify.start),
          textDirection: direction,
        );
        // `start` stays `start` — Flutter resolves it against the ambient
        // direction at paint time, which is the whole point of not using left.
        expect(
          tester.widget<Text>(find.byType(Text)).textAlign,
          TextAlign.start,
        );
      }
    });

    testWidgets('a per-instance theme merges over the app theme', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxText(
          'x',
          theme: AstryxTextTheme(style: TextStyle(letterSpacing: 2)),
        ),
      );
      final style = tester.widget<Text>(find.byType(Text)).style!;
      expect(style.letterSpacing, 2);
      // …and the role's own values survive the merge.
      expect(style.fontSize, 14);
    });

    testWidgets('style is the last word', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxText('x', style: TextStyle(fontSize: 99)),
      );
      expect(tester.widget<Text>(find.byType(Text)).style!.fontSize, 99);
    });

    testWidgets('semanticsLabel replaces the announced string', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxText(r'$1.2M', semanticsLabel: '1.2 million dollars'),
      );
      expect(
        tester.getSemantics(find.byType(AstryxText)).label,
        '1.2 million dollars',
      );
      handle.dispose();
    });
  });

  group('P5-2 — AstryxHeading', () {
    testWidgets('h4 is the base anchor, at 14px', (tester) async {
      // Astryx is a dense internal-tools system: h1 is three steps above body,
      // not ten. This is the fact that surprises people.
      await pumpAstryxWidget(tester, const AstryxHeading('x', level: 4));
      expect(styleOf(tester, find.byType(AstryxHeading)).fontSize, 14);
    });

    testWidgets('sizes step up and down from the anchor', (tester) async {
      final sizes = <int, double>{};
      for (var level = 1; level <= 6; level++) {
        await pumpAstryxWidget(tester, AstryxHeading('x', level: level));
        sizes[level] = styleOf(tester, find.byType(AstryxHeading)).fontSize!;
      }
      expect(sizes[1], 24);
      expect(sizes[2], 20);
      expect(sizes[3], 17);
      expect(sizes[4], 14);
      expect(sizes[5], 12);
      expect(sizes[6], 10);
    });

    testWidgets('headings are semibold', (tester) async {
      await pumpAstryxWidget(tester, const AstryxHeading('x'));
      expect(
        styleOf(tester, find.byType(AstryxHeading)).fontWeight,
        FontWeight.w600,
      );
    });

    testWidgets('announces a header at its level', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxHeading('Billing', level: 3));

      final node = tester.getSemantics(find.byType(AstryxHeading));
      expect(node.flagsCollection.isHeader, isTrue);
      expect(node.headingLevel, 3);
      handle.dispose();
    });

    testWidgets('accessibilityLevel overrides only the announced level', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxHeading('x', level: 3, accessibilityLevel: 2),
      );
      final node = tester.getSemantics(find.byType(AstryxHeading));
      expect(node.headingLevel, 2);
      // The visual size still follows `level`.
      expect(styleOf(tester, find.byType(AstryxHeading)).fontSize, 17);
      handle.dispose();
    });

    testWidgets('a display type resizes without changing the level', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxHeading(
          'x',
          level: 1,
          type: AstryxHeadingType.display1,
        ),
      );
      expect(styleOf(tester, find.byType(AstryxHeading)).fontSize, 42);
      expect(tester.getSemantics(find.byType(AstryxHeading)).headingLevel, 1);
      handle.dispose();
    });

    test('rejects a level outside 1-6', () {
      for (final level in <int>[0, 7]) {
        expect(() => AstryxHeading('x', level: level), throwsAssertionError);
      }
    });
  });

  group('P5-3 — AstryxHStack / AstryxVStack', () {
    testWidgets('gap resolves through the spacing token', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          children: <Widget>[SizedBox(width: 10), SizedBox(width: 10)],
        ),
      );
      // --spacing-4 is 16px.
      expect(tester.widget<Flex>(find.byType(Flex)).spacing, 16);
    });

    testWidgets('no gap means no spacing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(children: <Widget>[SizedBox(), SizedBox()]),
      );
      expect(tester.widget<Flex>(find.byType(Flex)).spacing, 0);
    });

    testWidgets('the two stacks differ only in axis and cross default', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(children: <Widget>[SizedBox()]),
      );
      var flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);
      // A row centres its children so an icon sits on the text's optical
      // centre; a column aligns to the reading edge.
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);

      await pumpAstryxWidget(
        tester,
        const AstryxVStack(children: <Widget>[SizedBox()]),
      );
      flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('defaults to min main-axis size, unlike Row', (tester) async {
      // Flutter's Row defaults to max, which makes `justify` appear not to
      // work inside a larger layout.
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(children: <Widget>[SizedBox(width: 20)]),
      );
      expect(tester.getSize(find.byType(AstryxHStack)).width, 20);
    });

    testWidgets('wrap: true switches to a Wrap and keeps the gap', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing2,
          runGap: AstryxSpacingToken.spacing4,
          children: <Widget>[SizedBox(width: 10)],
        ),
      );
      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 8);
      expect(wrap.runSpacing, 16);
      expect(find.byType(Flex), findsNothing);
    });

    testWidgets('runGap defaults to gap', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[SizedBox()],
        ),
      );
      expect(tester.widget<Wrap>(find.byType(Wrap)).runSpacing, 8);
    });

    testWidgets('justify and align map onto Flutter alignments', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxHStack(
          justify: AstryxStackJustify.between,
          align: AstryxStackAlign.stretch,
          children: <Widget>[SizedBox()],
        ),
      );
      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.stretch);
    });
  });

  group('P5-4 — AstryxGrid', () {
    testWidgets('lays a fixed column count into rows', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxGrid(
          columns: 2,
          gap: AstryxSpacingToken.spacing2,
          children: List<Widget>.generate(
            5,
            (i) => SizedBox(height: 10, key: ValueKey<int>(i)),
          ),
        ),
        surfaceSize: const Size(400, 400),
      );
      // 5 items in 2 columns = 3 rows.
      expect(find.byType(Row), findsNWidgets(3));
      expect(find.byType(SizedBox), findsAtLeast(5));
    });

    testWidgets('a responsive grid picks the column count from the width', (
      tester,
    ) async {
      Future<int> rowsAt(double width) async {
        await pumpAstryxWidget(
          tester,
          AstryxGrid(
            minWidth: 100,
            children: List<Widget>.generate(
              4,
              (i) => SizedBox(height: 10, key: ValueKey<int>(i)),
            ),
          ),
          surfaceSize: Size(width, 400),
        );
        return tester.widgetList(find.byType(Row)).length;
      }

      // 400px fits 4 columns → 1 row; 200px fits 2 → 2 rows.
      expect(await rowsAt(400), 1);
      expect(await rowsAt(200), 2);
    });

    testWidgets('maxColumns caps the responsive count', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxGrid(
          minWidth: 50,
          maxColumns: 2,
          children: List<Widget>.generate(4, (i) => const SizedBox(height: 10)),
        ),
        surfaceSize: const Size(400, 400),
      );
      expect(find.byType(Row), findsNWidgets(2));
    });

    testWidgets('an empty grid renders nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxGrid(columns: 2, children: <Widget>[]),
      );
      expect(find.byType(Row), findsNothing);
    });

    test('rejects both or neither of columns and minWidth', () {
      const none = <Widget>[];
      expect(
        () => AstryxGrid(columns: 2, minWidth: 100, children: none),
        throwsAssertionError,
      );
      expect(() => AstryxGrid(children: none), throwsAssertionError);
    });
  });

  group('P5-5 — AstryxCenter', () {
    testWidgets('centres its child', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCenter(child: SizedBox(width: 20, height: 20)),
        surfaceSize: const Size(200, 200),
      );
      expect(
        tester.getCenter(find.byType(SizedBox).last),
        tester.getCenter(find.byType(AstryxCenter)),
      );
    });

    testWidgets('padding resolves through the spacing tokens', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCenter(
          paddingInline: AstryxSpacingToken.spacing4,
          paddingBlock: AstryxSpacingToken.spacing2,
          child: SizedBox(width: 20, height: 20),
        ),
      );
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(
        padding.padding,
        const EdgeInsetsDirectional.only(
          start: 16,
          end: 16,
          top: 8,
          bottom: 8,
        ),
      );
    });

    testWidgets('minHeight keeps an empty state from collapsing', (
      tester,
    ) async {
      // Inside a bounded parent an Align fills it, so the floor only shows
      // where the height is the content's own — here, inside a Column.
      await pumpAstryxWidget(
        tester,
        const AstryxVStack(
          children: <Widget>[
            AstryxCenter(minHeight: 120, child: SizedBox.shrink()),
          ],
        ),
      );
      expect(tester.getSize(find.byType(AstryxCenter)).height, 120);
    });
  });

  group('P5-6 — AstryxDivider', () {
    testWidgets('draws a hairline from --color-border', (tester) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxDivider();
          },
        ),
      );
      final box = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(AstryxDivider),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(box.color, data.color(AstryxColorToken.border));
      expect(tester.getSize(find.byType(AstryxDivider)).height, 1);
    });

    testWidgets('the strong variant uses the emphasized token', (tester) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxDivider(variant: AstryxDividerVariant.strong);
          },
        ),
      );
      expect(
        tester
            .widget<ColoredBox>(
              find.descendant(
                of: find.byType(AstryxDivider),
                matching: find.byType(ColoredBox),
              ),
            )
            .color,
        data.color(AstryxColorToken.borderEmphasized),
      );
    });

    testWidgets('a plain divider is decorative and not announced', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxDivider());
      // A reader announcing "separator" between every row is noise.
      expect(
        find.descendant(
          of: find.byType(AstryxDivider),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('a labelled divider announces its label', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxDivider(label: 'Advanced'));

      final node = tester.getSemantics(find.byType(AstryxDivider));
      expect(node.label, 'Advanced');
      expect(node.flagsCollection.isHeader, isTrue);
      handle.dispose();
    });

    testWidgets('vertical runs the other way', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          height: 40,
          child: AstryxDivider(axis: Axis.vertical),
        ),
      );
      expect(tester.getSize(find.byType(AstryxDivider)).width, 1);
    });
  });

  group('P5-7 — AstryxIcon', () {
    testWidgets('resolves the glyph through the registry', (tester) async {
      await pumpAstryxWidget(tester, const AstryxIcon(AstryxIconName.check));
      expect(
        tester.widget<Icon>(find.byType(Icon)).icon,
        AstryxIconRegistry.defaults.icon(AstryxIconName.check),
      );
    });

    testWidgets('inherits its size from the ambient IconTheme', (tester) async {
      await pumpAstryxWidget(
        tester,
        const IconTheme(
          data: IconThemeData(size: 13),
          child: AstryxIcon(AstryxIconName.check),
        ),
      );
      expect(tester.widget<Icon>(find.byType(Icon)).size, 13);
    });

    testWidgets('an explicit size beats the inherited one', (tester) async {
      await pumpAstryxWidget(
        tester,
        const IconTheme(
          data: IconThemeData(size: 13),
          child: AstryxIcon(AstryxIconName.check, size: AstryxIconSize.lg),
        ),
      );
      expect(tester.widget<Icon>(find.byType(Icon)).size, 24);
    });

    testWidgets('sizes come from the rem scale', (tester) async {
      const expected = <AstryxIconSize, double>{
        AstryxIconSize.xsm: 12,
        AstryxIconSize.sm: 16,
        AstryxIconSize.md: 20,
        AstryxIconSize.lg: 24,
      };
      for (final entry in expected.entries) {
        await pumpAstryxWidget(
          tester,
          AstryxIcon(AstryxIconName.check, size: entry.key),
        );
        expect(
          tester.widget<Icon>(find.byType(Icon)).size,
          entry.value,
          reason: entry.key.name,
        );
      }
    });

    testWidgets('colour comes from the icon tokens', (tester) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxIcon(
              AstryxIconName.check,
              color: AstryxIconColor.warning,
            );
          },
        ),
      );
      expect(
        tester.widget<Icon>(find.byType(Icon)).color,
        data.color(AstryxColorToken.warning),
      );
    });

    testWidgets('inherit leaves the colour to the parent', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxIcon(
          AstryxIconName.check,
        ),
      );
      expect(tester.widget<Icon>(find.byType(Icon)).color, isNull);
    });

    testWidgets('a decorative icon is hidden from assistive technology', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxIcon(AstryxIconName.check));
      // Assert the tree, not the widget: `Icon` adds an `ExcludeSemantics` of
      // its own, so counting them would pass whatever this widget did.
      expect(tester.getSemantics(find.byType(AstryxIcon)).label, isEmpty);
      handle.dispose();
    });

    testWidgets('a labelled icon is announced as an image', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxIcon(AstryxIconName.warning, label: 'Warning'),
      );
      final node = tester.getSemantics(find.byType(AstryxIcon));
      expect(node.label, 'Warning');
      expect(node.flagsCollection.isImage, isTrue);
      handle.dispose();
    });

    testWidgets('directional icons mirror under RTL, others do not', (
      tester,
    ) async {
      Future<int> transformsFor(
        AstryxIconName name,
        TextDirection direction,
      ) async {
        await pumpAstryxWidget(
          tester,
          AstryxIcon(name),
          textDirection: direction,
        );
        return tester
            .widgetList(
              find.descendant(
                of: find.byType(AstryxIcon),
                matching: find.byType(Transform),
              ),
            )
            .length;
      }

      expect(
        await transformsFor(AstryxIconName.chevronRight, TextDirection.rtl),
        1,
      );
      expect(
        await transformsFor(AstryxIconName.chevronRight, TextDirection.ltr),
        0,
      );
      // A clock runs clockwise in every locale.
      expect(await transformsFor(AstryxIconName.clock, TextDirection.rtl), 0);
    });

    testWidgets('mirroring can be overridden', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxIcon(AstryxIconName.clock, mirrorForRtl: true),
        textDirection: TextDirection.rtl,
      );
      expect(
        find.descendant(
          of: find.byType(AstryxIcon),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );
    });
  });

  group('component themes', () {
    test('merge keeps the base where the override is silent', () {
      const base = AstryxDividerTheme(thickness: 2, labelGap: 4);
      const over = AstryxDividerTheme(thickness: 8);
      final merged = base.merge(over);
      expect(merged.thickness, 8);
      expect(merged.labelGap, 4);
      expect(base.merge(null), base);
    });

    test('text theme merges styles rather than replacing them', () {
      const base = AstryxTextTheme(style: TextStyle(letterSpacing: 1));
      const over = AstryxTextTheme(style: TextStyle(wordSpacing: 2));
      final merged = base.merge(over);
      expect(merged.style!.letterSpacing, 1);
      expect(merged.style!.wordSpacing, 2);
    });

    test('lerp interpolates and is null-safe', () {
      const a = AstryxDividerTheme(thickness: 0);
      const b = AstryxDividerTheme(thickness: 10);
      expect(AstryxDividerTheme.lerp(a, b, 0.5)!.thickness, 5);
      expect(AstryxDividerTheme.lerp(null, null, 0.5), isNull);
      expect(AstryxIconTheme.lerp(null, null, 0.5), isNull);
      expect(AstryxTextTheme.lerp(null, null, 0.5), isNull);
    });

    test('themes are value types', () {
      expect(
        const AstryxIconTheme(size: 20),
        const AstryxIconTheme(size: 20),
      );
      expect(
        const AstryxIconTheme(size: 20).hashCode,
        const AstryxIconTheme(size: 20).hashCode,
      );
      expect(
        const AstryxIconTheme(size: 20),
        isNot(const AstryxIconTheme(size: 24)),
      );
    });

    testWidgets('an app-level theme reaches every instance', (tester) async {
      await tester.pumpWidget(
        AstryxThemeProvider(
          child: Builder(
            builder: (context) => AstryxTheme(
              data: AstryxTheme.of(context).copyWith(
                icon: const AstryxIconTheme(size: 40),
              ),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: AstryxIcon(AstryxIconName.check),
              ),
            ),
          ),
        ),
      );
      expect(tester.widget<Icon>(find.byType(Icon)).size, 40);
    });
  });
}
