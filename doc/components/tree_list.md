---
title: AstryxTreeList
description: A list of nested, expandable rows.
component: true
group: Data display
source: lib/src/components/data/tree_list.dart
upstream: TreeList
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TreeListDemoExample extends StatefulWidget {
  const TreeListDemoExample({super.key});

  @override
  State<TreeListDemoExample> createState() => _TreeListDemoExampleState();
}

class _TreeListDemoExampleState extends State<TreeListDemoExample> {
  String? _selected = 'list';

  @override
  Widget build(BuildContext context) {
    // Tab lands on the tree once; the arrows do the rest. Right opens a branch
    // and then steps into it, Left closes it and then steps out.
    return AstryxTreeList(
      label: 'Files',
      nodes: _files,
      initiallyExpanded: const <String>{'lib', 'components'},
      selected: _selected,
      onSelectedChanged: (id) => setState(() => _selected = id),
    );
  }
}
```


## Usage

```dart
AstryxTreeList(
  label: 'Files',
  selected: selectedId,
  onSelectedChanged: (id) => setState(() => selectedId = id),
  nodes: const <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'lib',
      label: 'lib',
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'main', label: 'main.dart'),
      ],
    ),
  ],
)
```

A node’s identity is its `id`, and expansion and selection are carried as ids rather than as flags on the node. A caller rebuilding the tree from fresh data therefore does not lose which branches were open — the usual failure of a tree that stores its state in its own nodes.

## Keyboard

**The whole tree is one tab stop**, and the arrows move inside it. A tree whose every row were its own tab stop would take forty presses to walk past, which is why the ARIA tree pattern exists and why it is built by hand here.

| Key | Does |
| --- | --- |
| `Down` / `Up` | Moves to the next or previous visible row. |
| `Right` | Opens a closed branch; steps into an open one. Mirrored under RTL. |
| `Left` | Closes an open branch; steps out to the parent. Mirrored under RTL. |
| `Home` / `End` | The first and last visible rows. |
| `Enter` / `Space` | Presses the row. |
| `Tab` | Leaves the tree entirely. |

The arrows do not wrap, unlike [AstryxRadioList](radio_list.md): a tree is a hierarchy, and jumping from the last leaf back to the first root loses the reader’s place.

## Pressing a row

A leaf is chosen. A branch is opened or closed **and** chosen — a tree where clicking a folder does not select it is a tree where the folder can never be the answer.

## Who owns the open branches

Either you or the widget. Pass `expanded` and `onExpandedChanged` to drive it — which is what lets a button outside the tree expand all of it — or leave `expanded` null and let the tree keep its own set, seeded from `initiallyExpanded`. Selection is always yours, as it is on [AstryxRadioList](radio_list.md).

```dart
class TreeListControlledExample extends StatefulWidget {
  const TreeListControlledExample({super.key});

  @override
  State<TreeListControlledExample> createState() =>
      _TreeListControlledExampleState();
}

class _TreeListControlledExampleState extends State<TreeListControlledExample> {
  Set<String> _expanded = <String>{'lib'};
  String? _selected;

  /// Every branch in the tree, whether it is open or not.
  static const Set<String> _branches = <String>{'lib', 'components', 'test'};

  @override
  Widget build(BuildContext context) {
    // With `expanded` passed in, nothing opens until the caller says so — which
    // is what lets a button outside the tree drive it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: 'Expand all',
              size: AstryxButtonSize.sm,
              onPressed: () => setState(() => _expanded = _branches),
            ),
            AstryxButton(
              label: 'Collapse all',
              size: AstryxButtonSize.sm,
              onPressed: () => setState(() => _expanded = <String>{}),
            ),
          ],
        ),
        AstryxTreeList(
          label: 'Files',
          nodes: _files,
          density: AstryxItemDensity.compact,
          expanded: _expanded,
          onExpandedChanged: (next) => setState(() => _expanded = next),
          selected: _selected,
          onSelectedChanged: (id) => setState(() => _selected = id),
        ),
      ],
    );
  }
}
```


> **Note**
>
> A closed branch builds none of its children, so a tree of a thousand nodes costs only what is open. What *is* open is built in full — this is a `Column`, like [AstryxList](list.md), and does not virtualise.

### AstryxTreeList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `nodes` *(required)* | `List<AstryxTreeNode>` | — | The roots, in order. |
| `expanded` | `Set<String>?` | — | The ids of the open branches. Null keeps the set inside the widget. |
| `initiallyExpanded` | `Set<String>` | `const <String>{}` | The branches open on the first build. Ignored when `expanded` is set. |
| `onExpandedChanged` | `ValueChanged<Set<String>>?` | — | Called with the whole new set whenever a branch opens or closes. |
| `selected` | `String?` | — | The id of the chosen row. |
| `onSelectedChanged` | `ValueChanged<String>?` | — | Called with the id of the row the user chose. Null makes the tree read-only: it still expands and still traverses. |
| `label` | `String?` | — | The tree’s accessible name. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.balanced` | The vertical rhythm every row takes. |
| `focusNode` | `FocusNode?` | — | The focus node for the tree. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxTreeNode

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` *(required)* | `String` | — | This node’s identity, unique across the whole tree. |
| `label` *(required)* | `String` | — | The visible text, and this row’s accessible name. |
| `children` | `List<AstryxTreeNode>` | `const <AstryxTreeNode>[]` | The nodes under this one. A non-empty list makes the row expandable. |
| `leading` | `Widget?` | — | Content between the chevron and the label. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content at the reading-end edge. |
| `enabled` | `bool` | `true` | Whether this row can be chosen or opened. |


## Related

- [AstryxList](list.md) — when the rows do not nest.
- [AstryxCollapsible](collapsible.md) — one section that opens, rather than a tree of them.

