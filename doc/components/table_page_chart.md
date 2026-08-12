---
title: Table page with chart
description: A table screen with a summary chart above it.
component: true
group: Templates
source: example/lib/examples/template_chart_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Turn the page: the rows change and the chart does not. Filter by desk and the page resets to one.


## The chart summarises the set, not the page

This is the decision the screen is built around, and the one that is usually got wrong. A chart that redrew every time the reader turned a page would be a chart *of that page* — which the page already is, in more detail. The summary is only worth its space if it says something the rows on screen cannot.

```text
AstryxLayout(scrollable: false)
├── header ← title, desk filter, and the chart, in a muted card
├── child  ← AstryxTable, scrolling its own body
└── footer ← "1–5 of 12" and AstryxPagination
```

The chart lives in the pinned header for the same reason the filters do: on a screen where the table is the work, a summary you have to scroll up to reach is a summary nobody consults.

## Every filter resets the page

```dart
void _refilter(VoidCallback change) => setState(() {
  change();
  _page = 1;      // ← the whole point
});
```

Without it, narrowing a twelve-row set while on page three shows an empty table — which reads as "no data" rather than "you are past the end", and is the single most common bug on a screen like this.

> **Careful**
>
> **`scrollable: false`.** [AstryxTable](table.md) scrolls its own body under its header row. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded — a layout assertion rather than a subtle bug.

> **Accessibility**
>
> The chart is a `TrendChart` with a `semanticsValue` that states the shape in words — where it starts, where it ends, and where the drawdowns are. The same painter, and the same rule, as the [portfolio dashboard](dashboard_portfolio.md): the picture is never the only copy of the fact.

The limit column is a badge with an icon and a word — *Breached* or *Within* — rather than a red row. A row tinted by its status is a row whose status is invisible in greyscale and unreadable to a screen reader.

## Related

- [Table page](table_page.md) — the same screen with no chart.
- [Portfolio dashboard](dashboard_portfolio.md) — the same painter, and the note about why there is no chart component.
- [AstryxPagination](pagination.md) — one-based pages, and the disabled ends.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

