import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// App shell — the frame an application sits in, and the page inside it.
final List<DocPage> appShellPages = <DocPage>[
  _appShell,
  _layout,
  _section,
  _resizeHandle,
  _outline,
];

const String _group = DocGroup.appShell;

// -----------------------------------------------------------------------------
// AstryxAppShell
// -----------------------------------------------------------------------------

final DocPage _appShell = DocPage(
  id: 'app_shell',
  title: 'AstryxAppShell',
  group: _group,
  description:
      'The outer frame of an application: header, navigation, content, and the '
      'responsive behaviour joining them.',
  source: 'lib/src/components/shell/app_shell.dart',
  upstream: 'AppShell / useAppShellMobile',
  upstreamPath: '/components/AppShell',
  blocks: <DocBlock>[
    const DocExample('app_shell_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode("import 'package:astryx_ui/astryx_ui.dart';"),
    const DocCode('''
AstryxAppShell(
  header: const AppBar(),
  sidebar: const NavRail(),
  child: AstryxLayout(
    header: const AstryxHeading('Deploys', level: 1),
    child: const DeployTable(),
  ),
)'''),
    const DocTree('''
AstryxAppShell
├── header    ← full width, above everything
├── sidebar   ← beside the content, or behind a drawer
└── child     ← the content. Usually one AstryxLayout'''),
    const DocProse(
      'The header spans the whole window by design: an application’s identity '
      'and its account menu belong to the window, not to the column beside the '
      'navigation.',
    ),
    const DocHeading('Wide, and narrow'),
    const DocProse(
      'Above `compactBelow` the navigation sits beside the content. Below it, '
      'the navigation moves behind a drawer — and the drawer is a real '
      '[AstryxOverlay](overlay), so it traps focus, closes on Escape or a '
      'press on the scrim, and hands focus back to the button that opened it. '
      'A shell that hides navigation without any of that is a shell that loses '
      'keyboard users at the first tap.',
    ),
    const DocProse(
      'Growing back out of the compact layout closes the drawer, because a '
      'drawer left open would be a second copy of the navigation now sitting '
      'beside the content.',
    ),
    const DocCallout.note(
      '`compactBelow` is a number, not an entry in a breakpoint table. This '
      'package has [no breakpoint system](layout_guide) on purpose: the width '
      'at which *your* navigation stops fitting is a fact about your '
      'navigation, and a global table means every screen has to agree about a '
      'number none of them chose.',
    ),
    const DocHeading('Asking the shell where the navigation went'),
    const DocProse(
      '`AstryxAppShell.of(context)` is the port of upstream’s '
      '`useAppShellMobile`. A header cannot know whether to draw a menu button '
      'without knowing whether the navigation is beside the content or behind '
      'a drawer, and that answer belongs to the shell.',
    ),
    const DocCode('''
final shell = AstryxAppShell.of(context);

if (shell.compact)
  AstryxIconButton(
    icon: AstryxIconName.menu,
    label: 'Open navigation',
    onPressed: shell.controller.toggle,
  )'''),
    const DocProse(
      '`AstryxAppShellController` is an `AstryxOverlayController`, because the '
      'drawer *is* one of this package’s overlays: `show`, `hide` and `toggle` '
      'mean here what they mean on a [dialog](dialog), and the drawer joins '
      'the same dismissal stack — so Escape closes the topmost thing rather '
      'than whatever was opened first.',
    ),
    const DocCallout.warning(
      'There is no navigation rail in this package yet — `SideNav`, `TopNav` '
      'and `MobileNav` are still to come. `header` and `sidebar` take any '
      'widget, and an [AstryxList](list) of [AstryxItem](item)s gets a long '
      'way in the meantime.',
    ),
    DocApi('AstryxAppShell', _appShellProps),
    DocApi(
      'AstryxAppShellScope',
      _scopeProps,
      description: 'What `AstryxAppShell.of(context)` returns.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxLayout](layout) — the frame *inside* this one.',
      '[AstryxOverlay](overlay) — the primitive the drawer is built on.',
    ]),
  ],
);

final List<DocProp> _appShellProps = <DocProp>[
  const DocProp(
    'child',
    'Widget',
    'The content: usually one `AstryxLayout`.',
    required: true,
  ),
  const DocProp(
    'header',
    'Widget?',
    'The bar across the top, above both the navigation and the content.',
  ),
  const DocProp(
    'sidebar',
    'Widget?',
    'The navigation. Beside the content when there is room, behind a drawer '
        'when there is not.',
  ),
  const DocProp(
    'controller',
    'AstryxAppShellController?',
    'Drives the drawer from outside. Null keeps one inside the shell.',
  ),
  const DocProp(
    'sidebarWidth',
    'double',
    'How wide the navigation is when it sits beside the content.',
    defaultValue: '260',
  ),
  const DocProp(
    'compactBelow',
    'double',
    'The width below which the navigation moves into the drawer.',
    defaultValue: '900',
  ),
  const DocProp('navLabel', 'String?', 'The drawer’s accessible name.'),
];

final List<DocProp> _scopeProps = <DocProp>[
  const DocProp(
    'compact',
    'bool',
    'Whether the navigation is behind a drawer rather than beside the content.',
  ),
  const DocProp(
    'controller',
    'AstryxAppShellController',
    'The drawer’s controller — `show`, `hide`, `toggle`, `isOpen`.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxLayout
// -----------------------------------------------------------------------------

final DocPage _layout = DocPage(
  id: 'layout',
  title: 'AstryxLayout',
  group: _group,
  description:
      'The content frame inside the shell — header, footer, panel and '
      'scrolling body.',
  source: 'lib/src/components/shell/layout.dart',
  upstream:
      'Layout / LayoutContent / LayoutFooter / LayoutHeader / LayoutPanel',
  upstreamPath: '/components/Layout',
  blocks: <DocBlock>[
    const DocExample('layout_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxLayout(
  header: const AstryxHeading('Deploys', level: 1),
  footer: AstryxButton(label: 'Save', onPressed: save),
  child: const DeployTable(),
)'''),
    const DocProse(
      '**The header and the footer do not scroll; the body does.** That is the '
      'whole of it, and the reason this is a widget rather than a `Column`: a '
      'page title that scrolls away takes the reader’s place in the hierarchy '
      'with it, and a Save button that scrolls away is a Save button people '
      'cannot find.',
    ),
    const DocTree('''
AstryxLayout
├── header   ← pinned, with a rule under it
├── child    ← the body. Scrolls
│   └── panel ← beside the body, scrolling on its own
└── footer   ← pinned, with a rule over it'''),
    const DocProse(
      'Upstream splits this into five components — `Layout`, `LayoutHeader`, '
      '`LayoutContent`, `LayoutPanel`, `LayoutFooter`. They are slots here, '
      'because a slot cannot be put in the wrong order, left out of its '
      'parent, or nested inside another one by mistake.',
    ),
    const DocHeading('The panel'),
    const DocProse(
      'A column beside the body — details, filters, an outline. It scrolls on '
      'its own: a panel tied to the body’s scroll position is a panel that '
      'disappears while you are reading it.',
    ),
    const DocExample('layout_panel', align: DocExampleAlign.stretch),
    const DocProse(
      '`panelSide` is logical, so a panel at the `end` sits on the right under '
      'LTR and on the left under RTL, with no second layout to maintain.',
    ),
    const DocHeading('Scrolling and measure'),
    const DocTable(
      headers: <String>['Set', 'When'],
      rows: <List<String>>[
        <String>[
          '`scrollable: false`',
          'The body scrolls itself — a table with a pinned header row, a '
              'transcript that stays at the bottom. Two scroll views inside '
              'one another is one too many.',
        ],
        <String>[
          '`maxContentWidth`',
          'A page of prose or a single form, where a line running the width '
              'of a monitor is unreadable. Leave it null for a table.',
        ],
      ],
    ),
    DocApi('AstryxLayout', _layoutProps),
    DocApi('AstryxLayoutPanelSide', _panelSideProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxAppShell](app_shell) — the frame around this one.',
      '[AstryxCenter](center) — what `maxContentWidth` uses.',
      '[Layout](layout_guide) — the guide, for a page with no shell at all.',
    ]),
  ],
);

final List<DocProp> _layoutProps = <DocProp>[
  const DocProp(
    'child',
    'Widget',
    'The body, which is what scrolls.',
    required: true,
  ),
  const DocProp(
    'header',
    'Widget?',
    'The band above the body — a title, a breadcrumb trail, tabs. Pinned.',
  ),
  const DocProp(
    'footer',
    'Widget?',
    'The band below the body — the actions a form is submitted with. Pinned.',
  ),
  const DocProp(
    'panel',
    'Widget?',
    'A column beside the body, scrolling on its own.',
  ),
  const DocProp(
    'panelSide',
    'AstryxLayoutPanelSide',
    'Which edge the panel sits against.',
    defaultValue: 'AstryxLayoutPanelSide.end',
  ),
  const DocProp(
    'panelWidth',
    'double',
    'How wide the panel is.',
    defaultValue: '320',
  ),
  const DocProp(
    'scrollable',
    'bool',
    'Whether the body scrolls.',
    defaultValue: 'true',
  ),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inset around the body, the header and the footer.',
    defaultValue: 'AstryxSpacingToken.spacing6',
  ),
  const DocProp(
    'maxContentWidth',
    'double?',
    'A measure for the body. Null lets it fill.',
  ),
];

final List<DocProp> _panelSideProps = <DocProp>[
  const DocProp(
    'start',
    'AstryxLayoutPanelSide',
    'The reading-start edge — a filter rail, a table of contents.',
  ),
  const DocProp(
    'end',
    'AstryxLayoutPanelSide',
    'The reading-end edge. The default: a details panel about whatever is '
        'selected in the body.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxSection
// -----------------------------------------------------------------------------

final DocPage _section = DocPage(
  id: 'section',
  title: 'AstryxSection',
  group: _group,
  description:
      'A titled band of page content, with its own heading level and spacing.',
  source: 'lib/src/components/shell/section.dart',
  upstream: 'Section',
  upstreamPath: '/components/Section',
  blocks: <DocBlock>[
    const DocExample('section_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxSection(
  title: 'Environments',
  description: 'Where this project is deployed.',
  actions: <Widget>[
    AstryxButton(label: 'New environment', onPressed: create),
  ],
  child: const EnvironmentGrid(),
)'''),
    const DocTree('''
AstryxSection
├── title       ← the heading. Its level is worked out, not given
│   ├── description ← under the title
│   └── actions     ← at the trailing edge of the heading row
└── child       ← the content'''),
    const DocHeading('The heading level looks after itself'),
    const DocProse(
      '**A section inside another section is one level deeper.** So a page '
      'assembled from parts nobody wrote together still produces an outline a '
      'screen reader can navigate — and getting that wrong is the commonest '
      'accessibility fault on a long page, because it is one nobody can see by '
      'looking at the screen.',
    ),
    const DocExample('section_nesting', align: DocExampleAlign.stretch),
    const DocProse(
      'The top level is 2, because 1 belongs to the page’s own title — usually '
      'in [AstryxLayout](layout)’s `header`. Pass `level` explicitly only when '
      'the nesting and the outline genuinely disagree; a section deeper than 6 '
      'stops there, where HTML stops and where a heading stops meaning '
      'anything.',
    ),
    const DocCallout.accessibility(
      'The rule under the heading is decoration; the *level* is the structure. '
      'A screen-reader user navigates a page by heading level, so a section '
      'that looks like a sub-part and announces itself as a peer has lied '
      'about the shape of the page.',
    ),
    const DocHeading('Anchoring an outline'),
    const DocProse(
      '`headerKey` goes on the heading row, which is what an '
      '[AstryxOutline](outline) entry points at — both to know where the '
      'heading is and to have somewhere to scroll to.',
    ),
    DocApi('AstryxSection', _sectionProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxLayout](layout) — the page these sit in.',
      '[AstryxOutline](outline) — the same structure, read back as a table of '
          'contents.',
      '[AstryxCard](card) — for a band that is a *surface* rather than a part '
          'of the document.',
    ]),
  ],
);

final List<DocProp> _sectionProps = <DocProp>[
  const DocProp(
    'child',
    'Widget',
    'The section’s content.',
    required: true,
  ),
  const DocProp(
    'title',
    'String?',
    'The heading. Null for a band that is grouped but not titled.',
  ),
  const DocProp(
    'description',
    'String?',
    'A line under the title, saying what the section is for.',
  ),
  const DocProp(
    'actions',
    'List<Widget>',
    'Controls at the trailing edge of the heading row.',
    defaultValue: 'const <Widget>[]',
  ),
  const DocProp(
    'level',
    'int?',
    'Overrides the heading level. Defaults to one deeper than the enclosing '
        'section, and to 2 at the top of a page.',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken',
    'The space between the heading block and the content.',
    defaultValue: 'AstryxSpacingToken.spacing4',
  ),
  const DocProp(
    'showDivider',
    'bool',
    'Whether to draw a rule under the heading block.',
    defaultValue: 'false',
  ),
  const DocProp(
    'headerKey',
    'Key?',
    'A key on the heading, for an `AstryxOutline` to find and scroll to.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxResizeHandle
// -----------------------------------------------------------------------------

final DocPage _resizeHandle = DocPage(
  id: 'resize_handle',
  title: 'AstryxResizeHandle',
  group: _group,
  description: 'A draggable divider that resizes the panel beside it.',
  source: 'lib/src/components/shell/resize_handle.dart',
  upstream: 'ResizeHandle / useResizable',
  upstreamPath: '/components/ResizeHandle',
  blocks: <DocBlock>[
    const DocExample('resize_handle_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
Row(
  children: <Widget>[
    SizedBox(width: _width, child: const Filters()),
    AstryxResizeHandle(
      label: 'Resize the filters',
      edge: AstryxResizeEdge.start,
      size: _width,
      min: 180,
      max: 480,
      onResize: (width) => setState(() => _width = width),
    ),
    const Expanded(child: Results()),
  ],
)'''),
    const DocProse(
      'The handle holds no size of its own: `size` comes in and `onResize` '
      'goes out, so the number lives in the state that also lays the region '
      'out. Upstream’s `useResizable` keeps the same split — the hook owns the '
      'number, the handle only reports the drag.',
    ),
    const DocHeading('Which way is bigger'),
    const DocProse(
      '`edge` is one value rather than an axis and a direction, because those '
      'two can be set inconsistently and this cannot: the edge decides the '
      'axis, which way a drag grows the region, and which arrow keys apply.',
    ),
    const DocTable(
      headers: <String>['Edge', 'The region is', 'Grows when dragged'],
      rows: <List<String>>[
        <String>[
          '`start`',
          'a panel at the reading-start edge',
          'toward the '
              'reading end',
        ],
        <String>[
          '`end`',
          'a panel at the reading-end edge',
          'toward the '
              'reading start',
        ],
        <String>['`top`', 'a band at the top', 'down'],
        <String>['`bottom`', 'a band at the bottom', 'up'],
      ],
    ),
    const DocProse(
      'The inline edges mirror under RTL, so the same physical drag grows the '
      'panel in both directions. The block edges never mirror.',
    ),
    const DocCallout.accessibility(
      '**Tab reaches it, and the arrow keys move it** by `step`, with Home and '
      'End at `min` and `max`. It announces itself as a slider carrying the '
      'current size, and `label` is required because nothing is painted on a '
      'handle — without one a screen reader has a slider and no idea what it '
      'sizes. A divider only a pointer can move is a layout only some people '
      'can use, and this is the part hand-rolled resize handles almost always '
      'miss.',
    ),
    const DocProse(
      'The drag target is `thickness` wide — wider than the hairline it draws, '
      'because a one-pixel target is a target nobody hits. The rule takes the '
      'accent while the handle is hovered or dragged, so the affordance '
      'appears where the pointer already is rather than as a permanent seam '
      'down the page.',
    ),
    DocApi('AstryxResizeHandle', _resizeProps),
    DocApi('AstryxResizeEdge', _resizeEdgeProps),
  ],
);

final List<DocProp> _resizeProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The handle’s accessible name. Required.',
    required: true,
  ),
  const DocProp(
    'size',
    'double',
    'The current size of the region beside the handle.',
    required: true,
  ),
  const DocProp(
    'onResize',
    'ValueChanged<double>?',
    'Called with the size the region should take, continuously during a drag. '
        'Null makes the handle inert.',
  ),
  const DocProp(
    'edge',
    'AstryxResizeEdge',
    'Which edge the resized region sits against.',
    defaultValue: 'AstryxResizeEdge.start',
  ),
  const DocProp(
    'min',
    'double',
    'The smallest the region may become.',
    defaultValue: '0',
  ),
  const DocProp(
    'max',
    'double',
    'The largest the region may become.',
    defaultValue: 'double.infinity',
  ),
  const DocProp(
    'step',
    'double',
    'How far one arrow-key press moves the handle.',
    defaultValue: '16',
  ),
  const DocProp(
    'onResizeEnd',
    'ValueChanged<double>?',
    'Called when a drag finishes, for persisting the size rather than writing '
        'it on every frame.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the handle responds.',
    defaultValue: 'true',
  ),
  const DocProp(
    'thickness',
    'double',
    'How wide the drag target is.',
    defaultValue: '8',
  ),
  const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _resizeEdgeProps = <DocProp>[
  const DocProp(
    'start',
    'AstryxResizeEdge',
    'A panel at the reading-start '
        'edge.',
  ),
  const DocProp('end', 'AstryxResizeEdge', 'A panel at the reading-end edge.'),
  const DocProp('top', 'AstryxResizeEdge', 'A band at the top.'),
  const DocProp('bottom', 'AstryxResizeEdge', 'A band at the bottom.'),
];

// -----------------------------------------------------------------------------
// AstryxOutline
// -----------------------------------------------------------------------------

final DocPage _outline = DocPage(
  id: 'outline',
  title: 'AstryxOutline',
  group: _group,
  description:
      'An on-this-page table of contents, tracking the reader’s position.',
  source: 'lib/src/components/shell/outline.dart',
  upstream: 'Outline',
  upstreamPath: '/components/Outline',
  blocks: <DocBlock>[
    const DocExample('outline_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxOutline(
  controller: _scroll,
  entries: <AstryxOutlineEntry>[
    AstryxOutlineEntry(id: 'setup', label: 'Setup', anchor: _setupKey),
    AstryxOutlineEntry(id: 'usage', label: 'Usage', anchor: _usageKey),
  ],
)'''),
    const DocHeading('What it tracks'),
    const DocProse(
      '**Where the anchors are, not where the scroll offset is.** An offset '
      'means nothing on its own — a page of short sections and a page of long '
      'ones put the same number in different places — so the active entry is '
      'the last one whose heading has passed the top of the viewport, with '
      '`topOffset` as the slack that stops it flickering between two.',
    ),
    const DocProse(
      'An entry’s `anchor` earns its keep twice: without it the outline cannot '
      'know where the heading is, and pressing the entry has nowhere to scroll '
      'to. [AstryxSection](section)’s `headerKey` is what usually goes there. '
      'Upstream gets both from the DOM id it links to.',
    ),
    const DocTable(
      headers: <String>['Give it', 'And it'],
      rows: <List<String>>[
        <String>[
          'a `controller`',
          'follows the reader by itself.',
        ],
        <String>[
          'an `activeId`',
          'marks that entry instead, whatever the scroll position says — for '
              'an outline driven by a router.',
        ],
        <String>[
          'neither',
          'is a list of links, and nothing is marked.',
        ],
        <String>[
          'an `onSelected`',
          'reports the press instead of scrolling, for a caller that navigates '
              'rather than scrolls.',
        ],
      ],
    ),
    const DocCallout.accessibility(
      'The entry being read is marked two ways: the accent rule down its edge '
      'and `selected` in the semantics tree — so it is not conveyed by colour '
      'alone, and a screen-reader user is told where they are without reading '
      'back up the page.',
    ),
    DocApi('AstryxOutline', _outlineProps),
    DocApi('AstryxOutlineEntry', _outlineEntryProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxSection](section) — what the entries point at.',
      '[AstryxLayout](layout) — its `panel` is where an outline usually goes.',
    ]),
  ],
);

final List<DocProp> _outlineProps = <DocProp>[
  const DocProp(
    'entries',
    'List<AstryxOutlineEntry>',
    'The headings, in the order they appear on the page.',
    required: true,
  ),
  const DocProp(
    'controller',
    'ScrollController?',
    'The scroll view the anchors live in. Given one, the outline tracks the '
        'reader by itself.',
  ),
  const DocProp(
    'activeId',
    'String?',
    'Marks an entry active, whatever the scroll position says.',
  ),
  const DocProp(
    'onSelected',
    'ValueChanged<String>?',
    'Called with the id the reader chose. Null scrolls to the anchor instead.',
  ),
  const DocProp('label', 'String?', 'The outline’s accessible name.'),
  const DocProp(
    'topOffset',
    'double',
    'How far below the top of the viewport a heading counts as reached.',
    defaultValue: '24',
  ),
];

final List<DocProp> _outlineEntryProps = <DocProp>[
  const DocProp(
    'id',
    'String',
    'This entry’s identity, unique within the outline.',
    required: true,
  ),
  const DocProp(
    'label',
    'String',
    'The heading text, as it appears in the outline.',
    required: true,
  ),
  const DocProp(
    'level',
    'int',
    'The heading level, which sets the indent.',
    defaultValue: '2',
  ),
  const DocProp(
    'anchor',
    'GlobalKey?',
    'A key on the heading this entry points at.',
  ),
];
