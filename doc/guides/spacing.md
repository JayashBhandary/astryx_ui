---
title: Spacing
description: The spacing scale, and the rule that gaps come from tokens rather than magic numbers.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Fifteen steps, `spacing0` through `spacing12`, running 0 to 48px on a 4px grid — plus two half-steps, `spacing0_5` (2px) and `spacing1_5` (6px), for the distances inside a control where 4px is too coarse.

```dart
class ThemingSpacingExample extends StatelessWidget {
  const ThemingSpacingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final token in AstryxSpacingToken.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              SizedBox(
                width: 96,
                child: AstryxText(
                  token.name,
                  type: AstryxTextType.code,
                  maxLines: 1,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.accentMuted),
                ),
                child: SizedBox(height: 12, width: theme.spacing(token)),
              ),
              AstryxText(
                '${theme.spacing(token)}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
```


## Gaps belong to the container

A gap is a property of the thing doing the arranging, not a widget wedged between two others. Every layout widget takes a token — `gap` on the stacks, `gap` and `runGap` on the grid and on a wrapping stack, `padding` on a card — so spacing survives a reorder, an RTL flip and a child being removed.

```dart
class SpacingGapExample extends StatelessWidget {
  const SpacingGapExample({super.key});

  /// Three steps of the scale, applied to the same layout.
  static const List<AstryxSpacingToken> _steps = <AstryxSpacingToken>[
    AstryxSpacingToken.spacing1,
    AstryxSpacingToken.spacing3,
    AstryxSpacingToken.spacing6,
  ];

  @override
  Widget build(BuildContext context) {
    // One token drives the padding *and* the gap, which is what keeps the
    // rhythm of a screen consistent — two numbers cannot drift apart.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final step in _steps)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(step.name, type: AstryxTextType.code),
              AstryxCard(
                padding: step,
                child: AstryxHStack(
                  gap: step,
                  wrap: true,
                  runGap: step,
                  children: const <Widget>[
                    AstryxBadge('build'),
                    AstryxBadge('test'),
                    AstryxBadge('deploy'),
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


```dart
AstryxVStack(
  gap: AstryxSpacingToken.spacing3,
  align: AstryxStackAlign.stretch,
  children: <Widget>[…],
)

// Reading a step, for a widget the design system has no equivalent of:
final inset = AstryxTheme.of(context).spacing(AstryxSpacingToken.spacing4);
```

**Which step**

| Step | Usually |
| --- | --- |
| `spacing0_5`, `spacing1` | Inside a control — a glyph and its label, a badge’s padding. |
| `spacing2` | Between related controls. The most-used step in the package. |
| `spacing3` | Between the rows of a group or a form. |
| `spacing4` | A card’s padding — its default. |
| `spacing6` and up | Between the sections of a page, where the gap does the grouping. |

> **Careful**
>
> A `SizedBox(height: 12)` between two children is the one to watch for. It looks identical today and is invisible to every theme, density and direction change afterwards.

## The scale is not generated

Radius, type and motion each expand from a base and a ratio. Spacing does not: there is no spacing expander, and no `spacing` field on a theme definition. A theme that wants a tighter rhythm overrides the individual tokens, which beat every generated value.

```dart
final acmeDense = defineTheme(
  AstryxDefineThemeInput(
    name: 'acme-dense',
    extendsTheme: acmeTheme,
    tokens: <String, AstryxTokenValue>{
      '--spacing-3': AstryxTokenValue('10px'),
      '--spacing-4': AstryxTokenValue('12px'),
    },
  ),
);
```

> **Note**
>
> Spacing does not move with [density](density.md). Touch grows the region that responds to a finger, not the layout around it — so a form does not reflow when someone plugs in a mouse.

## Related

- [AstryxHStack & AstryxVStack](../components/stack.md) — where most gaps are set.
- [AstryxGrid](../components/grid.md) — `gap` and `runGap` on a tile wall.
- [Design tokens](tokens.md) — the other token families.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Spacing&component=Docs%3A+Spacing) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Spacing&area=Docs%3A+Spacing) — both templates arrive with the page filled in.
