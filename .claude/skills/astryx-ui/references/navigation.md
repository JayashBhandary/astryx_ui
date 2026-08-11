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

## AstryxLink

`lib/src/components/navigation/link.dart` · upstream `Link`

Inline navigation in running text, with the visited and external affordances.

```dart
class LinkDemoExample extends StatelessWidget {
  const LinkDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter has no inline element, so `AstryxLink.span` is how one sits in a
    // sentence. An external link says so in its accessible name as well as in
    // its glyph: the user who cannot see the glyph is the one most disrupted
    // by a window they did not expect.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: AstryxTheme.of(context).textStyle(AstryxTypeRole.body),
            children: <InlineSpan>[
              const TextSpan(text: 'Start with the '),
              AstryxLink.span('installation guide', onPressed: () {}),
              const TextSpan(text: ', then read about '),
              AstryxLink.span('theming', onPressed: () {}),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        AstryxLink('The Flutter docs', external: true, onPressed: () {}),
        AstryxLink('Already read', visited: true, onPressed: () {}),
        const AstryxLink('Unavailable', enabled: false),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** An external link says so **in its accessible name**, not only in its glyph: the user who cannot see the glyph is exactly the one most disrupted by a window they did not expect. The underline is on by default for the same kind of reason — in running text, colour alone is the only thing telling a link from an emphasised word, and for a colour-blind reader it tells them nothing.
- **Note:** `visited` is yours to track. A browser knows a link’s history and Flutter does not, so there is nothing here to read it from — pass it if your application keeps the answer, and leave it alone if it does not.

### AstryxLink

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The text. The positional first argument. |
| `onPressed` | `VoidCallback?` | — | Called when it is followed. |
| `href` | `Uri?` | — | A destination for the `AstryxLinkDelegate`. |
| `external` | `bool` | `false` | Whether following it leaves the application. Adds the glyph *and* the announcement. |
| `visited` | `bool` | `false` | Whether it has been followed. Yours to track. |
| `underline` | `AstryxLinkUnderline` | `AstryxLinkUnderline.always` | When the underline is drawn. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The type role the text takes, so a link matches the copy around it. |
| `enabled` | `bool` | `true` | Whether it can be followed. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |
| `focusNode` | `FocusNode?` | — | The focus node. |

### AstryxLinkUnderline

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `always` | `AstryxLinkUnderline` | — | The default, and what running text needs. |
| `hover` | `AstryxLinkUnderline` | — | On hover and focus only, for a link that is obviously one from its position — a row in a list, a name in a cell. |
| `never` | `AstryxLinkUnderline` | — | For a link inside something already visibly interactive. |

---

## AstryxSegmentedControl

`lib/src/components/navigation/segmented_control.dart` · upstream `SegmentedControl / SegmentedControlItem`

A small set of mutually exclusive views, all labels visible at once.

```dart
class SegmentedControlDemoExample extends StatefulWidget {
  const SegmentedControlDemoExample({super.key});

  @override
  State<SegmentedControlDemoExample> createState() =>
      _SegmentedControlDemoExampleState();
}

class _SegmentedControlDemoExampleState
    extends State<SegmentedControlDemoExample> {
  String _range = 'week';
  String _density = 'balanced';

  @override
  Widget build(BuildContext context) {
    // One tab stop; the arrows move *and* choose, and wrap at both ends. It
    // announces itself as a radio group, which is what it is.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSegmentedControl<String>(
          label: 'Range',
          value: _range,
          onChanged: (value) => setState(() => _range = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(value: 'day', label: 'Day'),
            AstryxSegment(value: 'week', label: 'Week'),
            AstryxSegment(value: 'month', label: 'Month'),
            AstryxSegment(value: 'year', label: 'Year', enabled: false),
          ],
        ),
        AstryxSegmentedControl<String>(
          label: 'Density',
          value: _density,
          onChanged: (value) => setState(() => _density = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(
              value: 'compact',
              label: 'Compact',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.menu),
            ),
            AstryxSegment(
              value: 'balanced',
              label: 'Balanced',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.viewColumns),
            ),
          ],
        ),
        AstryxText(
          'Showing $_range, $_density',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** **Keyboarded as an ARIA radiogroup**: one tab stop, the arrows move *and choose*, and they wrap at both ends so nobody has to reverse out of the end. Both axes work, because a user who does not know which way the control runs will try either, and the inline arrows mirror under RTL.

| Use | When |
| --- | --- |
| `AstryxSegmentedControl` | One choice out of a few — a range, a filter, a density. Announced as a radio group. |
| AstryxTabList (references/data.md) | Switching what a page *shows*, at the top of the thing it switches. Announced as tabs. |
| AstryxToggleButtonGroup (references/actions.md) | Settings that happen to sit together. Announced as pressed or not. |
| AstryxRadioList (references/forms.md) | The same choice with more than about five options, or labels longer than a word or two. |

### AstryxSegmentedControl

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `segments` **(required)** | `List<AstryxSegment<T>>` | — | The choices, in the order they are shown and traversed. |
| `value` **(required)** | `T?` | — | The chosen value. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly chosen value. Null makes the control read-only. |
| `label` | `String?` | — | The control’s accessible name. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.md` | The control’s size. |
| `expand` | `bool` | `false` | Whether the segments share the width equally. False hugs the labels. |
| `focusNode` | `FocusNode?` | — | The focus node for the control. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxSegment

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What choosing this segment produces. |
| `label` **(required)** | `String` | — | The visible text, and this segment’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. |
| `enabled` | `bool` | `true` | Whether this segment can be chosen. |
| `labelHidden` | `bool` | `false` | Whether the label is a name for a screen reader only. Requires `icon`. |

---

## AstryxToolbar

`lib/src/components/navigation/toolbar.dart` · upstream `Toolbar`

A horizontal band of controls, with arrow-key traversal as one tab stop.

```dart
class ToolbarDemoExample extends StatefulWidget {
  const ToolbarDemoExample({super.key});

  @override
  State<ToolbarDemoExample> createState() => _ToolbarDemoExampleState();
}

class _ToolbarDemoExampleState extends State<ToolbarDemoExample> {
  final Set<String> _marks = <String>{'bold'};

  @override
  Widget build(BuildContext context) {
    // Tab reaches the band once and leaves it once, however many controls sit
    // between; the arrows move inside it. A formatting bar of twelve buttons
    // is twelve presses to walk past otherwise.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing1,
      child: AstryxToolbar(
        label: 'Formatting',
        children: <Widget>[
          for (final mark in const <List<String>>[
            <String>['bold', 'Bold'],
            <String>['italic', 'Italic'],
            <String>['code', 'Code'],
          ])
            AstryxToggleButton(
              label: mark[1],
              pressed: _marks.contains(mark[0]),
              size: AstryxButtonSize.sm,
              onChanged: (on) => setState(() {
                on ? _marks.add(mark[0]) : _marks.remove(mark[0]);
              }),
            ),
          const AstryxToolbarDivider(),
          AstryxMoreMenu(
            label: 'More formatting',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Strikethrough', onSelected: () {}),
              AstryxMenuItem(label: 'Superscript', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Clear formatting',
                destructive: true,
                onSelected: () => setState(_marks.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** `AstryxToolbarDivider` is its own widget because a bare AstryxDivider (references/layout.md) in a row has no height to take, and because a rule between groups of controls is a thing worth naming.

### AstryxToolbar

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The controls, in the order they are traversed. |
| `label` | `String?` | — | The toolbar’s accessible name. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The space between controls. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The inset around them. |

---

## AstryxMoreMenu

`lib/src/components/navigation/more_menu.dart` · upstream `MoreMenu`

The overflow menu a toolbar or nav collapses its tail into.

```dart
class ToolbarDemoExample extends StatefulWidget {
  const ToolbarDemoExample({super.key});

  @override
  State<ToolbarDemoExample> createState() => _ToolbarDemoExampleState();
}

class _ToolbarDemoExampleState extends State<ToolbarDemoExample> {
  final Set<String> _marks = <String>{'bold'};

  @override
  Widget build(BuildContext context) {
    // Tab reaches the band once and leaves it once, however many controls sit
    // between; the arrows move inside it. A formatting bar of twelve buttons
    // is twelve presses to walk past otherwise.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing1,
      child: AstryxToolbar(
        label: 'Formatting',
        children: <Widget>[
          for (final mark in const <List<String>>[
            <String>['bold', 'Bold'],
            <String>['italic', 'Italic'],
            <String>['code', 'Code'],
          ])
            AstryxToggleButton(
              label: mark[1],
              pressed: _marks.contains(mark[0]),
              size: AstryxButtonSize.sm,
              onChanged: (on) => setState(() {
                on ? _marks.add(mark[0]) : _marks.remove(mark[0]);
              }),
            ),
          const AstryxToolbarDivider(),
          AstryxMoreMenu(
            label: 'More formatting',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Strikethrough', onSelected: () {}),
              AstryxMenuItem(label: 'Superscript', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Clear formatting',
                destructive: true,
                onSelected: () => setState(_marks.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** `label` is the trigger’s name, its tooltip **and** the menu’s name — one string, because they are one answer to one question: what is behind this button? AstryxBreadcrumbs (references/navigation.md) uses this widget for its collapsed steps, which is why that trigger is named "Show 3 hidden steps" rather than "…".

### AstryxMoreMenu

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxMenuEntry>` | — | The rows, in order. |
| `label` | `String?` | — | The trigger’s name, its tooltip, and the menu’s name. |
| `icon` | `AstryxIconName` | `AstryxIconName.moreHorizontal` | The glyph on the trigger. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.sm` | The trigger’s size. |
| `variant` | `AstryxButtonVariant` | `AstryxButtonVariant.ghost` | The trigger’s variant. |
| `enabled` | `bool` | `true` | Whether the menu opens. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |

---

## AstryxTabMenu

`lib/src/components/navigation/tab_menu.dart` · upstream `TabMenu`

A tab whose selection opens a menu rather than switching a panel.

```dart
class TabMenuDemoExample extends StatefulWidget {
  const TabMenuDemoExample({super.key});

  @override
  State<TabMenuDemoExample> createState() => _TabMenuDemoExampleState();
}

class _TabMenuDemoExampleState extends State<TabMenuDemoExample> {
  String _view = 'overview';

  static const Set<String> _reports = <String>{'usage', 'billing'};

  @override
  Widget build(BuildContext context) {
    // Most tabs are views; this one is a *set* of them. It is drawn as a tab so
    // it reads as one, and announced as a menu button so nobody is told it is
    // a tab and then handed a menu.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxHStack(
          children: <Widget>[
            AstryxTabList<String>(
              label: 'Views',
              value: _reports.contains(_view) ? null : _view,
              onChanged: (value) => setState(() => _view = value),
              tabs: const <AstryxTab<String>>[
                AstryxTab(value: 'overview', label: 'Overview'),
                AstryxTab(value: 'activity', label: 'Activity'),
              ],
            ),
            AstryxTabMenu(
              label: 'Reports',
              selected: _reports.contains(_view),
              entries: <AstryxMenuEntry>[
                for (final report in _reports)
                  AstryxMenuItem(
                    label: report,
                    onSelected: () => setState(() => _view = report),
                  ),
              ],
            ),
          ],
        ),
        AstryxText('Showing $_view'),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** It announces itself as a **menu button**, not a tab. Telling a screen-reader user this is a tab and then opening a menu is a promise the widget cannot keep — `selected` still reports which entry the page came from.

### AstryxTabMenu

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the trigger’s accessible name. |
| `entries` **(required)** | `List<AstryxMenuEntry>` | — | The rows the menu shows. |
| `icon` | `Widget?` | — | An icon before the label. |
| `selected` | `bool` | `false` | Whether the view currently showing came from this menu. Draws the tab’s indicator. |
| `enabled` | `bool` | `true` | Whether the menu opens. |
| `menuLabel` | `String?` | — | A name for the menu surface. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |

---

## AstryxPagination

`lib/src/components/navigation/pagination.dart` · upstream `Pagination`

Page-at-a-time controls for a list or table too long to scroll.

```dart
class PaginationDemoExample extends StatefulWidget {
  const PaginationDemoExample({super.key});

  @override
  State<PaginationDemoExample> createState() => _PaginationDemoExampleState();
}

class _PaginationDemoExampleState extends State<PaginationDemoExample> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    // Pages are one-based, as they are to the person reading them. The ends
    // are always shown, the middle gaps, and the arrows disable rather than
    // disappear — a control that vanishes moves everything beside it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxPagination(
          page: _page,
          pageCount: 20,
          onPageChanged: (page) => setState(() => _page = page),
        ),
        AstryxText(
          'Page $_page of 20',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **Pages are one-based**, as they are to the person reading them: "page 1 of 20" is what the control says, so it is what the control counts in. An off-by-one here is an off-by-one the user sees.
- **Accessibility:** The arrows **disable at the ends rather than disappearing**: a control that vanishes moves everything beside it, and the reader loses their place in a row they were about to press again. The whole control announces "Page 3 of 20", so someone landing on it is told where they are before they hear a single number.

### AstryxPagination

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `page` **(required)** | `int` | — | The current page, from 1 to `pageCount`. |
| `pageCount` **(required)** | `int` | — | How many pages there are. |
| `onPageChanged` | `ValueChanged<int>?` | — | Called with the page the user chose. Null makes the control read-only. |
| `siblings` | `int` | `1` | How many page numbers to show each side of the current one. |
| `showEdges` | `bool` | `true` | Whether the first and last pages are always shown. |
| `label` | `String?` | — | The control’s accessible name. |

---

