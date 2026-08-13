---
title: AstryxChatMessage
description: One turn in a conversation — the bubble, its metadata, and the list that holds them.
component: true
group: Chat & AI
source: lib/src/components/chat/chat_message.dart
upstream: ChatMessage / ChatMessageBubble / ChatMessageList / ChatMessageMetadata
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatMessageRolesExample extends StatelessWidget {
  const ChatMessageRolesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // A bubble for the user, plain page content for the answer, and a centred
    // notice for the system. The actions under the answer are always there:
    // hover-only controls are unreachable on a phone.
    return AstryxChatMessageList(
      children: <Widget>[
        AstryxChatMessage(
          role: AstryxChatRole.user,
          author: 'You',
          timestamp: AstryxTimestamp(
            now.subtract(const Duration(minutes: 4)),
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          child: const AstryxText('Why did the 14:02 deploy fail?'),
        ),
        AstryxChatMessage(
          author: 'Assistant',
          timestamp: AstryxTimestamp(
            now.subtract(const Duration(minutes: 3)),
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.copy,
              label: 'Copy the answer',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
            AstryxIconButton(
              icon: AstryxIconName.arrowsUpDown,
              label: 'Try again',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
          footer: const AstryxText(
            'Sources: deploy-log/14:02, scheduler/health',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          child: const AstryxText(
            'The health check timed out: the scheduler took 41 seconds to bind '
            'its port and the check gives up at 30.',
          ),
        ),
        const AstryxChatMessage(
          role: AstryxChatRole.system,
          child: AstryxText('The model changed to the long-context one'),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxChatMessage(
  role: AstryxChatRole.assistant,
  author: 'Assistant',
  timestamp: AstryxTimestamp(reply.at),
  actions: <Widget>[copyButton, retryButton],
  child: AstryxText(reply.text),
)
```

Upstream's `ChatMessage`, `ChatMessageBubble` and `ChatMessageMetadata` are one widget here, because the three are never useful apart: a bubble with no metadata has nothing to say about who wrote it, and metadata with no bubble has nothing to attach to.

## Only one role gets a bubble

| `AstryxChatRole` | Drawn as |
| --- | --- |
| `user` | A bubble, aligned to the reading end and capped at `maxWidth` — the shape that says "you wrote this" without a label. |
| `assistant` | **Not** a bubble. An answer is the content of the page: often long, often containing a code block or a table, and wrapping all of that in a rounded box makes it read as an aside. |
| `system` | Centred and quiet. "The model changed", "This conversation was resumed" — not a turn anybody took. |

## The actions are always visible

> **Careful**
>
> Upstream reveals a turn's controls on hover. **This does not**, and cannot: touch has no hover, and the density system actively suppresses hover styling there. A retry button nobody can reach on a phone is not a retry button. Keep the set small if the row feels busy — do not hide it.

## A turn still arriving

Put [AstryxStreamingText](use_streaming_text.md) in the `child` for an answer that is streaming, and a [spinner](spinner.md) for the wait before the first token. Neither moves the transcript, because the layout keeps the newest turn at offset zero.

```dart
class ChatMessageStreamingExample extends StatefulWidget {
  const ChatMessageStreamingExample({super.key});

  @override
  State<ChatMessageStreamingExample> createState() =>
      _ChatMessageStreamingExampleState();
}

class _ChatMessageStreamingExampleState
    extends State<ChatMessageStreamingExample> {
  static const String _answer =
      'Three services restarted and the health check passed on the first '
      'attempt. Total time was 41 seconds, most of it waiting on the port '
      'bind.';

  String _shown = '';

  void _stream() => setState(() => _shown = _answer);

  @override
  Widget build(BuildContext context) {
    // A turn whose content is `AstryxStreamingText`: the transcript does not
    // move as it types, because the layout keeps the newest turn at offset 0.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxChatMessage(
          author: 'Assistant',
          child: _shown.isEmpty
              ? const AstryxSpinner(label: 'Thinking')
              : AstryxStreamingText(
                  _shown,
                  streaming: false,
                  charactersPerSecond: 45,
                ),
        ),
        AstryxButton(
          label: _shown.isEmpty ? 'Stream the answer' : 'Reset',
          onPressed: () => _shown.isEmpty
              ? _stream()
              : setState(() => _shown = ''),
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> **Every turn is announced with who said it.** Layout carries that for a sighted reader — a bubble on the right is obviously yours — and carries nothing at all for anybody else, so `author` is the turn's accessible name and the role supplies a fallback ("You", "Assistant") when there is none. The content keeps its own nodes: a transcript read as one long string with no turn boundaries is not a transcript.

### AstryxChatMessage

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The turn's content — text, a code block, a table, a card. |
| `role` | `AstryxChatRole` | `AstryxChatRole.assistant` | Who it came from. |
| `author` | `String?` | — | The name shown above the turn, and its accessible name. |
| `timestamp` | `Widget?` | — | Shown beside the author. |
| `leading` | `Widget?` | — | A widget before the turn — an avatar. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls for this turn. Always visible. |
| `footer` | `Widget?` | — | Below the turn and its actions — sources, a tool call, a warning. |
| `maxWidth` | `double?` | `480` | How wide a `user` bubble may get. An assistant turn is unconstrained. |


### AstryxChatMessageList

Upstream's `ChatMessageList`. **Not a scroller** — `AstryxChatLayout` owns that, and a list scrolling inside a scroller is the nested-viewport bug every chat UI ships once.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The turns, oldest first. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing6` | The space between turns. Generous, because the gap is what separates a question from its answer. |
| `label` | `String?` | — | Names the transcript. |


## Related

- [AstryxChatLayout](chat_layout.md) — the frame that scrolls these.
- [AstryxStreamingText](use_streaming_text.md) — an answer as it arrives.
- [AstryxCodeBlock](code_block.md) — what an answer full of code goes in.

---

Something wrong with `AstryxChatMessage`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxChatMessage&component=AstryxChatMessage) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxChatMessage&area=AstryxChatMessage) — both templates arrive with the component filled in.
