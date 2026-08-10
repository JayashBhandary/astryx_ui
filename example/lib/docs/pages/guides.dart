import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/version.g.dart';

/// The pages that are not about one component.
final List<DocPage> guidePages = <DocPage>[
  _introduction,
  _installation,
  _principles,
  _theming,
  _tokens,
  _color,
  _typography,
  _spacing,
  _shape,
  _elevation,
  _motion,
  _layout,
  _icons,
  _illustrations,
  _styling,
  _core,
  _platformSupport,
  _density,
  _rtl,
  _accessibility,
];

const String _group = DocGroup.gettingStarted;

const DocPage _introduction = DocPage(
  id: 'introduction',
  title: 'astryx_ui',
  group: _group,
  description:
      'An unofficial Flutter port of Astryx, Meta’s design system for '
      'internal tools.',
  upstreamPath: '/',
  blocks: <DocBlock>[
    DocProse(
      'Astryx is a React and StyleX design system. `astryx_ui` reimplements it '
      'for Flutter: the token engine, the seven prebuilt themes, and a widget '
      'set built on `flutter/widgets` rather than Material.',
    ),
    DocCallout.warning(
      'Pre-alpha. Not affiliated with, endorsed by, or supported by Meta '
      'Platforms, Inc. The API is unstable.',
    ),
    DocHeading('What this is'),
    DocList(<String>[
      '**A faithful theme engine.** Astryx’s token defaults, scale expanders, '
          'HCT colour model and contrast maths, ported to Dart and verified '
          'against the upstream test suite. A theme defined here produces the '
          'same values the TypeScript version does.',
      '**All seven prebuilt themes** — neutral, matcha, stone, gothic, '
          'chocolate, y2k, butter.',
      '**Components built on `flutter/widgets`**, not Material. Every widget '
          'is themeable through the same token layer.',
      '**Every platform.** Pointer and touch are both first-class: dual '
          'density, platform-appropriate tap targets, and a gesture path for '
          'every hover interaction.',
    ]),
    DocHeading('What this is not'),
    DocList(<String>[
      'A 1:1 port of all ~100 Astryx components. Roughly 30 are in scope for '
          '1.0 — the ones on the left of this page.',
      'A Material replacement. It composes *with* Material: '
          '`AstryxThemeProvider` works inside a `MaterialApp`, which is the '
          'incremental adoption path.',
    ]),
    DocHeading('This site'),
    DocProse(
      'The documentation you are reading is built from `astryx_ui` itself. The '
      'navigation is a column of ghost buttons, the example frames are cards, '
      'the Preview/Code switch is a tab list, the API references are tables. '
      'Use the controls at the top to view every page in any of the eight '
      'themes, either brightness, both densities and both text directions.',
    ),
    DocProse(
      'Every example is a real widget in `example/lib/examples/`, and the code '
      'under each `Code` tab is extracted from that file by '
      '`tool/gen_snippets.dart`. A snippet cannot drift from the preview '
      'beside it, because both come from the same lines.',
    ),
    DocHeading('Start here'),
    DocList(<String>[
      '[Installation](installation) — add the package and wrap your app.',
      '[Principles](principles) — what it optimises for, and what follows.',
      '[Theming](theming) — the seven themes, and defining your own.',
      '[Design tokens](tokens) — the values everything resolves to.',
      '[Density](density) — how pointer and touch differ.',
      '[AstryxButton](button) — or just start reading components.',
    ]),
  ],
);

const DocPage _installation = DocPage(
  id: 'installation',
  title: 'Installation',
  group: _group,
  description: 'Add the package, wrap your app once, and you are done.',
  upstreamPath: '/docs/getting-started',
  blocks: <DocBlock>[
    DocHeading('Add the dependency'),
    DocCode(
      '''
dependencies:
  astryx_ui: ^$astryxVersion''',
      language: 'yaml',
      title: 'pubspec.yaml',
    ),
    DocProse(
      'This is a **pre-release**, and a bare `flutter pub add` will not select '
      'one — name the version:',
    ),
    DocCode(
      'flutter pub add astryx_ui:^$astryxVersion',
      language: 'bash',
    ),
    DocProse('To track the repository rather than a release:'),
    DocCode(
      '''
dependencies:
  astryx_ui:
    git: https://github.com/JayashBhandary/astryx_ui.git''',
      language: 'yaml',
      title: 'pubspec.yaml — from git',
    ),
    DocHeading('Wrap your app'),
    DocProse(
      '`AstryxApp` is a `WidgetsApp` with everything installed: the theme, the '
      'icon registry, the localisations, the focus-visible scope and the toast '
      'host.',
    ),
    DocCode('''
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);'''),
    DocProse(
      'Deliberately built on `WidgetsApp`, not `MaterialApp`: Astryx has its '
      'own colour, typography and spacing model, and inheriting Material’s '
      'would mean every widget neutralising its defaults.',
    ),
    DocHeading('Adopting incrementally'),
    DocProse(
      'Inside an existing `MaterialApp` or `CupertinoApp`, use the provider '
      'instead. It installs the same machinery and works anywhere in the tree, '
      'so a single screen can adopt the design system without the app '
      'converting.',
    ),
    DocCode('''
MaterialApp(
  home: AstryxThemeProvider(
    child: const HomePage(),
  ),
)'''),
    DocProse(
      'That is the whole setup. Toasts, tooltips, dialogs and focus rings all '
      'work from here with nothing else to wire.',
    ),
    DocHeading('Import surfaces'),
    DocTable(
      headers: <String>['Import', 'Gives you'],
      rows: <List<String>>[
        <String>[
          '`package:astryx_ui/astryx_ui.dart`',
          'Everything: the theme layer and every component.',
        ],
        <String>[
          '`package:astryx_ui/theme.dart`',
          'Tokens, `AstryxThemeData` and the engine, with no widgets — for a '
              'chart library, a custom painter, or a test.',
        ],
      ],
    ),
    DocHeading('Run this site'),
    DocCode(
      '''
cd example
flutter run -d chrome

# after editing anything in lib/examples/
dart run tool/gen_snippets.dart''',
      language: 'bash',
    ),
  ],
);

const DocPage _principles = DocPage(
  id: 'principles',
  title: 'Principles',
  group: _group,
  description:
      'What the design system optimises for, and the decisions that '
      'follow from it.',
  upstreamPath: '/docs/principles',
  blocks: <DocBlock>[
    DocProse(
      'Astryx is a design system for internal tools: dense screens, long-lived '
      'software, people who use the same view every day and would rather it '
      'were fast than novel. Every decision below follows from that, and each '
      'one is taken once, here, rather than argued again at each call site.',
    ),
    DocHeading('Fidelity beats improvement'),
    DocProse(
      'Where this port and upstream disagree about a value, upstream wins. The '
      'token defaults, the scale expanders, the HCT colour model and the '
      'contrast maths are checked against the upstream test suite, so a theme '
      'defined in Dart resolves to the values the TypeScript version produces.',
    ),
    DocProse(
      'That holds even when upstream is wrong. The `stone` theme sets '
      '`--color-on-error` equal to `--color-error` — a 1.00:1 contrast '
      'failure — and the port reproduces it, pinned by a test, rather than '
      'quietly correcting it. A design system that renders one way in React '
      'and another in Flutter is two design systems; a documented defect is '
      'cheaper than a silent divergence, and a theme’s `tokens` map overrides '
      'it in one line.',
    ),
    DocHeading('No component holds a value'),
    DocProse(
      'Not a colour, not a padding, not a radius, not a duration, not a '
      '`TextStyle`. Every one is a token read from the theme at build time. '
      'That is the whole reason seven themes, two brightnesses, two densities '
      'and a custom accent are a configuration change rather than a rewrite — '
      'and the reason a widget you write yourself stays in step with the ones '
      'you did not.',
    ),
    DocProse(
      'The escape hatch is a token override, never a literal: `defineTheme` '
      'takes a `tokens` map that beats every generated value, so "our brand '
      'needs a tighter radius" stays inside the system instead of leaking a '
      '`BorderRadius.circular(6)` into a hundred files.',
    ),
    DocHeading('Accessibility is construction, not review'),
    DocProse(
      'A rule that is checked at review time is a rule that ships broken on a '
      'busy week. The components make the accessible thing the only thing that '
      'compiles instead: `AstryxButton` takes a `label` rather than a `child`, '
      '`AstryxIconButton` requires one even though it paints none, and '
      '`labelHidden` hides a label from sight while keeping it as the '
      'accessible name.',
    ),
    DocProse(
      'The same principle covers focus, announcements and colour: overlays '
      'trap focus and return it, `Escape` closes one layer at a time, only '
      'errors interrupt a screen reader, and every status carries an icon as '
      'well as a fill. [Accessibility](accessibility) is the full list.',
    ),
    DocHeading('Pointer and touch are both first class'),
    DocProse(
      'Not a mobile variant bolted on afterwards. Density resolves from the '
      'platform *and* the pointer precision `MediaQuery` reports, and touch '
      'grows the region that responds to a finger without growing the painted '
      'control — so a form does not reflow when someone plugs in a mouse.',
    ),
    DocProse(
      'The corollary is the strictest rule in the package: nothing important '
      'may live behind hover, because a third of the users have no hover at '
      'all. Table row actions stay visible where upstream reveals them; every '
      'hover interaction has a gesture path beside it. See [Density](density).',
    ),
    DocHeading('Logical, never left and right'),
    DocProse(
      'Components are written in start and end terms throughout, so '
      'right-to-left is a `Directionality` and nothing else — no mode to '
      'switch on, no mirrored copy of a widget, no page that works only in '
      'English. If an example looks wrong in RTL, the bug is in the widget. '
      'See [Right-to-left](rtl).',
    ),
    DocHeading('Compose with Flutter, do not replace it'),
    DocProse(
      'The widgets are built on `flutter/widgets` rather than Material, '
      'because inheriting Material’s colour, typography and spacing model '
      'would mean every widget spending its first ten lines neutralising '
      'defaults. But the theme is a value, not a global: '
      '`AstryxThemeProvider` works anywhere in a tree, including inside a '
      '`MaterialApp`, so one screen can adopt the design system without the '
      'application converting.',
    ),
    DocHeading('Fewer components, finished'),
    DocProse(
      'Upstream ships around a hundred components; roughly 30 are in scope for '
      '1.0. The ones that are here are meant to be complete — keyboard, '
      'semantics, RTL, both densities, reduced motion — rather than to be '
      'many. Where two upstream components differ only by a prop they arrive '
      'as one: there is a single `AstryxCard`, and a non-null `onPressed` is '
      'what makes it pressable.',
    ),
    DocCallout.note(
      'Everything upstream ships that is not ported yet still has a page here, '
      'marked *Soon* in the sidebar. A missing route is indistinguishable from '
      'a component nobody has thought about; a placeholder says which one this '
      'is.',
    ),
    DocHeading('The documentation is the package'),
    DocProse(
      'This site is built out of `astryx_ui` — the navigation is a column of '
      'cards, the example frames are cards, the API references are tables. '
      'Every snippet under a `Code` tab is extracted from the widget rendered '
      'beside it by `tool/gen_snippets.dart`, so a snippet cannot drift from '
      'its preview, and a page that looks wrong in one of the eight themes is '
      'a bug you can see without leaving the page.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Design tokens](tokens) — the values everything resolves through.',
      '[Density](density) — pointer and touch, side by side.',
      '[Accessibility](accessibility) — the rules, and what enforces each.',
      '[Theming](theming) — the seven themes, and defining your own.',
    ]),
  ],
);

const DocPage _theming = DocPage(
  id: 'theming',
  title: 'Theming',
  group: _group,
  description: 'Seven themes, two brightnesses, and an engine for your own.',
  upstreamPath: '/docs/theme',
  blocks: <DocBlock>[
    DocHeading('The prebuilt themes'),
    DocProse(
      'A theme is a value, not a global. Nesting a provider re-themes a '
      'subtree — which is how the preview below shows eight at once.',
    ),
    DocExample('theming_themes', align: DocExampleAlign.stretch),
    DocCode('''
AstryxThemeProvider(
  theme: matchaTheme,
  mode: AstryxColorMode.system,
  child: const HomePage(),
)'''),
    DocHeading('Light and dark'),
    DocProse(
      '`mode` defaults to `system`, which follows the platform’s own '
      'preference through `MediaQuery` — the theme tracks a change without '
      'your app rebuilding anything.',
    ),
    DocExample('theming_modes', align: DocExampleAlign.stretch),
    DocHeading('A custom theme'),
    DocProse(
      'Themes are *defined*, not hard-coded. `defineTheme` runs the same '
      'expansion the React version does — the HCT colour model, the type, '
      'radius and motion scales, the derived-variable registry — so a theme '
      'defined here and the same theme defined in TypeScript produce identical '
      'token values.',
    ),
    DocCode('''
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
    radius: AstryxRadiusScaleConfig(base: 2, multiplier: 2),
  ),
);'''),
    DocProse(
      'One hex accent is enough: the engine derives the full palette from it, '
      'including the `--color-on-*` foregrounds that guarantee contrast. The '
      '"Acme" entry in the theme picker at the top of this page is exactly '
      'that definition — pick it and every component on the site re-themes.',
    ),
    DocProse(
      'Everything else is optional and layered. `extendsTheme` starts from '
      'another theme; `tokens` overrides individual CSS custom properties and '
      'beats every generated value; `components` carries per-component style '
      'overrides; `icons` swaps the registry.',
    ),
    DocCode('''
final acmeDense = defineTheme(
  AstryxDefineThemeInput(
    name: 'acme-dense',
    extendsTheme: acmeTheme,
    tokens: <String, AstryxTokenValue>{
      '--spacing-4': AstryxTokenValue('12px'),
    },
  ),
);'''),
    DocHeading('Reaching a token directly'),
    DocProse(
      'For a chart library, a custom painter, or a widget the design system '
      'does not cover.',
    ),
    DocCode('''
final theme = AstryxTheme.of(context);

final accent = theme.color(AstryxColorToken.accent);
final gap = theme.spacing(AstryxSpacingToken.spacing3);
final radius = theme.borderRadius(AstryxRadiusToken.container);
final style = theme.textStyle(AstryxTypeRole.body);'''),
    DocCallout.note(
      'If you only need tokens and theme types, import '
      '`package:astryx_ui/theme.dart` instead of the full surface. It is the '
      'same theme layer without any widgets.',
    ),
    DocHeading('Icons'),
    DocProse(
      'The registry maps semantic names to glyphs — Lucide by default, '
      'matching upstream. Install your own and every `AstryxIcon` in the app '
      'follows, with no call site changing.',
    ),
    DocCode('''
AstryxThemeProvider(
  // From `defaults`, so the names you do not list still resolve.
  icons: AstryxIconRegistry.defaults.copyWith(
    const <AstryxIconName, IconData>{
      AstryxIconName.search: MyIcons.search,
    },
  ),
  child: const HomePage(),
)'''),
    DocHeading('Related'),
    DocList(<String>[
      '[Design tokens](tokens) — what a theme resolves to.',
      '[Icons](icons) — the registry, and the rule above.',
      '[Styling](styling) — the narrower escape hatches.',
    ]),
  ],
);

const DocPage _tokens = DocPage(
  id: 'tokens',
  title: 'Design tokens',
  group: _group,
  description: 'The values every component resolves through.',
  upstreamPath: '/docs/tokens',
  blocks: <DocBlock>[
    DocProse(
      'No component holds a colour, a length or a duration. Every one is a '
      'token, resolved from the theme at build time — which is what makes '
      'eight themes, two brightnesses and a custom accent a configuration '
      'change rather than a rewrite.',
    ),
    DocTable(
      title: 'The token families',
      headers: <String>['Family', 'Enum', 'Read with'],
      rows: <List<String>>[
        <String>[
          'Colour',
          '`AstryxColorToken`',
          '`theme.color(token)`',
        ],
        <String>[
          'Spacing',
          '`AstryxSpacingToken`',
          '`theme.spacing(token)`',
        ],
        <String>['Size', '`AstryxSizeToken`', '`theme.size(token)`'],
        <String>[
          'Radius',
          '`AstryxRadiusToken`',
          '`theme.radius(token)` / `theme.borderRadius(token)`',
        ],
        <String>['Border', '`AstryxBorderToken`', '`theme.borderWidth()`'],
        <String>[
          'Shadow',
          '`AstryxShadowToken`',
          '`theme.shadow(token)` / `theme.boxShadows(token)`',
        ],
        <String>[
          'Type',
          '`AstryxTypeRole`',
          '`theme.textStyle(role)` / `theme.headingStyle(level)`',
        ],
        <String>[
          'Text size',
          '`AstryxTextSizeToken`',
          '`theme.textSize(token)`',
        ],
        <String>[
          'Font weight',
          '`AstryxFontWeightToken`',
          '`theme.fontWeight(token)`',
        ],
        <String>[
          'Duration',
          '`AstryxDurationToken`',
          '`theme.duration(token)`',
        ],
        <String>['Easing', '`AstryxEaseToken`', '`theme.ease(token)`'],
      ],
    ),
    DocHeading('Colour'),
    DocProse(
      'Seventy-nine colour tokens: the semantic set, the `--color-on-*` '
      'foregrounds that guarantee contrast against them, and four tokens for '
      'each of the ten categorical families. A sample, and '
      '[Colour](color) for the rest:',
    ),
    DocExample('theming_tokens', align: DocExampleAlign.stretch),
    DocHeading('Spacing'),
    DocProse(
      'Fifteen steps. Components name a step; they never write a number.',
    ),
    DocExample('theming_spacing', align: DocExampleAlign.stretch),
    DocHeading('Type'),
    DocProse(
      'Fourteen roles, each pairing a size, a weight and a line height. Ask '
      'for a role, not a size — that is what keeps two pieces of body copy '
      'identical.',
    ),
    DocExample('theming_type_scale', align: DocExampleAlign.stretch),
    DocHeading('Motion'),
    DocProse(
      'Durations and curves are tokens too, and every animation in the package '
      'goes through `AstryxMotion`, which honours '
      '`MediaQuery.disableAnimations`. Under reduced motion transitions become '
      'instantaneous and the two looping indicators — the spinner and the '
      'indeterminate progress bar — settle into a static state rather than '
      'disappearing.',
    ),
    DocCode('''
final motion = AstryxMotion.of(context);

AnimatedContainer(
  duration: motion.duration(AstryxDurationToken.fast),
  curve: motion.curve(),
  // …
)'''),
    DocCallout.note(
      'The token names are the upstream CSS custom properties, one for one: '
      '`AstryxColorToken.backgroundCard` is `--color-background-card`. When in '
      'doubt, the enum value’s own documentation names the property.',
    ),
  ],
);

const DocPage _color = DocPage(
  id: 'color',
  title: 'Colour',
  group: _group,
  description:
      'The colour system: the families, the semantic roles, and which '
      'one to reach for.',
  upstreamPath: '/docs/color',
  blocks: <DocBlock>[
    DocProse(
      'Seventy-nine colour tokens: thirty-nine semantic, and ten categorical '
      'families of four. Not one of them is named after a hue, because the '
      'name has to survive a theme change — `backgroundCard` is still the card '
      'background when the theme is `chocolate` and the card is brown.',
    ),
    DocHeading('Roles, not colours'),
    DocExample('color_roles', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['Family', 'Reach for it when'],
      rows: <List<String>>[
        <String>[
          '`background*`',
          'Painting a surface: the page, a card, a popover, a muted well, an '
              'inverted panel.',
        ],
        <String>[
          '`text*`, `icon*`',
          'Content on one of those surfaces — though a widget’s own `color:` '
              'parameter is usually the better route.',
        ],
        <String>[
          '`border`, `borderEmphasized`',
          'A boundary. `border` is decorative; `borderEmphasized` outlines a '
              'form control and is held to 3:1.',
        ],
        <String>[
          '`accent`, `success`, `warning`, `error`',
          'A fill that means something. Each has a `*Muted` tint for a '
              'background and an `on*` foreground for content.',
        ],
        <String>[
          '`skeleton`, `track`, `overlay`, `shadow`',
          'The machinery: a loading block, a progress trough, a scrim behind a '
              'dialog, the colour a shadow is built from.',
        ],
      ],
    ),
    DocHeading('Never choose a foreground'),
    DocProse(
      'Every fill that carries content has an `on*` partner, derived from it. '
      'Pairing them is the whole contract: change the accent and `onAccent` '
      'moves with it, so a label that was legible stays legible.',
    ),
    DocExample('color_on_pairs'),
    DocProse(
      '`onDark` and `onLight` are the same idea for content that sits on an '
      'inverted surface — a dark toast, a tooltip — where the page’s own text '
      'colours would be the wrong way round.',
    ),
    DocHeading('Light and dark are one token'),
    DocProse(
      'A colour token is not a colour: it is a `light-dark()` pair, and the '
      'brightness picks a half. That is why dark mode is not a second theme to '
      'maintain, and why `AstryxColorMode.system` can follow the platform '
      'without anything above it rebuilding.',
    ),
    DocHeading('The ten categorical families'),
    DocExample('color_palettes'),
    DocProse(
      'These are the palettes upstream did the most colour work on: every one '
      'passes WCAG AA in both modes, on its own tinted background. They are '
      'reproduced exactly and must not be adjusted — a nicer blue here is a '
      'contrast failure somewhere.',
    ),
    DocTable(
      title: 'Four tokens per family, on `AstryxPalette`',
      headers: <String>['Token', 'For'],
      rows: <List<String>>[
        <String>['`background`', 'The tinted fill.'],
        <String>['`border`', 'The border that goes with that fill.'],
        <String>['`text`', 'Text that reads on it.'],
        <String>['`icon`', 'An icon that reads on it.'],
      ],
    ),
    DocProse(
      'Reach for them through a component — '
      '`AstryxBadgeVariant.palette(AstryxPalette.teal)`, the same on '
      '`AstryxCardVariant` — rather than reading the four tokens yourself.',
    ),
    DocCallout.accessibility(
      'Categorical means *category*: a team, a label, an environment, a series '
      'in a chart. Never severity. `AstryxPalette.red` to mean "failed" leaves '
      'a colour-blind reader with nothing, and bypasses the `error` tokens '
      'that exist for it.',
    ),
    DocHeading('What is guaranteed'),
    DocList(<String>[
      '**Text clears 4.5:1** (WCAG 1.4.3) by tone spacing alone. HCT tone is '
          'CIE L*, which fixes relative luminance regardless of hue or chroma, '
          'so the guarantee holds for any accent and any neutral style.',
      '**`borderEmphasized` clears 3:1** (WCAG 1.4.11). It outlines form '
          'controls, so it is a non-text boundary; the engine tone-bumps it '
          'until it gets there.',
      '**`border`, `skeleton` and `track` are not.** They are decoration or a '
          'redundant cue, deliberately below 3:1 — which is why none of them '
          'may be a control’s only visible boundary.',
    ]),
    DocHeading('Deriving a palette from one colour'),
    DocProse(
      'One hex seed is enough. `expandColorScale` runs the same HCT derivation '
      'the React version does, so the tokens it generates match value for '
      'value.',
    ),
    DocCode('''
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(
      accent: '#0F62FE',
      neutralStyle: AstryxNeutralStyle.warm,
      contrast: AstryxContrastLevel.standard,
    ),
  ),
);'''),
    DocTable(
      headers: <String>['Option', 'Does'],
      rows: <List<String>>[
        <String>[
          '`accent`',
          'The seed, as `#RRGGBB`. Omit it and the neutrals are seeded from '
              'the default accent’s hue while the three accent tokens keep '
              'their defaults.',
        ],
        <String>[
          '`neutralStyle`',
          'How much of the seed hue bleeds into the neutrals — `warm`, `cool` '
              '(the default) or `neutral`, in descending chroma.',
        ],
        <String>[
          '`contrast`',
          '`standard`, or `high` to push text tones to the extremes.',
        ],
      ],
    ),
    DocProse(
      'Three things are deliberately *not* derived from the seed: the status '
      'colours, the categorical hues, and the `onDark`/`onLight` pair. They '
      'are convention-bound — green means success in every theme — so they '
      'fall through to the token defaults instead.',
    ),
    DocCallout.warning(
      'Upstream’s `stone` theme sets `--color-on-error` equal to '
      '`--color-error`, a 1.00:1 failure. Switch this page to `stone` and the '
      '`onError` chip above goes blank. It is reproduced rather than '
      'corrected, and pinned by a test; override the token if it reaches you. '
      'See [Accessibility](accessibility).',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Design tokens](tokens) — the other token families.',
      '[Theming](theming) — where a colour configuration goes.',
      '[AstryxBadge](badge) — the categorical palettes in use.',
    ]),
  ],
);

const DocPage _typography = DocPage(
  id: 'typography',
  title: 'Typography',
  group: _group,
  description:
      'The type scale, the roles, and how a heading level maps onto '
      'them.',
  upstreamPath: '/docs/typography',
  blocks: <DocBlock>[
    DocProse(
      'Nothing in the package names a font size. Text asks for a **role**, and '
      'a role is a size, a weight and a line height that travel together — '
      'fourteen roles, three properties each, forty-two tokens.',
    ),
    DocExample('typography_roles', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['Role', 'Size', 'Weight', 'For'],
      rows: <List<String>>[
        <String>[
          '`display1` … `display3`',
          '`5xl` … `3xl`',
          'normal',
          'Hero text and marketing-scale numbers. Rare inside a tool.',
        ],
        <String>[
          '`heading1` … `heading6`',
          '`2xl` … `xs`',
          'semibold',
          'The document outline. `heading4` sits at the base size.',
        ],
        <String>['`large`', '`lg`', 'semibold', 'Body copy one step up.'],
        <String>['`body`', '`base`', 'normal', 'The default.'],
        <String>['`label`', '`base`', 'medium', 'Form and control labels.'],
        <String>[
          '`supporting`',
          '`sm`',
          'normal',
          'Hints, captions, helper text.',
        ],
        <String>[
          '`code`',
          '`base`',
          'normal',
          'Inline and block code, in the code family.',
        ],
      ],
    ),
    DocHeading('In use'),
    DocProse(
      '`AstryxText` takes a `type`; `AstryxHeading` takes a `level`, which is '
      'both the size and the level announced to assistive technology.',
    ),
    DocExample('typography_in_context', align: DocExampleAlign.start),
    DocCode('''
const AstryxHeading('Deployment failed', level: 3)
const AstryxText('137 — out of memory', type: AstryxTextType.code)

// Building something the widget set has no widget for:
final theme = AstryxTheme.of(context);
final style = theme.textStyle(AstryxTypeRole.supporting);
final h2 = theme.headingStyle(2);'''),
    DocCallout.accessibility(
      'Do not skip a heading level to get a size. `AstryxHeading.type` changes '
      'the size while `level` keeps the outline honest, and '
      '`accessibilityLevel` overrides the announced level alone for the rare '
      'case where the two genuinely differ. See [AstryxHeading](heading).',
    ),
    DocHeading('Where the sizes come from'),
    DocProse(
      'The twelve raw sizes — `--font-size-4xs` through `--font-size-5xl` — '
      'are a geometric progression, `size = base × ratio^step`, rounded to '
      'whole pixels and emitted in `rem` against a 16px root. The semantic '
      'tokens then reference them, which is why moving the base moves the '
      'whole scale in step.',
    ),
    DocTable(
      title: 'What each prebuilt theme sets',
      headers: <String>['Themes', 'Base', 'Ratio'],
      rows: <List<String>>[
        <String>['neutral, chocolate', '14px', '1.2'],
        <String>['stone, butter', '14px', '1.25'],
        <String>['matcha, gothic, y2k', '16px', '1.25'],
      ],
    ),
    DocProse(
      'Line heights are computed rather than chosen: a target ratio tiered by '
      'size — 1.5 below 20px, 1.4 from 20 to 31px, 1.25 at 32px and above — '
      'snapped so the resulting pixel height lands on a 4px grid, with a floor '
      'of `size + 4`. That snapping is why the emitted ratios look irrational: '
      '1.4286, 1.4118.',
    ),
    DocHeading('Three families'),
    DocProse(
      'Body, heading and code. Headings inherit the body family unless they '
      'name their own, and the defaults are **system font stacks** — Astryx '
      'bundles no typeface, and neither does this port. A stack that leads '
      'with `-apple-system` resolves to a null Flutter family, which is '
      'correct rather than missing: Flutter’s default already is the '
      'platform’s UI font.',
    ),
    DocHeading('A custom type scale'),
    DocCode('''
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    typography: AstryxTypographyConfig(
      scale: AstryxTypeScaleSpec(base: 15, ratio: 1.25),
      body: AstryxTypographyRole(
        family: 'Geist',
        fallbacks: '-apple-system, sans-serif',
      ),
      heading: AstryxTypographyRole(weight: AstryxFontWeight.bold),
      code: AstryxTypographyRole(family: 'Geist Mono'),
    ),
  ),
);'''),
    DocCallout.note(
      'Setting a family does not load it. Register the font with Flutter as '
      'you normally would — `pubspec.yaml` or `google_fonts` — and the token '
      'picks it up once it is available.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxText](text) — the types, and the `style` escape hatch.',
      '[AstryxHeading](heading) — levels, display sizes, and the outline.',
      '[Design tokens](tokens) — the other token families.',
    ]),
  ],
);

const DocPage _spacing = DocPage(
  id: 'spacing',
  title: 'Spacing',
  group: _group,
  description:
      'The spacing scale, and the rule that gaps come from tokens '
      'rather than magic numbers.',
  upstreamPath: '/docs/spacing',
  blocks: <DocBlock>[
    DocProse(
      'Fifteen steps, `spacing0` through `spacing12`, running 0 to 48px on a '
      '4px grid — plus two half-steps, `spacing0_5` (2px) and `spacing1_5` '
      '(6px), for the distances inside a control where 4px is too coarse.',
    ),
    DocExample('theming_spacing', align: DocExampleAlign.stretch),
    DocHeading('Gaps belong to the container'),
    DocProse(
      'A gap is a property of the thing doing the arranging, not a widget '
      'wedged between two others. Every layout widget takes a token — `gap` on '
      'the stacks, `gap` and `runGap` on the grid and on a wrapping stack, '
      '`padding` on a card — so spacing survives a reorder, an RTL flip and a '
      'child being removed.',
    ),
    DocExample('spacing_gap', align: DocExampleAlign.start),
    DocCode('''
AstryxVStack(
  gap: AstryxSpacingToken.spacing3,
  align: AstryxStackAlign.stretch,
  children: <Widget>[…],
)

// Reading a step, for a widget the design system has no equivalent of:
final inset = AstryxTheme.of(context).spacing(AstryxSpacingToken.spacing4);'''),
    DocTable(
      title: 'Which step',
      headers: <String>['Step', 'Usually'],
      rows: <List<String>>[
        <String>[
          '`spacing0_5`, `spacing1`',
          'Inside a control — a glyph and its label, a badge’s padding.',
        ],
        <String>[
          '`spacing2`',
          'Between related controls. The most-used step in the package.',
        ],
        <String>['`spacing3`', 'Between the rows of a group or a form.'],
        <String>['`spacing4`', 'A card’s padding — its default.'],
        <String>[
          '`spacing6` and up',
          'Between the sections of a page, where the gap does the grouping.',
        ],
      ],
    ),
    DocCallout.warning(
      'A `SizedBox(height: 12)` between two children is the one to watch for. '
      'It looks identical today and is invisible to every theme, density and '
      'direction change afterwards.',
    ),
    DocHeading('The scale is not generated'),
    DocProse(
      'Radius, type and motion each expand from a base and a ratio. Spacing '
      'does not: there is no spacing expander, and no `spacing` field on a '
      'theme definition. A theme that wants a tighter rhythm overrides the '
      'individual tokens, which beat every generated value.',
    ),
    DocCode('''
final acmeDense = defineTheme(
  AstryxDefineThemeInput(
    name: 'acme-dense',
    extendsTheme: acmeTheme,
    tokens: <String, AstryxTokenValue>{
      '--spacing-3': AstryxTokenValue('10px'),
      '--spacing-4': AstryxTokenValue('12px'),
    },
  ),
);'''),
    DocCallout.note(
      'Spacing does not move with [density](density). Touch grows the region '
      'that responds to a finger, not the layout around it — so a form does '
      'not reflow when someone plugs in a mouse.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxHStack & AstryxVStack](stack) — where most gaps are set.',
      '[AstryxGrid](grid) — `gap` and `runGap` on a tile wall.',
      '[Design tokens](tokens) — the other token families.',
    ]),
  ],
);

const DocPage _shape = DocPage(
  id: 'shape',
  title: 'Shape',
  group: _group,
  description: 'Corner radii and how they compose when surfaces nest.',
  upstreamPath: '/docs/shape',
  blocks: <DocBlock>[
    DocProse(
      'Seven radius tokens, named for the level of the layout they belong to '
      'rather than for a number of pixels. Picking by level is what keeps '
      'nested corners concentric when the scale moves.',
    ),
    DocExample('shape_scale', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['Token', 'Default', 'For'],
      rows: <List<String>>[
        <String>['`none`', '0px', 'Square. A fixed anchor; never scales.'],
        <String>[
          '`inner`',
          '4px',
          'A corner inside a control — a chip, a row.',
        ],
        <String>[
          '`element`',
          '8px',
          'The controls themselves: buttons, inputs.',
        ],
        <String>['`container`', '12px', 'Cards, panels, popovers, dialogs.'],
        <String>['`page`', '28px', 'Page-level containers.'],
        <String>['`chat`', '28px', 'Chat surfaces. Tracks `page`.'],
        <String>['`full`', '9999px', 'A pill or a circle. Also fixed.'],
      ],
    ),
    DocHeading('Nesting'),
    DocProse(
      'A rounded thing inside another rounded thing wants a tighter radius, or '
      'the gap between the two curves reads as a mistake. The scale is built '
      'for that: each level is one step in, so the rule is "use the token for '
      'the level you are at" rather than arithmetic at the call site.',
    ),
    DocExample('shape_nesting', align: DocExampleAlign.start),
    DocHeading('Reading one'),
    DocCode('''
final theme = AstryxTheme.of(context);

theme.radius(AstryxRadiusToken.container);        // 12.0
theme.borderRadius(AstryxRadiusToken.container);  // BorderRadius'''),
    DocProse(
      '`radius` gives the bare number, for a `BoxConstraints` or a painter; '
      '`borderRadius` gives the `BorderRadius` a `BoxDecoration` wants. Most '
      'components resolve their own, so this is for the widget the design '
      'system has no equivalent of.',
    ),
    DocHeading('Scaling the whole set'),
    DocProse(
      'Radius expands from a base unit and a multiplier: every scalable token '
      'is `base × step × multiplier`, rounded to whole pixels, with steps 1 '
      '(`inner`), 2 (`element`), 3 (`container`) and 7 (`page` and `chat`). '
      '`none` and `full` are anchors and never move.',
    ),
    DocCode('''
// The default scale.
const AstryxRadiusScaleConfig(base: 4, multiplier: 1);

// Sharp and brutalist — every scalable radius becomes 0.
const AstryxRadiusScaleConfig(base: 4, multiplier: 0);

// Softer, without touching the pill or the square.
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    radius: AstryxRadiusScaleConfig(base: 4, multiplier: 2),
  ),
);'''),
    DocProse(
      'Upstream documents the multiplier’s range as 0–2. Because the whole set '
      'moves together, a theme can go square or go soft without any component '
      'learning about it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Theming](theming) — where a radius configuration goes.',
      '[Elevation](elevation) — the other property a surface carries.',
      '[Design tokens](tokens) — the other token families.',
    ]),
  ],
);

const DocPage _elevation = DocPage(
  id: 'elevation',
  title: 'Elevation',
  group: _group,
  description:
      'The elevation levels, what each is for, and how they read in '
      'dark mode.',
  upstreamPath: '/docs/elevation',
  blocks: <DocBlock>[
    DocProse(
      'Eight shadow tokens: three drop shadows that lift a surface off the '
      'page, and five inset shadows that ring a control without moving it. '
      'Elevation here is a *height above the page*, and the height is decided '
      'by what the surface is — not by how much attention it wants.',
    ),
    DocExample('elevation_shadows', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['Token', 'Where it is used'],
      rows: <List<String>>[
        <String>[
          '`low`',
          'The default overlay surface — popovers, tooltips, dropdown menus.',
        ],
        <String>[
          '`med`',
          'Toasts, and the floating list a selector opens.',
        ],
        <String>['`high`', 'Dialogs, the only thing above everything else.'],
        <String>[
          '`insetHover`, `insetSelected`',
          'A ring on a control that is hovered or chosen. No lift.',
        ],
        <String>[
          '`insetSuccess`, `insetWarning`, `insetError`',
          'A field’s validation state, drawn as a ring around the input.',
        ],
      ],
    ),
    DocProse(
      'An inset shadow is how a control shows state without changing size: a '
      'ring painted inside the border box moves nothing around it, so a form '
      'does not shift when a field turns red.',
    ),
    DocHeading('On a component'),
    DocProse(
      '`AstryxButton` and `AstryxIconButton` are the two that take an '
      'elevation directly — a floating action needs it. Everything else picks '
      'its own from what it is: a dialog is `high` because it is a dialog.',
    ),
    DocExample('elevation_button'),
    DocCode('''
AstryxButton(
  label: 'Compose',
  elevation: AstryxElevation.high,
  onPressed: compose,
)

// Anywhere else:
final theme = AstryxTheme.of(context);
final shadows = theme.boxShadows(AstryxShadowToken.med);'''),
    DocHeading('Dark mode'),
    DocProse(
      'A shadow is a `light-dark()` pair like every other colour value, and '
      'the dark half is *stronger*, not weaker — the alphas go from 0.1 to 0.2 '
      'and 0.3. On a dark page a faint shadow disappears, so the same shadow '
      'that separates a dialog from a white page would leave it floating in '
      'nothing.',
    ),
    DocCallout.note(
      'Shadow is a separation cue, never the only one. Every elevated surface '
      'in the package also carries a background and a border, because a '
      'shadow is invisible to a screen reader, thin at high contrast, and '
      'nearly gone on a low-quality display.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Shape](shape) — the corners those surfaces are cut with.',
      '[AstryxPopover](popover) — the `low` surface in use.',
      '[AstryxDialog](dialog) — the `high` one.',
    ]),
  ],
);

const DocPage _motion = DocPage(
  id: 'motion',
  title: 'Motion',
  group: _group,
  description:
      'Durations, easings, and what must not move when motion is '
      'reduced.',
  upstreamPath: '/docs/motion',
  blocks: <DocBlock>[
    DocProse(
      'Nine durations — three bands of min, base and max — and one easing '
      'curve. A band is chosen by what is moving: a control gives feedback '
      '`fast`, a panel arrives `medium`, and `slow` is for something crossing '
      'the whole screen.',
    ),
    DocExample('motion_durations', align: DocExampleAlign.start),
    DocTable(
      headers: <String>['Band', 'Default', 'For'],
      rows: <List<String>>[
        <String>[
          '`fastMin` · `fast` · `fastMax`',
          '130 · 175 · 230ms',
          'Micro-interactions: hover, a toggle, a checkbox.',
        ],
        <String>[
          '`mediumMin` · `medium` · `mediumMax`',
          '310 · 410 · 550ms',
          'Entrances and exits: a dialog, a drawer, a panel.',
        ],
        <String>[
          '`slowMin` · `slow` · `slowMax`',
          '730 · 975 · 1300ms',
          'The long ones. Rare in a tool.',
        ],
      ],
    ),
    DocProse(
      'The single easing, `--ease-standard`, is '
      '`cubic-bezier(0.24, 1, 0.4, 1)` — a fast start that settles. One curve, '
      'because a design system with five is a design system where nobody '
      'agrees which to use.',
    ),
    DocHeading('Always through AstryxMotion'),
    DocProse(
      'Read a duration from `AstryxMotion`, never from the theme. It is the '
      'layer that returns `Duration.zero` when the platform asks for reduced '
      'motion — zero rather than merely shorter, because the setting exists '
      'for people whom movement makes unwell, and a fast animation is still an '
      'animation.',
    ),
    DocCode('''
final motion = AstryxMotion.of(context);

AnimatedContainer(
  duration: motion.duration(AstryxDurationToken.fast),
  curve: motion.curve(),
  // …
)'''),
    DocProse(
      'For the cases a zero duration cannot express — a looping spinner, a '
      'shimmer — ask `motion.animate`, or '
      '`AstryxMotionAccess.animate(context)` where there is no theme to '
      'resolve. The honest response to reduced '
      'motion is to stop, not to race.',
    ),
    DocHeading('What reduced motion does'),
    DocList(<String>[
      'Transitions become instantaneous. The end state is the same state — '
          'nothing is skipped, only the travel.',
      'The spinner paints a complete ring instead of rotating.',
      'The indeterminate progress bar stops travelling.',
      'Nothing disappears. A stopped indicator still says "working", because '
          'the alternative is a screen that looks finished when it is not.',
    ]),
    DocCallout.accessibility(
      'The switch is the platform’s, read through '
      '`MediaQuery.disableAnimationsOf`. Use the device’s own reduce-motion '
      'setting to check a screen — there is nothing to turn on in the package.',
    ),
    DocHeading('A faster or slower theme'),
    DocProse(
      'Give the two bases and a ratio; each band expands into a min, base and '
      'max triple where `min = base × ratio` and `max = base ÷ ratio`. A '
      'snappy theme lowers the bases, a cinematic one raises them, and the '
      'proportions survive either change.',
    ),
    DocCode('''
// The default motion scale.
const AstryxMotionScaleConfig(
  fast: 175,
  medium: 410,
  slow: 975,
  ratio: 0.75,
);

final acmeSnappy = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme-snappy',
    motion: AstryxMotionScaleConfig(fast: 120, medium: 260, ratio: 0.75),
  ),
);'''),
    DocHeading('Related'),
    DocList(<String>[
      '[Accessibility](accessibility) — the rest of the rules, in one place.',
      '[AstryxSpinner](spinner) — what stopping looks like.',
      '[Design tokens](tokens) — the other token families.',
    ]),
  ],
);

const DocPage _layout = DocPage(
  id: 'layout_guide',
  title: 'Layout',
  group: _group,
  description:
      'Page structure: the shell, the content column, and the '
      'breakpoints between them.',
  upstreamPath: '/docs/layout',
  blocks: <DocBlock>[
    DocProse(
      'There is no page widget. A screen is assembled from the same four '
      'primitives a card is — a measure, a column of sections, a row for a '
      'header, a grid for tiles — which is why there is nothing to learn here '
      'beyond where each one belongs.',
    ),
    DocExample('layout_page', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['Primitive', 'Its job on a page'],
      rows: <List<String>>[
        <String>[
          '[AstryxCenter](center)',
          'The measure. `maxWidth` stops a line of text running the width of a '
              'monitor; `paddingBlock` gives the page air.',
        ],
        <String>[
          '[AstryxVStack](stack)',
          'The sections, with one `gap` doing the grouping.',
        ],
        <String>[
          '[AstryxHStack](stack)',
          'A header row. `mainAxisSize: MainAxisSize.max` with '
              '`justify: between` pushes the actions to the trailing edge.',
        ],
        <String>[
          '[AstryxGrid](grid)',
          'Tiles. `minWidth` sets the column count from the space available.',
        ],
        <String>[
          '[AstryxDivider](divider)',
          'A rule where a gap alone is not enough.',
        ],
      ],
    ),
    DocHeading('Responsive without breakpoints'),
    DocProse(
      'There is no breakpoint system, and that is deliberate. `AstryxGrid` '
      'takes a `minWidth` and works out its own column count — '
      '`repeat(auto-fit, minmax(…, 1fr))`, in CSS terms — so most responsive '
      'behaviour needs no threshold at all.',
    ),
    DocProse(
      'Where a layout genuinely has to change shape, use a `LayoutBuilder` and '
      'a number that lives beside the widget that needs it. A form knows the '
      'width it wants; a global breakpoint table means every screen has to '
      'agree about a number none of them chose.',
    ),
    DocCode('''
// From the two-column form template.
const double formTwoColumnMinWidth = 620;

LayoutBuilder(
  builder: (context, constraints) => constraints.maxWidth < formTwoColumnMinWidth
      ? _oneColumn()
      : _twoColumns(),
)'''),
    DocCallout.note(
      'Every example on this site has a device picker above it for the same '
      'reason: a responsive decision is only judged by making the constraints '
      'smaller, not by reading the code.',
    ),
    DocHeading('The vertical rhythm'),
    DocProse(
      'Section gaps come from the spacing scale like everything else — '
      '`spacing6` and up between the parts of a page, `spacing3` inside a '
      'group. Set the gap on the stack rather than padding the children, and '
      'a reordered section keeps the rhythm.',
    ),
    DocHeading('What is not here yet'),
    DocProse(
      'Upstream’s layout page also covers the application shell — the nav bar, '
      'the sidebar, the breadcrumb trail above the content. Those components '
      'are not ported yet; they carry the *Soon* badge under **Navigation** '
      'and **App shell** in the sidebar. Until they land, a shell is a '
      '`Row` of your own around the content column.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Spacing](spacing) — the scale the gaps come from.',
      '[Dashboard](dashboard) — a whole screen, assembled.',
      '[Two-column form](form_two_column) — the `LayoutBuilder` pattern in '
          'full.',
    ]),
  ],
);

const DocPage _icons = DocPage(
  id: 'icons',
  title: 'Icons',
  group: _group,
  description:
      'The icon registry, the Lucide mapping, and how to supply your '
      'own set.',
  upstreamPath: '/docs/icons',
  blocks: <DocBlock>[
    DocProse(
      'An icon is asked for by **meaning**, never by picture: '
      '`AstryxIconName.success`, not `circle-check`. The 28 names are a '
      'contract between the components and the theme — the component says what '
      'it means, the registry decides what that looks like, and swapping icon '
      'sets is one line rather than a hundred call sites.',
    ),
    DocExample('icons_registry_swap', align: DocExampleAlign.stretch),
    DocHeading('The default registry'),
    DocProse(
      '`AstryxIconRegistry.defaults` maps every name onto '
      '[Lucide](https://lucide.dev), which is what upstream uses. All seven '
      'prebuilt themes ship the same mapping — a fact a test pins, so a future '
      'theme that diverges is caught rather than silently flattened.',
    ),
    DocProse(
      'The 28 names, live, are on the [AstryxIcon](icon) page. They cover what '
      'the widget set itself needs — a close button, a chevron, a sort arrow, '
      'the four status glyphs — and deliberately stop there.',
    ),
    DocHeading('Installing your own'),
    DocCode('''
AstryxThemeProvider(
  icons: AstryxIconRegistry.defaults.copyWith(
    const <AstryxIconName, IconData>{
      AstryxIconName.close: MyIcons.close,
      AstryxIconName.check: MyIcons.check,
    },
  ),
  child: const HomePage(),
)'''),
    DocCallout.warning(
      'Build from `defaults` unless you mean to replace the whole set. A '
      'registry is installed wholesale, not merged: '
      '`AstryxIconRegistry(icons: {…})` with two entries has exactly two, and '
      'the twenty-six names it omits throw a `StateError` when something asks '
      'for one. `isComplete` answers whether a registry covers every name.',
    ),
    DocProse(
      'A missing name throws rather than painting nothing on purpose — an icon '
      'that silently disappears is a theme bug you find in production, and the '
      'error names the gap.',
    ),
    DocHeading('Icons the registry does not name'),
    DocProse(
      'Do not widen the registry for "edit" or "delete". Every slot that takes '
      'an icon takes a `Widget`, so an application uses its own icon family '
      'directly and keeps `AstryxIconName` as the transcription of upstream’s '
      'own union that it is.',
    ),
    DocCode('''
AstryxButton(
  label: 'Delete',
  leading: const Icon(MyIcons.trash),
  variant: AstryxButtonVariant.destructive,
  onPressed: confirmDelete,
)'''),
    DocHeading('Direction'),
    DocProse(
      'Five names mirror under RTL — the four chevrons and `externalLink` — '
      'and the rest do not. The set is explicit rather than inferred, because '
      'each of the exceptions is a plausible mistake: sort arrows are on the '
      'block axis, a clock runs clockwise in every locale, a tick is a glyph '
      'rather than a direction, and a mirrored magnifier just reads as a bug.',
    ),
    DocExample('icons_mirroring', align: DocExampleAlign.stretch),
    DocProse(
      '`mirrorForRtl` overrides the decision for one icon — for a custom '
      'registry whose glyph points the other way, or a name whose meaning in '
      'your product is directional when the default set says it is not.',
    ),
    DocHeading('Size and colour'),
    DocProse(
      'Both are inherited by default: a null `size` takes the enclosing '
      '`IconTheme`’s, and `AstryxIconColor.inherit` takes the surrounding text '
      'colour. That is what lets a button, a badge or a disabled menu row tint '
      'an icon it did not build — including one you supplied. See '
      '[AstryxIcon](icon) for the four sizes and nine colours.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxIcon](icon) — the component, and every name it knows.',
      '[AstryxIconButton](icon_button) — an icon that does something.',
      '[Theming](theming) — where the registry sits among the other theme '
          'inputs.',
    ]),
  ],
);

const DocPage _illustrations = DocPage(
  id: 'illustrations',
  title: 'Illustrations',
  group: _group,
  description:
      'The upstream illustration set, and what a Flutter port would '
      'need to carry it.',
  upstreamPath: '/docs/illustrations',
  blocks: <DocBlock>[
    DocCallout.warning(
      'No illustrations ship with `astryx_ui`, and none are planned. This page '
      'is the reasoning, and the composition to use instead.',
    ),
    DocProse(
      'Upstream ships an illustration set for the places a screen has nothing '
      'to show — empty states, first runs, errors, permission walls. It is '
      'artwork rather than a component: SVG assets that ship with the library '
      'and pick up the theme’s colours.',
    ),
    DocHeading('Why it is not here'),
    DocList(<String>[
      '**The package renders no assets.** Its only runtime dependencies are '
          '`collection`, `meta` and an icon font. Illustrations mean SVG, and '
          'SVG in Flutter means `flutter_svg` or `vector_graphics` — a real '
          'dependency for every consumer, most of whom would never draw one.',
      '**The artwork is Meta’s.** The token engine is a reimplementation from '
          'documented behaviour and a test suite; an illustration set is not '
          'something a port can reimplement. Carrying the files is a licensing '
          'question, not an engineering one.',
      '**A design system can stop short of art.** Everything else here is '
          'behaviour — layout, contrast, focus, keyboard. Illustration is the '
          'one part a product is usually happier owning.',
    ]),
    DocHeading('An empty state today'),
    DocProse(
      'The composition upstream illustrates is already available: '
      '[AstryxCenter](center) with a `minHeight`, an icon or your own asset, a '
      'heading, a supporting line, and one action. The '
      '[centred hero](centered_hero) template is the same shape with copy '
      'instead of artwork.',
    ),
    DocCode('''
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
)'''),
    DocProse(
      'For real artwork, add `flutter_svg` to *your* application and put the '
      'asset where the icon is above. Colour it from a token — '
      '`AstryxTheme.of(context).color(AstryxColorToken.iconSecondary)` — and '
      'it will follow every theme and both brightnesses like everything else '
      'on the screen.',
    ),
    DocCallout.accessibility(
      'An illustration is decoration. Wrap it in `ExcludeSemantics` and let '
      'the heading beneath it carry the meaning — an empty state announced as '
      '"image" is worse than one announced as nothing at all.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCenter](center) — the empty-state box.',
      '[Centred hero](centered_hero) — the same shape, as a template.',
      '[Icons](icons) — what does ship, and how to swap it.',
    ]),
  ],
);

const DocPage _styling = DocPage(
  id: 'styling',
  title: 'Styling',
  group: _group,
  description:
      "Extending a component's appearance without leaving the token "
      'system.',
  upstreamPath: '/docs/styling',
  blocks: <DocBlock>[
    DocProse(
      'Four ways to change how something looks, in the order you should reach '
      'for them. Each one is narrower than the last, and all four resolve '
      'through the same tokens — which is what keeps a customised screen '
      'themeable.',
    ),
    DocTable(
      headers: <String>['Reach for', 'When'],
      rows: <List<String>>[
        <String>[
          'A widget parameter',
          'Almost always. `variant`, `size`, `padding`, `gap` — the axes the '
              'component already has.',
        ],
        <String>[
          '`theme:` on the widget',
          'One instance genuinely differs. Takes that widget’s theme class.',
        ],
        <String>[
          '`AstryxTheme` with `copyWith`',
          'Every instance in a subtree, or in the whole app.',
        ],
        <String>[
          '`tokens:` on the theme',
          'The value itself is wrong for your product — a tighter radius, a '
              'different spacing step. Changes everything at once.',
        ],
      ],
    ),
    DocExample('styling_scopes', align: DocExampleAlign.stretch),
    DocHeading('Component themes'),
    DocProse(
      'A component theme is a small immutable class carrying only that '
      'widget’s visual properties, **every field nullable** — null means "fall '
      'through to the token default", so overriding one state does not mean '
      'restating the others. Resolution is always: the widget’s own property, '
      'then the inherited component theme, then the token.',
    ),
    DocTable(
      headers: <String>['Class', 'Applies to', 'Carries'],
      rows: <List<String>>[
        <String>[
          '`AstryxButtonTheme`',
          '`AstryxButton`, `AstryxIconButton`',
          'Backgrounds per state, foreground, border, radius, padding, gap, '
              'text style, height, icon size, shadows, cursors.',
        ],
        <String>[
          '`AstryxTextTheme`',
          '`AstryxText`, `AstryxHeading`',
          'A `TextStyle` and an alignment. `text` and `heading` are separate '
              'slots on the theme.',
        ],
        <String>['`AstryxIconTheme`', '`AstryxIcon`', 'Size and colour.'],
        <String>[
          '`AstryxDividerTheme`',
          '`AstryxDivider`',
          'Thickness, colour and inset.',
        ],
      ],
    ),
    DocProse(
      'Those four are what exist today. Everything else is styled through its '
      'own parameters and the tokens beneath them.',
    ),
    DocHeading('For a subtree, or the whole app'),
    DocCode('''
Builder(
  builder: (context) => AstryxTheme(
    data: AstryxTheme.of(context).copyWith(
      button: const AstryxButtonTheme(borderRadius: BorderRadius.zero),
    ),
    // Inherited scopes are not automatic — carry them across.
    density: AstryxTheme.densityOf(context),
    icons: AstryxTheme.iconsOf(context),
    child: const HomePage(),
  ),
)'''),
    DocProse(
      'The `Builder` is there so the `context` is *below* the provider that '
      'installed the theme. Put this immediately under `AstryxApp` or '
      '`AstryxThemeProvider` for an application-wide change, or around a '
      'single pane for a local one.',
    ),
    DocCallout.note(
      '`AstryxTheme` replaces the density and icon registry rather than '
      'inheriting them, so pass both through as above. Forget them and a '
      'custom icon set quietly reverts to Lucide, and a touch device loses its '
      '48px targets.',
    ),
    DocHeading('When the value itself is wrong'),
    DocProse(
      'If every button should be square, the radius scale is the honest place '
      'to say so — not a component theme repeated in four files. `tokens:` '
      'beats every generated value, and a scale config moves a whole family at '
      'once.',
    ),
    DocCode('''
final acme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    radius: AstryxRadiusScaleConfig(base: 4, multiplier: 0),
    tokens: <String, AstryxTokenValue>{
      '--color-border': AstryxTokenValue('#8F9296'),
    },
  ),
);'''),
    DocHeading('Building something the widget set has not got'),
    DocProse(
      'Read the tokens and compose. A widget written this way is themeable by '
      'construction: it follows all eight themes, both brightnesses and any '
      'custom accent without knowing that any of them exist.',
    ),
    DocCode('''
final theme = AstryxTheme.of(context);

DecoratedBox(
  decoration: BoxDecoration(
    color: theme.color(AstryxColorToken.backgroundCard),
    borderRadius: theme.borderRadius(AstryxRadiusToken.container),
    border: Border.all(color: theme.color(AstryxColorToken.border)),
    boxShadow: theme.boxShadows(AstryxShadowToken.low),
  ),
  child: Padding(
    padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
    child: Text('…', style: theme.textStyle(AstryxTypeRole.body)),
  ),
)'''),
    DocCallout.warning(
      'The one thing not to do is reach past the system: a `Color(0xFF…)`, a '
      '`TextStyle(fontSize: 14)`, an `EdgeInsets.all(16)`. Each compiles, '
      'looks right in the theme you are using, and is wrong in the other '
      'seven — and in dark mode, and at the next density.',
    ),
    DocHeading('A note on `components:`'),
    DocProse(
      'A theme definition also takes a `components:` map of CSS-style property '
      'overrides. It is a faithful port of upstream’s `ComponentStyleMap` and '
      'is carried, merged and compared like the rest of a definition — but the '
      'Flutter widgets read the typed component themes above, not CSS strings. '
      'Use it when you are keeping a Dart theme definition in step with a '
      'TypeScript one; use `AstryxButtonTheme` and friends to change how a '
      'button looks.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Theming](theming) — defining a theme, and the layers within one.',
      '[Design tokens](tokens) — what the escape hatches resolve to.',
      '[Shape](shape) — the radius scale, for the square-corners case.',
    ]),
  ],
);

const DocPage _core = DocPage(
  id: 'core',
  title: 'The token engine',
  group: _group,
  description:
      'How a theme definition becomes resolved tokens, and where the '
      'resolution happens.',
  upstreamPath: '/docs/core',
  blocks: <DocBlock>[
    DocProse(
      'A theme is written as data, turned into a map of concrete values once, '
      'and read as Flutter types from then on. Three steps, one direction — '
      'nothing downstream can change a token, and nothing upstream knows what '
      'a `Color` is.',
    ),
    DocTree('''
AstryxDefineThemeInput     what you write
      │
      │  defineTheme()           expand the scales, merge the layers
      ▼
AstryxDefinedTheme         token name → CSS string, possibly a var()
      │
      │  AstryxResolvedTokenSet.resolve()
      ▼
AstryxResolvedTokenSet     terminal strings, one map per mode
      │
      │  AstryxThemeData()       parse, and pick a mode
      ▼
AstryxThemeData            Color, double, Duration, Curve, TextStyle
      │
      │  AstryxTheme             an InheritedWidget
      ▼
the widgets'''),
    DocHeading('1. The definition'),
    DocProse(
      '`defineTheme` builds one flat map of CSS custom properties, in '
      'precedence order. Each layer writes over the one before it:',
    ),
    DocList(<String>[
      'The **token defaults** — every property Astryx ships.',
      'The **base theme**, when `extendsTheme` names one.',
      'The **generated scales**: colour from the seed accent, and the type, '
          'radius and motion expanders.',
      'The **font families** and the syntax-highlighting tokens.',
      'The **explicit `tokens:` map**, which beats everything above it.',
    ], ordered: true),
    DocProse(
      'The output is an `AstryxDefinedTheme`: a name, a token map, the '
      'component overrides, the icon entries, and the on-dark and on-light '
      'sets. Still strings — nothing has been parsed yet.',
    ),
    DocHeading('2. Resolution'),
    DocProse(
      'Generated themes emit derived tokens as *references*: '
      '`--color-text-accent` is literally `var(--color-accent)`, so overriding '
      'the accent re-themes everything pointing at it. In a browser the CSS '
      'cascade does that work. There is no cascade here, so the resolver '
      'replays it.',
    ),
    DocList(<String>[
      '`var()` references are followed through the map, with a cycle guard.',
      '`light-dark(a, b)` is split, producing **two** maps — one per mode — '
          'rather than a mode flag consulted at read time.',
      '`color-mix(in srgb, …)` is evaluated. Other colour spaces are '
          '**refused** rather than approximated: the expression is preserved '
          'with its references resolved, which is upstream’s behaviour and '
          'part of the contract.',
    ]),
    DocProse(
      'Resolution is eager and happens once. A theme is read far more often '
      'than it changes, and the resulting set is cheap to compare — its hash '
      'is computed during construction, so the `updateShouldNotify` path is an '
      'identity check and at worst an integer comparison.',
    ),
    DocExample('core_pipeline', align: DocExampleAlign.stretch),
    DocProse(
      'Five tokens from one small definition, and every route through the '
      'engine is visible in them: `accent` was generated from the seed; '
      '`textAccent` was a `var()` reference to it; `backgroundCard` is a '
      '`light-dark()` pair, which is why its two columns differ; `element` was '
      'overridden by hand; and `fast` was never mentioned, so the token '
      'default stands.',
    ),
    DocHeading('3. Flutter values'),
    DocProse(
      '`AstryxThemeData` takes a resolved set and a mode and parses the '
      'strings into `Color`, `double`, `Duration`, `Curve`, `FontWeight`, '
      '`TextStyle` and font stacks. The conversion is driven by the **token '
      'enums**, not by name prefixes — `--text-heading-1-weight` is a font '
      'weight and does not start with `--font-weight-`, so a prefix rule would '
      'put it in the wrong bucket.',
    ),
    DocProse(
      'This is also where the platform enters, and the only place it does: a '
      'font stack resolves differently on Apple platforms and on Windows. '
      'Everything else is platform-independent — see '
      '[Platform support](platform_support).',
    ),
    DocHeading('Running the engine on its own'),
    DocProse(
      'Layers 0 and 1 have no Flutter dependency, so a theme can be resolved '
      'in a plain Dart test, a build script, or a tool that emits tokens for '
      'something that is not Flutter at all.',
    ),
    DocCode(
      '''
import 'package:astryx_ui/theme.dart';

final tokens = AstryxResolvedTokenSet.resolve(myTheme);

tokens.value(AstryxColorToken.accent, AstryxThemeMode.light);  // '#0064E0'
tokens.pair(AstryxSpacingToken.spacing4);                      // ('16px', '16px')
tokens.forMode(AstryxThemeMode.dark);                          // the whole map''',
    ),
    DocHeading('The registry'),
    DocProse(
      '`defineTheme` registers each theme under its name as a side effect, so '
      'a theme picker can enumerate what an application has defined without '
      'being handed a list. `getRegisteredTheme(name)` and '
      '`getRegisteredThemes()` read it; registering the same name twice '
      'replaces the earlier entry.',
    ),
    DocCallout.note(
      'The engine is a port, not a design. Every expander, the HCT colour '
      'model and the contrast maths are checked against upstream’s own test '
      'fixtures, so the same definition written in Dart and in TypeScript '
      'produces the same token values. See [Principles](principles).',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Theming](theming) — the definition, from the outside.',
      '[Design tokens](tokens) — what the output is made of.',
      '[Styling](styling) — the escape hatches at each layer.',
    ]),
  ],
);

const DocPage _platformSupport = DocPage(
  id: 'platform_support',
  title: 'Platform support',
  group: _group,
  description:
      'Which Flutter platforms are exercised, and where behaviour '
      "differs. The Flutter counterpart of upstream's browser-support "
      'page.',
  upstreamPath: '/docs/browser-support',
  blocks: <DocBlock>[
    DocExample('platform_targets', align: DocExampleAlign.stretch),
    DocProse(
      'Upstream publishes a browser support matrix. The Flutter counterpart is '
      'shorter than a matrix: **everywhere Flutter runs**. There is no '
      'conditional import in the package, no `dart:io`, no `kIsWeb`, no method '
      'channel and no plugin — its `flutter:` section is empty, so there is no '
      'platform for it to fail to support.',
    ),
    DocHeading('What actually varies'),
    DocTable(
      headers: <String>['Thing', 'How it differs'],
      rows: <List<String>>[
        <String>[
          'Density',
          'iOS and Android resolve to `touch`; macOS, Windows, Linux and '
              'Fuchsia to `pointer`. A `MediaQuery` reporting a coarse pointer '
              'overrides both.',
        ],
        <String>[
          'Font stacks',
          'A CSS generic expands to different concrete families per platform — '
              'Menlo on Apple, Consolas on Windows. A stack leading with a '
              'system alias resolves to a *null* family, which is Flutter’s '
              'way of saying "the platform UI font".',
        ],
        <String>[
          'Everything else',
          'Identical. Colour, spacing, type, motion, focus, semantics and '
              'keyboard behaviour are the same on every target.',
        ],
      ],
    ),
    DocProse(
      'Both differences run through `TargetPlatform`, which means both are '
      'overridable: `AstryxThemeProvider.platform` forces the answer, which is '
      'how a test — or the picker at the top of this page — previews another '
      'platform’s rendering.',
    ),
    DocHeading('The web'),
    DocProse(
      'The web is the case worth understanding, because the platform Flutter '
      'reports there is the *host OS* rather than the input device. A '
      'Chromebook with a mouse attached reports Android; a Windows tablet with '
      'no mouse reports Windows. That is exactly why density consults pointer '
      'precision first and the platform second — see [Density](density).',
    ),
    DocProse(
      'This documentation site is the package running in Flutter web, in eight '
      'themes and both densities. It is the standing proof, and any rendering '
      'bug on the web is visible on the page you are reading.',
    ),
    DocHeading('Deliberately the same everywhere'),
    DocList(<String>[
      '**Text selection handles** are one shape on every platform, coloured '
          'from `--color-accent`. Astryx never ran natively, so imitating a '
          'platform’s own handles would be inventing rather than porting.',
      '**Keyboard behaviour** is the design system’s, not the platform’s: '
          'arrows inside composite controls, `Escape` closing one layer at a '
          'time, `Enter` and `Space` activating. No shortcut in the package '
          'competes with an application’s own.',
      '**Focus rings** appear for keyboard focus and not for a click, on every '
          'target, because the rule is `:focus-visible` rather than a platform '
          'convention.',
    ]),
    DocHeading('Versions'),
    DocTable(
      headers: <String>['Requires', 'Version'],
      rows: <List<String>>[
        <String>['Dart', '`>=3.9.0 <4.0.0`'],
        <String>['Flutter', '`>=3.35.0`'],
      ],
    ),
    DocHeading('How it is verified'),
    DocList(<String>[
      'Over 900 tests, run on the Dart VM. Widget tests pump the widgets '
          'directly, so they exercise the same code every target runs.',
      'Platform-dependent behaviour is tested by *forcing* the platform rather '
          'than by running on it: density, font-stack resolution and tap '
          'targets each have cases per `TargetPlatform`.',
      'The golden suite is tagged `golden` and excluded elsewhere with '
          '`--exclude-tags golden`. Rasterised output is only stable for a '
          'pinned Flutter version, so a golden failure on a newer version is a '
          'version difference rather than a regression.',
    ]),
    DocCallout.note(
      'The example app in this repository has runners for Android, iOS, Linux, '
      'macOS and web — not Windows. Nothing in the package is Windows-specific '
      'and the font stack has an explicit Windows branch, but if you ship '
      'there, add the runner and look at it yourself rather than taking this '
      'page’s word for it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Density](density) — the pointer and touch difference, in detail.',
      '[Typography](typography) — the font stacks that resolve per platform.',
      '[The token engine](core) — where platform resolution happens.',
    ]),
  ],
);

const DocPage _density = DocPage(
  id: 'density',
  title: 'Density',
  group: _group,
  description: 'One widget set that is honest on a mouse and on a thumb.',
  blocks: <DocBlock>[
    DocProse(
      'Astryx targets pointer and touch equally. The density is resolved from '
      'the platform *and* the pointer precision `MediaQuery` reports — which '
      'matters on the web, where the reported platform is the host OS rather '
      'than the input device: a Chromebook with a mouse attached reports '
      'Android, and a Windows tablet without one reports Windows.',
    ),
    DocExample('theming_density', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['', '`pointer`', '`touch`'],
      rows: <List<String>>[
        <String>['Minimum tap target', 'the control’s own height', '48px'],
        <String>['Hover affordances', 'active', 'suppressed'],
        <String>['Default toast position', 'a corner', 'the bottom'],
      ],
    ),
    DocProse(
      'Note what does **not** change: the control’s painted height. Touch '
      'density grows the region that responds to a finger, not the button — so '
      'a form does not reflow when someone plugs in a mouse.',
    ),
    DocHeading('Overriding it'),
    DocCode('''
AstryxThemeProvider(
  density: AstryxDensity.touch,
  child: const HomePage(),
)'''),
    DocProse(
      'Leave it null to follow the platform, which is what an application '
      'should normally do. The density picker at the top of this page has an '
      '`auto` setting for exactly that.',
    ),
    DocHeading('Reading it'),
    DocProse(
      'Gate every hover style on `supportsHover`, never on the platform: a '
      'widget on a touch device must not offer a state the user cannot reach.',
    ),
    DocCode('''
final density = AstryxTheme.densityOf(context);

if (density.supportsHover && _hovered) {
  // …hover styling.
}'''),
    DocCallout.warning(
      'Nothing important may live behind hover alone. That is why '
      '[table](table) row actions are always visible, and why a '
      '[tooltip](tooltip) may never be the only place a piece of information '
      'appears.',
    ),
    DocProse(
      '48px is the strictest of the three guidelines that apply — Apple’s HIG '
      'and WCAG 2.5.5 both say 44, Material says 48. Meeting the strictest '
      'means one number satisfies every platform, rather than a control that '
      'passes on iOS and fails on Android.',
    ),
  ],
);

const DocPage _rtl = DocPage(
  id: 'rtl',
  title: 'Right-to-left',
  group: _group,
  description:
      'Logical throughout, so RTL is a `Directionality` and nothing '
      'more.',
  upstreamPath: '/docs/internationalization',
  blocks: <DocBlock>[
    DocProse(
      'There is no RTL mode to switch on. Every component is written in '
      'logical terms — start and end rather than left and right — so wrapping '
      'your app in a `Directionality` is the whole of it.',
    ),
    DocExample('theming_rtl', align: DocExampleAlign.stretch),
    DocCode('''
Directionality(
  textDirection: TextDirection.rtl,
  child: const HomePage(),
)'''),
    DocTable(
      title: 'What flips, without being asked',
      headers: <String>['Thing', 'Under RTL'],
      rows: <List<String>>[
        <String>[
          'Padding and alignment',
          '`paddingInline`, `AstryxStackAlign.start`, everything logical.',
        ],
        <String>[
          'Icons',
          'Directional glyphs mirror — chevrons and arrows do, a calendar does '
              'not.',
        ],
        <String>[
          'Button groups',
          'The "first" child rounds its reading-start corners.',
        ],
        <String>[
          'Overlay sides',
          '`AstryxOverlaySide.left` and `.right` resolve against the '
              'direction.',
        ],
        <String>[
          'Arrow keys',
          '`→` and `←` swap in tab lists, radio groups, switches and submenus.',
        ],
        <String>[
          'Toast placement',
          '`bottomEnd` hugs the trailing edge, whichever side that is.',
        ],
        <String>[
          'Table alignment',
          '`AstryxTableAlignment.end` follows the reading direction.',
        ],
      ],
    ),
    DocCallout.note(
      'The block axis never flips: `top` and `bottom` mean what they say in '
      'every locale Astryx supports.',
    ),
    DocProse(
      'Use the LTR/RTL switch at the top of this page on any component page. '
      'Every example on this site is written without a single reference to '
      'direction, which is the point — if one of them looks wrong in RTL, that '
      'is a bug in the widget, not in the example.',
    ),
  ],
);

const DocPage _accessibility = DocPage(
  id: 'accessibility',
  title: 'Accessibility',
  group: _group,
  description: 'The rules the whole widget set is built to, in one place.',
  blocks: <DocBlock>[
    DocProse(
      'These are not aspirations. Each one is enforced by the components '
      'themselves, and most are pinned by tests.',
    ),
    DocHeading('Names are required, not optional'),
    DocList(<String>[
      '`AstryxButton` takes a `label`, never a `child` — a button whose '
          'content is arbitrary is a button whose accessible name is a guess.',
      '`AstryxIconButton` requires a `label` even though it paints none.',
      '`AstryxCheckbox` requires a `label`; upstream does too, for the same '
          'reason.',
      'A pressable `AstryxCard` wants a `semanticsLabel`, or a screen reader '
          'announces its entire contents as the button’s name.',
      '`labelHidden` hides a label from sight and keeps it as the name. It is '
          'the right tool when a visible label would be redundant — never a '
          'reason to omit one.',
    ]),
    DocHeading('Focus'),
    DocList(<String>[
      'The focus ring appears for keyboard focus and not for a click — CSS’s '
          '`:focus-visible`, ported.',
      'Overlays trap focus while open and return it to the trigger on close.',
      '`Escape` closes **one layer at a time**: a popover inside a dialog '
          'closes without taking the dialog with it.',
      'Composite controls are one tab stop, not one per child: a radio group, '
          'a tab strip and a menu are each entered once and navigated with '
          'arrows.',
    ]),
    DocHeading('Announcements'),
    DocList(<String>[
      'Only errors interrupt. A `warning` or `success` banner and a field’s '
          'success message wait their turn — interrupting for good news is its '
          'own problem.',
      'A field’s description *and* its status message both become the '
          'control’s hint, joined rather than one winning.',
      'A `loading` button reports itself as disabled while the work is in '
          'flight.',
      '`AstryxBanner.announce: false` for a banner that is part of the page’s '
          'initial state and has nothing to announce.',
    ]),
    DocHeading('Nothing behind hover alone'),
    DocList(<String>[
      'Table row actions are always visible. Upstream reveals them on hover; '
          'hover does not exist on touch.',
      'Every hover interaction has a gesture path — a tooltip opens on '
          'long-press and lingers, because the finger is over the thing it '
          'describes.',
      'Touch density raises every tap target to 48px, the strictest of the '
          'guidelines that apply.',
    ]),
    DocHeading('Colour is never the only signal'),
    DocList(<String>[
      'Every status carries an icon as well as a fill.',
      'The ten categorical palettes are for *categories*, never severity: a '
          'colour-blind user tells error from success by icon and position.',
      'The `subtle` divider is roughly 1.1:1 and therefore decoration — never '
          'a control’s only visible boundary.',
    ]),
    DocHeading('Motion'),
    DocProse(
      'Every animation goes through `AstryxMotion`, which honours '
      '`MediaQuery.disableAnimations`. Transitions become instantaneous; the '
      'spinner paints a complete ring instead of rotating; the indeterminate '
      'progress bar stops travelling. Nothing disappears — the state stays '
      'legible without the movement.',
    ),
    DocHeading('Known defects, kept'),
    DocCallout.warning(
      'Upstream’s `stone` theme sets `--color-on-error` equal to '
      '`--color-error` — a 1.00:1 contrast failure. It is reproduced '
      'faithfully rather than corrected, and pinned by a test, because '
      'silently diverging from upstream is worse than a documented defect. An '
      'error [badge](badge) is where it shows. Override the token if it '
      'affects you.',
    ),
    DocProse(
      'The status icons are stroked, not solid. Upstream fills them for '
      'legibility at small sizes; Lucide ships no filled variants. Swap the '
      'icon registry if this matters to you.',
    ),
  ],
);
