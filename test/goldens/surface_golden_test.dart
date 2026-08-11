@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for Phase 10.
void main() {
  testWidgets('card variants and elevations', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxCard(child: AstryxText('Standard')),
          AstryxCard(
            variant: AstryxCardVariant.muted,
            child: AstryxText('Muted'),
          ),
          AstryxCard(
            variant: AstryxCardVariant.transparent,
            showBorder: false,
            child: AstryxText('Transparent'),
          ),
          AstryxCard(
            variant: AstryxCardVariant.palette(AstryxPalette.purple),
            child: AstryxText('Purple'),
          ),
          AstryxCard(
            elevation: AstryxElevation.med,
            child: AstryxText('Elevated'),
          ),
        ],
      ),
      name: 'card.variants',
      surfaceSize: const Size(320, 400),
      disableAnimations: true,
    );
  });

  testWidgets('a card with header, body and footer', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxCard(
        header: const AstryxHeading('Usage', type: AstryxHeadingType.display3),
        footer: AstryxButton(label: 'See details', onPressed: () {}),
        child: const AstryxText('4,201 requests this month.'),
      ),
      name: 'card.slots',
      surfaceSize: const Size(340, 260),
      // The footer aligns to the reading-end edge, so RTL is a real change.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a selectable card in both controls and both states', (
    tester,
  ) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSelectableCard(
            label: 'Free',
            selected: false,
            onSelectedChanged: (_) {},
            child: const AstryxText('Unselected checkbox'),
          ),
          AstryxSelectableCard(
            label: 'Pro',
            selected: true,
            onSelectedChanged: (_) {},
            child: const AstryxText('Selected checkbox'),
          ),
          AstryxSelectableCard(
            label: 'Enterprise',
            selected: true,
            control: AstryxSelectableCardControl.radio,
            controlSize: AstryxToggleSize.sm,
            padding: AstryxSpacingToken.spacing3,
            onSelectedChanged: (_) {},
            child: const AstryxText('Selected radio, small'),
          ),
          AstryxSelectableCard(
            label: 'Unavailable',
            selected: true,
            enabled: false,
            onSelectedChanged: (_) {},
            child: const AstryxText('Selected but disabled'),
          ),
        ],
      ),
      name: 'selectable_card',
      surfaceSize: const Size(340, 320),
      // The control sits at the reading-start edge, so RTL is a real change.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a list of rows, ruled and selected', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxList(
        label: 'Team',
        showDividers: true,
        children: <Widget>[
          AstryxItem(
            leading: const AstryxIcon(AstryxIconName.check),
            label: 'Ada Lovelace',
            description: 'Owner',
            trailing: const AstryxBadge('Active'),
            onPressed: () {},
          ),
          AstryxItem(
            label: 'Alan Turing',
            description: 'Admin',
            selected: true,
            onPressed: () {},
          ),
          AstryxItem(
            label: 'Grace Hopper',
            description: 'Invited',
            enabled: false,
            onPressed: () {},
          ),
        ],
      ),
      name: 'list',
      surfaceSize: const Size(360, 220),
      // The leading icon and the trailing badge swap edges, so RTL is a real
      // change.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a tree, part open', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxTreeList(
        label: 'Files',
        selected: 'main',
        initiallyExpanded: <String>{'lib'},
        nodes: <AstryxTreeNode>[
          AstryxTreeNode(
            id: 'lib',
            label: 'lib',
            children: <AstryxTreeNode>[
              AstryxTreeNode(id: 'main', label: 'main.dart'),
              AstryxTreeNode(
                id: 'components',
                label: 'components',
                children: <AstryxTreeNode>[
                  AstryxTreeNode(id: 'item', label: 'item.dart'),
                ],
              ),
            ],
          ),
          AstryxTreeNode(id: 'readme', label: 'README.md'),
        ],
      ),
      name: 'tree_list',
      surfaceSize: const Size(320, 200),
      // The indent and the chevron both mirror.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('an empty state beside its metadata', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxEmptyState(
            size: AstryxEmptyStateSize.compact,
            icon: const AstryxIcon(AstryxIconName.search),
            title: 'No deploys yet',
            description: 'Push to main and the first will show here.',
            actions: <Widget>[
              AstryxButton(label: 'Read the guide', onPressed: () {}),
            ],
          ),
          const AstryxMetadataList(
            direction: AstryxMetadataListDirection.inline,
            labelWidth: 100,
            items: <AstryxMetadataItem>[
              AstryxMetadataItem(
                label: 'Owner',
                value: AstryxText('Ada Lovelace'),
                semanticsValue: 'Ada Lovelace',
              ),
              AstryxMetadataItem(
                label: 'Status',
                value: AstryxBadge('Live', variant: AstryxBadgeVariant.success),
                semanticsValue: 'Live',
              ),
            ],
          ),
        ],
      ),
      name: 'empty_state',
      surfaceSize: const Size(380, 320),
      disableAnimations: true,
    );
  });

  testWidgets('code, a quotation and a chord', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxCode('--color-accent'),
              AstryxKbd.chord(<String>['Ctrl', 'K']),
            ],
          ),
          AstryxCodeBlock(
            'void main() {\n  runApp(const App());\n}',
            language: 'dart',
            showLineNumbers: true,
          ),
          AstryxBlockquote(
            'The deploy took eleven minutes.',
            attribution: 'Postmortem, 3 March',
          ),
        ],
      ),
      name: 'code',
      surfaceSize: const Size(360, 320),
      // The block's header, the quote's rule and the line numbers all sit on
      // a reading edge.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the shell, wide and compact', (tester) async {
    Widget shell({required double width}) => SizedBox(
      width: width,
      height: 260,
      child: const AstryxAppShell(
        compactBelow: 500,
        header: Padding(
          padding: EdgeInsets.all(12),
          child: AstryxText('Acme', type: AstryxTextType.label),
        ),
        sidebar: AstryxList(
          label: 'Sections',
          density: AstryxItemDensity.compact,
          children: <Widget>[
            AstryxItem(label: 'Deploys', selected: true),
            AstryxItem(label: 'Environments'),
          ],
        ),
        child: AstryxLayout(
          header: AstryxHeading('Deploys', type: AstryxHeadingType.display3),
          footer: AstryxText('3 running'),
          child: AstryxText('The body scrolls; the bands do not.'),
        ),
      ),
    );

    await expectAstryxGolden(
      tester,
      // Not `stretch`: a stretched child is handed a tight width, and both
      // shells would then be measured at the frame's own width.
      AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        children: <Widget>[shell(width: 600), shell(width: 360)],
      ),
      name: 'app_shell',
      surfaceSize: const Size(620, 580),
      // The navigation sits at the reading-start edge, and the page's bands
      // run its full width.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a section, a handle and an outline', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: AstryxSection(
              title: 'Environments',
              description: 'Where this project is deployed.',
              showDivider: true,
              actions: <Widget>[
                AstryxButton(
                  label: 'New',
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
              child: const AstryxSection(
                title: 'Production',
                child: AstryxText('Heading level 3, without being told.'),
              ),
            ),
          ),
          const AstryxResizeHandle(label: 'Resize', size: 200),
          const SizedBox(
            width: 130,
            child: AstryxOutline(
              activeId: 'usage',
              entries: <AstryxOutlineEntry>[
                AstryxOutlineEntry(id: 'setup', label: 'Setup'),
                AstryxOutlineEntry(id: 'usage', label: 'Usage'),
                AstryxOutlineEntry(id: 'tokens', label: 'Tokens', level: 3),
              ],
            ),
          ),
        ],
      ),
      name: 'section',
      surfaceSize: const Size(460, 240),
      // The outline's rule, the section's actions and the indent are all on a
      // reading edge.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the rail, expanded and collapsed, over a trail', (tester) async {
    const entries = <AstryxNavEntry>[
      AstryxNavItem(
        id: 'deploys',
        label: 'Deploys',
        icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
        trailing: AstryxBadge('3'),
      ),
      AstryxNavSection(
        label: 'Settings',
        items: <AstryxNavItem>[
          AstryxNavItem(
            id: 'members',
            label: 'Members',
            icon: AstryxNavIcon(AstryxIcon(AstryxIconName.check)),
          ),
          AstryxNavItem(
            id: 'billing',
            label: 'Billing',
            icon: AstryxNavIcon(AstryxIcon(AstryxIconName.clock)),
            enabled: false,
          ),
        ],
      ),
    ];

    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          SizedBox(
            height: 190,
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing4,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: AstryxSideNav(
                    entries: entries,
                    selectedId: 'deploys',
                    onSelected: (_) {},
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: AstryxSideNav(
                    entries: entries,
                    selectedId: 'deploys',
                    collapsed: true,
                    onSelected: (_) {},
                  ),
                ),
              ],
            ),
          ),
          AstryxBreadcrumbs(
            items: <AstryxBreadcrumb>[
              AstryxBreadcrumb(label: 'Projects', onPressed: () {}),
              AstryxBreadcrumb(label: 'astryx_ui', onPressed: () {}),
              AstryxBreadcrumb(label: 'Environments', onPressed: () {}),
              const AstryxBreadcrumb(label: 'production'),
            ],
          ),
        ],
      ),
      name: 'navigation',
      surfaceSize: const Size(420, 280),
      // The rail, the icon slots and the trail all sit on a reading edge.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('every badge variant', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxBadge('Neutral'),
              AstryxBadge('Info', variant: AstryxBadgeVariant.info),
              AstryxBadge('Success', variant: AstryxBadgeVariant.success),
              AstryxBadge('Warning', variant: AstryxBadgeVariant.warning),
              AstryxBadge('Error', variant: AstryxBadgeVariant.error),
            ],
          ),
          _PaletteRow(<AstryxPalette>[
            AstryxPalette.blue,
            AstryxPalette.cyan,
            AstryxPalette.gray,
            AstryxPalette.green,
            AstryxPalette.orange,
          ]),
          _PaletteRow(<AstryxPalette>[
            AstryxPalette.pink,
            AstryxPalette.purple,
            AstryxPalette.red,
            AstryxPalette.teal,
            AstryxPalette.yellow,
          ]),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxBadge(
                'With icon',
                icon: AstryxIcon(AstryxIconName.check),
                variant: AstryxBadgeVariant.success,
              ),
            ],
          ),
        ],
      ),
      name: 'badge.variants',
      surfaceSize: const Size(480, 200),
      disableAnimations: true,
    );
  });

  testWidgets('every banner status', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final status in AstryxBannerStatus.values)
            AstryxBanner(
              status: status,
              title:
                  '${status.name[0].toUpperCase()}'
                  '${status.name.substring(1)}',
              description: 'Supporting detail for the ${status.name} case.',
              onDismiss: () {},
            ),
        ],
      ),
      name: 'banner.statuses',
      surfaceSize: const Size(520, 380),
      // The icon leads and the dismiss button trails, so both flip.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a banner with actions and extra content', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxBanner(
        status: AstryxBannerStatus.error,
        title: 'Could not save',
        actions: <Widget>[AstryxButton(label: 'Retry', onPressed: () {})],
        content: const AstryxText('Email, postcode and phone were rejected.'),
      ),
      name: 'banner.content',
      surfaceSize: const Size(520, 200),
      disableAnimations: true,
    );
  });

  testWidgets('tabs at every size', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        children: <Widget>[
          for (final size in AstryxTabSize.values)
            AstryxTabList<String>(
              size: size,
              value: 'activity',
              onChanged: (_) {},
              tabs: const <AstryxTab<String>>[
                AstryxTab(value: 'overview', label: 'Overview'),
                AstryxTab(value: 'activity', label: 'Activity'),
                AstryxTab(
                  value: 'settings',
                  label: 'Settings',
                  enabled: false,
                ),
              ],
            ),
        ],
      ),
      name: 'tab_list.sizes',
      surfaceSize: const Size(420, 260),
      // The selected indicator sits under the second tab, which moves.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a table with sorting, selection and striping', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxTable<_Row>(
        rows: const <_Row>[
          _Row('a', 'Alpha', 30),
          _Row('b', 'Bravo', 200),
          _Row('c', 'Charlie', 3),
        ],
        keyOf: (row) => row.id,
        striped: true,
        selectionMode: AstryxTableSelectionMode.multiple,
        selected: const <Object>{'b'},
        onSelectionChanged: (_) {},
        sort: const AstryxTableSort('name', AstryxSortDirection.ascending),
        onSortChanged: (_) {},
        rowLabelOf: (row) => row.name,
        columns: <AstryxTableColumn<_Row>>[
          AstryxTableColumn<_Row>(
            id: 'name',
            header: 'Name',
            compare: (a, b) => a.name.compareTo(b.name),
            cellBuilder: (context, row) => AstryxText(row.name),
          ),
          AstryxTableColumn<_Row>(
            id: 'count',
            header: 'Count',
            width: const AstryxTableColumnWidth.fixed(100),
            alignment: AstryxTableAlignment.end,
            compare: (a, b) => a.count.compareTo(b.count),
            cellBuilder: (context, row) => AstryxText('${row.count}'),
          ),
        ],
      ),
      name: 'table',
      surfaceSize: const Size(520, 260),
      // The checkbox column leads and the numeric column aligns to the
      // reading-end edge, so RTL moves both.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('a table at every density', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final density in AstryxTableDensity.values)
            AstryxTable<_Row>(
              density: density,
              rows: const <_Row>[_Row('a', 'Alpha', 30)],
              keyOf: (row) => row.id,
              columns: <AstryxTableColumn<_Row>>[
                AstryxTableColumn<_Row>(
                  id: 'name',
                  header: density.name,
                  cellBuilder: (context, row) => AstryxText(row.name),
                ),
              ],
            ),
        ],
      ),
      name: 'table.densities',
      surfaceSize: const Size(400, 400),
      disableAnimations: true,
    );
  });
}

/// A row of five badges, one per palette.
///
/// A widget rather than a `for` inside a `const` list — Dart has no constant
/// `for` element, and the list is worth keeping const.
class _PaletteRow extends StatelessWidget {
  const _PaletteRow(this.palettes);

  final List<AstryxPalette> palettes;

  @override
  Widget build(BuildContext context) => AstryxHStack(
    gap: AstryxSpacingToken.spacing2,
    children: <Widget>[
      for (final palette in palettes)
        AstryxBadge('Aa', variant: AstryxBadgeVariant.palette(palette)),
    ],
  );
}

class _Row {
  const _Row(this.id, this.name, this.count);

  final String id;
  final String name;
  final int count;
}
