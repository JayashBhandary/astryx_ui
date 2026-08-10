---
title: AstryxTable
description: A typed data table with sorting, selection, row actions and three column-width strategies.
component: true
group: Data display
source: lib/src/components/data/table.dart
upstream: Table / TableCell / TableHeaderCell / TableRow / useTableColumnResize / useTableColumnSettings / useTableFilterState / useTableFiltering / useTableGroupedRows / useTablePagination / useTableRowExpansion / useTableRowIndex / useTableRowStatus / useTableSelection / useTableSelectionState / useTableSortable / useTableStickyColumns / useTableTreeData / useTableTreeState
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxTable<Project>(
  label: 'Projects',
  rows: projects,
  keyOf: (row) => row.id,
  columns: <AstryxTableColumn<Project>>[
    AstryxTableColumn<Project>(
      id: 'name',
      header: 'Project',
      cellBuilder: (context, row) => AstryxText(row.name),
    ),
  ],
)
```

Generic over the row type, so `cellBuilder` receives your object and not a map. `keyOf` gives each row a stable identity — used for selection and as its widget key — and `rows` are expected to arrive already filtered and paginated. Sorting *is* applied here, because the table owns the comparators.

> **Careful**
>
> **The table does not virtualise rows.** A few hundred is fine; ten thousand is not. There is also no column reordering, no drag-resizing, no grouped or expandable rows, and sorting is one column at a time.

## Composition

```text
AstryxTable<T>
├── header row
│   ├── select-all checkbox   ← when selectionMode is multiple
│   ├── header cell           ← a button when the column has `compare`
│   └── actions gutter        ← reserved by rowActionsWidth
├── body
│   └── row
│       ├── row checkbox
│       ├── cell              ← from column.cellBuilder
│       └── actions           ← from rowActionsBuilder. Always visible
└── emptyState                ← instead of the body when rows is empty
```

## Sorting

A column is sortable when — and only when — it has a `compare`. Without one the header stays plain text rather than becoming a button, so a keyboard user does not tab through a control that does nothing.

Pressing a header cycles ascending → descending → **unsorted**. That third state matters: without it a user cannot get back to the order the data arrived in, which for a queue or a log is the only order that means anything.

```dart
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
```


## Selection

Three modes: `none`, `single` and `multiple`. The header checkbox governs the *visible* rows and goes indeterminate when only some are selected. Selection is independent of `onRowPressed` — a table can open a detail view on press and still have checkboxes.

```dart
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
```


> **Accessibility**
>
> Set `rowLabelOf`. Without it every row’s checkbox is announced as "Select row", which is true of all of them and therefore useless in a list of them.

## Row actions

Row actions are **always visible**, never revealed on hover. Upstream reveals them; hover does not exist on touch, and an action nobody can reach is not an action. The gutter is a fixed reservation rather than a measurement, so the actions line up down the table and the header leaves the same gap — widen `rowActionsWidth` for more than two buttons.

```dart
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
```


## Density and stripes

Three densities. `compact` is for data an operator scans all day; `spacious` is for a short table that should breathe.

```dart
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
```


## Column widths

Three strategies, mixable in one table.

| Strategy | Behaviour |
| --- | --- |
| `AstryxTableColumnWidth.flex(factor)` | Shares what is left after the fixed and intrinsic columns. The default, with a factor of 1. |
| `AstryxTableColumnWidth.fixed(width)` | Exactly that many logical pixels. |
| `AstryxTableColumnWidth.intrinsic(min:, max:)` | As wide as its widest cell, clamped — so an empty column does not collapse and one long value cannot push the rest off-screen. Costs a second layout pass. |

```dart
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
```


`minWidth` puts a floor under the total: below it the table scrolls horizontally rather than squeezing every column into illegibility. `maxHeight` puts a ceiling on the height, above which the body scrolls under a pinned header.

## Empty

An empty table is not a broken one. Say why it is empty, and offer the way out.

```dart
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
```


### AstryxTable

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `columns` *(required)* | `List<AstryxTableColumn<T>>` | — | The columns, in display order. |
| `rows` *(required)* | `List<T>` | — | The rows, already filtered and paginated. |
| `keyOf` *(required)* | `Object Function(T row)` | — | A stable identity for a row. |
| `density` | `AstryxTableDensity` | `AstryxTableDensity.balanced` | How much room each row takes. |
| `sort` | `AstryxTableSort?` | — | The current sort, or null for none. |
| `onSortChanged` | `ValueChanged<AstryxTableSort?>?` | — | Called with the sort a header press should produce. Null after a full cycle. |
| `selectionMode` | `AstryxTableSelectionMode` | `AstryxTableSelectionMode.none` | How many rows can be selected. |
| `selected` | `Set<Object>` | `const <Object>{}` | The selected row keys. |
| `onSelectionChanged` | `ValueChanged<Set<Object>>?` | — | Called with the selection the user’s action produces. |
| `onRowPressed` | `void Function(T row)?` | — | Called when a row is pressed. Independent of selection. |
| `rowActionsBuilder` | `Widget Function(BuildContext, T row)?` | — | Builds the always-visible actions at the row’s trailing edge. |
| `striped` | `bool` | `false` | Whether alternate rows take `--color-background-muted`. |
| `showRowDividers` | `bool` | `true` | Whether to draw a rule between rows. |
| `emptyState` | `Widget?` | — | Shown in place of the body when `rows` is empty. |
| `label` | `String?` | — | An accessible name for the table. |
| `minWidth` | `double?` | — | A floor under the total column width, below which the table scrolls. |
| `maxHeight` | `double?` | — | A ceiling on the height, above which the body scrolls. |
| `rowActionsWidth` | `double` | `96` | The width reserved for the row actions. |
| `rowLabelOf` | `String Function(T row)?` | — | Names a row, used as the accessible name of its checkbox. |


### AstryxTableColumn

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` *(required)* | `String` | — | A stable identifier, used for sorting state and as the column’s key. |
| `header` *(required)* | `String` | — | The header text, and the column’s accessible name. |
| `cellBuilder` *(required)* | `Widget Function(BuildContext, T row)` | — | Builds a cell for one row. |
| `width` | `AstryxTableColumnWidth` | `AstryxTableColumnWidth.flex()` | How this column decides its width. |
| `alignment` | `AstryxTableAlignment` | `AstryxTableAlignment.start` | How the cell’s content sits within its width. Use `end` for numbers. |
| `compare` | `int Function(T a, T b)?` | — | Makes the column sortable. Null leaves it unsortable. |
| `headerTooltip` | `String?` | — | Extra explanation shown on the header. |
| `visible` | `bool` | `true` | Whether the column is shown at all. |


## Related

- [AstryxBadge](badge.md) — the usual status cell.
- [AstryxDropdownMenu](dropdown_menu.md) — the usual row-actions trigger.
- [AstryxCenter](center.md) — for building an `emptyState`.

