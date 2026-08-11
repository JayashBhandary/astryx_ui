---
title: AstryxNavHeadingMenu
description: A navigation heading that is itself a menu trigger.
component: true
group: Navigation
source: lib/src/components/navigation/nav_heading_menu.dart
upstream: NavHeadingMenu
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
AstryxNavHeadingMenu(
  label: 'Acme Corp',
  description: 'Production',
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Globex', onSelected: () => switchTo('globex')),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'New workspace', onSelected: create),
  ],
)
```

What a workspace or project switcher is: the name of the thing you are looking at, and the way to look at a different one. Upstream ships it as its own component because the two jobs are hard to combine by hand — a heading is not a button, and a button that looks like a heading usually stops being operable somewhere along the way.

It goes in [AstryxSideNav](side_nav.md)’s `header`, and takes the rail’s `collapsed` flag: the label becomes the accessible name alone, and the chevron goes with it, because a chevron with nothing beside it is a button whose purpose has left.

> **Accessibility**
>
> The row announces the label and the description as one name — "Acme Corp, Production" — because they are one fact about where the user is, and two nodes would make the reader assemble it.

### AstryxNavHeadingMenu

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The name of the thing being looked at. |
| `entries` *(required)* | `List<AstryxMenuEntry>` | — | The rows the menu shows. |
| `description` | `String?` | — | Secondary text — the environment, the plan, the role. |
| `leading` | `Widget?` | — | A logo, an avatar. |
| `collapsed` | `bool` | `false` | Whether the enclosing rail is collapsed. |
| `enabled` | `bool` | `true` | Whether the heading opens its menu. |
| `menuLabel` | `String?` | — | A name for the menu surface. |
| `menuWidth` | `double?` | — | A fixed width for the menu. Null matches the trigger. |


## Related

- [AstryxNavSection](side_nav.md) — for a heading that only labels a group.
- [AstryxDropdownMenu](dropdown_menu.md) — the menu this opens.

