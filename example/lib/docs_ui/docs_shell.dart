import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/doc_page_view.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/segmented.dart';
import 'package:flutter/widgets.dart';

/// The chrome around the documentation: navigation, the view controls, and the
/// page itself.
///
/// Built from `astryx_ui` throughout. The only Flutter primitives here are the
/// ones a design system does not supply — scrolling, and a scrollbar.
class DocsShell extends StatelessWidget {
  const DocsShell({super.key});

  /// Below this width the sidebar becomes a dropdown in the top bar.
  static const double _wide = 1000;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    return ColoredBox(
      color: theme.color(AstryxColorToken.backgroundBody),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= _wide;

          return AstryxVStack(
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              _TopBar(wide: wide),
              const AstryxDivider(),
              Expanded(
                child: AstryxHStack(
                  align: AstryxStackAlign.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (wide) ...<Widget>[
                      const _Sidebar(),
                      const AstryxDivider(axis: Axis.vertical),
                    ],
                    Expanded(
                      child: _Content(pageId: controller.pageId),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing4),
        vertical: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        justify: AstryxStackJustify.between,
        wrap: true,
        runGap: AstryxSpacingToken.spacing2,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (!wide) const _NavigationMenu(),
              const AstryxHeading('astryx_ui', level: 5),
              const AstryxBadge('docs', variant: AstryxBadgeVariant.info),
            ],
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxSelector<DocsTheme>(
                label: 'Theme',
                labelHidden: true,
                value: controller.theme,
                width: 170,
                size: AstryxInputSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.viewColumns,
                  size: AstryxIconSize.sm,
                  color: AstryxIconColor.secondary,
                ),
                onChanged: (value) =>
                    controller.theme = value ?? controller.theme,
                options: <AstryxSelectorEntry<DocsTheme>>[
                  for (final theme in DocsTheme.values)
                    AstryxSelectorOption<DocsTheme>(
                      value: theme,
                      label: theme.label,
                    ),
                ],
              ),
              DocsSegmented<AstryxColorMode>(
                label: 'Brightness',
                values: AstryxColorMode.values,
                selected: controller.mode,
                labelOf: (value) => value.name,
                onSelected: (value) => controller.mode = value,
              ),
              DocsSegmented<AstryxDensity?>(
                label: 'Density',
                values: const <AstryxDensity?>[
                  null,
                  AstryxDensity.pointer,
                  AstryxDensity.touch,
                ],
                selected: controller.density,
                labelOf: (value) => value?.name ?? 'auto',
                onSelected: (value) => controller.density = value,
              ),
              DocsSegmented<TextDirection>(
                label: 'Text direction',
                values: TextDirection.values,
                selected: controller.textDirection,
                labelOf: (value) => value.name.toUpperCase(),
                onSelected: (value) => controller.textDirection = value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The narrow-layout replacement for the sidebar.
class _NavigationMenu extends StatelessWidget {
  const _NavigationMenu();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    // The written pages only. Two hundred entries in one menu is not a menu,
    // and a narrow viewport has no room for the sidebar's group headers to make
    // sense of them. Placeholders stay reachable by URL and by the wide layout.
    final groups = <String, List<DocPage>>{};
    for (final page in writtenDocPages) {
      groups.putIfAbsent(page.group, () => <DocPage>[]).add(page);
    }

    return AstryxDropdownMenu(
      label: 'All pages',
      width: 260,
      maxHeight: 420,
      entries: <AstryxMenuEntry>[
        for (final entry in groups.entries) ...<AstryxMenuEntry>[
          AstryxMenuSection(entry.key),
          for (final page in entry.value)
            AstryxMenuItem(
              label: page.title,
              onSelected: () => controller.pageId = page.id,
            ),
        ],
      ],
      triggerBuilder: (context, overlay) => AstryxIconButton(
        icon: AstryxIconName.menu,
        label: 'All pages',
        variant: AstryxButtonVariant.ghost,
        onPressed: overlay.toggle,
      ),
    );
  }
}

class _Sidebar extends StatefulWidget {
  const _Sidebar();

  @override
  State<_Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<_Sidebar> {
  /// The sidebar's own controller.
  ///
  /// Not optional, and not the primary controller: on a desktop or web target
  /// `PrimaryScrollController.shouldInherit` is false, so a scroll view left to
  /// inherit does not attach — while a scrollbar left to inherit still looks
  /// there, finds no position, and throws *The Scrollbar's ScrollController has
  /// no ScrollPosition attached*. Owning the controller makes the pair agree on
  /// every platform.
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
    final query = controller.query.trim().toLowerCase();

    final groups = <String, List<DocPage>>{};
    for (final page in docPages) {
      final matches =
          query.isEmpty ||
          page.title.toLowerCase().contains(query) ||
          page.description.toLowerCase().contains(query);
      // The current page always survives the filter: hiding what you are
      // reading is worse than showing one placeholder.
      final visible =
          !controller.writtenOnly ||
          page.isWritten ||
          page.id == controller.pageId;
      if (matches && visible) {
        groups.putIfAbsent(page.group, () => <DocPage>[]).add(page);
      }
    }

    // A query has to show its matches, wherever they are. Without this a search
    // returns nothing visible whenever the match is in a collapsed group.
    final expandAll = query.isNotEmpty;

    return SizedBox(
      width: 268,
      child: AstryxVStack(
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(
              theme.spacing(AstryxSpacingToken.spacing3),
            ),
            child: AstryxTextInput(
              label: 'Filter pages',
              labelHidden: true,
              placeholder: 'Filter pages',
              size: AstryxInputSize.sm,
              showClear: true,
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
              onChanged: (value) => controller.query = value,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: theme.spacing(AstryxSpacingToken.spacing3),
              end: theme.spacing(AstryxSpacingToken.spacing3),
              bottom: theme.spacing(AstryxSpacingToken.spacing2),
            ),
            child: AstryxSwitch(
              label: 'Written pages only',
              size: AstryxToggleSize.sm,
              value: controller.writtenOnly,
              onChanged: (value) => controller.writtenOnly = value,
            ),
          ),
          Expanded(
            child: _Scroller(
              controller: _scroll,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: theme.spacing(AstryxSpacingToken.spacing2),
                  end: theme.spacing(AstryxSpacingToken.spacing2),
                  bottom: theme.spacing(AstryxSpacingToken.spacing6),
                ),
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    if (groups.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(
                          theme.spacing(AstryxSpacingToken.spacing2),
                        ),
                        child: const AstryxText(
                          'Nothing matches.',
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                        ),
                      ),
                    for (final entry in groups.entries) ...<Widget>[
                      _GroupHeader(
                        group: entry.key,
                        count: entry.value.length,
                        open: expandAll || controller.isGroupOpen(entry.key),
                        onPressed: expandAll
                            ? null
                            : () => controller.toggleGroup(entry.key),
                      ),
                      if (expandAll || controller.isGroupOpen(entry.key))
                        for (final page in entry.value)
                          _NavItem(
                            page: page,
                            selected: page.id == controller.pageId,
                            onPressed: () => controller.pageId = page.id,
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A collapsible group heading in the sidebar.
///
/// The count is not decoration: with most of the site unwritten, knowing that
/// `Chat & AI` holds twelve pages before opening it is the difference between
/// exploring and guessing.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.group,
    required this.count,
    required this.open,
    required this.onPressed,
  });

  final String group;
  final int count;
  final bool open;

  /// Null while a query is filtering, when every group is forced open and a
  /// toggle would do nothing.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      child: AstryxCard(
        variant: AstryxCardVariant.transparent,
        showBorder: false,
        padding: AstryxSpacingToken.spacing2,
        semanticsLabel:
            '$group, $count pages, ${open ? 'expanded' : 'collapsed'}',
        onPressed: onPressed,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxIcon(
              open ? AstryxIconName.chevronDown : AstryxIconName.chevronRight,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            ),
            // A heading, not styled text: it gives the group the heading family
            // and weight, which is what separates it from the items below — and
            // it is announced as a level-6 heading, so a screen reader gets the
            // sidebar's structure rather than a flat list.
            Expanded(child: AstryxHeading(group, level: 6)),
            AstryxText(
              '$count',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.page,
    required this.selected,
    required this.onPressed,
  });

  final DocPage page;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // A pressable card, not a button: a nav item's label sits at the reading
    // edge, and a button centres its label by design. The card brings the hover
    // and press states, the focus ring and the tap target with it.
    return AstryxCard(
      variant: selected
          ? AstryxCardVariant.muted
          : AstryxCardVariant.transparent,
      showBorder: false,
      padding: AstryxSpacingToken.spacing2,
      // Placeholders say so in the accessible name too. A screen-reader user
      // must not have to open the page to find out it is empty.
      semanticsLabel: page.isWritten
          ? page.title
          : '${page.title}, not written yet',
      onPressed: onPressed,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          Expanded(
            child: AstryxText(
              page.title,
              color: selected
                  ? AstryxTextColor.primary
                  : AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
          // The affordance that stops someone clicking through two hundred
          // empty pages one at a time.
          if (!page.isWritten) AstryxBadge(_statusLabel(page.status)),
        ],
      ),
    );
  }
}

/// The shortest honest word for a page's state, for a badge two words wide.
String _statusLabel(DocStatus status) => switch (status) {
  DocStatus.ready => 'Written',
  DocStatus.stub => 'Empty',
  DocStatus.planned => 'Soon',
  DocStatus.notPlanned => 'N/A',
};

class _Content extends StatefulWidget {
  const _Content({required this.pageId});

  final String pageId;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(_Content oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new page starts at its top, not where the last one was left.
    if (oldWidget.pageId != widget.pageId && _scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final ref = controller.page;

    return _Scroller(
      controller: _scroll,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing6),
          vertical: theme.spacing(AstryxSpacingToken.spacing8),
        ),
        child: AstryxCenter(
          axis: AstryxCenterAxis.horizontal,
          maxWidth: 900,
          child: DocsPageView(
            key: ValueKey<String>(ref.page.id),
            page: ref.page,
            previous: ref.previous,
            next: ref.next,
            onNavigate: (target) {
              if (docPageOrNull(target) != null) {
                controller.pageId = target;
              }
            },
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
/// and on desktop and web they decide differently — see the note on
/// `_SidebarState._scroll`.
class _Scroller extends StatelessWidget {
  const _Scroller({required this.controller, required this.child});

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
      child: SingleChildScrollView(
        controller: controller,
        child: child,
      ),
    );
  }
}
