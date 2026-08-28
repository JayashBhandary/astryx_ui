---
title: AstryxBottomSheet
description: A modal panel that rises from the bottom edge of the viewport.
component: true
group: Overlays
source: lib/src/components/overlay/bottom_sheet.dart
upstream: BottomSheet
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BottomSheetDemoExample extends StatefulWidget {
  const BottomSheetDemoExample({super.key});

  @override
  State<BottomSheetDemoExample> createState() => _BottomSheetDemoExampleState();
}

class _BottomSheetDemoExampleState extends State<BottomSheetDemoExample> {
  final AstryxBottomSheetController _sheet = AstryxBottomSheetController();

  @override
  void dispose() {
    _sheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Like every overlay here the sheet is a widget in the tree, not a
    // `showModalBottomSheet` call: it renders nothing until its controller
    // opens it, so it sits next to whatever opens it.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Filters', onPressed: _sheet.show),
        AstryxBottomSheet(
          controller: _sheet,
          label: 'Filters',
          height: AstryxBottomSheetHeight.hug,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxHeading('Filters', type: AstryxHeadingType.display3),
              AstryxCheckbox(
                label: 'Only my issues',
                value: true,
                onChanged: (_) {},
              ),
              AstryxCheckbox(
                label: 'Include closed',
                value: false,
                onChanged: (_) {},
              ),
              AstryxButton(label: 'Apply', onPressed: _sheet.hide),
            ],
          ),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxBottomSheet(
  controller: _sheet,
  label: 'Filters',
  height: AstryxBottomSheetHeight.hug,
  child: const FilterForm(),
)
```

The same modal contract as [AstryxDialog](dialog.md) — trapped focus, Escape, a scrim that dims and dismisses, focus handed back to whatever opened it — anchored to an edge rather than centred, and draggable.

**Reach for a sheet on a touch screen.** It puts its content and its actions inside the thumb’s reach, which is the whole reason it exists; a dialog centred in a tall phone window puts them where the hand is not. On a desktop window `AstryxDialog` remains the right shape, and the sheet stops growing at 640px rather than becoming a very wide strip stuck to the bottom of the screen.

Like every overlay here it is a **widget in the tree**, not a `showModalBottomSheet` call: it renders nothing until its controller opens it, so it sits next to whatever opens it and there is no `BuildContext` to smuggle across an async gap.

## Height

`hug` sizes to its content, up to 92% of the viewport — the budget for a share menu, three actions, a confirmation. `capped` takes 62% whatever is in it, which leaves enough of the page visible behind the scrim to keep the sheet reading as a layer over something rather than as a new screen. `tall` takes 92%: a working surface, with the page a sliver above it.

```dart
class BottomSheetHeightsExample extends StatefulWidget {
  const BottomSheetHeightsExample({super.key});

  @override
  State<BottomSheetHeightsExample> createState() =>
      _BottomSheetHeightsExampleState();
}

class _BottomSheetHeightsExampleState extends State<BottomSheetHeightsExample> {
  final Map<AstryxBottomSheetHeight, AstryxBottomSheetController> _sheets = {
    for (final height in AstryxBottomSheetHeight.values)
      height: AstryxBottomSheetController(),
  };

  @override
  void dispose() {
    for (final controller in _sheets.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `hug` sizes to its content, `capped` takes 62% of the viewport whatever
    // is in it, and `tall` takes 92% — a working surface with the page a
    // sliver above it.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final MapEntry(key: height, value: controller) in _sheets.entries)
          AstryxHStack(
            children: <Widget>[
              AstryxButton(
                label: height.name,
                variant: AstryxButtonVariant.secondary,
                onPressed: controller.show,
              ),
              AstryxBottomSheet(
                controller: controller,
                label: '${height.name} sheet',
                height: height,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing3,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxHeading(
                      height.name,
                      type: AstryxHeadingType.display3,
                    ),
                    const AstryxText(
                      'Two lines of content, so the three budgets can be told '
                      'apart by what they do with the space rather than by '
                      'how much of it they fill.',
                    ),
                    AstryxButton(label: 'Close', onPressed: controller.hide),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


## Snap points

`snapPoints` gives the sheet more than one resting height, each a fraction of the viewport, and dragging the handle moves between them. Dragging below the shortest one dismisses the sheet unless `dragDismissible` is false. Values outside `(0, 1]` are dropped rather than thrown for — a snap point of `50` is a mistake, and a sheet that threw for it would take the screen down with it.

```dart
class BottomSheetSnapExample extends StatefulWidget {
  const BottomSheetSnapExample({super.key});

  @override
  State<BottomSheetSnapExample> createState() => _BottomSheetSnapExampleState();
}

class _BottomSheetSnapExampleState extends State<BottomSheetSnapExample> {
  final AstryxBottomSheetController _sheet = AstryxBottomSheetController();

  @override
  void dispose() {
    _sheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two detents: a third of the screen and most of it. Drag the handle to
    // move between them. Nothing lives behind a detent that the sheet does not
    // also reach by scrolling — a stop is a convenience, never the only way to
    // something.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Nearby stops', onPressed: _sheet.show),
        AstryxBottomSheet(
          controller: _sheet,
          label: 'Nearby stops',
          snapPoints: const <double>[0.33, 0.85],
          initialSnapPoint: 0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxHeading(
                'Nearby stops',
                type: AstryxHeadingType.display3,
              ),
              for (var i = 1; i <= 8; i++)
                AstryxItem(
                  label: 'Platform $i',
                  description: '${i * 2} minutes away',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> A detent is a **convenience, never the only way to something**: a sheet with snap points still has to work for someone who cannot drag, so put nothing behind a stop that the sheet does not also reach by scrolling. The handle is a drag target and is named as one; `label` is required because a sheet has no header of its own to derive a name from.

> **Note**
>
> The sheet travels up from the edge it is anchored to, rather than fading in as the other viewport overlays do: fading one in leaves no trace of where it came from, which is the one thing its shape is meant to say. Under reduced motion neither runs.

### AstryxBottomSheet

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxBottomSheetController` | — | The open/closed state. |
| `label` *(required)* | `String` | — | The sheet’s accessible name. Required — a sheet has no header to derive one from. |
| `child` *(required)* | `Widget` | — | The body. Scrolls when it is taller than the sheet. |
| `height` | `AstryxBottomSheetHeight` | `AstryxBottomSheetHeight.capped` | How much of the viewport the sheet may occupy: `hug`, `capped` or `tall`. |
| `snapPoints` | `List<double>` | `const <double>[]` | Extra resting heights, each a fraction of the viewport in `(0, 1]`. |
| `initialSnapPoint` | `int?` | — | Which snap point the sheet opens at. Null opens at the tallest. |
| `showScrim` | `bool` | `true` | Whether to dim the page behind the sheet. |
| `showHandle` | `bool` | `true` | Whether to draw the grab handle. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the scrim closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `dragDismissible` | `bool` | `true` | Whether dragging the sheet down past its shortest height closes it. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The inset between the sheet’s edges and its content. |
| `onDismiss` | `VoidCallback?` | — | Called when the sheet dismisses itself. |


---

Something wrong with `AstryxBottomSheet`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxBottomSheet&component=AstryxBottomSheet) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxBottomSheet&area=AstryxBottomSheet) — both templates arrive with the component filled in.
