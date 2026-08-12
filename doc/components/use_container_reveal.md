---
title: AstryxContainerReveal
description: Revealing content as its container scrolls into view.
component: true
group: Hooks & controllers
source: lib/src/foundation/entry_animation.dart
upstream: useContainerReveal
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookContainerRevealExample extends StatelessWidget {
  const HookContainerRevealExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Scroll the panel. Each card is laid out from the start — so the scrollbar
    // does not lie about the length — and painted as it comes into view.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      // Bounded inside the card: a card lays its body out in a column, and a
      // column hands its child unbounded height — which a scroller reads as
      // "no need to scroll".
      child: SizedBox(
        height: 220,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (var i = 1; i <= 8; i++)
                AstryxContainerReveal(
                  child: AstryxCard(
                    child: AstryxHStack(
                      gap: AstryxSpacingToken.spacing2,
                      children: <Widget>[
                        AstryxBadge('$i'),
                        const AstryxText('Revealed on the way in'),
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


## Usage

```dart
AstryxContainerReveal(
  transition: AstryxEntryTransition.fadeUp,
  child: AstryxCard(child: chart),
)
```

Upstream uses an `IntersectionObserver`. Flutter has none, so this watches the enclosing `Scrollable`’s position and compares its own bounds against the viewport’s — revealing once `fraction` of it is in view, and then **once only**.

## Laid out before it is revealed

A hidden child is still measured and still occupies its space. A reveal that changed the page height as it fired would move everything below it — including whatever the reader was reading — and would make the scrollbar lie about the length of the page.

> **Note**
>
> **With no enclosing scrollable it reveals immediately.** There is nothing to wait for, and content that never appears because a widget was looking for a viewport that does not exist is the worse failure by a wide margin.

## Measured after the frame

A scroll position notifies its listeners *before* the frame that moves anything, so measuring inside the callback reads the previous frame’s geometry — and a reveal that checks a position its child has already left never fires. The check is therefore posted to the end of the frame, coalesced to one per frame.

> **Careful**
>
> Reveal-on-scroll is a decoration, and a page of forty of them is forty listeners and forty rebuilds. Use it for a handful of substantial blocks — a chart, a section — not for every row of a table. It stops listening the moment it has fired, so the cost is bounded, but the cost of never adding it is zero.

### AstryxContainerReveal

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content revealed. |
| `transition` | `AstryxEntryTransition` | `AstryxEntryTransition.fadeUp` | How it enters once in view. |
| `fraction` | `double` | `0.1` | How much of the child must be in view before it reveals, 0 to 1. |
| `enabled` | `bool` | `true` | Whether to wait at all. False reveals on the first frame. |
| `onRevealed` | `VoidCallback?` | — | Called once, when the child is first revealed. |


## Related

- [AstryxEntryAnimation](use_entry_animation.md) — the entry this runs, and its transitions.
- [AstryxScrollOverflow](use_scroll_overflow.md) — the other thing worth knowing about a scroller.

