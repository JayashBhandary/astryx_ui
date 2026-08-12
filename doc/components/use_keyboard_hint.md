---
title: AstryxKeyboardHint
description: Showing shortcut hints only once the user is navigating by keyboard.
component: true
group: Hooks & controllers
source: lib/src/foundation/keyboard_hint.dart
upstream: useKeyboardHint
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookKeyboardHintExample extends StatelessWidget {
  const HookKeyboardHintExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Press a key, then move the mouse: the hints follow the same last-input
    // signal as the focus ring, so a hint and a ring never disagree about which
    // mode the user is in. They keep their space either way.
    return AstryxList(
      children: <Widget>[
        AstryxItem(
          label: 'Command palette',
          onPressed: () {},
          trailing: const AstryxKeyboardHint(
            child: AstryxKbd.hotkey(
              AstryxHotkey.mod(LogicalKeyboardKey.keyK),
            ),
          ),
        ),
        AstryxItem(
          label: 'Save',
          onPressed: () {},
          trailing: const AstryxKeyboardHint(
            child: AstryxKbd.hotkey(
              AstryxHotkey.mod(LogicalKeyboardKey.keyS),
            ),
          ),
        ),
        AstryxItem(
          label: 'Deploy log',
          onPressed: () {},
          // Nothing to hint, so the slot says something else on a pointer.
          trailing: const AstryxKeyboardHint(
            otherwise: AstryxText(
              '2 minutes ago',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            child: AstryxKbd.chord(<String>['G', 'L']),
          ),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxItem(
  label: 'Command palette',
  trailing: const AstryxKeyboardHint(
    child: AstryxKbd.hotkey(palette),
  ),
)
```

A shortcut hint beside every row is noise for somebody using a mouse and the whole point for somebody who is not. This shows its child while the last input was a key and steps back once a pointer is used.

It reads the same last-input-device signal as the focus ring (`AstryxFocusVisible`), so a hint and a ring can never disagree about which mode the user is in — which is what would make either of them look broken.

## It keeps its space

`reserveSpace` is on by default, and worth leaving on: a hint that appears on the first keystroke and pushes a row’s contents sideways draws the eye to the wrong thing at exactly the wrong moment. Hidden it is not painted, not hit-tested and not announced — but the row does not change shape.

`otherwise` fills the slot with something else on a pointer — a timestamp where the shortcut would be — which is the version that wastes no space at all.

> **Careful**
>
> **A hint is a reminder, never the only route.** Whatever the shortcut does must also be reachable by pressing something: this hides a *hint*, not a control. Putting a control in here is the keyboard equivalent of hiding one behind hover, and it fails the same people.

### AstryxKeyboardHint

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The hint. |
| `reserveSpace` | `bool` | `true` | Whether the hint keeps its space while hidden. |
| `otherwise` | `Widget?` | — | What to show instead while the user is on a pointer. |
| `excludeFromSemantics` | `bool` | `false` | Whether to keep the hint out of the semantics tree. It is announced by default, because the hint is usually where the shortcut is written down. |


## Related

- [AstryxHotkeys](use_hotkeys.md) — binding the shortcut this describes.
- [AstryxKbd](kbd.md) — drawing the keys.
- [AstryxSideNav](side_nav.md) — the one place hover is allowed to reveal something, and why.

