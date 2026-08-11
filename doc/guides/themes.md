---
title: Themes
description: The eight themes side by side, and the same components rendered in each.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Seven themes ship with the package. The eighth, *acme*, is defined in this site’s own example code from a single hex accent — it is in the gallery deliberately, because a theme the engine generated should be indistinguishable from the seven that were tuned by hand.

Every cell below paints its own page background. Nothing in them is configured twice: one `AstryxThemeProvider` per cell, and the widgets inside resolve whatever the theme above them says.

```dart
class ThemesGalleryExample extends StatelessWidget {
  const ThemesGalleryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxThemeProvider(
            theme: theme,
            // Each cell paints its own page background rather than borrowing
            // the site's: `--color-background-body` is the first thing that
            // separates one theme from the next, and a gallery that hides it
            // would be comparing seven cards on one page.
            child: Builder(
              builder: (context) {
                final t = AstryxTheme.of(context);

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.color(AstryxColorToken.backgroundBody),
                    borderRadius: t.borderRadius(AstryxRadiusToken.container),
                    border: Border.all(
                      color: t.color(AstryxColorToken.border),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      t.spacing(AstryxSpacingToken.spacing3),
                    ),
                    child: AstryxVStack(
                      gap: AstryxSpacingToken.spacing2,
                      align: AstryxStackAlign.stretch,
                      children: <Widget>[
                        AstryxHeading(name, level: 4),
                        const AstryxText(
                          'Body copy, on the page.',
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                        ),
                        AstryxButton(
                          label: 'Primary',
                          variant: AstryxButtonVariant.primary,
                          size: AstryxButtonSize.sm,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
```


## What actually differs

| Theme | Accent — light · dark | Type: base · ratio | Corners: element / container |
| --- | --- | --- | --- |
| `neutral` | `#262626` · `#ebebeb` | 14px · 1.2 | 10px / 12px |
| `matcha` | `#3E481D` · `#C0CBA9` | 16px · 1.25 | 12px / 18px |
| `stone` | `#25252a` · `#f3f3f5` | 14px · 1.25 | 8px / 12px |
| `gothic` | `#E8F1F6` — one value, both modes | 16px · 1.25 | 8px / 12px |
| `chocolate` | `#8C5927` · `#d4a06a` | 14px · 1.2 | 10px / 12px |
| `y2k` | `#2d241b` · `#EDEFFC` | 16px · 1.25 | 0 / 0 |
| `butter` | `#225BFF` · `#FDEE8C` | 14px · 1.25 | 8px / 12px |
| `acme` | `#0F62FE`, derived | the engine defaults | base 2, multiplier 2 |

Motion differs too, quietly: `gothic` is slower than the rest (150 / 350 / 800ms), `y2k` faster (100 / 250 / 600ms), and everything else runs 125 / 300 / 700ms. Under reduced motion all eight are identical, because the durations collapse. See [Motion](motion.md).

> **Note**
>
> The themes name real typefaces — Figtree, DM Sans, Playwrite US Trad, Fraunces, Montserrat, Poppins, Outfit, Fustat, JetBrains Mono — and the package bundles **none** of them, exactly as upstream ships no font files. Each falls through its stack to the platform’s own UI font until you add the family to your `pubspec.yaml`. What you see below is therefore the size, the weight and the rhythm, not the face. See [Typography](typography.md).

## Light and dark are one definition

A colour token is not a colour: it is a `light-dark()` pair, and the mode picks a half. Dark is not a second theme to maintain, which is why both halves of all eight fit on one page.

```dart
class ThemesLightDarkExample extends StatelessWidget {
  const ThemesLightDarkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(name, type: AstryxTextType.label),
              // A colour token is not a colour: it is a `light-dark()` pair,
              // and the mode picks a half. Both halves come from the one
              // definition — dark mode is not a second theme to maintain.
              for (final mode in <AstryxColorMode>[
                AstryxColorMode.light,
                AstryxColorMode.dark,
              ])
                AstryxThemeProvider(
                  theme: theme,
                  mode: mode,
                  child: Builder(
                    builder: (context) {
                      final t = AstryxTheme.of(context);

                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: t.color(AstryxColorToken.backgroundBody),
                          border: Border.all(
                            color: t.color(AstryxColorToken.border),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            t.spacing(AstryxSpacingToken.spacing2),
                          ),
                          child: AstryxHStack(
                            gap: AstryxSpacingToken.spacing2,
                            children: <Widget>[
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: t.color(AstryxColorToken.accent),
                                  borderRadius: t.borderRadius(
                                    AstryxRadiusToken.inner,
                                  ),
                                ),
                                child: const SizedBox(width: 18, height: 18),
                              ),
                              AstryxText(
                                mode.name,
                                type: AstryxTextType.supporting,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
```


`gothic` is the exception worth noticing: its tokens are single values rather than pairs, so it renders the same in either mode. That is upstream’s decision, reproduced — a theme is allowed to have an opinion about brightness.

## The tokens underneath

Six of the seventy-nine colour tokens, sampled from inside each theme — left to right: `accent`, `backgroundBody`, `backgroundCard`, `border`, `success` and `error`. The two statuses barely move: green means success in every theme, so they are convention-bound rather than derived from the accent.

```dart
class ThemesSwatchesExample extends StatelessWidget {
  const ThemesSwatchesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          Row(
            children: <Widget>[
              SizedBox(
                width: 84,
                child: AstryxText(
                  name,
                  type: AstryxTextType.code,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
              // The swatches resolve inside the theme they belong to. Reading a
              // token is the only way to sample one: the values live in the
              // resolved token set, not in a constant anybody can import.
              Expanded(
                child: AstryxThemeProvider(
                  theme: theme,
                  child: Builder(
                    builder: (context) {
                      final t = AstryxTheme.of(context);

                      return Row(
                        children: <Widget>[
                          for (final token in gallerySwatchTokens)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: t.color(token),
                                    borderRadius: t.borderRadius(
                                      AstryxRadiusToken.inner,
                                    ),
                                    border: Border.all(
                                      color: t.color(AstryxColorToken.border),
                                    ),
                                  ),
                                  child: const SizedBox(height: 24),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


There is no way to read a theme’s values except through the resolved token set — `theme.color(token)` inside the provider. That is the same route every component takes, and the reason a theme swap cannot miss one. See [Design tokens](tokens.md).

## The same controls, eight times

Nothing in this example names a colour, a radius or a size. The four controls are identical in all eight cells; everything that changes between them was resolved from the provider above.

```dart
class ThemesComponentsExample extends StatelessWidget {
  const ThemesComponentsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 250,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxThemeProvider(
            theme: theme,
            // The same four controls, eight times. Nothing below this line
            // names a colour, a radius or a size: every one of them is a token
            // the provider above resolved.
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(name, type: AstryxTextType.label),
                  AstryxTextInput(
                    label: 'Service',
                    placeholder: 'api-gateway',
                    size: AstryxInputSize.sm,
                    onChanged: (_) {},
                  ),
                  AstryxSwitch(
                    label: 'Alert on failure',
                    value: true,
                    size: AstryxToggleSize.sm,
                    onChanged: (_) {},
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxButton(
                        label: 'Deploy',
                        variant: AstryxButtonVariant.primary,
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                      AstryxIconButton(
                        icon: AstryxIconName.moreHorizontal,
                        label: 'More',
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```


## Choosing one

- **`neutral`** — the default, and the one the components were designed against. Start here.
- **`stone`** — the same restraint with tighter corners and a larger type ratio. The most "internal tool" of the seven.
- **`gothic`** — a fixed dark palette. For a tool that lives on a wall or beside a terminal.
- **`matcha`**, **`chocolate`** — a serif or script heading face against a sans body. Warmer, and the roundest corners in the set.
- **`y2k`** — every radius is zero. Nothing else in the package makes that as visible.
- **`butter`** — a blue accent in light, a yellow one in dark. The loudest, and a good test of whether your screens survive a theme they were not drawn for.

> **Careful**
>
> Switch this page to `stone` and the error foregrounds go blank: upstream sets `--color-on-error` equal to `--color-error`, a 1.00:1 contrast failure, and the port reproduces it rather than quietly correcting it. Pinned by a test, overridable in one line. See [Colour](color.md).

## Or define your own

One hex accent is enough. `defineTheme` runs the same HCT derivation the TypeScript version does, so a theme defined in Dart resolves to the values React would produce — including the `--color-on-*` foregrounds that keep text legible.

```dart
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
    radius: AstryxRadiusScaleConfig(base: 2, multiplier: 2),
  ),
);
```

That is the `acme` in the picker above, and in every gallery on this page. [Theming](theming.md) covers the rest: extending a theme, overriding individual tokens, and swapping the icon registry.

## Related

- [Theming](theming.md) — how a theme is defined and installed.
- [Design tokens](tokens.md) — what a theme resolves to.
- [Colour](color.md) — the seventy-nine tokens, and what is guaranteed.
- [Theme showcase](../components/theme_showcase.md) — one of every component, on one screen, for judging a theme.

