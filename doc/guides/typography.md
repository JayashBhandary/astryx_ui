---
title: Typography
description: The type scale, the roles, and how a heading level maps onto them.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Nothing in the package names a font size. Text asks for a **role**, and a role is a size, a weight and a line height that travel together — fourteen roles, three properties each, forty-two tokens.

```dart
class TypographyRolesExample extends StatelessWidget {
  const TypographyRolesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Fourteen roles. Each one is a size, a weight and a line height together —
    // ask for the role and the three cannot come apart.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final role in AstryxTypeRole.values)
          Builder(
            builder: (context) {
              final style = theme.textStyle(role);

              return AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.end,
                children: <Widget>[
                  SizedBox(
                    width: 92,
                    child: AstryxText(
                      role.name,
                      type: AstryxTextType.code,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: 76,
                    child: AstryxText(
                      '${style.fontSize?.round()}px · '
                      '${style.fontWeight?.value}',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'The quick brown fox',
                      style: style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
```


| Role | Size | Weight | For |
| --- | --- | --- | --- |
| `display1` … `display3` | `5xl` … `3xl` | normal | Hero text and marketing-scale numbers. Rare inside a tool. |
| `heading1` … `heading6` | `2xl` … `xs` | semibold | The document outline. `heading4` sits at the base size. |
| `large` | `lg` | semibold | Body copy one step up. |
| `body` | `base` | normal | The default. |
| `label` | `base` | medium | Form and control labels. |
| `supporting` | `sm` | normal | Hints, captions, helper text. |
| `code` | `base` | normal | Inline and block code, in the code family. |

## In use

`AstryxText` takes a `type`; `AstryxHeading` takes a `level`, which is both the size and the level announced to assistive technology.

```dart
class TypographyInContextExample extends StatelessWidget {
  const TypographyInContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The roles doing their jobs. Nothing here names a size: the heading takes
    // a level, everything else takes a type.
    return AstryxCard(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Deployment failed', level: 3),
          const AstryxText(
            'The build finished, but the health check never went green. '
            'Nothing was promoted.',
          ),
          const AstryxText('Exit code', type: AstryxTextType.label),
          const AstryxText('137 — out of memory', type: AstryxTextType.code),
          const AstryxText(
            'Retried twice. Last attempt 4 minutes ago.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(label: 'Retry', onPressed: () {}),
              AstryxButton(
                label: 'View log',
                variant: AstryxButtonVariant.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


```dart
const AstryxHeading('Deployment failed', level: 3)
const AstryxText('137 — out of memory', type: AstryxTextType.code)

// Building something the widget set has no widget for:
final theme = AstryxTheme.of(context);
final style = theme.textStyle(AstryxTypeRole.supporting);
final h2 = theme.headingStyle(2);
```

> **Accessibility**
>
> Do not skip a heading level to get a size. `AstryxHeading.type` changes the size while `level` keeps the outline honest, and `accessibilityLevel` overrides the announced level alone for the rare case where the two genuinely differ. See [AstryxHeading](../components/heading.md).

## Where the sizes come from

The twelve raw sizes — `--font-size-4xs` through `--font-size-5xl` — are a geometric progression, `size = base × ratio^step`, rounded to whole pixels and emitted in `rem` against a 16px root. The semantic tokens then reference them, which is why moving the base moves the whole scale in step.

**What each prebuilt theme sets**

| Themes | Base | Ratio |
| --- | --- | --- |
| neutral, chocolate | 14px | 1.2 |
| stone, butter | 14px | 1.25 |
| matcha, gothic, y2k | 16px | 1.25 |

Line heights are computed rather than chosen: a target ratio tiered by size — 1.5 below 20px, 1.4 from 20 to 31px, 1.25 at 32px and above — snapped so the resulting pixel height lands on a 4px grid, with a floor of `size + 4`. That snapping is why the emitted ratios look irrational: 1.4286, 1.4118.

## Three families

Body, heading and code. Headings inherit the body family unless they name their own, and the defaults are **system font stacks** — Astryx bundles no typeface, and neither does this port. A stack that leads with `-apple-system` resolves to a null Flutter family, which is correct rather than missing: Flutter’s default already is the platform’s UI font.

## A custom type scale

```dart
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    typography: AstryxTypographyConfig(
      scale: AstryxTypeScaleSpec(base: 15, ratio: 1.25),
      body: AstryxTypographyRole(
        family: 'Geist',
        fallbacks: '-apple-system, sans-serif',
      ),
      heading: AstryxTypographyRole(weight: AstryxFontWeight.bold),
      code: AstryxTypographyRole(family: 'Geist Mono'),
    ),
  ),
);
```

> **Note**
>
> Setting a family does not load it. Register the font with Flutter as you normally would — `pubspec.yaml` or `google_fonts` — and the token picks it up once it is available.

## Related

- [AstryxText](../components/text.md) — the types, and the `style` escape hatch.
- [AstryxHeading](../components/heading.md) — levels, display sizes, and the outline.
- [Design tokens](tokens.md) — the other token families.

