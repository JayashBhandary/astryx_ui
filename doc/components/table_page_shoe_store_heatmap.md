---
title: Retail heatmap table
description: The heatmap table screen with a retail data set.
component: true
group: Templates
source: example/lib/examples/template_heatmap_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One shoe, and how many pairs went in each size.
typedef Style = ({
  String name,
  String range,
  Map<String, int> bySize,
  int stock,
});

class ShoeStoreHeatmapTemplate extends StatefulWidget {
  const ShoeStoreHeatmapTemplate({super.key});

  @override
  State<ShoeStoreHeatmapTemplate> createState() =>
      _ShoeStoreHeatmapTemplateState();
}

class _ShoeStoreHeatmapTemplateState extends State<ShoeStoreHeatmapTemplate> {
  static const List<String> _sizes = <String>['6', '7', '8', '9', '10', '11'];

  static const List<Style> _all = <Style>[
    (
      name: 'Trail Runner GTX',
      range: 'Trail',
      stock: 412,
      bySize: <String, int>{
        '6': 18,
        '7': 46,
        '8': 92,
        '9': 141,
        '10': 118,
        '11': 54,
      },
    ),
    (
      name: 'Fell Shoe 3',
      range: 'Trail',
      stock: 96,
      bySize: <String, int>{
        '6': 11,
        '7': 28,
        '8': 61,
        '9': 88,
        '10': 74,
        '11': 31,
      },
    ),
    (
      name: 'Approach Mid',
      range: 'Hiking',
      stock: 12,
      bySize: <String, int>{
        '6': 6,
        '7': 19,
        '8': 44,
        '9': 52,
        '10': 48,
        '11': 22,
      },
    ),
    (
      name: 'Road Tempo',
      range: 'Road',
      stock: 288,
      bySize: <String, int>{
        '6': 24,
        '7': 58,
        '8': 104,
        '9': 162,
        '10': 131,
        '11': 47,
      },
    ),
    (
      name: 'City Knit',
      range: 'Road',
      stock: 0,
      bySize: <String, int>{
        '6': 31,
        '7': 64,
        '8': 88,
        '9': 96,
        '10': 71,
        '11': 26,
      },
    ),
    (
      name: 'Summit Boot',
      range: 'Hiking',
      stock: 54,
      bySize: <String, int>{
        '6': 4,
        '7': 12,
        '8': 33,
        '9': 41,
        '10': 39,
        '11': 26,
      },
    ),
  ];

  String _range = 'All';
  int _page = 1;
  static const int _pageSize = 4;

  List<Style> get _matches => _range == 'All'
      ? _all
      : _all.where((row) => row.range == _range).toList();

  List<Style> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Style>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// The busiest cell in the whole grid, so the ramp means the same thing on
  /// every page and under every filter.
  static final int _best = _all
      .expand((row) => row.bySize.values)
      .reduce((a, b) => a > b ? a : b);

  /// Which size sold most, across everything shown. The point of the screen.
  String get _peakSize {
    final totals = <String, int>{};
    for (final row in _matches) {
      for (final entry in row.bySize.entries) {
        totals[entry.key] = (totals[entry.key] ?? 0) + entry.value;
      }
    }
    if (totals.isEmpty) return '—';
    final ranked = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return 'UK ${ranked.first.key}';
  }

  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final pages = (matches.length / _pageSize).ceil().clamp(1, 999);

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
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
                    const AstryxHeading('Pairs sold by size', level: 1),
                    // The conclusion, in words, above the grid. A heatmap is
                    // how a reader checks an answer; it is a poor way to be
                    // told one.
                    AstryxText(
                      'Busiest size: $_peakSize · ${matches.length} styles',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Range',
                  value: _range,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _range = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Road', label: 'Road'),
                    AstryxSegment(value: 'Trail', label: 'Trail'),
                    AstryxSegment(value: 'Hiking', label: 'Hiking'),
                  ],
                ),
              ],
            ),
            // Sales rise toward `success`, and latency rose toward `error` on
            // the [HeatmapStatusTablePageTemplate]. Same ramp, opposite
            // meaning — which is exactly why the legend has to say which end
            // is which rather than leaving the hue to imply it.
            HeatLegend(
              low: 'fewest',
              high: 'most ($_best pairs)',
              tint: AstryxColorToken.success,
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
              '${rows.length} of ${matches.length} styles',
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
        child: AstryxTable<Style>(
          label: 'Pairs sold by style and size',
          keyOf: (row) => row.name,
          rowLabelOf: (row) => row.name,
          density: AstryxTableDensity.compact,
          minWidth: 760,
          columns: <AstryxTableColumn<Style>>[
            AstryxTableColumn<Style>(
              id: 'style',
              header: 'Style',
              width: const AstryxTableColumnWidth.fixed(170),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.name, maxLines: 1),
                  AstryxText(
                    row.range,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            for (final size in _sizes)
              AstryxTableColumn<Style>(
                id: 'size_$size',
                header: 'UK $size',
                width: const AstryxTableColumnWidth.fixed(78),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.bySize[size]!.compareTo(b.bySize[size]!),
                cellBuilder: (context, row) => HeatCell(
                  text: '${row.bySize[size]}',
                  intensity: row.bySize[size]! / _best,
                  tint: AstryxColorToken.success,
                  onTint: AstryxColorToken.onSuccess,
                  semanticsLabel: '${row.bySize[size]} pairs in UK $size',
                ),
              ),
            AstryxTableColumn<Style>(
              id: 'stock',
              header: 'Stock',
              width: const AstryxTableColumnWidth.fixed(130),
              compare: (a, b) => a.stock.compareTo(b.stock),
              cellBuilder: (context, row) => switch (row.stock) {
                0 => const AstryxBadge(
                  'Out of stock',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                < 50 => AstryxBadge(
                  '${row.stock} left',
                  variant: AstryxBadgeVariant.warning,
                  icon: const AstryxIcon(AstryxIconName.warning),
                ),
                _ => AstryxBadge(
                  '${row.stock} in stock',
                  variant: AstryxBadgeVariant.success,
                  icon: const AstryxIcon(AstryxIconName.success),
                ),
              },
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
```

Filter by range: the busiest size in the header is recomputed, and the ramp is not.


## The same widget, the opposite meaning

This screen and the [latency heatmap](table_page_heatmap_status.md) share `HeatCell` and `HeatLegend` exactly. What differs is the direction of the value: high latency is bad and runs toward `error`, high sales are good and run toward `success`.

> **Careful**
>
> **Which is why the legend is not decoration.** A hue does not imply a direction — a reader arriving at a saturated grid has no way to know whether they are looking at a triumph or a fire. The legend states both ends in words, and the header states the conclusion outright.

## Say the answer, then show the grid

"Busiest size: UK 9" sits above the table, in text, and it is recomputed from whatever the filters have left. A heatmap is a good way for a reader to *check* an answer and a poor way to be told one — the grid is the evidence, and the sentence is the finding.

```text
AstryxLayout(scrollable: false)
├── header ← the finding, the range filter, HeatLegend(success)
├── child  ← AstryxTable: style · six sizes · stock
└── footer ← the count, and AstryxPagination
```

## The stock column is a threshold, not a scale

Zero is *Out of stock* in the error variant, under fifty is "12 left" as a warning, and anything else is a success badge. Those are three decisions somebody made about a business, and a ramp would blur them into a gradient that means nothing at either end.

```dart
cellBuilder: (context, row) => switch (row.stock) {
  0 => const AstryxBadge('Out of stock', variant: AstryxBadgeVariant.error, …),
  < 50 => AstryxBadge('\${row.stock} left', variant: AstryxBadgeVariant.warning, …),
  _ => AstryxBadge('\${row.stock} in stock', variant: AstryxBadgeVariant.success, …),
},
```

> **Accessibility**
>
> Each cell announces "141 pairs in UK 9". A screen-reader user moving across a row of six figures has no column header in earshot, so a cell that announces only its number has told them a number about nothing.

Every size column is sortable, because ranking one size across every style is the second question this screen gets asked — and a column is sortable only if it has a `compare`.

## Related

- [Table page with heatmap](table_page_heatmap_status.md) — the same widgets with the ramp reversed, and the notes on how it is built.
- [Product gallery](product_gallery.md) — the shop these figures come from.
- [AstryxBadge](badge.md) — the variants, and what each one claims.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

