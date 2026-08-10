/// The whole-screen templates: a hero, a record, a dashboard, a table screen,
/// and every component at once.
///
/// None of these is a widget the package exports. They are compositions worth
/// copying, which is why the snippet is the point: each one is assembled only
/// from what `astryx_ui` actually ships, so pasting it compiles.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// One row of the incident tables on this page.
class Incident {
  const Incident({
    required this.id,
    required this.title,
    required this.service,
    required this.severity,
    required this.owner,
    required this.minutes,
    required this.resolved,
  });

  final String id;
  final String title;
  final String service;

  /// 1 is worst. Sorting on the number rather than the label is why the column
  /// carries it: "Sev-1" sorts after "Sev-2" as a string.
  final int severity;
  final String owner;
  final int minutes;
  final bool resolved;

  String get severityLabel => 'Sev-$severity';
}

/// The rows, already filtered and paginated — as `AstryxTable` expects them.
const List<Incident> incidents = <Incident>[
  Incident(
    id: 'i-4102',
    title: 'Checkout latency above 2s',
    service: 'payments-api',
    severity: 1,
    owner: 'Ada Lovelace',
    minutes: 42,
    resolved: false,
  ),
  Incident(
    id: 'i-4101',
    title: 'Webhook retries backing up',
    service: 'events',
    severity: 2,
    owner: 'Alan Turing',
    minutes: 128,
    resolved: false,
  ),
  Incident(
    id: 'i-4098',
    title: 'Stale cache in the EU region',
    service: 'edge',
    severity: 3,
    owner: 'Grace Hopper',
    minutes: 310,
    resolved: true,
  ),
  Incident(
    id: 'i-4094',
    title: 'Export job ran twice',
    service: 'reports',
    severity: 3,
    owner: 'Katherine Johnson',
    minutes: 1440,
    resolved: true,
  ),
  Incident(
    id: 'i-4090',
    title: 'Login rate limit too tight',
    service: 'auth',
    severity: 2,
    owner: 'Ada Lovelace',
    minutes: 2880,
    resolved: true,
  ),
];

/// The badge colour for a severity.
///
/// Colour is never the only signal here: the badge carries the words "Sev-1"
/// too, so the severity survives both a colour-blind reader and a greyscale
/// print.
AstryxBadgeVariant severityVariant(int severity) => switch (severity) {
  1 => AstryxBadgeVariant.error,
  2 => AstryxBadgeVariant.warning,
  _ => AstryxBadgeVariant.neutral,
};

/// "42m", "2h", "2d" — a duration a person can read at a glance.
String formatMinutes(int minutes) {
  if (minutes < 60) return '${minutes}m';
  if (minutes < 60 * 24) return '${(minutes / 60).round()}h';
  return '${(minutes / (60 * 24)).round()}d';
}

// #example template_centered_hero -> CenteredHeroTemplate
class CenteredHeroTemplate extends StatelessWidget {
  const CenteredHeroTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    // One measure, one heading, one action. `maxWidth` is what keeps the
    // supporting line readable — a hero that runs the full width of a desktop
    // window is a paragraph nobody finishes.
    return AstryxCenter(
      maxWidth: 620,
      minHeight: 360,
      padding: AstryxSpacingToken.spacing8,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxBadge(
            'Now in every region',
            variant: AstryxBadgeVariant.info,
            icon: AstryxIcon(AstryxIconName.info),
          ),
          const AstryxHeading(
            'Every deploy, every incident, one timeline',
            level: 1,
            type: AstryxHeadingType.display2,
            justify: AstryxTextJustify.center,
          ),
          const AstryxText(
            'Atlas watches the services you already run and tells you which '
            'change caused the graph to bend.',
            type: AstryxTextType.large,
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          // One `primary` in the view. The second action is secondary, not a
          // second primary: two of them side by side is a question.
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              AstryxButton(
                label: 'Start free',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.lg,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Read the docs',
                size: AstryxButtonSize.lg,
                trailing: const AstryxIcon(
                  AstryxIconName.externalLink,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const AstryxText(
            'No card. Two minutes to the first graph.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
// #end

// #example template_detail_page -> DetailPageTemplate
class DetailPageTemplate extends StatefulWidget {
  const DetailPageTemplate({super.key});

  @override
  State<DetailPageTemplate> createState() => _DetailPageTemplateState();
}

class _DetailPageTemplateState extends State<DetailPageTemplate> {
  static final Incident _incident = incidents.first;

  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // The record's identity and its actions, on one line at width and
        // wrapping at none. The id is `code`, because it is a thing to be
        // copied exactly.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          align: AstryxStackAlign.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxBadge(
                        _incident.severityLabel,
                        variant: severityVariant(_incident.severity),
                        icon: const AstryxIcon(AstryxIconName.warning),
                      ),
                      const AstryxBadge(
                        'Open',
                        variant: AstryxBadgeVariant.palette(AstryxPalette.red),
                      ),
                      AstryxText(
                        _incident.id,
                        type: AstryxTextType.code,
                        color: AstryxTextColor.secondary,
                      ),
                    ],
                  ),
                  AstryxHeading(_incident.title, level: 1),
                  AstryxText(
                    'Opened ${formatMinutes(_incident.minutes)} ago in '
                    '${_incident.service} · paging ${_incident.owner}',
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Resolve',
                  variant: AstryxButtonVariant.primary,
                  leading: const AstryxIcon(AstryxIconName.check),
                  onPressed: () => AstryxToastScope.of(
                    context,
                  ).show(const AstryxToast(message: 'Incident resolved')),
                ),
                AstryxDropdownMenu(
                  label: 'Incident actions',
                  width: 220,
                  entries: <AstryxMenuEntry>[
                    const AstryxMenuSection('Share'),
                    AstryxMenuItem(
                      label: 'Copy link',
                      icon: const AstryxIcon(AstryxIconName.copy),
                      onSelected: () {},
                    ),
                    AstryxMenuItem(
                      label: 'Open the runbook',
                      icon: const AstryxIcon(AstryxIconName.externalLink),
                      onSelected: () {},
                    ),
                    const AstryxMenuDivider(),
                    AstryxMenuItem(
                      label: 'Delete incident',
                      destructive: true,
                      onSelected: () {},
                    ),
                  ],
                  triggerBuilder: (context, controller) => AstryxIconButton(
                    icon: AstryxIconName.moreHorizontal,
                    label: 'Incident actions',
                    onPressed: controller.toggle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const AstryxBanner(
          status: AstryxBannerStatus.warning,
          title: 'Latency is still above the objective',
          description: 'p95 is 2.4s against a 1.0s target.',
          announce: false,
        ),
        AstryxTabList<String>(
          label: 'Incident sections',
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'overview', label: 'Overview'),
            AstryxTab(
              value: 'timeline',
              label: 'Timeline',
              badge: AstryxBadge('4'),
            ),
            AstryxTab(value: 'notes', label: 'Notes'),
          ],
        ),
        switch (_tab) {
          'overview' => const _IncidentFacts(),
          'timeline' => const _IncidentTimeline(),
          _ => const _IncidentNotes(),
        },
      ],
    );
  }
}
// #end

/// The label-and-value pairs of a record.
///
/// Upstream has `MetadataList` for this; it is not ported, so the pairs are a
/// responsive grid of two-line stacks. That is the composition a `MetadataList`
/// would replace, not a workaround for its absence.
class _IncidentFacts extends StatelessWidget {
  const _IncidentFacts();

  @override
  Widget build(BuildContext context) {
    final incident = incidents.first;

    return AstryxCard(
      header: const AstryxHeading('Details'),
      child: AstryxGrid(
        minWidth: 180,
        gap: AstryxSpacingToken.spacing4,
        children: <Widget>[
          _Fact(label: 'Service', value: incident.service),
          _Fact(
            label: 'Severity',
            value: '${incident.severityLabel} — customer facing',
          ),
          _Fact(label: 'On call', value: incident.owner),
          const _Fact(label: 'Detected by', value: 'Synthetic check'),
          const _Fact(label: 'Region', value: 'eu-1, us-1'),
          _Fact(
            label: 'Duration',
            value: '${formatMinutes(incident.minutes)} and counting',
          ),
        ],
      ),
    );
  }
}

/// One label-and-value pair.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText(
          label,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        AstryxText(value),
      ],
    );
  }
}

/// The record's history, as rows separated by rules.
class _IncidentTimeline extends StatelessWidget {
  const _IncidentTimeline();

  @override
  Widget build(BuildContext context) {
    const entries = <List<String>>[
      <String>['42m ago', 'Alert fired', 'p95 crossed 2s for 5 minutes'],
      <String>['38m ago', 'Ada acknowledged', 'Paged through Okta'],
      <String>['21m ago', 'Rollback started', 'payments-api to build 4,198'],
      <String>['4m ago', 'Latency falling', 'p95 at 2.4s, target 1.0s'],
    ];

    return AstryxCard(
      header: const AstryxHeading('Timeline'),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final entry in entries) ...<Widget>[
            if (entry != entries.first) const AstryxDivider(),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing4,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: AstryxText(
                    entry[0],
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    tabularNumbers: true,
                  ),
                ),
                Expanded(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxText(entry[1], weight: AstryxTextWeight.medium),
                      AstryxText(
                        entry[2],
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A note being written about the record.
class _IncidentNotes extends StatelessWidget {
  const _IncidentNotes();

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      header: const AstryxHeading('Notes'),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxButton(
            label: 'Post note',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      child: const AstryxTextArea(
        label: 'What did you find?',
        labelHidden: true,
        placeholder: 'Visible to everyone on the incident.',
      ),
    );
  }
}

// #example template_dashboard -> DashboardTemplate
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
// #end

/// The dashboard's heading and its one line of context.
class _DashboardTitle extends StatelessWidget {
  const _DashboardTitle();

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxHeading('Reliability', level: 1),
        AstryxText(
          'Every service the platform team owns.',
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}

/// One summary tile of the dashboard.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.value,
    required this.detail,
    required this.progress,
    this.variant = AstryxProgressVariant.accent,
  });

  final String label;
  final String value;
  final String detail;

  /// Null draws no bar — a count has no proportion to show.
  final double? progress;
  final AstryxProgressVariant variant;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(
            label,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxHeading(value, level: 3, type: AstryxHeadingType.display3),
          if (progress != null)
            AstryxProgressBar(
              label: label,
              value: progress,
              variant: variant,
              showLabel: false,
            ),
          AstryxText(
            detail,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}

// #example template_table -> TableTemplate
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
// #end

// #example template_theme_showcase -> ThemeShowcaseTemplate
class ThemeShowcaseTemplate extends StatefulWidget {
  const ThemeShowcaseTemplate({super.key});

  @override
  State<ThemeShowcaseTemplate> createState() => _ThemeShowcaseTemplateState();
}

class _ThemeShowcaseTemplateState extends State<ThemeShowcaseTemplate> {
  final AstryxDialogController _dialog = AstryxDialogController();

  bool _switched = true;
  bool _checked = true;
  String _tab = 'live';
  String? _selected = 'eu';
  String _radio = 'balanced';

  @override
  void dispose() {
    _dialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // One screen holding one of everything, so a theme can be judged rather
    // than imagined. Change the theme in the picker above and every colour,
    // radius, weight and duration on this page moves with it.
    //
    // Two columns of cards rather than an `AstryxGrid`: a grid gives every cell
    // in a row the height of the tallest, which needs an intrinsic measurement
    // that a wrapped row of buttons cannot supply. Columns of independent cards
    // are also the better shape here — these sections have nothing to line up.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) => constraints.maxWidth < 640
              ? AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    _actions(),
                    _forms(),
                    _status(),
                    _overlays(context),
                  ],
                )
              : AstryxHStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing4,
                        align: AstryxStackAlign.stretch,
                        children: <Widget>[_actions(), _status()],
                      ),
                    ),
                    Expanded(
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing4,
                        align: AstryxStackAlign.stretch,
                        children: <Widget>[_forms(), _overlays(context)],
                      ),
                    ),
                  ],
                ),
        ),
        _panel(),
      ],
    );
  }

  /// Every button variant, and the two sizes of icon button.
  Widget _actions() {
    return AstryxCard(
      header: const AstryxHeading('Actions', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Primary',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
              AstryxButton(label: 'Secondary', onPressed: () {}),
              AstryxButton(
                label: 'Ghost',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Destructive',
                variant: AstryxButtonVariant.destructive,
                onPressed: () {},
              ),
              AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
            ],
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.search,
                label: 'Search',
                tooltip: 'Search',
                onPressed: () {},
              ),
              AstryxIconButton(
                icon: AstryxIconName.funnel,
                label: 'Filter',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
              AstryxButton(label: 'Loading', loading: true, onPressed: () {}),
            ],
          ),
          AstryxButtonGroup(
            size: AstryxButtonSize.sm,
            children: <Widget>[
              AstryxButton(label: 'Day', onPressed: () {}),
              AstryxButton(
                label: 'Week',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
              AstryxButton(label: 'Month', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  /// One of every input, including a validated one.
  Widget _forms() {
    return AstryxCard(
      header: const AstryxHeading('Forms', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxTextInput(
            label: 'Workspace',
            placeholder: 'Atlas',
            status: AstryxFieldStatus.success('Available'),
          ),
          AstryxSelector<String>(
            label: 'Region',
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'eu', label: 'Frankfurt'),
              AstryxSelectorOption(value: 'us', label: 'Virginia'),
            ],
          ),
          AstryxSwitch(
            label: 'Notifications',
            value: _switched,
            labelPosition: AstryxToggleLabelPosition.start,
            labelSpacing: AstryxToggleLabelSpacing.spread,
            onChanged: (value) => setState(() => _switched = value),
          ),
          AstryxCheckbox(
            label: 'Include archived',
            value: _checked,
            onChanged: (value) => setState(() => _checked = value),
          ),
          AstryxRadioList<String>(
            label: 'Density',
            value: _radio,
            orientation: AstryxRadioListOrientation.horizontal,
            onChanged: (value) => setState(() => _radio = value),
            options: const <AstryxRadioOption<String>>[
              AstryxRadioOption(value: 'compact', label: 'Compact'),
              AstryxRadioOption(value: 'balanced', label: 'Balanced'),
            ],
          ),
        ],
      ),
    );
  }

  /// The badges, the bar, the spinner and the skeleton.
  Widget _status() {
    return const AstryxCard(
      header: AstryxHeading('Status', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxBadge('neutral'),
              AstryxBadge('info', variant: AstryxBadgeVariant.info),
              AstryxBadge('success', variant: AstryxBadgeVariant.success),
              AstryxBadge('warning', variant: AstryxBadgeVariant.warning),
              AstryxBadge('error', variant: AstryxBadgeVariant.error),
            ],
          ),
          AstryxBanner(
            title: 'Rebuilding the search index',
            description: 'Results may be incomplete for a few minutes.',
            announce: false,
          ),
          AstryxProgressBar(
            label: 'Rebuilding index',
            value: 0.62,
            showValueLabel: true,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxSpinner(label: 'Loading'),
              AstryxText('Loading…', color: AstryxTextColor.secondary),
            ],
          ),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.6),
        ],
      ),
    );
  }

  /// Every overlay, each behind its own trigger.
  Widget _overlays(BuildContext context) {
    return AstryxCard(
      header: const AstryxHeading('Overlays', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxPopover(
                label: 'Details',
                width: 220,
                content: const AstryxText(
                  'A floating panel, with focus trapped inside it until it '
                  'closes.',
                ),
                triggerBuilder: (context, controller) => AstryxButton(
                  label: 'Popover',
                  size: AstryxButtonSize.sm,
                  onPressed: controller.toggle,
                ),
              ),
              AstryxDropdownMenu(
                label: 'Menu',
                width: 180,
                entries: <AstryxMenuEntry>[
                  AstryxMenuItem(label: 'Rename', onSelected: () {}),
                  AstryxMenuItem(
                    label: 'Delete',
                    destructive: true,
                    onSelected: () {},
                  ),
                ],
                triggerBuilder: (context, controller) => AstryxButton(
                  label: 'Menu',
                  size: AstryxButtonSize.sm,
                  onPressed: controller.toggle,
                ),
              ),
              AstryxTooltip(
                message: 'The same information, for a pointer',
                child: AstryxButton(
                  label: 'Tooltip',
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ),
              AstryxButton(
                label: 'Toast',
                size: AstryxButtonSize.sm,
                onPressed: () => AstryxToastScope.of(
                  context,
                ).show(const AstryxToast(message: 'Saved to your views')),
              ),
              AstryxButton(
                label: 'Dialog',
                size: AstryxButtonSize.sm,
                onPressed: _dialog.show,
              ),
            ],
          ),
          AstryxDialog(
            controller: _dialog,
            title: 'A modal',
            description: 'Focus is trapped until it closes.',
            footer: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AstryxButton(label: 'Close', onPressed: _dialog.hide),
              ],
            ),
            child: const AstryxText(
              'Every radius, shadow and duration here comes from the theme in '
              'scope.',
            ),
          ),
        ],
      ),
    );
  }

  /// A table and a type specimen, behind a tab strip.
  Widget _panel() {
    return AstryxCard(
      header: AstryxTabList<String>(
        label: 'Showcase sections',
        value: _tab,
        onChanged: (value) => setState(() => _tab = value),
        tabs: const <AstryxTab<String>>[
          AstryxTab(value: 'live', label: 'Incidents'),
          AstryxTab(value: 'typography', label: 'Typography'),
        ],
      ),
      child: _tab == 'live'
          ? AstryxTable<Incident>(
              label: 'Incidents',
              rows: incidents,
              keyOf: (row) => row.id,
              striped: true,
              maxHeight: 220,
              columns: <AstryxTableColumn<Incident>>[
                AstryxTableColumn<Incident>(
                  id: 'title',
                  header: 'Incident',
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
              ],
            )
          : const AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHeading('Heading level 2'),
                AstryxHeading('Heading level 4', level: 4),
                AstryxText(
                  'Body text, which is what most of a tool is made of.',
                ),
                AstryxText(
                  'Supporting text, for the line under the thing.',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
                AstryxText('const AstryxText(…)', type: AstryxTextType.code),
              ],
            ),
    );
  }
}
// #end
