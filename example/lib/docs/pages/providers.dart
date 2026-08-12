import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// The inherited widgets an application installs once, near its root.
///
/// Upstream ships these as React context providers. The Flutter counterparts
/// are `InheritedWidget`s, and one of them — the layer — is Flutter's own.
/// Each page records the mapping, because a reader arriving from the upstream
/// docs is looking for a name that does not exist here.
final List<DocPage> providerPages = <DocPage>[
  _theme,
  _layerProvider,
  _linkProvider,
  _internationalizationProvider,
  _syntaxTheme,
];

const String _group = DocGroup.providers;

const DocPage _theme = DocPage(
  id: 'theme',
  title: 'AstryxThemeProvider',
  group: _group,
  description:
      'The provider that puts a resolved theme in scope — and everything else '
      'the widgets need.',
  source: 'lib/src/app/astryx_theme_provider.dart',
  upstream: 'Theme',
  upstreamPath: '/components/Theme',
  blocks: <DocBlock>[
    DocProse(
      'Upstream’s `Theme` writes CSS custom properties onto an element and the '
      'cascade does the rest. Flutter has no cascade, so the same job is an '
      '`InheritedWidget` — and this widget installs it, along with the four '
      'other scopes a widget expects to find above it.',
    ),
    DocHeading('Usage'),
    DocCode('''
AstryxApp(
  theme: neutralTheme,
  home: const HomePage(),
)'''),
    DocProse(
      'That is the whole setup for an app built on Astryx alone. To adopt the '
      'package inside an existing `MaterialApp` or `CupertinoApp`, wrap a '
      'subtree instead — `AstryxApp` composes exactly this, so the two behave '
      'identically:',
    ),
    DocCode('''
MaterialApp(
  home: AstryxThemeProvider(
    theme: matchaTheme,
    mode: AstryxColorMode.system,
    child: const HomePage(),
  ),
)'''),
    DocHeading('What it installs'),
    DocTree('''
AstryxThemeProvider
└── AstryxTheme                 ← the resolved tokens, the density, the icons
    └── AstryxLocalizationsScope ← the strings
        └── AstryxLinkScope      ← what following a link means
            └── AstryxFocusVisibleScope ← keyboard focus vs mouse focus
                └── AstryxToastScope + host ← so `show(…)` needs no wiring
                    └── your app'''),
    DocProse(
      'All five, or none of them work: a toast raised from a button has to '
      'resolve the same theme, density and strings as the page that raised it, '
      'so the host sits **inside** the scopes rather than beside them. Nothing '
      'here needs to be wired twice.',
    ),
    DocExample('provider_theme', align: DocExampleAlign.stretch),
    DocHeading('Nesting'),
    DocProse(
      'A provider can be nested, and the inner one wins for its own subtree — '
      'a preview pane rendering another theme, a documentation page showing '
      'several of them, a dark toolbar over a light page. What it does **not** '
      'do is reach an overlay opened from outside it: an overlay resolves the '
      'theme above its own trigger, which is the one the user was looking at.',
    ),
    DocHeading('Colour mode'),
    DocTable(
      headers: <String>['`AstryxColorMode`', 'Resolves to'],
      rows: <List<String>>[
        <String>[
          '`system`',
          'The platform’s own preference, through '
              '`MediaQuery.platformBrightnessOf` — so the theme tracks a '
              'change without the app rebuilding anything. The default.',
        ],
        <String>['`light`', 'Always light.'],
        <String>['`dark`', 'Always dark.'],
      ],
    ),
    DocHeading('Reading what it installed'),
    DocCode('''
final theme = AstryxTheme.of(context);
theme.color(AstryxColorToken.accent);
theme.spacing(AstryxSpacingToken.spacing3);

AstryxTheme.densityOf(context).supportsHover;
AstryxLocalizations.of(context).dialogClose;'''),
    DocCallout.warning(
      '`AstryxTheme.of` throws a `FlutterError` with a fix-it when there is no '
      'provider above it, rather than falling back to a default. A widget '
      'silently painting unthemed colours is a bug that ships; an exception on '
      'the first frame is one that does not.',
    ),
    DocApi('AstryxThemeProvider', <DocProp>[
      DocProp('child', 'Widget', 'The subtree to theme.', required: true),
      DocProp(
        'theme',
        'AstryxDefinedTheme?',
        'The theme to resolve. Null uses the Astryx defaults, which are a '
            'complete and usable theme rather than a placeholder.',
      ),
      DocProp(
        'mode',
        'AstryxColorMode',
        'Which colour mode to resolve.',
        defaultValue: 'AstryxColorMode.system',
      ),
      DocProp(
        'density',
        'AstryxDensity?',
        'Overrides the resolved interaction density. Null derives it from the '
            'platform and the pointer precision `MediaQuery` reports.',
      ),
      DocProp(
        'icons',
        'AstryxIconRegistry?',
        'The icon registry for this subtree. Null uses the Lucide-backed '
            'defaults.',
      ),
      DocProp(
        'localizations',
        'AstryxLocalizations',
        'The strings the widgets use.',
        defaultValue: 'AstryxLocalizations()',
      ),
      DocProp(
        'platform',
        'TargetPlatform?',
        'Overrides the platform used for density and font-stack resolution. '
            'For tests, and for previewing another platform.',
      ),
      DocProp(
        'linkDelegate',
        'AstryxLinkDelegate?',
        'What following a link means. Null means links do nothing.',
      ),
      DocProp(
        'toastController',
        'AstryxToastController?',
        'The controller the toast host renders from. Null lets the provider '
            'own one.',
      ),
      DocProp(
        'toastPosition',
        'AstryxToastPosition?',
        'Where the toast stack sits. Null follows the resolved density.',
      ),
    ]),
    DocApi(
      'AstryxTheme',
      <DocProp>[
        DocProp(
          'of(context)',
          'AstryxThemeData',
          'The resolved theme. Throws when there is none.',
        ),
        DocProp(
          'maybeOf(context)',
          'AstryxThemeData?',
          'The resolved theme, or null — for a widget where a theme is '
              'genuinely optional.',
        ),
        DocProp(
          'densityOf(context)',
          'AstryxDensity',
          'The density in effect, falling back to the platform.',
        ),
        DocProp(
          'iconsOf(context)',
          'AstryxIconRegistry',
          'The icon registry in effect.',
        ),
      ],
      description:
          'The scope itself. Install it through `AstryxThemeProvider`; reach '
          'for these statics to read it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Theming](theming) — the seven prebuilt themes, and writing your own.',
      '[Design tokens](tokens) — what a resolved theme contains.',
      '[Density](density) — what the provider decides about pointers and '
          'thumbs.',
      '[Installation](installation) — the two entry points, in order.',
    ]),
  ],
);

const DocPage _layerProvider = DocPage(
  id: 'layer_provider',
  title: 'The overlay layer',
  group: _group,
  description: 'The stacking context overlays are raised into.',
  source: 'lib/src/foundation/overlay_stack.dart',
  upstream: 'LayerProvider',
  upstreamPath: '/components/LayerProvider',
  blocks: <DocBlock>[
    DocProse(
      'Upstream’s `LayerProvider` exists because the web has no built-in place '
      'to put floating content: a popover rendered inside a scrolling, '
      '`overflow: hidden` panel is clipped, so the provider gives every '
      'overlay one shared stacking context to portal into.',
    ),
    DocProse(
      '**Flutter already has that, and it is called `Overlay`.** There is '
      'therefore no `AstryxLayerProvider` to install: `AstryxApp`, '
      '`MaterialApp` and `CupertinoApp` each build an `Overlay`, and every '
      'Astryx overlay portals into the nearest one through `OverlayPortal`. '
      'What this page documents is the part Flutter does *not* provide — the '
      'order in which those layers close.',
    ),
    DocHeading('One Escape, one layer'),
    DocProse(
      'A popover opened from inside a dialog is the case that proves the '
      'problem. Without coordination both listen for Escape, both dismiss, and '
      'the user loses the dialog they were working in because they wanted to '
      'close a colour picker. `AstryxOverlayStack` is the fix: every '
      'dismissible layer registers while open, and only the top-most one '
      'answers.',
    ),
    DocExample('provider_layer', align: DocExampleAlign.start),
    DocProse(
      'Astryx overlays are `OverlayPortal`s rather than routes — deliberately, '
      'so a popover does not appear in the back stack and cannot be reached '
      'with the browser’s back button. Flutter’s `Navigator` gets this '
      'ordering from its route stack; a portal has no such stack, so the '
      'ordering is tracked here instead.',
    ),
    DocCallout.note(
      'Order is push order, and that is sound rather than lucky: a Flutter '
      'overlay opens when something calls `show`, and the inner one is always '
      'shown after the outer one that contains its trigger.',
    ),
    DocHeading('Where a layer is hosted'),
    DocProse(
      'The nearest `Overlay` ancestor. That is almost always the app’s own, '
      'which is why nothing needs wiring — but two situations are worth '
      'knowing:',
    ),
    DocList(<String>[
      '**No app widget at all** — a bare `WidgetsBinding.attachRootWidget`, or '
          'a widget test that pumps a subtree. Wrap it in an `Overlay`, or use '
          'the harness the package’s own tests use.',
      '**A nested `Overlay`** — an in-app window manager, a preview pane. '
          'Overlays portal into the nested one, and are clipped to it. That is '
          'usually what you want; when it is not, host the trigger above the '
          'nested overlay.',
    ]),
    DocApi(
      'AstryxOverlayStack',
      <DocProp>[
        DocProp(
          'push(onDismiss)',
          'void',
          'Registers a layer as the top-most one.',
        ),
        DocProp(
          'remove(onDismiss)',
          'void',
          'Removes a layer, wherever it sits — a layer can be closed '
              'programmatically while something above it is still open.',
        ),
        DocProp(
          'isTopmost(onDismiss)',
          'bool',
          'Whether that layer is the one Escape would close.',
        ),
        DocProp(
          'dismissTopmost()',
          'bool',
          'Dismisses the top-most layer, and reports whether there was one — '
              'so a key handler can let Escape reach what is behind it.',
        ),
      ],
      description:
          'A static registry, not a widget. Every Astryx overlay uses it; '
          'reach for it directly only when you are building a dismissible '
          'layer of your own.',
    ),
    DocCallout.accessibility(
      'A modal layer sets `scopesRoute` in its semantics, which is what '
      'tells a screen reader the page behind it is inert. Set it false for a '
      'layer that is merely floating — announcing a page as unavailable when '
      'it is not is worse than saying nothing.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxOverlay](overlay) — the scrim-and-layer widget, and its '
          'properties.',
      '[AstryxPopover](popover) — an anchored layer.',
      '[AstryxDialog](dialog) — a modal layer with a panel on it.',
    ]),
  ],
);

const DocPage _linkProvider = DocPage(
  id: 'link_provider',
  title: 'AstryxLinkScope',
  group: _group,
  description:
      'How links navigate — supplied once, so components need not know the '
      'router.',
  source: 'lib/src/foundation/link_delegate.dart',
  upstream: 'LinkProvider',
  upstreamPath: '/components/LinkProvider',
  blocks: <DocBlock>[
    DocProse(
      'Upstream’s `LinkProvider` lets a consumer swap in their router: '
      'components call `useLinkComponent()` rather than rendering an `<a>`. '
      'This is the same seam. A widget with an `href` hands it to the delegate '
      'and never decides what navigation means.',
    ),
    DocProse(
      '**Navigation is the application’s concern.** The design system’s job is '
      'to leave a hole the right shape — one this package cannot fill, because '
      'it does not know whether you route with `Navigator`, `go_router`, or a '
      'URL launcher.',
    ),
    DocHeading('Usage'),
    DocCode('''
AstryxApp(
  linkDelegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
    if (uri.hasScheme) {
      launchUrl(uri);            // package:url_launcher
    } else {
      GoRouter.of(context).go(uri.toString());
    }
  }),
  home: const HomePage(),
)'''),
    DocProse(
      'Install it once on `AstryxApp` or `AstryxThemeProvider`. Wrap a subtree '
      'in `AstryxLinkScope` directly to override it for part of the app — a '
      'preview pane where links should do nothing, or an embedded document '
      'whose links resolve against another base.',
    ),
    DocExample('provider_link', align: DocExampleAlign.start),
    DocHeading('The default'),
    DocProse(
      'With no delegate installed, `AstryxLinkDelegate.none` applies: it warns '
      'in debug and does nothing in release. Doing nothing is the honest '
      'answer — guessing, by launching a URL or pushing a route, would be a '
      'surprising side effect from a package that knows nothing about your '
      'navigation.',
    ),
    DocCallout.warning(
      '`href` goes through the delegate; `onPressed` does not. A link with an '
      '`onPressed` calls it directly, which is the right choice for something '
      'that is not really a destination — opening a panel, revealing a row. '
      'Give a link one or the other, not both.',
    ),
    DocApi(
      'AstryxLinkDelegate',
      <DocProp>[
        DocProp(
          'followLink(uri, {target})',
          'void',
          'Follows `uri`. `target` carries a hint about where to open, for the '
              'web; other platforms may ignore it.',
        ),
        DocProp(
          'AstryxLinkDelegate.fromCallback(onFollow)',
          'factory',
          'Builds one from a callback, which is what most apps want.',
        ),
        DocProp(
          'AstryxLinkDelegate.none',
          'static const',
          'The default: a debug warning, and nothing else.',
        ),
        DocProp(
          'of(context)',
          'AstryxLinkDelegate',
          'The delegate in scope, or `none` when there is none.',
        ),
      ],
      description:
          'Subclass it for anything with state — analytics, a confirmation '
          'before leaving a dirty form — or use the callback factory.',
    ),
    DocApi('AstryxLinkScope', <DocProp>[
      DocProp(
        'delegate',
        'AstryxLinkDelegate',
        'The delegate for this subtree.',
        required: true,
      ),
      DocProp('child', 'Widget', 'The subtree.', required: true),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLink](link) — the widget that calls the delegate.',
      '[AstryxBreadcrumbs](breadcrumbs) — a trail of them.',
    ]),
  ],
);

const DocPage _internationalizationProvider = DocPage(
  id: 'internationalization_provider',
  title: 'AstryxLocalizationsScope',
  group: _group,
  description: 'Locale, text direction and the strings, supplied to the tree.',
  source: 'lib/src/localizations/astryx_localizations.dart',
  upstream: 'InternationalizationProvider',
  upstreamPath: '/components/InternationalizationProvider',
  blocks: <DocBlock>[
    DocProse(
      'Upstream’s `InternationalizationProvider` carries three things: the '
      'strings, the text direction, and the locale. In Flutter those already '
      'live in three different places, and only the first is this package’s to '
      'supply.',
    ),
    DocTable(
      headers: <String>['Upstream', 'Here', 'Installed by'],
      rows: <List<String>>[
        <String>[
          'Translated strings',
          '`AstryxLocalizations` + `AstryxLocalizationsScope`',
          '`AstryxThemeProvider(localizations: …)`',
        ],
        <String>[
          '`dir="rtl"`',
          '`Directionality`',
          'Flutter’s own, from the locale or set by hand',
        ],
        <String>[
          'The locale',
          '`Locale`, `localizationsDelegates`',
          '`AstryxApp` / `MaterialApp`',
        ],
      ],
    ),
    DocHeading('Usage'),
    DocCode(r'''
class FrLocalizations extends AstryxLocalizations {
  const FrLocalizations();

  @override
  String get dialogClose => 'Fermer';

  @override
  String clearField(String label) => 'Effacer $label';
}

AstryxApp(
  localizations: const FrLocalizations(),
  home: const HomePage(),
)'''),
    DocProse(
      '**Subclass and override only what changes.** Every string has a '
      'default, so a partial translation is a working app with some English '
      'in it rather than a crash or a run of missing-key placeholders. '
      '`AstryxLocalizations.of(context)` never returns null for the same '
      'reason: a missing localisation should not be an exception in front of '
      'a user.',
    ),
    DocExample('provider_localizations', align: DocExampleAlign.stretch),
    DocCallout.note(
      'English only for 1.0, and that is deliberate: what matters now is the '
      'delegate *structure*, so adding a locale later is additive rather than '
      'breaking. The same seam is where a product rewords a string to its '
      'own voice — "Dismiss notification" is not wrong, but it may not be '
      'yours.',
    ),
    DocHeading('What is in there'),
    DocTable(
      headers: <String>['Group', 'Covers'],
      rows: <List<String>>[
        <String>[
          'Actions',
          'Closing a dialog, a popover, a banner, a toast. `bannerDismiss` and '
              '`toastDismiss` are deliberately separate — one is persistent '
              'and one transient, and they translate differently.',
        ],
        <String>[
          'Forms',
          'The required and optional markers, placeholders, the clear button, '
              'character counts, and the rejection messages a number, date or '
              'time field announces.',
        ],
        <String>[
          'Date and time',
          'The month and weekday names, `am`/`pm`, the calendar’s buttons, and '
              'the relative phrases a timestamp uses. There is no `intl` '
              'dependency, so these are the whole of it.',
        ],
        <String>[
          'Text selection',
          'Cut, copy, paste and friends — Astryx builds its own selection '
              'toolbar rather than Material’s, so it needs its own strings.',
        ],
        <String>[
          'Tables, lists, navigation',
          'Sort directions, row selection, overflow counts, pagination, and '
              '`linkExternal` — the phrase said after a link that leaves the '
              'app.',
        ],
      ],
    ),
    DocHeading('Text direction'),
    DocProse(
      'RTL is a `Directionality` and nothing else. The widget set is logical '
      'throughout — `start`/`end`, `EdgeInsetsDirectional`, mirrored icons — '
      'so nothing else has to be told. That is why this page has no '
      '`textDirection` property to document.',
    ),
    DocApi(
      'AstryxLocalizations',
      <DocProp>[
        DocProp(
          'of(context)',
          'AstryxLocalizations',
          'The strings in scope, falling back to the English defaults.',
        ),
      ],
      description:
          'An immutable class of getters and methods, not a map of keys — so a '
          'missing override is a compile-time impossibility rather than a '
          'runtime blank.',
    ),
    DocApi('AstryxLocalizationsScope', <DocProp>[
      DocProp(
        'localizations',
        'AstryxLocalizations',
        'The strings for this subtree.',
        required: true,
      ),
      DocProp('child', 'Widget', 'The subtree.', required: true),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[Right-to-left](rtl) — the rules that make a `Directionality` enough.',
      '[Accessibility](accessibility) — where these strings end up.',
    ]),
  ],
);

const DocPage _syntaxTheme = DocPage(
  id: 'syntax_theme',
  title: 'AstryxSyntaxTheme',
  group: _group,
  description: 'The token colours a code block highlights with.',
  source: 'lib/src/theme/engine/syntax_theme.dart',
  upstream: 'SyntaxTheme',
  upstreamPath: '/components/SyntaxTheme',
  blocks: <DocBlock>[
    DocProse(
      'A theme may carry a syntax palette: fourteen colours for the parts of a '
      'code sample. `defineTheme` writes them into the token map under '
      '`--color-syntax-`, and all seven prebuilt themes ship one.',
    ),
    DocCallout.warning(
      '**Nothing in this package paints with them.** `AstryxCodeBlock` does '
      'not highlight, by decision rather than omission: shipping a tokeniser '
      'for every language somebody might paste is not a design system’s job, '
      'and a bad one is worse than none. The palette is here so that a '
      'highlighter '
      '*you* wire takes its colours from the theme instead of from fourteen '
      'hex values sitting beside it.',
    ),
    DocHeading('Reading the palette'),
    DocCode('''
final theme = AstryxTheme.of(context);

theme.syntaxColor(AstryxSyntaxToken.keyword);  // Color?, or null
theme.hasSyntaxPalette;                        // bool
theme.syntaxPalette;                           // the whole map'''),
    DocProse(
      '`syntaxColor` is **nullable**, unlike every other accessor on '
      '`AstryxThemeData`. A palette sits outside the 184 core tokens, so a '
      'theme either carries one or does not — and throwing would punish the '
      'caller for the theme’s silence. An app on the bare defaults, with no '
      'theme passed at all, has no palette.',
    ),
    DocExample('provider_syntax', align: DocExampleAlign.stretch),
    DocHeading('Defining one'),
    DocCode('''
final myTheme = defineTheme(
  AstryxThemeInput(
    name: 'acme',
    syntax: AstryxSyntaxTheme(
      name: 'acme-code',
      tokens: <String, String>{
        'keyword': 'light-dark(#700084, #efa8ff)',
        'string': 'light-dark(#005600, #a6d2a2)',
        // …twelve more
      },
    ),
  ),
)'''),
    DocProse(
      'Values are CSS, resolved by the same engine as every other token — so '
      '`light-dark()` gives both modes in one line, and a `var()` reference to '
      'another token is followed. `AstryxSyntaxTheme.define` takes '
      '`AstryxTokenValue`s instead, for a palette built in Dart rather than '
      'transcribed.',
    ),
    DocTable(
      headers: <String>['The fourteen roles', ''],
      rows: <List<String>>[
        <String>['`keyword`', '`if`, `return`, `class`.'],
        <String>['`string`', 'A string literal.'],
        <String>['`comment`', 'A comment.'],
        <String>['`number`', 'A numeric literal.'],
        <String>['`function`', 'A function or method name.'],
        <String>['`type`', 'A type name.'],
        <String>['`variable`', 'A variable or parameter name.'],
        <String>['`operator`', 'An operator — `+`, `=>`, `??`.'],
        <String>['`constant`', 'A constant, including `null` and friends.'],
        <String>['`tag`', 'A markup tag name.'],
        <String>['`attribute`', 'A markup attribute name.'],
        <String>['`property`', 'An object property or field name.'],
        <String>['`punctuation`', 'Brackets, commas, semicolons.'],
        <String>['`background`', 'The fill behind highlighted code.'],
      ],
    ),
    DocCallout.accessibility(
      'A palette is decoration over text that is already readable: contrast '
      'still has to hold against `background`, and colour must never be the '
      'only thing distinguishing one part of a sample from another. A reader '
      'who cannot separate the greens from the greys should still be reading '
      'code, not guessing at it.',
    ),
    DocApi('AstryxSyntaxTheme', <DocProp>[
      DocProp('name', 'String', 'The palette’s name.', required: true),
      DocProp(
        'tokens',
        'Map<String, String>',
        'Resolved values keyed by short name — `keyword`, `string` — with no '
            '`--color-syntax-` prefix.',
        required: true,
      ),
      DocProp(
        'AstryxSyntaxTheme.define({name, tokens})',
        'factory',
        'Builds one from `AstryxTokenValue`s, flattening light/dark pairs to '
            '`light-dark()` strings. Upstream’s `defineSyntaxTheme`.',
      ),
    ]),
    DocApi(
      'AstryxSyntaxToken',
      <DocProp>[
        DocProp('key', 'String', 'The short name — `keyword`, `string`.'),
        DocProp(
          'cssName',
          'String',
          'The full token name — `--color-syntax-keyword`.',
        ),
      ],
      description:
          'The typed counterpart of the string keys, and what '
          '`AstryxThemeData.syntaxColor` takes.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCodeBlock](code_block) — the block this would colour.',
      '[Theming](theming) — where a palette is defined.',
      '[Design tokens](tokens) — the token map it is written into.',
    ]),
  ],
);
