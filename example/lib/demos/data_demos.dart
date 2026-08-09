import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/widgets.dart';

/// `AstryxTabList`.
abstract final class TabListDemo {
  static Widget build(BuildContext context) => const _TabListDemo();
}

class _TabListDemo extends StatefulWidget {
  const _TabListDemo();

  @override
  State<_TabListDemo> createState() => _TabListDemoState();
}

class _TabListDemoState extends State<_TabListDemo> {
  String _tab = 'overview';
  String _sized = 'a';
  int _many = 0;

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Tabs with icons and a badge',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxTabList<String>(
              value: _tab,
              onChanged: (value) => setState(() => _tab = value),
              tabs: const <AstryxTab<String>>[
                AstryxTab(
                  value: 'overview',
                  label: 'Overview',
                  icon: AstryxIcon(AstryxIconName.info),
                ),
                AstryxTab(
                  value: 'activity',
                  label: 'Activity',
                  badge: AstryxBadge(
                    '12',
                    semanticsLabel: '12 new',
                    variant: AstryxBadgeVariant.info,
                  ),
                ),
                AstryxTab(
                  value: 'settings',
                  label: 'Settings',
                  icon: AstryxIcon(AstryxIconName.wrench),
                ),
                AstryxTab(
                  value: 'archive',
                  label: 'Archive',
                  enabled: false,
                ),
              ],
            ),
            AstryxText('Panel: $_tab'),
          ],
        ),
      ),
      DemoSection(
        title: 'Sizes, and fill',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (final size in AstryxTabSize.values)
              AstryxTabList<String>(
                size: size,
                value: _sized,
                onChanged: (value) => setState(() => _sized = value),
                tabs: const <AstryxTab<String>>[
                  AstryxTab(value: 'a', label: 'First'),
                  AstryxTab(value: 'b', label: 'Second'),
                  AstryxTab(value: 'c', label: 'Third'),
                ],
              ),
            AstryxTabList<String>(
              fill: true,
              value: _sized,
              onChanged: (value) => setState(() => _sized = value),
              tabs: const <AstryxTab<String>>[
                AstryxTab(value: 'a', label: 'First'),
                AstryxTab(value: 'b', label: 'Second'),
                AstryxTab(value: 'c', label: 'Third'),
              ],
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Overflow scrolls, with a fade at the edge that has more',
        child: SizedBox(
          width: 360,
          child: AstryxTabList<int>(
            value: _many,
            onChanged: (value) => setState(() => _many = value),
            tabs: <AstryxTab<int>>[
              for (var i = 0; i < 16; i++)
                AstryxTab<int>(value: i, label: 'Section $i'),
            ],
          ),
        ),
      ),
    ],
  );
}

/// `AstryxTable`.
abstract final class TableDemo {
  static Widget build(BuildContext context) => const _TableDemo();
}

class _Project {
  const _Project(this.id, this.name, this.owner, this.requests, this.status);

  final String id;
  final String name;
  final String owner;
  final int requests;
  final AstryxBadgeVariant status;
}

const _projects = <_Project>[
  _Project('p1', 'Atlas', 'Ada Lovelace', 4201, AstryxBadgeVariant.success),
  _Project('p2', 'Beacon', 'Alan Turing', 118, AstryxBadgeVariant.warning),
  _Project('p3', 'Cinder', 'Grace Hopper', 0, AstryxBadgeVariant.error),
  _Project(
    'p4',
    'Delta',
    'Katherine Johnson',
    92_300,
    AstryxBadgeVariant.success,
  ),
  _Project('p5', 'Ember', 'Ada Lovelace', 7, AstryxBadgeVariant.neutral),
];

class _TableDemo extends StatefulWidget {
  const _TableDemo();

  @override
  State<_TableDemo> createState() => _TableDemoState();
}

class _TableDemoState extends State<_TableDemo> {
  AstryxTableSort? _sort = const AstryxTableSort(
    'name',
    AstryxSortDirection.ascending,
  );
  Set<Object> _selected = <Object>{};
  AstryxTableDensity _density = AstryxTableDensity.balanced;
  bool _striped = true;

  List<AstryxTableColumn<_Project>> get _columns =>
      <AstryxTableColumn<_Project>>[
        AstryxTableColumn<_Project>(
          id: 'name',
          header: 'Project',
          compare: (a, b) => a.name.compareTo(b.name),
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<_Project>(
          id: 'owner',
          header: 'Owner',
          width: const AstryxTableColumnWidth.flex(1.4),
          compare: (a, b) => a.owner.compareTo(b.owner),
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
        AstryxTableColumn<_Project>(
          id: 'status',
          header: 'Status',
          // Intrinsic, because the badges are short and their width varies —
          // the case the strategy is documented for.
          width: const AstryxTableColumnWidth.intrinsic(min: 90),
          cellBuilder: (context, row) => AstryxBadge(
            switch (row.status) {
              AstryxBadgeVariant.success => 'Healthy',
              AstryxBadgeVariant.warning => 'Degraded',
              AstryxBadgeVariant.error => 'Down',
              _ => 'Idle',
            },
            variant: row.status,
          ),
        ),
        AstryxTableColumn<_Project>(
          id: 'requests',
          header: 'Requests',
          width: const AstryxTableColumnWidth.fixed(120),
          alignment: AstryxTableAlignment.end,
          compare: (a, b) => a.requests.compareTo(b.requests),
          cellBuilder: (context, row) => AstryxText('${row.requests}'),
        ),
      ];

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Controls',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
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
            AstryxText(
              '${_selected.length} selected',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Sorting, selection, row actions and a pinned header',
        child: AstryxTable<_Project>(
          label: 'Projects',
          rows: _projects,
          keyOf: (row) => row.id,
          columns: _columns,
          density: _density,
          striped: _striped,
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          rowLabelOf: (row) => row.name,
          maxHeight: 320,
          rowActionsBuilder: (context, row) => AstryxDropdownMenu(
            width: 180,
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Open ${row.name}', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Delete',
                destructive: true,
                onSelected: () {},
              ),
            ],
            triggerBuilder: (context, controller) => AstryxIconButton(
              icon: AstryxIconName.moreHorizontal,
              label: 'Actions for ${row.name}',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: controller.toggle,
            ),
          ),
        ),
      ),
      const DemoSection(
        title: 'Empty',
        child: AstryxTable<_Project>(
          rows: <_Project>[],
          keyOf: _keyOf,
          columns: <AstryxTableColumn<_Project>>[],
        ),
      ),
    ],
  );

  static Object _keyOf(_Project row) => row.id;
}
