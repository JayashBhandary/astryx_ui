---
title: Portfolio dashboard
description: A dashboard built around a chart and a holdings table.
component: true
group: Templates
source: example/lib/examples/template_chart_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One holding in the portfolio.
typedef Holding = ({
  String ticker,
  String name,
  String sector,
  int price,
  int value,
  double change,
});

class PortfolioDashboardTemplate extends StatefulWidget {
  const PortfolioDashboardTemplate({super.key});

  @override
  State<PortfolioDashboardTemplate> createState() =>
      _PortfolioDashboardTemplateState();
}

class _PortfolioDashboardTemplateState
    extends State<PortfolioDashboardTemplate> {
  static const List<Holding> _holdings = <Holding>[
    (
      ticker: 'ACME',
      name: 'Acme Corporation',
      sector: 'Industrials',
      price: 42150,
      value: 1264500,
      change: 2.41,
    ),
    (
      ticker: 'GLBX',
      name: 'Globex',
      sector: 'Technology',
      price: 18820,
      value: 941000,
      change: -1.08,
    ),
    (
      ticker: 'INIT',
      name: 'Initech',
      sector: 'Technology',
      price: 9640,
      value: 578400,
      change: 5.62,
    ),
    (
      ticker: 'UMBR',
      name: 'Umbrella Health',
      sector: 'Healthcare',
      price: 27310,
      value: 546200,
      change: 0.34,
    ),
    (
      ticker: 'NRTH',
      name: 'Northwind Energy',
      sector: 'Energy',
      price: 6125,
      value: 306250,
      change: -3.87,
    ),
    (
      ticker: 'CONT',
      name: 'Contoso Retail',
      sector: 'Consumer',
      price: 3480,
      value: 174000,
      change: 1.19,
    ),
  ];

  /// The series behind each range. Real data arrives from somewhere; the
  /// screen's job is the same either way.
  static const Map<String, List<double>> _series = <String, List<double>>{
    '1m': <double>[
      37.4, 37.9, 37.1, 38.2, 38.05, 38.6, 39.1, 38.8, 39.4, 39.2, 39.9, 40.1,
    ],
    '6m': <double>[
      31.2, 32.8, 32.1, 34.6, 33.9, 35.8, 36.4, 35.1, 37.2, 38.4, 39.05, 40.1,
    ],
    '1y': <double>[
      28.4, 27.1, 29.6, 31.2, 30.4, 33.1, 32.2, 34.9, 36.1, 35.4, 38.2, 40.1,
    ],
  };

  static const Map<String, String> _rangeLabels = <String, String>{
    '1m': 'the last month',
    '6m': 'the last six months',
    '1y': 'the last year',
  };

  String _range = '6m';
  AstryxTableSort? _sort = const AstryxTableSort(
    'value',
    AstryxSortDirection.descending,
  );

  int get _total =>
      _holdings.fold<int>(0, (sum, holding) => sum + holding.value);

  List<double> get _values => _series[_range]!;

  double get _rangeChange {
    final series = _values;
    return (series.last - series.first) / series.first * 100;
  }

  /// Sorted in the caller. `AstryxTable.rows` is documented as already sorted
  /// and already paginated, and a table that sorted itself could not be handed
  /// a page.
  List<Holding> get _rows {
    final rows = List<Holding>.of(_holdings);
    final sort = _sort;
    if (sort == null) return rows;

    int by(Holding a, Holding b) => switch (sort.columnId) {
      'name' => a.name.compareTo(b.name),
      'price' => a.price.compareTo(b.price),
      'change' => a.change.compareTo(b.change),
      _ => a.value.compareTo(b.value),
    };
    rows.sort(
      (a, b) =>
          sort.direction == AstryxSortDirection.ascending ? by(a, b) : by(b, a),
    );
    return rows;
  }

  /// What each sector is worth, largest first.
  List<({String sector, int value})> get _allocation {
    final totals = <String, int>{};
    for (final holding in _holdings) {
      totals[holding.sector] = (totals[holding.sector] ?? 0) + holding.value;
    }
    final rows = <({String sector, int value})>[
      for (final entry in totals.entries)
        (sector: entry.key, value: entry.value),
    ];
    return rows..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    final change = _rangeChange;
    final up = change >= 0;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Portfolio', level: 1),
                // The figure is text, at display size, and the chart is
                // underneath it. A dashboard whose headline number can only be
                // read off a curve is a dashboard nobody can quote.
                AstryxText(
                  pence(_total),
                  type: AstryxTextType.display3,
                  tabularNumbers: true,
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxBadge(
                      signed(change),
                      variant: up
                          ? AstryxBadgeVariant.success
                          : AstryxBadgeVariant.error,
                      icon: AstryxIcon(
                        up ? AstryxIconName.arrowUp : AstryxIconName.arrowDown,
                      ),
                    ),
                    AstryxText(
                      'over ${_rangeLabels[_range]}',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Range',
              value: _range,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() => _range = value),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: '1m', label: '1M'),
                AstryxSegment(value: '6m', label: '6M'),
                AstryxSegment(value: '1y', label: '1Y'),
              ],
            ),
          ],
        ),
        AstryxCard(
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxText(
                '£${_values.first.toStringAsFixed(1)}k',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                tabularNumbers: true,
              ),
              AstryxText(
                '£${_values.last.toStringAsFixed(1)}k',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                tabularNumbers: true,
              ),
            ],
          ),
          child: TrendChart(
            values: _values,
            height: 180,
            color: up ? AstryxColorToken.success : AstryxColorToken.error,
            label: 'Portfolio value over ${_rangeLabels[_range]}',
            // The chart's whole content, in a sentence. Everything a sighted
            // reader takes from the shape is stated here instead.
            semanticsValue:
                'From £${_values.first.toStringAsFixed(1)}k to '
                '£${_values.last.toStringAsFixed(1)}k, '
                '${signed(change)}',
          ),
        ),
        AstryxSection(
          title: 'Allocation',
          description: 'What each sector is worth, as a share of the whole.',
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              // Bars, not a pie. A proportion each reader can compare against
              // its neighbour beats a wedge nobody can measure — and
              // `AstryxProgressBar` is already a proportion with an announced
              // label, so there is nothing to draw.
              for (final row in _allocation)
                AstryxProgressBar(
                  label: row.sector,
                  value: row.value / _total,
                  showValueLabel: true,
                  formatValue: (value) =>
                      '${(value * 100).round()}% · ${pence(row.value)}',
                ),
            ],
          ),
        ),
        AstryxSection(
          title: 'Holdings',
          description: 'Six positions. Press a column header to sort.',
          child: AstryxTable<Holding>(
            label: 'Holdings',
            keyOf: (row) => row.ticker,
            rowLabelOf: (row) => row.name,
            sort: _sort,
            onSortChanged: (sort) => setState(() => _sort = sort),
            minWidth: 640,
            columns: <AstryxTableColumn<Holding>>[
              AstryxTableColumn<Holding>(
                id: 'name',
                header: 'Holding',
                compare: (a, b) => a.name.compareTo(b.name),
                cellBuilder: (context, row) => AstryxVStack(
                  gap: AstryxSpacingToken.spacing0_5,
                  children: <Widget>[
                    AstryxText(row.ticker, type: AstryxTextType.code),
                    AstryxText(
                      row.name,
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              AstryxTableColumn<Holding>(
                id: 'sector',
                header: 'Sector',
                width: const AstryxTableColumnWidth.fixed(130),
                cellBuilder: (context, row) => AstryxBadge(row.sector),
              ),
              AstryxTableColumn<Holding>(
                id: 'price',
                header: 'Price',
                width: const AstryxTableColumnWidth.fixed(120),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.price.compareTo(b.price),
                cellBuilder: (context, row) =>
                    AstryxText(pence(row.price), tabularNumbers: true),
              ),
              AstryxTableColumn<Holding>(
                id: 'change',
                header: 'Change',
                width: const AstryxTableColumnWidth.fixed(136),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.change.compareTo(b.change),
                // A sign and a glyph, not only a colour. Red and green are the
                // two hues most readers cannot tell apart, and this is the
                // column where that matters most.
                cellBuilder: (context, row) => AstryxHStack(
                  gap: AstryxSpacingToken.spacing1,
                  justify: AstryxStackJustify.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AstryxIcon(
                      row.change >= 0
                          ? AstryxIconName.arrowUp
                          : AstryxIconName.arrowDown,
                      size: AstryxIconSize.sm,
                      color: row.change >= 0
                          ? AstryxIconColor.success
                          : AstryxIconColor.error,
                    ),
                    AstryxText(signed(row.change), tabularNumbers: true),
                  ],
                ),
              ),
              AstryxTableColumn<Holding>(
                id: 'value',
                header: 'Value',
                width: const AstryxTableColumnWidth.fixed(140),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.value.compareTo(b.value),
                cellBuilder: (context, row) =>
                    AstryxText(pence(row.value), tabularNumbers: true),
              ),
            ],
            rows: _rows,
          ),
        ),
      ],
    );
  }
}
```

Change the range: the chart, the headline change and its colour all move together. Sort the table by pressing a column header.


> **Careful**
>
> **`astryx_ui` ships no charting widget, and does not intend to.** A chart is a domain of its own — scales, axes, ticks, legends, tooltips, and an accessibility story for all of them — and a design system that shipped half of one would be shipping something nobody could finish. So this screen draws its own, in about forty lines of `CustomPainter`, and the point of that painter is not that it is good. It is that the seam is visible: swap it for your charting package and nothing around it changes.

## A painter takes tokens, not colours

This is the whole rule for wiring up a chart library, and it is the one that gets broken first. Resolve the colours in `build`, from the token layer, and hand them to the painter. A painter holding a hex is right in one theme out of eight and one brightness out of two — and nobody notices until somebody switches to dark mode in a meeting.

```dart
CustomPaint(
  painter: _TrendPainter(
    values: values,
    line: theme.color(color),
    fill: theme.color(color).withValues(alpha: 0.14),
    baseline: theme.color(AstryxColorToken.border),
  ),
)
```

## The headline figure is text

The portfolio total is an `AstryxText` at display size, above the chart, and the change beside it is a badge with an arrow. A dashboard whose headline number can only be read off a curve is a dashboard nobody can quote — and the curve is what a reader uses to *check* that number, not to discover it.

```text
AstryxVStack(gap: spacing6)
├── the total, the change badge, the range control
├── AstryxCard → TrendChart, with the first and last value in the footer
├── AstryxSection("Allocation") → one AstryxProgressBar per sector
└── AstryxSection("Holdings")   → AstryxTable, sorted in the caller
```

## Bars, not a pie

The allocation section is a stack of [progress bars](progress_bar.md), one per sector, each with its percentage and its value in the label. A proportion the reader can compare against the one beneath it beats a wedge nobody can measure — and a progress bar is already a proportion with an announced label, so there was nothing to draw.

> **Accessibility**
>
> `TrendChart` takes a required `label` **and** a required `semanticsValue`, and the value is the chart in a sentence: "From £31.2k to £40.1k, +28.53%". Everything a sighted reader takes from the shape is stated there instead. The painter itself sits inside an `ExcludeSemantics`, because a canvas has nothing to announce.

The change column pairs its colour with an arrow and a sign. Red and green are the two hues most colour-blind readers cannot separate, and a gains column is exactly where that matters.

## Related

- [Dashboard](dashboard.md) — the same shape with no chart at all, carried by tiles.
- [Table page with chart](table_page_chart.md) — the same painter over a paginated table.
- [AstryxProgressBar](progress_bar.md) — the proportion, and its label.
- [Design tokens](../guides/tokens.md) — reaching a colour when no widget owns it.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Portfolio dashboard`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Portfolio+dashboard&component=Portfolio+dashboard) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Portfolio+dashboard&area=Portfolio+dashboard) — both templates arrive with the component filled in.
