---
title: AstryxHeading
description: 'A heading: a size from the scale, and a level in the outline.'
component: true
group: Layout & typography
source: lib/src/components/layout/heading.dart
upstream: Heading
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HeadingDemoExample extends StatelessWidget {
  const HeadingDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading('Workspace settings'),
        AstryxText(
          'Who can join, and what they can do once they have.',
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxHeading('Workspace settings')

const AstryxHeading('Members', level: 3)
```

`level` drives both the size and the level announced to assistive technology, which is the point: a heading that looks like a heading but is not announced as one leaves a screen-reader user without the document's structure.

## Levels

```dart
class HeadingLevelsExample extends StatelessWidget {
  const HeadingLevelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading('level 1', level: 1),
        AstryxHeading('level 2 — the default'),
        AstryxHeading('level 3', level: 3),
        AstryxHeading('level 4', level: 4),
        AstryxHeading('level 5', level: 5),
        AstryxHeading('level 6', level: 6),
      ],
    );
  }
}
```


## Display sizes

`type` changes the size only — the announced level stays `level`. So a hero heading can be enormous and still be the page’s h1.

```dart
class HeadingDisplayExample extends StatelessWidget {
  const HeadingDisplayExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `type` changes the size only. The announced level stays `level`, so a
    // hero heading can look enormous and still be the page's h1.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading(
          'display1',
          level: 1,
          type: AstryxHeadingType.display1,
        ),
        AstryxHeading('display2', type: AstryxHeadingType.display2),
        AstryxHeading('display3', type: AstryxHeadingType.display3),
      ],
    );
  }
}
```


## When the outline and the design disagree

`accessibilityLevel` overrides the announced level alone. It exists for the rare case where the visual hierarchy and the document outline genuinely differ. Prefer fixing the design.

```dart
class HeadingAccessibilityLevelExample extends StatelessWidget {
  const HeadingAccessibilityLevelExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Looks like an h4, announced as an h2 — for a card title that sits second
    // in the document outline but should not shout. Prefer fixing the design.
    return const AstryxHeading(
      'Recent activity',
      level: 4,
      accessibilityLevel: 2,
    );
  }
}
```


> **Accessibility**
>
> Do not skip levels to get a size. An h2 followed by an h4 tells a screen-reader user a section is missing. Use `type` for the size and keep `level` honest.

### AstryxHeading

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `data` *(required)* | `String` | — | The heading text. The positional first argument. |
| `level` | `int` | `2` | The heading level, 1–6. Drives both size and semantics. |
| `type` | `AstryxHeadingType?` | — | A display size to use instead of `level`’s own. The semantic level is unaffected. |
| `color` | `AstryxTextColor` | `AstryxTextColor.primary` | The semantic colour. |
| `accessibilityLevel` | `int?` | — | Overrides the level announced to assistive technology. |
| `justify` | `AstryxTextJustify?` | — | Alignment within the box. |
| `maxLines` | `int?` | — | Lines before truncation. |
| `overflow` | `TextOverflow?` | — | How overflow is handled. |
| `softWrap` | `bool` | `true` | Whether the heading wraps. |
| `strikethrough` | `bool` | `false` | Whether to strike it through. |
| `semanticsLabel` | `String?` | — | An alternative string for a screen reader. |
| `style` | `TextStyle?` | — | Applied over the resolved style. |
| `theme` | `AstryxTextTheme?` | — | Visual overrides, merged over `AstryxThemeData.heading`. |


## Related

- [AstryxText](text.md) — everything that is not a heading.

