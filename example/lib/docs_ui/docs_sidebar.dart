/// The sidebar: what the current section holds.
///
/// For components it is upstream's shape — one alphabetical list, with a
/// family folded under its root (`Button` holds `Button Group`), and the hooks
/// and providers in two folding sections at the end. For the guides and the
/// templates it is the pages in registry order.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/categories.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:flutter/widgets.dart';

/// One row in the sidebar's model: a page, perhaps with a folded family.
class DocsNavEntry {
  const DocsNavEntry(this.page, {this.children = const <DocPage>[]});

  final DocPage page;

  /// The pages folded under [page], alphabetical. Empty for most.
  final List<DocPage> children;

  /// The name the row shows.
  String get name => docDisplayName(page);
}

/// The component pages as an alphabetical list of families.
///
/// A page joins the family of the shortest other component name its own name
/// starts with — `Button Group` under `Button`, `Toggle Button Group` under
/// `Toggle Button` — which is how upstream folds its sidebar, without anybody
/// having to maintain the families by hand.
List<DocsNavEntry> docsComponentFamilies(Iterable<DocPage> pages) {
  final sorted = pages.toList()
    ..sort((a, b) => docDisplayName(a).compareTo(docDisplayName(b)));
  final names = <DocPage, String>{for (final p in sorted) p: docDisplayName(p)};

  DocPage? rootOf(DocPage page) {
    final name = names[page]!;
    DocPage? best;
    for (final other in sorted) {
      if (other == page) continue;
      final candidate = names[other]!;
      if (name.startsWith('$candidate ') &&
          (best == null || candidate.length < names[best]!.length)) {
        best = other;
      }
    }
    return best;
  }

  final children = <DocPage, List<DocPage>>{};
  final roots = <DocPage>[];
  for (final page in sorted) {
    final root = rootOf(page);
    if (root == null) {
      roots.add(page);
    } else {
      children.putIfAbsent(root, () => <DocPage>[]).add(page);
    }
  }
  return <DocsNavEntry>[
    for (final root in roots)
      DocsNavEntry(root, children: children[root] ?? const <DocPage>[]),
  ];
}

/// The sidebar.
class DocsSidebar extends StatefulWidget {
  const DocsSidebar({super.key});

  /// The sidebar's width.
  static const double width = 260;

  @override
  State<DocsSidebar> createState() => _DocsSidebarState();
}

class _DocsSidebarState extends State<DocsSidebar> {
  /// Owned, not inherited — see the note on `DocsScroller`.
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final section = controller.section;
    final query = controller.query.trim().toLowerCase();

    bool matches(DocPage page) =>
        query.isEmpty ||
        docDisplayName(page).toLowerCase().contains(query) ||
        page.title.toLowerCase().contains(query) ||
        page.description.toLowerCase().contains(query);

    final inSection = docPages
        .where((page) => docsSectionOf(page) == section)
        .toList();

    final rows = <Widget>[];
    void addHeading(String text) => rows.add(
      Padding(
        padding: EdgeInsetsDirectional.only(
          start: theme.spacing(AstryxSpacingToken.spacing2),
          top: theme.spacing(AstryxSpacingToken.spacing4),
          bottom: theme.spacing(AstryxSpacingToken.spacing1),
        ),
        child: AstryxText(
          text,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
    );

    if (section == DocsSection.components) {
      if (query.isEmpty) {
        rows.add(
          DocsNavRow(
            label: 'Overview',
            selected: controller.onComponentsOverview,
            onPressed: controller.goComponents,
          ),
        );
      }
      final components = inSection
          .where(
            (page) =>
                docCategory(page) != null || page.status != DocStatus.ready,
          )
          .where(
            (page) =>
                page.group != DocGroup.hooks &&
                page.group != DocGroup.providers,
          )
          .toList();
      if (query.isNotEmpty) {
        // A query is a flat list of matches: a family folded shut would hide
        // exactly the row being searched for.
        final hits = components.where(matches).toList()
          ..sort((a, b) => docDisplayName(a).compareTo(docDisplayName(b)));
        for (final page in hits) {
          rows.add(_pageRow(controller, page));
        }
      } else {
        for (final entry in docsComponentFamilies(components)) {
          rows.addAll(_familyRows(controller, entry));
        }
      }
      for (final group in <String>[DocGroup.hooks, DocGroup.providers]) {
        final pages = inSection
            .where((page) => page.group == group && matches(page))
            .toList();
        if (pages.isEmpty) continue;
        final open =
            query.isNotEmpty ||
            controller.isGroupOpen(group) ||
            pages.any((page) => _isCurrent(controller, page));
        rows.add(
          DocsNavRow(
            label: group,
            expanded: open,
            onToggle: query.isNotEmpty
                ? null
                : () => controller.toggleGroup(group),
            onPressed: query.isNotEmpty
                ? null
                : () => controller.toggleGroup(group),
          ),
        );
        if (open) {
          for (final page in pages) {
            rows.add(_pageRow(controller, page, depth: 1));
          }
        }
      }
    } else {
      // Guides and templates keep their registry order — it is a reading
      // order, from installation onwards.
      for (final page in inSection.where(matches)) {
        rows.add(_pageRow(controller, page));
      }
    }

    if (rows.isEmpty) addHeading('Nothing matches.');

    return SizedBox(
      width: DocsSidebar.width,
      child: AstryxVStack(
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing3)),
            child: AstryxTextInput(
              key: ValueKey<DocsSection>(section),
              label: 'Search ${section.label.toLowerCase()}',
              labelHidden: true,
              placeholder: 'Search ${section.label.toLowerCase()}…',
              showClear: true,
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
              onChanged: (value) => controller.query = value,
            ),
          ),
          Expanded(
            child: DocsScroller(
              controller: _scroll,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: theme.spacing(AstryxSpacingToken.spacing2),
                  end: theme.spacing(AstryxSpacingToken.spacing2),
                  bottom: theme.spacing(AstryxSpacingToken.spacing6),
                ),
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing0,
                  align: AstryxStackAlign.stretch,
                  children: rows,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrent(DocsController controller, DocPage page) =>
      !controller.onComponentsOverview &&
      !controller.onLanding &&
      controller.pageId == page.id;

  Widget _pageRow(DocsController controller, DocPage page, {int depth = 0}) =>
      DocsNavRow(
        label: docDisplayName(page),
        depth: depth,
        selected: _isCurrent(controller, page),
        badge: page.isWritten ? null : _statusLabel(page.status),
        onPressed: () => controller.pageId = page.id,
      );

  List<Widget> _familyRows(DocsController controller, DocsNavEntry entry) {
    if (entry.children.isEmpty) {
      return <Widget>[_pageRow(controller, entry.page)];
    }

    final key = 'family:${entry.name}';
    final members = <DocPage>[entry.page, ...entry.children];
    final open =
        controller.isGroupOpen(key) ||
        members.any((page) => _isCurrent(controller, page));

    return <Widget>[
      DocsNavRow(
        label: entry.name,
        expanded: open,
        semanticsHint: '${members.length} pages',
        onToggle: () => controller.toggleGroup(key),
        // Upstream opens the family rather than navigating: the root's own
        // page is the first row inside it.
        onPressed: () => controller.toggleGroup(key),
      ),
      if (open)
        for (final page in members) _pageRow(controller, page, depth: 1),
    ];
  }
}

/// The shortest honest word for a page's state, for a badge two words wide.
String _statusLabel(DocStatus status) => switch (status) {
  DocStatus.ready => 'Written',
  DocStatus.stub => 'Empty',
  DocStatus.planned => 'Soon',
  DocStatus.notPlanned => 'N/A',
};

/// One sidebar row: a page, or a folding family or section.
class DocsNavRow extends StatelessWidget {
  const DocsNavRow({
    required this.label,
    super.key,
    this.selected = false,
    this.depth = 0,
    this.expanded,
    this.onToggle,
    this.onPressed,
    this.badge,
    this.semanticsHint,
  });

  final String label;
  final bool selected;

  /// 0 at the edge, 1 inside a family.
  final int depth;

  /// Null for a plain page; whether it is open for a family or section.
  final bool? expanded;

  final VoidCallback? onToggle;
  final VoidCallback? onPressed;

  /// A status badge for a placeholder page.
  final String? badge;

  final String? semanticsHint;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final folding = expanded != null;
    final semantics = <String>[
      label,
      if (badge != null) 'not written yet',
      if (folding) expanded! ? 'expanded' : 'collapsed',
      ?semanticsHint,
    ].join(', ');

    // A pressable card, not a button: a nav item's label sits at the reading
    // edge, and a button centres its label by design.
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: theme.spacing(AstryxSpacingToken.spacing4) * depth,
      ),
      // The current page gets a painted fill: the card's muted variant is
      // transparent in some themes, and "you are here" must show in all.
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? theme.color(AstryxColorToken.backgroundMuted)
              : null,
          borderRadius: theme.borderRadius(AstryxRadiusToken.element),
        ),
        child: AstryxCard(
          variant: AstryxCardVariant.transparent,
          showBorder: false,
          padding: AstryxSpacingToken.spacing2,
          semanticsLabel: semantics,
          onPressed: onPressed,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              Expanded(
                child: AstryxText(
                  label,
                  color: selected || folding
                      ? AstryxTextColor.primary
                      : AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
              if (badge != null) AstryxBadge(badge!),
              if (folding)
                // Turned rather than swapped: the registry names no chevron-up.
                AnimatedRotation(
                  turns: expanded! ? 0.5 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: const AstryxIcon(
                    AstryxIconName.chevronDown,
                    size: AstryxIconSize.sm,
                    color: AstryxIconColor.secondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical scrolling with a scrollbar that is always reachable.
///
/// [controller] is required. A null controller means the scroll view and the
/// scrollbar each decide separately whether to inherit the primary controller,
/// and on desktop and web they decide differently: on those targets
/// `PrimaryScrollController.shouldInherit` is false, so a scroll view left to
/// inherit does not attach while a scrollbar left to inherit still looks there
/// and throws.
class DocsScroller extends StatelessWidget {
  const DocsScroller({
    required this.controller,
    required this.child,
    super.key,
  });

  final Widget child;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return RawScrollbar(
      controller: controller,
      thumbColor: theme.color(AstryxColorToken.borderEmphasized),
      radius: const Radius.circular(8),
      thickness: 8,
      child: SingleChildScrollView(controller: controller, child: child),
    );
  }
}
