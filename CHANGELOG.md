# Changelog

All notable changes to `astryx_ui` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.6-dev]

Documentation and tooling only. No library code changed, so nothing here can
break a consumer.

### Added

- **Fourteen template pages.** Whole screens, assembled only from what the
  package exports and extracted from compiling widgets in
  `example/lib/examples/template_*.dart`: four sign-in screens (bare, carded,
  SSO, split), three forms (contact, two-column, payment), settings as a page
  and as a dialog, a centred hero, a record detail page, a dashboard, a table
  screen, and a theme showcase holding one of every component. Each page states
  what it is made of and why each control was chosen over the one next to it.
- **A monitor / phone switch on every preview.** The phone pins the example to
  390 logical pixels and draws the frame's edge, which is the only way to watch
  a `LayoutBuilder` reflow — a two-column form becoming one, a tile row
  restacking. Width only: touch density is a separate axis with its own picker.
  It is not drawn when the viewport is already about phone-width, and the frame
  gives way rather than overflowing if the window is narrowed after the fact.
  The choice sits on `DocsController` with the other pickers, so it is made once
  for every example on the page and survives navigation.
  The glyphs are Lucide's, reached directly by the documentation app:
  `AstryxIconName` names neither a monitor nor a phone, and it stays a
  transcription of upstream's `IconName` union rather than growing to suit this
  site.
- `example/lib/docs_ui/segmented.dart` — the button-group picker the top bar and
  the new width switch share, instead of the private copy the top bar had. It
  also names the group to a screen reader, so "Mobile" is a choice *about*
  something.

### Fixed

- The previous/next page footer overflowed below about 520 logical pixels: some
  page titles are long — `InternationalizationProvider` — and two of them will
  not sit side by side on a phone. The pair now stacks.
- `example/lib/docs/version.g.dart` had fallen a release behind `pubspec.yaml`;
  regenerating the snippets brings it back to the package version.

### Known limitations, now documented

Three layout traps found while building the templates, all of them the same
root cause — a widget that measures its children intrinsically cannot measure
the touch-target wrapper or a `LayoutBuilder` inside them, so they assert in
touch density:

- `AstryxText(truncateTooltip: true)` cannot be used inside an `AstryxTable`
  cell.
- An `AstryxGrid` cell cannot hold a wrapped row of interactive widgets, or an
  `AstryxTable`. Cells of text, badges and figures are fine.

## [0.0.5-dev]

Documentation, tooling and tests only. No library code changed, so nothing here
can break a consumer.

### Added

- **The page registry mirrors upstream.** Every page on `astryx.atmeta.com` now
  has a route here — 163 placeholders alongside the 37 written pages, across
  seventeen groups, including the ones that are entirely unwritten: Navigation,
  App shell, Chat & AI, Command & search, Date & time, Media, Providers, Hooks
  & controllers and Templates. Each placeholder carries a description, the
  upstream page it will be written from, and a `DocStatus` — `ready`, `stub`
  (ported, not written up), `planned` (not ported yet) or `notPlanned`
  (deliberately omitted). A missing route and a widget nobody has thought about
  are no longer indistinguishable.
- **A sidebar that survives two hundred pages.** Groups collapse, each showing
  how many pages it holds; the group containing the current page opens on load
  and on every navigation; a *Written pages only* switch hides the
  placeholders; a search expands every group so a match is never hidden in a
  collapsed one. Placeholders carry a status badge, and say *not written yet*
  in their accessible name, so a screen-reader user does not have to open a
  page to find out it is empty.
- **A sitemap parity test.** `example/test/upstream_pages.txt` is every URL in
  upstream's `sitemap.xml`, captured 2026-08-10; the test fails when a
  component upstream ships is claimed by no page here. The fixture lives beside
  the test rather than in the git-ignored `scrape/`, so it is present in a
  fresh clone.
- **A contrast test for the documentation site's own colours.** Every
  foreground the docs chrome paints over every background it paints it on, in
  all eight themes and both brightnesses, against WCAG 2.1 AA — 4.5:1 for body
  text, 3:1 for large text and control furniture. The package's existing
  contrast tests check the engine; this checks the choices.
- Sidebar tests covering the three behaviours the flat list did not have:
  staying collapsed, marking empty pages, and hiding them.
- `example/lib/docs/groups.dart` — the group names and the reference file each
  is published to, in one place. `tool/gen_skill.dart` carried its own private
  copy of that map, and a group added to a page file but forgotten there made
  the generator exit 1.

### Changed

- The generators publish written pages only. `doc/` gets no file for a
  placeholder; the index names it with its status instead of linking it. The
  agent skill omits a group whose pages are all placeholders entirely — an
  agent told about a widget the package does not export will call it, and the
  call will not compile.
- Inline `` `code` `` in the documentation renders as a padded, rounded chip
  rather than text with a background colour, which put the first and last
  character flush against the edge of the highlight.
- `upstream:` on a page now claims every upstream sub-component it absorbs —
  `Table / TableCell / TableHeaderCell / useTableSelection / …` — which is what
  lets the sitemap check tell an absorbed component from a missing one. Names
  are corrected where they were wrong, so the checkbox page ports
  `CheckboxInput` rather than `Checkbox`.
- Documentation spacing: more room above a heading than between paragraphs,
  more between list items than between the lines inside one, and a bullet
  column sized to its bullet rather than to `10.`.
- `scrape/` is git-ignored.

### Fixed

- The sidebar threw *The Scrollbar's ScrollController has no ScrollPosition
  attached* on desktop and web, where `PrimaryScrollController.shouldInherit`
  is false and the scroll view and its scrollbar disagreed about inheriting it.
  The sidebar owns its controller now.

## [0.0.4-dev]

### Added

- Package metadata for pub.dev: `homepage` and `documentation` now point at
  <https://astryxui.web.app>, where the documentation site is hosted.
- Installation instructions for the published package, in the README and on the
  site's installation page. The version constraint they quote is generated from
  `pubspec.yaml`, so a released constraint cannot fall behind the release.
- **The repository is a Claude Code plugin marketplace**, so the agent skill
  installs with `/plugin marketplace add JayashBhandary/astryx_ui` followed by
  `/plugin install astryx-ui@astryx-ui`. The plugin's version is copied from
  `pubspec.yaml` when the skill is generated, so it cannot fall behind a
  release either.

### Changed

- The documentation site is deployed to Firebase Hosting at
  <https://astryxui.web.app>. The Hosting configuration is deliberately not in
  version control, and so is absent from the published archive; the deploy
  command and the target it needs are documented in `example/README.md`.

### Fixed

- The README linked a `dev/` directory that is not part of this repository, so
  five links 404'd on GitHub and on pub.dev. They now point at the
  documentation, the changelog, or the issue tracker.
- The README and the installation page still said the package was unpublished.

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

[Unreleased]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.6-dev...HEAD
[0.0.6-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.5-dev...v0.0.6-dev
[0.0.5-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.4-dev...v0.0.5-dev
[0.0.4-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.3-dev...v0.0.4-dev
[0.0.3-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.2-dev...v0.0.3-dev
[0.0.2-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.1-dev...v0.0.2-dev
[0.0.1-dev]: https://github.com/JayashBhandary/astryx_ui/releases/tag/v0.0.1-dev
