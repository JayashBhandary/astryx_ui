---
title: AstryxHotkeys
description: Binding keyboard shortcuts to actions.
component: true
group: Hooks & controllers
source: lib/src/foundation/hotkeys.dart
upstream: useHotkeys
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookHotkeysExample extends StatefulWidget {
  const HookHotkeysExample({super.key});

  @override
  State<HookHotkeysExample> createState() => _HookHotkeysExampleState();
}

class _HookHotkeysExampleState extends State<HookHotkeysExample> {
  static const AstryxHotkey _save = AstryxHotkey.mod(LogicalKeyboardKey.keyS);
  static const AstryxHotkey _palette = AstryxHotkey.mod(
    LogicalKeyboardKey.keyK,
  );

  final List<String> _log = <String>[];

  void _record(String what) => setState(() {
    _log.insert(0, what);
    if (_log.length > 3) _log.removeLast();
  });

  @override
  Widget build(BuildContext context) {
    // One definition per shortcut: bound here, and drawn by `AstryxKbd.hotkey`
    // below from the same object — so the hint can never describe a key that is
    // not the one bound. `mod` is ⌘ on a Mac and Ctrl elsewhere.
    return AstryxHotkeys(
      autofocus: true,
      bindings: <AstryxHotkey, VoidCallback>{
        _save: () => _record('Saved'),
        _palette: () => _record('Opened the palette'),
      },
      child: AstryxCard(
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxList(
              children: <Widget>[
                AstryxItem(
                  label: 'Save',
                  trailing: AstryxKbd.hotkey(_save),
                ),
                AstryxItem(
                  label: 'Command palette',
                  trailing: AstryxKbd.hotkey(_palette),
                ),
              ],
            ),
            AstryxText(
              _log.isEmpty ? 'Press one of them' : _log.join(' · '),
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
```


## Usage

```dart
const save = AstryxHotkey.mod(LogicalKeyboardKey.keyS);

AstryxHotkeys(
  bindings: <AstryxHotkey, VoidCallback>{save: _save},
  child: const EditorPage(),
)
```

Upstream takes strings — `'mod+s'`. This takes a [LogicalKeyboardKey] instead: a typo in a string is a shortcut that silently never fires, and there is no reason to accept one when the analyser could have caught it.

## `mod` is the point

A shortcut written with `AstryxHotkey.mod` is **Command on a Mac and Control everywhere else** — which is what a user of both expects, and what makes one definition correct on both. It also means the hotkey can say which modifier it resolved to, so the hint beside a menu row draws itself:

```dart
const palette = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

AstryxItem(
  label: 'Command palette',
  trailing: const AstryxKbd.hotkey(palette),   // ⌘K, or Ctrl+K
)
```

One object, bound and drawn. `AstryxKbd` otherwise refuses to translate `Ctrl` to `⌘`, because only the caller knows whether a cap it was handed is a platform convention or a product’s own — but a hotkey knows, so there is nothing left to guess.

## Where the keys arrive

> **Careful**
>
> **Key events walk *up* from whatever holds focus.** Until something inside the subtree is focused there is nothing for them to walk through, so an application-wide scope needs `autofocus: true` — otherwise `⌘K` does nothing on a freshly loaded page and gets reported as broken. The node is still skipped by Tab, so this costs no tab stop.

The flip side: a scope wrapped around a control should **not** autofocus, and a binding with no modifier inside a form will steal the key from every field in it. `/` to focus a search box is a fine shortcut on a page of tables and a hostile one on a page of text inputs.

`enabled: false` unbinds everything without touching the subtree — how a screen suspends its shortcuts while a modal is open.

### AstryxHotkeys

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `bindings` *(required)* | `Map<AstryxHotkey, VoidCallback>` | — | What each hotkey does. |
| `child` *(required)* | `Widget` | — | The subtree the bindings apply to. |
| `enabled` | `bool` | `true` | Whether the bindings are live. |
| `autofocus` | `bool` | `false` | Whether the scope takes focus when built. Set it on an application-wide scope; leave it off around a control. |
| `platform` | `TargetPlatform?` | — | Overrides the platform `mod` resolves against. For tests, and for previewing another platform’s shortcuts. |


### AstryxHotkey

An immutable value, `const`-constructible, and equal by key and modifiers — so it can be a map key, and a shortcut table can be a compile-time constant.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `AstryxHotkey(key, {control, shift, alt, meta})` | `constructor` | — | A shortcut with fixed modifiers. |
| `AstryxHotkey.mod(key, {shift, alt})` | `constructor` | — | A shortcut on the platform’s own command modifier. |
| `activatorFor(platform)` | `ShortcutActivator` | — | The binding, resolved — so a hotkey can be handed to Flutter’s own `Shortcuts` too. |
| `capsFor(platform)` | `List<String>` | — | The caps to draw: `⌘ K` on Apple platforms, `Ctrl K` elsewhere. |
| `describeFor(platform)` | `String` | — | The spoken form — "Command K". A row of symbols read aloud is not a shortcut anybody can follow. |


> **Accessibility**
>
> A shortcut is an accelerator, never the only way to do something (WCAG 2.1.1). Every hotkey in a screen needs a control that does the same job, and the shortcut belongs *on* that control as a hint — which is what `AstryxKbd.hotkey` is for.

## Related

- [AstryxKbd](kbd.md) — drawing the keys, including from a hotkey.
- [AstryxDropdownMenu](dropdown_menu.md) — where a shortcut hint usually sits.
- [Accessibility](../guides/accessibility.md) — the rule above, in context.

