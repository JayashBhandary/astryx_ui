---
title: AstryxCommandPalette
description: 'The keyboard-first command surface: a query, grouped results, and a footer of shortcuts.'
component: true
group: Command & search
source: lib/src/components/search/command_palette.dart
upstream: CommandPalette / CommandPaletteEmpty / CommandPaletteFooter / CommandPaletteGroup / CommandPaletteInput / CommandPaletteItem / CommandPaletteList
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CommandPaletteDemoExample extends StatefulWidget {
  const CommandPaletteDemoExample({super.key});

  @override
  State<CommandPaletteDemoExample> createState() =>
      _CommandPaletteDemoExampleState();
}

class _CommandPaletteDemoExampleState extends State<CommandPaletteDemoExample> {
  static const AstryxHotkey _open = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

  final AstryxOverlayController _palette = AstryxOverlayController();
  String _last = 'Nothing run yet';

  @override
  void dispose() {
    _palette.dispose();
    super.dispose();
  }

  void _run(String what) => setState(() => _last = what);

  @override
  Widget build(BuildContext context) {
    // Press the button, or ⌘K / Ctrl+K. The shortcut on each row is drawn from
    // the hotkey that is bound, so the palette cannot teach a stale chord.
    return AstryxHotkeys(
      autofocus: true,
      bindings: <AstryxHotkey, VoidCallback>{_open: _palette.show},
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Open the palette',
                trailing: const AstryxKbd.hotkey(_open),
                onPressed: _palette.show,
              ),
            ],
          ),
          AstryxText(
            _last,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxCommandPalette(
            controller: _palette,
            groups: <AstryxCommandGroup>[
              AstryxCommandGroup(
                label: 'Navigate',
                items: <AstryxCommandItem>[
                  AstryxCommandItem(
                    label: 'Go to deploys',
                    icon: AstryxIconName.arrowUp,
                    hotkey: const AstryxHotkey.mod(LogicalKeyboardKey.keyD),
                    onSelected: () => _run('Went to deploys'),
                  ),
                  AstryxCommandItem(
                    label: 'Go to settings',
                    icon: AstryxIconName.wrench,
                    keywords: const <String>['preferences', 'config'],
                    onSelected: () => _run('Went to settings'),
                  ),
                ],
              ),
              AstryxCommandGroup(
                label: 'Deploy',
                items: <AstryxCommandItem>[
                  AstryxCommandItem(
                    label: 'Roll back the last deploy',
                    icon: AstryxIconName.arrowDown,
                    description: 'Reverts to 13:41',
                    onSelected: () => _run('Rolled back'),
                  ),
                  const AstryxCommandItem(
                    label: 'Promote to production',
                    enabled: false,
                    description: 'Needs an approval first',
                    onSelected: _noop,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _noop() {}
}
```


## Usage

```dart
AstryxHotkeys(
  autofocus: true,
  bindings: <AstryxHotkey, VoidCallback>{
    const AstryxHotkey.mod(LogicalKeyboardKey.keyK): _palette.show,
  },
  child: Stack(
    children: <Widget>[
      page,
      AstryxCommandPalette(controller: _palette, groups: _commands),
    ],
  ),
)
```

Upstream ships the input, the list, the group, the item, the empty state and the footer separately. They are one widget here, because a palette assembled from six pieces is six chances to get the keyboard wrong — and the keyboard is the entire reason a palette exists.

Like every overlay in this package it is a **widget in the tree**, not a `show…` call: it renders nothing until the controller opens it, so it sits next to whatever opens it and there is no `BuildContext` to smuggle across an async gap.

## Keyboard

| Key | Does |
| --- | --- |
| Typing | Filters. The query field takes focus on open, so there is nothing to click first. |
| `↑` / `↓` | Moves the highlight, **skipping headings and disabled commands** and wrapping at the ends. |
| `Enter` | Runs the highlighted command and closes. |
| `Esc` | Closes. Nothing is run. |

The highlight returns to the top on every keystroke: the best match for what is typed *now* is the first row, and leaving it three rows down means `Enter` runs something the user has stopped looking at. The first runnable row is active on open, so `Enter` straight away does the obvious thing rather than nothing.

## Finding a command

A query matches the label, the description **and the keywords**. Those matter more than they look: "Log out" has to be findable by "sign out", "exit" and "quit", and a command nobody can find by the word they thought of is a command that is not there.

Each row draws its own shortcut from the `AstryxHotkey` that is *bound* elsewhere in the application — so the palette teaches the real chord and cannot describe one that has moved. Empty groups disappear rather than showing a heading over nothing.

> **Accessibility**
>
> The palette is a modal layer: the scrim marks the page behind it inert, focus is trapped, Escape closes it and focus returns to whatever opened it. The footer states the three keys rather than assuming they are known — a palette is often the first keyboard-only surface a user meets.

> **Note**
>
> It closes **before** running the command. A command that opens a dialog would otherwise open it behind the palette.

### AstryxCommandPalette

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxOverlayController` | — | Opens and closes it. |
| `groups` *(required)* | `List<AstryxCommandGroup>` | — | The commands. A group with an empty label draws no heading. |
| `empty` | `Widget?` | — | Shown when the query matches nothing. |
| `footer` | `Widget?` | — | Replaces the shortcut legend. |
| `showFooter` | `bool` | `true` | Whether to draw the footer at all. |
| `width` | `double` | `560` | How wide it is. |
| `maxHeight` | `double` | `420` | The tallest the result list grows before it scrolls. |
| `clearOnClose` | `bool` | `true` | Whether closing empties the query. A palette reopened on last week’s half-typed query has to be cleared before it is useful. |


### AstryxCommandItem

One command. `AstryxCommandGroup` is a label and a list of these.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | What the command is called. |
| `onSelected` *(required)* | `VoidCallback` | — | What running it does. |
| `description` | `String?` | — | A qualifying second line. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `hotkey` | `AstryxHotkey?` | — | The shortcut that runs it elsewhere, drawn on the row. |
| `keywords` | `List<String>` | `const <String>[]` | Extra words the query should match. |
| `enabled` | `bool` | `true` | Whether it can be run now. Disabled rows are shown and skipped. |


## Related

- [AstryxHotkeys](use_hotkeys.md) — binding the shortcut that opens it.
- [AstryxKbd](kbd.md) — the caps on each row.
- [AstryxDropdownMenu](dropdown_menu.md) — for a short list of actions attached to a control rather than to the application.

