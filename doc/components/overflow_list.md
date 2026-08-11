---
title: AstryxOverflowList
description: A row of items that measures itself and moves the tail into a menu.
component: true
group: Data display
source: lib/src/components/data/overflow_list.dart
upstream: OverflowList
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class OverflowListDemoExample extends StatefulWidget {
  const OverflowListDemoExample({super.key});

  @override
  State<OverflowListDemoExample> createState() =>
      _OverflowListDemoExampleState();
}

class _OverflowListDemoExampleState extends State<OverflowListDemoExample> {
  static const List<String> _tags = <String>[
    'billing',
    'infra',
    'urgent',
    'customer-reported',
    'regression',
    'needs-repro',
  ];

  String? _chosen;

  @override
  Widget build(BuildContext context) {
    // Narrow the window and the tail moves into the menu; widen it and the
    // items come back. Nothing is ever unreachable — what does not fit is a
    // real menu row, not a clipped one.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxOverflowList(
          menuLabel: 'More tags',
          items: <AstryxOverflowItem>[
            for (final tag in _tags)
              AstryxOverflowItem(
                label: tag,
                onSelected: () => setState(() => _chosen = tag),
                child: AstryxBadge(tag),
              ),
          ],
        ),
        AstryxText(
          _chosen == null ? 'Nothing chosen yet' : 'Chose $_chosen',
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
AstryxOverflowList(
  items: <AstryxOverflowItem>[
    for (final tag in tags)
      AstryxOverflowItem(
        label: tag,
        child: AstryxBadge(tag),
        onSelected: () => open(tag),
      ),
  ],
)
```

For a toolbar, a breadcrumb trail, a row of tags — anywhere the number of items is not known in advance and wrapping onto a second line would break the layout around it.

## Two representations of one item

An item carries both a `child`, drawn while it fits, and a `label`, which names it in the menu once it does not. A widget cannot be turned into a menu row automatically — and asking for both is also the only way the menu row can be a real, operable row rather than a picture of one.

```dart
class OverflowListWidthsExample extends StatelessWidget {
  const OverflowListWidthsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The same six actions at three widths. The row is measured, not guessed,
    // so the answer is right at every one of them.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final width in const <double>[420, 280, 160])
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxText(
                '${width.toInt()} px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              SizedBox(
                width: width,
                child: AstryxOverflowList(
                  items: <AstryxOverflowItem>[
                    for (final action in const <String>[
                      'Rename',
                      'Duplicate',
                      'Move',
                      'Archive',
                      'Export',
                      'Delete',
                    ])
                      AstryxOverflowItem(
                        label: action,
                        onSelected: () {},
                        child: AstryxButton(
                          label: action,
                          size: AstryxButtonSize.sm,
                          onPressed: () {},
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


> **Accessibility**
>
> **Nothing is hidden that a user cannot get to.** What falls off the end becomes a row in a real [AstryxDropdownMenu](dropdown_menu.md), reachable by pointer, keyboard and screen reader alike — and the items it stands in for leave the semantics tree, so nobody hears the same list twice. That is the difference between this and clipping the row.

## How it settles

The trigger’s width depends on the count it shows, and the count depends on how many items fit, which depends on the trigger’s width. The circle only ever turns one way — a wider label hides more items, and hiding more items never narrows the label — so the row reaches its answer within a frame or two of any resize and holds it. In a test, `pumpAndSettle` is enough.

### AstryxOverflowList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `items` *(required)* | `List<AstryxOverflowItem>` | — | The items, in order. The tail is what overflows. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing2` | The space between items, and before the trigger. |
| `menuLabel` | `String?` | — | An accessible name for the overflow menu. |
| `minVisible` | `int` | `1` | How many items stay on the row however narrow it gets. |


### AstryxOverflowItem

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The item’s name, used for its menu row. |
| `child` *(required)* | `Widget` | — | What is drawn on the row while the item fits. |
| `onSelected` | `VoidCallback?` | — | Called when the item is chosen from the menu. Null makes the menu row inert — right for a tag rather than an action. |
| `icon` | `Widget?` | — | An icon before the label in the menu. |
| `enabled` | `bool` | `true` | Whether the menu row can be chosen. |


