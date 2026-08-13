---
title: Illustrations
description: The upstream illustration set, and what a Flutter port would need to carry it.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

> **Careful**
>
> No illustrations ship with `astryx_ui`, and none are planned. This page is the reasoning, and the composition to use instead.

Upstream ships an illustration set for the places a screen has nothing to show — empty states, first runs, errors, permission walls. It is artwork rather than a component: SVG assets that ship with the library and pick up the theme’s colours.

## Why it is not here

- **The package renders no assets.** Its only runtime dependencies are `collection`, `meta` and an icon font. Illustrations mean SVG, and SVG in Flutter means `flutter_svg` or `vector_graphics` — a real dependency for every consumer, most of whom would never draw one.
- **The artwork is Meta’s.** The token engine is a reimplementation from documented behaviour and a test suite; an illustration set is not something a port can reimplement. Carrying the files is a licensing question, not an engineering one.
- **A design system can stop short of art.** Everything else here is behaviour — layout, contrast, focus, keyboard. Illustration is the one part a product is usually happier owning.

## An empty state today

The composition upstream illustrates is already available: [AstryxCenter](../components/center.md) with a `minHeight`, an icon or your own asset, a heading, a supporting line, and one action. The [centred hero](../components/centered_hero.md) template is the same shape with copy instead of artwork.

```dart
AstryxCenter(
  minHeight: 320,
  child: AstryxVStack(
    gap: AstryxSpacingToken.spacing3,
    align: AstryxStackAlign.center,
    children: <Widget>[
      const AstryxIcon(AstryxIconName.funnel, size: AstryxIconSize.lg),
      const AstryxHeading('No matching runs', level: 3),
      const AstryxText(
        'Try widening the date range, or clear the filters.',
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      AstryxButton(label: 'Clear filters', onPressed: clear),
    ],
  ),
)
```

For real artwork, add `flutter_svg` to *your* application and put the asset where the icon is above. Colour it from a token — `AstryxTheme.of(context).color(AstryxColorToken.iconSecondary)` — and it will follow every theme and both brightnesses like everything else on the screen.

> **Accessibility**
>
> An illustration is decoration. Wrap it in `ExcludeSemantics` and let the heading beneath it carry the meaning — an empty state announced as "image" is worse than one announced as nothing at all.

## Related

- [AstryxCenter](../components/center.md) — the empty-state box.
- [Centred hero](../components/centered_hero.md) — the same shape, as a template.
- [Icons](icons.md) — what does ship, and how to swap it.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Illustrations&component=Docs%3A+Illustrations) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Illustrations&area=Docs%3A+Illustrations) — both templates arrive with the page filled in.
