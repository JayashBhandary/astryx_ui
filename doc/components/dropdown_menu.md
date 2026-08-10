---
title: AstryxDropdownMenu
description: A list of actions, with sections, submenus and full keyboard support.
component: true
group: Overlays
source: lib/src/components/overlay/dropdown_menu.dart
upstream: DropdownMenu / DropdownMenuItem / DropdownMenuCheckboxItem / DropdownMenuRadioGroup / DropdownMenuRadioItem / DropdownMenuSubMenu
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DropdownMenuDemoExample extends StatefulWidget {
  const DropdownMenuDemoExample({super.key});

  @override
  State<DropdownMenuDemoExample> createState() =>
      _DropdownMenuDemoExampleState();
}

class _DropdownMenuDemoExampleState extends State<DropdownMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxDropdownMenu(
          label: 'Actions',
          width: 220,
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Rename',
              icon: const AstryxIcon(AstryxIconName.wrench),
              onSelected: () => setState(() => _last = 'Rename'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              icon: const AstryxIcon(AstryxIconName.copy),
              onSelected: () => setState(() => _last = 'Duplicate'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'Delete'),
            ),
          ],
          triggerBuilder: (context, controller) =>
              AstryxButton(label: 'Actions', onPressed: controller.toggle),
        ),
        AstryxText(
          'Last chosen: $_last',
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
AstryxDropdownMenu(
  label: 'Actions',
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: delete),
  ],
  triggerBuilder: (context, controller) =>
      AstryxButton(label: 'Actions', onPressed: controller.toggle),
)
```

> **Note**
>
> A menu performs **actions**. To pick a *value*, use [AstryxSelector](selector.md) — it reports a selection, shows which option is current, and can be validated.

## Composition

```text
AstryxDropdownMenu
└── entries
    ├── AstryxMenuSection('Manage')     ← a heading. Not focusable
    ├── AstryxMenuItem(label: …)
    │   └── submenu: <AstryxMenuEntry>[…]  ← a non-empty list makes a flyout
    ├── AstryxMenuDivider()             ← a rule. Not focusable
    └── AstryxMenuItem(destructive: true)
```

```dart
class DropdownMenuSectionsExample extends StatelessWidget {
  const DropdownMenuSectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Sections and dividers organise a long menu. Neither is focusable, so the
    // keyboard never lands on one.
    return AstryxDropdownMenu(
      label: 'Project menu',
      width: 260,
      entries: <AstryxMenuEntry>[
        const AstryxMenuSection('Manage'),
        AstryxMenuItem(label: 'Settings', onSelected: () {}),
        AstryxMenuItem(
          label: 'Members',
          trailing: const AstryxBadge('24'),
          onSelected: () {},
        ),
        const AstryxMenuDivider(),
        const AstryxMenuSection('Danger zone'),
        AstryxMenuItem(
          label: 'Transfer ownership',
          description: 'You will lose admin access',
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Delete project',
          destructive: true,
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) => AstryxIconButton(
        icon: AstryxIconName.moreHorizontal,
        label: 'Project menu',
        variant: AstryxButtonVariant.ghost,
        onPressed: controller.toggle,
      ),
    );
  }
}
```


## Submenus

A submenu is an item with `submenu` entries — not a separate row type, because a submenu row *is* an item in every respect except what happens when you choose it. Opening and closing are delayed slightly so diagonal mouse travel from the parent row to its flyout does not close the thing it is travelling to.

```dart
class DropdownMenuSubmenuExample extends StatelessWidget {
  const DropdownMenuSubmenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A non-empty `submenu` turns an item into a flyout. Right opens it and
    // Left closes it — mirrored under RTL.
    return AstryxDropdownMenu(
      width: 220,
      entries: <AstryxMenuEntry>[
        AstryxMenuItem(label: 'Open', onSelected: () {}),
        AstryxMenuItem(
          label: 'Move to',
          submenu: <AstryxMenuEntry>[
            const AstryxMenuSection('Boards'),
            AstryxMenuItem(label: 'Backlog', onSelected: () {}),
            AstryxMenuItem(label: 'In progress', onSelected: () {}),
            AstryxMenuItem(
              label: 'Archive',
              submenu: <AstryxMenuEntry>[
                AstryxMenuItem(label: '2024', onSelected: () {}),
                AstryxMenuItem(label: '2025', onSelected: () {}),
              ],
            ),
          ],
        ),
        AstryxMenuItem(
          label: 'Requires the Editor role',
          enabled: false,
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'With submenus', onPressed: controller.toggle),
    );
  }
}
```


## Trailing content

A shortcut hint, a badge, a count — `trailing` takes any widget.

```dart
class DropdownMenuTrailingExample extends StatelessWidget {
  const DropdownMenuTrailingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxDropdownMenu(
      width: 240,
      entries: <AstryxMenuEntry>[
        AstryxMenuItem(
          label: 'Save',
          trailing: const AstryxText(
            'Ctrl S',
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Save as…',
          trailing: const AstryxText(
            'Ctrl ⇧ S',
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'File', onPressed: controller.toggle),
    );
  }
}
```


## Placement

```dart
class DropdownMenuPlacementExample extends StatelessWidget {
  const DropdownMenuPlacementExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A menu matches its trigger's width by default, which is what makes it
    // read as belonging to the control. `width` overrides that.
    return SizedBox(
      width: 280,
      child: AstryxDropdownMenu(
        side: AstryxOverlaySide.top,
        align: AstryxOverlayAlign.end,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Newest first', onSelected: () {}),
          AstryxMenuItem(label: 'Oldest first', onSelected: () {}),
          AstryxMenuItem(label: 'Most requests', onSelected: () {}),
        ],
        triggerBuilder: (context, controller) => AstryxButton(
          label: 'Sort',
          width: double.infinity,
          trailing: const AstryxIcon(AstryxIconName.chevronDown),
          onPressed: controller.toggle,
        ),
      ),
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Enter` on the trigger | Opens the menu. |
| `↑` / `↓` | Moves the highlight without choosing anything, wrapping. |
| `Home` / `End` | Jumps to the first or last item. |
| a letter | Jumps to the first item starting with it. |
| `→` | Opens a submenu. Mirrored under RTL. |
| `←` | Closes it. Mirrored under RTL. |
| `Enter` | Chooses the highlighted item; the menu closes first, then the callback runs. |
| `Escape` | Closes the menu, not the page behind it. |

> **Accessibility**
>
> Sections and dividers are skipped by the keyboard, so arrowing never lands on something that does nothing. A disabled item stays visible and is announced as disabled — with a `description` it can even say why.

### AstryxDropdownMenu

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxMenuEntry>` | — | The rows, in order. |
| `triggerBuilder` *(required)* | `Widget Function(BuildContext, AstryxOverlayController)` | — | Builds the trigger, given the controller that opens the menu. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |
| `label` | `String?` | — | An accessible name for the surface. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.start` | Alignment along the trigger’s edge. |
| `width` | `double?` | — | A fixed width. Null sizes to the widest row. |
| `matchTriggerWidth` | `bool` | `true` | Whether the menu is at least as wide as its trigger. |
| `maxHeight` | `double` | `300` | The tallest the menu may be before it scrolls. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the menu opens or closes. |


### AstryxMenuItem

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and this item’s accessible name. |
| `onSelected` | `VoidCallback?` | — | Called when the item is chosen. The menu closes first. |
| `icon` | `Widget?` | — | An icon before the label. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content after the label — a shortcut hint, a badge. |
| `enabled` | `bool` | `true` | Whether the item can be chosen. |
| `destructive` | `bool` | `false` | Whether the action is irreversible, which colours it with `--color-error`. |
| `submenu` | `List<AstryxMenuEntry>` | `const <AstryxMenuEntry>[]` | Nested entries. A non-empty list turns this row into a submenu. |


