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
