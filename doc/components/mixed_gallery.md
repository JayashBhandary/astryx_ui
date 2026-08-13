---
title: Mixed gallery
description: A gallery of items at mixed sizes.
component: true
group: Templates
source: example/lib/examples/template_media_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class MixedGalleryTemplate extends StatefulWidget {
  const MixedGalleryTemplate({super.key});

  @override
  State<MixedGalleryTemplate> createState() => _MixedGalleryTemplateState();
}

class _MixedGalleryTemplateState extends State<MixedGalleryTemplate> {
  /// The sizes differ because the pictures do.
  ///
  /// A panorama cropped to a square is a panorama nobody can read, and a
  /// portrait letterboxed into a 16:9 tile is mostly ground. Each item carries
  /// its own ratio and its own width, and the row wraps around them.
  static const List<({Shot shot, double width})> _items =
      <({Shot shot, double width})>[
        (
          shot: (
            name: 'Cold aisle, full length',
            caption: 'Panorama · 8064 × 2268',
            ratio: 32 / 9,
          ),
          width: 420,
        ),
        (
          shot: (
            name: 'Rack 14, door open',
            caption: 'Portrait · 3024 × 4032',
            ratio: 3 / 4,
          ),
          width: 170,
        ),
        (
          shot: (
            name: 'Patch panel B',
            caption: 'Square · 3024 × 3024',
            ratio: 1,
          ),
          width: 200,
        ),
        (
          shot: (
            name: 'Generator test',
            caption: 'Video · 1920 × 1080',
            ratio: 16 / 9,
          ),
          width: 300,
        ),
        (
          shot: (
            name: 'Health check log',
            caption: 'Screenshot · 1440 × 900',
            ratio: 8 / 5,
          ),
          width: 260,
        ),
      ];

  final AstryxOverlayController _viewer = AstryxOverlayController();

  int _index = 0;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  void _open(int index) {
    setState(() => _index = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Site visit', level: 1)),
            AstryxText(
              '${_items.length} items',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // A wrapping row, not an `AstryxGrid`. A grid gives every cell in a row
        // the height of the tallest — which is the whole thing this screen is
        // trying not to do, quite apart from the intrinsic measurement a
        // pressable tile cannot answer in touch density.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.start,
          children: <Widget>[
            for (var i = 0; i < _items.length; i++)
              _MixedTile(
                shot: _items[i].shot,
                width: _items[i].width,
                onPressed: () => _open(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: _viewer,
          initialIndex: _index,
          label: 'Site visit',
          items: <AstryxLightboxItem>[
            for (final item in _items)
              AstryxLightboxItem(
                label: item.shot.name,
                caption: '${item.shot.name} · ${item.shot.caption}',
                // The viewer shows each item at its own ratio too. A gallery
                // that mixes shapes on the wall and squares them in the viewer
                // has lied about one of the two.
                child: SizedBox(
                  width: 640,
                  child: AstryxAspectRatio(
                    ratio: item.shot.ratio,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        item.shot.name,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// One tile, at whatever size and shape its picture asks for.
class _MixedTile extends StatelessWidget {
  const _MixedTile({
    required this.shot,
    required this.width,
    required this.onPressed,
  });

  final Shot shot;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing2,
        semanticsLabel: '${shot.name}, ${shot.caption}',
        onPressed: onPressed,
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing0_5,
          children: <Widget>[
            AstryxText(shot.name, type: AstryxTextType.label, maxLines: 1),
            AstryxText(
              shot.caption,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ],
        ),
        child: AstryxAspectRatio(
          ratio: shot.ratio,
          child: const Center(
            child: AstryxIcon(AstryxIconName.viewColumns),
          ),
        ),
      ),
    );
  }
}
```

Press any tile: the viewer opens on it, and shows it at the same shape the tile did.


## The sizes differ because the pictures do

This is the whole argument for the screen. A panorama cropped to a square is a panorama nobody can read; a portrait letterboxed into 16:9 is mostly ground. The [classic gallery](classic_gallery.md) is right when the items really are interchangeable — this one is right when they are not, and pretending otherwise loses information.

```dart
typedef Shot = ({String name, String caption, double ratio});

// Each item carries its own ratio *and* its own width. The row wraps
// around whatever those turn out to be.
(shot: (name: 'Cold aisle, full length', ratio: 32 / 9), width: 420),
(shot: (name: 'Rack 14, door open',      ratio:  3 / 4), width: 170),
```

> **Careful**
>
> **Not an [AstryxGrid](grid.md).** A grid gives every cell in a row the height of the tallest — which is precisely what this screen exists not to do. (It also measures each cell intrinsically, and a pressable tile sits inside the touch-target wrapper, which cannot answer that measurement in touch density.) A wrapping `AstryxHStack` of fixed-width tiles is the shape.

## The viewer keeps the promise the wall made

Each [AstryxLightbox](lightbox.md) item is drawn at its own ratio too. A gallery that mixes shapes on the wall and squares them in the viewer has lied about one of the two, and the reader finds out at exactly the moment they wanted a closer look.

One viewer sits beside the wall and takes the whole list — a tile sets an index and shows it. Five tiles with five lightboxes is five overlay controllers, five focus traps, and a good chance of two being open at once.

> **Accessibility**
>
> The tile’s `semanticsLabel` is the name *and* the caption as one sentence: "Cold aisle, full length, Panorama · 8064 × 2268". The size and shape of a picture are facts about it, and on this screen they are the facts the layout is conveying visually — so they have to be conveyed some other way as well.

## Related

- [Classic gallery](classic_gallery.md) — the uniform wall, and when it is right.
- [Side gallery](side_gallery.md) — one at a time, with the rest beside it.
- [AstryxAspectRatio](aspect_ratio.md) — the box, the ground and the clip.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Mixed gallery`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Mixed+gallery&component=Mixed+gallery) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Mixed+gallery&area=Mixed+gallery) — both templates arrive with the component filled in.
