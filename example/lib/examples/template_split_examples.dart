/// Two screens with a list down one side and the thing you picked on the other.
///
/// The split is the same; what it is *for* is not. A library's list is a
/// filter — narrowing what the wall shows. A messaging shell's list is a
/// selection — choosing which one thing is open. That difference is why one of
/// them keeps a multiple selection and the other cannot have one.
///
/// Neither is exported. Both are compositions worth copying, built from nothing
/// but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_library -> LibraryTemplate
/// One asset in the library.
typedef Asset = ({
  String id,
  String name,
  String collection,
  String kind,
  String size,
  String added,
});

class LibraryTemplate extends StatefulWidget {
  const LibraryTemplate({super.key});

  @override
  State<LibraryTemplate> createState() => _LibraryTemplateState();
}

class _LibraryTemplateState extends State<LibraryTemplate> {
  static const List<Asset> _assets = <Asset>[
    (
      id: 'a1',
      name: 'Runbook cover',
      collection: 'Brand',
      kind: 'Image',
      size: '2.4 MB',
      added: '11 minutes ago',
    ),
    (
      id: 'a2',
      name: 'Wordmark, dark',
      collection: 'Brand',
      kind: 'Vector',
      size: '18 kB',
      added: 'Yesterday',
    ),
    (
      id: 'a3',
      name: 'Incident 4102 timeline',
      collection: 'Incidents',
      kind: 'Image',
      size: '5.1 MB',
      added: '2 days ago',
    ),
    (
      id: 'a4',
      name: 'Scheduler diagram',
      collection: 'Architecture',
      kind: 'Vector',
      size: '96 kB',
      added: '2 days ago',
    ),
    (
      id: 'a5',
      name: 'Fleet map',
      collection: 'Architecture',
      kind: 'Image',
      size: '3.8 MB',
      added: 'Last week',
    ),
    (
      id: 'a6',
      name: 'On-call rota, Q3',
      collection: 'Operations',
      kind: 'Document',
      size: '212 kB',
      added: 'Last week',
    ),
    (
      id: 'a7',
      name: 'Post-mortem template',
      collection: 'Operations',
      kind: 'Document',
      size: '44 kB',
      added: 'Last month',
    ),
  ];

  final TextEditingController _query = TextEditingController();

  Set<String> _kinds = <String>{};
  String _collection = 'All';
  String _view = 'grid';
  final Set<Object> _selected = <Object>{};

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Narrowed in the caller, so an empty result can say which of the two
  /// nothings it is: nothing matched, or nothing here yet.
  List<Asset> get _shown {
    final text = _query.text.trim().toLowerCase();
    return _assets
        .where(
          (asset) =>
              (_collection == 'All' || asset.collection == _collection) &&
              (_kinds.isEmpty || _kinds.contains(asset.kind)) &&
              (text.isEmpty || asset.name.toLowerCase().contains(text)),
        )
        .toList();
  }

  /// How many assets a collection holds, for the count beside its row.
  int _countIn(String collection) => collection == 'All'
      ? _assets.length
      : _assets.where((asset) => asset.collection == collection).length;

  void _toggle(String id, {required bool selected}) => setState(() {
    if (selected) {
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
  });

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 210,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('Library', level: 1),
                    AstryxText(
                      '${shown.length} of ${_assets.length} assets',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: AstryxTextInput(
                        controller: _query,
                        label: 'Search the library',
                        labelHidden: true,
                        placeholder: 'Search',
                        showClear: true,
                        size: AstryxInputSize.sm,
                        leading: const AstryxIcon(
                          AstryxIconName.search,
                          size: AstryxIconSize.sm,
                        ),
                      ),
                    ),
                    // Two ways of looking at one set, so a segmented control:
                    // it announces itself as a radio group, and the arrows
                    // both move and choose.
                    AstryxSegmentedControl<String>(
                      label: 'View',
                      value: _view,
                      size: AstryxButtonSize.sm,
                      onChanged: (value) => setState(() => _view = value),
                      segments: const <AstryxSegment<String>>[
                        AstryxSegment(
                          value: 'grid',
                          label: 'Grid',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.viewColumns),
                        ),
                        AstryxSegment(
                          value: 'list',
                          label: 'List',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.menu),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // The selection bar appears only once something is ticked, and it
            // says how many. "Delete" with no count is a question nobody can
            // answer.
            if (_selected.isNotEmpty)
              AstryxBanner(
                title: '${_selected.length} selected',
                announce: false,
                actions: <Widget>[
                  AstryxButton(
                    label: 'Download',
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  AstryxButton(
                    label: 'Remove',
                    variant: AstryxButtonVariant.destructive,
                    size: AstryxButtonSize.sm,
                    onPressed: () => setState(_selected.clear),
                  ),
                ],
              ),
          ],
        ),
        panel: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxSection(
              title: 'Collections',
              level: 2,
              child: AstryxList(
                label: 'Collections',
                density: AstryxItemDensity.compact,
                children: <Widget>[
                  for (final collection in const <String>[
                    'All',
                    'Brand',
                    'Incidents',
                    'Architecture',
                    'Operations',
                  ])
                    AstryxItem(
                      label: collection,
                      selected: _collection == collection,
                      trailing: AstryxText(
                        '${_countIn(collection)}',
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                      onPressed: () => setState(() => _collection = collection),
                    ),
                ],
              ),
            ),
            const AstryxDivider(),
            AstryxCheckboxList<String>(
              label: 'Kind',
              values: _kinds,
              onChanged: (values) => setState(() => _kinds = values),
              options: const <AstryxCheckboxOption<String>>[
                AstryxCheckboxOption(value: 'Image', label: 'Image'),
                AstryxCheckboxOption(value: 'Vector', label: 'Vector'),
                AstryxCheckboxOption(value: 'Document', label: 'Document'),
              ],
            ),
          ],
        ),
        child: shown.isEmpty
            ? AstryxEmptyState(
                title: 'Nothing matches',
                description:
                    'Seven assets are still here; the filters are what is '
                    'hiding them.',
                icon: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.lg,
                ),
                actions: <Widget>[
                  AstryxButton(
                    label: 'Clear filters',
                    variant: AstryxButtonVariant.primary,
                    onPressed: () => setState(() {
                      _kinds = <String>{};
                      _collection = 'All';
                      _query.clear();
                    }),
                  ),
                ],
              )
            : _view == 'grid'
            ? _grid(shown)
            : _list(shown),
      ),
    );
  }

  /// The wall: a selectable card per asset.
  ///
  /// `AstryxSelectableCard` rather than a pressable card with a checkbox on
  /// it: this is a *control* that reports a selection, and it announces itself
  /// as a checkbox rather than as a button that happens to tick something.
  Widget _grid(List<Asset> shown) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (final asset in shown)
          SizedBox(
            width: 200,
            child: AstryxSelectableCard(
              label: asset.name,
              semanticsHint: '${asset.kind}, ${asset.size}',
              selected: _selected.contains(asset.id),
              padding: AstryxSpacingToken.spacing3,
              onSelectedChanged: (value) => _toggle(asset.id, selected: value),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxAspectRatio(
                    ratio: 4 / 3,
                    semanticsLabel: asset.name,
                    child: const Center(
                      child: AstryxIcon(AstryxIconName.viewColumns),
                    ),
                  ),
                  AstryxText(
                    asset.name,
                    type: AstryxTextType.label,
                    maxLines: 1,
                  ),
                  AstryxText(
                    '${asset.kind} · ${asset.size}',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// The same set, and the same selection, as rows.
  Widget _list(List<Asset> shown) {
    return AstryxTable<Asset>(
      label: 'Assets',
      keyOf: (row) => row.id,
      rowLabelOf: (row) => row.name,
      density: AstryxTableDensity.compact,
      selectionMode: AstryxTableSelectionMode.multiple,
      selected: _selected,
      onSelectionChanged: (value) => setState(() {
        _selected
          ..clear()
          ..addAll(value);
      }),
      columns: <AstryxTableColumn<Asset>>[
        AstryxTableColumn<Asset>(
          id: 'name',
          header: 'Name',
          compare: (a, b) => a.name.compareTo(b.name),
          cellBuilder: (context, row) => AstryxText(row.name, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'collection',
          header: 'Collection',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxBadge(row.collection),
        ),
        AstryxTableColumn<Asset>(
          id: 'kind',
          header: 'Kind',
          width: const AstryxTableColumnWidth.fixed(100),
          cellBuilder: (context, row) => AstryxText(row.kind, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'added',
          header: 'Added',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxText(
            row.added,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            maxLines: 1,
          ),
        ),
      ],
      rows: shown,
    );
  }
}
// #end

// #example template_messaging_shell -> MessagingShellTemplate
/// One conversation in the list.
typedef Thread = ({
  String id,
  String name,
  String preview,
  int unread,
  bool online,
});

/// One message in a thread.
typedef Line = ({bool mine, String text, String at});

class MessagingShellTemplate extends StatefulWidget {
  const MessagingShellTemplate({super.key});

  @override
  State<MessagingShellTemplate> createState() => _MessagingShellTemplateState();
}

class _MessagingShellTemplateState extends State<MessagingShellTemplate> {
  static const List<Thread> _threads = <Thread>[
    (
      id: 'sre',
      name: 'Ada Lovelace',
      preview: 'The bind is still taking 40 seconds.',
      unread: 2,
      online: true,
    ),
    (
      id: 'grace',
      name: 'Grace Hopper',
      preview: 'Merged — thanks for the review.',
      unread: 0,
      online: true,
    ),
    (
      id: 'oncall',
      name: 'On-call, Europe',
      preview: 'Rota swapped for Thursday.',
      unread: 5,
      online: false,
    ),
    (
      id: 'alan',
      name: 'Alan Turing',
      preview: 'Can you look at 4102 when you get a minute?',
      unread: 0,
      online: false,
    ),
  ];

  static const Map<String, List<Line>> _messages = <String, List<Line>>{
    'sre': <Line>[
      (
        mine: false,
        text: 'The 14:02 deploy rolled back again.',
        at: '13:58',
      ),
      (
        mine: true,
        text: 'Health check or the migration?',
        at: '14:01',
      ),
      (
        mine: false,
        text:
            'Health check. The bind is still taking 40 seconds and the check '
            'gives up at 30.',
        at: '14:03',
      ),
    ],
    'grace': <Line>[
      (mine: false, text: 'Merged — thanks for the review.', at: '09:12'),
    ],
    'oncall': <Line>[
      (mine: false, text: 'Rota swapped for Thursday.', at: 'Yesterday'),
    ],
    'alan': <Line>[
      (
        mine: false,
        text: 'Can you look at 4102 when you get a minute?',
        at: 'Monday',
      ),
    ],
  };

  final TextEditingController _draft = TextEditingController();
  final List<Line> _extra = <Line>[];

  String _thread = 'sre';

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Thread get _open => _threads.firstWhere((t) => t.id == _thread);

  List<Line> get _lines => <Line>[
    ..._messages[_thread] ?? const <Line>[],
    if (_thread == 'sre') ..._extra,
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _extra.add((mine: true, text: text.trim(), at: 'now'));
      _thread = 'sre';
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final open = _open;

    // `scrollable: false`, because the transcript scrolls itself and the list
    // in the panel scrolls itself. The layout is a frame here, not a scroller.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollable: false,
        padding: AstryxSpacingToken.spacing0,
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 260,
        panel: _ThreadList(
          threads: _threads,
          selected: _thread,
          onSelected: (id) => setState(() => _thread = id),
        ),
        child: AstryxChatLayout(
          maxWidth: 640,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxAvatar(
                      name: open.name,
                      size: AstryxAvatarSize.sm,
                      status: open.online
                          ? AstryxStatusDotVariant.success
                          : AstryxStatusDotVariant.neutral,
                      statusLabel: open.online ? 'Online' : 'Away',
                    ),
                    Flexible(child: AstryxHeading(open.name, level: 1)),
                  ],
                ),
              ),
              AstryxMoreMenu(
                label: 'Conversation actions',
                entries: <AstryxMenuEntry>[
                  AstryxMenuItem(
                    label: 'Search this thread',
                    onSelected: () {},
                  ),
                  AstryxMenuItem(label: 'Mute', onSelected: () {}),
                  const AstryxMenuDivider(),
                  AstryxMenuItem(
                    label: 'Leave conversation',
                    destructive: true,
                    onSelected: () {},
                  ),
                ],
              ),
            ],
          ),
          messages: <Widget>[
            for (final line in _lines)
              // `AstryxChatRole` is about which side of the transcript a turn
              // sits on, not about who is a machine: `user` is whoever is
              // composing, and everything else is the other side.
              AstryxChatMessage(
                role: line.mine
                    ? AstryxChatRole.user
                    : AstryxChatRole.assistant,
                author: line.mine ? 'You' : open.name,
                leading: line.mine
                    ? null
                    : AstryxAvatar(name: open.name, size: AstryxAvatarSize.sm),
                timestamp: AstryxText(
                  line.at,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
                // Plain text, always. Rendering what somebody typed changes
                // what they said — and in a person-to-person thread there is
                // no markdown to render in the first place.
                child: AstryxText(line.text),
              ),
          ],
          composer: AstryxChatComposer(
            controller: _draft,
            placeholder: 'Message ${open.name}',
            label: 'Message ${open.name}',
            onSubmit: _send,
            leading: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'Attach a file',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The conversations, newest first, with what is unread on each.
class _ThreadList extends StatelessWidget {
  const _ThreadList({
    required this.threads,
    required this.selected,
    required this.onSelected,
  });

  final List<Thread> threads;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    // No `Expanded` and no scroller of its own: `AstryxLayout` wraps a panel
    // in a `SingleChildScrollView`, so the panel is handed an unbounded
    // height and anything that wants to fill it cannot be laid out.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const AstryxHeading('Messages'),
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'New conversation',
                tooltip: 'New conversation',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        AstryxList(
          label: 'Conversations',
          children: <Widget>[
            for (final thread in threads)
              AstryxItem(
                label: thread.name,
                description: thread.preview,
                selected: thread.id == selected,
                leading: AstryxAvatar(
                  name: thread.name,
                  size: AstryxAvatarSize.sm,
                  status: thread.online ? AstryxStatusDotVariant.success : null,
                  statusLabel: thread.online ? 'Online' : null,
                ),
                // The count is the badge *and* the announcement: "2" on
                // its own beside a name is a number about nothing.
                trailing: thread.unread == 0
                    ? null
                    : AstryxBadge(
                        '${thread.unread}',
                        variant: AstryxBadgeVariant.info,
                        semanticsLabel: '${thread.unread} unread messages',
                      ),
                onPressed: () => onSelected(thread.id),
              ),
          ],
        ),
      ],
    );
  }
}
// #end
