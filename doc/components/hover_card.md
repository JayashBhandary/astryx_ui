---
title: AstryxHoverCard
description: A rich preview on hover, that stays open when you reach it.
component: true
group: Overlays
source: lib/src/components/overlay/hover_card.dart
upstream: HoverCard / useHoverCard
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HoverCardDemoExample extends StatelessWidget {
  const HoverCardDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Hover the mention. The card stays open while the pointer is on it, so
    // what is inside can be read, selected and pressed.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        const AstryxText('Assigned to'),
        AstryxHoverCard(
          label: 'Ada Lovelace',
          content: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const AstryxHeading(
                'Ada Lovelace',
                type: AstryxHeadingType.display3,
              ),
              const AstryxText(
                'Platform team · Cambridge',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              const AstryxText('Owns the scheduler and the retry engine.'),
              AstryxButton(label: 'View profile', onPressed: () {}),
            ],
          ),
          child: const AstryxText('@ada', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxHoverCard(
  label: 'Ada Lovelace',
  content: const UserSummary(),
  child: const AstryxText('@ada'),
)
```

A `child`, not a builder — like a tooltip and unlike a popover. It opens on hover rather than on a press, so it never competes for the tap, and the trigger stays whatever it already was: a link, a mention, an avatar.

## Why it is not a tooltip

The card **survives the pointer arriving on it**. That single behaviour is the component: it is what lets the content hold a button, a link, or text worth selecting, none of which a tooltip can do because a tooltip disappears the moment you reach for it.

|   | Tooltip | Hover card | Popover |
| --- | --- | --- | --- |
| Opens on | hover, focus, long-press | the same | a press |
| Content | one phrase | a panel | a panel |
| Interactive | no | yes | yes |
| Traps focus | no | no | yes, by default |

## Timing

`waitDuration` filters a mouse on its way somewhere else — longer than a tooltip’s, because a panel under every passing pointer makes a page feel booby-trapped. `exitDuration` is the grace period for crossing the gap from the trigger onto the card; set it to zero and it becomes unreachable.

```dart
class HoverCardTimingExample extends StatelessWidget {
  const HoverCardTimingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The wait filters a mouse on its way somewhere else; the exit duration is
    // the grace period for crossing the gap onto the card. Zero exit makes the
    // card unreachable, which is why it is not the default.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing5,
      children: <Widget>[
        AstryxHoverCard(
          waitDuration: Duration.zero,
          content: AstryxText('No wait at all.'),
          child: AstryxText('Instant', color: AstryxTextColor.accent),
        ),
        AstryxHoverCard(
          waitDuration: Duration(milliseconds: 700),
          content: AstryxText('Opens only for a pointer that settles.'),
          child: AstryxText('Patient', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
```


## Positioning

The same positioner as every other anchored overlay: it flips, shifts and shrinks to stay on screen.

| Property | Does |
| --- | --- |
| `side` | The **preferred** side. The positioner flips to the opposite one when there is no room. |
| `align` | Alignment along the anchor’s edge: `start`, `center` or `end`. The overlay shifts along that edge to stay on screen. |

```dart
class HoverCardSidesExample extends StatelessWidget {
  const HoverCardSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Same positioner as every other anchored overlay: the preferred side is a
    // preference, and it flips near an edge.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing5,
      children: <Widget>[
        AstryxHoverCard(
          side: AstryxOverlaySide.top,
          width: 220,
          showArrow: true,
          content: AstryxText('Above, with an arrow.'),
          child: AstryxText('Top', color: AstryxTextColor.accent),
        ),
        AstryxHoverCard(
          side: AstryxOverlaySide.right,
          width: 220,
          content: AstryxText('Beside the trigger.'),
          child: AstryxText('Right', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
```


## Touch

A long-press opens it, and — because touch has no pointer-exit to close it with — the next press anywhere closes it again. That is the only path here that arms a barrier.

> **Careful**
>
> Nothing may live **only** in a hover card. It needs a pointer or a deliberate long-press, it is gone as soon as attention moves, and a screen-reader user meets it only if they happen to focus the trigger. Treat it as a shortcut to something reachable by going there.

> **Accessibility**
>
> Focus on the trigger opens the card immediately, with no wait — the delay exists to filter passing pointers, and a keyboard user did not pass through by accident. Focus is never trapped: the page behind it is still live.

### AstryxHoverCard

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The trigger. |
| `content` *(required)* | `Widget` | — | The card’s content. |
| `controller` | `AstryxOverlayController?` | — | Drives the card from outside. Null makes it uncontrolled. |
| `label` | `String?` | — | An accessible name for the card. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.start` | Alignment along the trigger’s edge. |
| `width` | `double?` | `300` | The card’s width. Null sizes to the content. |
| `waitDuration` | `Duration` | `Duration(milliseconds: 300)` | How long a pointer must rest on the trigger first. |
| `exitDuration` | `Duration` | `Duration(milliseconds: 200)` | The grace period after the pointer leaves both the trigger and the card. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `enabled` | `bool` | `true` | Whether the card responds at all. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the card opens or closes. |


## Related

- [AstryxTooltip](tooltip.md) — for a phrase, not a panel.
- [AstryxPopover](popover.md) — when a press should open it and keep it open.

---

Something wrong with `AstryxHoverCard`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxHoverCard&component=AstryxHoverCard) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxHoverCard&area=AstryxHoverCard) — both templates arrive with the component filled in.
