---
title: Theming
description: Seven themes, two brightnesses, and an engine for your own.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

## The prebuilt themes

A theme is a value, not a global. Nesting a provider re-themes a subtree — which is how the preview below shows eight at once.

```dart
class ThemingThemesExample extends StatelessWidget {
  const ThemingThemesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every theme is a value. Nesting a provider re-themes a subtree, which is
    // how a preview like this one can show all seven at once.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final theme in <(String, AstryxDefinedTheme)>[
          ('neutral', neutralTheme),
          ('matcha', matchaTheme),
          ('stone', stoneTheme),
          ('gothic', gothicTheme),
          ('chocolate', chocolateTheme),
          ('y2k', y2kTheme),
          ('butter', butterTheme),
          ('acme (custom)', acmeTheme),
        ])
          AstryxThemeProvider(
            theme: theme.$2,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(theme.$1, type: AstryxTextType.label),
                  AstryxButton(
                    label: 'Primary',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  const AstryxHStack(
                    gap: AstryxSpacingToken.spacing1,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxBadge('A', variant: AstryxBadgeVariant.info),
                      AstryxBadge('B', variant: AstryxBadgeVariant.success),
                      AstryxBadge('C', variant: AstryxBadgeVariant.error),
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


```dart
AstryxThemeProvider(
  theme: matchaTheme,
  mode: AstryxColorMode.system,
  child: const HomePage(),
)
```

## Light and dark

`mode` defaults to `system`, which follows the platform’s own preference through `MediaQuery` — the theme tracks a change without your app rebuilding anything.

```dart
class ThemingModesExample extends StatelessWidget {
  const ThemingModesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `mode` defaults to `system`, which tracks the platform's own preference
    // through `MediaQuery` — no rebuild of your own required.
    return AstryxGrid(
      minWidth: 200,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final mode in <AstryxColorMode>[
          AstryxColorMode.light,
          AstryxColorMode.dark,
        ])
          AstryxThemeProvider(
            mode: mode,
            child: Builder(
              builder: (context) => ColoredBox(
                color: AstryxTheme.of(
                  context,
                ).color(AstryxColorToken.backgroundBody),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxText(mode.name, type: AstryxTextType.label),
                      const AstryxText(
                        'Body copy on the page background.',
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
              ),
            ),
          ),
      ],
    );
  }
}
```


## A custom theme

Themes are *defined*, not hard-coded. `defineTheme` runs the same expansion the React version does — the HCT colour model, the type, radius and motion scales, the derived-variable registry — so a theme defined here and the same theme defined in TypeScript produce identical token values.

```dart
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
    radius: AstryxRadiusScaleConfig(base: 2, multiplier: 2),
  ),
);
```

One hex accent is enough: the engine derives the full palette from it, including the `--color-on-*` foregrounds that guarantee contrast. The "Acme" entry in the theme picker at the top of this page is exactly that definition — pick it and every component on the site re-themes.

Everything else is optional and layered. `extendsTheme` starts from another theme; `tokens` overrides individual CSS custom properties and beats every generated value; `components` carries per-component style overrides; `icons` swaps the registry.

```dart
final acmeDense = defineTheme(
  AstryxDefineThemeInput(
    name: 'acme-dense',
    extendsTheme: acmeTheme,
    tokens: <String, AstryxTokenValue>{
      '--spacing-4': AstryxTokenValue('12px'),
    },
  ),
);
```

## Reaching a token directly

For a chart library, a custom painter, or a widget the design system does not cover.

```dart
final theme = AstryxTheme.of(context);

final accent = theme.color(AstryxColorToken.accent);
final gap = theme.spacing(AstryxSpacingToken.spacing3);
final radius = theme.borderRadius(AstryxRadiusToken.container);
final style = theme.textStyle(AstryxTypeRole.body);
```

> **Note**
>
> If you only need tokens and theme types, import `package:astryx_ui/theme.dart` instead of the full surface. It is the same theme layer without any widgets.

## Icons

The registry maps semantic names to glyphs — Lucide by default, matching upstream. Install your own and every `AstryxIcon` in the app follows, with no call site changing.

```dart
AstryxThemeProvider(
  // From `defaults`, so the names you do not list still resolve.
  icons: AstryxIconRegistry.defaults.copyWith(
    const <AstryxIconName, IconData>{
      AstryxIconName.search: MyIcons.search,
    },
  ),
  child: const HomePage(),
)
```

## Related

- [Design tokens](tokens.md) — what a theme resolves to.
- [Icons](icons.md) — the registry, and the rule above.
- [Styling](styling.md) — the narrower escape hatches.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Theming&component=Docs%3A+Theming) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Theming&area=Docs%3A+Theming) — both templates arrive with the page filled in.
