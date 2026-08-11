import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Navigation — getting around an application.
final List<DocPage> navigationPages = <DocPage>[
  _sideNav,
  _topNav,
  _mobileNav,
  _navHeadingMenu,
  _navIcon,
  _breadcrumbs,
  _link,
  _segmentedControl,
  _toolbar,
  _moreMenu,
  _tabMenu,
  _pagination,
];

const String _group = DocGroup.navigation;

/// The paragraph every page in this group needs, because the shared model is
/// the point of the group.
const DocProse _sharedModel = DocProse(
  'The rail, the bar and the drawer take the **same** `AstryxNavEntry` list — '
  '`AstryxNavItem` for a destination, `AstryxNavSection` for a labelled group, '
  '`AstryxNavDivider` for a rule. A navigation written once can be shown three '
  'ways, which is what stops an application from having a rail and a drawer '
  'that disagree about where its pages are.',
);

// -----------------------------------------------------------------------------
// AstryxSideNav
// -----------------------------------------------------------------------------

final DocPage _sideNav = DocPage(
  id: 'side_nav',
  title: 'AstryxSideNav',
  group: _group,
  description:
      'A vertical navigation rail with sections, headings, and a collapsed '
      'state.',
  source: 'lib/src/components/navigation/side_nav.dart',
  upstream:
      'SideNav / SideNavCollapseButton / SideNavHeading / SideNavItem / '
      'SideNavSection',
  upstreamPath: '/components/SideNav',
  blocks: <DocBlock>[
    const DocExample('side_nav_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode("import 'package:astryx_ui/astryx_ui.dart';"),
    const DocCode('''
AstryxSideNav(
  label: 'Sections',
  selectedId: _section,
  onSelected: (id) => setState(() => _section = id),
  entries: const <AstryxNavEntry>[
    AstryxNavItem(id: 'deploys', label: 'Deploys'),
    AstryxNavSection(
      label: 'Settings',
      items: <AstryxNavItem>[
        AstryxNavItem(id: 'members', label: 'Members'),
      ],
    ),
  ],
)'''),
    _sharedModel,
    const DocProse(
      'Upstream splits the rail into five components — `SideNav`, '
      '`SideNavSection`, `SideNavHeading`, `SideNavItem` and '
      '`SideNavCollapseButton`. Here the first is a widget, the next three are '
      'entries in a list, and the last appears on its own the moment you pass '
      '`onCollapsedChanged`: a button that does nothing has no reason to be '
      'drawn.',
    ),
    const DocHeading('Collapsed'),
    const DocCallout.accessibility(
      '**The labels leave the screen; they do not leave the semantics '
      'tree.** A collapsed row keeps its label as its accessible name and '
      'gains a '
      'tooltip that shows on **focus as well as hover**, so a keyboard user '
      'gets what a mouse user gets. This is the one place the widget set puts '
      'anything near a tooltip, and it is allowed only because the name is '
      'still announced and still reachable without a pointer — a rail that '
      'hides its labels behind hover alone works only for people who can '
      'hover.',
    ),
    const DocProse(
      'A section heading has nowhere to go in a 64px rail, so it becomes an '
      '`AstryxVisuallyHidden` name: the group is still announced, and the '
      'space is not spent on a word nobody can read.',
    ),
    const DocHeading('The footer stays put'),
    const DocProse(
      'The rows scroll and the footer does not, so a rail of forty '
      'destinations does not push the account row off the bottom of the '
      'window. `header` sits above the rows, with a rule under it — an '
      '[AstryxNavHeadingMenu](nav_heading_menu) is what usually goes there.',
    ),
    DocApi('AstryxSideNav', _sideNavProps),
    DocApi('AstryxNavItem', _navItemProps),
    DocApi('AstryxNavSection', _navSectionProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxAppShell](app_shell) — puts this beside the content, and moves '
          'it into a drawer when the window is narrow.',
      '[AstryxMobileNav](mobile_nav) — the same rows in a drawer of their own.',
      '[AstryxTopNav](top_nav) — the same entries as a bar.',
      '[AstryxTreeList](tree_list) — when the destinations are a hierarchy to '
          'explore rather than a set to choose from.',
    ]),
  ],
);

final List<DocProp> _sideNavProps = <DocProp>[
  const DocProp(
    'entries',
    'List<AstryxNavEntry>',
    'The destinations, sections and dividers, in order.',
    required: true,
  ),
  const DocProp('selectedId', 'String?', 'The id of the current destination.'),
  const DocProp(
    'onSelected',
    'ValueChanged<String>?',
    'Called with the id the user chose. Null leaves the rows inert.',
  ),
  const DocProp('header', 'Widget?', 'Content above the rows.'),
  const DocProp(
    'footer',
    'Widget?',
    'Content pinned below the rows, which does not scroll with them.',
  ),
  const DocProp(
    'collapsed',
    'bool',
    'Whether the rail shows its icons alone.',
    defaultValue: 'false',
  ),
  const DocProp(
    'onCollapsedChanged',
    'ValueChanged<bool>?',
    'Called when the collapse button is pressed. Null hides the button.',
  ),
  const DocProp('label', 'String?', 'The rail’s accessible name.'),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inset around the rows.',
    defaultValue: 'AstryxSpacingToken.spacing2',
  ),
  const DocProp(
    'density',
    'AstryxItemDensity',
    'The vertical rhythm the rows take.',
    defaultValue: 'AstryxItemDensity.compact',
  ),
];

final List<DocProp> _navItemProps = <DocProp>[
  const DocProp(
    'id',
    'String',
    'The destination’s identity — a route name, an enum’s name. What '
        '`selectedId` matches and `onSelected` reports.',
    required: true,
  ),
  const DocProp(
    'label',
    'String',
    'The visible text, and the row’s accessible name.',
    required: true,
  ),
  const DocProp(
    'icon',
    'Widget?',
    'An icon before the label. Wrap it in `AstryxNavIcon` for the slot every '
        'other row reserves.',
  ),
  const DocProp('trailing', 'Widget?', 'A count, a badge, a status dot.'),
  const DocProp(
    'description',
    'String?',
    'Secondary text below the label. Ignored by `AstryxTopNav`, which has one '
        'line to work with.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the destination can be chosen.',
    defaultValue: 'true',
  ),
  const DocProp(
    'children',
    'List<AstryxNavItem>',
    'Destinations under this one. A rail indents them; a bar puts them in a '
        'menu.',
    defaultValue: 'const <AstryxNavItem>[]',
  ),
  const DocProp(
    'panel',
    'Widget?',
    'A wide panel this row opens — upstream’s mega menu. An `AstryxTopNav` '
        'affordance; a rail has no width for one.',
  ),
];

final List<DocProp> _navSectionProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The heading over the group.',
    required: true,
  ),
  const DocProp(
    'items',
    'List<AstryxNavItem>',
    'The destinations in it.',
    defaultValue: 'const <AstryxNavItem>[]',
  ),
  const DocProp(
    'trailing',
    'Widget?',
    'Content at the trailing edge of the heading — a count, an add button.',
  ),
  const DocProp(
    'labelHidden',
    'bool',
    'Whether the heading is a name for a screen reader only.',
    defaultValue: 'false',
  ),
];

// -----------------------------------------------------------------------------
// AstryxTopNav
// -----------------------------------------------------------------------------

final DocPage _topNav = DocPage(
  id: 'top_nav',
  title: 'AstryxTopNav',
  group: _group,
  description:
      'A horizontal application bar, with menus and an optional mega menu.',
  source: 'lib/src/components/navigation/top_nav.dart',
  upstream:
      'TopNav / TopNavHeading / TopNavItem / TopNavMegaMenu / '
      'TopNavMegaMenuFeaturedCard / TopNavMegaMenuItem / TopNavMenu',
  upstreamPath: '/components/TopNav',
  blocks: <DocBlock>[
    const DocExample('top_nav_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxTopNav(
  leading: const Brand(),
  selectedId: _section,
  onSelected: (id) => setState(() => _section = id),
  actions: <Widget>[AccountMenu()],
  entries: const <AstryxNavEntry>[
    AstryxNavItem(id: 'deploys', label: 'Deploys'),
  ],
)'''),
    _sharedModel,
    const DocHeading('What a bar does differently'),
    const DocTable(
      headers: <String>['Entry', 'On a rail', 'On the bar'],
      rows: <List<String>>[
        <String>[
          '`AstryxNavItem` with `children`',
          'indented rows under their parent',
          'a menu the row opens',
        ],
        <String>[
          '`AstryxNavItem` with a `panel`',
          'ignored — a rail has no width for one',
          'the panel, as a popover under the bar',
        ],
        <String>[
          '`AstryxNavSection`',
          'a heading over its group',
          'a menu named after the group — a bar has no room for a heading, and '
              'a menu is exactly what holds one',
        ],
        <String>[
          '`AstryxNavDivider`',
          'a rule',
          'space between groups of destinations',
        ],
      ],
    ),
    const DocProse(
      'The destinations hug the leading edge and `actions` the trailing one, '
      'so adding a destination never moves the account menu. The destinations '
      'scroll sideways rather than wrapping — for a bar with genuinely more '
      'items than width, [AstryxOverflowList](overflow_list) moves the tail '
      'into a menu instead.',
    ),
    const DocCallout.note(
      'Upstream’s mega menu ships as four components — the menu, its items and '
      'a featured card. Here it is whatever widget you pass as `panel`: the '
      'panel’s contents are ordinary layout, and a card in it is an '
      '[AstryxCard](card).',
    ),
    DocApi('AstryxTopNav', _topNavProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxAppShell](app_shell) — whose `header` this usually is.',
      '[AstryxSideNav](side_nav) — the same entries as a rail.',
      '[AstryxTabList](tab_list) — for switching views *within* a page, which '
          'is not navigation.',
    ]),
  ],
);

final List<DocProp> _topNavProps = <DocProp>[
  const DocProp(
    'entries',
    'List<AstryxNavEntry>',
    'The destinations, in order.',
    required: true,
  ),
  const DocProp('selectedId', 'String?', 'The id of the current destination.'),
  const DocProp(
    'onSelected',
    'ValueChanged<String>?',
    'Called with the id the user chose.',
  ),
  const DocProp(
    'leading',
    'Widget?',
    'Content at the reading-start edge — a logo, a product name.',
  ),
  const DocProp(
    'actions',
    'List<Widget>',
    'Content at the reading-end edge — search, an account menu.',
    defaultValue: 'const <Widget>[]',
  ),
  const DocProp('label', 'String?', 'The bar’s accessible name.'),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inset around the bar’s contents.',
    defaultValue: 'AstryxSpacingToken.spacing3',
  ),
];

// -----------------------------------------------------------------------------
// AstryxMobileNav
// -----------------------------------------------------------------------------

final DocPage _mobileNav = DocPage(
  id: 'mobile_nav',
  title: 'AstryxMobileNav',
  group: _group,
  description:
      'The navigation drawer a narrow viewport gets instead of the '
      'rail.',
  source: 'lib/src/components/navigation/mobile_nav.dart',
  upstream: 'MobileNav / MobileNavToggle',
  upstreamPath: '/components/MobileNav',
  blocks: <DocBlock>[
    const DocExample('mobile_nav_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxMobileNav(
  controller: _nav,
  selectedId: _section,
  onSelected: (id) {
    setState(() => _section = id);
    _nav.hide();
  },
  entries: _entries,
)'''),
    const DocCallout.note(
      '**Inside an [AstryxAppShell](app_shell) you do not need this.** Give '
      'the shell an [AstryxSideNav](side_nav) as its `sidebar` and it moves '
      'that '
      'into a drawer itself when the window is narrow. Reach for this when '
      'there is no shell, or when the navigation lives somewhere the shell '
      'does not know about.',
    ),
    const DocProse(
      'The rows are drawn by the same code as the rail’s, so a drawer cannot '
      'drift from the navigation it stands in for.',
    ),
    const DocHeading('It is a real overlay'),
    const DocProse(
      'The `controller` is an `AstryxOverlayController`, and the drawer '
      'behaves like every other overlay in the package: focus is trapped in '
      'it, '
      'Escape and a press on the scrim close it, focus returns to the button '
      'that opened it, and it joins the same dismissal stack — so Escape '
      'closes the topmost thing rather than whatever was opened first.',
    ),
    const DocCallout.warning(
      '**Closing the drawer after a choice is yours to do.** A drawer that '
      'closed itself would take a mis-tap as a navigation; one that never '
      'closed would cover the page the user just asked for. The `onSelected` '
      'in the snippet above calls `hide` for that reason.',
    ),
    const DocHeading('The toggle'),
    const DocProse(
      '`AstryxMobileNavToggle` with no `controller` drives the drawer of the '
      'enclosing shell — the common case, and the one where wiring a '
      'controller by hand would mean two sources of truth for whether the '
      'navigation is open.',
    ),
    const DocCode('''
// In an AstryxAppShell's header:
if (AstryxAppShell.of(context).compact) const AstryxMobileNavToggle()'''),
    DocApi('AstryxMobileNav', _mobileNavProps),
    DocApi('AstryxMobileNavToggle', _toggleProps),
  ],
);

final List<DocProp> _mobileNavProps = <DocProp>[
  const DocProp(
    'controller',
    'AstryxOverlayController',
    'The open/closed state.',
    required: true,
  ),
  const DocProp(
    'entries',
    'List<AstryxNavEntry>',
    'The destinations, sections and dividers, in order.',
    required: true,
  ),
  const DocProp('selectedId', 'String?', 'The id of the current destination.'),
  const DocProp(
    'onSelected',
    'ValueChanged<String>?',
    'Called with the id the user chose. Closing the drawer is the caller’s.',
  ),
  const DocProp('header', 'Widget?', 'Content above the rows.'),
  const DocProp('footer', 'Widget?', 'Content pinned below the rows.'),
  const DocProp('label', 'String?', 'The drawer’s accessible name.'),
  const DocProp(
    'width',
    'double',
    'How wide the drawer is.',
    defaultValue: '280',
  ),
  const DocProp(
    'density',
    'AstryxItemDensity',
    'The vertical rhythm the rows take.',
    defaultValue: 'AstryxItemDensity.compact',
  ),
];

final List<DocProp> _toggleProps = <DocProp>[
  const DocProp(
    'controller',
    'AstryxOverlayController?',
    'The drawer to open. Null uses the enclosing shell’s.',
  ),
  const DocProp(
    'label',
    'String?',
    'Overrides the accessible name and the tooltip.',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize',
    'The button size.',
    defaultValue: 'AstryxButtonSize.md',
  ),
  const DocProp(
    'variant',
    'AstryxButtonVariant',
    'The button variant.',
    defaultValue: 'AstryxButtonVariant.ghost',
  ),
];

// -----------------------------------------------------------------------------
// AstryxNavHeadingMenu
// -----------------------------------------------------------------------------

final DocPage _navHeadingMenu = DocPage(
  id: 'nav_heading_menu',
  title: 'AstryxNavHeadingMenu',
  group: _group,
  description: 'A navigation heading that is itself a menu trigger.',
  source: 'lib/src/components/navigation/nav_heading_menu.dart',
  upstream: 'NavHeadingMenu',
  upstreamPath: '/components/NavHeadingMenu',
  blocks: <DocBlock>[
    const DocExample('side_nav_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxNavHeadingMenu(
  label: 'Acme Corp',
  description: 'Production',
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Globex', onSelected: () => switchTo('globex')),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'New workspace', onSelected: create),
  ],
)'''),
    const DocProse(
      'What a workspace or project switcher is: the name of the thing you are '
      'looking at, and the way to look at a different one. Upstream ships it '
      'as its own component because the two jobs are hard to combine by '
      'hand — a heading is not a button, and a button that looks like a '
      'heading usually stops being operable somewhere along the way.',
    ),
    const DocProse(
      'It goes in [AstryxSideNav](side_nav)’s `header`, and takes the rail’s '
      '`collapsed` flag: the label becomes the accessible name alone, and the '
      'chevron goes with it, because a chevron with nothing beside it is a '
      'button whose purpose has left.',
    ),
    const DocCallout.accessibility(
      'The row announces the label and the description as one name — "Acme '
      'Corp, Production" — because they are one fact about where the user is, '
      'and two nodes would make the reader assemble it.',
    ),
    DocApi('AstryxNavHeadingMenu', _headingMenuProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxNavSection](side_nav) — for a heading that only labels a group.',
      '[AstryxDropdownMenu](dropdown_menu) — the menu this opens.',
    ]),
  ],
);

final List<DocProp> _headingMenuProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The name of the thing being looked at.',
    required: true,
  ),
  const DocProp(
    'entries',
    'List<AstryxMenuEntry>',
    'The rows the menu shows.',
    required: true,
  ),
  const DocProp(
    'description',
    'String?',
    'Secondary text — the environment, the plan, the role.',
  ),
  const DocProp('leading', 'Widget?', 'A logo, an avatar.'),
  const DocProp(
    'collapsed',
    'bool',
    'Whether the enclosing rail is collapsed.',
    defaultValue: 'false',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the heading opens its menu.',
    defaultValue: 'true',
  ),
  const DocProp('menuLabel', 'String?', 'A name for the menu surface.'),
  const DocProp(
    'menuWidth',
    'double?',
    'A fixed width for the menu. Null matches the trigger.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxNavIcon
// -----------------------------------------------------------------------------

final DocPage _navIcon = DocPage(
  id: 'nav_icon',
  title: 'AstryxNavIcon',
  group: _group,
  description:
      'The icon slot in a navigation item, sized and aligned for the rail.',
  source: 'lib/src/components/navigation/nav_icon.dart',
  upstream: 'NavIcon',
  upstreamPath: '/components/NavIcon',
  blocks: <DocBlock>[
    const DocHeading('Usage'),
    const DocCode('''
AstryxNavItem(
  id: 'deploys',
  label: 'Deploys',
  icon: const AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
)'''),
    const DocProse(
      '**The square is the point, not the icon.** Every row reserves the same '
      'slot, so labels line up whether or not their neighbours have icons, and '
      'a rail that collapses to icons alone keeps them on one axis instead of '
      'shuffling as the labels go. An icon dropped straight into a row gets '
      'neither.',
    ),
    const DocProse(
      'It also carries the row’s state, which is why it is a widget rather '
      'than a size: the glyph takes `--color-icon-accent` when the row is the '
      'current destination and dims when the row is disabled.',
    ),
    const DocExample('side_nav_demo', align: DocExampleAlign.stretch),
    DocApi('AstryxNavIcon', _navIconProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxIcon](icon) — the glyph itself, and the registry it comes from.',
      '[AstryxSideNav](side_nav) — where this belongs.',
    ]),
  ],
);

final List<DocProp> _navIconProps = <DocProp>[
  const DocProp(
    'icon',
    'Widget',
    'The glyph. The positional first argument; size and colour come from the '
        'slot.',
    required: true,
  ),
  const DocProp(
    'selected',
    'bool',
    'Whether the row this belongs to is the current destination.',
    defaultValue: 'false',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the row accepts input.',
    defaultValue: 'true',
  ),
  const DocProp(
    'size',
    'AstryxIconSize',
    'How large the glyph is drawn. The slot is sized from it.',
    defaultValue: 'AstryxIconSize.md',
  ),
];

// -----------------------------------------------------------------------------
// AstryxBreadcrumbs
// -----------------------------------------------------------------------------

final DocPage _breadcrumbs = DocPage(
  id: 'breadcrumbs',
  title: 'AstryxBreadcrumbs',
  group: _group,
  description:
      'The trail back up a hierarchy, collapsing in the middle when it will '
      'not fit.',
  source: 'lib/src/components/navigation/breadcrumbs.dart',
  upstream: 'Breadcrumbs / BreadcrumbItem',
  upstreamPath: '/components/Breadcrumbs',
  blocks: <DocBlock>[
    const DocExample('breadcrumbs_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxBreadcrumbs(
  items: <AstryxBreadcrumb>[
    AstryxBreadcrumb(label: 'Projects', onPressed: () => go('/')),
    AstryxBreadcrumb(label: 'astryx_ui', onPressed: () => go('/astryx')),
    const AstryxBreadcrumb(label: 'Deploy #412'),
  ],
)'''),
    const DocHeading('It collapses in the middle'),
    const DocProse(
      '**Never at the ends.** The first step is the way out to the top and the '
      'last is where the user is; dropping either to save room throws away the '
      'two the trail exists for. What is dropped goes into a menu where it '
      'was, so it stays reachable — the same bargain '
      '[AstryxOverflowList](overflow_list) makes with the tail of a row.',
    ),
    const DocProse(
      'The row is measured, not guessed, so the answer is right at every '
      'width. The count settles for the same reason the overflow list’s does: '
      'hiding more steps never widens the trigger past what hiding fewer would '
      'need, so it converges within a frame or two of a resize.',
    ),
    const DocHeading('The last step is not a link'),
    const DocProse(
      'A step with no `onPressed` is a label rather than a link. The step the '
      'reader is on is the one they cannot go to — offering it is how a trail '
      'stops telling the user where they are — so it takes the primary text '
      'colour and no button.',
    ),
    const DocCallout.accessibility(
      'The separators are decoration and stay out of the semantics tree: a '
      'screen reader gets the trail’s structure from its nodes, not from a '
      'chevron read aloud between every pair. The collapsed-steps trigger is '
      'named for what it does — "Show 3 hidden steps" — because "…" spoken '
      'aloud is not an offer anybody can act on.',
    ),
    DocApi('AstryxBreadcrumbs', _breadcrumbsProps),
    DocApi('AstryxBreadcrumb', _crumbProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxLayout](layout) — a trail usually sits in its `header`.',
      '[AstryxOverflowList](overflow_list) — the same trick for a row of '
          'anything.',
    ]),
  ],
);

final List<DocProp> _breadcrumbsProps = <DocProp>[
  const DocProp(
    'items',
    'List<AstryxBreadcrumb>',
    'The steps, from the top of the hierarchy to where the reader is.',
    required: true,
  ),
  const DocProp('label', 'String?', 'The trail’s accessible name.'),
  const DocProp(
    'separator',
    'Widget?',
    'What goes between two steps. Defaults to a chevron, mirrored under RTL.',
  ),
];

final List<DocProp> _crumbProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The name of this level.',
    required: true,
  ),
  const DocProp(
    'onPressed',
    'VoidCallback?',
    'Goes there. Null makes the step a label rather than a link.',
  ),
  const DocProp('icon', 'Widget?', 'An icon before the label.'),
];

// -----------------------------------------------------------------------------
// AstryxLink
// -----------------------------------------------------------------------------

final DocPage _link = DocPage(
  id: 'link',
  title: 'AstryxLink',
  group: _group,
  description:
      'Inline navigation in running text, with the visited and external '
      'affordances.',
  source: 'lib/src/components/navigation/link.dart',
  upstream: 'Link',
  upstreamPath: '/components/Link',
  blocks: <DocBlock>[
    const DocExample('link_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode("AstryxLink('Read the guide', onPressed: open)"),
    const DocHeading('Inside a sentence'),
    const DocProse(
      'Flutter has no inline element, so a widget cannot sit inside a string — '
      'the same wall [AstryxCode](code) runs into. `AstryxLink.span` is the '
      'bridge: a `WidgetSpan` aligned to the text baseline, for `Text.rich`.',
    ),
    const DocCode('''
Text.rich(
  TextSpan(
    children: <InlineSpan>[
      const TextSpan(text: 'See the '),
      AstryxLink.span('installation guide', onPressed: open),
      const TextSpan(text: ' to begin.'),
    ],
  ),
)'''),
    const DocHeading('Where it goes'),
    const DocProse(
      'Navigation is the application’s concern, so an `href` is handed to the '
      '`AstryxLinkDelegate` and this package never decides what following '
      'means. An `onPressed` is called directly. A link with both does both — '
      'the callback is yours, the delegate is your router’s.',
    ),
    const DocCallout.accessibility(
      'An external link says so **in its accessible name**, not only in its '
      'glyph: the user who cannot see the glyph is exactly the one most '
      'disrupted by a window they did not expect. The underline is on by '
      'default for the same kind of reason — in running text, colour alone is '
      'the only thing telling a link from an emphasised word, and for a '
      'colour-blind reader it tells them nothing.',
    ),
    const DocCallout.note(
      '`visited` is yours to track. A browser knows a link’s history and '
      'Flutter does not, so there is nothing here to read it from — pass it if '
      'your application keeps the answer, and leave it alone if it does not.',
    ),
    DocApi('AstryxLink', _linkProps),
    DocApi('AstryxLinkUnderline', _underlineProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxButton](button) — for an action. A link goes somewhere; a button '
          'does something, and the two are different promises.',
      '[AstryxCode](code) — the other widget with a `span`.',
    ]),
  ],
);

final List<DocProp> _linkProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The text. The positional first argument.',
    required: true,
  ),
  const DocProp('onPressed', 'VoidCallback?', 'Called when it is followed.'),
  const DocProp('href', 'Uri?', 'A destination for the `AstryxLinkDelegate`.'),
  const DocProp(
    'external',
    'bool',
    'Whether following it leaves the application. Adds the glyph *and* the '
        'announcement.',
    defaultValue: 'false',
  ),
  const DocProp(
    'visited',
    'bool',
    'Whether it has been followed. Yours to track.',
    defaultValue: 'false',
  ),
  const DocProp(
    'underline',
    'AstryxLinkUnderline',
    'When the underline is drawn.',
    defaultValue: 'AstryxLinkUnderline.always',
  ),
  const DocProp(
    'type',
    'AstryxTextType',
    'The type role the text takes, so a link matches the copy around it.',
    defaultValue: 'AstryxTextType.body',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether it can be followed.',
    defaultValue: 'true',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'Overrides what a screen reader announces.',
  ),
  const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
];

final List<DocProp> _underlineProps = <DocProp>[
  const DocProp(
    'always',
    'AstryxLinkUnderline',
    'The default, and what running text needs.',
  ),
  const DocProp(
    'hover',
    'AstryxLinkUnderline',
    'On hover and focus only, for a link that is obviously one from its '
        'position — a row in a list, a name in a cell.',
  ),
  const DocProp(
    'never',
    'AstryxLinkUnderline',
    'For a link inside something already visibly interactive.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxSegmentedControl
// -----------------------------------------------------------------------------

final DocPage _segmentedControl = DocPage(
  id: 'segmented_control',
  title: 'AstryxSegmentedControl',
  group: _group,
  description:
      'A small set of mutually exclusive views, all labels visible at once.',
  source: 'lib/src/components/navigation/segmented_control.dart',
  upstream: 'SegmentedControl / SegmentedControlItem',
  upstreamPath: '/components/SegmentedControl',
  blocks: <DocBlock>[
    const DocExample('segmented_control_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxSegmentedControl<Range>(
  label: 'Range',
  value: _range,
  onChanged: (range) => setState(() => _range = range),
  segments: const <AstryxSegment<Range>>[
    AstryxSegment(value: Range.day, label: 'Day'),
    AstryxSegment(value: Range.week, label: 'Week'),
  ],
)'''),
    const DocHeading('Which of the four this is'),
    const DocTable(
      headers: <String>['Use', 'When'],
      rows: <List<String>>[
        <String>[
          '`AstryxSegmentedControl`',
          'One choice out of a few — a range, a filter, a density. Announced '
              'as a radio group.',
        ],
        <String>[
          '[AstryxTabList](tab_list)',
          'Switching what a page *shows*, at the top of the thing it '
              'switches. Announced as tabs.',
        ],
        <String>[
          '[AstryxToggleButtonGroup](toggle_button)',
          'Settings that happen to sit together. Announced as pressed or not.',
        ],
        <String>[
          '[AstryxRadioList](radio_list)',
          'The same choice with more than about five options, or labels longer '
              'than a word or two.',
        ],
      ],
    ),
    const DocCallout.accessibility(
      '**Keyboarded as an ARIA radiogroup**: one tab stop, the arrows move '
      '*and choose*, and they wrap at both ends so nobody has to reverse out '
      'of the end. Both axes work, because a user who does not know which way '
      'the control runs will try either, and the inline arrows mirror under '
      'RTL.',
    ),
    const DocProse(
      '`labelHidden` gives an icon-only segment — a list-or-grid switch — its '
      'name without painting it. It needs an `icon`: a segment with neither is '
      'a segment nobody can see.',
    ),
    DocApi('AstryxSegmentedControl', _segmentedProps),
    DocApi('AstryxSegment', _segmentProps),
  ],
);

final List<DocProp> _segmentedProps = <DocProp>[
  const DocProp(
    'segments',
    'List<AstryxSegment<T>>',
    'The choices, in the order they are shown and traversed.',
    required: true,
  ),
  const DocProp('value', 'T?', 'The chosen value.', required: true),
  const DocProp(
    'onChanged',
    'ValueChanged<T>?',
    'Called with the newly chosen value. Null makes the control read-only.',
  ),
  const DocProp('label', 'String?', 'The control’s accessible name.'),
  const DocProp(
    'size',
    'AstryxButtonSize',
    'The control’s size.',
    defaultValue: 'AstryxButtonSize.md',
  ),
  const DocProp(
    'expand',
    'bool',
    'Whether the segments share the width equally. False hugs the labels.',
    defaultValue: 'false',
  ),
  const DocProp('focusNode', 'FocusNode?', 'The focus node for the control.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _segmentProps = <DocProp>[
  const DocProp(
    'value',
    'T',
    'What choosing this segment produces.',
    required: true,
  ),
  const DocProp(
    'label',
    'String',
    'The visible text, and this segment’s accessible name.',
    required: true,
  ),
  const DocProp('icon', 'Widget?', 'An icon before the label.'),
  const DocProp(
    'enabled',
    'bool',
    'Whether this segment can be chosen.',
    defaultValue: 'true',
  ),
  const DocProp(
    'labelHidden',
    'bool',
    'Whether the label is a name for a screen reader only. Requires `icon`.',
    defaultValue: 'false',
  ),
];

// -----------------------------------------------------------------------------
// AstryxToolbar
// -----------------------------------------------------------------------------

final DocPage _toolbar = DocPage(
  id: 'toolbar',
  title: 'AstryxToolbar',
  group: _group,
  description:
      'A horizontal band of controls, with arrow-key traversal as one tab '
      'stop.',
  source: 'lib/src/components/navigation/toolbar.dart',
  upstream: 'Toolbar',
  upstreamPath: '/components/Toolbar',
  blocks: <DocBlock>[
    const DocExample('toolbar_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxToolbar(
  label: 'Formatting',
  children: <Widget>[
    AstryxToggleButton(label: 'Bold', pressed: bold, onChanged: setBold),
    const AstryxToolbarDivider(),
    AstryxMoreMenu(entries: more),
  ],
)'''),
    const DocHeading('One tab stop'),
    const DocProse(
      '**Tab reaches the toolbar, not each button in it.** A formatting bar of '
      'twelve buttons is twelve presses to walk past otherwise, which is why '
      'the ARIA toolbar pattern exists. Inside, the arrows move between the '
      'controls and wrap; Home and End go to the ends.',
    ),
    const DocProse(
      'The children stay ordinary, traversable widgets — that is how Tab '
      '*enters* on the first one. What makes the band a single stop is that '
      'Tab pressed **inside** it leaves instead of walking on: the toolbar '
      'steps focus to its edge and lets Flutter’s own traversal carry past. '
      'Nothing is asked of the children, so anything focusable can go in.',
    ),
    const DocCallout.note(
      '`AstryxToolbarDivider` is its own widget because a bare '
      '[AstryxDivider](divider) in a row has no height to take, and because a '
      'rule between groups of controls is a thing worth naming.',
    ),
    DocApi('AstryxToolbar', _toolbarProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxMoreMenu](more_menu) — for the tail that will not fit.',
      '[AstryxOverflowList](overflow_list) — which measures the row and '
          'decides what that tail is.',
      '[AstryxButtonGroup](button_group) — buttons joined into one visual '
          'control, which is a different thing: a group is *drawn* together, a '
          'toolbar is *operated* together.',
    ]),
  ],
);

final List<DocProp> _toolbarProps = <DocProp>[
  const DocProp(
    'children',
    'List<Widget>',
    'The controls, in the order they are traversed.',
    required: true,
  ),
  const DocProp('label', 'String?', 'The toolbar’s accessible name.'),
  const DocProp(
    'gap',
    'AstryxSpacingToken',
    'The space between controls.',
    defaultValue: 'AstryxSpacingToken.spacing1',
  ),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inset around them.',
    defaultValue: 'AstryxSpacingToken.spacing1',
  ),
];

// -----------------------------------------------------------------------------
// AstryxMoreMenu
// -----------------------------------------------------------------------------

final DocPage _moreMenu = DocPage(
  id: 'more_menu',
  title: 'AstryxMoreMenu',
  group: _group,
  description: 'The overflow menu a toolbar or nav collapses its tail into.',
  source: 'lib/src/components/navigation/more_menu.dart',
  upstream: 'MoreMenu',
  upstreamPath: '/components/MoreMenu',
  blocks: <DocBlock>[
    const DocExample('toolbar_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxMoreMenu(
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: remove),
  ],
)'''),
    const DocProse(
      'One widget rather than an [AstryxIconButton](icon_button) plus an '
      '[AstryxDropdownMenu](dropdown_menu) written out at every call site — '
      'which is what a toolbar, a navigation and a table row each need at '
      'their end, and which is exactly the composition people get subtly '
      'wrong: an unnamed trigger, or one that opens a menu with no name of its '
      'own.',
    ),
    const DocCallout.accessibility(
      '`label` is the trigger’s name, its tooltip **and** the menu’s name — '
      'one string, because they are one answer to one question: what is behind '
      'this button? [AstryxBreadcrumbs](breadcrumbs) uses this widget for its '
      'collapsed steps, which is why that trigger is named "Show 3 hidden '
      'steps" rather than "…".',
    ),
    DocApi('AstryxMoreMenu', _moreMenuProps),
  ],
);

final List<DocProp> _moreMenuProps = <DocProp>[
  const DocProp(
    'entries',
    'List<AstryxMenuEntry>',
    'The rows, in order.',
    required: true,
  ),
  const DocProp(
    'label',
    'String?',
    'The trigger’s name, its tooltip, and the menu’s name.',
  ),
  const DocProp(
    'icon',
    'AstryxIconName',
    'The glyph on the trigger.',
    defaultValue: 'AstryxIconName.moreHorizontal',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize',
    'The trigger’s size.',
    defaultValue: 'AstryxButtonSize.sm',
  ),
  const DocProp(
    'variant',
    'AstryxButtonVariant',
    'The trigger’s variant.',
    defaultValue: 'AstryxButtonVariant.ghost',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the menu opens.',
    defaultValue: 'true',
  ),
  const DocProp(
    'controller',
    'AstryxOverlayController?',
    'Drives the menu from outside.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxTabMenu
// -----------------------------------------------------------------------------

final DocPage _tabMenu = DocPage(
  id: 'tab_menu',
  title: 'AstryxTabMenu',
  group: _group,
  description:
      'A tab whose selection opens a menu rather than switching a '
      'panel.',
  source: 'lib/src/components/navigation/tab_menu.dart',
  upstream: 'TabMenu',
  upstreamPath: '/components/TabMenu',
  blocks: <DocBlock>[
    const DocExample('tab_menu_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxTabMenu(
  label: 'Reports',
  selected: view.isReport,
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Usage', onSelected: () => select(usage)),
  ],
)'''),
    const DocProse(
      'For the strip where most tabs are views and one is a *set* of them — '
      '"More reports", a saved-view picker, the tail of a strip too long for '
      'the bar. It sits beside an [AstryxTabList](tab_list) and is drawn to '
      'match, indicator and all, so a reader looking at a report still sees '
      'something in the strip claiming it.',
    ),
    const DocCallout.accessibility(
      'It announces itself as a **menu button**, not a tab. Telling a '
      'screen-reader user this is a tab and then opening a menu is a promise '
      'the widget cannot keep — `selected` still reports which entry the page '
      'came from.',
    ),
    DocApi('AstryxTabMenu', _tabMenuProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxTabList](tab_list) — the tabs that do switch a panel.',
      '[AstryxMoreMenu](more_menu) — when it does not need to look like a tab.',
    ]),
  ],
);

final List<DocProp> _tabMenuProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The visible text, and the trigger’s accessible name.',
    required: true,
  ),
  const DocProp(
    'entries',
    'List<AstryxMenuEntry>',
    'The rows the menu shows.',
    required: true,
  ),
  const DocProp('icon', 'Widget?', 'An icon before the label.'),
  const DocProp(
    'selected',
    'bool',
    'Whether the view currently showing came from this menu. Draws the tab’s '
        'indicator.',
    defaultValue: 'false',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the menu opens.',
    defaultValue: 'true',
  ),
  const DocProp('menuLabel', 'String?', 'A name for the menu surface.'),
  const DocProp(
    'controller',
    'AstryxOverlayController?',
    'Drives the menu from outside.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxPagination
// -----------------------------------------------------------------------------

final DocPage _pagination = DocPage(
  id: 'pagination',
  title: 'AstryxPagination',
  group: _group,
  description:
      'Page-at-a-time controls for a list or table too long to '
      'scroll.',
  source: 'lib/src/components/navigation/pagination.dart',
  upstream: 'Pagination',
  upstreamPath: '/components/Pagination',
  blocks: <DocBlock>[
    const DocExample('pagination_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxPagination(
  page: _page,
  pageCount: (total / pageSize).ceil(),
  onPageChanged: (page) => setState(() => _page = page),
)'''),
    const DocCallout.warning(
      '**Pages are one-based**, as they are to the person reading them: "page '
      '1 of 20" is what the control says, so it is what the control counts in. '
      'An off-by-one here is an off-by-one the user sees.',
    ),
    const DocHeading('What it shows'),
    const DocProse(
      'The first and last pages, `siblings` on each side of the current one, '
      'and a gap where the rest were left out. The ends are the two a reader '
      'jumps to most and the two that say how much there is — a trail of '
      'numbers with no end in sight says less than "… 20".',
    ),
    const DocProse(
      'The gap is not a button: it stands for a range rather than a page, and '
      'a control that cannot say where it would take you is not worth '
      'offering. A gap of exactly one page is drawn as the page instead, '
      'because "1 … 3" hides nothing and costs a press.',
    ),
    const DocProse(
      '`AstryxPagination.pagesFor` is that arithmetic on its own, static and '
      'pure — so what a reader sees can be read, and tested, without a widget '
      'tree.',
    ),
    const DocCallout.accessibility(
      'The arrows **disable at the ends rather than disappearing**: a control '
      'that vanishes moves everything beside it, and the reader loses their '
      'place in a row they were about to press again. The whole control '
      'announces "Page 3 of 20", so someone landing on it is told where they '
      'are before they hear a single number.',
    ),
    DocApi('AstryxPagination', _paginationProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxTable](table) — which does not virtualise; this is how a long '
          'one is made readable.',
      '[AstryxList](list) — same limit, same answer.',
    ]),
  ],
);

final List<DocProp> _paginationProps = <DocProp>[
  const DocProp(
    'page',
    'int',
    'The current page, from 1 to `pageCount`.',
    required: true,
  ),
  const DocProp(
    'pageCount',
    'int',
    'How many pages there are.',
    required: true,
  ),
  const DocProp(
    'onPageChanged',
    'ValueChanged<int>?',
    'Called with the page the user chose. Null makes the control read-only.',
  ),
  const DocProp(
    'siblings',
    'int',
    'How many page numbers to show each side of the current one.',
    defaultValue: '1',
  ),
  const DocProp(
    'showEdges',
    'bool',
    'Whether the first and last pages are always shown.',
    defaultValue: 'true',
  ),
  const DocProp('label', 'String?', 'The control’s accessible name.'),
];
