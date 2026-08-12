import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Data display — tabs and the table.
final List<DocPage> dataPages = <DocPage>[_tabList, _table];

const String _group = DocGroup.dataDisplay;

const DocPage _tabList = DocPage(
  id: 'tab_list',
  title: 'AstryxTabList',
  group: _group,
  description: 'A strip of tabs that reports a value and owns no panel.',
  source: 'lib/src/components/data/tab_list.dart',
  upstream: 'TabList / Tab',
  upstreamPath: '/components/TabList',
  blocks: <DocBlock>[
    DocExample('tab_list_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxTabList<String>(
  value: _tab,
  onChanged: (value) => setState(() => _tab = value),
  tabs: const <AstryxTab<String>>[
    AstryxTab(value: 'overview', label: 'Overview'),
    AstryxTab(value: 'activity', label: 'Activity'),
  ],
)'''),
    DocProse(
      'There is no `TabController`, no `TabBarView` and no panel. The strip '
      'reports a value; what that value shows is the application’s business — '
      'which is what makes the same widget work for a local `setState`, a '
      'router and a stored preference alike.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxTabList<T>
└── tabs
    └── AstryxTab<T>
        ├── value    ← what selecting it produces
        ├── label    ← the visible text, and its accessible name
        ├── icon     ← optional. Any widget
        └── badge    ← optional. An AstryxBadge'''),
    DocHeading('Icons and badges'),
    DocExample('tab_list_icons', align: DocExampleAlign.stretch),
    DocHeading('Sizes'),
    DocExample('tab_list_sizes', align: DocExampleAlign.stretch),
    DocHeading('Fill and the divider'),
    DocProse(
      '`fill` splits the width equally — for two or three tabs in a narrow '
      'panel, where a left-packed strip looks unfinished.',
    ),
    DocExample('tab_list_fill', align: DocExampleAlign.stretch),
    DocHeading('Overflow'),
    DocProse(
      'Too many tabs scroll rather than shrink, with a fade at whichever edge '
      'has more. Arrowing to a tab that is off-screen scrolls it into view: a '
      'selection the user cannot see is worse than no selection at all.',
    ),
    DocExample('tab_list_overflow', align: DocExampleAlign.start),
    DocCallout.note(
      'The overflow scrolls; it does not collapse into a "more" menu. If a '
      'strip needs sixteen tabs, the navigation probably needs rethinking '
      'before the widget does.',
    ),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>[
          '`Tab`',
          'Enters or leaves the strip — one stop for the whole '
              'strip.',
        ],
        <String>[
          '`→` / `←`',
          'Selects the next or previous enabled tab, '
              'wrapping. Mirrored under RTL.',
        ],
        <String>['`Home` / `End`', 'Selects the first or last enabled tab.'],
      ],
    ),
    DocCallout.accessibility(
      'Arrow keys select as they move, which is the ARIA pattern for tabs '
      'whose panels are cheap to render. Give the strip a `label` when the '
      'page has more than one.',
    ),
    DocApi('AstryxTabList', <DocProp>[
      DocProp(
        'tabs',
        'List<AstryxTab<T>>',
        'The tabs, in order.',
        required: true,
      ),
      DocProp('value', 'T?', 'The selected value.', required: true),
      DocProp(
        'onChanged',
        'ValueChanged<T>?',
        'Called with the newly selected value.',
      ),
      DocProp(
        'size',
        'AstryxTabSize?',
        'The tab height. Null inherits from an `AstryxSizeScope`.',
      ),
      DocProp(
        'showDivider',
        'bool',
        'Whether to draw a rule under the strip.',
        defaultValue: 'true',
      ),
      DocProp(
        'fill',
        'bool',
        'Whether the tabs share the full width equally.',
        defaultValue: 'false',
      ),
      DocProp('label', 'String?', 'An accessible name for the strip.'),
      DocProp('focusNode', 'FocusNode?', 'The strip’s focus node.'),
      DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
    ]),
    DocApi('AstryxTab', <DocProp>[
      DocProp(
        'value',
        'T',
        'What selecting this tab produces.',
        required: true,
      ),
      DocProp(
        'label',
        'String',
        'The visible text, and this tab’s accessible name.',
        required: true,
      ),
      DocProp('icon', 'Widget?', 'An icon before the label.'),
      DocProp('badge', 'AstryxBadge?', 'A count or status after it.'),
      DocProp(
        'enabled',
        'bool',
        'Whether the tab can be selected.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxButtonGroup](button_group) — for actions, not for views.',
    ]),
  ],
);

const DocPage _table = DocPage(
  id: 'table',
  title: 'AstryxTable',
  group: _group,
  description:
      'A typed data table with sorting, selection, row actions and three '
      'column-width strategies.',
  source: 'lib/src/components/data/table.dart',
  upstream:
      'Table / TableCell / TableHeaderCell / TableRow / '
      'useTableColumnResize / useTableColumnSettings / useTableFilterState / useTableFiltering / useTableGroupedRows / '
      'useTablePagination / useTableRowExpansion / useTableRowIndex / useTableRowStatus / useTableSelection / '
      'useTableSelectionState / useTableSortable / useTableStickyColumns / useTableTreeData / useTableTreeState',
  upstreamPath: '/components/Table',
  blocks: <DocBlock>[
    DocExample('table_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
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
)'''),
    DocProse(
      'Generic over the row type, so `cellBuilder` receives your object and '
      'not a map. `keyOf` gives each row a stable identity — used for '
      'selection and as its widget key — and `rows` are expected to arrive '
      'already filtered and paginated. Sorting *is* applied here, because the '
      'table owns the comparators.',
    ),
    DocCallout.warning(
      '**The table does not virtualise rows.** A few hundred is fine; ten '
      'thousand is not. There is also no column reordering, no drag-resizing, '
      'no grouped or expandable rows, and sorting is one column at a time.',
    ),
    DocHeading('Composition'),
    DocTree('''
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
└── emptyState                ← instead of the body when rows is empty'''),
    DocHeading('Sorting'),
    DocProse(
      'A column is sortable when — and only when — it has a `compare`. Without '
      'one the header stays plain text rather than becoming a button, so a '
      'keyboard user does not tab through a control that does nothing.',
    ),
    DocProse(
      'Pressing a header cycles ascending → descending → **unsorted**. That '
      'third state matters: without it a user cannot get back to the order the '
      'data arrived in, which for a queue or a log is the only order that '
      'means anything.',
    ),
    DocExample('table_sorting', align: DocExampleAlign.stretch),
    DocHeading('Selection'),
    DocProse(
      'Three modes: `none`, `single` and `multiple`. The header checkbox '
      'governs the *visible* rows and goes indeterminate when only some are '
      'selected. Selection is independent of `onRowPressed` — a table can open '
      'a detail view on press and still have checkboxes.',
    ),
    DocExample('table_selection', align: DocExampleAlign.stretch),
    DocCallout.accessibility(
      'Set `rowLabelOf`. Without it every row’s checkbox is announced as '
      '"Select row", which is true of all of them and therefore useless in a '
      'list of them.',
    ),
    DocHeading('Row actions'),
    DocProse(
      'Row actions are **always visible**, never revealed on hover. Upstream '
      'reveals them; hover does not exist on touch, and an action nobody can '
      'reach is not an action. The gutter is a fixed reservation rather than a '
      'measurement, so the actions line up down the table and the header '
      'leaves the same gap — widen `rowActionsWidth` for more than two '
      'buttons.',
    ),
    DocExample('table_row_actions', align: DocExampleAlign.stretch),
    DocHeading('Density and stripes'),
    DocProse(
      'Three densities. `compact` is for data an operator scans all day; '
      '`spacious` is for a short table that should breathe.',
    ),
    DocExample('table_density', align: DocExampleAlign.stretch),
    DocHeading('Column widths'),
    DocProse(
      'Three strategies, mixable in one table.',
    ),
    DocTable(
      headers: <String>['Strategy', 'Behaviour'],
      rows: <List<String>>[
        <String>[
          '`AstryxTableColumnWidth.flex(factor)`',
          'Shares what is left after the fixed and intrinsic columns. The '
              'default, with a factor of 1.',
        ],
        <String>[
          '`AstryxTableColumnWidth.fixed(width)`',
          'Exactly that many logical pixels.',
        ],
        <String>[
          '`AstryxTableColumnWidth.intrinsic(min:, max:)`',
          'As wide as its widest cell, clamped — so an empty column does not '
              'collapse and one long value cannot push the rest off-screen. '
              'Costs a second layout pass.',
        ],
      ],
    ),
    DocExample('table_widths', align: DocExampleAlign.stretch),
    DocProse(
      '`minWidth` puts a floor under the total: below it the table scrolls '
      'horizontally rather than squeezing every column into illegibility. '
      '`maxHeight` puts a ceiling on the height, above which the body scrolls '
      'under a pinned header.',
    ),
    DocHeading('Empty'),
    DocProse(
      'An empty table is not a broken one. Say why it is empty, and offer the '
      'way out.',
    ),
    DocExample('table_empty', align: DocExampleAlign.stretch),
    DocApi('AstryxTable', <DocProp>[
      DocProp(
        'columns',
        'List<AstryxTableColumn<T>>',
        'The columns, in display order.',
        required: true,
      ),
      DocProp(
        'rows',
        'List<T>',
        'The rows, already filtered and paginated.',
        required: true,
      ),
      DocProp(
        'keyOf',
        'Object Function(T row)',
        'A stable identity for a row.',
        required: true,
      ),
      DocProp(
        'density',
        'AstryxTableDensity',
        'How much room each row takes.',
        defaultValue: 'AstryxTableDensity.balanced',
      ),
      DocProp(
        'sort',
        'AstryxTableSort?',
        'The current sort, or null for none.',
      ),
      DocProp(
        'onSortChanged',
        'ValueChanged<AstryxTableSort?>?',
        'Called with the sort a header press should produce. Null after a full '
            'cycle.',
      ),
      DocProp(
        'selectionMode',
        'AstryxTableSelectionMode',
        'How many rows can be selected.',
        defaultValue: 'AstryxTableSelectionMode.none',
      ),
      DocProp(
        'selected',
        'Set<Object>',
        'The selected row keys.',
        defaultValue: 'const <Object>{}',
      ),
      DocProp(
        'onSelectionChanged',
        'ValueChanged<Set<Object>>?',
        'Called with the selection the user’s action produces.',
      ),
      DocProp(
        'onRowPressed',
        'void Function(T row)?',
        'Called when a row is pressed. Independent of selection.',
      ),
      DocProp(
        'rowActionsBuilder',
        'Widget Function(BuildContext, T row)?',
        'Builds the always-visible actions at the row’s trailing edge.',
      ),
      DocProp(
        'striped',
        'bool',
        'Whether alternate rows take `--color-background-muted`.',
        defaultValue: 'false',
      ),
      DocProp(
        'showRowDividers',
        'bool',
        'Whether to draw a rule between rows.',
        defaultValue: 'true',
      ),
      DocProp(
        'emptyState',
        'Widget?',
        'Shown in place of the body when `rows` is empty.',
      ),
      DocProp('label', 'String?', 'An accessible name for the table.'),
      DocProp(
        'minWidth',
        'double?',
        'A floor under the total column width, below which the table scrolls.',
      ),
      DocProp(
        'maxHeight',
        'double?',
        'A ceiling on the height, above which the body scrolls.',
      ),
      DocProp(
        'rowActionsWidth',
        'double',
        'The width reserved for the row actions.',
        defaultValue: '96',
      ),
      DocProp(
        'rowLabelOf',
        'String Function(T row)?',
        'Names a row, used as the accessible name of its checkbox.',
      ),
    ]),
    DocApi('AstryxTableColumn', <DocProp>[
      DocProp(
        'id',
        'String',
        'A stable identifier, used for sorting state and as the column’s key.',
        required: true,
      ),
      DocProp(
        'header',
        'String',
        'The header text, and the column’s accessible name.',
        required: true,
      ),
      DocProp(
        'cellBuilder',
        'Widget Function(BuildContext, T row)',
        'Builds a cell for one row.',
        required: true,
      ),
      DocProp(
        'width',
        'AstryxTableColumnWidth',
        'How this column decides its width.',
        defaultValue: 'AstryxTableColumnWidth.flex()',
      ),
      DocProp(
        'alignment',
        'AstryxTableAlignment',
        'How the cell’s content sits within its width. Use `end` for numbers.',
        defaultValue: 'AstryxTableAlignment.start',
      ),
      DocProp(
        'compare',
        'int Function(T a, T b)?',
        'Makes the column sortable. Null leaves it unsortable.',
      ),
      DocProp(
        'headerTooltip',
        'String?',
        'Extra explanation shown on the header.',
      ),
      DocProp(
        'visible',
        'bool',
        'Whether the column is shown at all.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxBadge](badge) — the usual status cell.',
      '[AstryxDropdownMenu](dropdown_menu) — the usual row-actions trigger.',
      '[AstryxCenter](center) — for building an `emptyState`.',
    ]),
  ],
);
