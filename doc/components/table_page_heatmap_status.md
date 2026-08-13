---
title: Table page with heatmap
description: A table screen whose cells carry heatmap and status colouring.
component: true
group: Templates
source: example/lib/examples/template_heatmap_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One service, and its p95 latency in each region.
typedef ServiceLatency = ({
  String service,
  String owner,
  Map<String, int> byRegion,
  String status,
});

class HeatmapStatusTablePageTemplate extends StatefulWidget {
  const HeatmapStatusTablePageTemplate({super.key});

  @override
  State<HeatmapStatusTablePageTemplate> createState() =>
      _HeatmapStatusTablePageTemplateState();
}

class _HeatmapStatusTablePageTemplateState
    extends State<HeatmapStatusTablePageTemplate> {
  static const List<String> _regions = <String>[
    'eu-west',
    'eu-north',
    'us-east',
    'us-west',
    'ap-south',
  ];

  static const List<ServiceLatency> _all = <ServiceLatency>[
    (
      service: 'scheduler',
      owner: 'Platform',
      status: 'Breaching',
      byRegion: <String, int>{
        'eu-west': 412,
        'eu-north': 388,
        'us-east': 902,
        'us-west': 741,
        'ap-south': 1180,
      },
    ),
    (
      service: 'edge',
      owner: 'Platform',
      status: 'At risk',
      byRegion: <String, int>{
        'eu-west': 88,
        'eu-north': 94,
        'us-east': 121,
        'us-west': 486,
        'ap-south': 512,
      },
    ),
    (
      service: 'artifacts',
      owner: 'Delivery',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 142,
        'eu-north': 138,
        'us-east': 166,
        'us-west': 174,
        'ap-south': 231,
      },
    ),
    (
      service: 'metrics',
      owner: 'Observability',
      status: 'At risk',
      byRegion: <String, int>{
        'eu-west': 264,
        'eu-north': 271,
        'us-east': 298,
        'us-west': 312,
        'ap-south': 640,
      },
    ),
    (
      service: 'registry',
      owner: 'Delivery',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 61,
        'eu-north': 58,
        'us-east': 74,
        'us-west': 79,
        'ap-south': 96,
      },
    ),
    (
      service: 'billing',
      owner: 'Commerce',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 104,
        'eu-north': 111,
        'us-east': 98,
        'us-west': 122,
        'ap-south': 148,
      },
    ),
    (
      service: 'search',
      owner: 'Discovery',
      status: 'Breaching',
      byRegion: <String, int>{
        'eu-west': 520,
        'eu-north': 498,
        'us-east': 610,
        'us-west': 588,
        'ap-south': 860,
      },
    ),
  ];

  String _owner = 'All';
  int _page = 1;
  static const int _pageSize = 4;

  List<ServiceLatency> get _matches => _owner == 'All'
      ? _all
      : _all.where((row) => row.owner == _owner).toList();

  List<ServiceLatency> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <ServiceLatency>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// The scale spans the **whole grid**, not the page and not the row.
  ///
  /// A ramp recomputed per page would recolour every cell when the reader
  /// turned it — the same 412 ms would be pale on one page and saturated on
  /// the next, which makes the colour a fact about the page rather than about
  /// the number.
  static final int _worst = _all
      .expand((row) => row.byRegion.values)
      .reduce((a, b) => a > b ? a : b);

  double _intensity(int value) => value / _worst;

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
                    const AstryxHeading('p95 latency by region', level: 1),
                    AstryxText(
                      '${matches.length} services · milliseconds',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Owner',
                  value: _owner,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _owner = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Platform', label: 'Platform'),
                    AstryxSegment(value: 'Delivery', label: 'Delivery'),
                  ],
                ),
              ],
            ),
            // The legend is not optional decoration. Without it the ramp is a
            // set of colours with no stated direction, and a reader has to
            // infer from the numbers what the colours were supposed to add.
            HeatLegend(
              low: 'fastest',
              high: 'slowest ($_worst ms)',
              tint: AstryxColorToken.error,
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
              '${rows.length} of ${matches.length} services',
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
        child: AstryxTable<ServiceLatency>(
          label: 'p95 latency by service and region',
          keyOf: (row) => row.service,
          rowLabelOf: (row) => row.service,
          density: AstryxTableDensity.compact,
          minWidth: 720,
          columns: <AstryxTableColumn<ServiceLatency>>[
            AstryxTableColumn<ServiceLatency>(
              id: 'service',
              header: 'Service',
              width: const AstryxTableColumnWidth.fixed(150),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.service, type: AstryxTextType.code),
                  AstryxText(
                    row.owner,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            for (final region in _regions)
              AstryxTableColumn<ServiceLatency>(
                id: region,
                header: region,
                width: const AstryxTableColumnWidth.fixed(96),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) =>
                    a.byRegion[region]!.compareTo(b.byRegion[region]!),
                cellBuilder: (context, row) => HeatCell(
                  text: '${row.byRegion[region]}',
                  intensity: _intensity(row.byRegion[region]!),
                  tint: AstryxColorToken.error,
                  onTint: AstryxColorToken.onError,
                  semanticsLabel:
                      '${row.byRegion[region]} milliseconds in $region',
                ),
              ),
            AstryxTableColumn<ServiceLatency>(
              id: 'status',
              header: 'Objective',
              width: const AstryxTableColumnWidth.fixed(130),
              cellBuilder: (context, row) => switch (row.status) {
                // The status column is *semantic*, and it is a badge rather
                // than a heat cell: "breaching" is a threshold somebody
                // agreed, not a position on a ramp. Two different kinds of
                // colour on one screen have to look like two different kinds.
                'Breaching' => const AstryxBadge(
                  'Breaching',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                'At risk' => const AstryxBadge(
                  'At risk',
                  variant: AstryxBadgeVariant.warning,
                  icon: AstryxIcon(AstryxIconName.warning),
                ),
                _ => const AstryxBadge(
                  'Healthy',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
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

Filter by owner and turn the page: a cell keeps its colour, because the scale spans the whole grid rather than what is on screen.


> **Careful**
>
> **There is no heatmap component, and no colour scale in the token system either.** The ten [palette](../guides/color.md) families are *categorical* — "the Red team" — so none of them is a ramp, and picking one would be asserting a severity the data has not got. What a heatmap needs is a continuous scale between two tokens, and that is one `Color.lerp`.

```dart
final fill = Color.lerp(
  theme.color(AstryxColorToken.backgroundMuted),   // the page's own ground
  theme.color(tint),                               // error, or success
  intensity.clamp(0.0, 1.0),
)!;

// Past about half way the ground is dark enough that the page's text
// colour stops being legible on it, and the paired foreground takes over.
final foreground = intensity > 0.55
    ? theme.color(onTint)
    : theme.color(AstryxColorToken.textPrimary);
```

Both ends are tokens, so the ramp moves with the theme and the brightness instead of being correct only in the one it was picked in. `onError` is the foreground paired with `error` — every filled token in the system has one, and reaching for a ground without its pair is how contrast is lost.

## Text on a ground you painted yourself

[AstryxText](text.md) takes a token, not a `Color`, which is deliberate. The way to put text on a surface of your own is to set the ambient style and ask for `AstryxTextColor.inherit` — the same route [AstryxMediaTheme](media_theme.md) takes over a photograph.

```dart
DefaultTextStyle.merge(
  style: TextStyle(color: foreground),
  child: AstryxText(text, color: AstryxTextColor.inherit),
)
```

## The scale spans the grid, not the page

The busiest cell in the *whole* data set is what one maps to. A ramp recomputed per page would recolour every cell when the reader turned it: the same 412 ms pale on one page and saturated on the next, which makes the colour a fact about the page rather than about the number.

## Two kinds of colour, and they must not look alike

| Column | Colour means | Drawn as |
| --- | --- | --- |
| The five regions | Where this value sits on a continuous scale | A `HeatCell` — a ground lerped toward `error`, with the figure on top. |
| Objective | A threshold somebody agreed | An [AstryxBadge](badge.md) with an icon and a word. *Breaching* is not a position on a ramp. |

> **Accessibility**
>
> **Every cell prints its own number, and the screen carries a legend.** The figure is the half of the cell that survives greyscale, a screenshot and a colour-blind reader; the legend is what says which end of the ramp is which, because a hue does not imply a direction. Each cell also announces itself in full — "902 milliseconds in us-east" — rather than reading out a bare number in a grid whose column headers are somewhere above.

## Related

- [Retail heatmap table](table_page_shoe_store_heatmap.md) — the same screen with the ramp running the other way.
- [Table page](table_page.md) — the frame, without the colouring.
- [Colour](../guides/color.md) — the semantic roles, and why the palettes are not severities.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Table page with heatmap`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Table+page+with+heatmap&component=Table+page+with+heatmap) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Table+page+with+heatmap&area=Table+page+with+heatmap) — both templates arrive with the component filled in.
