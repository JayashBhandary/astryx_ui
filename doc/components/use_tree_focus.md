---
title: useTreeFocus → AstryxTreeList
description: Arrow-key traversal across a tree, including expand and collapse.
component: true
group: Hooks & controllers
source: lib/src/components/data/tree_list.dart
upstream: useTreeFocus
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A tree is a list whose length changes as you walk it, and whose inline arrows mean something else entirely. That is why it is [AstryxTreeList](tree_list.md) rather than a configuration of [AstryxRovingFocus](use_list_focus.md).

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


## Why it is not the list primitive

| Key | In a tree |
| --- | --- |
| `↑` / `↓` | Moves through the **visible** rows — so collapsing a node changes what "next" means, mid-traversal. |
| `→` | Expands a collapsed node, then moves into it. Not "next item". |
| `←` | Collapses an expanded node, or moves to its parent. Mirrored under RTL. |
| `Enter` / `Space` | Presses the row. |

Two of the four arrows therefore do a *different job* from their list counterparts, and the traversal order is derived from state the tree owns. Forcing that through a flat index is how a tree ends up focusing a row that is no longer on screen.

> **Accessibility**
>
> A collapsed subtree is **not in the widget tree**: no layout, no semantics, and no focus stops behind a closed node. Each row carries its expanded state in its semantics, so a reader is told rather than left to infer it from a rotated chevron.

## Related

- [AstryxTreeList](tree_list.md) — the widget, and its properties.
- [useListFocus](use_list_focus.md) — the flat case, and the primitive.
- [AstryxCollapsible](collapsible.md) — one disclosure rather than a tree of them.

---

Something wrong with `useTreeFocus → AstryxTreeList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useTreeFocus+%E2%86%92+AstryxTreeList&component=useTreeFocus+%E2%86%92+AstryxTreeList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useTreeFocus+%E2%86%92+AstryxTreeList&area=useTreeFocus+%E2%86%92+AstryxTreeList) — both templates arrive with the component filled in.
