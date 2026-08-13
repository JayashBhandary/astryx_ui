---
title: AstryxTopNav
description: A horizontal application bar, with menus and an optional mega menu.
component: true
group: Navigation
source: lib/src/components/navigation/top_nav.dart
upstream: TopNav / TopNavHeading / TopNavItem / TopNavMegaMenu / TopNavMegaMenuFeaturedCard / TopNavMegaMenuItem / TopNavMenu
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxTopNav(
  leading: const Brand(),
  selectedId: _section,
  onSelected: (id) => setState(() => _section = id),
  actions: <Widget>[AccountMenu()],
  entries: const <AstryxNavEntry>[
    AstryxNavItem(id: 'deploys', label: 'Deploys'),
  ],
)
```

The rail, the bar and the drawer take the **same** `AstryxNavEntry` list — `AstryxNavItem` for a destination, `AstryxNavSection` for a labelled group, `AstryxNavDivider` for a rule. A navigation written once can be shown three ways, which is what stops an application from having a rail and a drawer that disagree about where its pages are.

## What a bar does differently

| Entry | On a rail | On the bar |
| --- | --- | --- |
| `AstryxNavItem` with `children` | indented rows under their parent | a menu the row opens |
| `AstryxNavItem` with a `panel` | ignored — a rail has no width for one | the panel, as a popover under the bar |
| `AstryxNavSection` | a heading over its group | a menu named after the group — a bar has no room for a heading, and a menu is exactly what holds one |
| `AstryxNavDivider` | a rule | space between groups of destinations |

The destinations hug the leading edge and `actions` the trailing one, so adding a destination never moves the account menu. The destinations scroll sideways rather than wrapping — for a bar with genuinely more items than width, [AstryxOverflowList](overflow_list.md) moves the tail into a menu instead.

> **Note**
>
> Upstream’s mega menu ships as four components — the menu, its items and a featured card. Here it is whatever widget you pass as `panel`: the panel’s contents are ordinary layout, and a card in it is an [AstryxCard](card.md).

### AstryxTopNav

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxNavEntry>` | — | The destinations, in order. |
| `selectedId` | `String?` | — | The id of the current destination. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the user chose. |
| `leading` | `Widget?` | — | Content at the reading-start edge — a logo, a product name. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Content at the reading-end edge — search, an account menu. |
| `label` | `String?` | — | The bar’s accessible name. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The inset around the bar’s contents. |


## Related

- [AstryxAppShell](app_shell.md) — whose `header` this usually is.
- [AstryxSideNav](side_nav.md) — the same entries as a rail.
- [AstryxTabList](tab_list.md) — for switching views *within* a page, which is not navigation.

---

Something wrong with `AstryxTopNav`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTopNav&component=AstryxTopNav) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTopNav&area=AstryxTopNav) — both templates arrive with the component filled in.
