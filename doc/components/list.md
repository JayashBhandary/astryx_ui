---
title: AstryxList
description: A vertical list of rows, with the separators and density the design system expects.
component: true
group: Data display
source: lib/src/components/data/list.dart
upstream: List / ListItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ListDemoExample extends StatefulWidget {
  const ListDemoExample({super.key});

  @override
  State<ListDemoExample> createState() => _ListDemoExampleState();
}

class _ListDemoExampleState extends State<ListDemoExample> {
  String? _open;

  @override
  Widget build(BuildContext context) {
    return AstryxList(
      label: 'Recent deploys',
      showDividers: true,
      children: <Widget>[
        for (final deploy in const <List<String>>[
          <String>['api', '2 minutes ago', 'Live'],
          <String>['web', '1 hour ago', 'Live'],
          <String>['worker', 'yesterday', 'Rolled back'],
        ])
          AstryxItem(
            label: deploy[0],
            description: deploy[1],
            selected: _open == deploy[0],
            trailing: AstryxBadge(
              deploy[2],
              variant: deploy[2] == 'Live'
                  ? AstryxBadgeVariant.success
                  : AstryxBadgeVariant.neutral,
            ),
            onPressed: () => setState(() => _open = deploy[0]),
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxList(
  label: 'Team',
  children: <Widget>[
    AstryxItem(label: 'Ada Lovelace', description: 'Owner'),
    AstryxItem(label: 'Alan Turing', description: 'Admin'),
  ],
)
```

Upstream ships `List` and `ListItem`. The item here is [AstryxItem](item.md), which is also usable on its own, so this widget is only the container: the dividers, the density every row inherits, and the name a screen reader reads before the first row.

> **Careful**
>
> **It does not scroll and does not virtualise.** A list is a `Column`, so a long one belongs inside the page’s scroll view, and a very long one belongs in a paginated [AstryxTable](table.md) instead — the same limit the table carries, for the same reason.

## Dividers and density

Rules are for rows that would otherwise run together — two lines of text each. A list of one-line rows reads better spaced than ruled, which is why `showDividers` is off by default.

```dart
class ListDensityExample extends StatelessWidget {
  const ListDensityExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The list sets the rhythm once; no row repeats it, and no row can
    // disagree with its neighbours by accident.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (final density in AstryxItemDensity.values)
          Flexible(
            child: AstryxList(
              label: density.name,
              density: density,
              children: <Widget>[
                for (final name in const <String>['Ada', 'Alan', 'Grace'])
                  AstryxItem(label: name),
              ],
            ),
          ),
      ],
    );
  }
}
```


## Nothing to show

A list with no rows renders nothing at all, which reads as a bug. `empty` is where an [AstryxEmptyState](empty_state.md) goes.

```dart
class ListEmptyExample extends StatefulWidget {
  const ListEmptyExample({super.key});

  @override
  State<ListEmptyExample> createState() => _ListEmptyExampleState();
}

class _ListEmptyExampleState extends State<ListEmptyExample> {
  final List<String> _keys = <String>[];

  @override
  Widget build(BuildContext context) {
    // `empty` is the list's answer to having nothing to show. Without it a
    // list with no rows renders nothing at all, which reads as a bug.
    return AstryxList(
      label: 'API keys',
      showDividers: true,
      empty: AstryxEmptyState(
        size: AstryxEmptyStateSize.compact,
        icon: const AstryxIcon(AstryxIconName.search),
        title: 'No API keys',
        description: 'Keys you create will be listed here.',
        actions: <Widget>[
          AstryxButton(
            label: 'Create a key',
            variant: AstryxButtonVariant.primary,
            onPressed: () => setState(() => _keys.add('key_live_1')),
          ),
        ],
      ),
      children: <Widget>[
        for (final key in _keys)
          AstryxItem(
            label: key,
            description: 'Created just now',
            trailing: AstryxButton(
              label: 'Revoke',
              size: AstryxButtonSize.sm,
              variant: AstryxButtonVariant.ghost,
              onPressed: () => setState(() => _keys.remove(key)),
            ),
          ),
      ],
    );
  }
}
```


> **Accessibility**
>
> The list announces itself as a list, and each row as one of its items, so a screen reader can say "list, 3 items" before reading the first. Give it a `label`: "list, 3 items" is a start, "Recent deploys, list, 3 items" is an answer.

### AstryxList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The rows, in order. Usually `AstryxItem`s. |
| `label` | `String?` | — | The list’s accessible name, announced before the first row. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.balanced` | The vertical rhythm every row inherits. |
| `showDividers` | `bool` | `false` | Whether to draw a rule between rows. |
| `gap` | `AstryxSpacingToken?` | — | Overrides the space between rows. Defaults to nothing when dividers are drawn: a rule and a gap doing the same job is one too many. |
| `empty` | `Widget?` | — | What to show when `children` is empty. Null renders nothing. |


## Related

- [AstryxItem](item.md) — the row.
- [AstryxTreeList](tree_list.md) — when the rows nest.
- [AstryxTable](table.md) — when the rows have columns.

---

Something wrong with `AstryxList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxList&component=AstryxList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxList&area=AstryxList) — both templates arrive with the component filled in.
