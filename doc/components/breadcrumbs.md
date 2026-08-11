---
title: AstryxBreadcrumbs
description: The trail back up a hierarchy, collapsing in the middle when it will not fit.
component: true
group: Navigation
source: lib/src/components/navigation/breadcrumbs.dart
upstream: Breadcrumbs / BreadcrumbItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BreadcrumbsDemoExample extends StatelessWidget {
  const BreadcrumbsDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final trail = <AstryxBreadcrumb>[
      AstryxBreadcrumb(label: 'Projects', onPressed: () {}),
      AstryxBreadcrumb(label: 'astryx_ui', onPressed: () {}),
      AstryxBreadcrumb(label: 'Environments', onPressed: () {}),
      AstryxBreadcrumb(label: 'production', onPressed: () {}),
      const AstryxBreadcrumb(label: 'Deploy #412'),
    ];

    // The same trail at three widths. It collapses in the middle, never at the
    // ends: the first step is the way out to the top and the last is where the
    // reader is.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final width in const <double>[560, 380, 240])
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
                child: AstryxBreadcrumbs(items: trail),
              ),
            ],
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxBreadcrumbs(
  items: <AstryxBreadcrumb>[
    AstryxBreadcrumb(label: 'Projects', onPressed: () => go('/')),
    AstryxBreadcrumb(label: 'astryx_ui', onPressed: () => go('/astryx')),
    const AstryxBreadcrumb(label: 'Deploy #412'),
  ],
)
```

## It collapses in the middle

**Never at the ends.** The first step is the way out to the top and the last is where the user is; dropping either to save room throws away the two the trail exists for. What is dropped goes into a menu where it was, so it stays reachable — the same bargain [AstryxOverflowList](overflow_list.md) makes with the tail of a row.

The row is measured, not guessed, so the answer is right at every width. The count settles for the same reason the overflow list’s does: hiding more steps never widens the trigger past what hiding fewer would need, so it converges within a frame or two of a resize.

## The last step is not a link

A step with no `onPressed` is a label rather than a link. The step the reader is on is the one they cannot go to — offering it is how a trail stops telling the user where they are — so it takes the primary text colour and no button.

> **Accessibility**
>
> The separators are decoration and stay out of the semantics tree: a screen reader gets the trail’s structure from its nodes, not from a chevron read aloud between every pair. The collapsed-steps trigger is named for what it does — "Show 3 hidden steps" — because "…" spoken aloud is not an offer anybody can act on.

### AstryxBreadcrumbs

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `items` *(required)* | `List<AstryxBreadcrumb>` | — | The steps, from the top of the hierarchy to where the reader is. |
| `label` | `String?` | — | The trail’s accessible name. |
| `separator` | `Widget?` | — | What goes between two steps. Defaults to a chevron, mirrored under RTL. |


### AstryxBreadcrumb

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The name of this level. |
| `onPressed` | `VoidCallback?` | — | Goes there. Null makes the step a label rather than a link. |
| `icon` | `Widget?` | — | An icon before the label. |


## Related

- [AstryxLayout](layout.md) — a trail usually sits in its `header`.
- [AstryxOverflowList](overflow_list.md) — the same trick for a row of anything.

