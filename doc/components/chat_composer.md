---
title: AstryxChatComposer
description: The input a message is written in, with its drawer.
component: true
group: Chat & AI
source: lib/src/components/chat/chat_composer.dart
upstream: ChatComposer / ChatComposerDrawer / ChatComposerInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatComposerDemoExample extends StatefulWidget {
  const ChatComposerDemoExample({super.key});

  @override
  State<ChatComposerDemoExample> createState() =>
      _ChatComposerDemoExampleState();
}

class _ChatComposerDemoExampleState extends State<ChatComposerDemoExample> {
  final TextEditingController _draft = TextEditingController();
  final List<String> _sent = <String>[];

  bool _generating = false;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    setState(() {
      _sent.insert(0, text);
      _draft.clear();
      _generating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Enter sends, Shift+Enter starts a line, and the send button is disabled
    // until there is something to send. While generating it becomes stop.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxChatComposer(
          controller: _draft,
          generating: _generating,
          onSubmit: _send,
          onStop: () => setState(() => _generating = false),
          leading: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.wrench,
              label: 'Tools',
              variant: AstryxButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
          trailing: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.microphone,
              label: 'Dictate',
              variant: AstryxButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
          footer: const AstryxText(
            'Enter sends · Shift+Enter starts a line',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ),
        if (_sent.isNotEmpty)
          AstryxText(
            'Sent: ${_sent.first}',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxChatComposer(
  controller: _draft,
  generating: _isGenerating,
  onSubmit: _send,
  onStop: _stop,
)
```

The `controller` is required, unlike most fields here: a composer's text is read by the send button, cleared on submit and often restored from a draft, so an internal controller nobody could reach would be useless.

> **Note**
>
> Clearing it after a send is **yours**. A send that failed should not have thrown the text away — which is what an automatic clear does to somebody on a bad connection.

## Enter sends

**Enter sends; Shift+Enter starts a line.** That is the convention every chat interface has settled on, and getting it backwards is the fastest way to make a composer feel wrong. `submitOnEnter: false` swaps it for a composer whose messages are routinely several paragraphs.

| Key | Does |
| --- | --- |
| `Enter` | Sends, if there is a non-empty draft. |
| `Shift` + `Enter` | Starts a line. |
| `Enter` while generating | Nothing. The reply in flight is the answer to the last one. |

An empty or whitespace-only draft is never sent, by key or by button, so a stray Enter cannot post nothing. An Enter that could not send is still *claimed* — it must not silently insert a line instead.

## Send, and stop

One control, two jobs: it sends while there is a draft, and becomes **stop generating** while `generating`. Two separate strings name it, because a button whose meaning changes needs a name that changes with it. Without an `onStop` it is disabled rather than dishonest.

The button is always present, never revealed. On a touch keyboard the return key inserts a newline and there is no Shift to hold, so the button is the *only* way to send there.

## The drawer

Upstream's `ChatComposerDrawer`: the attachments, the referenced files, the selected context. It sits inside the composer's own surface rather than floating above it, so what is about to be sent is unmistakable.

```dart
class ChatComposerDrawerExample extends StatefulWidget {
  const ChatComposerDrawerExample({super.key});

  @override
  State<ChatComposerDrawerExample> createState() =>
      _ChatComposerDrawerExampleState();
}

class _ChatComposerDrawerExampleState extends State<ChatComposerDrawerExample> {
  final TextEditingController _draft = TextEditingController();
  final List<String> _attached = <String>['deploy-log-14-02.txt'];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The drawer is part of the composer's surface rather than floating above
    // it, so what is about to be sent is unmistakable.
    return AstryxChatComposer(
      controller: _draft,
      onSubmit: (_) => setState(_draft.clear),
      drawer: _attached.isEmpty
          ? null
          : AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                for (final file in _attached)
                  AstryxBadge(file),
                AstryxButton(
                  label: 'Remove all',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () => setState(_attached.clear),
                ),
              ],
            ),
      leading: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Attach a file',
          variant: AstryxButtonVariant.ghost,
          onPressed: () => setState(() => _attached.add('metrics.csv')),
        ),
      ],
    );
  }
}
```


> **Careful**
>
> **Inline tokens are not ported.** Upstream's `ChatComposerTokenElement` renders a mention as a chip *inside* the editable text, which needs a rich-text editing controller this package does not have — `EditableText` edits a `String`. A half-working version that lets a caret walk into the middle of a chip would be worse than the gap, so the field is plain text for now.

> **Accessibility**
>
> The field is named without being labelled on screen: a visible label above a chat input is one nobody needs, and its absence would leave a screen reader with nothing. `label` overrides the name — "Message" by default — and the send control is named for what it will do *now*.

### AstryxChatComposer

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `TextEditingController` | — | The draft being written. |
| `onSubmit` | `ValueChanged<String>?` | — | Called with the trimmed draft. Never with an empty one. |
| `onStop` | `VoidCallback?` | — | Called when the user asks to stop generating. |
| `generating` | `bool` | `false` | Whether a reply is in flight. Turns send into stop. |
| `placeholder` | `String?` | — | Shown while empty. Defaults to "Send a message…". |
| `label` | `String?` | — | The field's accessible name. Announced, not shown. |
| `leading` | `List<Widget>` | `const <Widget>[]` | Controls before the field — attach, a model picker, a tool menu. |
| `trailing` | `List<Widget>` | `const <Widget>[]` | Controls between the field and the send button. |
| `drawer` | `Widget?` | — | Content above the field, in the same surface. |
| `footer` | `Widget?` | — | Content below the composer — a hint, a count, a disclaimer. |
| `maxLines` | `int` | `8` | The most lines before the field scrolls instead of growing. |
| `submitOnEnter` | `bool` | `true` | Whether Enter sends. |


## Related

- [AstryxChatLayout](chat_layout.md) — where a composer is pinned.
- [AstryxTextArea](text_area.md) — the growing field underneath it.
- [AstryxFileInput](file_input.md) — for attachments outside a conversation.

---

Something wrong with `AstryxChatComposer`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxChatComposer&component=AstryxChatComposer) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxChatComposer&area=AstryxChatComposer) — both templates arrive with the component filled in.
