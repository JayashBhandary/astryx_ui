---
title: AstryxBottomSheetSwitcher
description: A flow of bottom sheets sharing one scrim.
component: true
group: Overlays
source: lib/src/components/overlay/bottom_sheet_switcher.dart
upstream: BottomSheetSwitcher
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BottomSheetSwitcherExample extends StatefulWidget {
  const BottomSheetSwitcherExample({super.key});

  @override
  State<BottomSheetSwitcherExample> createState() =>
      _BottomSheetSwitcherExampleState();
}

class _BottomSheetSwitcherExampleState
    extends State<BottomSheetSwitcherExample> {
  String? _step;

  void _go(String? id) => setState(() => _step = id);

  @override
  Widget build(BuildContext context) {
    // Three sheets, one scrim. Opening and closing three separate sheets in
    // turn would dim the page, undim it and dim it again — three
    // interruptions where the user performed one task.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Check out', onPressed: () => _go('method')),
        AstryxBottomSheetSwitcher(
          activeSheetId: _step,
          onActiveSheetChanged: _go,
          sheets: <AstryxBottomSheetPage>[
            AstryxBottomSheetPage(
              id: 'method',
              label: 'Payment method',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxHeading(
                    'Payment method',
                    type: AstryxHeadingType.display3,
                  ),
                  AstryxItem(
                    label: 'Card ending 4242',
                    onPressed: () => _go('confirm'),
                  ),
                  AstryxItem(
                    label: 'Pay on delivery',
                    onPressed: () => _go('confirm'),
                  ),
                ],
              ),
            ),
            AstryxBottomSheetPage(
              id: 'confirm',
              label: 'Confirm payment',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxHeading(
                    'Confirm payment',
                    type: AstryxHeadingType.display3,
                  ),
                  const AstryxText('£42.00 to Acme Supplies.'),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    justify: AstryxStackJustify.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AstryxButton(
                        label: 'Back',
                        variant: AstryxButtonVariant.secondary,
                        onPressed: () => _go('method'),
                      ),
                      AstryxButton(
                        label: 'Pay',
                        onPressed: () => _go('receipt'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AstryxBottomSheetPage(
              id: 'receipt',
              label: 'Payment sent',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxBanner(
                    status: AstryxBannerStatus.success,
                    title: 'Payment sent',
                    description: 'A receipt is on its way to your inbox.',
                  ),
                  AstryxButton(label: 'Done', onPressed: () => _go(null)),
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


## Usage

```dart
AstryxBottomSheetSwitcher(
  activeSheetId: _step,
  onActiveSheetChanged: (id) => setState(() => _step = id),
  sheets: <AstryxBottomSheetPage>[
    AstryxBottomSheetPage(
      id: 'method',
      label: 'Payment method',
      child: MethodList(onPicked: () => setState(() => _step = 'confirm')),
    ),
    AstryxBottomSheetPage(
      id: 'confirm',
      label: 'Confirm payment',
      child: const Confirmation(),
    ),
  ],
)
```

The step-by-step case a sheet is often asked for: choose a payment method, then confirm it, then see the receipt. Each step is its own sheet with its own height, and the switcher moves between them **without the scrim flashing** — three separate sheets opening and closing in turn dim the page, undim it and dim it again, which reads as three interruptions rather than one task.

`activeSheetId` is the whole state: a non-null id is the step on screen, null closes the flow. There is no controller, because a controller and an id would be two sources of truth for the same thing. The scrim, Escape and a dismissing drag all report a close as `onActiveSheetChanged(null)`, so a flow closed by the user and one closed by code take the same path.

A step is an `AstryxBottomSheetPage` rather than a sheet widget: only the active one is built, and the rest are the steps it may become. Its fields are [AstryxBottomSheet](bottom_sheet.md)’s own, minus the ones the switcher owns for the whole flow — the scrim, and how it dismisses. Upstream spells the same thing as nested sheets carrying a `sheetId`.

> **Accessibility**
>
> Each step names itself, so a screen reader announces the step the flow moved to rather than the flow it is still in.

> **Note**
>
> Upstream choreographs the outgoing sheet: it stays present and inert, travels to meet the height of the incoming one, then fades. Here the two cross-fade while the layer resizes to the new step. The difference shows on a large height change; everything the flow *does* is the same.

### AstryxBottomSheetSwitcher

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `activeSheetId` *(required)* | `String?` | — | The id of the step on screen, or null when the flow is closed. |
| `onActiveSheetChanged` *(required)* | `ValueChanged<String?>` | — | Called with the step to move to, or null to close the flow. |
| `sheets` *(required)* | `List<AstryxBottomSheetPage>` | — | The steps. Order is documentation only — `activeSheetId` decides. |
| `showScrim` | `bool` | `true` | Whether to dim the page behind the flow. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the scrim closes the flow. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes the flow. |


### AstryxBottomSheetPage

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` *(required)* | `String` | — | What names this sheet in `activeSheetId`. Unique within one switcher. |
| `label` *(required)* | `String` | — | The step’s accessible name. |
| `child` *(required)* | `Widget` | — | The body. |
| `height` | `AstryxBottomSheetHeight` | `AstryxBottomSheetHeight.hug` | How much of the viewport this step may occupy. Hugs by default, unlike a standalone sheet: the steps of a flow are rarely the same length. |
| `snapPoints` | `List<double>` | `const <double>[]` | Extra resting heights, each a fraction of the viewport in `(0, 1]`. |
| `initialSnapPoint` | `int?` | — | Which snap point this step opens at. |
| `showHandle` | `bool` | `true` | Whether to draw the grab handle. |
| `dragDismissible` | `bool` | `true` | Whether dragging past the shortest height closes the flow. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The inset around the body. |


---

Something wrong with `AstryxBottomSheetSwitcher`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxBottomSheetSwitcher&component=AstryxBottomSheetSwitcher) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxBottomSheetSwitcher&area=AstryxBottomSheetSwitcher) — both templates arrive with the component filled in.
