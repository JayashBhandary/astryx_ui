# Getting started

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## astryx_ui

An unofficial Flutter port of Astryx, Meta’s design system for internal tools.

**Rules**

- **Careful:** Pre-alpha. Not affiliated with, endorsed by, or supported by Meta Platforms, Inc. The API is unstable.

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

