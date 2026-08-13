# Getting started

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## astryx_ui

A Flutter design system for internal tools, token-compatible with Astryx.

**Rules**

- **Careful:** Pre-alpha. Until 0.1.0 the API may change without a major version bump, so pin an exact version if that matters to you.

---

## Installation

Add the package, wrap your app once, and you are done.

```dart
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);
```

| Import | Gives you |
| --- | --- |
| `package:astryx_ui/astryx_ui.dart` | Everything: the theme layer and every component. |
| `package:astryx_ui/theme.dart` | Tokens, `AstryxThemeData` and the engine, with no widgets — for a chart library, a custom painter, or a test. |

---

## Principles

What the design system optimises for, and the decisions that follow from it.

**Rules**

- **Note:** Everything upstream ships that is not ported yet still has a page here, marked *Soon* in the sidebar. A missing route is indistinguishable from a component nobody has thought about; a placeholder says which one this is.

---

## Theming

Seven themes, two brightnesses, and an engine for your own.

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

**Rules**

- **Note:** If you only need tokens and theme types, import `package:astryx_ui/theme.dart` instead of the full surface. It is the same theme layer without any widgets.

---

## Design tokens

The values every component resolves through.

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

**Rules**

- **Note:** The token names are the upstream CSS custom properties, one for one: `AstryxColorToken.backgroundCard` is `--color-background-card`. When in doubt, the enum value’s own documentation names the property.

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

---

## Colour

The colour system: the families, the semantic roles, and which one to reach for.

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

**Rules**

- **Accessibility:** Categorical means *category*: a team, a label, an environment, a series in a chart. Never severity. `AstryxPalette.red` to mean "failed" leaves a colour-blind reader with nothing, and bypasses the `error` tokens that exist for it.
- **Careful:** Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error`, a 1.00:1 failure. Switch this page to `stone` and the `onError` chip above goes blank. It is reproduced rather than corrected, and pinned by a test; override the token if it reaches you. See Accessibility (references/guides.md).

| Family | Reach for it when |
| --- | --- |
| `background*` | Painting a surface: the page, a card, a popover, a muted well, an inverted panel. |
| `text*`, `icon*` | Content on one of those surfaces — though a widget’s own `color:` parameter is usually the better route. |
| `border`, `borderEmphasized` | A boundary. `border` is decorative; `borderEmphasized` outlines a form control and is held to 3:1. |
| `accent`, `success`, `warning`, `error` | A fill that means something. Each has a `*Muted` tint for a background and an `on*` foreground for content. |
| `skeleton`, `track`, `overlay`, `shadow` | The machinery: a loading block, a progress trough, a scrim behind a dialog, the colour a shadow is built from. |

**Four tokens per family, on `AstryxPalette`**

| Token | For |
| --- | --- |
| `background` | The tinted fill. |
| `border` | The border that goes with that fill. |
| `text` | Text that reads on it. |
| `icon` | An icon that reads on it. |

| Option | Does |
| --- | --- |
| `accent` | The seed, as `#RRGGBB`. Omit it and the neutrals are seeded from the default accent’s hue while the three accent tokens keep their defaults. |
| `neutralStyle` | How much of the seed hue bleeds into the neutrals — `warm`, `cool` (the default) or `neutral`, in descending chroma. |
| `contrast` | `standard`, or `high` to push text tones to the extremes. |

---

## Typography

The type scale, the roles, and how a heading level maps onto them.

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

**Rules**

- **Accessibility:** Do not skip a heading level to get a size. `AstryxHeading.type` changes the size while `level` keeps the outline honest, and `accessibilityLevel` overrides the announced level alone for the rare case where the two genuinely differ. See AstryxHeading (references/layout.md).
- **Note:** Setting a family does not load it. Register the font with Flutter as you normally would — `pubspec.yaml` or `google_fonts` — and the token picks it up once it is available.

| Role | Size | Weight | For |
| --- | --- | --- | --- |
| `display1` … `display3` | `5xl` … `3xl` | normal | Hero text and marketing-scale numbers. Rare inside a tool. |
| `heading1` … `heading6` | `2xl` … `xs` | semibold | The document outline. `heading4` sits at the base size. |
| `large` | `lg` | semibold | Body copy one step up. |
| `body` | `base` | normal | The default. |
| `label` | `base` | medium | Form and control labels. |
| `supporting` | `sm` | normal | Hints, captions, helper text. |
| `code` | `base` | normal | Inline and block code, in the code family. |

**What each prebuilt theme sets**

| Themes | Base | Ratio |
| --- | --- | --- |
| neutral, chocolate | 14px | 1.2 |
| stone, butter | 14px | 1.25 |
| matcha, gothic, y2k | 16px | 1.25 |

---

## Spacing

The spacing scale, and the rule that gaps come from tokens rather than magic numbers.

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

**Rules**

- **Careful:** A `SizedBox(height: 12)` between two children is the one to watch for. It looks identical today and is invisible to every theme, density and direction change afterwards.
- **Note:** Spacing does not move with density (references/guides.md). Touch grows the region that responds to a finger, not the layout around it — so a form does not reflow when someone plugs in a mouse.

**Which step**

| Step | Usually |
| --- | --- |
| `spacing0_5`, `spacing1` | Inside a control — a glyph and its label, a badge’s padding. |
| `spacing2` | Between related controls. The most-used step in the package. |
| `spacing3` | Between the rows of a group or a form. |
| `spacing4` | A card’s padding — its default. |
| `spacing6` and up | Between the sections of a page, where the gap does the grouping. |

---

## Shape

Corner radii and how they compose when surfaces nest.

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

---

## Elevation

The elevation levels, what each is for, and how they read in dark mode.

```dart
class ElevationShadowsExample extends StatelessWidget {
  const ElevationShadowsExample({super.key});

  /// The three drop shadows, and what sits at each.
  static const List<(AstryxShadowToken, String)> _steps =
      <(AstryxShadowToken, String)>[
        (AstryxShadowToken.low, 'popover, tooltip, menu'),
        (AstryxShadowToken.med, 'toast, selector list'),
        (AstryxShadowToken.high, 'dialog'),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        for (final (token, uses) in _steps)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundPopover),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              boxShadow: theme.boxShadows(token),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing4),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(token.name, type: AstryxTextType.label),
                  AstryxText(
                    uses,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
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

**Rules**

- **Note:** Shadow is a separation cue, never the only one. Every elevated surface in the package also carries a background and a border, because a shadow is invisible to a screen reader, thin at high contrast, and nearly gone on a low-quality display.

| Token | Where it is used |
| --- | --- |
| `low` | The default overlay surface — popovers, tooltips, dropdown menus. |
| `med` | Toasts, and the floating list a selector opens. |
| `high` | Dialogs, the only thing above everything else. |
| `insetHover`, `insetSelected` | A ring on a control that is hovered or chosen. No lift. |
| `insetSuccess`, `insetWarning`, `insetError` | A field’s validation state, drawn as a ring around the input. |

---

## Motion

Durations, easings, and what must not move when motion is reduced.

```dart
class MotionDurationsExample extends StatefulWidget {
  const MotionDurationsExample({super.key});

  @override
  State<MotionDurationsExample> createState() => _MotionDurationsExampleState();
}

class _MotionDurationsExampleState extends State<MotionDurationsExample> {
  /// The three bases. Each has a `-min` and a `-max` variant beside it.
  static const List<AstryxDurationToken> _bases = <AstryxDurationToken>[
    AstryxDurationToken.fast,
    AstryxDurationToken.medium,
    AstryxDurationToken.slow,
  ];

  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Durations come from `AstryxMotion`, never from the theme directly: it is
    // the layer that returns zero when the platform asks for reduced motion.
    final motion = AstryxMotion.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final token in _bases)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(
                '${token.name} · ${motion.duration(token).inMilliseconds}ms',
                type: AstryxTextType.code,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundMuted),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                ),
                child: SizedBox(
                  height: 28,
                  child: AnimatedAlign(
                    duration: motion.duration(token),
                    curve: motion.curve(),
                    alignment: _moved
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing(AstryxSpacingToken.spacing1),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color(AstryxColorToken.accent),
                          borderRadius: theme.borderRadius(
                            AstryxRadiusToken.full,
                          ),
                        ),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: _moved ? 'Send back' : 'Send across',
              onPressed: () => setState(() => _moved = !_moved),
            ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** The switch is the platform’s, read through `MediaQuery.disableAnimationsOf`. Use the device’s own reduce-motion setting to check a screen — there is nothing to turn on in the package.

| Band | Default | For |
| --- | --- | --- |
| `fastMin` · `fast` · `fastMax` | 130 · 175 · 230ms | Micro-interactions: hover, a toggle, a checkbox. |
| `mediumMin` · `medium` · `mediumMax` | 310 · 410 · 550ms | Entrances and exits: a dialog, a drawer, a panel. |
| `slowMin` · `slow` · `slowMax` | 730 · 975 · 1300ms | The long ones. Rare in a tool. |

---

## Layout

Page structure: the shell, the content column, and the breakpoints between them.

```dart
class LayoutPageExample extends StatelessWidget {
  const LayoutPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A screen is a measure, a column of sections, and a grid inside one of
    // them. There is no page widget to learn: the same four layout primitives
    // that build a card build the page around it.
    return AstryxCenter(
      axis: AstryxCenterAxis.horizontal,
      maxWidth: 760,
      paddingBlock: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing6,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            mainAxisSize: MainAxisSize.max,
            justify: AstryxStackJustify.between,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              const Flexible(
                child: AstryxHeading('Environments', level: 1),
              ),
              AstryxButton(
                label: 'New environment',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
            ],
          ),
          const AstryxDivider(),
          AstryxGrid(
            minWidth: 200,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              for (final (name, status) in const <(String, String)>[
                ('production', 'healthy'),
                ('staging', 'degraded'),
                ('preview', 'healthy'),
              ])
                AstryxCard(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxText(name, type: AstryxTextType.label),
                      AstryxBadge(
                        status,
                        variant: status == 'healthy'
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.warning,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** Every example on this site has a device picker above it for the same reason: a responsive decision is only judged by making the constraints smaller, not by reading the code.

| Primitive | Its job on a page |
| --- | --- |
| AstryxCenter (references/layout.md) | The measure. `maxWidth` stops a line of text running the width of a monitor; `paddingBlock` gives the page air. |
| AstryxVStack (references/layout.md) | The sections, with one `gap` doing the grouping. |
| AstryxHStack (references/layout.md) | A header row. `mainAxisSize: MainAxisSize.max` with `justify: between` pushes the actions to the trailing edge. |
| AstryxGrid (references/layout.md) | Tiles. `minWidth` sets the column count from the space available. |
| AstryxDivider (references/layout.md) | A rule where a gap alone is not enough. |

---

## Icons

The icon registry, the Lucide mapping, and how to supply your own set.

```dart
class IconsRegistrySwapExample extends StatelessWidget {
  const IconsRegistrySwapExample({super.key});

  /// Built from the defaults, so the 25 names not listed still resolve.
  static final AstryxIconRegistry _custom = AstryxIconRegistry.defaults
      .copyWith(const <AstryxIconName, IconData>{
        AstryxIconName.close: LucideIcons.circleX,
        AstryxIconName.check: LucideIcons.badgeCheck,
        AstryxIconName.chevronRight: LucideIcons.arrowRight,
      });

  static const List<AstryxIconName> _shown = <AstryxIconName>[
    AstryxIconName.close,
    AstryxIconName.check,
    AstryxIconName.chevronRight,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (title, registry) in <(String, AstryxIconRegistry)>[
          ('AstryxIconRegistry.defaults', AstryxIconRegistry.defaults),
          ('defaults.copyWith(…)', _custom),
        ])
          // `AstryxTheme` rather than a nested provider: this swaps the
          // registry and inherits everything else, so the theme and density
          // pickers above still reach the icons below.
          AstryxTheme(
            data: AstryxTheme.of(context),
            density: AstryxTheme.densityOf(context),
            icons: registry,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    title,
                    type: AstryxTextType.code,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing4,
                    children: <Widget>[
                      for (final name in _shown)
                        AstryxIcon(name, size: AstryxIconSize.lg),
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

**Rules**

- **Careful:** Build from `defaults` unless you mean to replace the whole set. A registry is installed wholesale, not merged: `AstryxIconRegistry(icons: {…})` with two entries has exactly two, and the twenty-six names it omits throw a `StateError` when something asks for one. `isComplete` answers whether a registry covers every name.

---

## Illustrations

The upstream illustration set, and what a Flutter port would need to carry it.

```dart
AstryxCenter(
  minHeight: 320,
  child: AstryxVStack(
    gap: AstryxSpacingToken.spacing3,
    align: AstryxStackAlign.center,
    children: <Widget>[
      const AstryxIcon(AstryxIconName.funnel, size: AstryxIconSize.lg),
      const AstryxHeading('No matching runs', level: 3),
      const AstryxText(
        'Try widening the date range, or clear the filters.',
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      AstryxButton(label: 'Clear filters', onPressed: clear),
    ],
  ),
)
```

**Rules**

- **Careful:** No illustrations ship with `astryx_ui`, and none are planned. This page is the reasoning, and the composition to use instead.
- **Accessibility:** An illustration is decoration. Wrap it in `ExcludeSemantics` and let the heading beneath it carry the meaning — an empty state announced as "image" is worse than one announced as nothing at all.

---

## Styling

Extending a component's appearance without leaving the token system.

```dart
class StylingScopesExample extends StatelessWidget {
  const StylingScopesExample({super.key});

  /// Square corners and a heavier label, as a component theme.
  ///
  /// Every field is nullable, and null means "fall through to the token
  /// default" — so this changes two things and inherits the rest.
  static const AstryxButtonTheme _squared = AstryxButtonTheme(
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Scope(
          title: 'the theme',
          note: 'Nothing overridden.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ),
        _Scope(
          title: 'one button',
          note: '`theme:` on the widget.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            theme: _squared,
            onPressed: () {},
          ),
        ),
        // Everything below inherits it — including a button three widgets deep
        // that knows nothing about this.
        AstryxTheme(
          data: AstryxTheme.of(context).copyWith(button: _squared),
          density: AstryxTheme.densityOf(context),
          icons: AstryxTheme.iconsOf(context),
          child: _Scope(
            title: 'a subtree',
            note: '`AstryxTheme` with `copyWith`.',
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Save',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                ),
                AstryxButton(label: 'Cancel', onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Scope extends StatelessWidget {
  const _Scope({required this.title, required this.note, required this.child});

  final String title;
  final String note;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(title, type: AstryxTextType.label),
          child,
          AstryxText(
            note,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** `AstryxTheme` replaces the density and icon registry rather than inheriting them, so pass both through as above. Forget them and a custom icon set quietly reverts to Lucide, and a touch device loses its 48px targets.
- **Careful:** The one thing not to do is reach past the system: a `Color(0xFF…)`, a `TextStyle(fontSize: 14)`, an `EdgeInsets.all(16)`. Each compiles, looks right in the theme you are using, and is wrong in the other seven — and in dark mode, and at the next density.

| Reach for | When |
| --- | --- |
| A widget parameter | Almost always. `variant`, `size`, `padding`, `gap` — the axes the component already has. |
| `theme:` on the widget | One instance genuinely differs. Takes that widget’s theme class. |
| `AstryxTheme` with `copyWith` | Every instance in a subtree, or in the whole app. |
| `tokens:` on the theme | The value itself is wrong for your product — a tighter radius, a different spacing step. Changes everything at once. |

| Class | Applies to | Carries |
| --- | --- | --- |
| `AstryxButtonTheme` | `AstryxButton`, `AstryxIconButton` | Backgrounds per state, foreground, border, radius, padding, gap, text style, height, icon size, shadows, cursors. |
| `AstryxTextTheme` | `AstryxText`, `AstryxHeading` | A `TextStyle` and an alignment. `text` and `heading` are separate slots on the theme. |
| `AstryxIconTheme` | `AstryxIcon` | Size and colour. |
| `AstryxDividerTheme` | `AstryxDivider` | Thickness, colour and inset. |

---

## The token engine

How a theme definition becomes resolved tokens, and where the resolution happens.

```dart
/// A definition: one seed accent, and one token set by hand.
final AstryxDefinedTheme _demoTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'engine-demo',
    color: AstryxColorScaleConfig(accent: '#B3261E'),
    tokens: <String, AstryxTokenValue>{
      '--radius-element': AstryxTokenValue('2px'),
    },
  ),
);

/// The engine's output: every token, concrete, in both modes.
///
/// Resolved once, at the top level — not per build. A theme is read far more
/// often than it changes.
final AstryxResolvedTokenSet _resolved = AstryxResolvedTokenSet.resolve(
  _demoTheme,
);

class CorePipelineExample extends StatelessWidget {
  const CorePipelineExample({super.key});

  static const List<AstryxToken> _shown = <AstryxToken>[
    // Generated from the seed.
    AstryxColorToken.accent,
    // Emitted as `var(--color-accent)`, followed by the resolver.
    AstryxColorToken.textAccent,
    // A `light-dark()` pair: one token, two halves.
    AstryxColorToken.backgroundCard,
    // Overridden by hand, beating the generated value.
    AstryxRadiusToken.element,
    // Untouched by the definition, so the token default stands.
    AstryxDurationToken.fast,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const _Row(cells: <String>['token', 'light', 'dark'], header: true),
        for (final token in _shown)
          _Row(
            cells: <String>[
              token.cssName,
              _resolved.value(token, AstryxThemeMode.light),
              _resolved.value(token, AstryxThemeMode.dark),
            ],
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.cells, this.header = false});

  final List<String> cells;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      mainAxisSize: MainAxisSize.max,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (index, cell) in cells.indexed)
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: AstryxText(
              cell,
              type: header ? AstryxTextType.label : AstryxTextType.code,
              color: header
                  ? AstryxTextColor.primary
                  : AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}
```

**Rules**

- **Note:** The engine is a port, not a design. Every expander, the HCT colour model and the contrast maths are checked against upstream’s own test fixtures, so the same definition written in Dart and in TypeScript produces the same token values. See Principles (references/guides.md).

---

## Platform support

Which Flutter platforms are exercised, and where behaviour differs. The Flutter counterpart of upstream's browser-support page.

```dart
/// One target, and what the package resolves for it.
///
/// The glyphs come from Lucide directly rather than from `AstryxIconName`,
/// which names only what the widget set itself needs. Every icon slot takes a
/// `Widget`, so an application's own icons go in the same way.
typedef _Target = ({
  String name,
  IconData icon,
  String density,
  AstryxPalette palette,
  String note,
});

const List<_Target> _targets = <_Target>[
  (
    name: 'Android',
    icon: LucideIcons.smartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: '48px tap targets, hover suppressed.',
  ),
  (
    name: 'iOS',
    icon: LucideIcons.tabletSmartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: 'The same, and the same tap target.',
  ),
  (
    name: 'macOS',
    icon: LucideIcons.laptop,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Menlo heads the monospace stack.',
  ),
  (
    name: 'Windows',
    icon: LucideIcons.monitor,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Consolas heads the monospace stack.',
  ),
  (
    name: 'Linux',
    icon: LucideIcons.terminal,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'The generic families stand.',
  ),
  (
    name: 'Fuchsia',
    icon: LucideIcons.cpu,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Resolved, though untested in the wild.',
  ),
  (
    name: 'Web',
    icon: LucideIcons.globe,
    density: 'either',
    palette: AstryxPalette.gray,
    note: 'Pointer precision decides, not the host OS.',
  ),
];

class PlatformTargetsExample extends StatelessWidget {
  const PlatformTargetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final target in _targets)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    // Decorative: the name is right beside it, so announcing
                    // the glyph as well would say everything twice.
                    ExcludeSemantics(
                      child: Icon(
                        target.icon,
                        size: AstryxIconSize.lg.pixels,
                        color: theme.color(AstryxColorToken.iconSecondary),
                      ),
                    ),
                    Flexible(
                      child: AstryxText(
                        target.name,
                        type: AstryxTextType.label,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                AstryxHStack(
                  children: <Widget>[
                    AstryxBadge(
                      target.density,
                      variant: AstryxBadgeVariant.palette(target.palette),
                    ),
                  ],
                ),
                AstryxText(
                  target.note,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

**Rules**

- **Note:** The example app in this repository has runners for Android, iOS, Linux, macOS and web — not Windows. Nothing in the package is Windows-specific and the font stack has an explicit Windows branch, but if you ship there, add the runner and look at it yourself rather than taking this page’s word for it.

| Thing | How it differs |
| --- | --- |
| Density | iOS and Android resolve to `touch`; macOS, Windows, Linux and Fuchsia to `pointer`. A `MediaQuery` reporting a coarse pointer overrides both. |
| Font stacks | A CSS generic expands to different concrete families per platform — Menlo on Apple, Consolas on Windows. A stack leading with a system alias resolves to a *null* family, which is Flutter’s way of saying "the platform UI font". |
| Everything else | Identical. Colour, spacing, type, motion, focus, semantics and keyboard behaviour are the same on every target. |

| Requires | Version |
| --- | --- |
| Dart | `>=3.9.0 <4.0.0` |
| Flutter | `>=3.35.0` |

---

## Density

One widget set that is honest on a mouse and on a thumb.

```dart
class ThemingDensityExample extends StatelessWidget {
  const ThemingDensityExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Touch density raises every tap target to 48px and suppresses hover-only
    // affordances. The control's painted height does not change — the region
    // that responds to a finger does.
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final density in AstryxDensity.values)
          AstryxThemeProvider(
            density: density,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    '${density.name} · min target '
                    '${density.minimumTapTarget.toInt()}px',
                    type: AstryxTextType.label,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxButton(label: 'Save', onPressed: () {}),
                      AstryxIconButton(
                        icon: AstryxIconName.copy,
                        label: 'Copy',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  AstryxCheckbox(
                    label: 'Also a target',
                    value: true,
                    onChanged: (_) {},
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

**Rules**

- **Careful:** Nothing important may live behind hover alone. That is why table (references/data.md) row actions are always visible, and why a tooltip (references/overlays.md) may never be the only place a piece of information appears.

|   | `pointer` | `touch` |
| --- | --- | --- |
| Minimum tap target | the control’s own height | 48px |
| Hover affordances | active | suppressed |
| Default toast position | a corner | the bottom |

---

## Right-to-left

Logical throughout, so RTL is a `Directionality` and nothing more.

```dart
class ThemingRtlExample extends StatelessWidget {
  const ThemingRtlExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Nothing in the tree below asks about direction. Padding, alignment, icon
    // mirroring, overlay sides and keyboard arrows are all logical.
    return AstryxGrid(
      minWidth: 240,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final direction in TextDirection.values)
          Directionality(
            textDirection: direction,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    direction.name.toUpperCase(),
                    type: AstryxTextType.label,
                  ),
                  AstryxButton(
                    label: 'Next',
                    trailing: const AstryxIcon(AstryxIconName.chevronRight),
                    onPressed: () {},
                  ),
                  AstryxCheckbox(
                    label: 'Label follows the reading edge',
                    value: true,
                    onChanged: (_) {},
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

**Rules**

- **Note:** The block axis never flips: `top` and `bottom` mean what they say in every locale Astryx supports.

**What flips, without being asked**

| Thing | Under RTL |
| --- | --- |
| Padding and alignment | `paddingInline`, `AstryxStackAlign.start`, everything logical. |
| Icons | Directional glyphs mirror — chevrons and arrows do, a calendar does not. |
| Button groups | The "first" child rounds its reading-start corners. |
| Overlay sides | `AstryxOverlaySide.left` and `.right` resolve against the direction. |
| Arrow keys | `→` and `←` swap in tab lists, radio groups, switches and submenus. |
| Toast placement | `bottomEnd` hugs the trailing edge, whichever side that is. |
| Table alignment | `AstryxTableAlignment.end` follows the reading direction. |

---

## Accessibility

The rules the whole widget set is built to, in one place.

**Rules**

- **Careful:** Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error` — a 1.00:1 contrast failure. It is reproduced faithfully rather than corrected, and pinned by a test, because silently diverging from upstream is worse than a documented defect. An error badge (references/surfaces.md) is where it shows. Override the token if it affects you.

---

## Migration

Coming from Material or Cupertino: what maps, what does not, and what to stop doing.

```dart
// The app is still a MaterialApp. One screen is not.
MaterialApp(
  home: const HomeScreen(),
  routes: <String, WidgetBuilder>{
    '/settings': (context) => const AstryxThemeProvider(
      child: SettingsScreen(),
    ),
  },
)
```

**Rules**

- **Note:** Two providers in one application are fine, and so is one inside another: a theme is a value, not a global. That is the same property that lets Themes (references/guides.md) render eight of them on one page.
- **Note:** The test for step 4: switch the theme and the density with the pickers at the top of this page, then do the same in your app. Whatever stops looking right is a value a widget is still holding.

| Material | Here | What actually differs |
| --- | --- | --- |
| `MaterialApp` | `AstryxApp` (references/guides.md) | A `WidgetsApp`. Nothing Material-shaped arrives with it — no `Scaffold`, no `AppBar`, no `ThemeData`. |
| `Theme.of(context)`, `ColorScheme` | `AstryxTheme.of(context)` | Tokens rather than a colour scheme: `theme.color(…)`, `theme.spacing(…)`, `theme.textStyle(…)`. See Design tokens (references/guides.md). |
| `ElevatedButton`, `FilledButton` | `AstryxButton` (references/actions.md) | One button with a `variant`. `primary` is the filled one; there is also `destructive`, which Material leaves you to build. |
| `OutlinedButton`, `TextButton` | `AstryxButton` (references/actions.md) | `secondary` and `ghost`. Emphasis is a variant, not a class. |
| `IconButton` | `AstryxIconButton` (references/actions.md) | `label` is **required** even though nothing is painted. An unnamed icon button is a compile error here, not a review comment. |
| `TextField`, `TextFormField` | `AstryxTextInput` (references/forms.md), `AstryxTextArea` (references/forms.md) | No `InputDecoration`. The label, the description and the error are parameters on the input — or on `AstryxField` (references/forms.md), which labels anything. |
| `Checkbox`, `CheckboxListTile` | `AstryxCheckbox` (references/forms.md) | The label belongs to the control, so there is no tile variant. Tristate is `AstryxCheckboxValue`, not a nullable `bool`. |
| `Switch`, `SwitchListTile` | `AstryxSwitch` (references/forms.md) | Same: one widget, `label` required. |
| `Radio`, `RadioListTile` | `AstryxRadioList` (references/forms.md) | The **group** is the widget. Roving focus, arrow keys and the single tab stop come from it owning the set. |
| `DropdownButton`, `DropdownMenu` | `AstryxSelector` (references/forms.md) | Choosing a *value* is a selector. Material’s dropdown does both jobs; here they are two widgets. |
| `PopupMenuButton` | `AstryxDropdownMenu` (references/overlays.md) | Choosing a *command* is a menu. Sections, dividers and destructive items are part of it. |
| `Card`, `InkWell` | `AstryxCard` (references/surfaces.md) | A pressable card is a non-null `onPressed`, not a wrapper. There is no ink ripple: the states are hover, focus-visible and pressed. |
| `Chip` | `AstryxBadge` (references/surfaces.md) | A badge is a label, not a control. Nothing about it is tappable, and that is the point. |
| `MaterialBanner` | `AstryxBanner` (references/surfaces.md) | Status is a variant, and every one carries an icon as well as a fill. |
| `Divider`, `VerticalDivider` | `AstryxDivider` (references/layout.md) | One widget with an `axis`, and an optional label in the rule. |
| `CircularProgressIndicator` | `AstryxSpinner` (references/status.md) | Settles into a complete ring under reduced motion rather than vanishing. |
| `LinearProgressIndicator` | `AstryxProgressBar` (references/status.md) | Takes a `label`; determinate and indeterminate are the same widget. |
| Shimmer packages | `AstryxSkeleton` (references/status.md) | In the package, themed by `--color-skeleton`, and still legible when animations are off. |
| `Tooltip` | `AstryxTooltip` (references/overlays.md) | Same idea, stricter rule: a tooltip may not be the only route to information. A third of your users have no hover. |
| `SnackBar`, `ScaffoldMessenger` | `AstryxToast` (references/overlays.md) | `AstryxToastScope.of(context).show(…)`. No `Scaffold` in the way, because there is no `Scaffold`. |
| `AlertDialog`, `showDialog` | `AstryxDialog` (references/overlays.md) | A **widget in the tree** driven by a controller, not a route pushed onto a navigator. |
| `TabBar`, `TabBarView` | `AstryxTabList` (references/data.md) | The list only. You own the body it selects, which is usually a switch over your own state. |
| `DataTable` | `AstryxTable` (references/data.md) | Columns are `AstryxTableColumn` objects with their own widths, alignment and sort. Row actions stay visible rather than appearing on hover. |
| `Text`, `TextStyle` | `AstryxText` (references/layout.md), `AstryxHeading` (references/layout.md) | Ask for a `type` or a `level`, never a size. See Typography (references/guides.md). |
| `Icon`, `Icons.*` | `AstryxIcon` (references/layout.md) | Icons are asked for by meaning — `AstryxIconName.success` — and the registry decides the glyph. |
| `Column` + `SizedBox` gaps | `AstryxVStack` (references/layout.md), `AstryxHStack` | `gap` is a spacing token, so a reordered list keeps its rhythm and no gap is a magic number. |
| `GridView`, `Wrap` | `AstryxGrid` (references/layout.md) | A `minWidth` and no breakpoints: the grid works out its own column count. See Layout (references/guides.md). |
| `Semantics(label:)` for hidden text | `labelHidden`, `AstryxVisuallyHidden` | Hiding a label from sight while keeping it as the accessible name is a parameter on the control. |

| Cupertino | Here |
| --- | --- |
| `CupertinoButton` | `AstryxButton` (references/actions.md) |
| `CupertinoTextField` | `AstryxTextInput` (references/forms.md) |
| `CupertinoSwitch` | `AstryxSwitch` (references/forms.md) |
| `CupertinoAlertDialog` | `AstryxDialog` (references/overlays.md) |
| `CupertinoActivityIndicator` | `AstryxSpinner` (references/status.md) |
| `CupertinoSegmentedControl` | `AstryxButtonGroup` (references/actions.md) for actions, `AstryxTabList` (references/data.md) for views |
| `CupertinoPageScaffold` | Nothing yet — see below. |

| Habit | Instead |
| --- | --- |
| `Colors.blue`, `Color(0xFF…)` | A colour token. If none of the seventy-nine fits, the answer is a `tokens` override in `defineTheme`, not a literal. See Colour (references/guides.md). |
| `EdgeInsets.all(16)` | `theme.spacing(AstryxSpacingToken.spacing4)`, or the component’s own padding parameter, which already takes a token. |
| `TextStyle(fontSize: 13)` | A type role. `theme.textStyle(AstryxTypeRole.supporting)` when you are building something the widget set does not cover. |
| `BorderRadius.circular(8)` | `theme.borderRadius(AstryxRadiusToken.element)` — which is 0 in the `y2k` theme, and that is the point. |
| `Duration(milliseconds: 200)` | `AstryxMotion.of(context)`, which honours reduced motion. See Motion (references/guides.md). |
| Row actions revealed on hover | Keep them visible. Nothing important may live behind hover — see Density (references/guides.md). |
| `left`, `right`, `EdgeInsets.only(left:)` | Start and end. `EdgeInsetsDirectional`, and the components’ own logical parameters. |
| A heading size chosen for looks | `level` for the outline, `type` for the size. Skipping a level to get a size breaks the document; see Typography (references/guides.md). |
| `if (Platform.isAndroid)` for touch sizing | Density resolves itself, from the platform *and* the pointer. |

---

## Working with AI

The generated agent skill, what it contains, and how to keep it current.

**Rules**

- **Note:** Only written pages are published to it. A component that is stubbed or still *Soon* is left out entirely, because an agent told about a widget the package does not export will call it, and the call will not compile.
- **Careful:** Pre-alpha: the API changes between releases. Pin the plugin to the tag matching the version in your `pubspec.yaml`, or the agent will confidently write against a package you are not using.

| File | Holds |
| --- | --- |
| `SKILL.md` | The short half: setup, the rules that must not be broken, a table for choosing between two similar components, the mistakes a generator makes without it, and an index of every component. |
| `references/guides.md` | The guide pages — tokens, colour, typography, density, RTL, accessibility. |
| `references/*.md` per group | One file per sidebar group — actions, forms, overlays, surfaces, data, layout, status, templates. Each component has a canonical snippet and its full property table. |
| `references/enums.md` | Every public enum and its values, scraped from the package source. The names are not always the obvious ones, and an invented variant does not compile. |
| `references/patterns.md` | Whole screens: a form in a card, a table with row actions, a destructive flow, a settings list. |

---

## Themes

The eight themes side by side, and the same components rendered in each.

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

**Rules**

- **Note:** The themes name real typefaces — Figtree, DM Sans, Playwrite US Trad, Fraunces, Montserrat, Poppins, Outfit, Fustat, JetBrains Mono — and the package bundles **none** of them, exactly as upstream ships no font files. Each falls through its stack to the platform’s own UI font until you add the family to your `pubspec.yaml`. What you see below is therefore the size, the weight and the rhythm, not the face. See Typography (references/guides.md).
- **Careful:** Switch this page to `stone` and the error foregrounds go blank: upstream sets `--color-on-error` equal to `--color-error`, a 1.00:1 contrast failure, and the port reproduces it rather than quietly correcting it. Pinned by a test, overridable in one line. See Colour (references/guides.md).

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

---

## Showcase

Apps built with astryx_ui, and how to add yours.

**Rules**

- **Note:** No public link needed. Most of what this package is for lives behind a login and cannot be demonstrated — a screenshot and a description are a complete submission, and the form leaves the link field optional for exactly that reason.

---

