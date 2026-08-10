import 'package:example/docs/model.dart';

/// The pages that are not about one component.
final List<DocPage> guidePages = <DocPage>[
  _introduction,
  _installation,
  _theming,
  _tokens,
  _density,
  _rtl,
  _accessibility,
];

const String _group = 'Getting started';

const DocPage _introduction = DocPage(
  id: 'introduction',
  title: 'astryx_ui',
  group: _group,
  description:
      'An unofficial Flutter port of Astryx, Meta’s design system for '
      'internal tools.',
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
  blocks: <DocBlock>[
    DocHeading('Add the dependency'),
    DocProse(
      'Not yet published to pub.dev. Until then, depend on it by path or by '
      'git.',
    ),
    DocCode(
      '''
dependencies:
  astryx_ui:
    path: ../astryx_ui''',
      language: 'yaml',
      title: 'pubspec.yaml',
    ),
    DocCode(
      '''
dependencies:
  astryx_ui:
    git:
      url: https://github.com/JayashBhandary/astryx_ui.git
      path: astryx_ui''',
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

const DocPage _theming = DocPage(
  id: 'theming',
  title: 'Theming',
  group: _group,
  description: 'Seven themes, two brightnesses, and an engine for your own.',
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
      '--spacing-4': AstryxTokenValue.length('12px'),
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
  icons: AstryxIconRegistry(<AstryxIconName, IconData>{
    AstryxIconName.search: MyIcons.search,
    // …the rest fall back to the default registry.
  }),
  child: const HomePage(),
)'''),
    DocHeading('Related'),
    DocList(<String>[
      '[Design tokens](tokens) — what a theme resolves to.',
      '[AstryxIcon](icon) — the names the registry knows.',
    ]),
  ],
);

const DocPage _tokens = DocPage(
  id: 'tokens',
  title: 'Design tokens',
  group: _group,
  description: 'The values every component resolves through.',
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
      'Roughly 100 colour tokens: the semantic set, the `--color-on-*` '
      'foregrounds that guarantee contrast against them, and four tokens for '
      'each of the nine categorical families. A sample:',
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
  description: 'Logical throughout, so RTL is a `Directionality` and nothing '
      'more.',
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
      'The nine categorical palettes are for *categories*, never severity: a '
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
