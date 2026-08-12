---
title: AstryxChatSendButton
description: 'The composer''s submit control, reflecting sending and stop-generating.'
component: true
group: Chat & AI
source: lib/src/components/chat/chat_buttons.dart
upstream: ChatSendButton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatSendButtonStatesExample extends StatefulWidget {
  const ChatSendButtonStatesExample({super.key});

  @override
  State<ChatSendButtonStatesExample> createState() =>
      _ChatSendButtonStatesExampleState();
}

class _ChatSendButtonStatesExampleState
    extends State<ChatSendButtonStatesExample> {
  bool _hasDraft = false;
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    // One control, two jobs — in the place the hand is already going. Two
    // buttons side by side, one always inert, is the arrangement this replaces.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxSwitch(
              label: 'Has a draft',
              value: _hasDraft,
              onChanged: (value) => setState(() => _hasDraft = value),
            ),
            AstryxSwitch(
              label: 'Generating',
              value: _generating,
              onChanged: (value) => setState(() => _generating = value),
            ),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxChatSendButton(
              canSend: _hasDraft,
              generating: _generating,
              onSend: () {},
              onStop: () {},
            ),
          ],
        ),
      ],
    );
  }
}
```


## One control, two jobs

The thing you press to start a reply is the thing you press to stop it, in the place your hand is already going. Two buttons side by side, one of them always inert, is the arrangement this replaces.

| State | Shows |
| --- | --- |
| `canSend: false` | A disabled send. An empty draft is not an error and not a disabled composer — it is a button with nothing to do yet. |
| `canSend: true` | A primary send. |
| `generating: true` | A stop control, named "Stop generating" — a separate string, because a button whose meaning changes needs a name that changes with it. |

`AstryxChatComposer` builds one of these itself, so most callers never name it. Reach for it directly when assembling a composer of your own — and note that it is deliberately not a private class, because two implementations of send-becomes-stop would eventually disagree.

> **Accessibility**
>
> A screen reader announces the *name*, not the glyph, so the name is what has to change between the two states. The control is also always present rather than revealed: on a touch keyboard the return key inserts a newline and there is no Shift to hold, which makes the button the only way to send.

### AstryxChatSendButton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `onSend` | `VoidCallback?` | — | Called to send. |
| `onStop` | `VoidCallback?` | — | Called to stop a reply in flight. |
| `canSend` | `bool` | `false` | Whether there is something to send. |
| `generating` | `bool` | `false` | Whether a reply is being generated. |
| `enabled` | `bool` | `true` | Whether the control responds at all. |


## Related

- [AstryxChatComposer](chat_composer.md) — where it sits, and the Enter key.
- [AstryxChatDictationButton](chat_dictation_button.md) — the other control beside the field.

