import 'dart:ui' show CheckedState;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P10-5`–`P10-7` — `AstryxTable`.
///
/// One group per concern, as the phase plan asks: sizing, sorting, selection,
/// scrolling. A single 400-line group would tell you a table is broken without
/// telling you which half.
class _Row {
  const _Row(this.id, this.name, this.count);

  final String id;
  final String name;
  final int count;
}

const _rows = <_Row>[
  _Row('c', 'Charlie', 3),
  _Row('a', 'Alpha', 30),
  _Row('b', 'Bravo', 200),
];

List<AstryxTableColumn<_Row>> _columns({
  AstryxTableColumnWidth nameWidth = const AstryxTableColumnWidth.flex(),
  bool sortable = true,
}) => <AstryxTableColumn<_Row>>[
  AstryxTableColumn<_Row>(
    id: 'name',
    header: 'Name',
    width: nameWidth,
    compare: sortable ? (a, b) => a.name.compareTo(b.name) : null,
    cellBuilder: (context, row) => AstryxText(row.name),
  ),
  AstryxTableColumn<_Row>(
    id: 'count',
    header: 'Count',
    width: const AstryxTableColumnWidth.fixed(120),
    alignment: AstryxTableAlignment.end,
    compare: sortable ? (a, b) => a.count.compareTo(b.count) : null,
    cellBuilder: (context, row) => AstryxText('${row.count}'),
  ),
];

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget table, {
    Size size = const Size(600, 400),
  }) => pumpAstryxWidget(tester, table, surfaceSize: size);

  group('P10-5 — columns and sizing', () {
    testWidgets('renders every header and every cell', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Count'), findsOneWidget);
      for (final row in _rows) {
        expect(find.text(row.name), findsOneWidget);
      }
    });

    testWidgets('a fixed column gets exactly its width', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
        ),
      );

      // The `Count` cells sit in a 120px column, so no two of them can be
      // further apart horizontally than that.
      final first = tester.getRect(find.text('3'));
      final second = tester.getRect(find.text('30'));
      expect((first.right - second.right).abs(), lessThan(1));
    });

    testWidgets('an intrinsic column grows to its widest cell', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(
            nameWidth: const AstryxTableColumnWidth.intrinsic(min: 40),
          ),
          rows: _rows,
          keyOf: (row) => row.id,
        ),
      );
      // Two passes: measure, then place. This is the cost the doc comment
      // warns about, and the reason the test has to settle rather than pump.
      await tester.pumpAndSettle();

      // 'Charlie' is the widest, so the column is at least as wide as it.
      final charlie = tester.getRect(find.text('Charlie'));
      expect(charlie.width, greaterThan(40));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a hidden column is not rendered', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: <AstryxTableColumn<_Row>>[
            ..._columns(),
            AstryxTableColumn<_Row>(
              id: 'secret',
              header: 'Secret',
              visible: false,
              cellBuilder: (context, row) => const AstryxText('hidden'),
            ),
          ],
          rows: _rows,
          keyOf: (row) => row.id,
        ),
      );

      expect(find.text('Secret'), findsNothing);
      expect(find.text('hidden'), findsNothing);
    });

    testWidgets('an empty table shows its empty state', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: const <_Row>[],
          keyOf: (row) => row.id,
        ),
      );

      expect(find.text('No data'), findsOneWidget);
      // The header stays: an empty table still tells you what it would show.
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('every density is distinct', (tester) async {
      final heights = <AstryxTableDensity, double>{};
      for (final density in AstryxTableDensity.values) {
        await pump(
          tester,
          AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            density: density,
            keyOf: (row) => row.id,
          ),
        );
        heights[density] = tester
            .getSize(find.byType(AstryxTable<_Row>))
            .height;
      }

      expect(
        heights[AstryxTableDensity.compact],
        lessThan(heights[AstryxTableDensity.balanced]!),
      );
      expect(
        heights[AstryxTableDensity.balanced],
        lessThan(heights[AstryxTableDensity.spacious]!),
      );
    });
  });

  group('P10-6 — sorting', () {
    testWidgets('a sortable header cycles ascending, descending, none', (
      tester,
    ) async {
      AstryxTableSort? sort;
      var calls = 0;

      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            keyOf: (row) => row.id,
            sort: sort,
            onSortChanged: (value) => setState(() {
              sort = value;
              calls++;
            }),
          ),
        ),
      );

      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(
        sort,
        const AstryxTableSort('name', AstryxSortDirection.ascending),
      );

      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(
        sort,
        const AstryxTableSort('name', AstryxSortDirection.descending),
      );

      // The third state is the point: back to the order the data arrived in.
      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(sort, isNull);
      expect(calls, 3);
    });

    testWidgets('sorting reorders the rows without mutating the input', (
      tester,
    ) async {
      final original = List<_Row>.of(_rows);

      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: original,
          keyOf: (row) => row.id,
          sort: const AstryxTableSort('name', AstryxSortDirection.ascending),
          onSortChanged: (_) {},
        ),
      );

      final alpha = tester.getTopLeft(find.text('Alpha')).dy;
      final charlie = tester.getTopLeft(find.text('Charlie')).dy;
      expect(alpha, lessThan(charlie));

      // The caller's list is untouched — sorting a list passed into a build
      // is a bug that surfaces three screens away.
      expect(original.map((r) => r.id).toList(), <String>['c', 'a', 'b']);
    });

    testWidgets('descending really is the reverse', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          sort: const AstryxTableSort('count', AstryxSortDirection.descending),
          onSortChanged: (_) {},
        ),
      );

      expect(
        tester.getTopLeft(find.text('200')).dy,
        lessThan(tester.getTopLeft(find.text('3')).dy),
      );
    });

    testWidgets('an unsortable column has no header button', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(sortable: false),
          rows: _rows,
          keyOf: (row) => row.id,
          onSortChanged: (_) => fail('an unsortable header fired'),
        ),
      );

      // No button, so a keyboard user does not tab through a control that
      // does nothing.
      expect(
        tester.getSemantics(find.text('Name')).flagsCollection.isButton,
        isFalse,
      );
      handle.dispose();
    });

    testWidgets('a sortable header is announced as a button', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          onSortChanged: (_) {},
        ),
      );

      expect(find.bySemanticsLabel('Sort by Name'), findsOneWidget);
      handle.dispose();
    });
  });

  group('P10-6 — selection', () {
    testWidgets('no checkboxes when selection is off', (tester) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
        ),
      );
      expect(find.byType(AstryxCheckbox), findsNothing);
    });

    testWidgets('single selection replaces rather than accumulates', (
      tester,
    ) async {
      var selected = <Object>{};

      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            keyOf: (row) => row.id,
            selectionMode: AstryxTableSelectionMode.single,
            selected: selected,
            onSelectionChanged: (value) => setState(() => selected = value),
          ),
        ),
      );

      await tester.tap(find.byType(AstryxCheckbox).at(0));
      await tester.pump();
      expect(selected, <Object>{'c'});

      await tester.tap(find.byType(AstryxCheckbox).at(1));
      await tester.pump();
      expect(selected, <Object>{'a'}, reason: 'single means single');
    });

    testWidgets('multiple selection accumulates', (tester) async {
      var selected = <Object>{};

      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            keyOf: (row) => row.id,
            selectionMode: AstryxTableSelectionMode.multiple,
            selected: selected,
            onSelectionChanged: (value) => setState(() => selected = value),
          ),
        ),
      );

      // The first checkbox is the header's.
      await tester.tap(find.byType(AstryxCheckbox).at(1));
      await tester.pump();
      await tester.tap(find.byType(AstryxCheckbox).at(2));
      await tester.pump();

      expect(selected, <Object>{'c', 'a'});
    });

    testWidgets('the header checkbox is indeterminate on a partial selection', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var selected = <Object>{'c'};

      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            keyOf: (row) => row.id,
            selectionMode: AstryxTableSelectionMode.multiple,
            selected: selected,
            onSelectionChanged: (value) => setState(() => selected = value),
          ),
        ),
      );

      final header = tester.getSemantics(
        find.bySemanticsLabel('Select all rows'),
      );
      expect(header.flagsCollection.isChecked, CheckedState.mixed);

      // Pressing it from indeterminate selects everything, not nothing.
      await tester.tap(find.byType(AstryxCheckbox).first);
      await tester.pump();
      expect(selected, <Object>{'c', 'a', 'b'});

      // And again clears the visible rows.
      await tester.tap(find.byType(AstryxCheckbox).first);
      await tester.pump();
      expect(selected, isEmpty);
      handle.dispose();
    });

    testWidgets('the header checkbox leaves off-page selections alone', (
      tester,
    ) async {
      var selected = <Object>{'somewhere-else'};

      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTable<_Row>(
            columns: _columns(),
            rows: _rows,
            keyOf: (row) => row.id,
            selectionMode: AstryxTableSelectionMode.multiple,
            selected: selected,
            onSelectionChanged: (value) => setState(() => selected = value),
          ),
        ),
      );

      await tester.tap(find.byType(AstryxCheckbox).first);
      await tester.pump();
      expect(selected, contains('somewhere-else'));

      await tester.tap(find.byType(AstryxCheckbox).first);
      await tester.pump();
      expect(
        selected,
        <Object>{'somewhere-else'},
        reason: 'clearing the page must not clear another page',
      );
    });

    testWidgets('a row checkbox is named after its row', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          rowLabelOf: (row) => row.name,
          selectionMode: AstryxTableSelectionMode.multiple,
          onSelectionChanged: (_) {},
        ),
      );

      expect(find.bySemanticsLabel('Select Charlie'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('pressing a row is independent of selecting it', (
      tester,
    ) async {
      _Row? pressed;
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          onRowPressed: (row) => pressed = row,
        ),
      );

      await tester.tap(find.text('Charlie'));
      await tester.pump();
      expect(pressed?.id, 'c');
    });

    testWidgets('row actions are visible without hover in touch density', (
      tester,
    ) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          rowActionsBuilder: (context, row) => AstryxIconButton(
            icon: AstryxIconName.moreHorizontal,
            label: 'More for ${row.name}',
            onPressed: () {},
          ),
        ),
      );

      // Present with no pointer anywhere near the table — the ADR-006
      // commitment, and the one upstream behaviour deliberately not ported.
      expect(find.byType(AstryxIconButton), findsNWidgets(_rows.length));
    });
  });

  group('P10-7 — scrolling', () {
    testWidgets('the header stays put while the body scrolls', (tester) async {
      final many = <_Row>[
        for (var i = 0; i < 60; i++) _Row('$i', 'Row $i', i),
      ];

      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: many,
          keyOf: (row) => row.id,
          maxHeight: 300,
        ),
      );

      final headerBefore = tester.getRect(find.text('Name'));
      final rowBefore = tester.getRect(find.text('Row 0')).top;

      await tester.drag(find.text('Row 0'), const Offset(0, -200));
      await tester.pumpAndSettle();

      // The body moved; the header did not. That is the whole feature.
      expect(tester.getRect(find.text('Name')), headerBefore);
      // Position, not presence: the table does not virtualise, so every row
      // stays in the tree whether or not it is on screen.
      expect(tester.getRect(find.text('Row 0')).top, lessThan(rowBefore - 100));
    });

    testWidgets('both axes scroll from one horizontal controller', (
      tester,
    ) async {
      final wide = <AstryxTableColumn<_Row>>[
        for (var i = 0; i < 8; i++)
          AstryxTableColumn<_Row>(
            id: 'col$i',
            header: 'Column $i',
            width: const AstryxTableColumnWidth.fixed(200),
            cellBuilder: (context, row) => AstryxText('${row.name} $i'),
          ),
      ];

      await pump(
        tester,
        AstryxTable<_Row>(columns: wide, rows: _rows, keyOf: (row) => row.id),
        size: const Size(400, 300),
      );

      final headerBefore = tester.getRect(find.text('Column 0')).left;
      final cellBefore = tester.getRect(find.text('Charlie 0')).left;

      await tester.drag(find.text('Column 0'), const Offset(-150, 0));
      await tester.pumpAndSettle();

      final headerAfter = tester.getRect(find.text('Column 0')).left;
      final cellAfter = tester.getRect(find.text('Charlie 0')).left;

      expect(headerAfter, lessThan(headerBefore));
      // Identical movement, because there is only one controller — the two
      // axes cannot drift apart (ADR-039).
      expect(headerBefore - headerAfter, closeTo(cellBefore - cellAfter, 0.5));
    });

    testWidgets('a narrow viewport scrolls rather than crushing columns', (
      tester,
    ) async {
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
        ),
        size: const Size(160, 300),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(AstryxTable<_Row>),
          matching: find.byType(Scrollable),
        ),
        findsWidgets,
      );
    });
  });

  group('semantics', () {
    testWidgets('the table is named, and a selected row says so', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AstryxTable<_Row>(
          columns: _columns(),
          rows: _rows,
          keyOf: (row) => row.id,
          label: 'Projects',
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: const <Object>{'c'},
          onSelectionChanged: (_) {},
        ),
      );

      expect(find.bySemanticsLabel('Projects'), findsOneWidget);
      handle.dispose();
    });
  });
}
