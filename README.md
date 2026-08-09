# astryx_ui

An unofficial Flutter port of [Astryx](https://github.com/facebook/astryx), Meta's
design system for building internal tools and products.

> **Status: pre-alpha.** Nothing is published yet and the API is unstable. See
> [`dev/04-TRACKER.md`](../dev/04-TRACKER.md) for what is built and what is not.

## What this is

Astryx is a React + StyleX design system. `astryx_ui` reimplements it for
Flutter:

- **A faithful theme engine.** Astryx's token defaults, scale expanders, HCT
  color model, and contrast math ported to Dart, verified against the upstream
  test suite. Custom themes generate the same values the React version does.
- **All seven prebuilt themes** — neutral, matcha, stone, gothic, chocolate,
  y2k, butter.
- **Components built on `flutter/widgets`**, not Material. Every widget is
  themeable through the same token layer.
- **Every platform.** Pointer and touch are both first-class: dual density,
  platform-appropriate touch targets, and a gesture path for every hover
  interaction.

## What this is not

- Not affiliated with, endorsed by, or supported by Meta Platforms, Inc.
- Not a 1:1 port of all ~100 Astryx components. See
  [`dev/reference/COMPONENT-INVENTORY.md`](../dev/reference/COMPONENT-INVENTORY.md)
  for the scope of 1.0 and what is deferred.

## Installation

Not yet published to pub.dev. Until then, depend on it by path or by git:

```yaml
dependencies:
  astryx_ui:
    path: ../astryx_ui
```

## Setup

Wrap your app once. `AstryxApp` is a `WidgetsApp` with everything installed:

```dart
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);
```

Adopting incrementally inside an existing `MaterialApp` or `CupertinoApp`?
Use the provider instead — it installs the theme, the icon registry, the
localisations, the focus-visible scope and the toast host, and works anywhere
in the tree:

```dart
MaterialApp(
  home: AstryxThemeProvider(
    child: const HomePage(),
  ),
)
```

That is the whole setup. Toasts, tooltips, dialogs and focus rings all work
from here with nothing else to wire.

## Theming

Seven prebuilt themes ship with the package — `neutralTheme`, `matchaTheme`,
`stoneTheme`, `gothicTheme`, `chocolateTheme`, `y2kTheme` and `butterTheme`:

```dart
AstryxThemeProvider(
  theme: matchaTheme,
  mode: AstryxColorMode.system,
  child: const HomePage(),
)
```

`mode` defaults to `system`, which follows the platform's own light/dark
preference through `MediaQuery` — the theme tracks a change without your app
rebuilding anything.

### A custom theme

Themes are *defined*, not hard-coded. `defineAstryxTheme` runs the same
expansion the React version does — the HCT colour model, the type, radius and
motion scales, the derived-variable registry — so a theme defined here and the
same theme defined in TypeScript produce identical token values:

```dart
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
  ),
);
```

Give it a hex accent and the engine derives the full palette, including the
`--color-on-*` foregrounds that guarantee contrast.

### Reaching a token directly

For a chart library or a non-Astryx widget that needs to match:

```dart
final theme = AstryxTheme.of(context);
final accent = theme.color(AstryxColorToken.accent);
final gap = theme.spacing(AstryxSpacingToken.spacing3);
```

If you only need tokens and theme types, import the lighter
`package:astryx_ui/theme.dart` instead of the full surface.

## Density

Astryx targets pointer and touch equally, and the density is resolved from the
platform and the pointer precision `MediaQuery` reports. Touch density raises
every tap target to 48px and disables hover-only affordances. Override it when
you know better:

```dart
AstryxThemeProvider(
  density: AstryxDensity.touch,
  child: const HomePage(),
)
```

## What is not in 1.0

Stated up front rather than discovered:

- **`AstryxTable` does not virtualise rows.** A few hundred rows is fine; ten
  thousand is not. It also has no column reordering, drag-resizing, grouped or
  expandable rows, and sorts one column at a time.
- **`AstryxTabList` scrolls its overflow** rather than collapsing it into a
  menu.
- **The status icons are stroked, not solid.** Upstream fills them for
  legibility at small sizes; Lucide ships no filled variants. Swap the icon
  registry if this matters to you.
- Roughly 70 of upstream's ~100 components are out of scope for 1.0. See
  [`dev/reference/COMPONENT-INVENTORY.md`](../dev/reference/COMPONENT-INVENTORY.md).

Each widget's own limitations are stated in its doc comment too, so you do not
have to come back here.

## Example gallery

`example/` is a live gallery: every widget, every variant, with theme, mode,
density and text-direction pickers. It builds for web.

```sh
cd example && flutter run -d chrome
```

## Contributing

The full development process — architecture, conventions, porting rules, phase
plans, and the session tracker — lives in the [`dev/`](../dev/) directory at the
repository root. Start with [`dev/README.md`](../dev/README.md).

## License

MIT. Derived from Astryx (MIT, Copyright &copy; 2026 Meta Platforms, Inc.).
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).
