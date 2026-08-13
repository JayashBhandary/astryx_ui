---
title: Table
description: 'A data table as a screen: a toolbar, filtering, sorting, selection and row actions.'
component: true
group: Templates
source: example/lib/examples/template_screen_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TableTemplate extends StatefulWidget {
  const TableTemplate({super.key});

  @override
  State<TableTemplate> createState() => _TableTemplateState();
}

class _TableTemplateState extends State<TableTemplate> {
  final TextEditingController _query = TextEditingController();

  AstryxTableSort? _sort = const AstryxTableSort(
    'severity',
    AstryxSortDirection.ascending,
  );
  Set<Object> _selected = <Object>{};
  String _status = 'all';

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Filtering happens here, not in the table: `rows` is documented as already
  /// filtered, and a table that filtered its own rows could not tell the
  /// difference between "no matches" and "no data".
  List<Incident> get _rows {
    final query = _query.text.trim().toLowerCase();
    return incidents.where((row) {
      final matchesStatus = switch (_status) {
        'open' => !row.resolved,
        'resolved' => row.resolved,
        _ => true,
      };
      final matchesQuery =
          query.isEmpty ||
          row.title.toLowerCase().contains(query) ||
          row.service.toLowerCase().contains(query) ||
          row.owner.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Incidents', level: 1)),
            AstryxButton(
              label: 'Declare incident',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        // The toolbar: search, a filter in a popover, and a column menu. All
        // three are always visible — none of them is behind hover.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 260,
              child: AstryxTextInput(
                label: 'Search incidents',
                labelHidden: true,
                controller: _query,
                placeholder: 'Search title, service or owner',
                leading: const AstryxIcon(AstryxIconName.search),
                showClear: true,
                size: AstryxInputSize.sm,
                onChanged: (_) => setState(() {}),
              ),
            ),
            AstryxPopover(
              label: 'Filter incidents',
              width: 240,
              content: AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxRadioList<String>(
                    label: 'Status',
                    value: _status,
                    size: AstryxToggleSize.sm,
                    onChanged: (value) => setState(() => _status = value),
                    options: const <AstryxRadioOption<String>>[
                      AstryxRadioOption(value: 'all', label: 'Everything'),
                      AstryxRadioOption(value: 'open', label: 'Open only'),
                      AstryxRadioOption(
                        value: 'resolved',
                        label: 'Resolved only',
                      ),
                    ],
                  ),
                ],
              ),
              triggerBuilder: (context, controller) => AstryxButton(
                label: _status == 'all' ? 'Filter' : 'Filter: $_status',
                size: AstryxButtonSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.sm,
                ),
                onPressed: controller.toggle,
              ),
            ),
            AstryxDropdownMenu(
              label: 'Table options',
              width: 200,
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('Rows'),
                AstryxMenuItem(
                  label: 'Export as CSV',
                  icon: const AstryxIcon(AstryxIconName.copy),
                  onSelected: () {},
                ),
                AstryxMenuItem(
                  label: 'Subscribe to this view',
                  onSelected: () {},
                ),
              ],
              triggerBuilder: (context, controller) => AstryxIconButton(
                icon: AstryxIconName.viewColumns,
                label: 'Table options',
                tooltip: 'Table options',
                size: AstryxButtonSize.sm,
                onPressed: controller.toggle,
              ),
            ),
          ],
        ),
        // The selection bar appears once something is selected and says how
        // many, because "Delete" with no count is a question the user cannot
        // answer.
        if (_selected.isNotEmpty)
          AstryxBanner(
            title: '${_selected.length} selected',
            announce: false,
            actions: <Widget>[
              AstryxButton(
                label: 'Resolve',
                size: AstryxButtonSize.sm,
                onPressed: () => setState(_selected.clear),
              ),
              AstryxButton(
                label: 'Clear',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () => setState(_selected.clear),
              ),
            ],
          ),
        AstryxTable<Incident>(
          label: 'Incidents',
          rows: rows,
          keyOf: (row) => row.id,
          rowLabelOf: (row) => row.title,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          striped: true,
          maxHeight: 320,
          emptyState: AstryxCenter(
            minHeight: 180,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxIcon(
                  AstryxIconName.search,
                  size: AstryxIconSize.lg,
                  color: AstryxIconColor.secondary,
                ),
                const AstryxHeading('No incidents match', level: 4),
                const AstryxText(
                  'Every filter is still applied.',
                  color: AstryxTextColor.secondary,
                ),
                AstryxButton(
                  label: 'Clear filters',
                  onPressed: () => setState(() {
                    _query.clear();
                    _status = 'all';
                  }),
                ),
              ],
            ),
          ),
          rowActionsBuilder: (context, row) => AstryxDropdownMenu(
            width: 200,
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Open ${row.id}', onSelected: () {}),
              AstryxMenuItem(label: 'Reassign', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Delete',
                destructive: true,
                onSelected: () {},
              ),
            ],
            triggerBuilder: (context, controller) => AstryxIconButton(
              icon: AstryxIconName.moreHorizontal,
              label: 'Actions for ${row.title}',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: controller.toggle,
            ),
          ),
          columns: <AstryxTableColumn<Incident>>[
            AstryxTableColumn<Incident>(
              id: 'title',
              header: 'Incident',
              width: const AstryxTableColumnWidth.flex(1.8),
              compare: (a, b) => a.title.compareTo(b.title),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.title, maxLines: 1),
                  AstryxText(
                    row.service,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'severity',
              header: 'Severity',
              width: const AstryxTableColumnWidth.intrinsic(min: 100),
              // Sorting on the number, showing the label: "Sev-10" would sort
              // between "Sev-1" and "Sev-2" as a string.
              compare: (a, b) => a.severity.compareTo(b.severity),
              cellBuilder: (context, row) => AstryxBadge(
                row.severityLabel,
                variant: severityVariant(row.severity),
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'status',
              header: 'Status',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              cellBuilder: (context, row) => AstryxBadge(
                row.resolved ? 'Resolved' : 'Open',
                variant: row.resolved
                    ? AstryxBadgeVariant.success
                    : AstryxBadgeVariant.warning,
                icon: AstryxIcon(
                  row.resolved
                      ? AstryxIconName.success
                      : AstryxIconName.warning,
                ),
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'age',
              header: 'Age',
              width: const AstryxTableColumnWidth.fixed(80),
              alignment: AstryxTableAlignment.end,
              headerTooltip: 'Time since the alert fired',
              compare: (a, b) => a.minutes.compareTo(b.minutes),
              cellBuilder: (context, row) =>
                  AstryxText(formatMinutes(row.minutes), tabularNumbers: true),
            ),
          ],
        ),
        AstryxText(
          '${rows.length} of ${incidents.length} incidents'
          '${_sort == null ? '' : ' · sorted by ${_sort!.columnId}'}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

Search for something that does not exist to see the empty state; tick a row to see the selection bar.


## The table does not filter itself

Search and the status filter both narrow the list in the caller, and `rows` gets the result. That is deliberate: a table that filtered its own rows could not tell "no matches" from "no data", and those need different empty states — one offers to clear the filters, the other offers to create the first record.

```dart
List<Incident> get _rows {
  final query = _query.text.trim().toLowerCase();
  return incidents.where((row) {
    final matchesStatus = switch (_status) {
      'open' => !row.resolved,
      'resolved' => row.resolved,
      _ => true,
    };
    return matchesStatus &&
        (query.isEmpty || row.title.toLowerCase().contains(query));
  }).toList();
}
```

## The toolbar

```text
AstryxHStack(wrap: true)
├── AstryxTextInput(leading: search, showClear: true, labelHidden: true)
├── AstryxPopover  ← the status filter, and the trigger says what is applied
└── AstryxDropdownMenu ← export, subscribe
```

The search field is `labelHidden: true`, not label-less: the placeholder is invisible to a screen reader once text is typed, so the name has to exist somewhere. The filter trigger changes its own label to `Filter: open` when a filter is on, because a filter you cannot see is a table lying about how much data there is.

## Sorting: on the number, showing the label

A column is sortable when — and only when — it has a `compare`. The severity column shows a badge reading "Sev-1" but compares the integer behind it, which is the whole reason the row type keeps both. Sorting the label as a string puts Sev-10 between Sev-1 and Sev-2.

Pressing a header cycles ascending → descending → unsorted. That third state is not a nicety: without it there is no way back to the order the rows arrived in.

## Selection needs a count and a name

The selection bar appears once something is ticked and says how many. **Resolve** with no count is a question the user cannot answer. And `rowLabelOf` is what names each row’s checkbox — without it every one of them is announced as "Select row", which is true of all of them and therefore useless.

> **Accessibility**
>
> Row actions are **always visible**. Hover does not exist on touch, and the density system actively suppresses hover styling there — an action that only appears under a pointer is an action half your users do not have.

> **Careful**
>
> **Do not put `truncateTooltip: true` in a table cell.** Deciding whether text is cut off needs the cell’s final width, and a table row is measured before it is laid out — the layout asserts in touch density. `maxLines: 1` on its own is what these cells use; the ellipsis is the signal, and a screen reader gets the whole string either way.

> **Careful**
>
> **No pagination here, and no virtualisation anywhere.** `AstryxTable` does not virtualise rows: a `maxHeight` scrolls the body, and a few hundred rows is fine. Past that, page in your own data layer — the [table page](table_page.md) template is that screen, with [AstryxPagination](pagination.md) in the footer.

## Related

- [AstryxTable](table.md) — every property, and the three width strategies.
- [Table page](table_page.md) — the same table as a whole screen, paginated.
- [Dashboard](dashboard.md) — the same data, summarised.
- [Detail page](detail_page.md) — where a row leads.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Table`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Table&component=Table) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Table&area=Table) — both templates arrive with the component filled in.
