---
title: Side gallery
description: A gallery with the selected item beside the strip.
component: true
group: Templates
source: example/lib/examples/template_media_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SideGalleryTemplate extends StatefulWidget {
  const SideGalleryTemplate({super.key});

  @override
  State<SideGalleryTemplate> createState() => _SideGalleryTemplateState();
}

class _SideGalleryTemplateState extends State<SideGalleryTemplate> {
  static const List<Shot> _shots = <Shot>[
    (
      name: 'Latency, p95',
      caption: 'Captured 14:02 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Queue depth',
      caption: 'Captured 14:03 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Retries per minute',
      caption: 'Captured 14:06 · scheduler-b',
      ratio: 16 / 9,
    ),
    (
      name: 'Error budget burn',
      caption: 'Captured 14:11 · platform',
      ratio: 16 / 9,
    ),
  ];

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final shot = _shots[_index];

    // One item at a time, with the rest reachable without leaving the screen.
    // This is the shape to reach for when the pictures are *evidence* — the
    // reader is comparing them against each other rather than browsing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(
              child: AstryxHeading('Incident 4102 · evidence', level: 1),
            ),
            AstryxText(
              '${_index + 1} of ${_shots.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final strip = _Strip(
              shots: _shots,
              index: _index,
              vertical: wide,
              onSelected: (index) => setState(() => _index = index),
            );

            final viewer = _Viewer(shot: shot);

            // The strip runs down the trailing edge when there is room for it
            // and across the bottom when there is not. Same widget, same
            // selection — only the axis moves.
            if (!wide) {
              return AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[viewer, strip],
              );
            }

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: viewer),
                SizedBox(width: 132, child: strip),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// The item being looked at, and what is known about it.
class _Viewer extends StatelessWidget {
  const _Viewer({required this.shot});

  final Shot shot;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(shot.name, type: AstryxTextType.label),
          AstryxText(
            shot.caption,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
      child: AstryxAspectRatio(
        ratio: shot.ratio,
        semanticsLabel: shot.name,
        child: Center(
          child: AstryxText(shot.name, color: AstryxTextColor.secondary),
        ),
      ),
    );
  }
}

/// The strip of everything else, in whichever axis fits.
class _Strip extends StatelessWidget {
  const _Strip({
    required this.shots,
    required this.index,
    required this.vertical,
    required this.onSelected,
  });

  final List<Shot> shots;
  final int index;
  final bool vertical;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (var i = 0; i < shots.length; i++)
        // `selected` is what marks the current one, and the thumbnail draws it
        // as a ring rather than a tint — a tint over a picture is a change to
        // the picture.
        AstryxThumbnail(
          label: shots[i].name,
          icon: AstryxIconName.viewColumns,
          ratio: 16 / 9,
          width: vertical ? 116 : 104,
          selected: i == index,
          onPressed: () => onSelected(i),
        ),
    ];

    if (vertical) {
      return AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: tiles,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: tiles,
      ),
    );
  }
}
```

Narrow the window past 640: the strip moves from the trailing edge to under the picture, and the selection is untouched.


## For comparing, not for browsing

A wall is for finding one item among many. This is for going back and forth between four — which is what "evidence" means on an incident, and why the item on screen never leaves it. An [AstryxLightbox](lightbox.md) would be wrong here: a modal that has to be closed between comparisons is a modal the reader stops using.

```text
LayoutBuilder
├── wide   → AstryxHStack ── Expanded  → the viewer
│                         └── SizedBox(132) → the strip, vertical
└── narrow → AstryxVStack ── the viewer, then the strip, horizontal
```

One widget, one selection, and only the axis moves. The breakpoint is a `LayoutBuilder` and one constant — the width at which a picture and a strip stop both fitting is a fact about this screen, not an entry in a table every other screen has to agree with.

## The strip is thumbnails, and `selected` is the mark

[AstryxThumbnail](thumbnail.md) draws the current one as a ring rather than a tint, and that is not a style choice: a tint over a picture is a change to the picture, and on a screen whose whole job is comparing pictures that is the one thing that must not happen.

```dart
AstryxThumbnail(
  label: shots[i].name,          // required — the accessible name
  ratio: 16 / 9,
  width: vertical ? 116 : 104,
  selected: i == index,          // ← a ring, not a tint
  onPressed: () => onSelected(i),
)
```

> **Accessibility**
>
> The count — "2 of 4" — is on the page in text, beside the heading. A reader who cannot see which thumbnail has the ring still needs to know where they are in the set, and a selected state alone does not say how many there are.

## Related

- [Mixed gallery](mixed_gallery.md) — everything at once, at its own size.
- [Product detail](product_detail.md) — the same shape, with a price beside it.
- [AstryxThumbnail](thumbnail.md) — the tile, the caption and the selected state.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Side gallery`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Side+gallery&component=Side+gallery) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Side+gallery&area=Side+gallery) — both templates arrive with the component filled in.
