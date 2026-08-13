---
title: AstryxOverlay
description: The scrim-and-layer primitive the modals are built on.
component: true
group: Overlays
source: lib/src/components/overlay/overlay_layer.dart
upstream: Overlay
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class OverlayDemoExample extends StatefulWidget {
  const OverlayDemoExample({super.key});

  @override
  State<OverlayDemoExample> createState() => _OverlayDemoExampleState();
}

class _OverlayDemoExampleState extends State<OverlayDemoExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The modal contract with nothing on top of it: scrim, focus trap, Escape,
    // barrier dismissal. What sits on the layer is entirely yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Open preview', onPressed: _controller.show),
        AstryxOverlay(
          controller: _controller,
          label: 'Preview',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'atlas-scheduler.png',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxSkeleton(height: 120),
                AstryxButton(label: 'Close', onPressed: _controller.hide),
              ],
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
AstryxOverlay(
  controller: _lightbox,
  label: 'Preview',
  child: AstryxCard(child: Image.network(url)),
)
```

The modal contract with **no opinion about what is on the layer**. [AstryxDialog](dialog.md) is this widget plus a header, a scrolling body and a footer; [AstryxAlertDialog](alert_dialog.md) is that plus the answers. Reach for this one directly when that shape is wrong — a lightbox, a command palette, a sheet.

## What it guarantees

- A scrim that dims the page and closes on a press.
- Focus trapped inside while open, and **restored to whatever opened it**.
- Escape closes it — and only it, never the layer beneath.
- An entry and exit that honour reduced motion.

Like every overlay here it is a **widget in the tree**, not a `showDialog` call: it renders nothing until its controller opens it, so it can sit next to whatever opens it and there is no `BuildContext` to smuggle across an async gap.

## Placement

`alignment` puts the layer anywhere in the viewport. A sheet is an overlay aligned to the bottom edge, not a separate component.

```dart
class OverlayPlacementExample extends StatefulWidget {
  const OverlayPlacementExample({super.key});

  @override
  State<OverlayPlacementExample> createState() =>
      _OverlayPlacementExampleState();
}

class _OverlayPlacementExampleState extends State<OverlayPlacementExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `alignment` puts the layer anywhere in the viewport: bottom-centre is a
    // sheet, top-centre is a command palette, centre is a dialog.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Open sheet', onPressed: _controller.show),
        AstryxOverlay(
          controller: _controller,
          label: 'Filters',
          alignment: Alignment.bottomCenter,
          transition: AstryxOverlayTransition.fade,
          child: AstryxCard(
            width: 360,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Filters',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'A sheet is an overlay aligned to the bottom edge — not a '
                  'separate component.',
                ),
                AstryxButton(label: 'Apply', onPressed: _controller.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```


## Composition

```text
AstryxOverlay
├── scrim        ← dims the page. Presses dismiss unless told otherwise
└── child        ← positioned by `alignment`, inside `padding`
    └── focus trap, and the semantics that make the page behind it inert
```

> **Note**
>
> Turning `showScrim` off leaves focus trapped unless `trapFocus` is off too. A layer that looks non-modal while behaving modally is worse than either one on its own.

> **Accessibility**
>
> `scopesRoute` is what tells a screen reader the rest of the page is inert, and `label` is what names the layer. Set `scopesRoute: false` for something merely floating — announcing a page as unavailable when it is not is worse than saying nothing.

### AstryxOverlay

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxOverlayController` | — | The open/closed state. |
| `child` *(required)* | `Widget` | — | What sits on the layer. |
| `alignment` | `AlignmentGeometry` | `Alignment.center` | Where the child sits in the viewport. |
| `padding` | `EdgeInsetsGeometry?` | `--spacing-4` | The inset from the viewport edge. |
| `showScrim` | `bool` | `true` | Whether to dim the page behind it. |
| `scrimColor` | `AstryxColorToken?` | `AstryxColorToken.overlay` | The scrim’s colour. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the scrim closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `trapFocus` | `bool` | `true` | Whether focus is trapped inside while open. |
| `restoreFocus` | `bool` | `true` | Whether focus returns to whatever opened it. |
| `transition` | `AstryxOverlayTransition` | `AstryxOverlayTransition.scale` | How it enters and leaves. `slide` has no anchor here and fades. |
| `duration` | `AstryxDurationToken` | `AstryxDurationToken.mediumMax` | How long the entry and exit take. |
| `label` | `String?` | — | The layer’s accessible name. |
| `scopesRoute` | `bool` | `true` | Whether the page behind it is announced as inert. |
| `onDismiss` | `VoidCallback?` | — | Called when the layer dismisses itself. |


## Related

- [AstryxDialog](dialog.md) — this, with a panel.
- [AstryxAlertDialog](alert_dialog.md) — that, with the answers.

---

Something wrong with `AstryxOverlay`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxOverlay&component=AstryxOverlay) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxOverlay&area=AstryxOverlay) — both templates arrive with the component filled in.
