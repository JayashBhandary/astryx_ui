---
title: The overlay layer
description: The stacking context overlays are raised into.
component: true
group: Providers
source: lib/src/foundation/overlay_stack.dart
upstream: LayerProvider
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream’s `LayerProvider` exists because the web has no built-in place to put floating content: a popover rendered inside a scrolling, `overflow: hidden` panel is clipped, so the provider gives every overlay one shared stacking context to portal into.

**Flutter already has that, and it is called `Overlay`.** There is therefore no `AstryxLayerProvider` to install: `AstryxApp`, `MaterialApp` and `CupertinoApp` each build an `Overlay`, and every Astryx overlay portals into the nearest one through `OverlayPortal`. What this page documents is the part Flutter does *not* provide — the order in which those layers close.

## One Escape, one layer

A popover opened from inside a dialog is the case that proves the problem. Without coordination both listen for Escape, both dismiss, and the user loses the dialog they were working in because they wanted to close a colour picker. `AstryxOverlayStack` is the fix: every dismissible layer registers while open, and only the top-most one answers.

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


Astryx overlays are `OverlayPortal`s rather than routes — deliberately, so a popover does not appear in the back stack and cannot be reached with the browser’s back button. Flutter’s `Navigator` gets this ordering from its route stack; a portal has no such stack, so the ordering is tracked here instead.

> **Note**
>
> Order is push order, and that is sound rather than lucky: a Flutter overlay opens when something calls `show`, and the inner one is always shown after the outer one that contains its trigger.

## Where a layer is hosted

The nearest `Overlay` ancestor. That is almost always the app’s own, which is why nothing needs wiring — but two situations are worth knowing:

- **No app widget at all** — a bare `WidgetsBinding.attachRootWidget`, or a widget test that pumps a subtree. Wrap it in an `Overlay`, or use the harness the package’s own tests use.
- **A nested `Overlay`** — an in-app window manager, a preview pane. Overlays portal into the nested one, and are clipped to it. That is usually what you want; when it is not, host the trigger above the nested overlay.

### AstryxOverlayStack

A static registry, not a widget. Every Astryx overlay uses it; reach for it directly only when you are building a dismissible layer of your own.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `push(onDismiss)` | `void` | — | Registers a layer as the top-most one. |
| `remove(onDismiss)` | `void` | — | Removes a layer, wherever it sits — a layer can be closed programmatically while something above it is still open. |
| `isTopmost(onDismiss)` | `bool` | — | Whether that layer is the one Escape would close. |
| `dismissTopmost()` | `bool` | — | Dismisses the top-most layer, and reports whether there was one — so a key handler can let Escape reach what is behind it. |


> **Accessibility**
>
> A modal layer sets `scopesRoute` in its semantics, which is what tells a screen reader the page behind it is inert. Set it false for a layer that is merely floating — announcing a page as unavailable when it is not is worse than saying nothing.

## Related

- [AstryxOverlay](overlay.md) — the scrim-and-layer widget, and its properties.
- [AstryxPopover](popover.md) — an anchored layer.
- [AstryxDialog](dialog.md) — a modal layer with a panel on it.

---

Something wrong with `The overlay layer`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+The+overlay+layer&component=The+overlay+layer) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+The+overlay+layer&area=The+overlay+layer) — both templates arrive with the component filled in.
