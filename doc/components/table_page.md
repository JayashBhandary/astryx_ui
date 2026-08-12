---
title: Table page
description: 'A table as a whole screen: filters in a pinned header, pagination in a pinned footer.'
component: true
group: Templates
source: example/lib/examples/template_table_page_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One row of the table.
class Run {
  const Run({
    required this.id,
    required this.pipeline,
    required this.branch,
    required this.owner,
    required this.seconds,
    required this.state,
  });

  final String id;
  final String pipeline;
  final String branch;
  final String owner;
  final int seconds;

  /// `passed`, `failed` or `running`.
  final String state;
}

/// Forty-two rows, which is the whole point: three pages of fourteen.
///
/// Generated rather than typed out, and deterministic — an example that
/// shuffles itself is an example whose screenshot cannot be trusted.
final List<Run> runs = <Run>[
  for (var i = 0; i < 42; i++)
    Run(
      id: 'r-${4200 - i}',
      pipeline: const <String>[
        'payments-api',
        'events',
        'edge',
        'reports',
      ][i % 4],
      branch: i.isEven ? 'main' : 'release/4.2',
      owner: const <String>[
        'Ada Lovelace',
        'Alan Turing',
        'Grace Hopper',
        'Katherine Johnson',
      ][i % 4],
      seconds: 40 + (i * 37) % 900,
      state: switch (i % 7) {
        0 => 'failed',
        1 => 'running',
        _ => 'passed',
      },
    ),
];

class TablePageTemplate extends StatefulWidget {
  const TablePageTemplate({super.key});

  @override
  State<TablePageTemplate> createState() => _TablePageTemplateState();
}

class _TablePageTemplateState extends State<TablePageTemplate> {
  static const List<int> _pageSizes = <int>[7, 14, 28];

  final TextEditingController _query = TextEditingController();

  AstryxTableSort? _sort;
  String _state = 'all';
  int _pageSize = 14;
  int _page = 1;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Every row that survives the filters, in whatever order sorting asked for.
  ///
  /// Filtering *and* sorting happen here, not in the table. That is not a
  /// preference: a page is a window onto the sorted set, so the sort has to be
  /// applied before the window is cut — a table sorting the fourteen rows it
  /// was handed would sort one page at a time.
  List<Run> get _matches {
    final query = _query.text.trim().toLowerCase();
    final rows =
        runs.where((row) {
          final matchesState = _state == 'all' || row.state == _state;
          final matchesQuery =
              query.isEmpty ||
              row.id.contains(query) ||
              row.pipeline.contains(query) ||
              row.branch.contains(query) ||
              row.owner.toLowerCase().contains(query);
          return matchesState && matchesQuery;
        }).toList();

    final sort = _sort;
    if (sort != null) {
      final compare = switch (sort.columnId) {
        'run' => (Run a, Run b) => a.id.compareTo(b.id),
        'duration' => (Run a, Run b) => a.seconds.compareTo(b.seconds),
        'owner' => (Run a, Run b) => a.owner.compareTo(b.owner),
        _ => null,
      };
      if (compare != null) {
        rows.sort(
          sort.direction == AstryxSortDirection.ascending
              ? compare
              : (a, b) => compare(b, a),
        );
      }
    }

    return rows;
  }

  int get _pageCount => (_matches.length / _pageSize).ceil().clamp(1, 999);

  /// The rows this page shows.
  List<Run> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Run>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// Any change to the filters puts the reader back on page one.
  ///
  /// Leaving them on page three of a set that now has two is how a filter
  /// produces an empty screen that looks like a bug.
  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final first = matches.isEmpty ? 0 : (_page - 1) * _pageSize + 1;
    final last = first + rows.length - (rows.isEmpty ? 0 : 1);

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        // The table scrolls its own body under a pinned header row, so the page
        // must not scroll as well — two scroll views inside one another is one
        // too many.
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Flexible(child: AstryxHeading('Pipeline runs', level: 1)),
                AstryxButton(
                  label: 'Run pipeline',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 240,
                  child: AstryxTextInput(
                    label: 'Search runs',
                    labelHidden: true,
                    controller: _query,
                    placeholder: 'Run, pipeline, branch or owner',
                    leading: const AstryxIcon(AstryxIconName.search),
                    showClear: true,
                    size: AstryxInputSize.sm,
                    onChanged: (_) => _refilter(() {}),
                  ),
                ),
                // A segmented control rather than a menu: three states, all
                // worth seeing at once, and the applied one is visible without
                // opening anything.
                AstryxSegmentedControl<String>(
                  label: 'State',
                  value: _state,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _state = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'all', label: 'All'),
                    AstryxSegment(value: 'passed', label: 'Passed'),
                    AstryxSegment(value: 'failed', label: 'Failed'),
                  ],
                ),
                const Spacer(),
                AstryxText(
                  '${matches.length} of ${runs.length} runs',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // The range, not just the page number: "1–14 of 38" is the sentence
            // that tells a reader how much they have not seen.
            AstryxText(
              matches.isEmpty ? 'Nothing to show' : '$first–$last of '
                  '${matches.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                AstryxSelector<int>(
                  label: 'Rows per page',
                  labelHidden: true,
                  value: _pageSize,
                  width: 132,
                  size: AstryxInputSize.sm,
                  onChanged: (value) => _refilter(
                    () => _pageSize = value ?? _pageSize,
                  ),
                  options: <AstryxSelectorOption<int>>[
                    for (final size in _pageSizes)
                      AstryxSelectorOption<int>(
                        value: size,
                        label: '$size per page',
                      ),
                  ],
                ),
                AstryxPagination(
                  label: 'Runs',
                  page: _page,
                  pageCount: _pageCount,
                  onPageChanged: (page) => setState(() => _page = page),
                ),
              ],
            ),
          ],
        ),
        child: AstryxTable<Run>(
          label: 'Pipeline runs',
          rows: rows,
          keyOf: (row) => row.id,
          rowLabelOf: (row) => '${row.id} — ${row.pipeline}',
          sort: _sort,
          // Sorting is a change to the whole set, so it resets the page too.
          onSortChanged: (sort) => _refilter(() => _sort = sort),
          striped: true,
          emptyState: AstryxCenter(
            minHeight: 220,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxIcon(
                  AstryxIconName.search,
                  size: AstryxIconSize.lg,
                  color: AstryxIconColor.secondary,
                ),
                const AstryxHeading('No runs match', level: 4),
                const AstryxText(
                  'Every filter is still applied.',
                  color: AstryxTextColor.secondary,
                ),
                AstryxButton(
                  label: 'Clear filters',
                  onPressed: () => _refilter(() {
                    _query.clear();
                    _state = 'all';
                  }),
                ),
              ],
            ),
          ),
          rowActionsBuilder: (context, row) => AstryxIconButton(
            icon: AstryxIconName.externalLink,
            label: 'Open ${row.id}',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
          columns: <AstryxTableColumn<Run>>[
            AstryxTableColumn<Run>(
              id: 'run',
              header: 'Run',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              compare: (a, b) => a.id.compareTo(b.id),
              cellBuilder: (context, row) =>
                  AstryxCode(row.id, semanticsLabel: 'Run ${row.id}'),
            ),
            AstryxTableColumn<Run>(
              id: 'pipeline',
              header: 'Pipeline',
              width: const AstryxTableColumnWidth.flex(1.4),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.pipeline, maxLines: 1),
                  AstryxText(
                    row.branch,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            AstryxTableColumn<Run>(
              id: 'state',
              header: 'State',
              width: const AstryxTableColumnWidth.intrinsic(min: 104),
              cellBuilder: (context, row) => switch (row.state) {
                'failed' => const AstryxBadge(
                  'Failed',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                'running' => const AstryxBadge(
                  'Running',
                  variant: AstryxBadgeVariant.info,
                  icon: AstryxIcon(AstryxIconName.clock),
                ),
                _ => const AstryxBadge(
                  'Passed',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
                ),
              },
            ),
            AstryxTableColumn<Run>(
              id: 'owner',
              header: 'Owner',
              compare: (a, b) => a.owner.compareTo(b.owner),
              cellBuilder: (context, row) => AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxAvatar(name: row.owner, size: AstryxAvatarSize.xs),
                  Flexible(child: AstryxText(row.owner, maxLines: 1)),
                ],
              ),
            ),
            AstryxTableColumn<Run>(
              id: 'duration',
              header: 'Duration',
              width: const AstryxTableColumnWidth.fixed(96),
              alignment: AstryxTableAlignment.end,
              compare: (a, b) => a.seconds.compareTo(b.seconds),
              cellBuilder: (context, row) => AstryxText(
                '${(row.seconds / 60).floor()}m ${row.seconds % 60}s',
                tabularNumbers: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Change the page size, sort a column, then filter: the reader lands back on page one every time, and the range under the table says what they are looking at.


## Why this is not the table template

The [table](table_template.md) template is a composition inside a page. This is the page: the filters sit in an [AstryxLayout](layout.md) header that does not scroll, the pagination sits in a footer that does not scroll, and the only thing that moves is the rows. On a screen where the table *is* the work, a filter you have to scroll up to reach is a filter nobody reverts.

```text
AstryxLayout(scrollable: false)
├── header  ← title, search, state filter, "n of m"
├── child   ← AstryxTable, scrolling its own body under a pinned header row
└── footer  ← "15–28 of 38", rows-per-page, AstryxPagination
```

> **Careful**
>
> **`scrollable: false`.** `AstryxTable` scrolls its own body under its header row. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded — which is a layout assertion rather than a subtle bug.

## Sort the set, then cut the page

Both the filtering and the **sorting** happen in the caller, in that order, before the page is sliced out. This is the one thing a paginated table gets wrong most often: hand `rows` a single page and let the table sort it, and you have sorted fourteen rows out of thirty-eight — a column that reorders within the page and never moves a row between pages.

```dart
List<Run> get _matches {
  final rows = runs.where(_passesFilters).toList();   // filter the whole set
  if (_sort != null) rows.sort(_comparatorFor(_sort!));  // then sort it
  return rows;
}

List<Run> get _rows {                                // then cut the window
  final start = (_page - 1) * _pageSize;
  if (start >= _matches.length) return const <Run>[];
  return _matches.sublist(start, min(start + _pageSize, _matches.length));
}
```

## Every filter resets the page

Search, the state filter, the page size and the sort all go through one helper that sets `_page = 1`. Without it, narrowing a 38-row set while on page three shows an empty table — which reads as "no data" rather than "you are past the end", and is the single most common bug on a screen like this.

```dart
void _refilter(VoidCallback change) => setState(() {
  change();
  _page = 1;      // ← the whole point
});
```

## The footer counts, it does not just number

"Page 2 of 3" tells a reader nothing about how much they have not seen. "15–28 of 38" does, and it is the only line on the screen that distinguishes a filter that matched nothing from a data set that is empty. Both states are handled: the range collapses to "Nothing to show" and the table draws its own `emptyState` offering to clear the filters.

> **Accessibility**
>
> Row actions are always visible, never on hover — touch has no hover, and the density system suppresses hover styling there. `rowLabelOf` is what names each row for the action beside it: "Actions" repeated fourteen times is fourteen identical announcements.

> **Note**
>
> **Rows per page is a selector, not a switch or a segmented control.** It picks a value out of several and shows the current one, which is the line between [AstryxSelector](selector.md) and the other two.

## Related

- [AstryxPagination](pagination.md) — pages are one-based, the ends are always shown, and the arrows disable rather than disappear.
- [AstryxTable](table.md) — the table itself, and the three width strategies.
- [Table](table_template.md) — the same data as a composition rather than a page.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

