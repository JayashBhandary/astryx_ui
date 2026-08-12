---
title: AstryxAspectRatio
description: A box that keeps its width-to-height ratio as it resizes.
component: true
group: Media
source: lib/src/components/media/aspect_ratio.dart
upstream: AspectRatio
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class AspectRatioDemoExample extends StatelessWidget {
  const AspectRatioDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // With nothing in it the box is a placeholder: the right shape in the
    // right colour reads as the picture arriving, where a hole reads as a bug.
    return AstryxGrid(
      minWidth: 160,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final entry in <({String label, double ratio})>[
          (label: '16 / 9', ratio: 16 / 9),
          (label: '1', ratio: 1),
          (label: '4 / 3', ratio: 4 / 3),
        ])
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxAspectRatio(ratio: entry.ratio, showBorder: true),
              AstryxText(
                entry.label,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxAspectRatio(
  ratio: 16 / 9,
  child: Image.network(url, fit: BoxFit.cover),
)
```

> **Note**
>
> Flutter already has `AspectRatio` and this does not replace it. What it adds is the **radius, the ground and the clip** from the token layer — the part every media surface in a design system has to agree about. Use Flutter’s directly when none of that applies.

## The ground is a placeholder

It matters more than it looks. An image that has not loaded yet leaves a hole, and a hole in the middle of a page reads as a **bug** rather than as a wait; a tinted box of the right shape reads as the picture arriving. That is why the ground has a token and not a null.

`showBorder` is worth turning on over a photograph that might be nearly the page’s own colour at its edges — without it the frame ends nowhere in particular.

### AstryxAspectRatio

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `ratio` *(required)* | `double` | — | Width divided by height. `16 / 9`, `1`, `4 / 3`. |
| `child` | `Widget?` | — | What fills the box. Null leaves the ground. |
| `radius` | `AstryxRadiusToken` | `AstryxRadiusToken.container` | The corner radius. |
| `background` | `AstryxColorToken` | `AstryxColorToken.backgroundMuted` | The ground behind the child. |
| `showBorder` | `bool` | `false` | Whether to draw a hairline border. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Null leaves whatever the child says — and an `Image` with no `semanticLabel` says nothing at all, which is right for decoration and wrong for a diagram. |


## Related

- [AstryxThumbnail](thumbnail.md) — this with a picture and a name.
- [AstryxSkeleton](skeleton.md) — a placeholder for a wait whose shape is known but whose ratio is not.

