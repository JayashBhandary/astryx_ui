/// The two screens that are built around a figure over time.
///
/// **`astryx_ui` ships no charting widget, and does not intend to.** A chart is
/// a domain of its own — scales, axes, ticks, legends, tooltips, accessibility
/// — and a design system that shipped half of one would be shipping something
/// nobody could finish. So these templates draw their own, in about forty lines
/// of `CustomPainter`, and the point of that painter is not that it is good: it
/// is that it takes every colour from the token layer and nothing from a
/// literal. Swap it for your charting package and the screens around it do not
/// change.
///
/// Nothing here is exported. Both templates are compositions worth copying.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A line with the area under it filled — the smallest chart worth drawing.
///
/// Not a component, and deliberately not clever: no axes, no ticks, no
/// tooltips. It exists so the templates around it are real, and so the seam
/// where a charting package goes is visible.
///
/// [label] is required for the same reason it is on every control in the
/// package: a picture of a trend announces nothing, and [semanticsValue] is
/// what a screen reader is actually given instead of the shape.
class TrendChart extends StatelessWidget {
  /// Creates a trend chart.
  const TrendChart({
    required this.values,
    required this.label,
    required this.semanticsValue,
    super.key,
    this.height = 200,
    this.color = AstryxColorToken.accent,
    this.showBaseline = true,
  });

  /// The series, oldest first. At least two points.
  final List<double> values;

  /// What the series is. The chart's accessible name.
  final String label;

  /// The series in words — the shape is not readable to everyone.
  final String semanticsValue;

  /// How tall the plot is.
  final double height;

  /// The token the line and the fill are derived from.
  final AstryxColorToken color;

  /// Whether to draw the rule at the series' starting value.
  final bool showBaseline;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Every colour is resolved here, from tokens, and handed to the painter.
    // A painter that called `AstryxTheme.of` itself would still be correct —
    // but a painter that hard-coded a hex would be right in one theme out of
    // eight and in one brightness out of two.
    return Semantics(
      label: label,
      value: semanticsValue,
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: CustomPaint(
            painter: _TrendPainter(
              values: values,
              line: theme.color(color),
              fill: theme.color(color).withValues(alpha: 0.14),
              baseline: theme.color(AstryxColorToken.border),
              showBaseline: showBaseline,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({
    required this.values,
    required this.line,
    required this.fill,
    required this.baseline,
    required this.showBaseline,
  });

  final List<double> values;
  final Color line;
  final Color fill;
  final Color baseline;
  final bool showBaseline;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    var low = values.first;
    var high = values.first;
    for (final value in values) {
      if (value < low) low = value;
      if (value > high) high = value;
    }
    final span = high - low == 0 ? 1.0 : high - low;

    Offset at(int index) => Offset(
      size.width * index / (values.length - 1),
      size.height - ((values[index] - low) / span) * size.height,
    );

    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }

    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = fill);

    if (showBaseline) {
      final y = at(0).dy;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = baseline
          ..strokeWidth = 1,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.values != values || old.line != line || old.fill != fill;
}

/// A price in whole pence, so nothing here rounds twice.
String pence(int value) {
  final units = (value / 100).floor();
  final digits = units.toString();
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }
  return '£$grouped.${(value % 100).toString().padLeft(2, '0')}';
}

/// A signed percentage, always with its sign, for a change column.
String signed(double value) =>
    '${value >= 0 ? '+' : '−'}${value.abs().toStringAsFixed(2)}%';

// #example template_dashboard_portfolio -> PortfolioDashboardTemplate
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
                  // The badge carries the number and the words carry the
                  // window it is over. Neither can be cut off, so on a narrow
                  // column they take a line each.
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing1,
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
// #end

// #example template_table_page_chart -> TablePageChartTemplate
/// One day of trading for the whole book.
typedef Session = ({
  String date,
  String desk,
  int volume,
  int pnl,
  bool breached,
});

class TablePageChartTemplate extends StatefulWidget {
  const TablePageChartTemplate({super.key});

  @override
  State<TablePageChartTemplate> createState() => _TablePageChartTemplateState();
}

class _TablePageChartTemplateState extends State<TablePageChartTemplate> {
  static const List<Session> _all = <Session>[
    (date: '12 Aug', desk: 'Rates', volume: 4120, pnl: 184200, breached: false),
    (date: '12 Aug', desk: 'Credit', volume: 2980, pnl: -41100, breached: true),
    (date: '11 Aug', desk: 'Rates', volume: 3860, pnl: 96400, breached: false),
    (
      date: '11 Aug',
      desk: 'Equity',
      volume: 5210,
      pnl: 210500,
      breached: false,
    ),
    (date: '11 Aug', desk: 'Credit', volume: 3140, pnl: 28800, breached: false),
    (date: '10 Aug', desk: 'Rates', volume: 2740, pnl: -18600, breached: false),
    (
      date: '10 Aug',
      desk: 'Equity',
      volume: 4890,
      pnl: 152300,
      breached: false,
    ),
    (date: '9 Aug', desk: 'Credit', volume: 2210, pnl: -92400, breached: true),
    (date: '9 Aug', desk: 'Rates', volume: 3320, pnl: 64100, breached: false),
    (date: '8 Aug', desk: 'Equity', volume: 4460, pnl: 118900, breached: false),
    (date: '8 Aug', desk: 'Credit', volume: 2650, pnl: 36200, breached: false),
    (date: '7 Aug', desk: 'Rates', volume: 3980, pnl: 142700, breached: false),
  ];

  /// The series the chart draws, in the same order as the rows below it.
  static const List<double> _cumulative = <double>[
    0.14, 0.28, 0.19, 0.34, 0.41, 0.36, 0.52, 0.44, 0.58, 0.71, 0.66, 0.82,
  ];

  String _desk = 'All';
  int _page = 1;
  static const int _pageSize = 5;

  List<Session> get _matches =>
      _desk == 'All' ? _all : _all.where((row) => row.desk == _desk).toList();

  List<Session> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Session>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// Every filter goes through here, because narrowing the set while on page
  /// three shows an empty table — which reads as "no data" rather than "you
  /// are past the end".
  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final pages = (matches.length / _pageSize).ceil().clamp(1, 999);
    final start = matches.isEmpty ? 0 : (_page - 1) * _pageSize + 1;
    final end = start + rows.length - 1;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        // The table scrolls its own body under its own header row. Leaving the
        // layout scrollable puts one scroll view inside another.
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
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
                    const AstryxHeading('Trading sessions', level: 1),
                    AstryxText(
                      '${matches.length} of ${_all.length} sessions',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Desk',
                  value: _desk,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _desk = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Rates', label: 'Rates'),
                    AstryxSegment(value: 'Credit', label: 'Credit'),
                    AstryxSegment(value: 'Equity', label: 'Equity'),
                  ],
                ),
              ],
            ),
            // The chart summarises the *whole* set, not the page. A summary
            // that moved every time the reader turned a page would be a
            // summary of the page, which the page already is.
            const AstryxCard(
              variant: AstryxCardVariant.muted,
              padding: AstryxSpacingToken.spacing3,
              header: AstryxText(
                'Cumulative P&L, all desks',
                type: AstryxTextType.label,
              ),
              child: TrendChart(
                values: _cumulative,
                height: 88,
                showBaseline: false,
                label: 'Cumulative profit and loss over twelve sessions',
                semanticsValue:
                    'Rising from 0.14 to 0.82 million, with drawdowns on the '
                    '9th and the 11th',
              ),
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxText(
              matches.isEmpty ? 'Nothing to show' : '$start–$end of '
                  '${matches.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
            AstryxPagination(
              page: _page,
              pageCount: pages,
              onPageChanged: (page) => setState(() => _page = page),
            ),
          ],
        ),
        child: AstryxTable<Session>(
          label: 'Trading sessions',
          keyOf: (row) => '${row.date}/${row.desk}',
          rowLabelOf: (row) => '${row.desk} on ${row.date}',
          density: AstryxTableDensity.compact,
          minWidth: 560,
          emptyState: AstryxEmptyState(
            title: 'No sessions for that desk',
            size: AstryxEmptyStateSize.compact,
            actions: <Widget>[
              AstryxButton(
                label: 'Show all desks',
                onPressed: () => _refilter(() => _desk = 'All'),
              ),
            ],
          ),
          columns: <AstryxTableColumn<Session>>[
            AstryxTableColumn<Session>(
              id: 'date',
              header: 'Date',
              width: const AstryxTableColumnWidth.fixed(90),
              cellBuilder: (context, row) => AstryxText(row.date, maxLines: 1),
            ),
            AstryxTableColumn<Session>(
              id: 'desk',
              header: 'Desk',
              cellBuilder: (context, row) => AstryxBadge(row.desk),
            ),
            AstryxTableColumn<Session>(
              id: 'volume',
              header: 'Volume',
              width: const AstryxTableColumnWidth.fixed(100),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) =>
                  AstryxText('${row.volume}', tabularNumbers: true),
            ),
            AstryxTableColumn<Session>(
              id: 'pnl',
              header: 'P&L',
              width: const AstryxTableColumnWidth.fixed(120),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) => AstryxText(
                '${row.pnl < 0 ? '−' : ''}${pence(row.pnl.abs())}',
                tabularNumbers: true,
              ),
            ),
            AstryxTableColumn<Session>(
              id: 'limit',
              header: 'Limit',
              width: const AstryxTableColumnWidth.fixed(120),
              cellBuilder: (context, row) => row.breached
                  ? const AstryxBadge(
                      'Breached',
                      variant: AstryxBadgeVariant.error,
                      icon: AstryxIcon(AstryxIconName.error),
                    )
                  : const AstryxBadge(
                      'Within',
                      variant: AstryxBadgeVariant.success,
                      icon: AstryxIcon(AstryxIconName.success),
                    ),
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
// #end
