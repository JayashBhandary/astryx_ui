/// A board of columns, and cards that move between them.
///
/// **Nothing in `astryx_ui` moves under a pointer.** Dragging is a gesture, not
/// a surface: it belongs to `flutter/widgets`, where `Draggable` and
/// `DragTarget` already live, and a design system that wrapped them would be
/// adding a name rather than a capability. So this template uses the
/// framework's own, with `astryx_ui` cards riding on top.
///
/// The important half is the other one. A drag is a pointer affordance and
/// nothing else — no keyboard reaches it, no screen reader announces it, and
/// touch users get a long-press at best. So **every card also carries a move
/// menu**, and that menu is the primary path: the drag is the enhancement.
///
/// Not exported. A composition worth copying.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_kanban_board -> KanbanBoardTemplate
/// One card on the board.
typedef Ticket = ({
  String id,
  String title,
  String assignee,
  String tag,
  int points,
  bool blocked,
});

/// One column, and the work-in-progress limit it is judged against.
typedef Lane = ({String id, String title, int? limit});

class KanbanBoardTemplate extends StatefulWidget {
  const KanbanBoardTemplate({super.key});

  @override
  State<KanbanBoardTemplate> createState() => _KanbanBoardTemplateState();
}

class _KanbanBoardTemplateState extends State<KanbanBoardTemplate> {
  static const List<Lane> _lanes = <Lane>[
    (id: 'triage', title: 'Triage', limit: null),
    (id: 'doing', title: 'In progress', limit: 3),
    (id: 'review', title: 'In review', limit: 2),
    (id: 'done', title: 'Done', limit: null),
  ];

  static const List<Ticket> _tickets = <Ticket>[
    (
      id: 'ATL-412',
      title: 'Health check gives up before the port binds',
      assignee: 'Ada Lovelace',
      tag: 'scheduler',
      points: 5,
      blocked: false,
    ),
    (
      id: 'ATL-408',
      title: 'Artifact upload retries without backing off',
      assignee: 'Grace Hopper',
      tag: 'artifacts',
      points: 3,
      blocked: true,
    ),
    (
      id: 'ATL-401',
      title: 'Rollback leaves the old revision in the routing table',
      assignee: 'Alan Turing',
      tag: 'edge',
      points: 8,
      blocked: false,
    ),
    (
      id: 'ATL-397',
      title: 'Deploy log truncates at 400 lines',
      assignee: 'Ada Lovelace',
      tag: 'logs',
      points: 2,
      blocked: false,
    ),
    (
      id: 'ATL-392',
      title: 'Metrics shard 4 lags behind by ninety seconds',
      assignee: 'Katherine Johnson',
      tag: 'metrics',
      points: 5,
      blocked: false,
    ),
    (
      id: 'ATL-388',
      title: 'On-call rota export drops the last row',
      assignee: 'Grace Hopper',
      tag: 'oncall',
      points: 1,
      blocked: false,
    ),
    (
      id: 'ATL-380',
      title: 'Pipeline variables are not masked in the log',
      assignee: 'Alan Turing',
      tag: 'security',
      points: 3,
      blocked: false,
    ),
  ];

  /// Where each ticket is. The board is this map, and everything on screen is
  /// derived from it — which is what makes a drag and a menu the same edit.
  final Map<String, String> _lane = <String, String>{
    'ATL-412': 'doing',
    'ATL-408': 'doing',
    'ATL-401': 'review',
    'ATL-397': 'triage',
    'ATL-392': 'triage',
    'ATL-388': 'done',
    'ATL-380': 'triage',
  };

  /// The card a pointer is currently carrying, so its origin can dim.
  String? _dragging;

  List<Ticket> _inLane(String lane) =>
      _tickets.where((ticket) => _lane[ticket.id] == lane).toList();

  /// The one edit this screen makes. A drag calls it; so does a menu row.
  void _move(String ticket, String lane) {
    if (_lane[ticket] == lane) return;
    final title = _lanes.firstWhere((entry) => entry.id == lane).title;
    setState(() => _lane[ticket] = lane);
    AstryxToastScope.of(context).show(
      AstryxToast(message: '$ticket moved to $title'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 620,
      child: AstryxLayout(
        scrollable: false,
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
                const AstryxHeading('Sprint 42', level: 1),
                AstryxText(
                  '${_tickets.length} tickets · '
                  '${_tickets.fold<int>(0, (sum, t) => sum + t.points)} points',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxButton(
              label: 'New ticket',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (final lane in _lanes)
                SizedBox(
                  width: 268,
                  child: _Lane(
                    lane: lane,
                    tickets: _inLane(lane.id),
                    lanes: _lanes,
                    dragging: _dragging,
                    onMove: _move,
                    onDragStart: (id) => setState(() => _dragging = id),
                    onDragEnd: () => setState(() => _dragging = null),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One column: a header, a drop target, and the cards in it.
class _Lane extends StatelessWidget {
  const _Lane({
    required this.lane,
    required this.tickets,
    required this.lanes,
    required this.dragging,
    required this.onMove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final Lane lane;
  final List<Ticket> tickets;
  final List<Lane> lanes;
  final String? dragging;
  final void Function(String ticket, String lane) onMove;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;

  bool get _overLimit => lane.limit != null && tickets.length > lane.limit!;

  @override
  Widget build(BuildContext context) {
    // `DragTarget` is the framework's, not the package's. What `astryx_ui`
    // contributes is everything the column *looks* like — and the card
    // variant is what says "let go here", because a border that only appears
    // under a pointer is the one signal a drag is allowed to use.
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => onMove(details.data, lane.id),
      builder: (context, candidate, rejected) {
        final active = candidate.isNotEmpty;

        return AstryxCard(
          variant: active
              ? AstryxCardVariant.standard
              : AstryxCardVariant.muted,
          elevation: active ? AstryxElevation.low : AstryxElevation.none,
          padding: AstryxSpacingToken.spacing3,
          // The lane is stretched to the height of the board, and a busy
          // column holds more cards than that. `scrollable` is what keeps the
          // header pinned while the cards under it move.
          scrollable: true,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: AstryxText(
                  lane.title,
                  type: AstryxTextType.label,
                  maxLines: 1,
                ),
              ),
              // The limit is a number *and* a word when it is breached. A
              // column that turned red and said nothing is a rule nobody can
              // look up.
              if (lane.limit == null)
                AstryxBadge('${tickets.length}')
              else
                AstryxBadge(
                  '${tickets.length}/${lane.limit}',
                  variant: _overLimit
                      ? AstryxBadgeVariant.warning
                      : AstryxBadgeVariant.neutral,
                  icon: _overLimit
                      ? const AstryxIcon(AstryxIconName.warning)
                      : null,
                  semanticsLabel: _overLimit
                      ? '${tickets.length} of ${lane.limit}, over the limit'
                      : '${tickets.length} of ${lane.limit}',
                ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              if (tickets.isEmpty)
                AstryxEmptyState(
                  title: active ? 'Drop it here' : 'Nothing here',
                  size: AstryxEmptyStateSize.compact,
                  minHeight: 120,
                )
              else
                for (final ticket in tickets)
                  _TicketCard(
                    ticket: ticket,
                    lanes: lanes,
                    lane: lane,
                    dimmed: dragging == ticket.id,
                    onMove: onMove,
                    onDragStart: onDragStart,
                    onDragEnd: onDragEnd,
                  ),
            ],
          ),
        );
      },
    );
  }
}

/// One ticket: draggable for a pointer, and movable by menu for everyone else.
class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.lanes,
    required this.lane,
    required this.dimmed,
    required this.onMove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final Ticket ticket;
  final List<Lane> lanes;
  final Lane lane;
  final bool dimmed;
  final void Function(String ticket, String lane) onMove;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final card = _body(context);

    // `Draggable` for a mouse, `LongPressDraggable` for a thumb. Neither is
    // reachable from a keyboard, which is exactly why the menu inside `card`
    // is not an extra: it is the path that always works.
    return Draggable<String>(
      data: ticket.id,
      onDragStarted: () => onDragStart(ticket.id),
      onDragEnd: (_) => onDragEnd(),
      onDraggableCanceled: (_, _) => onDragEnd(),
      feedback: SizedBox(width: 244, child: _body(context, lifted: true)),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }

  Widget _body(BuildContext context, {bool lifted = false}) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      elevation: lifted ? AstryxElevation.high : AstryxElevation.none,
      header: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxText(ticket.id, type: AstryxTextType.code),
          // The move menu. Named for the ticket, not "More" — a board of seven
          // identical "More" buttons is seven identical announcements.
          if (!lifted)
            AstryxMoreMenu(
              label: 'Move ${ticket.id}',
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('Move to'),
                for (final target in lanes)
                  AstryxMenuItem(
                    label: target.title,
                    enabled: target.id != lane.id,
                    onSelected: () => onMove(ticket.id, target.id),
                  ),
              ],
            ),
        ],
      ),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxAvatar(name: ticket.assignee, size: AstryxAvatarSize.xs),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxBadge(ticket.tag),
              AstryxBadge(
                '${ticket.points}',
                semanticsLabel: '${ticket.points} points',
              ),
            ],
          ),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(ticket.title, maxLines: 3),
          if (ticket.blocked)
            const AstryxBadge(
              'Blocked',
              variant: AstryxBadgeVariant.error,
              icon: AstryxIcon(AstryxIconName.error),
            ),
        ],
      ),
    );
  }
}
// #end
