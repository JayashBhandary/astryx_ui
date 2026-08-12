import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Where upstream ships a React hook.
///
/// **A hook is not a Flutter idiom**, so each of these resolves to something
/// else: an `InheritedWidget` lookup, a framework API that already exists, or a
/// widget this package had to write. Saying which — on a page carrying the
/// upstream name — is the whole job, because a reader arriving from
/// `useScrollLock` is searching for a word that does not appear in the API.
final List<DocPage> hookPages = <DocPage>[
  _useTheme,
  _useMediaQuery,
  _useHotkeys,
  _useFocusTrap,
  _useScrollLock,
  _useScrollOverflow,
  _useOverflow,
  _useListFocus,
  _useGridFocus,
  _useTreeFocus,
  _useLayer,
  _useClickableContainer,
  _useInputContainer,
  _useKeyboardHint,
  _useEntryAnimation,
  _useContainerReveal,
  _useImageMode,
  _useStreamingText,
  _useTranslator,
];

const String _group = DocGroup.hooks;

const DocPage _useTheme = DocPage(
  id: 'use_theme',
  title: 'useTheme → AstryxTheme.of',
  group: _group,
  description: 'Reading the theme in scope, and why there is no hook.',
  source: 'lib/src/theme/astryx_theme.dart',
  upstream: 'useTheme',
  upstreamPath: '/components/useTheme',
  blocks: <DocBlock>[
    DocProse(
      'Upstream needs a hook because CSS custom properties are invisible to '
      'JavaScript: a component that wants the resolved value of '
      '`--color-accent` has to ask a context for it. Flutter has one mechanism '
      'for exactly this, and it is older than hooks.',
    ),
    DocCode('''
final theme = AstryxTheme.of(context);

theme.color(AstryxColorToken.accent);         // Color
theme.spacing(AstryxSpacingToken.spacing3);   // 8.0
theme.textStyle(AstryxTypeRole.body);         // TextStyle
theme.duration(AstryxDurationToken.fast);     // Duration'''),
    DocProse(
      '`of(context)` **subscribes** as well as reads: a widget that calls it '
      'rebuilds when the theme above it changes, and nothing has to be wired '
      'up to make that happen. That is the half a hook is usually praised for, '
      'and here it is the framework’s.',
    ),
    DocExample('hook_theme', align: DocExampleAlign.stretch),
    DocHeading('The rest of the family'),
    DocTable(
      headers: <String>['Upstream hook', 'Here'],
      rows: <List<String>>[
        <String>['`useTheme`', '`AstryxTheme.of(context)`'],
        <String>[
          '`useTheme().mode`',
          '`AstryxTheme.of(context).mode`, and `.brightness` for the Flutter '
              'enum',
        ],
        <String>[
          '— (a media query upstream)',
          '`AstryxTheme.densityOf(context)`, which is the pointer/touch answer',
        ],
        <String>['`useIcons`', '`AstryxTheme.iconsOf(context)`'],
        <String>['`useTranslator`', '`AstryxLocalizations.of(context)`'],
        <String>['`useLinkComponent`', '`AstryxLinkDelegate.of(context)`'],
      ],
    ),
    DocCallout.warning(
      'Reach for this only when building something the design system has no '
      'widget for — a custom painter, a chart, a one-off surface. A raw token '
      'read inside a screen is usually a sign that a component exists and was '
      'not used.',
    ),
    DocCallout.note(
      '`AstryxTheme.of` throws when there is no provider above it, with a '
      'fix-it naming both entry points. `maybeOf` is the nullable form, for a '
      'widget that must survive outside a theme.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxThemeProvider](theme) — what installs the scope.',
      '[Design tokens](tokens) — everything reachable through it.',
      '[Styling](styling) — extending a component without leaving the tokens.',
    ]),
  ],
);

const DocPage _useMediaQuery = DocPage(
  id: 'use_media_query',
  title: 'useMediaQuery → MediaQuery',
  group: _group,
  description: 'Responding to viewport size, pointer, and motion preference.',
  upstream: 'useMediaQuery',
  upstreamPath: '/components/useMediaQuery',
  blocks: <DocBlock>[
    DocProse(
      'Upstream’s hook wraps `window.matchMedia`. Flutter’s `MediaQuery` '
      'covers the same ground, and the package has already resolved the three '
      'media features it depends on — so most of the time the answer is not a '
      'media query at all.',
    ),
    DocTable(
      headers: <String>['CSS', 'Here'],
      rows: <List<String>>[
        <String>[
          '`@media (min-width: …)`',
          '`LayoutBuilder`, or `MediaQuery.sizeOf(context)`',
        ],
        <String>[
          '`@media (hover: hover)`',
          '`AstryxTheme.densityOf(context).supportsHover`',
        ],
        <String>[
          '`@media (pointer: coarse)`',
          '`AstryxTheme.densityOf(context)`, and `.minimumTapTarget`',
        ],
        <String>[
          '`@media (prefers-reduced-motion)`',
          '`AstryxMotionAccess.animate(context)`',
        ],
        <String>[
          '`@media (prefers-color-scheme)`',
          '`AstryxColorMode.system`, resolved by the provider',
        ],
      ],
    ),
    DocHeading('Width: ask the box, not the window'),
    DocProse(
      '**`LayoutBuilder` before `MediaQuery`.** "How wide is the window" is '
      'rarely the question a component has; "how much room do *I* have" is — '
      'and the two differ the moment the component sits inside a panel, a '
      'split view, or a dialog. A layout that reads the window is a layout '
      'that breaks the first time it is reused somewhere narrower.',
    ),
    DocExample('hook_media_query', align: DocExampleAlign.stretch),
    DocHeading('There is no breakpoint table'),
    DocProse(
      'On purpose. The width at which *your* navigation stops fitting is a '
      'fact about your navigation, and a global table means every screen has '
      'to agree about a number none of them chose. So the thresholds that '
      'exist are properties: `AstryxAppShell.compactBelow`, '
      '`AstryxGrid.minWidth`, `AstryxOverflowList`’s own measurement.',
    ),
    DocCode('''
AstryxAppShell(
  compactBelow: 900,   // your number, on your screen
  sidebar: const NavRail(),
  child: page,
)

AstryxGrid(
  minWidth: 240,       // as many columns as fit, no query at all
  children: tiles,
)'''),
    DocCallout.note(
      'Reduced motion is the one media feature you should almost never read '
      'yourself: every Astryx animation already honours it through '
      '`AstryxMotion`. Read `AstryxMotionAccess.animate` only for an animation '
      'you wrote by hand.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Layout](layout_guide) — the page structure these questions are about.',
      '[Density](density) — the pointer and hover answers, resolved once.',
      '[Motion](motion) — what must not move when motion is reduced.',
      '[AstryxAppShell](app_shell) — where a width threshold actually lives.',
    ]),
  ],
);

const DocPage _useHotkeys = DocPage(
  id: 'use_hotkeys',
  title: 'AstryxHotkeys',
  group: _group,
  description: 'Binding keyboard shortcuts to actions.',
  source: 'lib/src/foundation/hotkeys.dart',
  upstream: 'useHotkeys',
  upstreamPath: '/components/useHotkeys',
  blocks: <DocBlock>[
    DocExample('hook_hotkeys', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
const save = AstryxHotkey.mod(LogicalKeyboardKey.keyS);

AstryxHotkeys(
  bindings: <AstryxHotkey, VoidCallback>{save: _save},
  child: const EditorPage(),
)'''),
    DocProse(
      "Upstream takes strings — `'mod+s'`. This takes a "
      '[LogicalKeyboardKey] instead: a typo in a string is a shortcut that '
      'silently never fires, and there is no reason to accept one when the '
      'analyser could have caught it.',
    ),
    DocHeading('`mod` is the point'),
    DocProse(
      'A shortcut written with `AstryxHotkey.mod` is **Command on a Mac and '
      'Control everywhere else** — which is what a user of both expects, and '
      'what makes one definition correct on both. It also means the hotkey can '
      'say which modifier it resolved to, so the hint beside a menu row draws '
      'itself:',
    ),
    DocCode('''
const palette = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

AstryxItem(
  label: 'Command palette',
  trailing: const AstryxKbd.hotkey(palette),   // ⌘K, or Ctrl+K
)'''),
    DocProse(
      'One object, bound and drawn. `AstryxKbd` otherwise refuses to translate '
      '`Ctrl` to `⌘`, because only the caller knows whether a cap it was '
      'handed is a platform convention or a product’s own — but a hotkey '
      'knows, so there is nothing left to guess.',
    ),
    DocHeading('Where the keys arrive'),
    DocCallout.warning(
      '**Key events walk *up* from whatever holds focus.** Until something '
      'inside the subtree is focused there is nothing for them to walk '
      'through, so an application-wide scope needs `autofocus: true` — '
      'otherwise `⌘K` does nothing on a freshly loaded page and gets reported '
      'as broken. The node is still skipped by Tab, so this costs no tab stop.',
    ),
    DocProse(
      'The flip side: a scope wrapped around a control should **not** '
      'autofocus, and a binding with no modifier inside a form will steal the '
      'key from every field in it. `/` to focus a search box is a fine '
      'shortcut on a page of tables and a hostile one on a page of text '
      'inputs.',
    ),
    DocProse(
      '`enabled: false` unbinds everything without touching the subtree — how '
      'a screen suspends its shortcuts while a modal is open.',
    ),
    DocApi('AstryxHotkeys', <DocProp>[
      DocProp(
        'bindings',
        'Map<AstryxHotkey, VoidCallback>',
        'What each hotkey does.',
        required: true,
      ),
      DocProp(
        'child',
        'Widget',
        'The subtree the bindings apply to.',
        required: true,
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the bindings are live.',
        defaultValue: 'true',
      ),
      DocProp(
        'autofocus',
        'bool',
        'Whether the scope takes focus when built. Set it on an '
            'application-wide scope; leave it off around a control.',
        defaultValue: 'false',
      ),
      DocProp(
        'platform',
        'TargetPlatform?',
        'Overrides the platform `mod` resolves against. For tests, and for '
            'previewing another platform’s shortcuts.',
      ),
    ]),
    DocApi(
      'AstryxHotkey',
      <DocProp>[
        DocProp(
          'AstryxHotkey(key, {control, shift, alt, meta})',
          'constructor',
          'A shortcut with fixed modifiers.',
        ),
        DocProp(
          'AstryxHotkey.mod(key, {shift, alt})',
          'constructor',
          'A shortcut on the platform’s own command modifier.',
        ),
        DocProp(
          'activatorFor(platform)',
          'ShortcutActivator',
          'The binding, resolved — so a hotkey can be handed to Flutter’s own '
              '`Shortcuts` too.',
        ),
        DocProp(
          'capsFor(platform)',
          'List<String>',
          'The caps to draw: `⌘ K` on Apple platforms, `Ctrl K` elsewhere.',
        ),
        DocProp(
          'describeFor(platform)',
          'String',
          'The spoken form — "Command K". A row of symbols read aloud is not a '
              'shortcut anybody can follow.',
        ),
      ],
      description:
          'An immutable value, `const`-constructible, and equal by key and '
          'modifiers — so it can be a map key, and a shortcut table can be a '
          'compile-time constant.',
    ),
    DocCallout.accessibility(
      'A shortcut is an accelerator, never the only way to do something (WCAG '
      '2.1.1). Every hotkey in a screen needs a control that does the same '
      'job, and the shortcut belongs *on* that control as a hint — which is '
      'what `AstryxKbd.hotkey` is for.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxKbd](kbd) — drawing the keys, including from a hotkey.',
      '[AstryxDropdownMenu](dropdown_menu) — where a shortcut hint usually '
          'sits.',
      '[Accessibility](accessibility) — the rule above, in context.',
    ]),
  ],
);

const DocPage _useFocusTrap = DocPage(
  id: 'use_focus_trap',
  title: 'AstryxFocusTrap',
  group: _group,
  description: 'Holding focus inside an open overlay, and giving it back.',
  source: 'lib/src/foundation/focus_trap.dart',
  upstream: 'useFocusTrap',
  upstreamPath: '/components/useFocusTrap',
  blocks: <DocBlock>[
    DocProse(
      'Two behaviours, both required by the WAI-ARIA dialog pattern and both '
      'easy to get subtly wrong. **Every Astryx overlay already uses this** — '
      'reach for it directly only for a layer you are building yourself.',
    ),
    DocList(<String>[
      '**Trap.** Tab from the last focusable child returns to the first, and '
          'Shift+Tab from the first goes to the last. Focus never reaches the '
          'page behind the overlay, which is still visible and still tabbable '
          'as far as the framework is concerned.',
      '**Restore.** On dismount focus returns to whatever held it before — '
          'normally the trigger. A user who opens a dialog with the keyboard '
          'and closes it must not be dumped back at the top of the document.',
    ]),
    DocProse(
      'The restore half matters more than it looks. `FocusScope` already '
      'restores focus *within* a scope, but the node that opened the overlay '
      'is outside it, so the framework has nothing to go back to. This widget '
      'records the node itself.',
    ),
    DocExample('hook_focus_trap', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxFocusTrap(
  enabled: isOpen,
  child: const MyLayerBody(),
)'''),
    DocProse(
      '`enabled: false` lets focus move freely, for a panel that is '
      'deliberately non-modal — a formatting toolbar over an editor, where '
      'trapping would be hostile rather than helpful.',
    ),
    DocApi('AstryxFocusTrap', <DocProp>[
      DocProp(
        'child',
        'Widget',
        'The subtree focus is kept inside.',
        required: true,
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the trap is active.',
        defaultValue: 'true',
      ),
      DocProp(
        'autofocus',
        'bool',
        'Whether to move focus into the subtree when the trap activates.',
        defaultValue: 'true',
      ),
      DocProp(
        'restoreFocus',
        'bool',
        'Whether to return focus to the previously-focused node on dismount.',
        defaultValue: 'true',
      ),
      DocProp('debugLabel', 'String?', 'A label for the debug focus tree.'),
    ]),
    DocCallout.accessibility(
      'A trap without a way out is a cage. Whatever you put inside one needs '
      'Escape, or a close control, or both — which is why the overlays own the '
      'trap rather than leaving it to a caller who might forget.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[The overlay layer](layer_provider) — the dismiss stack the trap sits '
          'beside.',
      '[AstryxOverlay](overlay) — trap, scrim and Escape as one widget.',
      '[AstryxScrollLock](use_scroll_lock) — the other half of taking over a '
          'page.',
    ]),
  ],
);

const DocPage _useScrollLock = DocPage(
  id: 'use_scroll_lock',
  title: 'AstryxScrollLock',
  group: _group,
  description: 'Freezing the page behind a modal.',
  source: 'lib/src/foundation/scroll_lock.dart',
  upstream: 'useScrollLock',
  upstreamPath: '/components/useScrollLock',
  blocks: <DocBlock>[
    DocExample('hook_scroll_lock', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxScrollLock.whileModalIsOpen(
  child: AstryxAppShell(child: page),
)'''),
    DocProse(
      'One of those, once, near the root is the whole setup. **It is not wired '
      'in by default**, because the lock belongs to the scrollable a product '
      'wants frozen and this package cannot know which that is.',
    ),
    DocHeading('Why it is needed'),
    DocProse(
      'An overlay’s scrim blocks *presses* on the page behind it, and a wheel '
      'or a trackpad is not a press. Without a lock the content behind an open '
      'dialog still scrolls under the pointer, which reads as the modal having '
      'failed to take over.',
    ),
    DocProse(
      'Upstream sets `overflow: hidden` on the document. There is no document '
      'here and no global scroll to freeze, so the lock is a **scope**: it '
      'wraps the page and the page stops scrolling, while the modal above it — '
      'in its own overlay, outside that subtree — scrolls normally.',
    ),
    DocHeading('What counts as a modal'),
    DocProse(
      '`whileModalIsOpen` reads `AstryxOverlayStack.modalLayers`, the same '
      'registry Escape consults. A layer counts as modal when it **dims the '
      'page** — a dialog, an alert dialog, the shell’s navigation drawer. A '
      'popover, a dropdown menu, a context menu and a tooltip do not: those '
      'are not claims that the page is inert, and freezing a page because a '
      'tooltip appeared would be a bug with a very confusing report.',
    ),
    DocCallout.warning(
      '**A locked subtree takes no pointer events at all**, not merely no '
      'scrolls. Blocking the pointer is the only thing that reliably stops a '
      'wheel: a page-level `ListView` with no controller is `primary: true`, '
      'and `ScrollView` wraps the ambient physics in '
      '`AlwaysScrollableScrollPhysics` for that case — which overrules '
      'anything handed down through `ScrollConfiguration`. Behind a modal that '
      'costs nothing, because the scrim was already swallowing presses. Do not '
      'lock something that has to stay clickable.',
    ),
    DocProse(
      'The physics override is applied as well as the pointer block, for the '
      'scrollables that do honour it and for the keyboard — `Space` and the '
      'arrow keys scroll a focused scroller with no pointer involved at all.',
    ),
    DocApi('AstryxScrollLock', <DocProp>[
      DocProp(
        'locked',
        'bool',
        'Whether the subtree is frozen. The manual form.',
        required: true,
      ),
      DocProp('child', 'Widget', 'The subtree to freeze.', required: true),
      DocProp(
        'AstryxScrollLock.whileModalIsOpen({child})',
        'constructor',
        'Freezes whenever a modal layer is open, with nothing to wire up.',
      ),
    ]),
    DocApi(
      'AstryxOverlayStack',
      <DocProp>[
        DocProp(
          'openLayers',
          'ValueListenable<int>',
          'How many dismissible layers are open.',
        ),
        DocProp(
          'modalLayers',
          'ValueListenable<int>',
          'How many of those dim the page — what the automatic lock '
              'listens to.',
        ),
      ],
      description:
          'The two counters this reads. Listen to them directly for anything '
          'else that should know a modal is up — pausing a poll, or a video.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[The overlay layer](layer_provider) — the stack these counters come '
          'from.',
      '[AstryxFocusTrap](use_focus_trap) — the other half of taking over a '
          'page.',
      '[AstryxDialog](dialog) — the layer this is usually locking behind.',
    ]),
  ],
);

const DocPage _useScrollOverflow = DocPage(
  id: 'use_scroll_overflow',
  title: 'AstryxScrollOverflow',
  group: _group,
  description:
      'Knowing whether a scroller has content beyond either edge, for fading '
      'its edges.',
  source: 'lib/src/foundation/scroll_overflow.dart',
  upstream: 'useScrollOverflow',
  upstreamPath: '/components/useScrollOverflow',
  blocks: <DocBlock>[
    DocExample('hook_scroll_overflow', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxScrollOverflow(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: chips),
  ),
)'''),
    DocProse(
      'A clipped edge with nothing at it looks like the end of the content, '
      'and a user who cannot tell the difference stops scrolling. So a '
      'scroller wider than its box has to **say** there is more.',
    ),
    DocProse(
      'It listens to scroll notifications rather than owning a controller, so '
      'it works over any scrollable — one you built, one a component built, '
      'one nested three widgets down — without being handed anything.',
    ),
    DocHeading('What it reports'),
    DocTable(
      headers: <String>['`AstryxScrollEdges`', 'Means'],
      rows: <List<String>>[
        <String>[
          '`overflows`',
          'The content is longer than the viewport at all. False makes the '
              'other two meaningless — a scroller with nothing to scroll is at '
              'both ends at once.',
        ],
        <String>['`atStart` / `atEnd`', 'Resting against that edge.'],
        <String>[
          '`hasMoreAtStart` / `hasMoreAtEnd`',
          'The pair a fade or an arrow keys off: overflowing **and** not at '
              'that edge.',
        ],
      ],
    ),
    DocProse(
      'Start and end are logical, so under a right-to-left `Directionality` '
      'the start edge of a horizontal strip is the right one — and the '
      'gradient runs the right way without this widget being told which way '
      'that is.',
    ),
    DocHeading('Your own affordance'),
    DocProse(
      'Fades are the default because they cost nothing and read as depth. Pass '
      '`builder` for something a fade cannot say — a pair of arrow buttons, a '
      '"+3 more" count, a shadow:',
    ),
    DocCode('''
AstryxScrollOverflow(
  fade: false,
  builder: (context, edges, child) => AstryxHStack(
    children: <Widget>[
      AstryxIconButton(
        icon: AstryxIconName.chevronLeft,
        label: 'Scroll back',
        enabled: edges.hasMoreAtStart,
        onPressed: _back,
      ),
      Expanded(child: child),
      AstryxIconButton(
        icon: AstryxIconName.chevronRight,
        label: 'Scroll on',
        enabled: edges.hasMoreAtEnd,
        onPressed: _on,
      ),
    ],
  ),
  child: strip,
)'''),
    DocCallout.accessibility(
      'A fade is decoration: it is not announced, and it is not reachable '
      'without sight or a pointer. It must never be the *only* way to reach '
      'what is past the edge — the content behind it stays in the semantics '
      'tree and stays reachable by keyboard, which is what makes the fade an '
      'extra rather than a gate. The fades never hit-test, so a control under '
      'one is still pressable.',
    ),
    DocCallout.note(
      '`AstryxTabList` does this for its own strip. Its copy predates this '
      'primitive and behaves identically; the two are worth merging, and until '
      'they are, this is the one to reach for in your own code.',
    ),
    DocApi('AstryxScrollOverflow', <DocProp>[
      DocProp(
        'child',
        'Widget',
        'The scrollable, or anything containing one.',
        required: true,
      ),
      DocProp(
        'axis',
        'Axis',
        'Which axis to watch. A notification from the other axis is ignored, '
            'so a horizontal strip inside a scrolling page reports only its '
            'own edges.',
        defaultValue: 'Axis.horizontal',
      ),
      DocProp(
        'fade',
        'bool',
        'Whether to draw a gradient at an edge with more past it.',
        defaultValue: 'true',
      ),
      DocProp(
        'fadeExtent',
        'double',
        'How wide a fade is.',
        defaultValue: '24',
      ),
      DocProp(
        'fadeColor',
        'AstryxColorToken?',
        'What a fade resolves to. It has to match what is *behind* the '
            'scroller, so a strip on a card wants `backgroundCard`.',
      ),
      DocProp(
        'builder',
        'Widget Function(context, edges, child)?',
        'Wraps the child once the edges are known.',
      ),
      DocProp(
        'onChanged',
        'ValueChanged<AstryxScrollEdges>?',
        'Called whenever the edges change.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTabList](tab_list) — a strip that scrolls and fades.',
      '[useOverflow](use_overflow) — when the tail should move into a menu '
          'instead of scrolling.',
    ]),
  ],
);

const DocPage _useOverflow = DocPage(
  id: 'use_overflow',
  title: 'useOverflow → AstryxOverflowList',
  group: _group,
  description:
      'Measuring which children do not fit, so a component can collapse its '
      'tail.',
  source: 'lib/src/components/data/overflow_list.dart',
  upstream: 'useOverflow',
  upstreamPath: '/components/useOverflow',
  blocks: <DocBlock>[
    DocProse(
      'Upstream measures children against their container and hides the ones '
      'that do not fit. Here that measurement is not a hook a caller wires up: '
      'it is inside [AstryxOverflowList](overflow_list), which is the widget '
      'to reach for.',
    ),
    DocExample('overflow_list_demo', align: DocExampleAlign.stretch),
    DocHeading('The rule that matters'),
    DocProse(
      '**Nothing is hidden that a user cannot get to.** The overflow trigger '
      'is a real menu with a real row per hidden item, so what falls off the '
      'end stays reachable by pointer, keyboard and screen reader alike. That '
      'is the difference between collapsing a row and clipping it.',
    ),
    DocProse(
      'It is also why an item is declared twice — a widget for the row, a '
      'label for the menu. A widget cannot be turned into an operable menu row '
      'automatically, and a picture of one is worse than nothing.',
    ),
    DocHeading('Scroll, collapse, or wrap'),
    DocTable(
      headers: <String>['When the row will not fit', 'Reach for'],
      rows: <List<String>>[
        <String>[
          'The items are equals and order matters — tags, filters',
          '`AstryxOverflowList`, so the tail is still reachable',
        ],
        <String>[
          'The items are destinations and the strip is navigation',
          '`AstryxTabList`, which scrolls and fades — see '
              '[useScrollOverflow](use_scroll_overflow)',
        ],
        <String>[
          'The tail is *actions* rather than content',
          '`AstryxMoreMenu`, which is the "…" trigger and its menu as one '
              'widget',
        ],
        <String>[
          'A second line is fine',
          '`AstryxHStack(wrap: true)` — no measurement needed at all',
        ],
      ],
    ),
    DocCallout.warning(
      'Measuring costs a layout pass and a rebuild. A row of six chips is a '
      'fine use; a table of two hundred cells is not, and the answer there is '
      'a column strategy rather than measurement.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxOverflowList](overflow_list) — the widget, and its properties.',
      '[AstryxMoreMenu](more_menu) — the overflow trigger on its own.',
      '[AstryxBreadcrumbs](breadcrumbs) — a trail that collapses in the '
          'middle rather than at the end.',
    ]),
  ],
);

const DocPage _useListFocus = DocPage(
  id: 'use_list_focus',
  title: 'AstryxRovingFocus.list',
  group: _group,
  description: 'Arrow-key traversal across a list as one tab stop.',
  source: 'lib/src/foundation/roving_focus.dart',
  upstream: 'useListFocus',
  upstreamPath: '/components/useListFocus',
  blocks: <DocBlock>[
    DocExample('hook_list_focus', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxRovingFocus.list(
  length: chips.length,
  label: 'Filters',
  onActivate: (index) => _toggle(chips[index]),
  itemBuilder: (context, item) => AstryxFocusRing(
    focused: item.showsFocusRing,
    child: _Chip(chips[item.index]),
  ),
)'''),
    DocProse(
      '**One tab stop.** Tab moves onto the group and off it again; the arrows '
      'move within it. A strip of twelve chips is twelve presses to walk past '
      'otherwise, which is the whole reason the ARIA composite pattern exists.',
    ),
    DocProse(
      'Every composite in this package already behaves this way — '
      '`AstryxRadioList`, `AstryxTabList`, `AstryxToolbar`, '
      '`AstryxSegmentedControl`, `AstryxCalendar`. Reach for this to build one '
      'the package does not have.',
    ),
    DocHeading('Roving focus is not selection'),
    DocProse(
      'This moves an *active index*; what that means is yours. Two shapes, '
      'both correct in the right place:',
    ),
    DocList(<String>[
      '**Activate on `Enter` and `Space`** — `onActivate`. What a menu, a grid '
          'or a toolbar wants: a user can look before committing.',
      '**Select as the focus moves** — `onActiveChanged`. What a radio group '
          'does, because there the focus *is* the choice.',
    ]),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves onto the group, and off it.'],
        <String>[
          '`←` / `→`',
          'Moves along a horizontal list. **Mirrored under RTL.**',
        ],
        <String>[
          '`↑` / `↓`',
          'Moves along a vertical one. Both axes work in either orientation, '
              'which is what a user who does not know which way the group runs '
              'will try.',
        ],
        <String>['`Home` / `End`', 'The first and last available item.'],
        <String>['`Enter` / `Space`', 'Calls `onActivate` with the index.'],
      ],
    ),
    DocProse(
      '`wrap` is on for a list: the arrows cycle rather than stopping, so a '
      'user never has to reverse. `isEnabled` marks the items movement should '
      'skip — a disabled chip is passed over rather than landed on.',
    ),
    DocCallout.warning(
      '**Nothing `itemBuilder` returns may be focusable.** A focusable item '
      'would be its own tab stop, and the group would stop being one — the '
      'exact thing this widget exists to prevent. Build plain visuals, and use '
      '`item.showsFocusRing` to draw the ring.',
    ),
    DocApi('AstryxRovingFocus', <DocProp>[
      DocProp('length', 'int', 'How many items there are.', required: true),
      DocProp(
        'itemBuilder',
        'Widget Function(context, AstryxRovingFocusItem)',
        'Builds one item, told whether the focus is on it.',
        required: true,
      ),
      DocProp(
        'columns',
        'int',
        'Required by `AstryxRovingFocus.grid`; absent for a list.',
      ),
      DocProp(
        'orientation',
        'Axis',
        'Which way a list runs.',
        defaultValue: 'Axis.horizontal',
      ),
      DocProp(
        'wrap',
        'bool',
        'Whether movement cycles at the ends. True for a list, false for a '
            'grid.',
        defaultValue: 'true',
      ),
      DocProp(
        'onActivate',
        'ValueChanged<int>?',
        'Called with the index `Enter` or `Space` was pressed on.',
      ),
      DocProp(
        'isEnabled',
        'bool Function(int)?',
        'Whether an index can hold the focus. Movement skips the rest.',
      ),
      DocProp(
        'activeIndex',
        'int?',
        'The active index, for a caller that owns it. Null keeps it internal.',
      ),
      DocProp(
        'onActiveChanged',
        'ValueChanged<int>?',
        'Called with the index the focus moved to.',
      ),
      DocProp(
        'gap',
        'AstryxSpacingToken',
        'The gap in the default layout.',
        defaultValue: 'AstryxSpacingToken.spacing1',
      ),
      DocProp(
        'layoutBuilder',
        'Widget Function(context, List<Widget>)?',
        'Lays the items out. Null uses a row, a column or a grid.',
      ),
      DocProp('label', 'String?', 'An accessible name for the group.'),
    ]),
    DocApi(
      'AstryxRovingFocusItem',
      <DocProp>[
        DocProp('index', 'int', 'Which item this is.'),
        DocProp(
          'isActive',
          'bool',
          'Whether the roving focus sits here — true for exactly one item, '
              'whether or not the group is focused.',
        ),
        DocProp('groupHasFocus', 'bool', 'Whether the group holds focus.'),
        DocProp(
          'showsFocusRing',
          'bool',
          'Both conditions in one place: active **and** the group focused. '
              'Hand it to `AstryxFocusRing.focused`.',
        ),
      ],
      description: 'What each item is told about itself.',
    ),
    DocCallout.accessibility(
      'The group carries the accessible name and `explicitChildNodes`, so each '
      'item keeps a node of its own — a reader hears "Open, checked" rather '
      'than one field of indeterminate content. Give every item a `Semantics` '
      'with its label and state; the group cannot infer either.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[useGridFocus](use_grid_focus) — the same widget in two dimensions.',
      '[useTreeFocus](use_tree_focus) — why a tree is not this.',
      '[AstryxToolbar](toolbar) — a band of controls that is one tab stop.',
      '[Accessibility](accessibility) — the composite rule, in context.',
    ]),
  ],
);

const DocPage _useGridFocus = DocPage(
  id: 'use_grid_focus',
  title: 'AstryxRovingFocus.grid',
  group: _group,
  description: 'Two-dimensional arrow-key traversal across a grid.',
  source: 'lib/src/foundation/roving_focus.dart',
  upstream: 'useGridFocus',
  upstreamPath: '/components/useGridFocus',
  blocks: <DocBlock>[
    DocExample('hook_grid_focus', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxRovingFocus.grid(
  length: swatches.length,
  columns: 3,
  label: 'Team colour',
  onActivate: (index) => _pick(swatches[index]),
  itemBuilder: (context, item) => AstryxFocusRing(
    focused: item.showsFocusRing,
    child: _Swatch(swatches[item.index]),
  ),
)'''),
    DocProse(
      'The same widget as [useListFocus](use_list_focus) with a `columns` '
      'count, because a grid differs from a list in three details and nothing '
      'else:',
    ),
    DocTable(
      headers: <String>['Key', 'In a grid'],
      rows: <List<String>>[
        <String>[
          '`←` / `→`',
          'Moves **within the row**. Mirrored under RTL.',
        ],
        <String>['`↑` / `↓`', 'Moves between rows, by `columns` at a time.'],
        <String>[
          '`Home` / `End`',
          'The ends of **that row**, not of the whole grid.',
        ],
      ],
    ),
    DocProse(
      '`wrap` is off by default here, and that is the important one: stepping '
      'right off the end of a row into the next one is right for a menu of '
      'options and wrong for a calendar, where it silently changes the week.',
    ),
    DocProse(
      'The default layout is rows of `columns` items. Pass `layoutBuilder` '
      'where the geometry is not that — a table, a masonry wall, a month grid '
      'with a weekday header above it.',
    ),
    DocCallout.note(
      '`AstryxCalendar` is this pattern with the month arithmetic added: '
      '`Page Up` and `Page Down` for months, `Shift` with them for years. A '
      'grid whose axes mean something — a date, a seat, a cell reference — '
      'usually wants keys of its own beyond the four arrows.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[useListFocus](use_list_focus) — the shared API and the '
          'not-selection rule.',
      '[AstryxCalendar](calendar) — the grid this package already ships.',
      '[AstryxGrid](grid) — laying a wall out, which is a different question.',
    ]),
  ],
);

const DocPage _useTreeFocus = DocPage(
  id: 'use_tree_focus',
  title: 'useTreeFocus → AstryxTreeList',
  group: _group,
  description:
      'Arrow-key traversal across a tree, including expand and collapse.',
  source: 'lib/src/components/data/tree_list.dart',
  upstream: 'useTreeFocus',
  upstreamPath: '/components/useTreeFocus',
  blocks: <DocBlock>[
    DocProse(
      'A tree is a list whose length changes as you walk it, and whose inline '
      'arrows mean something else entirely. That is why it is '
      '[AstryxTreeList](tree_list) rather than a configuration of '
      '[AstryxRovingFocus](use_list_focus).',
    ),
    DocExample('tree_list_demo', align: DocExampleAlign.stretch),
    DocHeading('Why it is not the list primitive'),
    DocTable(
      headers: <String>['Key', 'In a tree'],
      rows: <List<String>>[
        <String>[
          '`↑` / `↓`',
          'Moves through the **visible** rows — so collapsing a node changes '
              'what "next" means, mid-traversal.',
        ],
        <String>[
          '`→`',
          'Expands a collapsed node, then moves into it. Not "next item".',
        ],
        <String>[
          '`←`',
          'Collapses an expanded node, or moves to its parent. Mirrored under '
              'RTL.',
        ],
        <String>['`Enter` / `Space`', 'Presses the row.'],
      ],
    ),
    DocProse(
      'Two of the four arrows therefore do a *different job* from their list '
      'counterparts, and the traversal order is derived from state the tree '
      'owns. Forcing that through a flat index is how a tree ends up focusing '
      'a row that is no longer on screen.',
    ),
    DocCallout.accessibility(
      'A collapsed subtree is **not in the widget tree**: no layout, no '
      'semantics, and no focus stops behind a closed node. Each row carries '
      'its expanded state in its semantics, so a reader is told rather than '
      'left to infer it from a rotated chevron.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTreeList](tree_list) — the widget, and its properties.',
      '[useListFocus](use_list_focus) — the flat case, and the primitive.',
      '[AstryxCollapsible](collapsible) — one disclosure rather than a tree of '
          'them.',
    ]),
  ],
);

const DocPage _useLayer = DocPage(
  id: 'use_layer',
  title: 'useLayer → Overlay and the stack',
  group: _group,
  description: 'Placing content in the overlay stack at the right depth.',
  source: 'lib/src/foundation/overlay_stack.dart',
  upstream: 'useLayer',
  upstreamPath: '/components/useLayer',
  blocks: <DocBlock>[
    DocProse(
      'Upstream needs a hook to claim a depth in a shared stacking context, '
      'because the web has no built-in place to put floating content. Flutter '
      'has one and it is called `Overlay` — so there is nothing to claim, and '
      'no `useLayer` to port.',
    ),
    DocProse(
      'What remains is the *order* things close in, which is '
      '[the overlay layer](layer_provider): `AstryxOverlayStack` tracks the '
      'open dismissible layers so **Escape closes one, not all of them**.',
    ),
    DocExample('provider_layer', align: DocExampleAlign.start),
    DocHeading('Building your own layer'),
    DocCode('''
final layer = AstryxOverlayController();

AstryxOverlay(
  controller: layer,
  label: 'Preview',
  child: myPanel,      // scrim, focus trap, Escape, entry animation
)'''),
    DocProse(
      'Reach past that only for something `AstryxOverlay` cannot express. Then '
      'the contract to honour is four lines long: register with the stack '
      'while open, unregister on close *and on dispose*, answer Escape only '
      'when `isTopmost`, and trap focus if you dimmed the page.',
    ),
    DocCode('''
@override
void initState() {
  super.initState();
  AstryxOverlayStack.push(_dismiss, modal: true);
}

@override
void dispose() {
  // On dispose too, or a gone layer keeps swallowing Escape.
  AstryxOverlayStack.remove(_dismiss);
  super.dispose();
}'''),
    DocCallout.warning(
      'The unregister-on-dispose line is the one that gets forgotten, and the '
      'bug it causes is remote from its cause: Escape stops working somewhere '
      'else on the page, long after the layer that broke it has gone.',
    ),
    DocHeading('Depth, as far as it exists'),
    DocProse(
      'Order is push order, and that is sound rather than lucky: a Flutter '
      'overlay opens when something calls `show`, and the inner one is always '
      'shown after the outer one that contains its trigger. There is no '
      'z-index to manage and no depth to pass.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[The overlay layer](layer_provider) — the stack, and where layers are '
          'hosted.',
      '[AstryxOverlay](overlay) — the scrim-and-layer widget.',
      '[AstryxScrollLock](use_scroll_lock) — what a modal layer should freeze '
          'behind it.',
    ]),
  ],
);

const DocPage _useClickableContainer = DocPage(
  id: 'use_clickable_container',
  title: 'useClickableContainer → onPressed',
  group: _group,
  description:
      'Making a container behave as one control without nesting interactive '
      'elements.',
  source: 'lib/src/components/surface/card.dart',
  upstream: 'useClickableContainer',
  upstreamPath: '/components/useClickableContainer',
  blocks: <DocBlock>[
    DocProse(
      'Upstream needs a hook because a `<div>` is not a button: making one '
      'behave like one means adding a role, a tab index, key handlers, and the '
      'hover and press styling by hand. Here it is a parameter. **A non-null '
      '`onPressed` makes the container a button** — hover, press, a focus '
      'ring, `Semantics(button: true)` and the tap-target guarantee, all of '
      'it.',
    ),
    DocExample('hook_clickable_container', align: DocExampleAlign.stretch),
    DocTable(
      headers: <String>['A pressable…', 'Is'],
      rows: <List<String>>[
        <String>['surface', '`AstryxCard(onPressed:, semanticsLabel:)`'],
        <String>['row', '`AstryxItem(onPressed:)`'],
        <String>[
          'card that carries selection',
          '`AstryxSelectableCard` — a *control*, announced as a checkbox or a '
              'radio, reporting a selection rather than a press',
        ],
        <String>['band of controls', '`AstryxToolbar` — one tab stop'],
      ],
    ),
    DocCallout.warning(
      '**There is no `ClickableCard`.** One card, with a parameter — because '
      'two widgets that differ only in whether they respond to a press are two '
      'widgets that drift apart on padding, radius and focus.',
    ),
    DocHeading('One control, not two'),
    DocProse(
      'The rule the hook exists to enforce: **a pressable container must not '
      'contain another control.** A button inside a button is a node assistive '
      'technology cannot describe and a keyboard cannot reach twice, and the '
      'press that lands is a coin toss.',
    ),
    DocList(<String>[
      'Row actions belong *beside* the row, in a cell of their own — which is '
          'what `AstryxTable.rowActionsBuilder` is for.',
      'A card with a menu in its corner should not itself be pressable: put '
          'the navigation on a link or a title inside it.',
      'A checkbox and a pressable card are the same gesture competing. Use '
          '`AstryxSelectableCard`, which is that gesture done once.',
    ]),
    DocHeading('Building your own'),
    DocProse(
      'For a surface this package has no widget for, three primitives are the '
      'whole of it — and the nesting order is not optional:',
    ),
    DocCode('''
AstryxSemanticsButton(        // outer: the node, with the label
  label: 'Open the deploy log',
  onPressed: _open,
  child: AstryxTapTarget(     // inner: the 48px hit region on touch
    child: GestureDetector(onTap: _open, child: surface),
  ),
)'''),
    DocProse(
      'Nested the other way the semantics node keeps the child’s small bounds, '
      'so assistive technology still sees a 20×20 target however large the hit '
      'region is: the pointer works and the accessibility guarantee silently '
      'does not. State goes through `AstryxStatesController`, which suppresses '
      'hover on touch so a tap does not leave the surface looking hovered.',
    ),
    DocCallout.accessibility(
      'A pressable container needs a name of its own — `semanticsLabel` on a '
      'card — because its content is a heading, a paragraph and a badge, and a '
      'reader announcing all three as the button’s name is not a label. Hover '
      'styling is gated on '
      '`AstryxTheme.densityOf(context).supportsHover`, so nothing lives behind '
      'a hover a touch user cannot perform.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCard](card) — the surface, pressable or not.',
      '[AstryxSelectableCard](selectable_card) — the selection-carrying form.',
      '[AstryxItem](item) — the row the lists are built from.',
      '[Accessibility](accessibility) — the nesting rule, in context.',
    ]),
  ],
);

const DocPage _useInputContainer = DocPage(
  id: 'use_input_container',
  title: 'useInputContainer → the field',
  group: _group,
  description:
      'Sharing focus, hover and validation state between a field and its '
      'affixes.',
  source: 'lib/src/components/forms/input_container.dart',
  upstream: 'useInputContainer',
  upstreamPath: '/components/useInputContainer',
  blocks: <DocBlock>[
    DocProse(
      'Upstream needs a hook because a text field, its icon, its clear button '
      'and its unit suffix are separate elements that must agree about one '
      'state: focused, hovered, invalid, disabled. Here that agreement is a '
      'widget — `AstryxInputContainer` — and it is **internal on purpose**.',
    ),
    DocCallout.note(
      'It is not exported. Three controls drifting apart on border colour and '
      'focus ring is exactly how a design system stops looking like one, so '
      'the container is shared between the text inputs and the selector and is '
      'not offered as a building block. What is public is everything you would '
      'reach for it *through*.',
    ),
    DocTable(
      headers: <String>['To…', 'Use'],
      rows: <List<String>>[
        <String>[
          'put an icon, a unit or a button inside a field',
          '`leading` and `trailing` on `AstryxTextInput` — the slots the '
              'container lays out',
        ],
        <String>[
          'join several controls into one bordered row',
          '[AstryxInputGroup](input_group), with `AstryxInputGroupText` for '
              'the affixes',
        ],
        <String>[
          'give your own control a label, a description and validation',
          '[AstryxField](field), which publishes them through '
              '`AstryxFieldScope`',
        ],
        <String>[
          'read that state in your own control',
          '`AstryxFieldScope.maybeOf(context)` — the label, the status and '
              'whether the field is enabled',
        ],
      ],
    ),
    DocExample('field_scope', align: DocExampleAlign.start),
    DocHeading('What the container guarantees'),
    DocList(<String>[
      '**A press anywhere focuses the control.** A user who clicks the padding '
          'of a text field expects a caret, not nothing — upstream’s '
          '`useInputContainer` does the same.',
      '**The affixes stay announced.** Only the editable is excluded from '
          'semantics, not the whole box: excluding the container once took the '
          '`leading` and `trailing` slots with it, so a clear button announced '
          'as nothing at all while staying perfectly clickable.',
      '**One border, one status.** Focus doubles the border rather than adding '
          'a ring outside it, and a status colours the whole box — including '
          'affixes that did not cause it.',
    ]),
    DocCallout.accessibility(
      'Flutter has no `<label for>`, so a label rendered merely *next to* a '
      'control is invisible to a screen reader. `AstryxField` publishes its '
      'label, description and status through a scope and each input folds them '
      'into the semantics node it already owns — which is the entire reason '
      'that widget exists.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxField](field) — the label and validation wrapper.',
      '[AstryxInputGroup](input_group) — adjacent controls as one box.',
      '[AstryxTextInput](text_input) — the field the container was built for.',
    ]),
  ],
);

const DocPage _useKeyboardHint = DocPage(
  id: 'use_keyboard_hint',
  title: 'AstryxKeyboardHint',
  group: _group,
  description:
      'Showing shortcut hints only once the user is navigating by keyboard.',
  source: 'lib/src/foundation/keyboard_hint.dart',
  upstream: 'useKeyboardHint',
  upstreamPath: '/components/useKeyboardHint',
  blocks: <DocBlock>[
    DocExample('hook_keyboard_hint', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxItem(
  label: 'Command palette',
  trailing: const AstryxKeyboardHint(
    child: AstryxKbd.hotkey(palette),
  ),
)'''),
    DocProse(
      'A shortcut hint beside every row is noise for somebody using a mouse '
      'and the whole point for somebody who is not. This shows its child while '
      'the last input was a key and steps back once a pointer is used.',
    ),
    DocProse(
      'It reads the same last-input-device signal as the focus ring '
      '(`AstryxFocusVisible`), so a hint and a ring can never disagree about '
      'which mode the user is in — which is what would make either of them '
      'look broken.',
    ),
    DocHeading('It keeps its space'),
    DocProse(
      '`reserveSpace` is on by default, and worth leaving on: a hint that '
      'appears on the first keystroke and pushes a row’s contents sideways '
      'draws the eye to the wrong thing at exactly the wrong moment. Hidden it '
      'is not painted, not hit-tested and not announced — but the row does not '
      'change shape.',
    ),
    DocProse(
      '`otherwise` fills the slot with something else on a pointer — a '
      'timestamp where the shortcut would be — which is the version that '
      'wastes no space at all.',
    ),
    DocCallout.warning(
      '**A hint is a reminder, never the only route.** Whatever the shortcut '
      'does must also be reachable by pressing something: this hides a *hint*, '
      'not a control. Putting a control in here is the keyboard equivalent of '
      'hiding one behind hover, and it fails the same people.',
    ),
    DocApi('AstryxKeyboardHint', <DocProp>[
      DocProp('child', 'Widget', 'The hint.', required: true),
      DocProp(
        'reserveSpace',
        'bool',
        'Whether the hint keeps its space while hidden.',
        defaultValue: 'true',
      ),
      DocProp(
        'otherwise',
        'Widget?',
        'What to show instead while the user is on a pointer.',
      ),
      DocProp(
        'excludeFromSemantics',
        'bool',
        'Whether to keep the hint out of the semantics tree. It is announced '
            'by default, because the hint is usually where the shortcut is '
            'written down.',
        defaultValue: 'false',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxHotkeys](use_hotkeys) — binding the shortcut this describes.',
      '[AstryxKbd](kbd) — drawing the keys.',
      '[AstryxSideNav](side_nav) — the one place hover is allowed to reveal '
          'something, and why.',
    ]),
  ],
);

const DocPage _useEntryAnimation = DocPage(
  id: 'use_entry_animation',
  title: 'AstryxEntryAnimation',
  group: _group,
  description: 'Animating an element as it enters, respecting reduced-motion.',
  source: 'lib/src/foundation/entry_animation.dart',
  upstream: 'useEntryAnimation',
  upstreamPath: '/components/useEntryAnimation',
  blocks: <DocBlock>[
    DocExample('hook_entry_animation', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxEntryAnimation(
  transition: AstryxEntryTransition.fadeUp,
  child: AstryxCard(child: summary),
)'''),
    DocProse(
      'Two things a hand-rolled `AnimationController` in a `StatefulWidget` '
      'routinely gets wrong, and this does not: the duration and easing come '
      'from **tokens**, and reduced motion means *not animating* rather than '
      'animating quickly.',
    ),
    DocTable(
      headers: <String>['`AstryxEntryTransition`', 'For'],
      rows: <List<String>>[
        <String>[
          '`fade`',
          'The safe default. Nothing moves, so nothing can be read as a layout '
              'shift.',
        ],
        <String>[
          '`fadeUp`',
          'Says "this is new" rather than "this was always here", which a fade '
              'alone cannot.',
        ],
        <String>[
          '`fadeScale`',
          'Something that appeared *at* a point — a card just created, a panel '
              'with a source.',
        ],
      ],
    ),
    DocHeading('Once per element'),
    DocProse(
      'The animation runs when the element is first built and never again. To '
      'replay it — a list that re-animates when its filter changes — give it a '
      '`key` that changes with the content. That is not a workaround: a new '
      'key tells Flutter this is new content rather than the old content '
      'updated, which is the same thing the animation is trying to say.',
    ),
    DocProse(
      'Once it has finished, the transition widgets are dropped from the tree '
      'rather than left behind — an opacity layer on every card that ever '
      'entered is a repaint cost for the rest of the session.',
    ),
    DocCallout.warning(
      'A `delay` is for staggering a list, and the total matters more than the '
      'step: keep it under about a quarter of a second. A stagger a user has '
      'to wait out has stopped being an animation and become a loading state.',
    ),
    DocCallout.accessibility(
      'Under `prefers-reduced-motion` the child is simply *there* — no frame '
      'of it is animated. A shorter animation is still an animation, and the '
      'setting exists for people whom motion makes unwell. Nothing about the '
      'content, the layout or the semantics differs between the two paths.',
    ),
    DocApi('AstryxEntryAnimation', <DocProp>[
      DocProp('child', 'Widget', 'The content that enters.', required: true),
      DocProp(
        'transition',
        'AstryxEntryTransition',
        'How it enters.',
        defaultValue: 'AstryxEntryTransition.fade',
      ),
      DocProp(
        'duration',
        'AstryxDurationToken',
        'How long the entry takes.',
        defaultValue: 'AstryxDurationToken.mediumMin',
      ),
      DocProp(
        'ease',
        'AstryxEaseToken',
        'The easing curve.',
        defaultValue: 'AstryxEaseToken.standard',
      ),
      DocProp(
        'delay',
        'Duration',
        'How long to wait before starting.',
        defaultValue: 'Duration.zero',
      ),
      DocProp(
        'offset',
        'double',
        'How far `fadeUp` rises, in logical pixels.',
        defaultValue: '8',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether to animate at all.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[useContainerReveal](use_container_reveal) — the same entry, triggered '
          'by a scroll.',
      '[Motion](motion) — the tokens, and what must not move.',
    ]),
  ],
);

const DocPage _useContainerReveal = DocPage(
  id: 'use_container_reveal',
  title: 'AstryxContainerReveal',
  group: _group,
  description: 'Revealing content as its container scrolls into view.',
  source: 'lib/src/foundation/entry_animation.dart',
  upstream: 'useContainerReveal',
  upstreamPath: '/components/useContainerReveal',
  blocks: <DocBlock>[
    DocExample('hook_container_reveal', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxContainerReveal(
  transition: AstryxEntryTransition.fadeUp,
  child: AstryxCard(child: chart),
)'''),
    DocProse(
      'Upstream uses an `IntersectionObserver`. Flutter has none, so this '
      'watches the enclosing `Scrollable`’s position and compares its own '
      'bounds against the viewport’s — revealing once `fraction` of it is in '
      'view, and then **once only**.',
    ),
    DocHeading('Laid out before it is revealed'),
    DocProse(
      'A hidden child is still measured and still occupies its space. A reveal '
      'that changed the page height as it fired would move everything below it '
      '— including whatever the reader was reading — and would make the '
      'scrollbar lie about the length of the page.',
    ),
    DocCallout.note(
      '**With no enclosing scrollable it reveals immediately.** There is '
      'nothing to wait for, and content that never appears because a widget '
      'was looking for a viewport that does not exist is the worse failure by '
      'a wide margin.',
    ),
    DocHeading('Measured after the frame'),
    DocProse(
      'A scroll position notifies its listeners *before* the frame that moves '
      'anything, so measuring inside the callback reads the previous frame’s '
      'geometry — and a reveal that checks a position its child has already '
      'left never fires. The check is therefore posted to the end of the '
      'frame, coalesced to one per frame.',
    ),
    DocCallout.warning(
      'Reveal-on-scroll is a decoration, and a page of forty of them is forty '
      'listeners and forty rebuilds. Use it for a handful of substantial '
      'blocks — a chart, a section — not for every row of a table. It stops '
      'listening the moment it has fired, so the cost is bounded, but the cost '
      'of never adding it is zero.',
    ),
    DocApi('AstryxContainerReveal', <DocProp>[
      DocProp('child', 'Widget', 'The content revealed.', required: true),
      DocProp(
        'transition',
        'AstryxEntryTransition',
        'How it enters once in view.',
        defaultValue: 'AstryxEntryTransition.fadeUp',
      ),
      DocProp(
        'fraction',
        'double',
        'How much of the child must be in view before it reveals, 0 to 1.',
        defaultValue: '0.1',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether to wait at all. False reveals on the first frame.',
        defaultValue: 'true',
      ),
      DocProp(
        'onRevealed',
        'VoidCallback?',
        'Called once, when the child is first revealed.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxEntryAnimation](use_entry_animation) — the entry this runs, and '
          'its transitions.',
      '[AstryxScrollOverflow](use_scroll_overflow) — the other thing worth '
          'knowing about a scroller.',
    ]),
  ],
);

const DocPage _useImageMode = DocPage(
  id: 'use_image_mode',
  title: 'useImageMode → the resolved mode',
  group: _group,
  description: 'Choosing the light or dark variant of an image.',
  upstream: 'useImageMode',
  upstreamPath: '/components/useImageMode',
  blocks: <DocBlock>[
    DocProse(
      'Upstream needs a hook because CSS cannot swap an `<img src>` on a media '
      'query without duplicating the element. Flutter can just pick, and the '
      'resolved mode is already in scope — so this is one line and there is no '
      'widget to port.',
    ),
    DocExample('hook_image_mode', align: DocExampleAlign.start),
    DocCode('''
final dark = AstryxTheme.of(context).mode == AstryxThemeMode.dark;

Image.asset(dark ? 'assets/logo_dark.png' : 'assets/logo_light.png')'''),
    DocProse(
      '`AstryxThemeData.brightness` is the same answer as a Flutter '
      '`Brightness`, for an API that wants one. Both **subscribe**: a widget '
      'that reads either rebuilds when the mode changes, so an asset swapped '
      'this way follows a system theme change with nothing else wired up.',
    ),
    DocCallout.warning(
      'Reach for two assets only when the image genuinely has two versions — a '
      'logo with a light and a dark lockup, a diagram with dark ink. A '
      'photograph does not, and inverting one is a worse result than leaving '
      'it alone. For an icon, use `AstryxIcon`: it takes its colour from the '
      'theme already, so there is nothing to swap.',
    ),
    DocCallout.accessibility(
      'Both variants of an image are the same picture, so both take the '
      '**same** `semanticLabel`. And whatever the image conveys must survive '
      'it being unavailable: a diagram carrying information no caption repeats '
      'is information a screen-reader user does not have.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[useTheme](use_theme) — everything else the resolved theme carries.',
      '[Colour](color) — the semantic roles, which almost always beat swapping '
          'an asset.',
      '[Illustrations](illustrations) — the upstream set, and what a port '
          'would need.',
    ]),
  ],
);

const DocPage _useStreamingText = DocPage(
  id: 'use_streaming_text',
  title: 'AstryxStreamingText',
  group: _group,
  description: 'Rendering text as it arrives token by token.',
  source: 'lib/src/components/data/streaming_text.dart',
  upstream: 'useStreamingText',
  upstreamPath: '/components/useStreamingText',
  blocks: <DocBlock>[
    DocExample('hook_streaming_text', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxStreamingText(
  _answer,                 // grows as chunks arrive
  streaming: _isStreaming, // false once the response ends
)'''),
    DocProse(
      'A model’s output does not arrive smoothly: it comes in bursts of a few '
      'tokens with pauses between them, and rendering each burst the instant '
      'it lands reads as stuttering. This reveals what has arrived at a '
      'constant rate, so the text appears to be typed rather than to twitch.',
    ),
    DocProse(
      'Hand it the whole text you have so far on every build. It tracks how '
      'much of that is already on screen, so there is no buffer to manage and '
      'no chunk boundary to remember.',
    ),
    DocHeading('It never rewinds'),
    DocProse(
      'More text extends what is shown. Text that is *not* a continuation of '
      'what was shown is a rewrite rather than a stream — a retry, a '
      'correction — and is swapped in whole, because a caret walking backwards '
      'over a sentence is a bug nobody can read past.',
    ),
    DocCallout.accessibility(
      '**The whole text is the accessible name from the first frame**, not the '
      'part that happens to be on screen. A live region firing per token would '
      'restart the sentence eighty times a second, which is not a reading '
      'experience — it is a denial of one. The partial text is excluded from '
      'semantics and the node carries the complete string, so a screen-reader '
      'user gets the answer once, in full.',
    ),
    DocCallout.note(
      'Under reduced motion everything that has arrived is shown at once. The '
      'caret is static rather than blinking, for the same reason: a blink is a '
      'second animation that would have to be suppressed, and the caret’s job '
      '— "there is more coming" — it does standing still.',
    ),
    DocApi('AstryxStreamingText', <DocProp>[
      DocProp(
        'text',
        'String',
        'Everything that has arrived so far.',
        required: true,
      ),
      DocProp(
        'streaming',
        'bool',
        'Whether more is expected. Only affects the caret — the reveal is '
            'driven by `text` either way.',
        defaultValue: 'true',
      ),
      DocProp(
        'charactersPerSecond',
        'double',
        'How fast text is revealed. 80 is a little faster than a fast typist '
            'and slow enough to read along with.',
        defaultValue: '80',
      ),
      DocProp(
        'showCaret',
        'bool',
        'Whether to draw a caret while there is more to come.',
        defaultValue: 'true',
      ),
      DocProp(
        'semanticsLabel',
        'String?',
        'What a screen reader announces. Defaults to the whole of `text`.',
      ),
      DocProp(
        'onCompleted',
        'VoidCallback?',
        'Called once the screen matches what has arrived — which is not the '
            'same as the response being over.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxSpinner](spinner) — the wait *before* the first token.',
      '[AstryxSkeleton](skeleton) — a wait whose result has a known shape.',
      '[AstryxText](text) — everything about type and colour.',
    ]),
  ],
);

const DocPage _useTranslator = DocPage(
  id: 'use_translator',
  title: 'useTranslator → AstryxLocalizations.of',
  group: _group,
  description: 'Looking up a translated string.',
  source: 'lib/src/localizations/astryx_localizations.dart',
  upstream: 'useTranslator',
  upstreamPath: '/components/useTranslator',
  blocks: <DocBlock>[
    DocProse(
      'Upstream looks a key up in a map. Here the strings are **getters and '
      'methods on a class**, so a missing one is a compile error rather than a '
      'blank on screen, and a typo in a key is not expressible.',
    ),
    DocExample('hook_translator', align: DocExampleAlign.stretch),
    DocCode('''
final l10n = AstryxLocalizations.of(context);

l10n.dialogClose;              // 'Close'
l10n.clearField('Email');      // 'Clear Email'
l10n.paginationPage(3, 20);    // 'Page 3 of 20'
'''),
    DocProse(
      'A method rather than an interpolated template for anything with a '
      'placeholder: word order is part of a translation, and a template like '
      '"{count} items" cannot be reordered by a translator while a Dart method '
      'can.',
    ),
    DocCallout.note(
      '`of(context)` **never returns null**, falling back to the English '
      'defaults. A missing localisation should not be an exception in front of '
      'a user, and a partial translation should be a working app with some '
      'English in it.',
    ),
    DocProse(
      'It is also a subscription: override the strings for a subtree with an '
      '[AstryxLocalizationsScope](internationalization_provider) and '
      'everything below it rebuilds.',
    ),
    DocHeading('These are the widgets’ strings, not yours'),
    DocProse(
      '`AstryxLocalizations` covers what the *widget set* says — "Required", '
      '"No matches", "Sort ascending", "3 minutes ago". Your own copy belongs '
      'in your own localisations, through `flutter_localizations` and the ARB '
      'tooling, which this package neither wraps nor replaces.',
    ),
    DocCallout.warning(
      'Do not read a string out of here to label something of your own — '
      '`l10n.tableNoData` on your empty state ties your copy to a widget’s '
      'wording, and the next release is entitled to change it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLocalizationsScope](internationalization_provider) — installing '
          'and overriding the strings.',
      '[Right-to-left](rtl) — the other half of internationalisation, which is '
          'a `Directionality` and nothing else.',
    ]),
  ],
);
