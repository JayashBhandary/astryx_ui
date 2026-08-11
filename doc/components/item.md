---
title: AstryxItem
description: The row the lists are built from — something at the start, a label, and something at the end.
component: true
group: Data display
source: lib/src/components/data/item.dart
upstream: Item
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ItemDemoExample extends StatelessWidget {
  const ItemDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxItem(
      leading: const AstryxIcon(AstryxIconName.check),
      label: 'ada@example.com',
      description: 'Owner · invited 3 days ago',
      trailing: const AstryxBadge(
        'Active',
        variant: AstryxBadgeVariant.success,
      ),
      onPressed: () {},
    );
  }
}
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
AstryxItem(
  leading: const AstryxIcon(AstryxIconName.check),
  label: 'ada@example.com',
  description: 'Owner',
  trailing: const AstryxBadge('Active'),
  onPressed: open,
)
```

## Anatomy

```text
AstryxItem
├── leading      ← optional. An icon, an avatar, a checkbox
├── label        ← required. Also the accessible name
│   └── description ← optional, under the label
└── trailing     ← optional. A badge, a count, a chevron
```

One line each by default. `maxLines: null` lets them wrap, but a list whose rows wrap has stopped being scannable, which is most of what a list is for.

## Pressable, selected, disabled

A non-null `onPressed` makes the row a button — the same rule [AstryxCard](card.md) follows, for the same reason. `selected` is not a press state: it survives the pointer leaving, and is what marks the row a list is currently showing.

```dart
class ItemStatesExample extends StatefulWidget {
  const ItemStatesExample({super.key});

  @override
  State<ItemStatesExample> createState() => _ItemStatesExampleState();
}

class _ItemStatesExampleState extends State<ItemStatesExample> {
  String _selected = 'Alan Turing';

  @override
  Widget build(BuildContext context) {
    // A press and a selection are different things: the press state goes when
    // the pointer leaves, the selection stays until something else is chosen.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final name in const <String>['Ada Lovelace', 'Alan Turing'])
          AstryxItem(
            label: name,
            selected: _selected == name,
            onPressed: () => setState(() => _selected = name),
          ),
        const AstryxItem(
          label: 'Grace Hopper',
          description: 'Shown, but not yours to open',
        ),
        AstryxItem(
          label: 'Katherine Johnson',
          description: 'Unavailable',
          enabled: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
```


| State | Set by | Reads as |
| --- | --- | --- |
| Pressable | `onPressed` non-null | a button: hover, press, a focus ring, a tap target |
| Selected | `selected: true` | tinted, and announced `selected` |
| Inert | `onPressed: null` | a plain row, contributing nothing of its own to semantics |
| Disabled | `enabled: false` | dimmed, still announced as a button, no tap action |

> **Accessibility**
>
> A disabled row stays in the semantics tree. A control that vanishes when it is disabled tells a screen-reader user the option does not exist, rather than that it is unavailable — which are different facts.

## Density

A row inside an [AstryxList](list.md) takes the list’s density, so no row repeats it and no row can disagree with its neighbours by accident. `density` on the row itself overrides that.

### AstryxItem

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the row’s accessible name. |
| `leading` | `Widget?` | — | Content at the reading-start edge. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content at the reading-end edge. |
| `onPressed` | `VoidCallback?` | — | Makes the whole row a button. Null leaves it inert. |
| `selected` | `bool` | `false` | Whether the row is the chosen one, which tints it. |
| `enabled` | `bool` | `true` | Whether the row accepts input. |
| `density` | `AstryxItemDensity?` | — | Overrides the density inherited from the enclosing list. |
| `maxLines` | `int?` | `1` | How many lines the label and description may each take. Null lets them wrap freely. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces instead of `label`. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxItemDensity

The same two names `AstryxCheckboxList` uses, because they mean the same thing.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `compact` | `AstryxItemDensity` | — | Tight rows, for a long list in a dense screen. |
| `balanced` | `AstryxItemDensity` | — | The default. |


## Related

- [AstryxList](list.md) — stacks rows with dividers and one density.
- [AstryxTreeList](tree_list.md) — the same row, nested.
- [AstryxDropdownMenu](dropdown_menu.md) — rows in a menu, which carry their own highlight and submenu state and so are drawn by the menu.

