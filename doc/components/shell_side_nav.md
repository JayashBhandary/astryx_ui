---
title: Shell with side nav
description: The shell with a vertical rail only.
component: true
group: Templates
source: example/lib/examples/template_shell_variant_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Collapse the rail with the control under the account row, or narrow the window past 680 to send it behind the drawer the menu button in the page header opens.


## One bar, and it is vertical

The [shell navigation](shell_nav.md) template has both bars. Most applications need one, and which one is a fact about how many destinations there are rather than a matter of taste. A rail is right when the list is long enough to need headings, or deep enough to need indenting — a bar has room for neither.

```text
AstryxAppShell(compactBelow: 680)   ← no `header:` at all
├── sidebar ← AstryxSideNav
│   ├── header ← AstryxNavHeadingMenu: the workspace switcher
│   ├── rows   ← sections, indented children, a badge
│   └── footer ← the account row, pinned above the collapse control
└── child   ← AstryxLayout: the page, and its own header
```

Everything a top bar would have carried is in the rail: identity at the top through [AstryxNavHeadingMenu](nav_heading_menu.md), the account at the bottom. A full-width band holding only a logo is a band spent on nothing.

## Where the menu button goes when there is no header

The shell still moves the rail behind a drawer when the window is narrow — but with no shell header, there is nowhere obvious to put the control that opens it. It goes in the *page’s* own header, and [AstryxMobileNavToggle](mobile_nav.md) with no `controller` reaches for the enclosing shell’s.

```dart
final shell = AstryxAppShell.of(context);

if (shell.compact)
  const AstryxMobileNavToggle(       // ← no controller: it finds the shell's
    label: 'Open navigation',
    size: AstryxButtonSize.sm,
  ),
```

> **Note**
>
> `sidebarWidth` moves with the collapsed state — `_collapsed ? 72 : 244` — because the rail does not decide its own width. The content column is the other half of that decision, and only the shell knows about both.

## Children indent here; on a bar they would be a menu

The **Runs** destination has `children`, and a rail draws them as indented rows under their parent. The same list on an [AstryxTopNav](top_nav.md) becomes a menu that row opens — one entry type, two containers, and no second list to keep in step.

> **Accessibility**
>
> Collapsing takes the labels off the screen and leaves them in the semantics tree, with a tooltip that shows on **focus as well as hover**. That is the one place this widget set puts anything near a tooltip, and it is allowed only because the name is still announced and still reachable without a pointer.

## Related

- [Shell navigation](shell_nav.md) — both bars, and what each is for.
- [Shell with top nav](shell_top_nav.md) — the other half of this split.
- [AstryxSideNav](side_nav.md) — the rail, its sections and its collapsed state.
- [AstryxAppShell](app_shell.md) — the frame, and `compactBelow`.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Shell with side nav`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Shell+with+side+nav&component=Shell+with+side+nav) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Shell+with+side+nav&area=Shell+with+side+nav) — both templates arrive with the component filled in.
