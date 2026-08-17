// GENERATED FILE — DO NOT EDIT.
//
// The README, parsed into documentation blocks.
//
// Regenerate with:
//
//   dart run tool/gen_readme.dart

/// The README, as documentation blocks.
///
/// Parsed from the repository's `README.md` by `tool/gen_readme.dart`, so the
/// landing page and the page pub serves cannot disagree about what the package
/// is, how it is installed, or what it will not do.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/model.dart';

/// Everything above the first heading: what the package is, and the status
/// note under it.
const List<DocBlock> readmeIntro = <DocBlock>[
  DocProse('**The Flutter design system for the app you have to ship this quarter.** 111 components, 42 whole screens, one token layer, and no Material anywhere in the tree. Add one dependency and the buttons, tables, dialogs, menus, toasts, date pickers, command palette and chat surfaces are already designed — in seven themes, light and dark, on a mouse and on a thumb.'),
  DocProse('**[See every component, live, in seven themes → astryxui.web.app](https://astryxui.web.app/)**'),
  DocCallout.note('**Status: pre-alpha.** Published as a development preview; the API is unstable and may change without a major version bump until 0.1.0. See the [changelog](https://github.com/JayashBhandary/astryx_ui/blob/main/CHANGELOG.md) for what each release contains.'),
];

/// Each `##` and `###` section, keyed by its heading.
///
/// A `##` section holds its subsections as well, so `Theming` includes
/// `A custom theme`; each subsection is also an entry of its own.
const Map<String, List<DocBlock>> readmeSections = <String, List<DocBlock>>{
  'Install': <DocBlock>[
    DocCode('''flutter pub add astryx_ui:^0.0.7-dev''', language: 'sh'),
    DocProse('Pre-release versions are not selected by a bare `flutter pub add`, so name the version — or write it out:'),
    DocCode('''dependencies:
  astryx_ui: ^0.0.7-dev''', language: 'yaml'),
    DocProse('To track the repository instead of a release:'),
    DocCode('''dependencies:
  astryx_ui:
    git: https://github.com/JayashBhandary/astryx_ui.git''', language: 'yaml'),
  ],
  'What you get': <DocBlock>[
    DocList(<String>[
      '**111 components.** Buttons, fields, selects, tables, tabs, menus, dialogs, toasts, banners, calendars, date and time inputs, avatars, carousels, a command palette, a typeahead, an app shell and a full chat surface. Not a starting point — the set an internal tool actually needs.',
      '**42 whole screens.** Sign-in, settings, dashboards, tables with filters and pagination, kanban boards, editors, an IDE, galleries, storefronts, an incident console, AI chat. Each one is extracted from a widget that compiles, so the code you copy is the screen you looked at.',
      '**19 controllers and mixins**, where upstream ships a React hook.',
      '**Seven themes, and an engine for yours.** `defineTheme` runs the same HCT colour model and contrast maths as the TypeScript original, so a theme defined in Dart produces the same values the React version does. Give it one hex accent and it derives the palette, including the foregrounds that guarantee contrast.',
      '**Never a raw colour or a magic number.** Every value resolves through the token layer, so changing your brand is changing one theme rather than running a search-and-replace across your codebase.',
      '**Pointer and touch, both first class.** Touch density raises every tap target to 48 logical pixels and suppresses hover styling, because hover does not exist there. Nothing is ever behind it.',
      '**Accessibility that is not optional.** Every control requires an accessible name, keeps a visible focus ring for keyboard users, and states its keyboard map in its own documentation. An icon-only button takes its label as a required argument — the compiler asks for it, not the code review.',
      '**A skill your coding agent can read.** The whole widget set, every enum and the rules that are not guessable from the API, generated from the same source as the docs.',
    ]),
  ],
  'Why not Material': <DocBlock>[
    DocProse('Material is a brand, and `ThemeData` is its API. Every internal tool built on it starts by fighting the parts of that brand it did not choose — the ripples, the elevation, the shape defaults, the `ColorScheme` mapping that never quite covers what a design has.'),
    DocProse('`astryx_ui` is built on `flutter/widgets`, which is Flutter without the opinion. Colours, spacing, radii, type and motion come from one token layer that is value-compatible with [Astryx](https://github.com/facebook/astryx), Meta\'s React + StyleX design system. A team running Astryx on the web and this in the app ships one design language rather than two that drift.'),
    DocProse('It also composes rather than converts: adopt it a subtree at a time inside the `MaterialApp` you already have. Nothing here asks you to start again.'),
  ],
  'Setup': <DocBlock>[
    DocProse('Wrap your app once. `AstryxApp` is a `WidgetsApp` with everything installed:'),
    DocCode('''import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);''', language: 'dart'),
    DocProse('Adopting incrementally inside an existing `MaterialApp` or `CupertinoApp`? Use the provider instead — it installs the theme, the icon registry, the localisations, the focus-visible scope and the toast host, and works anywhere in the tree:'),
    DocCode('''MaterialApp(
  home: AstryxThemeProvider(
    child: const HomePage(),
  ),
)''', language: 'dart'),
    DocProse('That is the whole setup. Toasts, tooltips, dialogs and focus rings all work from here with nothing else to wire.'),
  ],
  'Theming': <DocBlock>[
    DocProse('Seven prebuilt themes ship with the package — `neutralTheme`, `matchaTheme`, `stoneTheme`, `gothicTheme`, `chocolateTheme`, `y2kTheme` and `butterTheme`:'),
    DocCode('''AstryxThemeProvider(
  theme: matchaTheme,
  mode: AstryxColorMode.system,
  child: const HomePage(),
)''', language: 'dart'),
    DocProse('`mode` defaults to `system`, which follows the platform\'s own light/dark preference through `MediaQuery` — the theme tracks a change without your app rebuilding anything.'),
    DocHeading('A custom theme', level: 3),
    DocProse('Themes are *defined*, not hard-coded. `defineTheme` runs the same expansion the React version does — the HCT colour model, the type, radius and motion scales, the derived-variable registry — so a theme defined here and the same theme defined in TypeScript produce identical token values:'),
    DocCode('''final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
  ),
);''', language: 'dart'),
    DocProse('Give it a hex accent and the engine derives the full palette, including the `--color-on-*` foregrounds that guarantee contrast.'),
    DocHeading('Reaching a token directly', level: 3),
    DocProse('For a chart library or a non-Astryx widget that needs to match:'),
    DocCode('''final theme = AstryxTheme.of(context);
final accent = theme.color(AstryxColorToken.accent);
final gap = theme.spacing(AstryxSpacingToken.spacing3);''', language: 'dart'),
    DocProse('If you only need tokens and theme types, import the lighter `package:astryx_ui/theme.dart` instead of the full surface.'),
  ],
  'A custom theme': <DocBlock>[
    DocProse('Themes are *defined*, not hard-coded. `defineTheme` runs the same expansion the React version does — the HCT colour model, the type, radius and motion scales, the derived-variable registry — so a theme defined here and the same theme defined in TypeScript produce identical token values:'),
    DocCode('''final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
  ),
);''', language: 'dart'),
    DocProse('Give it a hex accent and the engine derives the full palette, including the `--color-on-*` foregrounds that guarantee contrast.'),
  ],
  'Reaching a token directly': <DocBlock>[
    DocProse('For a chart library or a non-Astryx widget that needs to match:'),
    DocCode('''final theme = AstryxTheme.of(context);
final accent = theme.color(AstryxColorToken.accent);
final gap = theme.spacing(AstryxSpacingToken.spacing3);''', language: 'dart'),
    DocProse('If you only need tokens and theme types, import the lighter `package:astryx_ui/theme.dart` instead of the full surface.'),
  ],
  'Density': <DocBlock>[
    DocProse('Astryx targets pointer and touch equally, and the density is resolved from the platform and the pointer precision `MediaQuery` reports. Touch density raises every tap target to 48px and disables hover-only affordances. Override it when you know better:'),
    DocCode('''AstryxThemeProvider(
  density: AstryxDensity.touch,
  child: const HomePage(),
)''', language: 'dart'),
  ],
  'What is not in 1.0': <DocBlock>[
    DocProse('Stated up front rather than discovered:'),
    DocList(<String>[
      '**`AstryxTable` does not virtualise rows.** A few hundred rows is fine; ten thousand is not. It also has no column reordering, drag-resizing, grouped or expandable rows, and sorts one column at a time.',
      '**`AstryxTabList` scrolls its overflow** rather than collapsing it into a menu.',
      '**No charting widget**, and none is planned. The dashboard templates draw their own from a `CustomPainter` over the token layer, and show you where a real charting package goes.',
      '**The status icons are stroked, not solid.** Upstream fills them for legibility at small sizes; Lucide ships no filled variants. Swap the icon registry if this matters to you.',
      '**The API is unstable until 0.1.0.** Pin the version you build against.',
    ]),
    DocProse('Each widget\'s own limitations are stated in its doc comment too, so you do not have to come back here.'),
  ],
  'Documentation': <DocBlock>[
    DocProse('[`doc/`](https://github.com/JayashBhandary/astryx_ui/blob/main/doc/README.md) documents every component: what it is for, how it composes, every variant, the keyboard map, the accessibility rules, and a full API reference.'),
    DocProse('The same content is a live site at **[astryxui.web.app](https://astryxui.web.app)**, built from [`example/`](https://github.com/JayashBhandary/astryx_ui/blob/main/example/README.md) with `astryx_ui` itself: theme, brightness, density and text-direction pickers, a `Preview` / `Code` tab on every example, and a monitor/phone switch that re-runs every preview at a phone\'s width. Any page is linkable — `astryxui.web.app/card`.'),
    DocCode('''firebase deploy --only hosting:astryxui''', language: 'sh'),
    DocProse('Run it locally:'),
    DocCode('''cd example && flutter run -d chrome''', language: 'sh'),
    DocProse('Every code block in both is extracted from a real, compiling widget in `example/lib/examples/`, so a snippet cannot describe something the package does not do. See [`example/README.md`](https://github.com/JayashBhandary/astryx_ui/blob/main/example/README.md) for how that works.'),
    DocHeading('For AI coding agents', level: 3),
    DocProse('[`.claude/skills/astryx-ui/`](https://github.com/JayashBhandary/astryx_ui/blob/main/.claude/skills/astryx-ui/SKILL.md) is the same documentation shaped for an agent rather than a reader: the rules the widget set enforces, a component index, per-group API references, every public enum\'s values scraped from the source, and the mistakes a generator makes without them.'),
    DocProse('This repository is also a Claude Code plugin marketplace, so the skill installs in one step:'),
    DocCode('''/plugin marketplace add JayashBhandary/astryx_ui
/plugin install astryx-ui@astryx-ui''', language: 'text'),
    DocProse('Pin a release by appending a tag — `JayashBhandary/astryx_ui@v0.0.7-dev` — and pick up later ones with `/plugin marketplace update`. Claude Code loads the skill automatically inside this repository whether or not the plugin is installed.'),
    DocProse('Not using Claude Code? Copy `.claude/skills/astryx-ui/` into your own project\'s `.claude/skills/`, or point your agent at [`doc/`](https://github.com/JayashBhandary/astryx_ui/blob/main/doc/README.md), which is the same content in plain markdown.'),
  ],
  'For AI coding agents': <DocBlock>[
    DocProse('[`.claude/skills/astryx-ui/`](https://github.com/JayashBhandary/astryx_ui/blob/main/.claude/skills/astryx-ui/SKILL.md) is the same documentation shaped for an agent rather than a reader: the rules the widget set enforces, a component index, per-group API references, every public enum\'s values scraped from the source, and the mistakes a generator makes without them.'),
    DocProse('This repository is also a Claude Code plugin marketplace, so the skill installs in one step:'),
    DocCode('''/plugin marketplace add JayashBhandary/astryx_ui
/plugin install astryx-ui@astryx-ui''', language: 'text'),
    DocProse('Pin a release by appending a tag — `JayashBhandary/astryx_ui@v0.0.7-dev` — and pick up later ones with `/plugin marketplace update`. Claude Code loads the skill automatically inside this repository whether or not the plugin is installed.'),
    DocProse('Not using Claude Code? Copy `.claude/skills/astryx-ui/` into your own project\'s `.claude/skills/`, or point your agent at [`doc/`](https://github.com/JayashBhandary/astryx_ui/blob/main/doc/README.md), which is the same content in plain markdown.'),
  ],
  'Contributing': <DocBlock>[
    DocProse('[`.github/CONTRIBUTING.md`](https://github.com/JayashBhandary/astryx_ui/blob/main/.github/CONTRIBUTING.md) is the guide: how the generated documentation fits together, the component checklist, and what gets merged. There are four issue templates — [bug report](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml), [feature request](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml), [component request](https://github.com/JayashBhandary/astryx_ui/issues/new?template=component_request.yml) and [show what you built](https://github.com/JayashBhandary/astryx_ui/issues/new?template=showcase.yml).'),
    DocProse('Two things worth reading before you open an editor. [`example/README.md`](https://github.com/JayashBhandary/astryx_ui/blob/main/example/README.md) explains how the documentation is built — every example is a compiling widget, and the snippets, the markdown in [`doc/`](https://github.com/JayashBhandary/astryx_ui/blob/main/doc/README.md) and the agent skill are all generated from it, so a documentation change starts there. And every widget\'s own doc comment states its limitations and the Astryx decision behind it, which is usually the answer to "why is it like this".'),
    DocHeading('Built something with it?', level: 3),
    DocProse('Open a [showcase issue](https://github.com/JayashBhandary/astryx_ui/issues/new?template=showcase.yml). Internal tools and half-finished side projects count. What people actually build decides which components get finished next, so the rough edges you hit on the way are the useful part.'),
  ],
  'Built something with it?': <DocBlock>[
    DocProse('Open a [showcase issue](https://github.com/JayashBhandary/astryx_ui/issues/new?template=showcase.yml). Internal tools and half-finished side projects count. What people actually build decides which components get finished next, so the rough edges you hit on the way are the useful part.'),
  ],
  'License': <DocBlock>[
    DocProse('MIT. Derived from Astryx (MIT, Copyright &copy; 2026 Meta Platforms, Inc.). See [`LICENSE`](https://github.com/JayashBhandary/astryx_ui/blob/main/LICENSE) and [`NOTICE`](https://github.com/JayashBhandary/astryx_ui/blob/main/NOTICE).'),
  ],
};
