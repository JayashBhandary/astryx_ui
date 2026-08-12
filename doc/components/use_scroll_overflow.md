---
title: AstryxScrollOverflow
description: Knowing whether a scroller has content beyond either edge, for fading its edges.
component: true
group: Hooks & controllers
source: lib/src/foundation/scroll_overflow.dart
upstream: useScrollOverflow
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookScrollOverflowExample extends StatefulWidget {
  const HookScrollOverflowExample({super.key});

  @override
  State<HookScrollOverflowExample> createState() =>
      _HookScrollOverflowExampleState();
}

class _HookScrollOverflowExampleState extends State<HookScrollOverflowExample> {
  AstryxScrollEdges _edges = AstryxScrollEdges.none;

  @override
  Widget build(BuildContext context) {
    // Scroll the strip. The fade appears only on the side that has more, so it
    // is information rather than decoration — and it is never hit-testable, so
    // a chip underneath it stays pressable.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxScrollOverflow(
          onChanged: (edges) => setState(() => _edges = edges),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                for (final region in <String>[
                  'us-east-1',
                  'us-west-2',
                  'eu-west-1',
                  'eu-central-1',
                  'ap-south-1',
                  'ap-northeast-1',
                  'sa-east-1',
                ])
                  AstryxBadge(region),
              ],
            ),
          ),
        ),
        AstryxText(
          _edges.overflows
              ? 'More at the start: ${_edges.hasMoreAtStart} · '
                    'more at the end: ${_edges.hasMoreAtEnd}'
              : 'Everything fits',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxScrollOverflow(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: chips),
  ),
)
```

A clipped edge with nothing at it looks like the end of the content, and a user who cannot tell the difference stops scrolling. So a scroller wider than its box has to **say** there is more.

It listens to scroll notifications rather than owning a controller, so it works over any scrollable — one you built, one a component built, one nested three widgets down — without being handed anything.

## What it reports

| `AstryxScrollEdges` | Means |
| --- | --- |
| `overflows` | The content is longer than the viewport at all. False makes the other two meaningless — a scroller with nothing to scroll is at both ends at once. |
| `atStart` / `atEnd` | Resting against that edge. |
| `hasMoreAtStart` / `hasMoreAtEnd` | The pair a fade or an arrow keys off: overflowing **and** not at that edge. |

Start and end are logical, so under a right-to-left `Directionality` the start edge of a horizontal strip is the right one — and the gradient runs the right way without this widget being told which way that is.

## Your own affordance

Fades are the default because they cost nothing and read as depth. Pass `builder` for something a fade cannot say — a pair of arrow buttons, a "+3 more" count, a shadow:

```dart
AstryxScrollOverflow(
  fade: false,
  builder: (context, edges, child) => AstryxHStack(
    children: <Widget>[
      AstryxIconButton(
        icon: AstryxIconName.chevronLeft,
        label: 'Scroll back',
        enabled: edges.hasMoreAtStart,
        onPressed: _back,
      ),
      Expanded(child: child),
      AstryxIconButton(
        icon: AstryxIconName.chevronRight,
        label: 'Scroll on',
        enabled: edges.hasMoreAtEnd,
        onPressed: _on,
      ),
    ],
  ),
  child: strip,
)
```

> **Accessibility**
>
> A fade is decoration: it is not announced, and it is not reachable without sight or a pointer. It must never be the *only* way to reach what is past the edge — the content behind it stays in the semantics tree and stays reachable by keyboard, which is what makes the fade an extra rather than a gate. The fades never hit-test, so a control under one is still pressable.

> **Note**
>
> `AstryxTabList` does this for its own strip. Its copy predates this primitive and behaves identically; the two are worth merging, and until they are, this is the one to reach for in your own code.

### AstryxScrollOverflow

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The scrollable, or anything containing one. |
| `axis` | `Axis` | `Axis.horizontal` | Which axis to watch. A notification from the other axis is ignored, so a horizontal strip inside a scrolling page reports only its own edges. |
| `fade` | `bool` | `true` | Whether to draw a gradient at an edge with more past it. |
| `fadeExtent` | `double` | `24` | How wide a fade is. |
| `fadeColor` | `AstryxColorToken?` | — | What a fade resolves to. It has to match what is *behind* the scroller, so a strip on a card wants `backgroundCard`. |
| `builder` | `Widget Function(context, edges, child)?` | — | Wraps the child once the edges are known. |
| `onChanged` | `ValueChanged<AstryxScrollEdges>?` | — | Called whenever the edges change. |


## Related

- [AstryxTabList](tab_list.md) — a strip that scrolls and fades.
- [useOverflow](use_overflow.md) — when the tail should move into a menu instead of scrolling.

