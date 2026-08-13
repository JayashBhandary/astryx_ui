---
title: AstryxContextMenu
description: A menu raised by a secondary click, at the pointer.
component: true
group: Overlays
source: lib/src/components/overlay/context_menu.dart
upstream: ContextMenu / ContextMenuItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ContextMenuDemoExample extends StatefulWidget {
  const ContextMenuDemoExample({super.key});

  @override
  State<ContextMenuDemoExample> createState() => _ContextMenuDemoExampleState();
}

class _ContextMenuDemoExampleState extends State<ContextMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    // Secondary-click the card — or long-press it on a touch screen. The menu
    // opens where the pointer is, not against the card's edge.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxContextMenu(
          label: 'Request actions',
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Open in new tab',
              onSelected: () => setState(() => _last = 'opened'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              onSelected: () => setState(() => _last = 'duplicated'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'deleted'),
            ),
          ],
          child: const AstryxCard(
            width: 300,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText('GET /v1/projects/atlas'),
                AstryxText(
                  'Last run 14:02 · 204 ms',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
        ),
        AstryxText(
          'Last action: $_last',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxContextMenu(
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: delete),
  ],
  child: const RowOfTheTable(),
)
```

The same `AstryxMenuEntry` rows as a [dropdown menu](dropdown_menu.md), with the same keyboard model — arrows, Home and End, type-ahead, submenus, Escape. What differs is what opens it and where it lands.

|   | Dropdown menu | Context menu |
| --- | --- | --- |
| Opened by | a press on its trigger | a secondary click |
| On touch | the same press | a long-press |
| Anchored to | the trigger’s edge | the pointer |
| Discoverable | yes — it is a control | **no** |

> **Careful**
>
> Because it is not discoverable, **nothing may live only here**. A right-click has no keyboard equivalent and no visible affordance: a user who never tries it never learns the actions exist. Give each entry second home — a toolbar, a row menu, a details panel — and let this be the shortcut for people who already know.

## The same rows as a menu

```dart
class ContextMenuSectionsExample extends StatelessWidget {
  const ContextMenuSectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The same entry vocabulary as a dropdown menu: sections, dividers,
    // descriptions, submenus, destructive rows.
    return AstryxContextMenu(
      entries: <AstryxMenuEntry>[
        const AstryxMenuSection('This row'),
        AstryxMenuItem(label: 'Copy value', onSelected: () {}),
        AstryxMenuItem(
          label: 'Copy as',
          submenu: <AstryxMenuEntry>[
            AstryxMenuItem(label: 'JSON', onSelected: () {}),
            AstryxMenuItem(label: 'CSV', onSelected: () {}),
            AstryxMenuItem(label: 'cURL', onSelected: () {}),
          ],
        ),
        const AstryxMenuDivider(),
        const AstryxMenuSection('This column'),
        AstryxMenuItem(
          label: 'Sort ascending',
          icon: const AstryxIcon(AstryxIconName.arrowUp),
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Hide column',
          icon: const AstryxIcon(AstryxIconName.eyeSlash),
          description: 'Still exported',
          onSelected: () {},
        ),
      ],
      child: const AstryxCard(
        width: 300,
        child: AstryxText('Right-click this cell'),
      ),
    );
  }
}
```


## Width

A dropdown is bounded by its trigger; this one is anchored to a point, so `maxWidth` bounds it instead — 280 by default. Without a bound the rows would stretch to the viewport, which is not a menu.

## On the web

The browser’s own menu appears over this one unless the app turns it off once at startup.

```dart
if (kIsWeb) await BrowserContextMenu.disableContextMenu();
```

## Keyboard

| Key | Does |
| --- | --- |
| `↑` / `↓` | Moves the highlight, wrapping. |
| `Home` / `End` | Jumps to the first or last item. |
| a letter | Jumps to the first item starting with it. |
| `→` / `←` | Opens and closes a submenu. Mirrored under RTL. |
| `Enter` | Chooses the highlighted item; the menu closes first, then the callback runs. |
| `Escape` | Closes the menu, not the page behind it. |

> **Accessibility**
>
> The menu takes focus when it opens, so the arrows have somewhere to land, and gives it back when it closes. Every row is announced as a button; sections and dividers are skipped.

### AstryxContextMenu

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxMenuEntry>` | — | The rows, in order. Shared with `AstryxDropdownMenu`. |
| `child` *(required)* | `Widget` | — | The region a secondary click opens the menu over. |
| `label` | `String?` | — | An accessible name for the surface. |
| `enabled` | `bool` | `true` | Whether the menu can be opened. |
| `width` | `double?` | — | A fixed width. Null sizes the menu up to `maxWidth`. |
| `maxWidth` | `double` | `280` | The widest the menu may become. |
| `maxHeight` | `double` | `300` | The tallest the menu may be before it scrolls. |
| `longPressOnTouch` | `bool` | `true` | Whether a long-press opens it in touch density. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the menu opens or closes. |


## Related

- [AstryxDropdownMenu](dropdown_menu.md) — the discoverable version, and where the row types are documented.

---

Something wrong with `AstryxContextMenu`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxContextMenu&component=AstryxContextMenu) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxContextMenu&area=AstryxContextMenu) — both templates arrive with the component filled in.
