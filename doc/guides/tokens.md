---
title: Design tokens
description: The values every component resolves through.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

No component holds a colour, a length or a duration. Every one is a token, resolved from the theme at build time — which is what makes eight themes, two brightnesses and a custom accent a configuration change rather than a rewrite.

**The token families**

| Family | Enum | Read with |
| --- | --- | --- |
| Colour | `AstryxColorToken` | `theme.color(token)` |
| Spacing | `AstryxSpacingToken` | `theme.spacing(token)` |
| Size | `AstryxSizeToken` | `theme.size(token)` |
| Radius | `AstryxRadiusToken` | `theme.radius(token)` / `theme.borderRadius(token)` |
| Border | `AstryxBorderToken` | `theme.borderWidth()` |
| Shadow | `AstryxShadowToken` | `theme.shadow(token)` / `theme.boxShadows(token)` |
| Type | `AstryxTypeRole` | `theme.textStyle(role)` / `theme.headingStyle(level)` |
| Text size | `AstryxTextSizeToken` | `theme.textSize(token)` |
| Font weight | `AstryxFontWeightToken` | `theme.fontWeight(token)` |
| Duration | `AstryxDurationToken` | `theme.duration(token)` |
| Easing | `AstryxEaseToken` | `theme.ease(token)` |

## Colour

Seventy-nine colour tokens: the semantic set, the `--color-on-*` foregrounds that guarantee contrast against them, and four tokens for each of the ten categorical families. A sample, and [Colour](color.md) for the rest:

```dart
class ThemingTokensExample extends StatelessWidget {
  const ThemingTokensExample({super.key});

  /// The tokens a page reaches for most often. There are 100-odd in total.
  static const List<AstryxColorToken> _tokens = <AstryxColorToken>[
    AstryxColorToken.accent,
    AstryxColorToken.accentMuted,
    AstryxColorToken.backgroundBody,
    AstryxColorToken.backgroundSurface,
    AstryxColorToken.backgroundCard,
    AstryxColorToken.backgroundMuted,
    AstryxColorToken.border,
    AstryxColorToken.borderEmphasized,
    AstryxColorToken.success,
    AstryxColorToken.warning,
    AstryxColorToken.error,
    AstryxColorToken.backgroundInverted,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 180,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final token in _tokens)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(token),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
                  border: Border.all(
                    color: theme.color(AstryxColorToken.border),
                  ),
                ),
                child: const SizedBox(width: 24, height: 24),
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
    );
  }
}
```


## Spacing

Fifteen steps. Components name a step; they never write a number.

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


## Type

Fourteen roles, each pairing a size, a weight and a line height. Ask for a role, not a size — that is what keeps two pieces of body copy identical.

```dart
class ThemingTypeScaleExample extends StatelessWidget {
  const ThemingTypeScaleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final role in AstryxTypeRole.values)
          AstryxHStack(
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
              Flexible(
                child: Text(
                  'The quick brown fox',
                  style: theme.textStyle(role),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


## Motion

Durations and curves are tokens too, and every animation in the package goes through `AstryxMotion`, which honours `MediaQuery.disableAnimations`. Under reduced motion transitions become instantaneous and the two looping indicators — the spinner and the indeterminate progress bar — settle into a static state rather than disappearing.

```dart
final motion = AstryxMotion.of(context);

AnimatedContainer(
  duration: motion.duration(AstryxDurationToken.fast),
  curve: motion.curve(),
  // …
)
```

> **Note**
>
> The token names are the upstream CSS custom properties, one for one: `AstryxColorToken.backgroundCard` is `--color-background-card`. When in doubt, the enum value’s own documentation names the property.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Design+tokens&component=Docs%3A+Design+tokens) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Design+tokens&area=Docs%3A+Design+tokens) — both templates arrive with the page filled in.
