---
title: useOverflow → AstryxOverflowList
description: Measuring which children do not fit, so a component can collapse its tail.
component: true
group: Hooks & controllers
source: lib/src/components/data/overflow_list.dart
upstream: useOverflow
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream measures children against their container and hides the ones that do not fit. Here that measurement is not a hook a caller wires up: it is inside [AstryxOverflowList](overflow_list.md), which is the widget to reach for.

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


## The rule that matters

**Nothing is hidden that a user cannot get to.** The overflow trigger is a real menu with a real row per hidden item, so what falls off the end stays reachable by pointer, keyboard and screen reader alike. That is the difference between collapsing a row and clipping it.

It is also why an item is declared twice — a widget for the row, a label for the menu. A widget cannot be turned into an operable menu row automatically, and a picture of one is worse than nothing.

## Scroll, collapse, or wrap

| When the row will not fit | Reach for |
| --- | --- |
| The items are equals and order matters — tags, filters | `AstryxOverflowList`, so the tail is still reachable |
| The items are destinations and the strip is navigation | `AstryxTabList`, which scrolls and fades — see [useScrollOverflow](use_scroll_overflow.md) |
| The tail is *actions* rather than content | `AstryxMoreMenu`, which is the "…" trigger and its menu as one widget |
| A second line is fine | `AstryxHStack(wrap: true)` — no measurement needed at all |

> **Careful**
>
> Measuring costs a layout pass and a rebuild. A row of six chips is a fine use; a table of two hundred cells is not, and the answer there is a column strategy rather than measurement.

## Related

- [AstryxOverflowList](overflow_list.md) — the widget, and its properties.
- [AstryxMoreMenu](more_menu.md) — the overflow trigger on its own.
- [AstryxBreadcrumbs](breadcrumbs.md) — a trail that collapses in the middle rather than at the end.

---

Something wrong with `useOverflow → AstryxOverflowList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useOverflow+%E2%86%92+AstryxOverflowList&component=useOverflow+%E2%86%92+AstryxOverflowList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useOverflow+%E2%86%92+AstryxOverflowList&area=useOverflow+%E2%86%92+AstryxOverflowList) — both templates arrive with the component filled in.
