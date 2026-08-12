---
title: AstryxChatLayout
description: 'The frame of a conversation: a scrolling transcript and a pinned composer.'
component: true
group: Chat & AI
source: lib/src/components/chat/chat_layout.dart
upstream: ChatLayout / ChatLayoutScrollButton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatLayoutDemoExample extends StatefulWidget {
  const ChatLayoutDemoExample({super.key});

  @override
  State<ChatLayoutDemoExample> createState() => _ChatLayoutDemoExampleState();
}

class _ChatLayoutDemoExampleState extends State<ChatLayoutDemoExample> {
  final TextEditingController _draft = TextEditingController();
  final List<({AstryxChatRole role, String text})> _turns =
      <({AstryxChatRole role, String text})>[
        (role: AstryxChatRole.user, text: 'Why did the 14:02 deploy fail?'),
        (
          role: AstryxChatRole.assistant,
          text:
              'The health check timed out. The scheduler took 41 seconds to '
              'bind its port, and the check gives up at 30.',
        ),
        (role: AstryxChatRole.user, text: 'Can we raise the timeout?'),
        (
          role: AstryxChatRole.assistant,
          text:
              'You can, but the bind is the real problem — it used to take '
              'four seconds. I would look at the migration that ships with '
              'this release first.',
        ),
      ];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    setState(() {
      _turns
        ..add((role: AstryxChatRole.user, text: text))
        ..add((
          role: AstryxChatRole.assistant,
          text: 'Noted. (This example does not actually answer.)',
        ));
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The layout owns the scrolling: it opens on the newest turn, stays put as
    // turns arrive, and offers a jump-to-latest button once you scroll back.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      // Bounded inside the card: a card lays its body out in a column, and a
      // column hands its child unbounded height — which the layout needs to
      // divide between the transcript and the composer.
      child: SizedBox(
        height: 420,
        child: AstryxChatLayout(
          messages: <Widget>[
            for (final turn in _turns)
              AstryxChatMessage(
                role: turn.role,
                author: turn.role == AstryxChatRole.user
                    ? 'You'
                    : 'Assistant',
                child: AstryxText(turn.text),
              ),
          ],
          composer: AstryxChatComposer(
            controller: _draft,
            onSubmit: _send,
          ),
        ),
      ),
    );
  }
}
```


## Usage

```dart
AstryxChatLayout(
  messages: <Widget>[
    for (final turn in conversation) AstryxChatMessage(…),
  ],
  composer: AstryxChatComposer(controller: _draft, onSubmit: _send),
)
```

The turns go in **oldest first**, as they read. The layout owns the scrolling, which is the part that is easy to get wrong in three separate ways.

## It does not jump

The transcript is built **reversed**: the newest turn sits at offset zero. Growing content therefore cannot move what is on screen — no scroll correction, no post-frame `jumpTo`, none of the jitter those produce. It opens on the newest turn for the same reason, without animating there first.

That also means it **stays put when the reader has scrolled up**. A transcript that yanks itself back to the bottom as an answer streams in is one nobody can re-read a paragraph of.

> **Note**
>
> The reversal is an implementation detail and does not reach the caller. One place it is visible: a `controller` you pass sees offset zero as the **newest** turn and the maximum extent as the oldest.

## Jump to latest

Once the reader is more than `scrollButtonThreshold` from the newest turn, a button appears to take them back. A conversation that moved on while you were reading is otherwise something you have to scroll to discover — and the button is present or absent rather than faded, because a control that is half-there is one a user cannot decide about.

## The empty state

A conversation with nothing in it is the *first* thing most people using one see, so `empty` is a slot rather than a blank: a heading, a line of guidance, a few suggested prompts. With no turns the scroller is not built at all — a centred welcome inside a reversed list would sit at the bottom.

```dart
class ChatLayoutEmptyExample extends StatefulWidget {
  const ChatLayoutEmptyExample({super.key});

  @override
  State<ChatLayoutEmptyExample> createState() => _ChatLayoutEmptyExampleState();
}

class _ChatLayoutEmptyExampleState extends State<ChatLayoutEmptyExample> {
  final TextEditingController _draft = TextEditingController();

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // An empty conversation is the first thing most people see, so it is a slot
    // rather than a blank — and centred, which a reversed transcript could not
    // manage on its own.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      child: SizedBox(
        height: 380,
        child: AstryxChatLayout(
          messages: const <Widget>[],
          empty: AstryxEmptyState(
            title: 'Ask about a deploy',
            description:
                'Logs, timings and health checks for the last 30 days.',
            actions: <Widget>[
              AstryxButton(label: 'Why did 14:02 fail?', onPressed: () {}),
            ],
          ),
          composer: AstryxChatComposer(
            controller: _draft,
            onSubmit: (_) {},
          ),
        ),
      ),
    );
  }
}
```


> **Accessibility**
>
> Reversed in the widget tree, **oldest-first on screen** — so semantics traversal, which follows visual order, reads the conversation the way it happened. The transcript is a named container, and each turn keeps its own node inside it.

### AstryxChatLayout

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `messages` *(required)* | `List<Widget>` | — | The turns, oldest first. |
| `composer` *(required)* | `Widget` | — | Pinned below the transcript. |
| `header` | `Widget?` | — | Pinned above it — a title, a model picker, a banner. |
| `empty` | `Widget?` | — | Shown when there are no turns yet. |
| `controller` | `ScrollController?` | — | The transcript's controller. Offset zero is the newest turn. |
| `maxWidth` | `double` | `760` | The widest the transcript and composer grow — a measure, for the same reason prose has one. |
| `showScrollButton` | `bool` | `true` | Whether to offer the jump-to-latest button. |
| `scrollButtonThreshold` | `double` | `240` | How far from the newest turn the button appears. |


## Related

- [AstryxChatMessage](chat_message.md) — the turns that go in it.
- [AstryxChatComposer](chat_composer.md) — the input at the foot.
- [AstryxLayout](layout.md) — the frame for a page that is not a conversation.

