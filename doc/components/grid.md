---
title: AstryxGrid
description: 'A CSS-style grid: fixed tracks, or as many as the width allows.'
component: true
group: Layout & typography
source: lib/src/components/layout/grid.dart
upstream: Grid / GridSpan
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class GridDemoExample extends StatelessWidget {
  const GridDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxGrid(
      columns: 3,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
        _Metric('Seats', '24'),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxGrid(
  columns: 3,
  gap: AstryxSpacingToken.spacing3,
  children: <Widget>[...],
)
```

Either `columns` for a fixed track count, or `minWidth` for a responsive one. Not both.

## Responsive

With `minWidth`, the column count falls out of the space available — `repeat(auto-fit, minmax(180px, 1fr))`, in CSS terms. No breakpoints to keep in step with the design, and `maxColumns` stops a grid spreading indefinitely on a wide display.

```dart
class GridResponsiveExample extends StatelessWidget {
  const GridResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    // No breakpoints. The column count falls out of the width available, the
    // way `repeat(auto-fit, minmax(180px, 1fr))` does upstream. Resize the
    // window to watch it re-flow.
    return const AstryxGrid(
      minWidth: 180,
      maxColumns: 4,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
      ],
    );
  }
}
```


## Short rows

Five items in a four-track row leave one short. `fit` collapses the empty tracks so the row stretches; `fill` keeps them, so the last item stays the width it would have had in a full row.

```dart
class GridRepeatExample extends StatelessWidget {
  const GridRepeatExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Five items in a four-column track list leave one short row. `fit`
    // stretches it; `fill` keeps the empty tracks, so the last item stays the
    // width it would have had in a full row.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('repeat: fit', type: AstryxTextType.label),
        AstryxGrid(
          minWidth: 140,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            _Metric('One', '1'),
            _Metric('Two', '2'),
            _Metric('Three', '3'),
            _Metric('Four', '4'),
            _Metric('Five', '5'),
          ],
        ),
        AstryxText('repeat: fill', type: AstryxTextType.label),
        AstryxGrid(
          minWidth: 140,
          repeat: AstryxGridRepeat.fill,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            _Metric('One', '1'),
            _Metric('Two', '2'),
            _Metric('Three', '3'),
            _Metric('Four', '4'),
            _Metric('Five', '5'),
          ],
        ),
      ],
    );
  }
}
```


## Gaps

`gap` sets both axes; `rowGap` and `columnGap` override it per axis.

```dart
class GridGapsExample extends StatelessWidget {
  const GridGapsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Rows and columns can breathe differently — tight columns, roomy rows.
    return const AstryxGrid(
      columns: 3,
      columnGap: AstryxSpacingToken.spacing1,
      rowGap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
        _Metric('Seats', '24'),
      ],
    );
  }
}
```


> **Note**
>
> The grid lays its children out in rows and never scrolls. For hundreds of tiles, put it in a scroll view — or reach for a Flutter sliver grid, which builds lazily.

### AstryxGrid

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The widgets to lay out, in order. |
| `columns` | `int?` | — | A fixed number of equal columns. |
| `minWidth` | `double?` | — | The minimum column width, for a responsive track list. |
| `maxColumns` | `int?` | — | A ceiling on the responsive column count. |
| `repeat` | `AstryxGridRepeat` | `AstryxGridRepeat.fit` | Whether empty tracks collapse. Only meaningful with `minWidth`. |
| `gap` | `AstryxSpacingToken?` | — | The space between items on both axes. |
| `rowGap` | `AstryxSpacingToken?` | — | The space between rows. |
| `columnGap` | `AstryxSpacingToken?` | — | The space between columns. |


## Related

- [AstryxHStack & AstryxVStack](stack.md) — for one-dimensional layout.
- [AstryxCard](card.md) — the usual tile.

