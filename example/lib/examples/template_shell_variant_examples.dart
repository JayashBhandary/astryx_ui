/// The shell with one bar instead of two.
///
/// `template_shell_examples.dart` puts a bar *and* a rail around the content.
/// Most applications need only one of them, and which one is a decision about
/// how many destinations there are — not a decision about taste. These are the
/// two halves, each with the part the other one was carrying moved somewhere it
/// still fits.
///
/// Neither is exported. Both are compositions worth copying, built from nothing
/// but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_shell_side_nav -> ShellSideNavTemplate
class ShellSideNavTemplate extends StatefulWidget {
  const ShellSideNavTemplate({super.key});

  @override
  State<ShellSideNavTemplate> createState() => _ShellSideNavTemplateState();
}

class _ShellSideNavTemplateState extends State<ShellSideNavTemplate> {
  /// Every destination in the product, down one column.
  ///
  /// A rail is the right container when the list is long enough to need
  /// headings, or deep enough to need indenting — both of which a bar has no
  /// room for. `children` here are indented rows; on an `AstryxTopNav` the same
  /// list would be a menu.
  static const List<AstryxNavEntry> _entries = <AstryxNavEntry>[
    AstryxNavItem(
      id: 'overview',
      label: 'Overview',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
    ),
    AstryxNavItem(
      id: 'runs',
      label: 'Runs',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
      trailing: AstryxBadge('12'),
      children: <AstryxNavItem>[
        AstryxNavItem(id: 'runs_queued', label: 'Queued'),
        AstryxNavItem(id: 'runs_failed', label: 'Failed'),
      ],
    ),
    AstryxNavItem(
      id: 'artifacts',
      label: 'Artifacts',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.copy)),
    ),
    AstryxNavDivider(),
    AstryxNavSection(
      label: 'Configuration',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'triggers',
          label: 'Triggers',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.clock)),
        ),
        AstryxNavItem(
          id: 'secrets',
          label: 'Secrets',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.eyeSlash)),
        ),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'overview': 'Overview',
    'runs': 'Runs',
    'runs_queued': 'Queued runs',
    'runs_failed': 'Failed runs',
    'artifacts': 'Artifacts',
    'triggers': 'Triggers',
    'secrets': 'Secrets',
  };

  String _section = 'runs';
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final title = _titles[_section]!;

    // No `header:` on the shell at all. Everything a bar would have carried is
    // in the rail — identity at the top, the account at the bottom — because a
    // full-width band holding only a logo is a band spent on nothing.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 680,
        navLabel: 'Sections',
        sidebarWidth: _collapsed ? 72 : 244,
        sidebar: AstryxSideNav(
          label: 'Sections',
          entries: _entries,
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          collapsed: _collapsed,
          onCollapsedChanged: (value) => setState(() => _collapsed = value),
          header: AstryxNavHeadingMenu(
            label: 'Foundry',
            description: 'acme/platform',
            collapsed: _collapsed,
            leading: const AstryxNavIcon(AstryxIcon(AstryxIconName.wrench)),
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'acme/platform', onSelected: () {}),
              AstryxMenuItem(label: 'acme/website', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(label: 'New project', onSelected: () {}),
            ],
          ),
          footer: AstryxItem(
            label: 'Grace Hopper',
            description: _collapsed ? null : 'grace@acme.example',
            leading: const AstryxAvatar(
              name: 'Grace Hopper',
              size: AstryxAvatarSize.sm,
            ),
            onPressed: () {},
          ),
        ),
        child: AstryxLayout(
          header: _PageHeader(title: title),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'One bar, and it is vertical. Collapse the rail with the '
                'control below the account row, or narrow the window past 680 '
                'logical pixels to send it behind the drawer the menu button '
                'in this page header opens.',
              ),
              for (var i = 0; i < 7; i++)
                AstryxCard(
                  padding: AstryxSpacingToken.spacing3,
                  child: AstryxHStack(
                    gap: AstryxSpacingToken.spacing3,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: AstryxText(
                          '$title · job ${920 - i}',
                          maxLines: 1,
                        ),
                      ),
                      AstryxBadge(
                        i.isEven ? 'Passed' : 'Queued',
                        variant: i.isEven
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.neutral,
                        icon: AstryxIcon(
                          i.isEven
                              ? AstryxIconName.success
                              : AstryxIconName.clock,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The page's own header — which is where the drawer toggle has to live when
/// the shell has no header of its own.
class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // `AstryxMobileNavToggle` with no `controller` reaches for the enclosing
    // shell's, so this row does not have to know that a drawer exists — only
    // that the shell is compact, which is the shell's answer to give.
    final shell = AstryxAppShell.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (shell.compact)
                const AstryxMobileNavToggle(
                  label: 'Open navigation',
                  size: AstryxButtonSize.sm,
                ),
              Flexible(child: AstryxHeading(title, level: 1)),
            ],
          ),
        ),
        AstryxButton(
          label: 'Run pipeline',
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end

// #example template_shell_top_nav -> ShellTopNavTemplate
class ShellTopNavTemplate extends StatefulWidget {
  const ShellTopNavTemplate({super.key});

  @override
  State<ShellTopNavTemplate> createState() => _ShellTopNavTemplateState();
}

class _ShellTopNavTemplateState extends State<ShellTopNavTemplate> {
  /// The same entry type as the rail, laid along a row.
  ///
  /// A section becomes a *menu* here rather than a heading: a bar has no room
  /// for a label over a group, and a menu is exactly what holds one.
  static const List<AstryxNavEntry> _entries = <AstryxNavEntry>[
    AstryxNavItem(id: 'inbox', label: 'Inbox', trailing: AstryxBadge('4')),
    AstryxNavItem(id: 'reports', label: 'Reports'),
    AstryxNavSection(
      label: 'Admin',
      items: <AstryxNavItem>[
        AstryxNavItem(id: 'members', label: 'Members'),
        AstryxNavItem(id: 'audit', label: 'Audit log'),
        AstryxNavItem(id: 'billing', label: 'Billing'),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'inbox': 'Inbox',
    'reports': 'Reports',
    'members': 'Members',
    'audit': 'Audit log',
    'billing': 'Billing',
  };

  String _section = 'inbox';

  @override
  Widget build(BuildContext context) {
    final title = _titles[_section] ?? 'Inbox';

    // No `sidebar:`, so there is no drawer and `compactBelow` has nothing to
    // do — the bar scrolls its own destinations sideways when the window is
    // too narrow for them, and the actions stay pinned at the trailing edge.
    return SizedBox(
      height: 480,
      child: AstryxAppShell(
        header: AstryxTopNav(
          label: 'Areas',
          leading: const AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxNavIcon(AstryxIcon(AstryxIconName.checkDouble)),
              AstryxText('Ledger', type: AstryxTextType.label),
            ],
          ),
          entries: _entries,
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.search,
              label: 'Search',
              tooltip: 'Search',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
            AstryxDropdownMenu(
              label: 'Account',
              width: 220,
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('grace@acme.example'),
                AstryxMenuItem(label: 'Preferences', onSelected: () {}),
                AstryxMenuItem(label: 'Sign out', onSelected: () {}),
              ],
              triggerBuilder: (context, controller) => AstryxAvatar(
                name: 'Grace Hopper',
                size: AstryxAvatarSize.sm,
                semanticsLabel: 'Account — Grace Hopper',
                onPressed: controller.toggle,
              ),
            ),
          ],
        ),
        child: AstryxLayout(
          maxContentWidth: 900,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(child: AstryxHeading(title, level: 1)),
              AstryxButton(
                label: 'New entry',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'Five destinations and no rail. Narrow the window and the bar '
                'scrolls its destinations rather than dropping them: nothing '
                'moves behind a drawer, because there is no drawer to move it '
                'into.',
              ),
              // A second level of navigation, inside the page rather than
              // beside it. This is the affordance a rail would have carried,
              // and it is a tab strip because these are views of one thing
              // rather than places in the product.
              AstryxTabList<String>(
                label: '$title views',
                value: 'open',
                onChanged: (_) {},
                tabs: const <AstryxTab<String>>[
                  AstryxTab(value: 'open', label: 'Open'),
                  AstryxTab(
                    value: 'waiting',
                    label: 'Waiting',
                    badge: AstryxBadge('2'),
                  ),
                  AstryxTab(value: 'done', label: 'Done'),
                ],
              ),
              AstryxList(
                label: title,
                showDividers: true,
                children: <Widget>[
                  for (final entry in const <List<String>>[
                    <String>['Invoice 8841', 'Northwind · £4,800.00'],
                    <String>['Invoice 8840', 'Contoso · £192.00'],
                    <String>['Invoice 8839', 'Initech · £1,250.00'],
                    <String>['Invoice 8838', 'Umbrella · £640.00'],
                  ])
                    AstryxItem(
                      label: entry[0],
                      description: entry[1],
                      leading: const AstryxIcon(AstryxIconName.copy),
                      trailing: const AstryxIcon(AstryxIconName.chevronRight),
                      onPressed: () {},
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// #end
