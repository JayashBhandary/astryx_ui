---
title: AstryxCarousel
description: A horizontally paged strip of items, with the controls and keyboard traversal.
component: true
group: Media
source: lib/src/components/media/carousel.dart
upstream: Carousel
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CarouselDemoExample extends StatelessWidget {
  const CarouselDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tab onto the strip and use the arrows — one tab stop for the whole set.
    // There is no autoplay, and there is no way to ask for one.
    return AstryxCarousel(
      label: 'Screenshots',
      height: 180,
      items: <Widget>[
        for (var i = 1; i <= 5; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AstryxAspectRatio(
              ratio: 16 / 9,
              showBorder: true,
              child: Center(
                child: AstryxText(
                  'Screenshot $i',
                  color: AstryxTextColor.secondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxCarousel(
  label: 'Screenshots',
  items: <Widget>[
    for (final shot in shots) AstryxAspectRatio(ratio: 16 / 9, child: shot),
  ],
)
```

## There is no autoplay

> **Careful**
>
> **And there is no way to ask for one.** Content that moves on its own for more than five seconds has to be pausable (WCAG 2.2.1); it takes the thing a reader was looking at away mid-sentence; and the pause control is invariably the least obvious thing on the screen. If a set of items deserves attention on its own schedule, it deserves a page rather than a timer.

## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the strip, and off it. **One stop.** |
| `←` / `→` | One item. Mirrored under RTL. |
| `Home` / `End` | The first and last item. |

One tab stop for the whole strip: a carousel of forty screenshots is otherwise forty presses to walk past. The controls stay drawn and **disable at the ends** rather than disappearing, because a control that vanishes moves the one beside it.

`viewportFraction` below one leaves the next item peeking in — the only reliable way to say "there is more this way" on a touch device with no hover and no visible controls.

> **Accessibility**
>
> The position is the container’s **value**, so a reader landing on the strip is told "Item 3 of 8" before anything else. The same string is drawn beside the controls, because a sighted keyboard user needs it too and a scrollbar does not say it.

### AstryxCarousel

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `items` *(required)* | `List<Widget>` | — | The items, in order. |
| `label` | `String?` | — | What the strip is. |
| `initialIndex` | `int` | `0` | Which item to open on. |
| `onIndexChanged` | `ValueChanged<int>?` | — | Called with the item now showing. |
| `showControls` | `bool` | `true` | Whether to draw the previous and next controls. |
| `showPosition` | `bool` | `true` | Whether to draw the "3 of 8" readout. |
| `height` | `double?` | — | A fixed height for the strip. |
| `viewportFraction` | `double` | `1` | How much of the viewport one item takes. |
| `focusNode` | `FocusNode?` | — | The strip’s focus node. |


## Related

- [AstryxLightbox](lightbox.md) — for looking at one item properly.
- [AstryxTabList](tab_list.md) — when the items are alternatives rather than a sequence.
- [AstryxScrollOverflow](use_scroll_overflow.md) — for a strip that scrolls freely rather than paging.

---

Something wrong with `AstryxCarousel`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCarousel&component=AstryxCarousel) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCarousel&area=AstryxCarousel) — both templates arrive with the component filled in.
