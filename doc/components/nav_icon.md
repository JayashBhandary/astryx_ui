---
title: AstryxNavIcon
description: The icon slot in a navigation item, sized and aligned for the rail.
component: true
group: Navigation
source: lib/src/components/navigation/nav_icon.dart
upstream: NavIcon
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

## Usage

```dart
AstryxNavItem(
  id: 'deploys',
  label: 'Deploys',
  icon: const AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
)
```

**The square is the point, not the icon.** Every row reserves the same slot, so labels line up whether or not their neighbours have icons, and a rail that collapses to icons alone keeps them on one axis instead of shuffling as the labels go. An icon dropped straight into a row gets neither.

It also carries the row’s state, which is why it is a widget rather than a size: the glyph takes `--color-icon-accent` when the row is the current destination and dims when the row is disabled.

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


### AstryxNavIcon

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `icon` *(required)* | `Widget` | — | The glyph. The positional first argument; size and colour come from the slot. |
| `selected` | `bool` | `false` | Whether the row this belongs to is the current destination. |
| `enabled` | `bool` | `true` | Whether the row accepts input. |
| `size` | `AstryxIconSize` | `AstryxIconSize.md` | How large the glyph is drawn. The slot is sized from it. |


## Related

- [AstryxIcon](icon.md) — the glyph itself, and the registry it comes from.
- [AstryxSideNav](side_nav.md) — where this belongs.

---

Something wrong with `AstryxNavIcon`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxNavIcon&component=AstryxNavIcon) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxNavIcon&area=AstryxNavIcon) — both templates arrive with the component filled in.
