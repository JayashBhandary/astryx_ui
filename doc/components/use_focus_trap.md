---
title: AstryxFocusTrap
description: Holding focus inside an open overlay, and giving it back.
component: true
group: Hooks & controllers
source: lib/src/foundation/focus_trap.dart
upstream: useFocusTrap
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Two behaviours, both required by the WAI-ARIA dialog pattern and both easy to get subtly wrong. **Every Astryx overlay already uses this** — reach for it directly only for a layer you are building yourself.

- **Trap.** Tab from the last focusable child returns to the first, and Shift+Tab from the first goes to the last. Focus never reaches the page behind the overlay, which is still visible and still tabbable as far as the framework is concerned.
- **Restore.** On dismount focus returns to whatever held it before — normally the trigger. A user who opens a dialog with the keyboard and closes it must not be dumped back at the top of the document.

The restore half matters more than it looks. `FocusScope` already restores focus *within* a scope, but the node that opened the overlay is outside it, so the framework has nothing to go back to. This widget records the node itself.

```dart
class HookFocusTrapExample extends StatefulWidget {
  const HookFocusTrapExample({super.key});

  @override
  State<HookFocusTrapExample> createState() => _HookFocusTrapExampleState();
}

class _HookFocusTrapExampleState extends State<HookFocusTrapExample> {
  bool _trapped = true;

  @override
  Widget build(BuildContext context) {
    // Tab round the three buttons inside the panel. Trapped, focus loops inside
    // it; untrapped, it escapes to the switch above and onto the page. Every
    // Astryx overlay uses this — reach for it directly only for a layer you are
    // building yourself.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSwitch(
          label: 'Trap focus',
          value: _trapped,
          onChanged: (value) => setState(() => _trapped = value),
        ),
        AstryxFocusTrap(
          enabled: _trapped,
          // Nothing is stealing focus on the way in here: the panel is already
          // on the page, unlike an overlay that has just opened.
          autofocus: false,
          child: AstryxCard(
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(label: 'First', onPressed: () {}),
                AstryxButton(label: 'Second', onPressed: () {}),
                AstryxButton(label: 'Third', onPressed: () {}),
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
AstryxFocusTrap(
  enabled: isOpen,
  child: const MyLayerBody(),
)
```

`enabled: false` lets focus move freely, for a panel that is deliberately non-modal — a formatting toolbar over an editor, where trapping would be hostile rather than helpful.

### AstryxFocusTrap

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The subtree focus is kept inside. |
| `enabled` | `bool` | `true` | Whether the trap is active. |
| `autofocus` | `bool` | `true` | Whether to move focus into the subtree when the trap activates. |
| `restoreFocus` | `bool` | `true` | Whether to return focus to the previously-focused node on dismount. |
| `debugLabel` | `String?` | — | A label for the debug focus tree. |


> **Accessibility**
>
> A trap without a way out is a cage. Whatever you put inside one needs Escape, or a close control, or both — which is why the overlays own the trap rather than leaving it to a caller who might forget.

## Related

- [The overlay layer](layer_provider.md) — the dismiss stack the trap sits beside.
- [AstryxOverlay](overlay.md) — trap, scrim and Escape as one widget.
- [AstryxScrollLock](use_scroll_lock.md) — the other half of taking over a page.

