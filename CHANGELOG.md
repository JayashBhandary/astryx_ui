# Changelog

All notable changes to `astryx_ui` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1-dev]

First development preview. The API is unstable and may change without a major
version bump until 0.1.0.

### Added

- Package scaffold: pubspec, lint configuration, directory layout, license and
  attribution files.
- Token layer: colour primitives (OKLCH, RGBA, CSS colour parsing, light/dark
  pairs) and the full token set — colour, spacing, radius, size, border,
  shadow, duration, ease, font weight, text size and typography tokens.
- Theme engine: `defineTheme`, the token resolver, scale expansion for colour,
  type, radius and motion, contrast and HCT helpers, style overrides, syntax
  themes and the theme registry.
- Theme runtime: `AstryxThemeData`, `ResolvedTokenSet`, `AstryxTheme`,
  `AstryxShadow`, font stacks, token-to-Flutter conversions, and per-component
  theme classes.
- Prebuilt themes: neutral, stone, butter, chocolate, gothic, matcha and y2k.
- App layer: `AstryxApp` and `AstryxThemeProvider`.
- Foundation: density, focus ring, focus trap, focus-visible tracking, link
  delegate, motion, overlay positioning and stack, RTL helpers, semantics,
  size scope, states controller and tap targets.
- Components — layout and typography (stack, grid, center, divider, heading,
  text, icon), actions (button, icon button, button group), feedback
  (progress bar, skeleton, spinner), forms (text input, checkbox, radio list,
  selector, switch, toggle row, field), overlays (dialog, dropdown menu,
  popover, toast, tooltip, anchored overlay), surfaces (badge, banner, card,
  palette) and data display (table, tab list).
- Icon registry backed by Lucide, mirroring Astryx's semantic icon names.
- Localizations via `AstryxLocalizations`.
- Secondary entry point `package:astryx_ui/theme.dart` for the theme layer
  without components.

[Unreleased]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.1-dev...HEAD
[0.0.1-dev]: https://github.com/JayashBhandary/astryx_ui/releases/tag/v0.0.1-dev
