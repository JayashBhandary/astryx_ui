# Data display

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxTabList

`lib/src/components/data/tab_list.dart` · upstream `TabList / Tab`

A strip of tabs that reports a value and owns no panel.

```dart
class TabListDemoExample extends StatefulWidget {
  const TabListDemoExample({super.key});

  @override
  State<TabListDemoExample> createState() => _TabListDemoExampleState();
}

class _TabListDemoExampleState extends State<TabListDemoExample> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    // The strip owns no panel. It reports a value; the application decides what
    // that value shows — which is what keeps a tab bar usable with routing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Project sections',
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'overview', label: 'Overview'),
            AstryxTab(value: 'activity', label: 'Activity'),
            AstryxTab(value: 'settings', label: 'Settings'),
          ],
        ),
        AstryxText(switch (_tab) {
          'overview' => '4,201 requests this month.',
          'activity' => 'Ada deployed 20 minutes ago.',
          _ => 'Two admins, twenty-two members.',
        }),
      ],
    );
  }
}
```

**Rules**

- **Note:** The overflow scrolls; it does not collapse into a "more" menu. If a strip needs sixteen tabs, the navigation probably needs rethinking before the widget does.
- **Accessibility:** Arrow keys select as they move, which is the ARIA pattern for tabs whose panels are cheap to render. Give the strip a `label` when the page has more than one.

| Key | Does |
| --- | --- |
| `Tab` | Enters or leaves the strip — one stop for the whole strip. |
| `→` / `←` | Selects the next or previous enabled tab, wrapping. Mirrored under RTL. |
| `Home` / `End` | Selects the first or last enabled tab. |

### AstryxTabList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `tabs` **(required)** | `List<AstryxTab<T>>` | — | The tabs, in order. |
| `value` **(required)** | `T?` | — | The selected value. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly selected value. |
| `size` | `AstryxTabSize?` | — | The tab height. Null inherits from an `AstryxSizeScope`. |
| `showDivider` | `bool` | `true` | Whether to draw a rule under the strip. |
| `fill` | `bool` | `false` | Whether the tabs share the full width equally. |
| `label` | `String?` | — | An accessible name for the strip. |
| `focusNode` | `FocusNode?` | — | The strip’s focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxTab

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What selecting this tab produces. |
| `label` **(required)** | `String` | — | The visible text, and this tab’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. |
| `badge` | `AstryxBadge?` | — | A count or status after it. |
| `enabled` | `bool` | `true` | Whether the tab can be selected. |

---

## AstryxTable

`lib/src/components/data/table.dart` · upstream `Table / TableCell / TableHeaderCell / TableRow / useTableColumnResize / useTableColumnSettings / useTableFilterState / useTableFiltering / useTableGroupedRows / useTablePagination / useTableRowExpansion / useTableRowIndex / useTableRowStatus / useTableSelection / useTableSelectionState / useTableSortable / useTableStickyColumns / useTableTreeData / useTableTreeState`

A typed data table with sorting, selection, row actions and three column-width strategies.

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

**Rules**

- **Careful:** **The table does not virtualise rows.** A few hundred is fine; ten thousand is not. There is also no column reordering, no drag-resizing, no grouped or expandable rows, and sorting is one column at a time.
- **Accessibility:** Set `rowLabelOf`. Without it every row’s checkbox is announced as "Select row", which is true of all of them and therefore useless in a list of them.

| Strategy | Behaviour |
| --- | --- |
| `AstryxTableColumnWidth.flex(factor)` | Shares what is left after the fixed and intrinsic columns. The default, with a factor of 1. |
| `AstryxTableColumnWidth.fixed(width)` | Exactly that many logical pixels. |
| `AstryxTableColumnWidth.intrinsic(min:, max:)` | As wide as its widest cell, clamped — so an empty column does not collapse and one long value cannot push the rest off-screen. Costs a second layout pass. |

### AstryxTable

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `columns` **(required)** | `List<AstryxTableColumn<T>>` | — | The columns, in display order. |
| `rows` **(required)** | `List<T>` | — | The rows, already filtered and paginated. |
| `keyOf` **(required)** | `Object Function(T row)` | — | A stable identity for a row. |
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

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `id` **(required)** | `String` | — | A stable identifier, used for sorting state and as the column’s key. |
| `header` **(required)** | `String` | — | The header text, and the column’s accessible name. |
| `cellBuilder` **(required)** | `Widget Function(BuildContext, T row)` | — | Builds a cell for one row. |
| `width` | `AstryxTableColumnWidth` | `AstryxTableColumnWidth.flex()` | How this column decides its width. |
| `alignment` | `AstryxTableAlignment` | `AstryxTableAlignment.start` | How the cell’s content sits within its width. Use `end` for numbers. |
| `compare` | `int Function(T a, T b)?` | — | Makes the column sortable. Null leaves it unsortable. |
| `headerTooltip` | `String?` | — | Extra explanation shown on the header. |
| `visible` | `bool` | `true` | Whether the column is shown at all. |

---

