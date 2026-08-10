# Changelog

All notable changes to `astryx_ui` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.3-dev]

Documentation only. No library code changed, so nothing here can break a
consumer.

### Added

- **A documentation site**, in `example/`. Every component with prose, live
  examples, the source that produced them, and an API reference — viewable in
  any of the eight themes, either brightness, both densities and both text
  directions. Built from `astryx_ui` itself, with no Material anywhere: the
  navigation is a column of pressable cards, the example frames are cards, the
  Preview/Code switch is an `AstryxTabList`, the API references are
  `AstryxTable`s. Pages are addressable by URL fragment on the web.
- **`doc/`** — the same content as markdown: 30 component pages under
  `components/`, seven guides under `guides/` (installation, theming, design
  tokens, density, right-to-left, accessibility), and an index. Generated from
  the page model by `example/tool/gen_docs_md.dart`.
- **A skill for AI coding agents**, in `.claude/skills/astryx-ui/`. The rules
  the widget set is built to, a component index, per-group API references, every
  public enum's values, and the mistakes a generator makes without them.
  Generated from the same source by `example/tool/gen_skill.dart`.
- **Snippet extraction.** Every code block in the site, the markdown and the
  skill is lifted from a real, compiling widget in `example/lib/examples/` by
  `example/tool/gen_snippets.dart`. A snippet cannot describe something the
  package does not do, because the preview and the code come from the same
  lines.
- Example tests that render every page and build all 156 examples, so a layout
  error in a documented example fails the suite rather than being found by a
  reader.

### Changed

- `example/` is the documentation site rather than a gallery of demo pages. The
  theme, brightness, density and direction pickers survive; the demo and gallery
  scaffolding they lived in does not.

## [0.0.2-dev]

### Fixed

- `AstryxCard` no longer asserts `BoxConstraints forces an infinite width`
  when given an unbounded width — inside a `Row`, an `AstryxHStack`, or a
  horizontal list. It fills a bounded width as before and shrinks to fit an
  unbounded one, matching how a block box sizes itself in CSS.

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

[Unreleased]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.3-dev...HEAD
[0.0.3-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.2-dev...v0.0.3-dev
[0.0.2-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.1-dev...v0.0.2-dev
[0.0.1-dev]: https://github.com/JayashBhandary/astryx_ui/releases/tag/v0.0.1-dev
