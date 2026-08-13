---
title: Shell navigation
description: 'The application frame with both bars in place: a full-width header and a collapsible rail beside the content.'
component: true
group: Templates
source: example/lib/examples/template_shell_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Collapse the rail with the control in its header, or narrow the browser window past 720 pixels to send it behind the drawer the menu button opens.


## Two bars, one list of destinations

The header is an [AstryxTopNav](top_nav.md) and the rail is an [AstryxSideNav](side_nav.md), and they are not the same navigation twice. The bar carries the areas of the product — application, docs, status — while the rail carries the sections *inside* the area you are in. Both are containers for one `AstryxNavEntry` list, which is why a section, a divider and a badge look right in either.

```text
AstryxAppShell(compactBelow: 720)
├── header  ← AstryxTopNav: brand, areas, search, account
├── sidebar ← AstryxSideNav: sections, heading menu, account row
└── child   ← AstryxLayout: breadcrumbs, title, actions, body
```

## The header asks the shell where the navigation went

A header cannot know whether to draw a menu button without knowing whether the rail is beside the content or behind the drawer, and that answer belongs to the shell. `AstryxAppShell.of(context)` is the port of upstream’s `useAppShellMobile`; measuring the window a second time in the header is how the two disagree at exactly the threshold.

```dart
final shell = AstryxAppShell.of(context);

if (shell.compact)
  AstryxIconButton(
    icon: AstryxIconName.menu,
    label: 'Open navigation',
    onPressed: shell.controller.toggle,
  ),
```

> **Note**
>
> **`compactBelow` is a number, not a breakpoint.** The width at which *your* navigation stops fitting is a fact about your navigation. A global breakpoint table means every screen has to agree about a number none of them chose.

## Collapsed is narrower, not quieter

Collapsing the rail takes the labels off the screen and leaves them in the semantics tree, with a tooltip that shows on focus as well as hover. The shell’s `sidebarWidth` moves with it — the rail does not decide its own width, because the content column is the other half of that decision.

## Three layers of "where am I"

| Layer | Widget | Answers |
| --- | --- | --- |
| Which product area | [AstryxTopNav](top_nav.md) selection | Application, docs, status. |
| Which section of it | [AstryxSideNav](side_nav.md) selection | Deploys, incidents, services. |
| Where in the hierarchy | [AstryxBreadcrumbs](breadcrumbs.md) | Acme Corp › Production › Deploys. The last crumb has no link: a link to the page you are on is how a trail stops telling you where you are. |

> **Accessibility**
>
> The drawer is a real [AstryxOverlay](overlay.md): it traps focus, closes on Escape or a press on the scrim, and hands focus back to the button that opened it. A shell that hides navigation without any of that loses keyboard users at the first tap.

## Related

- [AstryxAppShell](app_shell.md) — the frame, and the compact behaviour.
- [AstryxSideNav](side_nav.md) — the rail, its sections and its collapsed state.
- [AstryxTopNav](top_nav.md) — the bar, its menus and the mega menu.
- [Documentation](documentation.md) — the same frame with an outline in the panel.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Shell navigation`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Shell+navigation&component=Shell+navigation) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Shell+navigation&area=Shell+navigation) — both templates arrive with the component filled in.
