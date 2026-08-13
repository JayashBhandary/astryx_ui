---
title: Shell with top nav
description: The shell with a horizontal bar only.
component: true
group: Templates
source: example/lib/examples/template_shell_variant_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Narrow the window: the destinations scroll sideways rather than disappearing, and the account menu never moves.


## No sidebar means no drawer

With nothing in `sidebar:`, `compactBelow` has nothing to do — there is no navigation for the shell to move anywhere. The bar handles its own narrow case instead: the destinations sit in a horizontal scroller and the actions stay pinned at the trailing edge, so adding a destination never moves the account menu.

```text
AstryxAppShell                     ← no `sidebar:`, so no drawer
├── header ← AstryxTopNav
│   ├── leading ← the brand
│   ├── entries ← Inbox · Reports · Admin (a section → a menu)
│   └── actions ← search, the account menu
└── child  ← AstryxLayout(maxContentWidth: 900)
    ├── header ← the page title and its one action
    └── child  ← AstryxTabList, then the rows
```

## A section becomes a menu

The **Admin** entry is an `AstryxNavSection` with three items. A rail would draw that as a heading over a group; a bar has no room for a heading, and a menu is exactly what holds one. Same `List<AstryxNavEntry>`, different container, and nothing in the application has to know which one it is in.

## The second level goes inside the page

A bar has room for about five destinations. Anything past that has to live somewhere, and on this shape it lives *in* the page rather than beside it — an [AstryxTabList](tab_list.md) under the title, because Open and Waiting and Done are views of one thing rather than places in the product.

> **Note**
>
> **That is the trade.** A rail can hold twenty destinations and a bar cannot. If the second level of navigation keeps growing, the answer is not a wider bar — it is the [rail](shell_side_nav.md), or [both](shell_nav.md).

`maxContentWidth: 900` on the layout is doing what the rail would otherwise have done. Without a rail eating 240 pixels, the content column runs the full width of a monitor, and a row of text that wide is a row nobody reads to the end of.

> **Accessibility**
>
> The bar carries `label: 'Areas'`, and the account trigger is an [AstryxAvatar](avatar.md) with `semanticsLabel: 'Account — Grace Hopper'`. A picture of a person is not a name for the menu behind it, and "Grace Hopper" alone does not say that pressing it opens preferences and sign-out.

## Related

- [Shell with side nav](shell_side_nav.md) — the other half of this split.
- [Shell navigation](shell_nav.md) — both, and the three layers of "where am I".
- [AstryxTopNav](top_nav.md) — the bar, its menus and the mega menu.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Shell with top nav`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Shell+with+top+nav&component=Shell+with+top+nav) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Shell+with+top+nav&area=Shell+with+top+nav) — both templates arrive with the component filled in.
