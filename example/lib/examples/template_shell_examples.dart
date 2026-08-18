/// The two screens the application frame is for: an app behind both navigation
/// bars, and a documentation page with an outline beside it.
///
/// Neither is exported. They are compositions worth copying, assembled from
/// nothing but what `astryx_ui` ships — which is what makes the snippet the
/// point.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// #example template_shell_nav -> ShellNavTemplate
class ShellNavTemplate extends StatefulWidget {
  const ShellNavTemplate({super.key});

  @override
  State<ShellNavTemplate> createState() => _ShellNavTemplateState();
}

class _ShellNavTemplateState extends State<ShellNavTemplate> {
  /// One list of destinations. The rail and the bar are containers for it.
  static const List<AstryxNavEntry> _sections = <AstryxNavEntry>[
    AstryxNavItem(
      id: 'deploys',
      label: 'Deploys',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
      trailing: AstryxBadge('3'),
    ),
    AstryxNavItem(
      id: 'incidents',
      label: 'Incidents',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.warning)),
    ),
    AstryxNavItem(
      id: 'services',
      label: 'Services',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
    ),
    AstryxNavDivider(),
    AstryxNavSection(
      label: 'Workspace',
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
        ),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'deploys': 'Deploys',
    'incidents': 'Incidents',
    'services': 'Services',
    'members': 'Members',
    'billing': 'Billing',
  };

  String _section = 'deploys';
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    // Two bars and one content column. The shell decides whether the rail sits
    // beside the content or behind a drawer; nothing inside has to know, and
    // the header asks when it needs to.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 720,
        navLabel: 'Sections',
        sidebarWidth: _collapsed ? 72 : 248,
        header: _ShellBar(section: _titles[_section]!),
        sidebar: AstryxSideNav(
          label: 'Sections',
          entries: _sections,
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
          footer: AstryxItem(
            label: 'Ada Lovelace',
            description: _collapsed ? null : 'ada@acme.example',
            leading: const AstryxAvatar(
              name: 'Ada Lovelace',
              size: AstryxAvatarSize.sm,
            ),
            onPressed: () {},
          ),
        ),
        child: AstryxLayout(
          header: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxBreadcrumbs(
                label: 'You are here',
                items: <AstryxBreadcrumb>[
                  AstryxBreadcrumb(label: 'Acme Corp', onPressed: () {}),
                  AstryxBreadcrumb(label: 'Production', onPressed: () {}),
                  AstryxBreadcrumb(label: _titles[_section]!),
                ],
              ),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                justify: AstryxStackJustify.between,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(child: AstryxHeading(_titles[_section]!, level: 1)),
                  AstryxButton(
                    label: 'New deploy',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'Narrow the window past 720 logical pixels and the rail moves '
                'behind the drawer the menu button opens. Widen it and it '
                'comes back — the content column is the only thing that '
                'changes width.',
              ),
              for (var i = 0; i < 6; i++)
                AstryxCard(
                  child: AstryxHStack(
                    gap: AstryxSpacingToken.spacing3,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: AstryxVStack(
                          gap: AstryxSpacingToken.spacing0_5,
                          children: <Widget>[
                            AstryxText(
                              '${_titles[_section]} #${412 - i}',
                              type: AstryxTextType.label,
                            ),
                            const AstryxText(
                              'main · 11 minutes',
                              type: AstryxTextType.supporting,
                              color: AstryxTextColor.secondary,
                            ),
                          ],
                        ),
                      ),
                      AstryxBadge(
                        i == 0 ? 'Live' : 'Superseded',
                        variant: i == 0
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.neutral,
                        icon: AstryxIcon(
                          i == 0
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

/// The bar across the whole window: identity, global actions, account.
///
/// It is an `AstryxTopNav` rather than a hand-built row because the tabs in it
/// are destinations — and a bar of destinations owns arrow-key traversal, a
/// selected state and the overflow behaviour that comes with it.
class _ShellBar extends StatelessWidget {
  const _ShellBar({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) {
    // The shell knows where the navigation went. A header cannot decide whether
    // to draw a menu button without that, which is why it asks rather than
    // measuring the window a second time.
    final shell = AstryxAppShell.of(context);

    return AstryxTopNav(
      leading: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Atlas', type: AstryxTextType.label),
        ],
      ),
      entries: <AstryxNavEntry>[
        const AstryxNavItem(id: 'app', label: 'Application'),
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
                AstryxItem(label: 'Deploy pipelines', onPressed: () {}),
                AstryxItem(label: 'On-call rotations', onPressed: () {}),
              ],
            ),
          ),
        ),
        const AstryxNavItem(id: 'status', label: 'Status'),
      ],
      selectedId: 'app',
      onSelected: (_) {},
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
          width: 200,
          entries: <AstryxMenuEntry>[
            const AstryxMenuSection('ada@acme.example'),
            AstryxMenuItem(label: 'Preferences', onSelected: () {}),
            AstryxMenuItem(label: 'Sign out', onSelected: () {}),
          ],
          triggerBuilder: (context, controller) => AstryxAvatar(
            name: 'Ada Lovelace',
            size: AstryxAvatarSize.sm,
            semanticsLabel: 'Account — Ada Lovelace',
            onPressed: controller.toggle,
          ),
        ),
      ],
    );
  }
}
// #end

// #example template_documentation -> DocumentationTemplate
class DocumentationTemplate extends StatefulWidget {
  const DocumentationTemplate({super.key});

  @override
  State<DocumentationTemplate> createState() => _DocumentationTemplateState();
}

class _DocumentationTemplateState extends State<DocumentationTemplate> {
  /// One heading per section, in the order they appear on the page.
  static const List<({String id, String title, String body})> _sections =
      <({String id, String title, String body})>[
        (
          id: 'install',
          title: 'Install',
          body:
              'Add the package, then wrap the application once. Everything '
              'else — the theme, the icons, the localisations, the toast host '
              '— is installed by that one widget.',
        ),
        (
          id: 'configure',
          title: 'Configure',
          body:
              'A pipeline is a file in the repository, not a form in a web '
              'application. The file is the source of truth and the screen is '
              'a view of it, which is why every field here is read-only until '
              'you take the lock.',
        ),
        (
          id: 'deploy',
          title: 'Deploy',
          body:
              'A deploy is a request to make the cluster match a commit. It '
              'is not a script, and nothing about it is ordered by the time '
              'you pressed the button.',
        ),
        (
          id: 'rollback',
          title: 'Roll back',
          body:
              'Rolling back is a deploy of the previous commit, which is why '
              'there is no separate rollback screen: the thing you already '
              'know how to watch is the thing that runs.',
        ),
      ];

  /// The scroll view the anchors live in, and the one the outline tracks.
  final ScrollController _scroll = ScrollController();

  /// A key on each section's heading, so the outline has somewhere to scroll.
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  String _page = 'deploys';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Three columns: the rail says where you are in the site, the outline says
    // where you are on the page, and the body is the only one that scrolls
    // under either of them.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 840,
        navLabel: 'Documentation',
        sidebarWidth: 232,
        header: const _DocsBar(),
        sidebar: AstryxSideNav(
          label: 'Documentation',
          selectedId: _page,
          onSelected: (id) => setState(() => _page = id),
          entries: const <AstryxNavEntry>[
            AstryxNavSection(
              label: 'Getting started',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'install', label: 'Installation'),
                AstryxNavItem(id: 'concepts', label: 'Concepts'),
              ],
            ),
            AstryxNavSection(
              label: 'Guides',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'deploys', label: 'Deploys'),
                AstryxNavItem(id: 'rollbacks', label: 'Rollbacks'),
                AstryxNavItem(id: 'oncall', label: 'On-call'),
              ],
            ),
          ],
        ),
        child: AstryxLayout(
          // The outline needs the body's scroll position, and the body's
          // scroll view belongs to the layout — so the controller is handed in
          // rather than invented here.
          scrollController: _scroll,
          maxContentWidth: 720,
          panelWidth: 200,
          header: AstryxBreadcrumbs(
            label: 'You are here',
            items: <AstryxBreadcrumb>[
              AstryxBreadcrumb(label: 'Docs', onPressed: () {}),
              AstryxBreadcrumb(label: 'Guides', onPressed: () {}),
              const AstryxBreadcrumb(label: 'Deploys'),
            ],
          ),
          panel: AstryxOutline(
            label: 'On this page',
            controller: _scroll,
            entries: <AstryxOutlineEntry>[
              for (final section in _sections)
                AstryxOutlineEntry(
                  id: section.id,
                  label: section.title,
                  anchor: _anchors[section.id],
                ),
            ],
          ),
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            // Two pagers whose labels are page titles, and page titles are as
            // long as they are. Narrow, they take a line each — the chevrons
            // still say which way each one goes.
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Concepts',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.chevronLeft,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Rollbacks',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                trailing: const AstryxIcon(
                  AstryxIconName.chevronRight,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing6,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxHeading('Deploys', level: 1),
                  AstryxText(
                    'What a deploy is, how to start one, and what to do when '
                    'it goes wrong.',
                    type: AstryxTextType.large,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
              const AstryxBanner(
                title: 'This guide covers Atlas 4',
                description: 'Atlas 3 pipelines are configured in the console.',
                announce: false,
              ),
              for (final section in _sections)
                AstryxSection(
                  title: section.title,
                  headerKey: _anchors[section.id],
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxText(section.body),
                      if (section.id == 'install')
                        const AstryxCodeBlock(
                          'dart pub add astryx_ui',
                          language: 'bash',
                        )
                      else
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(text: 'Run '),
                              AstryxCode.span('atlas ${section.id}'),
                              const TextSpan(text: ', or see '),
                              AstryxLink.span(
                                'the reference',
                                onPressed: () {},
                              ),
                              const TextSpan(text: ' for every flag.'),
                            ],
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

/// The bar above a documentation site: identity, search, version.
class _DocsBar extends StatelessWidget {
  const _DocsBar();

  @override
  Widget build(BuildContext context) {
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open documentation navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const Flexible(
            child: AstryxText(
              'Atlas docs',
              type: AstryxTextType.label,
              maxLines: 1,
            ),
          ),
          const Spacer(),
          // A phone has no keyboard to press ⌘K on and no room for the cap
          // that says so, so the search collapses to its glyph. The name it is
          // announced by does not collapse with it — an icon button with no
          // label is a button screen readers call "button".
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.search,
              label: 'Search the documentation',
              tooltip: 'Search',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            )
          else ...<Widget>[
            AstryxButton(
              label: 'Search',
              size: AstryxButtonSize.sm,
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
              ),
              // `mod` is ⌘ on a Mac and Ctrl everywhere else, and the cap says
              // whichever one this platform actually listens for.
              trailing: const AstryxKbd.hotkey(
                AstryxHotkey.mod(LogicalKeyboardKey.keyK),
                size: AstryxKbdSize.sm,
              ),
              onPressed: () {},
            ),
            const AstryxBadge('v4.2'),
          ],
        ],
      ),
    );
  }
}
// #end
