---
title: AstryxResizeHandle
description: A draggable divider that resizes the panel beside it.
component: true
group: App shell
source: lib/src/components/shell/resize_handle.dart
upstream: ResizeHandle / useResizable
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ResizeHandleDemoExample extends StatefulWidget {
  const ResizeHandleDemoExample({super.key});

  @override
  State<ResizeHandleDemoExample> createState() =>
      _ResizeHandleDemoExampleState();
}

class _ResizeHandleDemoExampleState extends State<ResizeHandleDemoExample> {
  double _width = 200;

  @override
  Widget build(BuildContext context) {
    // Tab to the handle and use the arrow keys: a divider only a pointer can
    // move is a layout only some people can use.
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: _width,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('${_width.round()} px'),
            ),
          ),
          AstryxResizeHandle(
            label: 'Resize the filters',
            size: _width,
            min: 120,
            max: 360,
            onResize: (width) => setState(() => _width = width),
          ),
          const Expanded(
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('Results'),
            ),
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
Row(
  children: <Widget>[
    SizedBox(width: _width, child: const Filters()),
    AstryxResizeHandle(
      label: 'Resize the filters',
      edge: AstryxResizeEdge.start,
      size: _width,
      min: 180,
      max: 480,
      onResize: (width) => setState(() => _width = width),
    ),
    const Expanded(child: Results()),
  ],
)
```

The handle holds no size of its own: `size` comes in and `onResize` goes out, so the number lives in the state that also lays the region out. Upstream’s `useResizable` keeps the same split — the hook owns the number, the handle only reports the drag.

## Which way is bigger

`edge` is one value rather than an axis and a direction, because those two can be set inconsistently and this cannot: the edge decides the axis, which way a drag grows the region, and which arrow keys apply.

| Edge | The region is | Grows when dragged |
| --- | --- | --- |
| `start` | a panel at the reading-start edge | toward the reading end |
| `end` | a panel at the reading-end edge | toward the reading start |
| `top` | a band at the top | down |
| `bottom` | a band at the bottom | up |

The inline edges mirror under RTL, so the same physical drag grows the panel in both directions. The block edges never mirror.

> **Accessibility**
>
> **Tab reaches it, and the arrow keys move it** by `step`, with Home and End at `min` and `max`. It announces itself as a slider carrying the current size, and `label` is required because nothing is painted on a handle — without one a screen reader has a slider and no idea what it sizes. A divider only a pointer can move is a layout only some people can use, and this is the part hand-rolled resize handles almost always miss.

The drag target is `thickness` wide — wider than the hairline it draws, because a one-pixel target is a target nobody hits. The rule takes the accent while the handle is hovered or dragged, so the affordance appears where the pointer already is rather than as a permanent seam down the page.

### AstryxResizeHandle

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The handle’s accessible name. Required. |
| `size` *(required)* | `double` | — | The current size of the region beside the handle. |
| `onResize` | `ValueChanged<double>?` | — | Called with the size the region should take, continuously during a drag. Null makes the handle inert. |
| `edge` | `AstryxResizeEdge` | `AstryxResizeEdge.start` | Which edge the resized region sits against. |
| `min` | `double` | `0` | The smallest the region may become. |
| `max` | `double` | `double.infinity` | The largest the region may become. |
| `step` | `double` | `16` | How far one arrow-key press moves the handle. |
| `onResizeEnd` | `ValueChanged<double>?` | — | Called when a drag finishes, for persisting the size rather than writing it on every frame. |
| `enabled` | `bool` | `true` | Whether the handle responds. |
| `thickness` | `double` | `8` | How wide the drag target is. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxResizeEdge

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `AstryxResizeEdge` | — | A panel at the reading-start edge. |
| `end` | `AstryxResizeEdge` | — | A panel at the reading-end edge. |
| `top` | `AstryxResizeEdge` | — | A band at the top. |
| `bottom` | `AstryxResizeEdge` | — | A band at the bottom. |


