import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// The destinations every example on this page shares.
const List<AstryxNavEntry> _entries = <AstryxNavEntry>[
  AstryxNavItem(
    id: 'deploys',
    label: 'Deploys',
    icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
    trailing: AstryxBadge('3'),
  ),
  AstryxNavItem(
    id: 'environments',
    label: 'Environments',
    icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
  ),
  AstryxNavDivider(),
  AstryxNavSection(
    label: 'Settings',
    items: <AstryxNavItem>[
      AstryxNavItem(
        id: 'members',
        label: 'Members',
        icon: AstryxNavIcon(AstryxIcon(AstryxIconName.check)),
      ),
      AstryxNavItem(
        id: 'billing',
        label: 'Billing',
        icon: AstryxNavIcon(AstryxIcon(AstryxIconName.clock)),
        enabled: false,
      ),
    ],
  ),
];

// #example side_nav_demo -> SideNavDemoExample
class SideNavDemoExample extends StatefulWidget {
  const SideNavDemoExample({super.key});

  @override
  State<SideNavDemoExample> createState() => _SideNavDemoExampleState();
}

class _SideNavDemoExampleState extends State<SideNavDemoExample> {
  String _section = 'deploys';
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    // Collapse it and the labels leave the screen but not the semantics tree:
    // each row keeps its name and gains a tooltip that shows on focus as well
    // as hover, so a keyboard user gets what a mouse user gets.
    return SizedBox(
      height: 420,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: _collapsed ? 64 : 240,
            child: AstryxSideNav(
              label: 'Sections',
              entries: _entries,
              selectedId: _section,
              onSelected: (id) => setState(() => _section = id),
              collapsed: _collapsed,
              onCollapsedChanged: (value) => setState(() => _collapsed = value),
              header: AstryxNavHeadingMenu(
                label: 'Acme Corp',
                description: 'Production',
                collapsed: _collapsed,
                leading: const AstryxNavIcon(
                  AstryxIcon(AstryxIconName.viewColumns),
                ),
                entries: <AstryxMenuEntry>[
                  AstryxMenuItem(label: 'Acme Corp', onSelected: () {}),
                  AstryxMenuItem(label: 'Globex', onSelected: () {}),
                  const AstryxMenuDivider(),
                  AstryxMenuItem(label: 'New workspace', onSelected: () {}),
                ],
              ),
            ),
          ),
          const AstryxDivider(axis: Axis.vertical),
          Expanded(
            child: AstryxCenter(child: AstryxHeading(_section)),
          ),
        ],
      ),
    );
  }
}
// #end

// #example top_nav_demo -> TopNavDemoExample
class TopNavDemoExample extends StatefulWidget {
  const TopNavDemoExample({super.key});

  @override
  State<TopNavDemoExample> createState() => _TopNavDemoExampleState();
}

class _TopNavDemoExampleState extends State<TopNavDemoExample> {
  String _section = 'deploys';

  @override
  Widget build(BuildContext context) {
    // The same entries as the rail, laid along a row. A section becomes a menu
    // — a bar has no room for a heading over a group, but a menu is exactly
    // what holds one — and an item with a `panel` opens the mega menu.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTopNav(
          leading: const AstryxText('Acme', type: AstryxTextType.label),
          entries: <AstryxNavEntry>[
            ..._entries,
            AstryxNavItem(
              id: 'docs',
              label: 'Docs',
              panel: AstryxCard(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    const AstryxHeading('Guides', level: 3),
                    AstryxItem(label: 'Getting started', onPressed: () {}),
                    AstryxItem(label: 'Theming', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.search,
              label: 'Search',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
            AstryxButton(
              label: 'Account',
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        const AstryxDivider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AstryxText('Showing $_section'),
        ),
      ],
    );
  }
}
// #end

// #example mobile_nav_demo -> MobileNavDemoExample
class MobileNavDemoExample extends StatefulWidget {
  const MobileNavDemoExample({super.key});

  @override
  State<MobileNavDemoExample> createState() => _MobileNavDemoExampleState();
}

class _MobileNavDemoExampleState extends State<MobileNavDemoExample> {
  final AstryxOverlayController _nav = AstryxOverlayController();
  String _section = 'deploys';

  @override
  void dispose() {
    _nav.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The drawer is a real overlay: it traps focus, closes on Escape or a
    // press on the scrim, and hands focus back to the button that opened it.
    // Closing it after a choice is the caller's, which is why `onSelected`
    // hides it here.
    return SizedBox(
      height: 260,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxMobileNavToggle(
                controller: _nav,
                size: AstryxButtonSize.sm,
              ),
              AstryxText('Showing $_section'),
            ],
          ),
          AstryxMobileNav(
            controller: _nav,
            entries: _entries,
            selectedId: _section,
            onSelected: (id) {
              setState(() => _section = id);
              _nav.hide();
            },
          ),
        ],
      ),
    );
  }
}
// #end

// #example breadcrumbs_demo -> BreadcrumbsDemoExample
class BreadcrumbsDemoExample extends StatelessWidget {
  const BreadcrumbsDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final trail = <AstryxBreadcrumb>[
      AstryxBreadcrumb(label: 'Projects', onPressed: () {}),
      AstryxBreadcrumb(label: 'astryx_ui', onPressed: () {}),
      AstryxBreadcrumb(label: 'Environments', onPressed: () {}),
      AstryxBreadcrumb(label: 'production', onPressed: () {}),
      const AstryxBreadcrumb(label: 'Deploy #412'),
    ];

    // The same trail at three widths. It collapses in the middle, never at the
    // ends: the first step is the way out to the top and the last is where the
    // reader is.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final width in const <double>[560, 380, 240])
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxText(
                '${width.toInt()} px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              SizedBox(
                width: width,
                child: AstryxBreadcrumbs(items: trail),
              ),
            ],
          ),
      ],
    );
  }
}

// #end
