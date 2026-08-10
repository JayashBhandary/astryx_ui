---
title: AstryxText
description: A run of text, sized and coloured from the type scale.
component: true
group: Layout & typography
source: lib/src/components/layout/text.dart
upstream: Text
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TextDemoExample extends StatelessWidget {
  const TextDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText('Requests are up 12% this week.'),
        AstryxText(
          'Compared with the seven days before.',
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
const AstryxText('Requests are up 12% this week.')

const AstryxText(
  'Compared with the seven days before.',
  type: AstryxTextType.supporting,
  color: AstryxTextColor.secondary,
)
```

Text takes a `type` and a `color`, not a `TextStyle`. The type selects one row of the type scale — size, weight and line height together — so two pieces of body copy cannot drift apart by half a pixel. `style` exists as an escape hatch, and everything else on this page is an attempt to make reaching for it rare.

## Types

```dart
class TextTypesExample extends StatelessWidget {
  const TextTypesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText('display1', type: AstryxTextType.display1),
        AstryxText('display2', type: AstryxTextType.display2),
        AstryxText('display3', type: AstryxTextType.display3),
        AstryxText('large', type: AstryxTextType.large),
        AstryxText('body — the default'),
        AstryxText('label', type: AstryxTextType.label),
        AstryxText('supporting', type: AstryxTextType.supporting),
        AstryxText('code_sample()', type: AstryxTextType.code),
      ],
    );
  }
}
```


| Type | For |
| --- | --- |
| `display1` … `display3` | Marketing-scale numbers and hero text. Rarely inside a tool. |
| `large` | Body copy one step up, for emphasis. |
| `body` | The default. |
| `label` | Form and control labels. |
| `supporting` | Hints, captions, helper text. |
| `code` | Inline and block code, in the code family. |

## Colours

Semantic, not literal. `inherit` takes the colour from the enclosing `DefaultTextStyle`, which is what text inside a button or an inverted banner wants.

```dart
class TextColorsExample extends StatelessWidget {
  const TextColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText('primary'),
        AstryxText('secondary', color: AstryxTextColor.secondary),
        AstryxText('placeholder', color: AstryxTextColor.placeholder),
        AstryxText('disabled', color: AstryxTextColor.disabled),
        AstryxText('accent', color: AstryxTextColor.accent),
      ],
    );
  }
}
```


## Weights

`weight` overrides what the type would give. Prefer a different `type` where one fits: the scale already pairs weight with size and leading.

```dart
class TextWeightsExample extends StatelessWidget {
  const TextWeightsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      wrap: true,
      children: <Widget>[
        AstryxText('normal', weight: AstryxTextWeight.normal),
        AstryxText('medium', weight: AstryxTextWeight.medium),
        AstryxText('semibold', weight: AstryxTextWeight.semibold),
        AstryxText('bold', weight: AstryxTextWeight.bold),
      ],
    );
  }
}
```


## Truncation

With `maxLines` set, overflow defaults to an ellipsis. `truncateTooltip` adds a tooltip carrying the full string — but only when the text is genuinely cut off, so it never repeats something already legible. It costs one text layout per build, so leave it off for text that cannot truncate.

```dart
class TextTruncationExample extends StatelessWidget {
  const TextTruncationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `truncateTooltip` shows the full string on hover — but only when the
    // text is genuinely cut off, so a tooltip never repeats what is already
    // legible. A screen reader always gets the whole string.
    return const SizedBox(
      width: 240,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(
            'analytics-pipeline-eu-west-1.internal.example.com',
            maxLines: 1,
            truncateTooltip: true,
          ),
          AstryxText(
            'A description long enough to need two lines and then some more, '
            'which is where the ellipsis lands.',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
```


> **Accessibility**
>
> Truncation is a painting concern and never reaches the semantics tree: a screen reader always gets the whole string, ellipsis or not.

## Numbers

`tabularNumbers` asks the font for fixed-width figures, so a column of numbers lines up. Fonts without the `tnum` feature render unchanged.

```dart
class TextNumbersExample extends StatelessWidget {
  const TextNumbersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tabular figures line the digits up, so a column of numbers is
    // comparable at a glance.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.start,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.end,
          children: <Widget>[
            AstryxText('Proportional', type: AstryxTextType.label),
            AstryxText('1,118'),
            AstryxText('92,300'),
            AstryxText('4,201'),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.end,
          children: <Widget>[
            AstryxText('tabularNumbers', type: AstryxTextType.label),
            AstryxText('1,118', tabularNumbers: true),
            AstryxText('92,300', tabularNumbers: true),
            AstryxText('4,201', tabularNumbers: true),
          ],
        ),
      ],
    );
  }
}
```


## Semantics

`semanticsLabel` replaces what is read aloud without changing what is painted — for text a reader would mangle: `$1.2M`, an abbreviation, a glyph.

```dart
class TextSemanticsExample extends StatelessWidget {
  const TextSemanticsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // What is read aloud need not be what is painted. `$1.2M` is a glyph
    // salad to a screen reader; the label says it in words.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText(
          r'$1.2M',
          type: AstryxTextType.display3,
          semanticsLabel: '1.2 million dollars',
        ),
        AstryxText(
          'Annual recurring revenue',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


### AstryxText

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `data` *(required)* | `String` | — | The text to display. The positional first argument. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The semantic role, which selects the type-scale row. |
| `color` | `AstryxTextColor` | `AstryxTextColor.primary` | The semantic colour. |
| `weight` | `AstryxTextWeight?` | — | Overrides the weight the `type` would give. |
| `size` | `AstryxTextSizeToken?` | — | Overrides the size from the raw ramp. The line height stays the role’s, so this changes the leading ratio — usually not what you want. |
| `justify` | `AstryxTextJustify?` | — | Alignment within the box. Logical, so it flips under RTL. |
| `maxLines` | `int?` | — | Lines before the text is truncated. |
| `overflow` | `TextOverflow?` | — | How overflow is handled. Defaults to `ellipsis` when `maxLines` is set, `clip` otherwise. |
| `truncateTooltip` | `bool` | `false` | Whether to show the full text in a tooltip when — and only when — it is cut off. |
| `softWrap` | `bool` | `true` | Whether the text wraps at soft breaks. |
| `strikethrough` | `bool` | `false` | Whether to strike the text through. |
| `tabularNumbers` | `bool` | `false` | Whether digits use fixed-width figures. |
| `semanticsLabel` | `String?` | — | An alternative string for a screen reader. |
| `style` | `TextStyle?` | — | Applied over the resolved style. |
| `theme` | `AstryxTextTheme?` | — | Visual overrides, merged over `AstryxThemeData.text`. |


## Related

- [AstryxHeading](heading.md) — text that is also a document landmark.
- [Design tokens](../guides/tokens.md) — the scale these types come from.

