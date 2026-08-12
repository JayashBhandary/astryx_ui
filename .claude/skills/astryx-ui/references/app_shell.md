# App shell

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxAppShell

`lib/src/components/shell/app_shell.dart` · upstream `AppShell / useAppShellMobile`

The outer frame of an application: header, navigation, content, and the responsive behaviour joining them.

```dart
class AppShellDemoExample extends StatefulWidget {
  const AppShellDemoExample({super.key});

  @override
  State<AppShellDemoExample> createState() => _AppShellDemoExampleState();
}

class _AppShellDemoExampleState extends State<AppShellDemoExample> {
  String _section = 'deploys';

  @override
  Widget build(BuildContext context) {
    // Narrow the frame and the navigation moves behind a drawer; widen it and
    // it comes back beside the content. The threshold is `compactBelow`, a
    // number that lives beside the widget that needs it.
    return SizedBox(
      height: 420,
      child: AstryxAppShell(
        compactBelow: 600,
        navLabel: 'Sections',
        header: const _ShellHeader(),
        sidebar: AstryxList(
          label: 'Sections',
          density: AstryxItemDensity.compact,
          children: <Widget>[
            for (final section in const <List<String>>[
              <String>['deploys', 'Deploys'],
              <String>['environments', 'Environments'],
              <String>['settings', 'Settings'],
            ])
              AstryxItem(
                label: section[1],
                selected: _section == section[0],
                onPressed: () => setState(() => _section = section[0]),
              ),
          ],
        ),
        child: AstryxLayout(
          header: AstryxHeading(_section, level: 1),
          child: const AstryxText(
            'The shell holds the application together. The page inside it is '
            'an AstryxLayout, which holds this heading still while the body '
            'scrolls under it.',
          ),
        ),
      ),
    );
  }
}

/// The bar across the top, with the menu button the compact layout needs.
class _ShellHeader extends StatelessWidget {
  const _ShellHeader();

  @override
  Widget build(BuildContext context) {
    // `AstryxAppShell.of` is the port of upstream's `useAppShellMobile`: a
    // header cannot know whether to draw a menu button without knowing where
    // the navigation went, and that answer belongs to the shell.
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Acme', type: AstryxTextType.label),
          const Spacer(),
          const AstryxBadge('Production'),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** `compactBelow` is a number, not an entry in a breakpoint table. This package has no breakpoint system (references/guides.md) on purpose: the width at which *your* navigation stops fitting is a fact about your navigation, and a global table means every screen has to agree about a number none of them chose.
- **Careful:** There is no navigation rail in this package yet — `SideNav`, `TopNav` and `MobileNav` are still to come. `header` and `sidebar` take any widget, and an AstryxList (references/data.md) of AstryxItem (references/data.md)s gets a long way in the meantime.

### AstryxAppShell

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content: usually one `AstryxLayout`. |
| `header` | `Widget?` | — | The bar across the top, above both the navigation and the content. |
| `sidebar` | `Widget?` | — | The navigation. Beside the content when there is room, behind a drawer when there is not. |
| `controller` | `AstryxAppShellController?` | — | Drives the drawer from outside. Null keeps one inside the shell. |
| `sidebarWidth` | `double` | `260` | How wide the navigation is when it sits beside the content. |
| `compactBelow` | `double` | `900` | The width below which the navigation moves into the drawer. |
| `navLabel` | `String?` | — | The drawer’s accessible name. |

### AstryxAppShellScope

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `compact` | `bool` | — | Whether the navigation is behind a drawer rather than beside the content. |
| `controller` | `AstryxAppShellController` | — | The drawer’s controller — `show`, `hide`, `toggle`, `isOpen`. |

---

## AstryxLayout

`lib/src/components/shell/layout.dart` · upstream `Layout / LayoutContent / LayoutFooter / LayoutHeader / LayoutPanel`

The content frame inside the shell — header, footer, panel and scrolling body.

```dart
class LayoutDemoExample extends StatelessWidget {
  const LayoutDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The header and the footer hold still; the body scrolls under them. A
    // page title that scrolls away takes the reader's place in the hierarchy
    // with it, and a Save button that scrolls away cannot be found.
    return SizedBox(
      height: 360,
      child: AstryxLayout(
        header: AstryxHStack(
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Deploys', level: 1)),
            AstryxButton(
              label: 'New deploy',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(label: 'Discard', onPressed: () {}),
            AstryxButton(
              label: 'Save',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 1; i <= 12; i++)
              AstryxCard(
                padding: AstryxSpacingToken.spacing3,
                child: AstryxText('Deploy #$i'),
              ),
          ],
        ),
      ),
    );
  }
}
```

| Set | When |
| --- | --- |
| `scrollable: false` | The body scrolls itself — a table with a pinned header row, a transcript that stays at the bottom. Two scroll views inside one another is one too many. |
| `maxContentWidth` | A page of prose or a single form, where a line running the width of a monitor is unreadable. Leave it null for a table. |
| `scrollController` | Something beside the body needs its scroll position — an AstryxOutline (references/app_shell.md) in the panel tracking the reader. The body’s scroll view belongs to this widget, so the controller is handed in rather than invented. See the documentation (references/templates.md) template. |

### AstryxLayout

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The body, which is what scrolls. |
| `header` | `Widget?` | — | The band above the body — a title, a breadcrumb trail, tabs. Pinned. |
| `footer` | `Widget?` | — | The band below the body — the actions a form is submitted with. Pinned. |
| `panel` | `Widget?` | — | A column beside the body, scrolling on its own. |
| `panelSide` | `AstryxLayoutPanelSide` | `AstryxLayoutPanelSide.end` | Which edge the panel sits against. |
| `panelWidth` | `double` | `320` | How wide the panel is. |
| `scrollable` | `bool` | `true` | Whether the body scrolls. |
| `scrollController` | `ScrollController?` | — | The body’s scroll controller, for anything that has to know where the body has got to — an outline in the panel. Only legal while `scrollable` is true. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing6` | The inset around the body, the header and the footer. |
| `maxContentWidth` | `double?` | — | A measure for the body. Null lets it fill. |

### AstryxLayoutPanelSide

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `start` | `AstryxLayoutPanelSide` | — | The reading-start edge — a filter rail, a table of contents. |
| `end` | `AstryxLayoutPanelSide` | — | The reading-end edge. The default: a details panel about whatever is selected in the body. |

---

## AstryxSection

`lib/src/components/shell/section.dart` · upstream `Section`

A titled band of page content, with its own heading level and spacing.

```dart
class SectionDemoExample extends StatelessWidget {
  const SectionDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxSection(
      title: 'Environments',
      description: 'Where this project is deployed.',
      showDivider: true,
      actions: <Widget>[
        AstryxButton(
          label: 'New environment',
          size: AstryxButtonSize.sm,
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
      ],
      child: AstryxGrid(
        minWidth: 160,
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          for (final env in const <String>['production', 'staging', 'preview'])
            AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText(env),
            ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The rule under the heading is decoration; the *level* is the structure. A screen-reader user navigates a page by heading level, so a section that looks like a sub-part and announces itself as a peer has lied about the shape of the page.

### AstryxSection

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The section’s content. |
| `title` | `String?` | — | The heading. Null for a band that is grouped but not titled. |
| `description` | `String?` | — | A line under the title, saying what the section is for. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls at the trailing edge of the heading row. |
| `level` | `int?` | — | Overrides the heading level. Defaults to one deeper than the enclosing section, and to 2 at the top of a page. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The space between the heading block and the content. |
| `showDivider` | `bool` | `false` | Whether to draw a rule under the heading block. |
| `headerKey` | `Key?` | — | A key on the heading, for an `AstryxOutline` to find and scroll to. |

---

## AstryxResizeHandle

`lib/src/components/shell/resize_handle.dart` · upstream `ResizeHandle / useResizable`

A draggable divider that resizes the panel beside it.

```dart
class ResizeHandleDemoExample extends StatefulWidget {
  const ResizeHandleDemoExample({super.key});

  @override
  State<ResizeHandleDemoExample> createState() =>
      _ResizeHandleDemoExampleState();
}

class _ResizeHandleDemoExampleState extends State<ResizeHandleDemoExample> {
  double _width = 200;

  @override
  Widget build(BuildContext context) {
    // Tab to the handle and use the arrow keys: a divider only a pointer can
    // move is a layout only some people can use.
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: _width,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('${_width.round()} px'),
            ),
          ),
          AstryxResizeHandle(
            label: 'Resize the filters',
            size: _width,
            min: 120,
            max: 360,
            onResize: (width) => setState(() => _width = width),
          ),
          const Expanded(
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('Results'),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** **Tab reaches it, and the arrow keys move it** by `step`, with Home and End at `min` and `max`. It announces itself as a slider carrying the current size, and `label` is required because nothing is painted on a handle — without one a screen reader has a slider and no idea what it sizes. A divider only a pointer can move is a layout only some people can use, and this is the part hand-rolled resize handles almost always miss.

| Edge | The region is | Grows when dragged |
| --- | --- | --- |
| `start` | a panel at the reading-start edge | toward the reading end |
| `end` | a panel at the reading-end edge | toward the reading start |
| `top` | a band at the top | down |
| `bottom` | a band at the bottom | up |

### AstryxResizeHandle

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The handle’s accessible name. Required. |
| `size` **(required)** | `double` | — | The current size of the region beside the handle. |
| `onResize` | `ValueChanged<double>?` | — | Called with the size the region should take, continuously during a drag. Null makes the handle inert. |
| `edge` | `AstryxResizeEdge` | `AstryxResizeEdge.start` | Which edge the resized region sits against. |
| `min` | `double` | `0` | The smallest the region may become. |
| `max` | `double` | `double.infinity` | The largest the region may become. |
| `step` | `double` | `16` | How far one arrow-key press moves the handle. |
| `onResizeEnd` | `ValueChanged<double>?` | — | Called when a drag finishes, for persisting the size rather than writing it on every frame. |
| `enabled` | `bool` | `true` | Whether the handle responds. |
| `thickness` | `double` | `8` | How wide the drag target is. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxResizeEdge

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `start` | `AstryxResizeEdge` | — | A panel at the reading-start edge. |
| `end` | `AstryxResizeEdge` | — | A panel at the reading-end edge. |
| `top` | `AstryxResizeEdge` | — | A band at the top. |
| `bottom` | `AstryxResizeEdge` | — | A band at the bottom. |

---

## AstryxOutline

`lib/src/components/shell/outline.dart` · upstream `Outline`

An on-this-page table of contents, tracking the reader’s position.

```dart
class OutlineDemoExample extends StatefulWidget {
  const OutlineDemoExample({super.key});

  @override
  State<OutlineDemoExample> createState() => _OutlineDemoExampleState();
}

class _OutlineDemoExampleState extends State<OutlineDemoExample> {
  final ScrollController _scroll = ScrollController();
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    'setup': GlobalKey(),
    'usage': GlobalKey(),
    'tokens': GlobalKey(),
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scroll the page, and the outline follows: what it tracks is where the
    // headings are, not what the scroll offset says.
    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final section in const <List<String>>[
                    <String>['setup', 'Setup'],
                    <String>['usage', 'Usage'],
                    <String>['tokens', 'Tokens'],
                  ])
                    AstryxSection(
                      title: section[1],
                      headerKey: _anchors[section[0]],
                      child: const AstryxText(
                        'Enough copy to push the next heading past the top of '
                        'the viewport, which is the event the outline is '
                        'listening for.\n\n'
                        'Scroll on, and the entry beside this one takes the '
                        'accent rule.',
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 160,
            child: AstryxOutline(
              label: 'On this page',
              controller: _scroll,
              entries: <AstryxOutlineEntry>[
                for (final section in const <List<String>>[
                  <String>['setup', 'Setup'],
                  <String>['usage', 'Usage'],
                  <String>['tokens', 'Tokens'],
                ])
                  AstryxOutlineEntry(
                    id: section[0],
                    label: section[1],
                    anchor: _anchors[section[0]],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The entry being read is marked two ways: the accent rule down its edge and `selected` in the semantics tree — so it is not conveyed by colour alone, and a screen-reader user is told where they are without reading back up the page.

| Give it | And it |
| --- | --- |
| a `controller` | follows the reader by itself. |
| an `activeId` | marks that entry instead, whatever the scroll position says — for an outline driven by a router. |
| neither | is a list of links, and nothing is marked. |
| an `onSelected` | reports the press instead of scrolling, for a caller that navigates rather than scrolls. |

### AstryxOutline

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxOutlineEntry>` | — | The headings, in the order they appear on the page. |
| `controller` | `ScrollController?` | — | The scroll view the anchors live in. Given one, the outline tracks the reader by itself. |
| `activeId` | `String?` | — | Marks an entry active, whatever the scroll position says. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the reader chose. Null scrolls to the anchor instead. |
| `label` | `String?` | — | The outline’s accessible name. |
| `topOffset` | `double` | `24` | How far below the top of the viewport a heading counts as reached. |

### AstryxOutlineEntry

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `id` **(required)** | `String` | — | This entry’s identity, unique within the outline. |
| `label` **(required)** | `String` | — | The heading text, as it appears in the outline. |
| `level` | `int` | `2` | The heading level, which sets the indent. |
| `anchor` | `GlobalKey?` | — | A key on the heading this entry points at. |

---

