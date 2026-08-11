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

## AstryxItem

`lib/src/components/data/item.dart` · upstream `Item`

The row the lists are built from — something at the start, a label, and something at the end.

```dart
class ItemDemoExample extends StatelessWidget {
  const ItemDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxItem(
      leading: const AstryxIcon(AstryxIconName.check),
      label: 'ada@example.com',
      description: 'Owner · invited 3 days ago',
      trailing: const AstryxBadge(
        'Active',
        variant: AstryxBadgeVariant.success,
      ),
      onPressed: () {},
    );
  }
}
```

**Rules**

- **Accessibility:** A disabled row stays in the semantics tree. A control that vanishes when it is disabled tells a screen-reader user the option does not exist, rather than that it is unavailable — which are different facts.

| State | Set by | Reads as |
| --- | --- | --- |
| Pressable | `onPressed` non-null | a button: hover, press, a focus ring, a tap target |
| Selected | `selected: true` | tinted, and announced `selected` |
| Inert | `onPressed: null` | a plain row, contributing nothing of its own to semantics |
| Disabled | `enabled: false` | dimmed, still announced as a button, no tap action |

### AstryxItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the row’s accessible name. |
| `leading` | `Widget?` | — | Content at the reading-start edge. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content at the reading-end edge. |
| `onPressed` | `VoidCallback?` | — | Makes the whole row a button. Null leaves it inert. |
| `selected` | `bool` | `false` | Whether the row is the chosen one, which tints it. |
| `enabled` | `bool` | `true` | Whether the row accepts input. |
| `density` | `AstryxItemDensity?` | — | Overrides the density inherited from the enclosing list. |
| `maxLines` | `int?` | `1` | How many lines the label and description may each take. Null lets them wrap freely. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces instead of `label`. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxItemDensity

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `compact` | `AstryxItemDensity` | — | Tight rows, for a long list in a dense screen. |
| `balanced` | `AstryxItemDensity` | — | The default. |

---

## AstryxList

`lib/src/components/data/list.dart` · upstream `List / ListItem`

A vertical list of rows, with the separators and density the design system expects.

```dart
class ListDemoExample extends StatefulWidget {
  const ListDemoExample({super.key});

  @override
  State<ListDemoExample> createState() => _ListDemoExampleState();
}

class _ListDemoExampleState extends State<ListDemoExample> {
  String? _open;

  @override
  Widget build(BuildContext context) {
    return AstryxList(
      label: 'Recent deploys',
      showDividers: true,
      children: <Widget>[
        for (final deploy in const <List<String>>[
          <String>['api', '2 minutes ago', 'Live'],
          <String>['web', '1 hour ago', 'Live'],
          <String>['worker', 'yesterday', 'Rolled back'],
        ])
          AstryxItem(
            label: deploy[0],
            description: deploy[1],
            selected: _open == deploy[0],
            trailing: AstryxBadge(
              deploy[2],
              variant: deploy[2] == 'Live'
                  ? AstryxBadgeVariant.success
                  : AstryxBadgeVariant.neutral,
            ),
            onPressed: () => setState(() => _open = deploy[0]),
          ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **It does not scroll and does not virtualise.** A list is a `Column`, so a long one belongs inside the page’s scroll view, and a very long one belongs in a paginated AstryxTable (references/data.md) instead — the same limit the table carries, for the same reason.
- **Accessibility:** The list announces itself as a list, and each row as one of its items, so a screen reader can say "list, 3 items" before reading the first. Give it a `label`: "list, 3 items" is a start, "Recent deploys, list, 3 items" is an answer.

### AstryxList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The rows, in order. Usually `AstryxItem`s. |
| `label` | `String?` | — | The list’s accessible name, announced before the first row. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.balanced` | The vertical rhythm every row inherits. |
| `showDividers` | `bool` | `false` | Whether to draw a rule between rows. |
| `gap` | `AstryxSpacingToken?` | — | Overrides the space between rows. Defaults to nothing when dividers are drawn: a rule and a gap doing the same job is one too many. |
| `empty` | `Widget?` | — | What to show when `children` is empty. Null renders nothing. |

---

## AstryxTreeList

`lib/src/components/data/tree_list.dart` · upstream `TreeList`

A list of nested, expandable rows.

```dart
class TreeListDemoExample extends StatefulWidget {
  const TreeListDemoExample({super.key});

  @override
  State<TreeListDemoExample> createState() => _TreeListDemoExampleState();
}

class _TreeListDemoExampleState extends State<TreeListDemoExample> {
  String? _selected = 'list';

  @override
  Widget build(BuildContext context) {
    // Tab lands on the tree once; the arrows do the rest. Right opens a branch
    // and then steps into it, Left closes it and then steps out.
    return AstryxTreeList(
      label: 'Files',
      nodes: _files,
      initiallyExpanded: const <String>{'lib', 'components'},
      selected: _selected,
      onSelectedChanged: (id) => setState(() => _selected = id),
    );
  }
}
```

**Rules**

- **Note:** A closed branch builds none of its children, so a tree of a thousand nodes costs only what is open. What *is* open is built in full — this is a `Column`, like AstryxList (references/data.md), and does not virtualise.

| Key | Does |
| --- | --- |
| `Down` / `Up` | Moves to the next or previous visible row. |
| `Right` | Opens a closed branch; steps into an open one. Mirrored under RTL. |
| `Left` | Closes an open branch; steps out to the parent. Mirrored under RTL. |
| `Home` / `End` | The first and last visible rows. |
| `Enter` / `Space` | Presses the row. |
| `Tab` | Leaves the tree entirely. |

### AstryxTreeList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `nodes` **(required)** | `List<AstryxTreeNode>` | — | The roots, in order. |
| `expanded` | `Set<String>?` | — | The ids of the open branches. Null keeps the set inside the widget. |
| `initiallyExpanded` | `Set<String>` | `const <String>{}` | The branches open on the first build. Ignored when `expanded` is set. |
| `onExpandedChanged` | `ValueChanged<Set<String>>?` | — | Called with the whole new set whenever a branch opens or closes. |
| `selected` | `String?` | — | The id of the chosen row. |
| `onSelectedChanged` | `ValueChanged<String>?` | — | Called with the id of the row the user chose. Null makes the tree read-only: it still expands and still traverses. |
| `label` | `String?` | — | The tree’s accessible name. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.balanced` | The vertical rhythm every row takes. |
| `focusNode` | `FocusNode?` | — | The focus node for the tree. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxTreeNode

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `id` **(required)** | `String` | — | This node’s identity, unique across the whole tree. |
| `label` **(required)** | `String` | — | The visible text, and this row’s accessible name. |
| `children` | `List<AstryxTreeNode>` | `const <AstryxTreeNode>[]` | The nodes under this one. A non-empty list makes the row expandable. |
| `leading` | `Widget?` | — | Content between the chevron and the label. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content at the reading-end edge. |
| `enabled` | `bool` | `true` | Whether this row can be chosen or opened. |

---

## AstryxOverflowList

`lib/src/components/data/overflow_list.dart` · upstream `OverflowList`

A row of items that measures itself and moves the tail into a menu.

```dart
class OverflowListDemoExample extends StatefulWidget {
  const OverflowListDemoExample({super.key});

  @override
  State<OverflowListDemoExample> createState() =>
      _OverflowListDemoExampleState();
}

class _OverflowListDemoExampleState extends State<OverflowListDemoExample> {
  static const List<String> _tags = <String>[
    'billing',
    'infra',
    'urgent',
    'customer-reported',
    'regression',
    'needs-repro',
  ];

  String? _chosen;

  @override
  Widget build(BuildContext context) {
    // Narrow the window and the tail moves into the menu; widen it and the
    // items come back. Nothing is ever unreachable — what does not fit is a
    // real menu row, not a clipped one.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxOverflowList(
          menuLabel: 'More tags',
          items: <AstryxOverflowItem>[
            for (final tag in _tags)
              AstryxOverflowItem(
                label: tag,
                onSelected: () => setState(() => _chosen = tag),
                child: AstryxBadge(tag),
              ),
          ],
        ),
        AstryxText(
          _chosen == null ? 'Nothing chosen yet' : 'Chose $_chosen',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** **Nothing is hidden that a user cannot get to.** What falls off the end becomes a row in a real AstryxDropdownMenu (references/overlays.md), reachable by pointer, keyboard and screen reader alike — and the items it stands in for leave the semantics tree, so nobody hears the same list twice. That is the difference between this and clipping the row.

### AstryxOverflowList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `items` **(required)** | `List<AstryxOverflowItem>` | — | The items, in order. The tail is what overflows. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing2` | The space between items, and before the trigger. |
| `menuLabel` | `String?` | — | An accessible name for the overflow menu. |
| `minVisible` | `int` | `1` | How many items stay on the row however narrow it gets. |

### AstryxOverflowItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The item’s name, used for its menu row. |
| `child` **(required)** | `Widget` | — | What is drawn on the row while the item fits. |
| `onSelected` | `VoidCallback?` | — | Called when the item is chosen from the menu. Null makes the menu row inert — right for a tag rather than an action. |
| `icon` | `Widget?` | — | An icon before the label in the menu. |
| `enabled` | `bool` | `true` | Whether the menu row can be chosen. |

---

## AstryxMetadataList

`lib/src/components/data/metadata_list.dart` · upstream `MetadataList / MetadataListItem`

Label-and-value pairs, for the details panel of a record.

```dart
class MetadataListDemoExample extends StatelessWidget {
  const MetadataListDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxMetadataList(
      items: <AstryxMetadataItem>[
        AstryxMetadataItem(
          label: 'Owner',
          value: AstryxText('Ada Lovelace'),
          semanticsValue: 'Ada Lovelace',
        ),
        AstryxMetadataItem(
          label: 'Created',
          value: AstryxText('3 March 2026'),
          semanticsValue: '3 March 2026',
        ),
        AstryxMetadataItem(
          label: 'Status',
          // A widget value needs `semanticsValue`: without it a screen reader
          // is read the badge's colour story rather than the word "Live".
          semanticsValue: 'Live',
          value: AstryxBadge('Live', variant: AstryxBadgeVariant.success),
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** A pair is one semantics node, so a screen reader reads "Owner, Ada Lovelace" rather than stopping between the two halves of one fact. Set `semanticsValue` whenever the value is not plain text: a badge announces its own contents, and "green dot, Healthy" has one word of information in it.

### AstryxMetadataList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `items` **(required)** | `List<AstryxMetadataItem>` | — | The pairs, in order. |
| `direction` | `AstryxMetadataListDirection` | `AstryxMetadataListDirection.stacked` | Whether a label sits above its value (`stacked`) or beside it (`inline`). |
| `labelWidth` | `double` | `140` | The width of the label column when inline. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The space between pairs. |

### AstryxMetadataItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | What the value is. |
| `value` **(required)** | `Widget` | — | The value itself. `AstryxMetadataItem.text` builds it from a string and sets the announcement to match. |
| `icon` | `Widget?` | — | An icon before the label. |
| `semanticsValue` | `String?` | — | What a screen reader reads as the value. Required in practice whenever `value` is not plain text. |

---

## AstryxEmptyState

`lib/src/components/data/empty_state.dart` · upstream `EmptyState`

What a list, table or panel shows when it has nothing to show.

```dart
class EmptyStateDemoExample extends StatelessWidget {
  const EmptyStateDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxEmptyState(
      icon: const AstryxIcon(AstryxIconName.search),
      title: 'No deploys yet',
      description: 'Push to the main branch and the first one will show here.',
      actions: <Widget>[
        AstryxButton(
          label: 'Read the guide',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Import a project', onPressed: () {}),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **An empty state is not an error.** Nothing has gone wrong when a new project has no deploys, so this does not announce itself, take a status colour, or borrow AstryxBanner (references/surfaces.md)’s urgency. What it carries instead is the one action that ends the emptiness — the difference between "No results" and a screen a user can leave.
- **Accessibility:** The title is a level-3 heading: an empty state stands in for content, so it belongs in the outline where that content would have been. The icon is decorative and stays out of the semantics tree — the title carries the meaning.

### AstryxEmptyState

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `title` **(required)** | `String` | — | What is missing, in a few words. |
| `description` | `String?` | — | A line under the title, saying why, or what would fill it. |
| `icon` | `Widget?` | — | A decorative icon above the title. |
| `actions` | `List<Widget>` | `const <Widget>[]` | The way out: one action, or two at most. |
| `size` | `AstryxEmptyStateSize` | `AstryxEmptyStateSize.standard` | How much room the block takes. |
| `minHeight` | `double?` | — | A floor under the height, so a list’s height does not jump when rows arrive. |
| `maxWidth` | `double` | `380` | A ceiling on the text’s width, so the description stays readable. |

### AstryxEmptyStateSize

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `compact` | `AstryxEmptyStateSize` | — | For an empty state inside a card, a popover or a table body. |
| `standard` | `AstryxEmptyStateSize` | — | The default, for an empty page or a full-width panel. |

---

## AstryxCode

`lib/src/components/data/code.dart` · upstream `Code`

Inline monospace, for a symbol or a value inside a sentence.

```dart
class CodeDemoExample extends StatelessWidget {
  const CodeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCode('AstryxSpacingToken.spacing4'),
        AstryxCode('--color-accent'),
        AstryxCode('flutter pub get'),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Set `semanticsLabel` for a string that is unreadable aloud — a hex colour, a token with no spaces in it. What a screen reader makes of `#0064E0` is noise, and "hex 0064E0" is not.

### AstryxCode

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `data` **(required)** | `String` | — | The code. The positional first argument. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |

---

## AstryxCodeBlock

`lib/src/components/data/code.dart` · upstream `CodeBlock`

A fenced block of code, with the language, copy control and optional line numbers.

```dart
class CodeBlockDemoExample extends StatelessWidget {
  const CodeBlockDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxCodeBlock('''
AstryxCard(
  header: const AstryxHeading('Usage', level: 4),
  child: const AstryxText('4,201 requests this month.'),
)''', language: 'dart');
  }
}
```

**Rules**

- **Careful:** **Nothing is highlighted.** Upstream colours its blocks with a JavaScript tokeniser that has no counterpart here, and a half-right highlighter is worse than none: code coloured by a grammar that does not match the language is code that lies about what it means. `language` is a label the reader sees, not an instruction.
- **Accessibility:** The line numbers are decoration: they are not copied with the code and not read aloud, because "1 2 3 4" is not the program.

### AstryxCodeBlock

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `code` **(required)** | `String` | — | The code, newline-separated. The positional first argument. |
| `language` | `String?` | — | The language, shown in the header. A label, not a highlighting instruction. |
| `showLineNumbers` | `bool` | `false` | Whether to number the lines. |
| `showCopy` | `bool` | `true` | Whether to offer a copy button. |
| `wrap` | `bool` | `false` | Whether long lines wrap instead of scrolling sideways. |
| `maxHeight` | `double?` | — | The tallest the block may be before it scrolls. |
| `semanticsLabel` | `String?` | — | What a screen reader announces instead of the code. |

---

## AstryxBlockquote

`lib/src/components/data/blockquote.dart` · upstream `Blockquote`

A quotation set apart from the surrounding prose.

```dart
class BlockquoteDemoExample extends StatelessWidget {
  const BlockquoteDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxBlockquote(
      'The deploy took eleven minutes and nobody could tell why until we read '
      'the logs in the wrong order and found it by accident.',
      attribution: 'Incident 412, postmortem',
    );
  }
}
```

### AstryxBlockquote

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `quote` **(required)** | `String` | — | The quoted text. The positional first argument, and empty when `child` carries the quotation instead. |
| `attribution` | `String?` | — | Who or what is being quoted, shown under it. |
| `child` | `Widget?` | — | Replaces `quote` with arbitrary content — a list, a table, code. |

---

## AstryxKbd

`lib/src/components/data/kbd.dart` · upstream `Kbd`

A keyboard key or chord, rendered as a key.

```dart
class KbdDemoExample extends StatelessWidget {
  const KbdDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxKbd('K'),
        const AstryxKbd.chord(<String>['Ctrl', 'K']),
        const AstryxKbd.chord(
          <String>['⌘', '⇧', 'P'],
          // A string of symbols is not a shortcut anyone can follow.
          semanticsLabel: 'Command Shift P',
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** **The glyphs are yours.** This does not translate `Ctrl` to `⌘` on a Mac, because only the caller knows whether the shortcut is the platform’s or the product’s own — and a key cap showing the wrong modifier is worse than one showing a name.
- **Accessibility:** A chord is one semantics node, not one per cap. Set `semanticsLabel` whenever the caps are symbols: `⌘ ⇧ P` read out as a string of glyphs is not a shortcut anyone can follow.

### AstryxKbd

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `keys` **(required)** | `List<String>` | — | The keys, in the order they are shown. The positional argument of `AstryxKbd.chord`; the default constructor takes one `String`. |
| `size` | `AstryxKbdSize` | `AstryxKbdSize.md` | How large the caps are drawn. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to the keys, space-separated. |

### AstryxKbdSize

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `sm` | `AstryxKbdSize` | — | Beside `supporting` text — a hint in a menu row, a footnote. |
| `md` | `AstryxKbdSize` | — | The default, beside `body` text. |

---

