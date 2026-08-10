---
title: Dashboard
description: Summary tiles above a table of what needs attention.
component: true
group: Templates
source: example/lib/examples/template_screen_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DashboardTemplate extends StatefulWidget {
  const DashboardTemplate({super.key});

  @override
  State<DashboardTemplate> createState() => _DashboardTemplateState();
}

class _DashboardTemplateState extends State<DashboardTemplate> {
  String _range = '7d';

  @override
  Widget build(BuildContext context) {
    final open = incidents.where((row) => !row.resolved).toList();

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // Title and range picker on one line at width, stacked below it when
        // there is no room. Not `wrap: true`: a wrapped row hands its children
        // unbounded width, so the supporting line would refuse to break and
        // overflow instead of moving.
        LayoutBuilder(
          builder: (context, constraints) {
            // A range picker as an attached button group, the selected segment
            // taking the louder variant. That is the segmented control until
            // `SegmentedControl` is ported.
            final picker = AstryxButtonGroup(
              size: AstryxButtonSize.sm,
              children: <Widget>[
                for (final range in const <String>['24h', '7d', '30d'])
                  AstryxButton(
                    label: range,
                    variant: _range == range
                        ? AstryxButtonVariant.primary
                        : AstryxButtonVariant.secondary,
                    onPressed: () => setState(() => _range = range),
                  ),
              ],
            );

            return constraints.maxWidth < 520
                ? AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    children: <Widget>[const _DashboardTitle(), picker],
                  )
                : AstryxHStack(
                    gap: AstryxSpacingToken.spacing4,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Flexible(child: _DashboardTitle()),
                      picker,
                    ],
                  );
          },
        ),
        // Tiles first, and the column count falls out of the width rather than
        // out of a breakpoint table.
        const AstryxGrid(
          minWidth: 190,
          maxColumns: 4,
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            _Tile(
              label: 'Availability',
              value: '99.94%',
              detail: 'Objective 99.90%',
              progress: 0.9994,
              variant: AstryxProgressVariant.success,
            ),
            _Tile(
              label: 'p95 latency',
              value: '318 ms',
              detail: 'Objective 400 ms',
              progress: 0.79,
            ),
            _Tile(
              label: 'Error budget',
              value: '38% left',
              detail: 'Resets in 12 days',
              progress: 0.38,
              variant: AstryxProgressVariant.warning,
            ),
            _Tile(
              label: 'Open incidents',
              value: '2',
              detail: 'One at Sev-1',
              progress: null,
            ),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // `Flexible`, so the heading wraps on a narrow screen instead
                // of pushing the link past the edge.
                const Flexible(child: AstryxHeading('Open incidents')),
                AstryxButton(
                  label: 'All incidents',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  trailing: const AstryxIcon(
                    AstryxIconName.chevronRight,
                    size: AstryxIconSize.sm,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            AstryxTable<Incident>(
              label: 'Open incidents',
              rows: open,
              keyOf: (row) => row.id,
              rowLabelOf: (row) => row.title,
              emptyState: const AstryxCenter(
                minHeight: 160,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: AstryxStackAlign.center,
                  children: <Widget>[
                    AstryxIcon(
                      AstryxIconName.success,
                      size: AstryxIconSize.lg,
                      color: AstryxIconColor.success,
                    ),
                    AstryxHeading('Nothing on fire', level: 4),
                    AstryxText(
                      'Every service is inside its objective.',
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ),
              columns: <AstryxTableColumn<Incident>>[
                AstryxTableColumn<Incident>(
                  id: 'title',
                  header: 'Incident',
                  width: const AstryxTableColumnWidth.flex(1.6),
                  cellBuilder: (context, row) =>
                      AstryxText(row.title, maxLines: 1),
                ),
                AstryxTableColumn<Incident>(
                  id: 'severity',
                  header: 'Severity',
                  width: const AstryxTableColumnWidth.intrinsic(min: 96),
                  cellBuilder: (context, row) => AstryxBadge(
                    row.severityLabel,
                    variant: severityVariant(row.severity),
                  ),
                ),
                AstryxTableColumn<Incident>(
                  id: 'owner',
                  header: 'On call',
                  cellBuilder: (context, row) => AstryxText(row.owner),
                ),
                AstryxTableColumn<Incident>(
                  id: 'age',
                  header: 'Age',
                  width: const AstryxTableColumnWidth.fixed(80),
                  alignment: AstryxTableAlignment.end,
                  cellBuilder: (context, row) => AstryxText(
                    formatMinutes(row.minutes),
                    tabularNumbers: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
```

Resize the window: the tile row re-flows on width alone, with no breakpoints involved.


## Tiles first, and the count falls out of the width

`AstryxGrid(minWidth: 190, maxColumns: 4)` is the whole responsive story — the same thing `repeat(auto-fit, minmax(190px, 1fr))` does upstream. Four tiles across on a desktop, two on a tablet, one on a phone, and no breakpoint table to maintain.

Each tile pairs a figure with the objective it is measured against, because "99.94%" alone is not information. The progress bar is `showLabel: false` — the tile’s own label is already the accessible name, and two labels on one control is noise — and the open-incident tile has no bar at all: a count has no proportion to show.

## An objective, or a colour that means nothing

| Tile | Variant | Because |
| --- | --- | --- |
| Availability | `success` | Above its objective. |
| p95 latency | `accent` | Inside its objective, neutrally. |
| Error budget | `warning` | Being consumed faster than the window refills it. |
| Open incidents | no bar | A count, not a proportion. |

## Then the table, filtered to what matters

The table shows open incidents only — the dashboard’s job is what needs attention, not everything that ever happened — with a ghost button through to the full [table screen](table_template.md). Filtering happens in the caller, because `AstryxTable.rows` is documented as already filtered and paginated.

Its `emptyState` is the good news: "Nothing on fire". An empty table with no empty state looks like a table that failed to load.

> **Careful**
>
> **The range picker is an `AstryxButtonGroup`, not a segmented control.** `SegmentedControl` is not ported, so the selected segment takes the louder `variant` inside an attached group. It behaves correctly and it is three buttons — it is not one tab stop with arrow-key traversal, which is what the real component will bring.

> **Note**
>
> There is no chart here. Upstream’s dashboard templates lean on one, and this port ships no charting widget — the tiles carry the numbers instead. Reach a token with `AstryxTheme.of(context).color(…)` if you are wiring up your own chart library.

## Related

- [Table](table_template.md) — the full list, with filters and selection.
- [Detail page](detail_page.md) — one row of that table, opened.
- [AstryxGrid](grid.md) — responsive tracks without breakpoints.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

