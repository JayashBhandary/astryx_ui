---
title: Shape
description: Corner radii and how they compose when surfaces nest.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Seven radius tokens, named for the level of the layout they belong to rather than for a number of pixels. Picking by level is what keeps nested corners concentric when the scale moves.

```dart
class ShapeScaleExample extends StatelessWidget {
  const ShapeScaleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 130,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final token in AstryxRadiusToken.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundMuted),
                  borderRadius: theme.borderRadius(token),
                  border: Border.all(
                    color: theme.color(AstryxColorToken.border),
                  ),
                ),
                child: const SizedBox(height: 56),
              ),
              AstryxText(
                '${token.name} · ${theme.radius(token).round()}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ],
          ),
      ],
    );
  }
}
```


| Token | Default | For |
| --- | --- | --- |
| `none` | 0px | Square. A fixed anchor; never scales. |
| `inner` | 4px | A corner inside a control — a chip, a row. |
| `element` | 8px | The controls themselves: buttons, inputs. |
| `container` | 12px | Cards, panels, popovers, dialogs. |
| `page` | 28px | Page-level containers. |
| `chat` | 28px | Chat surfaces. Tracks `page`. |
| `full` | 9999px | A pill or a circle. Also fixed. |

## Nesting

A rounded thing inside another rounded thing wants a tighter radius, or the gap between the two curves reads as a mistake. The scale is built for that: each level is one step in, so the rule is "use the token for the level you are at" rather than arithmetic at the call site.

```dart
class ShapeNestingExample extends StatelessWidget {
  const ShapeNestingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Three steps of the scale, nested in the order they are meant to nest:
    // container outside, element inside it, inner innermost. Each step is one
    // notch tighter than the one around it, so the curves stay concentric.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxText('container · card', type: AstryxTextType.label),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundMuted),
              borderRadius: theme.borderRadius(AstryxRadiusToken.element),
              border: Border.all(color: theme.color(AstryxColorToken.border)),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxText(
                    'element · button, input',
                    type: AstryxTextType.supporting,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.color(AstryxColorToken.backgroundCard),
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.inner,
                      ),
                      border: Border.all(
                        color: theme.color(AstryxColorToken.border),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        theme.spacing(AstryxSpacingToken.spacing2),
                      ),
                      child: const AstryxText(
                        'inner · a chip inside it',
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```


## Reading one

```dart
final theme = AstryxTheme.of(context);

theme.radius(AstryxRadiusToken.container);        // 12.0
theme.borderRadius(AstryxRadiusToken.container);  // BorderRadius
```

`radius` gives the bare number, for a `BoxConstraints` or a painter; `borderRadius` gives the `BorderRadius` a `BoxDecoration` wants. Most components resolve their own, so this is for the widget the design system has no equivalent of.

## Scaling the whole set

Radius expands from a base unit and a multiplier: every scalable token is `base × step × multiplier`, rounded to whole pixels, with steps 1 (`inner`), 2 (`element`), 3 (`container`) and 7 (`page` and `chat`). `none` and `full` are anchors and never move.

```dart
// The default scale.
const AstryxRadiusScaleConfig(base: 4, multiplier: 1);

// Sharp and brutalist — every scalable radius becomes 0.
const AstryxRadiusScaleConfig(base: 4, multiplier: 0);

// Softer, without touching the pill or the square.
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    radius: AstryxRadiusScaleConfig(base: 4, multiplier: 2),
  ),
);
```

Upstream documents the multiplier’s range as 0–2. Because the whole set moves together, a theme can go square or go soft without any component learning about it.

## Related

- [Theming](theming.md) — where a radius configuration goes.
- [Elevation](elevation.md) — the other property a surface carries.
- [Design tokens](tokens.md) — the other token families.

