# Navigation

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxSideNav

`lib/src/components/navigation/side_nav.dart` · upstream `SideNav / SideNavCollapseButton / SideNavHeading / SideNavItem / SideNavSection`

A vertical navigation rail with sections, headings, and a collapsed state.

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

**Rules**

- **Accessibility:** **The labels leave the screen; they do not leave the semantics tree.** A collapsed row keeps its label as its accessible name and gains a tooltip that shows on **focus as well as hover**, so a keyboard user gets what a mouse user gets. This is the one place the widget set puts anything near a tooltip, and it is allowed only because the name is still announced and still reachable without a pointer — a rail that hides its labels behind hover alone works only for people who can hover.

### AstryxSideNav

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxNavEntry>` | — | The destinations, sections and dividers, in order. |
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

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `id` **(required)** | `String` | — | The destination’s identity — a route name, an enum’s name. What `selectedId` matches and `onSelected` reports. |
| `label` **(required)** | `String` | — | The visible text, and the row’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. Wrap it in `AstryxNavIcon` for the slot every other row reserves. |
| `trailing` | `Widget?` | — | A count, a badge, a status dot. |
| `description` | `String?` | — | Secondary text below the label. Ignored by `AstryxTopNav`, which has one line to work with. |
| `enabled` | `bool` | `true` | Whether the destination can be chosen. |
| `children` | `List<AstryxNavItem>` | `const <AstryxNavItem>[]` | Destinations under this one. A rail indents them; a bar puts them in a menu. |
| `panel` | `Widget?` | — | A wide panel this row opens — upstream’s mega menu. An `AstryxTopNav` affordance; a rail has no width for one. |

### AstryxNavSection

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The heading over the group. |
| `items` | `List<AstryxNavItem>` | `const <AstryxNavItem>[]` | The destinations in it. |
| `trailing` | `Widget?` | — | Content at the trailing edge of the heading — a count, an add button. |
| `labelHidden` | `bool` | `false` | Whether the heading is a name for a screen reader only. |

---

## AstryxTopNav

`lib/src/components/navigation/top_nav.dart` · upstream `TopNav / TopNavHeading / TopNavItem / TopNavMegaMenu / TopNavMegaMenuFeaturedCard / TopNavMegaMenuItem / TopNavMenu`

A horizontal application bar, with menus and an optional mega menu.

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

**Rules**

- **Note:** Upstream’s mega menu ships as four components — the menu, its items and a featured card. Here it is whatever widget you pass as `panel`: the panel’s contents are ordinary layout, and a card in it is an AstryxCard (references/surfaces.md).

| Entry | On a rail | On the bar |
| --- | --- | --- |
| `AstryxNavItem` with `children` | indented rows under their parent | a menu the row opens |
| `AstryxNavItem` with a `panel` | ignored — a rail has no width for one | the panel, as a popover under the bar |
| `AstryxNavSection` | a heading over its group | a menu named after the group — a bar has no room for a heading, and a menu is exactly what holds one |
| `AstryxNavDivider` | a rule | space between groups of destinations |

### AstryxTopNav

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxNavEntry>` | — | The destinations, in order. |
| `selectedId` | `String?` | — | The id of the current destination. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the user chose. |
| `leading` | `Widget?` | — | Content at the reading-start edge — a logo, a product name. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Content at the reading-end edge — search, an account menu. |
| `label` | `String?` | — | The bar’s accessible name. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The inset around the bar’s contents. |

---

## AstryxMobileNav

`lib/src/components/navigation/mobile_nav.dart` · upstream `MobileNav / MobileNavToggle`

The navigation drawer a narrow viewport gets instead of the rail.

```dart
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
```

**Rules**

- **Note:** **Inside an AstryxAppShell (references/app_shell.md) you do not need this.** Give the shell an AstryxSideNav (references/navigation.md) as its `sidebar` and it moves that into a drawer itself when the window is narrow. Reach for this when there is no shell, or when the navigation lives somewhere the shell does not know about.
- **Careful:** **Closing the drawer after a choice is yours to do.** A drawer that closed itself would take a mis-tap as a navigation; one that never closed would cover the page the user just asked for. The `onSelected` in the snippet above calls `hide` for that reason.

### AstryxMobileNav

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxOverlayController` | — | The open/closed state. |
| `entries` **(required)** | `List<AstryxNavEntry>` | — | The destinations, sections and dividers, in order. |
| `selectedId` | `String?` | — | The id of the current destination. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the user chose. Closing the drawer is the caller’s. |
| `header` | `Widget?` | — | Content above the rows. |
| `footer` | `Widget?` | — | Content pinned below the rows. |
| `label` | `String?` | — | The drawer’s accessible name. |
| `width` | `double` | `280` | How wide the drawer is. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.compact` | The vertical rhythm the rows take. |

### AstryxMobileNavToggle

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` | `AstryxOverlayController?` | — | The drawer to open. Null uses the enclosing shell’s. |
| `label` | `String?` | — | Overrides the accessible name and the tooltip. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.md` | The button size. |
| `variant` | `AstryxButtonVariant` | `AstryxButtonVariant.ghost` | The button variant. |

---

## AstryxNavHeadingMenu

`lib/src/components/navigation/nav_heading_menu.dart` · upstream `NavHeadingMenu`

A navigation heading that is itself a menu trigger.

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

**Rules**

- **Accessibility:** The row announces the label and the description as one name — "Acme Corp, Production" — because they are one fact about where the user is, and two nodes would make the reader assemble it.

### AstryxNavHeadingMenu

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The name of the thing being looked at. |
| `entries` **(required)** | `List<AstryxMenuEntry>` | — | The rows the menu shows. |
| `description` | `String?` | — | Secondary text — the environment, the plan, the role. |
| `leading` | `Widget?` | — | A logo, an avatar. |
| `collapsed` | `bool` | `false` | Whether the enclosing rail is collapsed. |
| `enabled` | `bool` | `true` | Whether the heading opens its menu. |
| `menuLabel` | `String?` | — | A name for the menu surface. |
| `menuWidth` | `double?` | — | A fixed width for the menu. Null matches the trigger. |

---

## AstryxNavIcon

`lib/src/components/navigation/nav_icon.dart` · upstream `NavIcon`

The icon slot in a navigation item, sized and aligned for the rail.

```dart
AstryxNavItem(
  id: 'deploys',
  label: 'Deploys',
  icon: const AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
)
```

### AstryxNavIcon

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `icon` **(required)** | `Widget` | — | The glyph. The positional first argument; size and colour come from the slot. |
| `selected` | `bool` | `false` | Whether the row this belongs to is the current destination. |
| `enabled` | `bool` | `true` | Whether the row accepts input. |
| `size` | `AstryxIconSize` | `AstryxIconSize.md` | How large the glyph is drawn. The slot is sized from it. |

---

## AstryxBreadcrumbs

`lib/src/components/navigation/breadcrumbs.dart` · upstream `Breadcrumbs / BreadcrumbItem`

The trail back up a hierarchy, collapsing in the middle when it will not fit.

```dart
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
```

**Rules**

- **Accessibility:** The separators are decoration and stay out of the semantics tree: a screen reader gets the trail’s structure from its nodes, not from a chevron read aloud between every pair. The collapsed-steps trigger is named for what it does — "Show 3 hidden steps" — because "…" spoken aloud is not an offer anybody can act on.

### AstryxBreadcrumbs

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `items` **(required)** | `List<AstryxBreadcrumb>` | — | The steps, from the top of the hierarchy to where the reader is. |
| `label` | `String?` | — | The trail’s accessible name. |
| `separator` | `Widget?` | — | What goes between two steps. Defaults to a chevron, mirrored under RTL. |

### AstryxBreadcrumb

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The name of this level. |
| `onPressed` | `VoidCallback?` | — | Goes there. Null makes the step a label rather than a link. |
| `icon` | `Widget?` | — | An icon before the label. |

---

