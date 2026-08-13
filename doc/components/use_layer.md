---
title: useLayer → Overlay and the stack
description: Placing content in the overlay stack at the right depth.
component: true
group: Hooks & controllers
source: lib/src/foundation/overlay_stack.dart
upstream: useLayer
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream needs a hook to claim a depth in a shared stacking context, because the web has no built-in place to put floating content. Flutter has one and it is called `Overlay` — so there is nothing to claim, and no `useLayer` to port.

What remains is the *order* things close in, which is [the overlay layer](layer_provider.md): `AstryxOverlayStack` tracks the open dismissible layers so **Escape closes one, not all of them**.

```dart
class ProviderLayerExample extends StatefulWidget {
  const ProviderLayerExample({super.key});

  @override
  State<ProviderLayerExample> createState() => _ProviderLayerExampleState();
}

class _ProviderLayerExampleState extends State<ProviderLayerExample> {
  final AstryxOverlayController _layer = AstryxOverlayController();

  @override
  void dispose() {
    _layer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two layers, one on top of the other. Escape closes the popover and leaves
    // the panel — the stack keeps the order, so one press is one layer.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Raise a layer', onPressed: _layer.show),
        AstryxOverlay(
          controller: _layer,
          label: 'Export',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Export',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'Open the menu, then press Escape twice: the menu goes '
                  'first, this panel second.',
                ),
                AstryxDropdownMenu(
                  label: 'Format',
                  entries: <AstryxMenuEntry>[
                    AstryxMenuItem(label: 'CSV', onSelected: () {}),
                    AstryxMenuItem(label: 'JSON', onSelected: () {}),
                  ],
                  triggerBuilder: (context, controller) => AstryxButton(
                    label: 'Format',
                    onPressed: controller.toggle,
                  ),
                ),
                AstryxButton(label: 'Close', onPressed: _layer.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```


## Building your own layer

```dart
final layer = AstryxOverlayController();

AstryxOverlay(
  controller: layer,
  label: 'Preview',
  child: myPanel,      // scrim, focus trap, Escape, entry animation
)
```

Reach past that only for something `AstryxOverlay` cannot express. Then the contract to honour is four lines long: register with the stack while open, unregister on close *and on dispose*, answer Escape only when `isTopmost`, and trap focus if you dimmed the page.

```dart
@override
void initState() {
  super.initState();
  AstryxOverlayStack.push(_dismiss, modal: true);
}

@override
void dispose() {
  // On dispose too, or a gone layer keeps swallowing Escape.
  AstryxOverlayStack.remove(_dismiss);
  super.dispose();
}
```

> **Careful**
>
> The unregister-on-dispose line is the one that gets forgotten, and the bug it causes is remote from its cause: Escape stops working somewhere else on the page, long after the layer that broke it has gone.

## Depth, as far as it exists

Order is push order, and that is sound rather than lucky: a Flutter overlay opens when something calls `show`, and the inner one is always shown after the outer one that contains its trigger. There is no z-index to manage and no depth to pass.

## Related

- [The overlay layer](layer_provider.md) — the stack, and where layers are hosted.
- [AstryxOverlay](overlay.md) — the scrim-and-layer widget.
- [AstryxScrollLock](use_scroll_lock.md) — what a modal layer should freeze behind it.

---

Something wrong with `useLayer → Overlay and the stack`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useLayer+%E2%86%92+Overlay+and+the+stack&component=useLayer+%E2%86%92+Overlay+and+the+stack) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useLayer+%E2%86%92+Overlay+and+the+stack&area=useLayer+%E2%86%92+Overlay+and+the+stack) — both templates arrive with the component filled in.
