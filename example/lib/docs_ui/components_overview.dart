/// The `/components` overview: every component as a live tile, by category.
///
/// Upstream's library page, in Flutter. Each tile renders the first example
/// of the component's page — the real widget, scaled down, not a screenshot —
/// so a tile cannot drift from the component it shows.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/categories.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:flutter/widgets.dart';

/// The size a tile's preview is laid out at, before it is scaled to the tile.
///
/// About one and a half times a tile's width, so a preview shows at roughly
/// two-thirds of its real size — small enough to read as a thumbnail, large
/// enough that the text in it is still text. In the tile's own 16:10
/// proportion, so the scale is the same both ways.
const Size docsTileCanvas = Size(600, 375);

/// Pages whose first example is wider than [docsTileCanvas] allows, and the
/// canvas each needs instead. Checked by `test/components_overview_test.dart`,
/// which pumps every tile: a new wide example fails there, not on the site.
const Map<String, Size> docsTileCanvasOverrides = <String, Size>{
  'code': Size(960, 600),
  'empty_state': Size(800, 500),
};

/// One tile's data: a page and the example it previews.
class DocsTile {
  const DocsTile(this.page, this.example);

  final DocPage page;

  /// The first example on the page, or null when it has none.
  final DocExample? example;
}

/// The overview's content, by category, in upstream's order.
///
/// Only written pages that have a category get a tile — a placeholder has no
/// example to show, and guides, hooks and providers are not components.
Map<String, List<DocsTile>> docsOverviewTiles() {
  final byCategory = <String, List<DocsTile>>{
    for (final category in DocCategory.all) category: <DocsTile>[],
  };
  for (final page in writtenDocPages) {
    final category = docCategory(page);
    if (category == null) continue;
    final example = page.blocks.whereType<DocExample>().firstOrNull;
    byCategory[category]!.add(DocsTile(page, example));
  }
  for (final tiles in byCategory.values) {
    tiles.sort(
      (a, b) => docDisplayName(a.page).compareTo(docDisplayName(b.page)),
    );
  }
  byCategory.removeWhere((_, tiles) => tiles.isEmpty);
  return byCategory;
}

/// The overview page.
class DocsComponentsOverview extends StatefulWidget {
  const DocsComponentsOverview({super.key});

  @override
  State<DocsComponentsOverview> createState() => _DocsComponentsOverviewState();
}

class _DocsComponentsOverviewState extends State<DocsComponentsOverview> {
  final ScrollController _scroll = ScrollController();
  late final Map<String, List<DocsTile>> _tiles = docsOverviewTiles();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final sections = _tiles.entries.toList();

    return RawScrollbar(
      controller: _scroll,
      thumbColor: theme.color(AstryxColorToken.borderEmphasized),
      radius: const Radius.circular(8),
      thickness: 8,
      // A sliver list, so a section is built only as it scrolls near: a
      // hundred live previews at once would be a hundred widgets animating off
      // screen.
      child: CustomScrollView(
        controller: _scroll,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing(AstryxSpacingToken.spacing6),
              vertical: theme.spacing(AstryxSpacingToken.spacing8),
            ),
            sliver: SliverList.builder(
              itemCount: sections.length + 1,
              itemBuilder: (context, index) => AstryxCenter(
                axis: AstryxCenterAxis.horizontal,
                maxWidth: 1080,
                child: index == 0
                    ? const _Hero()
                    : _CategorySection(
                        title: sections[index - 1].key,
                        tiles: sections[index - 1].value,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final count = docsOverviewTiles().values.fold<int>(
      0,
      (sum, tiles) => sum + tiles.length,
    );

    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing(AstryxSpacingToken.spacing8),
        bottom: theme.spacing(AstryxSpacingToken.spacing6),
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading(
            'Browse the library',
            level: 1,
            type: AstryxHeadingType.display1,
            justify: AstryxTextJustify.center,
          ),
          AstryxText(
            'Every component — $count of them — with copy-ready examples for '
            'every variant, state, and pattern.',
            type: AstryxTextType.large,
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: theme.spacing(AstryxSpacingToken.spacing2),
            ),
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.center,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AstryxButton(
                  label: 'Install the package',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.lg,
                  onPressed: () => controller.pageId = 'installation',
                ),
                AstryxButton(
                  label: 'View on pub.dev',
                  size: AstryxButtonSize.lg,
                  onPressed: () => docsFollow(
                    context,
                    'https://pub.dev/packages/astryx_ui',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: theme.spacing(AstryxSpacingToken.spacing8),
            ),
            child: const AstryxDivider(),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.title, required this.tiles});

  final String title;
  final List<DocsTile> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final gap = theme.spacing(AstryxSpacingToken.spacing3);

    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing(AstryxSpacingToken.spacing6),
        bottom: theme.spacing(AstryxSpacingToken.spacing4),
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHeading(title),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 860
                  ? 3
                  : constraints.maxWidth >= 520
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: theme.spacing(AstryxSpacingToken.spacing5),
                children: <Widget>[
                  for (final tile in tiles)
                    SizedBox(width: width, child: DocsComponentTile(tile)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One tile: a live, scaled preview with the component's name under it.
class DocsComponentTile extends StatelessWidget {
  const DocsComponentTile(this.tile, {super.key});

  final DocsTile tile;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.maybeOf(context);
    final name = docDisplayName(tile.page);
    void open() => controller?.pageId = tile.page.id;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          variant: AstryxCardVariant.muted,
          padding: AstryxSpacingToken.spacing0,
          semanticsLabel: '$name: ${tile.page.description}',
          onPressed: open,
          child: ClipRRect(
            borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            child: ColoredBox(
              // The muted surface, painted rather than left to the card: a
              // tile has to read as a tile against the page in every theme,
              // and the card's muted variant is transparent in some of them.
              color: theme.color(AstryxColorToken.backgroundMuted),
              child: AspectRatio(
                aspectRatio: docsTileCanvas.aspectRatio,
                child: _TilePreview(
                  example: tile.example,
                  canvas:
                      docsTileCanvasOverrides[tile.page.id] ?? docsTileCanvas,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: open,
          behavior: HitTestBehavior.opaque,
          child: ExcludeSemantics(
            child: AstryxText(
              name,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

/// The example, laid out at [docsTileCanvas] and scaled to fit the tile.
///
/// Laid out the way the page lays it out — full width, unbounded height — so a
/// preview that renders on its page renders here. Inert: a tile is a link, and
/// a button inside it that could be pressed would be a second, smaller link.
class _TilePreview extends StatelessWidget {
  const _TilePreview({required this.example, required this.canvas});

  final DocExample? example;
  final Size canvas;

  @override
  Widget build(BuildContext context) {
    final builder = example == null ? null : docPreviews[example!.snippetId];
    if (builder == null) {
      return const Center(
        child: AstryxIcon(
          AstryxIconName.viewColumns,
          color: AstryxIconColor.secondary,
        ),
      );
    }

    final child = Builder(builder: builder);
    final placed = switch (example!.align) {
      DocExampleAlign.center => Center(child: child),
      DocExampleAlign.start || DocExampleAlign.stretch => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: SizedBox(width: double.infinity, child: child),
      ),
    };

    return IgnorePointer(
      child: ExcludeFocus(
        child: ExcludeSemantics(
          child: FittedBox(
            child: SizedBox.fromSize(
              size: canvas,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: Center(child: placed),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
