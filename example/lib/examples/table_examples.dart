import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// The row type every example on this page displays.
class Project {
  const Project(this.id, this.name, this.owner, this.requests, this.health);

  final String id;
  final String name;
  final String owner;
  final int requests;
  final String health;
}

/// The rows, already filtered and paginated — as a table expects them.
const List<Project> projects = <Project>[
  Project('p1', 'Atlas', 'Ada Lovelace', 4201, 'Healthy'),
  Project('p2', 'Beacon', 'Alan Turing', 118, 'Degraded'),
  Project('p3', 'Cinder', 'Grace Hopper', 0, 'Down'),
  Project('p4', 'Delta', 'Katherine Johnson', 92300, 'Healthy'),
  Project('p5', 'Ember', 'Ada Lovelace', 7, 'Idle'),
];

/// The badge that goes with a health string.
AstryxBadgeVariant variantFor(String health) => switch (health) {
  'Healthy' => AstryxBadgeVariant.success,
  'Degraded' => AstryxBadgeVariant.warning,
  'Down' => AstryxBadgeVariant.error,
  _ => AstryxBadgeVariant.neutral,
};

// #example table_demo -> TableDemoExample
class TableDemoExample extends StatelessWidget {
  const TableDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTable<Project>(
      label: 'Projects',
      rows: projects,
      keyOf: (row) => row.id,
      columns: <AstryxTableColumn<Project>>[
        AstryxTableColumn<Project>(
          id: 'name',
          header: 'Project',
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<Project>(
          id: 'owner',
          header: 'Owner',
          width: const AstryxTableColumnWidth.flex(1.4),
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
        AstryxTableColumn<Project>(
          id: 'requests',
          header: 'Requests',
          width: const AstryxTableColumnWidth.fixed(120),
          alignment: AstryxTableAlignment.end,
          cellBuilder: (context, row) =>
              AstryxText('${row.requests}', tabularNumbers: true),
        ),
      ],
    );
  }
}
// #end

// #example table_sorting -> TableSortingExample
class TableSortingExample extends StatefulWidget {
  const TableSortingExample({super.key});

  @override
  State<TableSortingExample> createState() => _TableSortingExampleState();
}

class _TableSortingExampleState extends State<TableSortingExample> {
  AstryxTableSort? _sort = const AstryxTableSort(
    'name',
    AstryxSortDirection.ascending,
  );

  @override
  Widget build(BuildContext context) {
    // A column is sortable when — and only when — it has a `compare`. Pressing
    // a header cycles ascending → descending → unsorted, because without that
    // third state a user cannot get back to the order the data arrived in.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTable<Project>(
          label: 'Projects',
          rows: projects,
          keyOf: (row) => row.id,
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          columns: <AstryxTableColumn<Project>>[
            AstryxTableColumn<Project>(
              id: 'name',
              header: 'Project',
              compare: (a, b) => a.name.compareTo(b.name),
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
            AstryxTableColumn<Project>(
              id: 'owner',
              header: 'Owner',
              compare: (a, b) => a.owner.compareTo(b.owner),
              cellBuilder: (context, row) => AstryxText(row.owner),
            ),
            AstryxTableColumn<Project>(
              id: 'requests',
              header: 'Requests',
              width: const AstryxTableColumnWidth.fixed(120),
              alignment: AstryxTableAlignment.end,
              compare: (a, b) => a.requests.compareTo(b.requests),
              cellBuilder: (context, row) =>
                  AstryxText('${row.requests}', tabularNumbers: true),
            ),
          ],
        ),
        AstryxText(
          _sort == null
              ? 'Unsorted — the order the rows arrived in'
              : 'Sorted by ${_sort!.columnId}, ${_sort!.direction.name}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example table_selection -> TableSelectionExample
class TableSelectionExample extends StatefulWidget {
  const TableSelectionExample({super.key});

  @override
  State<TableSelectionExample> createState() => _TableSelectionExampleState();
}

class _TableSelectionExampleState extends State<TableSelectionExample> {
  Set<Object> _selected = <Object>{'p2'};

  @override
  Widget build(BuildContext context) {
    // The header checkbox governs the *visible* rows, and goes indeterminate
    // when only some are selected. `rowLabelOf` is what names each row's
    // checkbox — without it every one announces "Select row".
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTable<Project>(
          label: 'Projects',
          rows: projects,
          keyOf: (row) => row.id,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          rowLabelOf: (row) => row.name,
          columns: <AstryxTableColumn<Project>>[
            AstryxTableColumn<Project>(
              id: 'name',
              header: 'Project',
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
            AstryxTableColumn<Project>(
              id: 'health',
              header: 'Health',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              cellBuilder: (context, row) =>
                  AstryxBadge(row.health, variant: variantFor(row.health)),
            ),
          ],
        ),
        AstryxText(
          '${_selected.length} selected',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example table_row_actions -> TableRowActionsExample
class TableRowActionsExample extends StatelessWidget {
  const TableRowActionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Row actions are **always visible**, never hover-only: hover does not
    // exist on touch, and an action nobody can reach is not an action.
    return AstryxTable<Project>(
      label: 'Projects',
      rows: projects,
      keyOf: (row) => row.id,
      striped: true,
      maxHeight: 260,
      rowActionsBuilder: (context, row) => AstryxDropdownMenu(
        width: 180,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Open ${row.name}', onSelected: () {}),
          const AstryxMenuDivider(),
          AstryxMenuItem(label: 'Delete', destructive: true, onSelected: () {}),
        ],
        triggerBuilder: (context, controller) => AstryxIconButton(
          icon: AstryxIconName.moreHorizontal,
          label: 'Actions for ${row.name}',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: controller.toggle,
        ),
      ),
      columns: <AstryxTableColumn<Project>>[
        AstryxTableColumn<Project>(
          id: 'name',
          header: 'Project',
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<Project>(
          id: 'owner',
          header: 'Owner',
          headerTooltip: 'Who gets paged first',
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
      ],
    );
  }
}
// #end

// #example table_density -> TableDensityExample
class TableDensityExample extends StatefulWidget {
  const TableDensityExample({super.key});

  @override
  State<TableDensityExample> createState() => _TableDensityExampleState();
}

class _TableDensityExampleState extends State<TableDensityExample> {
  AstryxTableDensity _density = AstryxTableDensity.balanced;
  bool _striped = false;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxSelector<AstryxTableDensity>(
              label: 'Density',
              value: _density,
              width: 200,
              onChanged: (value) =>
                  setState(() => _density = value ?? _density),
              options: <AstryxSelectorEntry<AstryxTableDensity>>[
                for (final density in AstryxTableDensity.values)
                  AstryxSelectorOption<AstryxTableDensity>(
                    value: density,
                    label: density.name,
                  ),
              ],
            ),
            AstryxSwitch(
              label: 'Striped',
              value: _striped,
              onChanged: (value) => setState(() => _striped = value),
            ),
          ],
        ),
        AstryxTable<Project>(
          label: 'Projects',
          rows: projects,
          keyOf: (row) => row.id,
          density: _density,
          striped: _striped,
          columns: <AstryxTableColumn<Project>>[
            AstryxTableColumn<Project>(
              id: 'name',
              header: 'Project',
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
            AstryxTableColumn<Project>(
              id: 'owner',
              header: 'Owner',
              cellBuilder: (context, row) => AstryxText(row.owner),
            ),
          ],
        ),
      ],
    );
  }
}
// #end

// #example table_widths -> TableWidthsExample
class TableWidthsExample extends StatelessWidget {
  const TableWidthsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three strategies, one row: flexible columns share what is left, fixed
    // columns take theirs, and an intrinsic column is as wide as its widest
    // cell — clamped, so one long value cannot push the rest off-screen.
    return AstryxTable<Project>(
      label: 'Column widths',
      rows: projects,
      keyOf: (row) => row.id,
      minWidth: 520,
      columns: <AstryxTableColumn<Project>>[
        AstryxTableColumn<Project>(
          id: 'name',
          header: 'flex(1)',
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<Project>(
          id: 'owner',
          header: 'flex(2)',
          width: const AstryxTableColumnWidth.flex(2),
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
        AstryxTableColumn<Project>(
          id: 'health',
          header: 'intrinsic',
          width: const AstryxTableColumnWidth.intrinsic(min: 80, max: 160),
          cellBuilder: (context, row) =>
              AstryxBadge(row.health, variant: variantFor(row.health)),
        ),
        AstryxTableColumn<Project>(
          id: 'requests',
          header: 'fixed(110)',
          width: const AstryxTableColumnWidth.fixed(110),
          alignment: AstryxTableAlignment.end,
          cellBuilder: (context, row) =>
              AstryxText('${row.requests}', tabularNumbers: true),
        ),
      ],
    );
  }
}
// #end

// #example table_empty -> TableEmptyExample
class TableEmptyExample extends StatelessWidget {
  const TableEmptyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTable<Project>(
      label: 'Projects',
      rows: const <Project>[],
      keyOf: (row) => row.id,
      emptyState: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxText('No projects match this filter.'),
          AstryxButton(
            label: 'Clear filters',
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
      columns: <AstryxTableColumn<Project>>[
        AstryxTableColumn<Project>(
          id: 'name',
          header: 'Project',
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<Project>(
          id: 'owner',
          header: 'Owner',
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
      ],
    );
  }
}
// #end
