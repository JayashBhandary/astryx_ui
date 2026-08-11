---
title: AstryxPagination
description: Page-at-a-time controls for a list or table too long to scroll.
component: true
group: Navigation
source: lib/src/components/navigation/pagination.dart
upstream: Pagination
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class PaginationDemoExample extends StatefulWidget {
  const PaginationDemoExample({super.key});

  @override
  State<PaginationDemoExample> createState() => _PaginationDemoExampleState();
}

class _PaginationDemoExampleState extends State<PaginationDemoExample> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    // Pages are one-based, as they are to the person reading them. The ends
    // are always shown, the middle gaps, and the arrows disable rather than
    // disappear — a control that vanishes moves everything beside it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxPagination(
          page: _page,
          pageCount: 20,
          onPageChanged: (page) => setState(() => _page = page),
        ),
        AstryxText(
          'Page $_page of 20',
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
AstryxPagination(
  page: _page,
  pageCount: (total / pageSize).ceil(),
  onPageChanged: (page) => setState(() => _page = page),
)
```

> **Careful**
>
> **Pages are one-based**, as they are to the person reading them: "page 1 of 20" is what the control says, so it is what the control counts in. An off-by-one here is an off-by-one the user sees.

## What it shows

The first and last pages, `siblings` on each side of the current one, and a gap where the rest were left out. The ends are the two a reader jumps to most and the two that say how much there is — a trail of numbers with no end in sight says less than "… 20".

The gap is not a button: it stands for a range rather than a page, and a control that cannot say where it would take you is not worth offering. A gap of exactly one page is drawn as the page instead, because "1 … 3" hides nothing and costs a press.

`AstryxPagination.pagesFor` is that arithmetic on its own, static and pure — so what a reader sees can be read, and tested, without a widget tree.

> **Accessibility**
>
> The arrows **disable at the ends rather than disappearing**: a control that vanishes moves everything beside it, and the reader loses their place in a row they were about to press again. The whole control announces "Page 3 of 20", so someone landing on it is told where they are before they hear a single number.

### AstryxPagination

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `page` *(required)* | `int` | — | The current page, from 1 to `pageCount`. |
| `pageCount` *(required)* | `int` | — | How many pages there are. |
| `onPageChanged` | `ValueChanged<int>?` | — | Called with the page the user chose. Null makes the control read-only. |
| `siblings` | `int` | `1` | How many page numbers to show each side of the current one. |
| `showEdges` | `bool` | `true` | Whether the first and last pages are always shown. |
| `label` | `String?` | — | The control’s accessible name. |


## Related

- [AstryxTable](table.md) — which does not virtualise; this is how a long one is made readable.
- [AstryxList](list.md) — same limit, same answer.

