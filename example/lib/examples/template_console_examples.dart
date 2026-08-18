/// A live operations view: what is on fire, when it started, and who has it.
///
/// The screen a team leaves open on a wall. That changes three things about
/// how it is built — nothing important is behind an interaction, every time is
/// relative and keeps ticking, and the severity of a row is never carried by
/// its colour alone.
///
/// Not exported. A composition worth copying, built from nothing but what
/// `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_incident_console -> IncidentConsoleTemplate
/// One live incident.
typedef Incident = ({
  String id,
  int severity,
  String title,
  String service,
  String owner,
  bool acknowledged,
  Duration age,
});

/// One entry in an incident's timeline.
typedef Event = ({String who, String what, Duration ago});

class IncidentConsoleTemplate extends StatefulWidget {
  const IncidentConsoleTemplate({super.key});

  @override
  State<IncidentConsoleTemplate> createState() =>
      _IncidentConsoleTemplateState();
}

class _IncidentConsoleTemplateState extends State<IncidentConsoleTemplate> {
  static const List<Incident> _all = <Incident>[
    (
      id: 'INC-4102',
      severity: 1,
      title: 'Scheduler health check timing out',
      service: 'scheduler',
      owner: 'Ada Lovelace',
      acknowledged: true,
      age: Duration(minutes: 41),
    ),
    (
      id: 'INC-4101',
      severity: 2,
      title: 'Elevated 5xx from the edge in eu-west',
      service: 'edge',
      owner: 'Grace Hopper',
      acknowledged: true,
      age: Duration(hours: 2, minutes: 12),
    ),
    (
      id: 'INC-4100',
      severity: 3,
      title: 'Artifact upload retries above baseline',
      service: 'artifacts',
      owner: 'Unassigned',
      acknowledged: false,
      age: Duration(minutes: 6),
    ),
    (
      id: 'INC-4098',
      severity: 3,
      title: 'Metrics ingestion lag on shard 4',
      service: 'metrics',
      owner: 'Alan Turing',
      acknowledged: true,
      age: Duration(hours: 5, minutes: 3),
    ),
  ];

  static const Map<String, List<Event>> _timeline = <String, List<Event>>{
    'INC-4102': <Event>[
      (
        who: 'Ada Lovelace',
        what: 'Raised the health-check timeout to 60 seconds',
        ago: Duration(minutes: 4),
      ),
      (
        who: 'Ada Lovelace',
        what: 'Acknowledged and took ownership',
        ago: Duration(minutes: 33),
      ),
      (
        who: 'Atlas',
        what: 'Paged the Europe rotation',
        ago: Duration(minutes: 40),
      ),
      (
        who: 'Atlas',
        what: 'Opened after three failed deploys in a row',
        ago: Duration(minutes: 41),
      ),
    ],
  };

  /// A single instant that every relative stamp on this screen is measured
  /// from, so two rows the same age never disagree by a second.
  late final DateTime _opened = DateTime.now();

  int? _severity;
  String _selected = 'INC-4102';

  List<Incident> get _shown => _severity == null
      ? _all
      : _all.where((incident) => incident.severity == _severity).toList();

  Incident get _open => _all.firstWhere((incident) => incident.id == _selected);

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelWidth: 280,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxHeading('Incidents', level: 1),
                    // Pulsing says *live*, and the label says what live
                    // means. The pulse honours reduced motion; the words do
                    // not need to.
                    AstryxStatusDot(
                      AstryxStatusDotVariant.error,
                      label: 'Live — updating as events arrive',
                      pulsing: true,
                    ),
                  ],
                ),
                AstryxText(
                  '${shown.length} open · '
                  '${_all.where((i) => !i.acknowledged).length} '
                  'unacknowledged',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxSegmentedControl<int?>(
                  label: 'Severity',
                  value: _severity,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => setState(() => _severity = value),
                  segments: const <AstryxSegment<int?>>[
                    AstryxSegment<int?>(value: null, label: 'All'),
                    AstryxSegment<int?>(value: 1, label: 'Sev-1'),
                    AstryxSegment<int?>(value: 2, label: 'Sev-2'),
                    AstryxSegment<int?>(value: 3, label: 'Sev-3'),
                  ],
                ),
                AstryxButton(
                  label: 'Declare an incident',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        panel: _OnCallPanel(incident: _open, opened: _opened),
        child: shown.isEmpty
            ? const AstryxEmptyState(
                title: 'Nothing at that severity',
                description: 'Four incidents are open at other severities.',
                icon: AstryxIcon(
                  AstryxIconName.success,
                  size: AstryxIconSize.lg,
                ),
              )
            : AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final incident in shown)
                    _IncidentCard(
                      incident: incident,
                      opened: _opened,
                      selected: incident.id == _selected,
                      onPressed: () => setState(() => _selected = incident.id),
                    ),
                  AstryxSection(
                    title: 'Timeline · $_selected',
                    description:
                        'Newest first. Every entry names who did it, because '
                        '"acknowledged" with no name is the thing nobody can '
                        'follow up.',
                    child: AstryxList(
                      label: 'Timeline for $_selected',
                      showDividers: true,
                      children: <Widget>[
                        for (final event
                            in _timeline[_selected] ?? const <Event>[])
                          AstryxItem(
                            label: event.what,
                            description: event.who,
                            maxLines: 2,
                            trailing: AstryxTimestamp(
                              _opened.subtract(event.ago),
                              type: AstryxTextType.supporting,
                            ),
                          ),
                        if ((_timeline[_selected] ?? const <Event>[]).isEmpty)
                          const AstryxItem(
                            label: 'Nothing has happened yet',
                            description:
                                'This incident was opened automatically and '
                                'has not been touched.',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// One incident, as a card that is also the way into it.
class _IncidentCard extends StatelessWidget {
  const _IncidentCard({
    required this.incident,
    required this.opened,
    required this.selected,
    required this.onPressed,
  });

  final Incident incident;
  final DateTime opened;
  final bool selected;
  final VoidCallback onPressed;

  /// The badge for a severity.
  ///
  /// The number is in the text, not only in the colour — the palettes are
  /// *categorical*, and a reader who cannot tell red from orange still has to
  /// know which of these to look at first.
  AstryxBadgeVariant get _severityVariant => switch (incident.severity) {
    1 => AstryxBadgeVariant.error,
    2 => AstryxBadgeVariant.warning,
    _ => AstryxBadgeVariant.neutral,
  };

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      variant: selected
          ? AstryxCardVariant.standard
          : AstryxCardVariant.transparent,
      elevation: selected ? AstryxElevation.low : AstryxElevation.none,
      semanticsLabel:
          '${incident.id}, severity ${incident.severity}, '
          '${incident.title}, owned by ${incident.owner}',
      onPressed: onPressed,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                // Wrapping, not truncating. Every badge in this row is a
                // fact about how urgent the card is; a phone that clips
                // "Unacknowledged" off the end has hidden the one word that
                // decides whether anybody picks the incident up.
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxBadge(
                      'Sev-${incident.severity}',
                      variant: _severityVariant,
                      icon: AstryxIcon(
                        incident.severity == 1
                            ? AstryxIconName.error
                            : AstryxIconName.warning,
                      ),
                    ),
                    AstryxText(incident.id, type: AstryxTextType.code),
                    if (!incident.acknowledged)
                      const AstryxBadge(
                        'Unacknowledged',
                        variant: AstryxBadgeVariant.warning,
                        icon: AstryxIcon(AstryxIconName.clock),
                      ),
                  ],
                ),
                AstryxText(
                  incident.title,
                  type: AstryxTextType.label,
                  maxLines: 1,
                ),
                AstryxText(
                  '${incident.service} · ${incident.owner}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // A relative stamp that keeps ticking. On a wall display, "41
          // minutes" that froze at load is worse than no clock at all.
          AstryxTimestamp(
            opened.subtract(incident.age),
            type: AstryxTextType.supporting,
          ),
        ],
      ),
    );
  }
}

/// Who has the incident, and who to reach if they do not answer.
class _OnCallPanel extends StatelessWidget {
  const _OnCallPanel({required this.incident, required this.opened});

  final Incident incident;
  final DateTime opened;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSection(
          title: 'On call',
          level: 2,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxItem(
                label: incident.owner,
                description: 'Europe, until 18:00',
                leading: AstryxAvatar(
                  name: incident.owner,
                  status: AstryxStatusDotVariant.success,
                  statusLabel: 'Available',
                ),
              ),
              const AstryxAvatarGroup(
                label: 'Also on this incident',
                size: AstryxAvatarSize.sm,
                avatars: <AstryxAvatar>[
                  AstryxAvatar(name: 'Grace Hopper'),
                  AstryxAvatar(name: 'Alan Turing'),
                  AstryxAvatar(name: 'Katherine Johnson'),
                  AstryxAvatar(name: 'Edsger Dijkstra'),
                ],
              ),
              AstryxButton(
                label: 'Page the escalation',
                variant: AstryxButtonVariant.destructive,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        AstryxSection(
          title: 'This incident',
          level: 2,
          child: AstryxMetadataList(
            items: <AstryxMetadataItem>[
              AstryxMetadataItem.text(label: 'Id', value: incident.id),
              AstryxMetadataItem.text(
                label: 'Service',
                value: incident.service,
              ),
              AstryxMetadataItem(
                label: 'Opened',
                semanticsValue: '${incident.age.inMinutes} minutes ago',
                value: AstryxTimestamp(opened.subtract(incident.age)),
              ),
              AstryxMetadataItem.text(
                label: 'Severity',
                value: 'Sev-${incident.severity}',
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        const AstryxSection(
          title: 'Error budget',
          level: 2,
          child: AstryxProgressBar(
            label: 'Error budget consumed this window',
            value: 0.68,
            variant: AstryxProgressVariant.warning,
            showValueLabel: true,
          ),
        ),
      ],
    );
  }
}
// #end
