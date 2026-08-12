---
title: AstryxThemeProvider
description: The provider that puts a resolved theme in scope — and everything else the widgets need.
component: true
group: Providers
source: lib/src/app/astryx_theme_provider.dart
upstream: Theme
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream’s `Theme` writes CSS custom properties onto an element and the cascade does the rest. Flutter has no cascade, so the same job is an `InheritedWidget` — and this widget installs it, along with the four other scopes a widget expects to find above it.

## Usage

```dart
AstryxApp(
  theme: neutralTheme,
  home: const HomePage(),
)
```

That is the whole setup for an app built on Astryx alone. To adopt the package inside an existing `MaterialApp` or `CupertinoApp`, wrap a subtree instead — `AstryxApp` composes exactly this, so the two behave identically:

```dart
MaterialApp(
  home: AstryxThemeProvider(
    theme: matchaTheme,
    mode: AstryxColorMode.system,
    child: const HomePage(),
  ),
)
```

## What it installs

```text
AstryxThemeProvider
└── AstryxTheme                 ← the resolved tokens, the density, the icons
    └── AstryxLocalizationsScope ← the strings
        └── AstryxLinkScope      ← what following a link means
            └── AstryxFocusVisibleScope ← keyboard focus vs mouse focus
                └── AstryxToastScope + host ← so `show(…)` needs no wiring
                    └── your app
```

All five, or none of them work: a toast raised from a button has to resolve the same theme, density and strings as the page that raised it, so the host sits **inside** the scopes rather than beside them. Nothing here needs to be wired twice.

```dart
class ProviderThemeExample extends StatefulWidget {
  const ProviderThemeExample({super.key});

  @override
  State<ProviderThemeExample> createState() => _ProviderThemeExampleState();
}

class _ProviderThemeExampleState extends State<ProviderThemeExample> {
  AstryxDefinedTheme _theme = butterTheme;
  AstryxColorMode _mode = AstryxColorMode.light;

  @override
  Widget build(BuildContext context) {
    // A provider can be nested: this one re-themes its own subtree and leaves
    // the page around it alone. Everything below it — including any overlay it
    // opens — resolves the theme installed here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSegmentedControl<AstryxDefinedTheme>(
              label: 'Theme',
              value: _theme,
              segments: <AstryxSegment<AstryxDefinedTheme>>[
                AstryxSegment(value: butterTheme, label: 'Butter'),
                AstryxSegment(value: matchaTheme, label: 'Matcha'),
                AstryxSegment(value: gothicTheme, label: 'Gothic'),
              ],
              onChanged: (theme) => setState(() => _theme = theme),
            ),
            AstryxSegmentedControl<AstryxColorMode>(
              label: 'Mode',
              value: _mode,
              segments: const <AstryxSegment<AstryxColorMode>>[
                AstryxSegment(value: AstryxColorMode.light, label: 'Light'),
                AstryxSegment(value: AstryxColorMode.dark, label: 'Dark'),
              ],
              onChanged: (mode) => setState(() => _mode = mode),
            ),
          ],
        ),
        AstryxThemeProvider(
          theme: _theme,
          mode: _mode,
          child: AstryxCard(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Inside the provider',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'Colour, radius, type and motion all come from the theme '
                  'installed here — no widget below reads a raw value.',
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxButton(label: 'Primary', onPressed: () {}),
                    const AstryxBadge('Badge'),
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


## Nesting

A provider can be nested, and the inner one wins for its own subtree — a preview pane rendering another theme, a documentation page showing several of them, a dark toolbar over a light page. What it does **not** do is reach an overlay opened from outside it: an overlay resolves the theme above its own trigger, which is the one the user was looking at.

## Colour mode

| `AstryxColorMode` | Resolves to |
| --- | --- |
| `system` | The platform’s own preference, through `MediaQuery.platformBrightnessOf` — so the theme tracks a change without the app rebuilding anything. The default. |
| `light` | Always light. |
| `dark` | Always dark. |

## Reading what it installed

```dart
final theme = AstryxTheme.of(context);
theme.color(AstryxColorToken.accent);
theme.spacing(AstryxSpacingToken.spacing3);

AstryxTheme.densityOf(context).supportsHover;
AstryxLocalizations.of(context).dialogClose;
```

> **Careful**
>
> `AstryxTheme.of` throws a `FlutterError` with a fix-it when there is no provider above it, rather than falling back to a default. A widget silently painting unthemed colours is a bug that ships; an exception on the first frame is one that does not.

### AstryxThemeProvider

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The subtree to theme. |
| `theme` | `AstryxDefinedTheme?` | — | The theme to resolve. Null uses the Astryx defaults, which are a complete and usable theme rather than a placeholder. |
| `mode` | `AstryxColorMode` | `AstryxColorMode.system` | Which colour mode to resolve. |
| `density` | `AstryxDensity?` | — | Overrides the resolved interaction density. Null derives it from the platform and the pointer precision `MediaQuery` reports. |
| `icons` | `AstryxIconRegistry?` | — | The icon registry for this subtree. Null uses the Lucide-backed defaults. |
| `localizations` | `AstryxLocalizations` | `AstryxLocalizations()` | The strings the widgets use. |
| `platform` | `TargetPlatform?` | — | Overrides the platform used for density and font-stack resolution. For tests, and for previewing another platform. |
| `linkDelegate` | `AstryxLinkDelegate?` | — | What following a link means. Null means links do nothing. |
| `toastController` | `AstryxToastController?` | — | The controller the toast host renders from. Null lets the provider own one. |
| `toastPosition` | `AstryxToastPosition?` | — | Where the toast stack sits. Null follows the resolved density. |


### AstryxTheme

The scope itself. Install it through `AstryxThemeProvider`; reach for these statics to read it.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `of(context)` | `AstryxThemeData` | — | The resolved theme. Throws when there is none. |
| `maybeOf(context)` | `AstryxThemeData?` | — | The resolved theme, or null — for a widget where a theme is genuinely optional. |
| `densityOf(context)` | `AstryxDensity` | — | The density in effect, falling back to the platform. |
| `iconsOf(context)` | `AstryxIconRegistry` | — | The icon registry in effect. |


## Related

- [Theming](../guides/theming.md) — the seven prebuilt themes, and writing your own.
- [Design tokens](../guides/tokens.md) — what a resolved theme contains.
- [Density](../guides/density.md) — what the provider decides about pointers and thumbs.
- [Installation](../guides/installation.md) — the two entry points, in order.

