/// A table whose rows are grouped under collapsible headers.
///
/// **`AstryxTable` has no row grouping**, and a header row faked out of a data
/// row would be a header row that a screen reader announces as data, that
/// sorting reorders into the middle of the set, and that a checkbox column
/// offers to select. So this is not one table with special rows: it is *one
/// table per group*, each inside an `AstryxCollapsible`, sharing one sort and
/// one selection.
///
/// The trade is stated on the page. Every group's columns are declared once and
/// given the same widths, which is what keeps them lined up down the screen —
/// and what you have to remember if you copy this.
///
/// Not exported. A composition worth copying.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_table_grouped -> GroupedTableTemplate
/// One line of spend.
typedef Expense = ({
  String id,
  String vendor,
  String team,
  String status,
  int amount,
  String submitted,
});

class GroupedTableTemplate extends StatefulWidget {
  const GroupedTableTemplate({super.key});

  @override
  State<GroupedTableTemplate> createState() => _GroupedTableTemplateState();
}

class _GroupedTableTemplateState extends State<GroupedTableTemplate> {
  static const List<Expense> _all = <Expense>[
    (
      id: 'EXP-2201',
      vendor: 'Cloud hosting',
      team: 'Platform',
      status: 'Approved',
      amount: 482000,
      submitted: '2 Aug',
    ),
    (
      id: 'EXP-2198',
      vendor: 'Log storage',
      team: 'Platform',
      status: 'Pending',
      amount: 118400,
      submitted: '3 Aug',
    ),
    (
      id: 'EXP-2194',
      vendor: 'On-call paging',
      team: 'Platform',
      status: 'Approved',
      amount: 64200,
      submitted: '5 Aug',
    ),
    (
      id: 'EXP-2190',
      vendor: 'Conference tickets',
      team: 'Design',
      status: 'Rejected',
      amount: 240000,
      submitted: '1 Aug',
    ),
    (
      id: 'EXP-2187',
      vendor: 'Prototyping tool',
      team: 'Design',
      status: 'Approved',
      amount: 39600,
      submitted: '6 Aug',
    ),
    (
      id: 'EXP-2183',
      vendor: 'Usability panel',
      team: 'Design',
      status: 'Pending',
      amount: 156000,
      submitted: '7 Aug',
    ),
    (
      id: 'EXP-2179',
      vendor: 'CRM seats',
      team: 'Sales',
      status: 'Approved',
      amount: 372000,
      submitted: '2 Aug',
    ),
    (
      id: 'EXP-2176',
      vendor: 'Travel, Berlin',
      team: 'Sales',
      status: 'Pending',
      amount: 87300,
      submitted: '8 Aug',
    ),
  ];

  /// The sort applies to every group, not to one of them.
  AstryxTableSort? _sort = const AstryxTableSort(
    'amount',
    AstryxSortDirection.descending,
  );

  /// One selection across the whole screen, however many tables draw it.
  Set<Object> _selected = <Object>{};

  /// Which field the rows are bucketed by. Grouping is a decision the caller
  /// makes about the data, not something a table can be asked to work out.
  String _groupBy = 'team';

  String _keyOf(Expense row) => _groupBy == 'team' ? row.team : row.status;

  /// The groups, in a stable order, each with its rows already sorted.
  List<({String title, List<Expense> rows, int subtotal})> get _groups {
    final buckets = <String, List<Expense>>{};
    for (final row in _all) {
      buckets.putIfAbsent(_keyOf(row), () => <Expense>[]).add(row);
    }

    final groups = <({String title, List<Expense> rows, int subtotal})>[];
    for (final entry in buckets.entries) {
      final rows = List<Expense>.of(entry.value);
      final sort = _sort;
      if (sort != null) {
        int by(Expense a, Expense b) => switch (sort.columnId) {
          'vendor' => a.vendor.compareTo(b.vendor),
          'status' => a.status.compareTo(b.status),
          _ => a.amount.compareTo(b.amount),
        };
        rows.sort(
          (a, b) => sort.direction == AstryxSortDirection.ascending
              ? by(a, b)
              : by(b, a),
        );
      }
      groups.add((
        title: entry.key,
        rows: rows,
        subtotal: rows.fold<int>(0, (sum, row) => sum + row.amount),
      ));
    }

    return groups..sort((a, b) => b.subtotal.compareTo(a.subtotal));
  }

  int get _total => _all.fold<int>(0, (sum, row) => sum + row.amount);

  /// The columns, declared once and reused by every group.
  ///
  /// This is what keeps the groups lined up. Each table works out its own
  /// widths from its own rows, so a column left to size itself would be one
  /// width under Platform and another under Design — and a grouped table whose
  /// columns do not line up is a set of unrelated tables in a stack.
  List<AstryxTableColumn<Expense>> get _columns => <AstryxTableColumn<Expense>>[
    AstryxTableColumn<Expense>(
      id: 'vendor',
      header: 'Vendor',
      compare: (a, b) => a.vendor.compareTo(b.vendor),
      cellBuilder: (context, row) => AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(row.vendor, maxLines: 1),
          AstryxText(
            row.id,
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    ),
    AstryxTableColumn<Expense>(
      id: 'status',
      header: 'Status',
      width: const AstryxTableColumnWidth.fixed(140),
      compare: (a, b) => a.status.compareTo(b.status),
      cellBuilder: (context, row) => switch (row.status) {
        'Approved' => const AstryxBadge(
          'Approved',
          variant: AstryxBadgeVariant.success,
          icon: AstryxIcon(AstryxIconName.success),
        ),
        'Rejected' => const AstryxBadge(
          'Rejected',
          variant: AstryxBadgeVariant.error,
          icon: AstryxIcon(AstryxIconName.error),
        ),
        _ => const AstryxBadge(
          'Pending',
          variant: AstryxBadgeVariant.warning,
          icon: AstryxIcon(AstryxIconName.clock),
        ),
      },
    ),
    AstryxTableColumn<Expense>(
      id: 'submitted',
      header: 'Submitted',
      width: const AstryxTableColumnWidth.fixed(110),
      cellBuilder: (context, row) => AstryxText(
        row.submitted,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
        maxLines: 1,
      ),
    ),
    AstryxTableColumn<Expense>(
      id: 'amount',
      header: 'Amount',
      width: const AstryxTableColumnWidth.fixed(120),
      alignment: AstryxTableAlignment.end,
      compare: (a, b) => a.amount.compareTo(b.amount),
      cellBuilder: (context, row) =>
          AstryxText(_money(row.amount), tabularNumbers: true),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final groups = _groups;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Expenses, August', level: 1),
                AstryxText(
                  '${_all.length} lines · ${_money(_total)}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Group by',
              value: _groupBy,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() => _groupBy = value),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: 'team', label: 'Team'),
                AstryxSegment(value: 'status', label: 'Status'),
              ],
            ),
          ],
        ),
        if (_selected.isNotEmpty)
          AstryxBanner(
            title: '${_selected.length} selected',
            announce: false,
            actions: <Widget>[
              AstryxButton(
                label: 'Approve',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                onPressed: () => setState(() => _selected = <Object>{}),
              ),
              AstryxButton(
                label: 'Clear',
                size: AstryxButtonSize.sm,
                onPressed: () => setState(() => _selected = <Object>{}),
              ),
            ],
          ),
        // One collapsible per group, and one table inside each. The group is a
        // *disclosure* rather than a row, which is why it can hold a subtotal
        // and a count without either of them pretending to be data.
        AstryxCollapsibleGroup(
          children: <AstryxCollapsible>[
            for (final group in groups)
              AstryxCollapsible(
                title: group.title,
                initiallyExpanded: true,
                description:
                    '${group.rows.length} lines · ${_money(group.subtotal)}',
                trailing: AstryxBadge(
                  '${(group.subtotal / _total * 100).round()}%',
                  semanticsLabel:
                      '${(group.subtotal / _total * 100).round()} per cent of '
                      'the total',
                ),
                child: AstryxTable<Expense>(
                  // Each table is named for its group. Four tables all called
                  // "Expenses" is four identical announcements, and a reader
                  // who tabs into the third one has no idea which it is.
                  label: '${group.title} expenses',
                  keyOf: (row) => row.id,
                  rowLabelOf: (row) => '${row.vendor}, ${_money(row.amount)}',
                  columns: _columns,
                  rows: group.rows,
                  density: AstryxTableDensity.compact,
                  // Shared, so a sort press in one group reorders all of them
                  // — which is the behaviour a single grouped table would have.
                  sort: _sort,
                  onSortChanged: (sort) => setState(() => _sort = sort),
                  selectionMode: AstryxTableSelectionMode.multiple,
                  selected: _selected,
                  onSelectionChanged: (value) => setState(() {
                    // The set is the whole screen's, so a group's "select all"
                    // has to add its own keys without dropping anyone else's.
                    final keys = group.rows.map((row) => row.id).toSet();
                    _selected = <Object>{
                      ..._selected.where((key) => !keys.contains(key)),
                      ...value.where(keys.contains),
                    };
                  }),
                ),
              ),
          ],
        ),
        AstryxCard(
          variant: AstryxCardVariant.muted,
          padding: AstryxSpacingToken.spacing3,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const AstryxText('Total', type: AstryxTextType.label),
              AstryxText(
                _money(_total),
                type: AstryxTextType.label,
                tabularNumbers: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pence to pounds, grouped in threes.
String _money(int value) {
  final units = (value / 100).floor().toString();
  final grouped = StringBuffer();
  for (var i = 0; i < units.length; i++) {
    if (i > 0 && (units.length - i) % 3 == 0) grouped.write(',');
    grouped.write(units[i]);
  }
  return '£$grouped.${(value % 100).toString().padLeft(2, '0')}';
}
// #end
