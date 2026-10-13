import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `AstryxTabsTheme` and `AstryxTableTheme`.
///
/// The Material equivalents are `TabBarTheme` and `DataTableThemeData`. What is
/// pinned here is the theme classes' algebra, and that both the app-wide and
/// the widget-level theme reach the pixels — with an empty theme painting
/// exactly what the tokens did before.
class _Row {
  const _Row(this.id, this.name);

  final String id;
  final String name;
}

const _rows = <_Row>[_Row('a', 'Alpha'), _Row('b', 'Bravo'), _Row('c', 'Cy')];

const _red = Color(0xFFFF0000);
const _green = Color(0xFF00FF00);
const _blue = Color(0xFF0000FF);
const _amber = Color(0xFFFFBF00);

void main() {
  /// Every [BoxDecoration] painted below [of].
  List<BoxDecoration> decorations(WidgetTester tester, Finder of) => tester
      .widgetList<DecoratedBox>(
        find.descendant(of: of, matching: find.byType(DecoratedBox)),
      )
      .map((box) => box.decoration)
      .whereType<BoxDecoration>()
      .toList();

  Iterable<Color?> colors(WidgetTester tester, Finder of) =>
      decorations(tester, of).map((d) => d.color);

  /// The colours of every bottom border painted below [of].
  Iterable<Color> bottomBorderColors(WidgetTester tester, Finder of) =>
      decorations(
        tester,
        of,
      ).map((d) => d.border).whereType<Border>().map((b) => b.bottom.color);

  AstryxThemeData themeOf(WidgetTester tester, Finder finder) =>
      AstryxTheme.of(tester.element(finder));

  group('AstryxTabsTheme', () {
    const a = AstryxTabsTheme(
      labelColor: _red,
      indicatorThickness: 2,
      labelStyle: TextStyle(fontSize: 12),
    );
    const b = AstryxTabsTheme(
      labelColor: _blue,
      gap: 8,
      labelStyle: TextStyle(letterSpacing: 1),
    );

    test('merge applies non-null fields and merges text styles', () {
      final merged = a.merge(b);
      expect(merged.labelColor, _blue);
      expect(merged.indicatorThickness, 2);
      expect(merged.gap, 8);
      expect(merged.labelStyle!.fontSize, 12);
      expect(merged.labelStyle!.letterSpacing, 1);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only the given fields', () {
      final next = a.copyWith(indicatorColor: _green);
      expect(next.indicatorColor, _green);
      expect(next.labelColor, _red);
      expect(next.indicatorThickness, 2);
      expect(a.copyWith(), a);
    });

    test('lerp blends present values and snaps absent ones', () {
      expect(AstryxTabsTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxTabsTheme.lerp(
        const AstryxTabsTheme(indicatorThickness: 2, labelColor: _red),
        const AstryxTabsTheme(indicatorThickness: 4, gap: 8),
        0.5,
      )!;
      expect(mid.indicatorThickness, 3);
      expect(mid.gap, 8);
      expect(mid.labelColor, isNull);
    });

    test('== and hashCode compare by value', () {
      const same1 = AstryxTabsTheme(labelColor: _red, gap: 4);
      const same2 = AstryxTabsTheme(labelColor: _red, gap: 4);
      expect(same1, same2);
      expect(same1.hashCode, same2.hashCode);
      expect(same1, isNot(const AstryxTabsTheme(labelColor: _red)));
    });
  });

  group('AstryxTableTheme', () {
    const a = AstryxTableTheme(
      stripeColor: _red,
      rowMinHeight: 40,
      headerTextStyle: TextStyle(fontSize: 12),
    );
    const b = AstryxTableTheme(
      stripeColor: _blue,
      cellPadding: EdgeInsets.all(4),
      headerTextStyle: TextStyle(letterSpacing: 1),
    );

    test('merge applies non-null fields and merges text styles', () {
      final merged = a.merge(b);
      expect(merged.stripeColor, _blue);
      expect(merged.rowMinHeight, 40);
      expect(merged.cellPadding, const EdgeInsets.all(4));
      expect(merged.headerTextStyle!.fontSize, 12);
      expect(merged.headerTextStyle!.letterSpacing, 1);
      expect(a.merge(null), same(a));
    });

    test('copyWith replaces only the given fields', () {
      final next = a.copyWith(selectedRowColor: _green);
      expect(next.selectedRowColor, _green);
      expect(next.stripeColor, _red);
      expect(next.rowMinHeight, 40);
      expect(a.copyWith(), a);
    });

    test('lerp blends present values and snaps absent ones', () {
      expect(AstryxTableTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxTableTheme.lerp(
        const AstryxTableTheme(
          rowMinHeight: 40,
          cellPadding: EdgeInsets.all(4),
        ),
        const AstryxTableTheme(
          rowMinHeight: 60,
          cellPadding: EdgeInsets.all(8),
          borderWidth: 2,
        ),
        0.5,
      )!;
      expect(mid.rowMinHeight, 50);
      expect(mid.cellPadding, const EdgeInsets.all(6));
      expect(mid.borderWidth, 2);
    });

    test('== and hashCode compare by value', () {
      const same1 = AstryxTableTheme(stripeColor: _red, rowMinHeight: 4);
      const same2 = AstryxTableTheme(stripeColor: _red, rowMinHeight: 4);
      expect(same1, same2);
      expect(same1.hashCode, same2.hashCode);
      expect(same1, isNot(const AstryxTableTheme(stripeColor: _red)));
    });
  });

  group('AstryxTabList consumes AstryxTabsTheme', () {
    final strip = find.byType(AstryxTabList<String>);

    Widget tabList({AstryxTabsTheme? theme}) => AstryxTabList<String>(
      value: 'one',
      onChanged: (_) {},
      theme: theme,
      tabs: const <AstryxTab<String>>[
        AstryxTab(value: 'one', label: 'One'),
        AstryxTab(value: 'two', label: 'Two'),
      ],
    );

    Color? labelColor(WidgetTester tester, String label) =>
        tester.widget<Text>(find.text(label)).style!.color;

    testWidgets('an empty theme paints the token defaults', (tester) async {
      await tester.pumpWidget(AstryxApp(home: Center(child: tabList())));
      final theme = themeOf(tester, strip);

      expect(
        colors(tester, strip),
        contains(theme.color(AstryxColorToken.accent)),
      );
      expect(
        bottomBorderColors(tester, strip),
        contains(theme.color(AstryxColorToken.border)),
      );
      expect(
        labelColor(tester, 'One'),
        theme.color(AstryxColorToken.textPrimary),
      );
      expect(
        labelColor(tester, 'Two'),
        theme.color(AstryxColorToken.textSecondary),
      );
      expect(
        tester.getSize(strip).height,
        theme.size(AstryxSizeToken.elementMd),
      );
    });

    testWidgets('AstryxApp(componentThemes:) reaches the painted strip', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: const AstryxComponentThemes(
            tabs: AstryxTabsTheme(
              indicatorColor: _red,
              dividerColor: _green,
              selectedLabelColor: _blue,
              labelColor: _amber,
              height: 48,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          home: Center(child: tabList()),
        ),
      );

      expect(colors(tester, strip), contains(_red));
      expect(bottomBorderColors(tester, strip), contains(_green));
      expect(labelColor(tester, 'One'), _blue);
      expect(labelColor(tester, 'Two'), _amber);
      expect(
        tester.widget<Text>(find.text('One')).style!.fontWeight,
        FontWeight.w900,
      );
      expect(tester.getSize(strip).height, 48);
    });

    testWidgets('the indicator takes the themed thickness', (tester) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: const AstryxComponentThemes(
            tabs: AstryxTabsTheme(indicatorColor: _red, indicatorThickness: 5),
          ),
          home: Center(child: tabList()),
        ),
      );
      final indicator = find.descendant(
        of: strip,
        matching: find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).color == _red,
        ),
      );
      expect(tester.getSize(indicator.first).height, 5);
    });

    testWidgets('the widget theme wins over the app-wide one', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: const AstryxComponentThemes(
            tabs: AstryxTabsTheme(indicatorColor: _red, labelColor: _amber),
          ),
          home: Center(
            child: tabList(
              theme: const AstryxTabsTheme(indicatorColor: _green),
            ),
          ),
        ),
      );

      expect(colors(tester, strip), contains(_green));
      expect(colors(tester, strip), isNot(contains(_red)));
      // Fields the widget theme leaves null still come from the app.
      expect(labelColor(tester, 'Two'), _amber);
    });

    testWidgets('AstryxComponentTheme themes one subtree', (tester) async {
      await tester.pumpWidget(
        AstryxApp(
          home: AstryxComponentTheme(
            data: const AstryxComponentThemes(
              tabs: AstryxTabsTheme(indicatorColor: _blue),
            ),
            child: Center(child: tabList()),
          ),
        ),
      );
      expect(colors(tester, strip), contains(_blue));
    });
  });

  group('AstryxTable consumes AstryxTableTheme', () {
    final table = find.byType(AstryxTable<_Row>);

    Widget buildTable({
      AstryxTableTheme? theme,
      Set<Object> selected = const <Object>{},
    }) => AstryxTable<_Row>(
      rows: _rows,
      keyOf: (row) => row.id,
      striped: true,
      selectionMode: AstryxTableSelectionMode.multiple,
      selected: selected,
      onSelectionChanged: (_) {},
      theme: theme,
      columns: <AstryxTableColumn<_Row>>[
        AstryxTableColumn<_Row>(
          id: 'name',
          header: 'Name',
          cellBuilder: (context, row) => Text(row.name),
        ),
      ],
    );

    /// The style the body text under [label] inherits.
    TextStyle cellStyle(WidgetTester tester, String label) =>
        DefaultTextStyle.of(tester.element(find.text(label))).style;

    testWidgets('an empty theme paints the token defaults', (tester) async {
      await tester.pumpWidget(
        AstryxApp(home: buildTable(selected: const <Object>{'a'})),
      );
      final theme = themeOf(tester, table);

      final painted = colors(tester, table);
      expect(painted, contains(theme.color(AstryxColorToken.accentMuted)));
      expect(painted, contains(theme.color(AstryxColorToken.backgroundMuted)));
      expect(painted, contains(theme.color(AstryxColorToken.backgroundCard)));

      final outline = decorations(tester, table).first;
      expect(
        outline.borderRadius,
        theme.borderRadius(AstryxRadiusToken.container),
      );
      expect(
        tester.widget<Text>(find.text('Name')).style!.color,
        theme.color(AstryxColorToken.textSecondary),
      );
      expect(
        cellStyle(tester, 'Alpha').fontSize,
        theme.textStyle(AstryxTypeRole.body).fontSize,
      );
    });

    testWidgets('AstryxApp(componentThemes:) reaches the painted table', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: const AstryxComponentThemes(
            table: AstryxTableTheme(
              headerBackgroundColor: _red,
              selectedRowColor: _green,
              stripeColor: _blue,
              dividerColor: _amber,
              borderRadius: BorderRadius.zero,
              headerTextStyle: TextStyle(color: _red),
              cellTextStyle: TextStyle(fontSize: 21),
              rowMinHeight: 64,
            ),
          ),
          home: buildTable(selected: const <Object>{'a'}),
        ),
      );

      final painted = colors(tester, table);
      expect(painted, contains(_red));
      expect(painted, contains(_green));
      expect(painted, contains(_blue));
      expect(bottomBorderColors(tester, table), contains(_amber));
      expect(decorations(tester, table).first.borderRadius, BorderRadius.zero);
      expect(tester.widget<Text>(find.text('Name')).style!.color, _red);
      expect(cellStyle(tester, 'Alpha').fontSize, 21);

      final row = find
          .ancestor(of: find.text('Bravo'), matching: find.byType(Row))
          .last;
      expect(tester.getSize(row).height, greaterThanOrEqualTo(64));
    });

    testWidgets('cellPadding replaces the density padding', (tester) async {
      await tester.pumpWidget(
        AstryxApp(
          home: buildTable(
            theme: const AstryxTableTheme(cellPadding: EdgeInsets.all(17)),
          ),
        ),
      );
      final padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Alpha'), matching: find.byType(Padding))
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(17));
    });

    testWidgets('the widget theme wins over the app-wide one', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxApp(
          componentThemes: const AstryxComponentThemes(
            table: AstryxTableTheme(
              stripeColor: _red,
              selectedRowColor: _amber,
            ),
          ),
          home: buildTable(
            selected: const <Object>{'a'},
            theme: const AstryxTableTheme(stripeColor: _green),
          ),
        ),
      );

      final painted = colors(tester, table);
      expect(painted, contains(_green));
      expect(painted, isNot(contains(_red)));
      // Fields the widget theme leaves null still come from the app.
      expect(painted, contains(_amber));
    });
  });
}
