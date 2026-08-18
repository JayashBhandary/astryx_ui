---
title: Documentation
description: 'A docs page: side navigation, a measured content column, and an on-this-page outline that tracks the reader.'
component: true
group: Templates
source: example/lib/examples/template_shell_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DocumentationTemplate extends StatefulWidget {
  const DocumentationTemplate({super.key});

  @override
  State<DocumentationTemplate> createState() => _DocumentationTemplateState();
}

class _DocumentationTemplateState extends State<DocumentationTemplate> {
  /// One heading per section, in the order they appear on the page.
  static const List<({String id, String title, String body})> _sections =
      <({String id, String title, String body})>[
        (
          id: 'install',
          title: 'Install',
          body:
              'Add the package, then wrap the application once. Everything '
              'else — the theme, the icons, the localisations, the toast host '
              '— is installed by that one widget.',
        ),
        (
          id: 'configure',
          title: 'Configure',
          body:
              'A pipeline is a file in the repository, not a form in a web '
              'application. The file is the source of truth and the screen is '
              'a view of it, which is why every field here is read-only until '
              'you take the lock.',
        ),
        (
          id: 'deploy',
          title: 'Deploy',
          body:
              'A deploy is a request to make the cluster match a commit. It '
              'is not a script, and nothing about it is ordered by the time '
              'you pressed the button.',
        ),
        (
          id: 'rollback',
          title: 'Roll back',
          body:
              'Rolling back is a deploy of the previous commit, which is why '
              'there is no separate rollback screen: the thing you already '
              'know how to watch is the thing that runs.',
        ),
      ];

  /// The scroll view the anchors live in, and the one the outline tracks.
  final ScrollController _scroll = ScrollController();

  /// A key on each section's heading, so the outline has somewhere to scroll.
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  String _page = 'deploys';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Three columns: the rail says where you are in the site, the outline says
    // where you are on the page, and the body is the only one that scrolls
    // under either of them.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 840,
        navLabel: 'Documentation',
        sidebarWidth: 232,
        header: const _DocsBar(),
        sidebar: AstryxSideNav(
          label: 'Documentation',
          selectedId: _page,
          onSelected: (id) => setState(() => _page = id),
          entries: const <AstryxNavEntry>[
            AstryxNavSection(
              label: 'Getting started',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'install', label: 'Installation'),
                AstryxNavItem(id: 'concepts', label: 'Concepts'),
              ],
            ),
            AstryxNavSection(
              label: 'Guides',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'deploys', label: 'Deploys'),
                AstryxNavItem(id: 'rollbacks', label: 'Rollbacks'),
                AstryxNavItem(id: 'oncall', label: 'On-call'),
              ],
            ),
          ],
        ),
        child: AstryxLayout(
          // The outline needs the body's scroll position, and the body's
          // scroll view belongs to the layout — so the controller is handed in
          // rather than invented here.
          scrollController: _scroll,
          maxContentWidth: 720,
          panelWidth: 200,
          header: AstryxBreadcrumbs(
            label: 'You are here',
            items: <AstryxBreadcrumb>[
              AstryxBreadcrumb(label: 'Docs', onPressed: () {}),
              AstryxBreadcrumb(label: 'Guides', onPressed: () {}),
              const AstryxBreadcrumb(label: 'Deploys'),
            ],
          ),
          panel: AstryxOutline(
            label: 'On this page',
            controller: _scroll,
            entries: <AstryxOutlineEntry>[
              for (final section in _sections)
                AstryxOutlineEntry(
                  id: section.id,
                  label: section.title,
                  anchor: _anchors[section.id],
                ),
            ],
          ),
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            // Two pagers whose labels are page titles, and page titles are as
            // long as they are. Narrow, they take a line each — the chevrons
            // still say which way each one goes.
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Concepts',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.chevronLeft,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Rollbacks',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                trailing: const AstryxIcon(
                  AstryxIconName.chevronRight,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing6,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxHeading('Deploys', level: 1),
                  AstryxText(
                    'What a deploy is, how to start one, and what to do when '
                    'it goes wrong.',
                    type: AstryxTextType.large,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
              const AstryxBanner(
                title: 'This guide covers Atlas 4',
                description: 'Atlas 3 pipelines are configured in the console.',
                announce: false,
              ),
              for (final section in _sections)
                AstryxSection(
                  title: section.title,
                  headerKey: _anchors[section.id],
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxText(section.body),
                      if (section.id == 'install')
                        const AstryxCodeBlock(
                          'dart pub add astryx_ui',
                          language: 'bash',
                        )
                      else
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(text: 'Run '),
                              AstryxCode.span('atlas ${section.id}'),
                              const TextSpan(text: ', or see '),
                              AstryxLink.span(
                                'the reference',
                                onPressed: () {},
                              ),
                              const TextSpan(text: ' for every flag.'),
                            ],
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

/// The bar above a documentation site: identity, search, version.
class _DocsBar extends StatelessWidget {
  const _DocsBar();

  @override
  Widget build(BuildContext context) {
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open documentation navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const Flexible(
            child: AstryxText(
              'Atlas docs',
              type: AstryxTextType.label,
              maxLines: 1,
            ),
          ),
          const Spacer(),
          // A phone has no keyboard to press ⌘K on and no room for the cap
          // that says so, so the search collapses to its glyph. The name it is
          // announced by does not collapse with it — an icon button with no
          // label is a button screen readers call "button".
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.search,
              label: 'Search the documentation',
              tooltip: 'Search',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            )
          else ...<Widget>[
            AstryxButton(
              label: 'Search',
              size: AstryxButtonSize.sm,
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
              ),
              // `mod` is ⌘ on a Mac and Ctrl everywhere else, and the cap says
              // whichever one this platform actually listens for.
              trailing: const AstryxKbd.hotkey(
                AstryxHotkey.mod(LogicalKeyboardKey.keyK),
                size: AstryxKbdSize.sm,
              ),
              onPressed: () {},
            ),
            const AstryxBadge('v4.2'),
          ],
        ],
      ),
    );
  }
}
```

Scroll the middle column: the outline on the right follows. Press an outline entry and the page scrolls to that heading.


## Two different questions

The rail answers "where am I in the site" and the outline answers "where am I on the page". They look similar and they are not interchangeable: a docs site with only the first makes a long page unnavigable, and one with only the second makes the site unbrowsable.

```text
AstryxAppShell(compactBelow: 840)
├── header  ← brand, search with its shortcut, version badge
├── sidebar ← AstryxSideNav: the site
└── child   ← AstryxLayout(maxContentWidth: 720)
    ├── header ← AstryxBreadcrumbs
    ├── child  ← AstryxSection per heading, each with an anchor key
    ├── panel  ← AstryxOutline: the page
    └── footer ← previous / next
```

## The outline needs the body’s scroll controller

An outline tracks the reader by watching where the headings *are*, not by dividing the scroll offset — so it needs the scroll position of the view the anchors live in, and that view belongs to [AstryxLayout](layout.md). Hand the same `ScrollController` to both and the tracking is automatic; give the outline nothing and it is a list of links with `activeId` for you to set.

```dart
final _scroll = ScrollController();
final _anchors = <String, GlobalKey>{for (final s in sections) s.id: GlobalKey()};

AstryxLayout(
  scrollController: _scroll,          // the body's scroll view
  panel: AstryxOutline(
    controller: _scroll,              // ← the same one
    entries: <AstryxOutlineEntry>[
      for (final s in sections)
        AstryxOutlineEntry(id: s.id, label: s.title, anchor: _anchors[s.id]),
    ],
  ),
  child: AstryxVStack(
    children: <Widget>[
      for (final s in sections)
        AstryxSection(title: s.title, headerKey: _anchors[s.id], child: …),
    ],
  ),
)
```

The `anchor` is doing both halves of the job. Without it the outline cannot know where a heading is, and pressing an entry has nowhere to scroll to. Upstream gets the same thing from the DOM id it links to.

> **Note**
>
> **`maxContentWidth: 720`.** Prose is the content here, and a paragraph that runs the width of a monitor is a paragraph nobody finishes. Leave the measure off for a table, which has its own reasons to be wide.

## The sections carry their own heading level

[AstryxSection](section.md) works out its level from how deeply it is nested, so the outline’s indents and the document’s heading structure cannot drift apart. A page whose headings jump from `h1` to `h4` is a page a screen reader cannot summarise.

> **Accessibility**
>
> The search control shows its own shortcut with [AstryxKbd.hotkey](kbd.md), which resolves to ⌘K on a Mac and Ctrl+K elsewhere — the same `AstryxHotkey` the handler listens for, so the cap cannot claim a chord the application does not answer.

The footer is the previous and next page rather than the actions a form would have. It is pinned for the same reason a Save button is: at the bottom of a long page, the way onward is the one thing the reader is looking for.

## Related

- [AstryxOutline](outline.md) — the tracking, the anchors and `topOffset`.
- [AstryxSection](section.md) — the titled band, and how it picks its level.
- [AstryxLayout](layout.md) — the header, panel, footer and `scrollController`.
- [Shell navigation](shell_nav.md) — the same frame around an application rather than a document.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Documentation`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Documentation&component=Documentation) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Documentation&area=Documentation) — both templates arrive with the component filled in.
