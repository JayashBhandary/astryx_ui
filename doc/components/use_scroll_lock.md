---
title: AstryxScrollLock
description: Freezing the page behind a modal.
component: true
group: Hooks & controllers
source: lib/src/foundation/scroll_lock.dart
upstream: useScrollLock
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookScrollLockExample extends StatefulWidget {
  const HookScrollLockExample({super.key});

  @override
  State<HookScrollLockExample> createState() => _HookScrollLockExampleState();
}

class _HookScrollLockExampleState extends State<HookScrollLockExample> {
  final AstryxOverlayController _modal = AstryxOverlayController();

  @override
  void dispose() {
    _modal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Open the panel, then try to scroll the list behind it. Locked, it does
    // not move — a scrim blocks presses, and a wheel is not a press.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxButton(label: 'Open the panel', onPressed: _modal.show),
        AstryxOverlay(
          controller: _modal,
          label: 'Panel',
          child: AstryxCard(
            width: 280,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxText('Now try to scroll the list behind this.'),
                AstryxButton(label: 'Close', onPressed: _modal.hide),
              ],
            ),
          ),
        ),
        AstryxScrollLock.whileModalIsOpen(
          child: AstryxCard(
            padding: AstryxSpacingToken.spacing0,
            // Bounded here rather than around the card: a card lays its body
            // out in a column, and a column hands its child unbounded height.
            child: SizedBox(
              height: 160,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  for (var i = 1; i <= 20; i++) AstryxItem(label: 'Row $i'),
                ],
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
AstryxScrollLock.whileModalIsOpen(
  child: AstryxAppShell(child: page),
)
```

One of those, once, near the root is the whole setup. **It is not wired in by default**, because the lock belongs to the scrollable a product wants frozen and this package cannot know which that is.

## Why it is needed

An overlay’s scrim blocks *presses* on the page behind it, and a wheel or a trackpad is not a press. Without a lock the content behind an open dialog still scrolls under the pointer, which reads as the modal having failed to take over.

Upstream sets `overflow: hidden` on the document. There is no document here and no global scroll to freeze, so the lock is a **scope**: it wraps the page and the page stops scrolling, while the modal above it — in its own overlay, outside that subtree — scrolls normally.

## What counts as a modal

`whileModalIsOpen` reads `AstryxOverlayStack.modalLayers`, the same registry Escape consults. A layer counts as modal when it **dims the page** — a dialog, an alert dialog, the shell’s navigation drawer. A popover, a dropdown menu, a context menu and a tooltip do not: those are not claims that the page is inert, and freezing a page because a tooltip appeared would be a bug with a very confusing report.

> **Careful**
>
> **A locked subtree takes no pointer events at all**, not merely no scrolls. Blocking the pointer is the only thing that reliably stops a wheel: a page-level `ListView` with no controller is `primary: true`, and `ScrollView` wraps the ambient physics in `AlwaysScrollableScrollPhysics` for that case — which overrules anything handed down through `ScrollConfiguration`. Behind a modal that costs nothing, because the scrim was already swallowing presses. Do not lock something that has to stay clickable.

The physics override is applied as well as the pointer block, for the scrollables that do honour it and for the keyboard — `Space` and the arrow keys scroll a focused scroller with no pointer involved at all.

### AstryxScrollLock

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `locked` *(required)* | `bool` | — | Whether the subtree is frozen. The manual form. |
| `child` *(required)* | `Widget` | — | The subtree to freeze. |
| `AstryxScrollLock.whileModalIsOpen({child})` | `constructor` | — | Freezes whenever a modal layer is open, with nothing to wire up. |


### AstryxOverlayStack

The two counters this reads. Listen to them directly for anything else that should know a modal is up — pausing a poll, or a video.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `openLayers` | `ValueListenable<int>` | — | How many dismissible layers are open. |
| `modalLayers` | `ValueListenable<int>` | — | How many of those dim the page — what the automatic lock listens to. |


## Related

- [The overlay layer](layer_provider.md) — the stack these counters come from.
- [AstryxFocusTrap](use_focus_trap.md) — the other half of taking over a page.
- [AstryxDialog](dialog.md) — the layer this is usually locking behind.

---

Something wrong with `AstryxScrollLock`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxScrollLock&component=AstryxScrollLock) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxScrollLock&area=AstryxScrollLock) — both templates arrive with the component filled in.
