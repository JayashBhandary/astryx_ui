---
title: Messaging shell
description: A conversation list beside the open conversation.
component: true
group: Templates
source: example/lib/examples/template_split_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Pick another conversation, then send something: the draft goes to the thread it was written in.


## A list that selects, not a list that filters

It looks like the [library](library.md) and it is the opposite: there, the panel narrows what the body shows and several things may be selected at once. Here exactly one conversation is open, and the panel is how it is chosen. That is why `_thread` is a `String` rather than a `Set` — the type is the design.

```text
AstryxLayout(scrollable: false, padding: spacing0, panelSide: start)
├── panel ← the conversations: avatar, preview, unread count
└── child ← AstryxChatLayout
    ├── header   ← who this is, their status, the conversation menu
    ├── messages ← AstryxChatMessage per line
    └── composer ← AstryxChatComposer
```

`scrollable: false` and `padding: spacing0`, because neither column is the layout’s to scroll or to inset: the transcript owns its scrolling and opens at the newest turn, and the thread list owns its own.

## The chat roles are about sides, not about machines

> **Careful**
>
> `AstryxChatRole.user` is whoever is composing, and `AstryxChatRole.assistant` is the other side of the transcript. In a conversation between two people that mapping reads oddly in the source and correctly on the screen — `user` is the bubble at the trailing edge, which is where the reader’s own words belong.

The other side gets a `leading:` [AstryxAvatar](avatar.md) and the reader’s own turns do not. Repeating your own face beside every line you wrote is a column of noise down the edge nobody is reading.

## Never markdown

Every message is [AstryxText](text.md). The [AI chat](ai_chat.md) template renders the *assistant’s* turn as [AstryxMarkdown](markdown.md) because that is the format it arrives in — but rendering what a person typed changes what they said, and in a person-to-person thread there is no markdown to render in the first place.

> **Accessibility**
>
> The unread badge carries a `semanticsLabel` — "2 unread messages" — because "2" beside a name is a number about nothing. The presence dot on the avatar takes a `statusLabel` for the same reason: a green ring is not the word "online".

## Related

- [AI chat](ai_chat.md) — the same transcript when the other side is a model.
- [Library](library.md) — the panel that filters rather than selects.
- [AstryxChatLayout](chat_layout.md) — the transcript, the scroll behaviour and the composer slot.
- [AstryxAvatar](avatar.md) — initials, status and the label it needs.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

