---
title: AstryxSideNav
description: A vertical navigation rail with sections, headings, and a collapsed state.
component: true
group: Navigation
source: lib/src/components/navigation/side_nav.dart
upstream: SideNav / SideNavCollapseButton / SideNavHeading / SideNavItem / SideNavSection
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
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
)
```

The rail, the bar and the drawer take the **same** `AstryxNavEntry` list — `AstryxNavItem` for a destination, `AstryxNavSection` for a labelled group, `AstryxNavDivider` for a rule. A navigation written once can be shown three ways, which is what stops an application from having a rail and a drawer that disagree about where its pages are.

Upstream splits the rail into five components — `SideNav`, `SideNavSection`, `SideNavHeading`, `SideNavItem` and `SideNavCollapseButton`. Here the first is a widget, the next three are entries in a list, and the last appears on its own the moment you pass `onCollapsedChanged`: a button that does nothing has no reason to be drawn.

## Collapsed

> **Accessibility**
>
> **The labels leave the screen; they do not leave the semantics tree.** A collapsed row keeps its label as its accessible name and gains a tooltip that shows on **focus as well as hover**, so a keyboard user gets what a mouse user gets. This is the one place the widget set puts anything near a tooltip, and it is allowed only because the name is still announced and still reachable without a pointer — a rail that hides its labels behind hover alone works only for people who can hover.

A section heading has nowhere to go in a 64px rail, so it becomes an `AstryxVisuallyHidden` name: the group is still announced, and the space is not spent on a word nobody can read.

## The footer stays put

The rows scroll and the footer does not, so a rail of forty destinations does not push the account row off the bottom of the window. `header` sits above the rows, with a rule under it — an [AstryxNavHeadingMenu](nav_heading_menu.md) is what usually goes there.

### AstryxSideNav

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxNavEntry>` | — | The destinations, sections and dividers, in order. |
| `selectedId` | `String?` | — | The id of the current destination. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the user chose. Null leaves the rows inert. |
| `header` | `Widget?` | — | Content above the rows. |
| `footer` | `Widget?` | — | Content pinned below the rows, which does not scroll with them. |
| `collapsed` | `bool` | `false` | Whether the rail shows its icons alone. |
| `onCollapsedChanged` | `ValueChanged<bool>?` | — | Called when the collapse button is pressed. Null hides the button. |
| `label` | `String?` | — | The rail’s accessible name. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing2` | The inset around the rows. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.compact` | The vertical rhythm the rows take. |


### AstryxNavItem

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` *(required)* | `String` | — | The destination’s identity — a route name, an enum’s name. What `selectedId` matches and `onSelected` reports. |
| `label` *(required)* | `String` | — | The visible text, and the row’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. Wrap it in `AstryxNavIcon` for the slot every other row reserves. |
| `trailing` | `Widget?` | — | A count, a badge, a status dot. |
| `description` | `String?` | — | Secondary text below the label. Ignored by `AstryxTopNav`, which has one line to work with. |
| `enabled` | `bool` | `true` | Whether the destination can be chosen. |
| `children` | `List<AstryxNavItem>` | `const <AstryxNavItem>[]` | Destinations under this one. A rail indents them; a bar puts them in a menu. |
| `panel` | `Widget?` | — | A wide panel this row opens — upstream’s mega menu. An `AstryxTopNav` affordance; a rail has no width for one. |


### AstryxNavSection

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The heading over the group. |
| `items` | `List<AstryxNavItem>` | `const <AstryxNavItem>[]` | The destinations in it. |
| `trailing` | `Widget?` | — | Content at the trailing edge of the heading — a count, an add button. |
| `labelHidden` | `bool` | `false` | Whether the heading is a name for a screen reader only. |


## Related

- [AstryxAppShell](app_shell.md) — puts this beside the content, and moves it into a drawer when the window is narrow.
- [AstryxMobileNav](mobile_nav.md) — the same rows in a drawer of their own.
- [AstryxTopNav](top_nav.md) — the same entries as a bar.
- [AstryxTreeList](tree_list.md) — when the destinations are a hierarchy to explore rather than a set to choose from.

---

Something wrong with `AstryxSideNav`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSideNav&component=AstryxSideNav) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSideNav&area=AstryxSideNav) — both templates arrive with the component filled in.
