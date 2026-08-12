/// Two table screens whose cells are coloured by their value.
///
/// **There is no heatmap component, and there is no colour scale in the token
/// system either.** The ten `AstryxPalette` families are *categorical* — "the
/// Red team" — so none of them is a ramp, and picking one would be picking a
/// severity the data has not got. What a heatmap needs is a continuous scale
/// between two tokens, which is one `Color.lerp` and is what [HeatCell] below
/// does.
///
/// The rule that survives all of it: **colour is never the only signal**. Every
/// cell prints its own number, and every screen carries a legend saying which
/// end of the ramp is which. A grid the reader has to squint at to rank is a
/// grid that has told them nothing.
///
/// Nothing here is exported. Both templates are compositions worth copying.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// One cell of a heatmap: a figure, on a ground derived from that figure.
///
/// [intensity] is already normalised — working out where a value sits between
/// the smallest and the largest is the caller's job, because only the caller
/// knows whether the scale should span the row, the column or the whole grid.
class HeatCell extends StatelessWidget {
  /// Creates a heat cell.
  const HeatCell({
    required this.text,
    required this.intensity,
    super.key,
    this.tint = AstryxColorToken.accent,
    this.onTint = AstryxColorToken.onAccent,
    this.semanticsLabel,
  });

  /// The figure, written out. Never omitted: it is the half of the cell that
  /// works in greyscale, in a screenshot, and for a colour-blind reader.
  final String text;

  /// Where this value sits on the scale, from 0 to 1.
  final double intensity;

  /// The token the top of the ramp is made of.
  final AstryxColorToken tint;

  /// The foreground paired with [tint] — every filled token has one.
  final AstryxColorToken onTint;

  /// What a screen reader hears instead of the bare figure.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // The ramp: the page's own muted ground at zero, the tint at one. Both
    // ends are tokens, so the scale moves with the theme and the brightness
    // instead of being right in the one it was picked in.
    final fill = Color.lerp(
      theme.color(AstryxColorToken.backgroundMuted),
      theme.color(tint),
      intensity.clamp(0.0, 1.0),
    )!;

    // Past about half way the ground is dark enough that the page's text
    // colour stops being legible on it, and the paired foreground takes over.
    final foreground = intensity > 0.55
        ? theme.color(onTint)
        : theme.color(AstryxColorToken.textPrimary);

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: semanticsLabel != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing(AstryxSpacingToken.spacing2),
            vertical: theme.spacing(AstryxSpacingToken.spacing1),
          ),
          // `AstryxText` takes a token, not a `Color` — so the way to put text
          // on a ground of your own is to set the ambient style and ask for
          // `inherit`. That is the same route `AstryxMediaTheme` takes over a
          // photograph.
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foreground),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AstryxText(
                text,
                color: AstryxTextColor.inherit,
                tabularNumbers: true,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The legend a heatmap is unreadable without.
class HeatLegend extends StatelessWidget {
  /// Creates a legend.
  const HeatLegend({
    required this.low,
    required this.high,
    super.key,
    this.tint = AstryxColorToken.accent,
  });

  /// What the pale end means, in words.
  final String low;

  /// What the saturated end means.
  final String high;

  /// The token the ramp runs to.
  final AstryxColorToken tint;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText(
          low,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        for (final step in const <double>[0, 0.25, 0.5, 0.75, 1])
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(
                theme.color(AstryxColorToken.backgroundMuted),
                theme.color(tint),
                step,
              ),
              borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
            ),
            child: const SizedBox(width: 24, height: 12),
          ),
        AstryxText(
          high,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}

// #example template_table_page_heatmap_status -> HeatmapStatusTablePageTemplate
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
// #end

// #example template_table_page_shoe_store_heatmap -> ShoeStoreHeatmapTemplate
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
// #end
