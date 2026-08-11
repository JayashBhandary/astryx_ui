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
