---
title: Classic gallery
description: A uniform wall of media tiles, each opening the same viewer on the item that was pressed.
component: true
group: Templates
source: example/lib/examples/template_gallery_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One item in the gallery.
///
/// `name` is not decoration. A tile whose picture has not loaded, or whose
/// reader cannot see it, has nothing else — which is why every media widget in
/// this package makes the name required rather than optional.
typedef GalleryItem = ({String name, String meta, String album});

class ClassicGalleryTemplate extends StatefulWidget {
  const ClassicGalleryTemplate({super.key});

  @override
  State<ClassicGalleryTemplate> createState() => _ClassicGalleryTemplateState();
}

class _ClassicGalleryTemplateState extends State<ClassicGalleryTemplate> {
  static const List<GalleryItem> _items = <GalleryItem>[
    (name: 'Cold aisle, rack 14', meta: '4032 × 3024', album: 'Site visit'),
    (name: 'Patch panel B', meta: '4032 × 3024', album: 'Site visit'),
    (name: 'Generator test', meta: '1920 × 1080', album: 'Site visit'),
    (name: 'Latency dashboard', meta: '2560 × 1440', album: 'Incident 4102'),
    (name: 'Scheduler timeline', meta: '2560 × 1440', album: 'Incident 4102'),
    (name: 'Health check log', meta: '1440 × 900', album: 'Incident 4102'),
    (name: 'Rollback approval', meta: '1440 × 900', album: 'Incident 4102'),
    (name: 'Post-mortem board', meta: '3024 × 4032', album: 'Incident 4102'),
  ];

  final AstryxOverlayController _viewer = AstryxOverlayController();

  /// Which item the viewer opens on, and which tile reads as selected.
  int _index = 0;
  String _album = 'All';

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  List<GalleryItem> get _shown => _album == 'All'
      ? _items
      : _items.where((item) => item.album == _album).toList();

  void _open(int index) {
    setState(() => _index = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing0_5,
              children: <Widget>[
                const AstryxHeading('Photos', level: 1),
                AstryxText(
                  '${shown.length} of ${_items.length} items',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Album',
              value: _album,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() {
                _album = value;
                _index = 0;
              }),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: 'All', label: 'All'),
                AstryxSegment(value: 'Site visit', label: 'Site visit'),
                AstryxSegment(value: 'Incident 4102', label: 'Incident'),
              ],
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            // A wrapping row of fixed-width tiles rather than an `AstryxGrid`:
            // a grid gives every cell in a row the height of the tallest, which
            // means measuring each cell intrinsically — and a pressable tile
            // sits inside the touch-target wrapper, which cannot answer that
            // measurement in touch density. Uniform tiles get the same wall
            // either way.
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              children: <Widget>[
                for (var i = 0; i < shown.length; i++)
                  _GalleryTile(item: shown[i], onPressed: () => _open(i)),
              ],
            ),
            // The viewer lives beside the wall, not inside a tile: one overlay
            // for the whole gallery, opened on whichever item was pressed.
            AstryxLightbox(
              controller: _viewer,
              initialIndex: _index,
              label: 'Photos',
              items: <AstryxLightboxItem>[
                for (final item in shown)
                  AstryxLightboxItem(
                    label: item.name,
                    caption: '${item.name} · ${item.meta} · ${item.album}',
                    child: SizedBox(
                      width: 640,
                      child: AstryxAspectRatio(
                        ratio: 3 / 2,
                        background: AstryxColorToken.backgroundCard,
                        child: Center(
                          child: AstryxText(
                            item.name,
                            color: AstryxTextColor.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              actions: <Widget>[
                AstryxIconButton(
                  icon: AstryxIconName.copy,
                  label: 'Copy a link to this photo',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One tile: a picture, its name over the picture, and the whole thing
/// pressable.
class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.item, required this.onPressed});

  final GalleryItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return SizedBox(
      width: 200,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing0,
        // The name is announced here, once. The caption over the picture is
        // decoration by the time a screen reader gets this far.
        semanticsLabel: '${item.name}, ${item.album}',
        onPressed: onPressed,
        child: ClipRRect(
          borderRadius: theme.borderRadius(AstryxRadiusToken.container),
          child: Stack(
            children: <Widget>[
              const AstryxAspectRatio(
                ratio: 3 / 2,
                background: AstryxColorToken.backgroundInverted,
                child: Center(
                  // Over a dark ground, `inherit` is the only correct answer —
                  // and inside a media scope it is the colour that scope set.
                  child: AstryxMediaTheme(
                    scrim: AstryxMediaScrim.none,
                    padding: AstryxSpacingToken.spacing0,
                    child: AstryxIcon(
                      AstryxIconName.viewColumns,
                      size: AstryxIconSize.lg,
                    ),
                  ),
                ),
              ),
              // Anything drawn over media goes through `AstryxMediaTheme`: the
              // page's text colour is a guess about a photograph nobody has
              // seen, and the scrim is what makes the guess unnecessary.
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 0,
                end: 0,
                bottom: 0,
                child: AstryxMediaTheme(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing0_5,
                    children: <Widget>[
                      AstryxText(
                        item.name,
                        color: AstryxTextColor.inherit,
                        maxLines: 1,
                      ),
                      AstryxText(
                        item.meta,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.inherit,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Press a tile: the viewer opens on that one. Page it with the arrow keys and close it with Escape. Filter by album and the viewer follows the filtered set.


## One viewer, not one per tile

The [AstryxLightbox](lightbox.md) sits beside the wall of tiles and takes the whole list. A tile does not own an overlay — it sets an index and shows the shared one. Eight tiles with eight lightboxes is eight overlay controllers, eight focus traps and eight chances for two of them to be open at once.

```dart
void _open(int index) {
  setState(() => _index = index);   // which item the viewer starts on
  _viewer.show();
}

AstryxLightbox(
  controller: _viewer,
  initialIndex: _index,             // read every time it opens, not once
  items: items,
)
```

## A picture is not the thing’s name

Every tile carries its name in text as well as in the picture, and the card announces `"{name}, {album}"`. That is not a courtesy: a thumbnail that has not loaded, or a reader who cannot see it, leaves the name as the only thing there is — which is why the name is required on [AstryxThumbnail](thumbnail.md) and [AstryxAvatar](avatar.md) rather than optional.

## Anything over media goes through AstryxMediaTheme

The caption sits on the picture, so it cannot use the page’s text colour — the picture is whatever colour it is. [AstryxMediaTheme](media_theme.md) forces the on-dark tokens and puts a scrim behind them, and the text inside it asks for `AstryxTextColor.inherit` so that both the caption and the glyph beside it take that colour without either naming it.

> **Careful**
>
> **The wall is a wrapping row of fixed-width tiles, not an [AstryxGrid](grid.md).** A grid gives every cell in a row the height of the tallest, which means measuring each cell intrinsically — and a pressable tile sits inside the touch-target wrapper, which cannot answer that measurement in touch density. Uniform tiles look identical either way; a grid is right for cells of text and figures, like the [dashboard](dashboard.md) tiles.

> **Accessibility**
>
> The tile is one tab stop and announces its name once. The caption over the picture is inside the same card, so a second announcement of the same words would be noise — the card’s `semanticsLabel` is the sentence, and the visible caption is what a sighted reader gets instead.

Filtering by album rebuilds both the wall and the viewer’s list from the same `_shown`, so the counter inside the viewer says "3 of 5" about the set the reader is actually looking at. A viewer paging through hidden items is a filter that did not apply.

## Related

- [AstryxLightbox](lightbox.md) — the viewer, its paging and its focus trap.
- [AstryxAspectRatio](aspect_ratio.md) — the box, the ground and the clip.
- [AstryxMediaTheme](media_theme.md) — the scrim and the on-dark tokens.
- [AstryxThumbnail](thumbnail.md) — the smaller tile, with a caption and a selected state built in.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

