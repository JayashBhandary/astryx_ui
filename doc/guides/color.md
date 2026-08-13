---
title: Colour
description: 'The colour system: the families, the semantic roles, and which one to reach for.'
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Seventy-nine colour tokens: thirty-nine semantic, and ten categorical families of four. Not one of them is named after a hue, because the name has to survive a theme change — `backgroundCard` is still the card background when the theme is `chocolate` and the card is brown.

## Roles, not colours

```dart
class ColorRolesExample extends StatelessWidget {
  const ColorRolesExample({super.key});

  /// The semantic tokens, grouped by the job they do rather than by hue.
  ///
  /// A token is chosen by what it is *for* — the surface a card sits on, the
  /// line that bounds a control — which is why none of them is named after a
  /// colour.
  static const List<(String, List<AstryxColorToken>)> _groups =
      <(String, List<AstryxColorToken>)>[
        (
          'Surfaces',
          <AstryxColorToken>[
            AstryxColorToken.backgroundBody,
            AstryxColorToken.backgroundSurface,
            AstryxColorToken.backgroundCard,
            AstryxColorToken.backgroundMuted,
            AstryxColorToken.backgroundInverted,
          ],
        ),
        (
          'Text and icon',
          <AstryxColorToken>[
            AstryxColorToken.textPrimary,
            AstryxColorToken.textSecondary,
            AstryxColorToken.textDisabled,
            AstryxColorToken.textAccent,
            AstryxColorToken.iconSecondary,
          ],
        ),
        (
          'Lines and fills',
          <AstryxColorToken>[
            AstryxColorToken.border,
            AstryxColorToken.borderEmphasized,
            AstryxColorToken.skeleton,
            AstryxColorToken.track,
            AstryxColorToken.tintHover,
          ],
        ),
        (
          'Sentiment',
          <AstryxColorToken>[
            AstryxColorToken.accent,
            AstryxColorToken.success,
            AstryxColorToken.warning,
            AstryxColorToken.error,
            AstryxColorToken.errorMuted,
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (title, tokens) in _groups)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(title, type: AstryxTextType.label),
                for (final token in tokens)
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color(token),
                          borderRadius: theme.borderRadius(
                            AstryxRadiusToken.inner,
                          ),
                          border: Border.all(
                            color: theme.color(AstryxColorToken.border),
                          ),
                        ),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                      Flexible(
                        child: AstryxText(
                          token.name,
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
```


| Family | Reach for it when |
| --- | --- |
| `background*` | Painting a surface: the page, a card, a popover, a muted well, an inverted panel. |
| `text*`, `icon*` | Content on one of those surfaces — though a widget’s own `color:` parameter is usually the better route. |
| `border`, `borderEmphasized` | A boundary. `border` is decorative; `borderEmphasized` outlines a form control and is held to 3:1. |
| `accent`, `success`, `warning`, `error` | A fill that means something. Each has a `*Muted` tint for a background and an `on*` foreground for content. |
| `skeleton`, `track`, `overlay`, `shadow` | The machinery: a loading block, a progress trough, a scrim behind a dialog, the colour a shadow is built from. |

## Never choose a foreground

Every fill that carries content has an `on*` partner, derived from it. Pairing them is the whole contract: change the accent and `onAccent` moves with it, so a label that was legible stays legible.

```dart
class ColorOnPairsExample extends StatelessWidget {
  const ColorOnPairsExample({super.key});

  /// Each fill and the foreground that is guaranteed to read on it.
  static const List<(AstryxColorToken, AstryxColorToken)> _pairs =
      <(AstryxColorToken, AstryxColorToken)>[
        (AstryxColorToken.accent, AstryxColorToken.onAccent),
        (AstryxColorToken.success, AstryxColorToken.onSuccess),
        (AstryxColorToken.warning, AstryxColorToken.onWarning),
        (AstryxColorToken.error, AstryxColorToken.onError),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Never choose the foreground yourself. Each `--color-on-*` token is
    // derived from its fill, so it stays legible when the accent changes.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final (fill, on) in _pairs)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(fill),
              borderRadius: theme.borderRadius(AstryxRadiusToken.element),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(AstryxSpacingToken.spacing3),
                vertical: theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: Text(
                on.name,
                style: theme
                    .textStyle(AstryxTypeRole.label)
                    .copyWith(color: theme.color(on)),
              ),
            ),
          ),
      ],
    );
  }
}
```


`onDark` and `onLight` are the same idea for content that sits on an inverted surface — a dark toast, a tooltip — where the page’s own text colours would be the wrong way round.

## Light and dark are one token

A colour token is not a colour: it is a `light-dark()` pair, and the brightness picks a half. That is why dark mode is not a second theme to maintain, and why `AstryxColorMode.system` can follow the platform without anything above it rebuilding.

## The ten categorical families

```dart
class ColorPalettesExample extends StatelessWidget {
  const ColorPalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Ten families, four tokens each. They name a category — a team, a label,
    // a series in a chart — and never a severity.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxBadge(
            palette.name,
            variant: AstryxBadgeVariant.palette(palette),
          ),
      ],
    );
  }
}
```


These are the palettes upstream did the most colour work on: every one passes WCAG AA in both modes, on its own tinted background. They are reproduced exactly and must not be adjusted — a nicer blue here is a contrast failure somewhere.

**Four tokens per family, on `AstryxPalette`**

| Token | For |
| --- | --- |
| `background` | The tinted fill. |
| `border` | The border that goes with that fill. |
| `text` | Text that reads on it. |
| `icon` | An icon that reads on it. |

Reach for them through a component — `AstryxBadgeVariant.palette(AstryxPalette.teal)`, the same on `AstryxCardVariant` — rather than reading the four tokens yourself.

> **Accessibility**
>
> Categorical means *category*: a team, a label, an environment, a series in a chart. Never severity. `AstryxPalette.red` to mean "failed" leaves a colour-blind reader with nothing, and bypasses the `error` tokens that exist for it.

## What is guaranteed

- **Text clears 4.5:1** (WCAG 1.4.3) by tone spacing alone. HCT tone is CIE L*, which fixes relative luminance regardless of hue or chroma, so the guarantee holds for any accent and any neutral style.
- **`borderEmphasized` clears 3:1** (WCAG 1.4.11). It outlines form controls, so it is a non-text boundary; the engine tone-bumps it until it gets there.
- **`border`, `skeleton` and `track` are not.** They are decoration or a redundant cue, deliberately below 3:1 — which is why none of them may be a control’s only visible boundary.

## Deriving a palette from one colour

One hex seed is enough. `expandColorScale` runs the same HCT derivation the React version does, so the tokens it generates match value for value.

```dart
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(
      accent: '#0F62FE',
      neutralStyle: AstryxNeutralStyle.warm,
      contrast: AstryxContrastLevel.standard,
    ),
  ),
);
```

| Option | Does |
| --- | --- |
| `accent` | The seed, as `#RRGGBB`. Omit it and the neutrals are seeded from the default accent’s hue while the three accent tokens keep their defaults. |
| `neutralStyle` | How much of the seed hue bleeds into the neutrals — `warm`, `cool` (the default) or `neutral`, in descending chroma. |
| `contrast` | `standard`, or `high` to push text tones to the extremes. |

Three things are deliberately *not* derived from the seed: the status colours, the categorical hues, and the `onDark`/`onLight` pair. They are convention-bound — green means success in every theme — so they fall through to the token defaults instead.

> **Careful**
>
> Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error`, a 1.00:1 failure. Switch this page to `stone` and the `onError` chip above goes blank. It is reproduced rather than corrected, and pinned by a test; override the token if it reaches you. See [Accessibility](accessibility.md).

## Related

- [Design tokens](tokens.md) — the other token families.
- [Theming](theming.md) — where a colour configuration goes.
- [AstryxBadge](../components/badge.md) — the categorical palettes in use.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Colour&component=Docs%3A+Colour) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Colour&area=Docs%3A+Colour) — both templates arrive with the page filled in.
