---
title: AstryxChatDictationButton
description: 'The composer''s speech-to-text control.'
component: true
group: Chat & AI
source: lib/src/components/chat/chat_buttons.dart
upstream: ChatDictationButton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatDictationStatesExample extends StatefulWidget {
  const ChatDictationStatesExample({super.key});

  @override
  State<ChatDictationStatesExample> createState() =>
      _ChatDictationStatesExampleState();
}

class _ChatDictationStatesExampleState
    extends State<ChatDictationStatesExample> {
  bool _listening = false;

  @override
  Widget build(BuildContext context) {
    // Idle, listening, and unavailable. Listening is a pressed button rather
    // than an animation, so the state survives reduced motion — and the
    // unavailable one says why instead of just going dim.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxChatDictationButton(
          listening: _listening,
          onStart: () => setState(() => _listening = true),
          onStop: () => setState(() => _listening = false),
        ),
        const AstryxChatDictationButton(
          enabled: false,
          unavailableReason: 'No microphone permission',
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxChatDictationButton(
  listening: _listening,
  onStart: _startDictation,
  onStop: _stopDictation,
)
```

> **Careful**
>
> **This package does no speech recognition.** There is no platform channel here and no dependency that would bring one. What it provides is the control and its states, so a caller wiring `speech_to_text` or a platform API has somewhere to put it that looks and behaves like the rest of the composer.

The name follows the state — "Dictate", then "Stop dictating" — for the same reason the send control’s does. Listening is drawn as a pressed button rather than an animation, so the state survives reduced motion.

`unavailableReason` is the tooltip on a disabled control. A control that is dim for no stated reason is one a user assumes is broken; "No microphone permission" is a sentence they can act on.

### AstryxChatDictationButton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `onStart` | `VoidCallback?` | — | Called to begin listening. |
| `onStop` | `VoidCallback?` | — | Called to stop listening. |
| `listening` | `bool` | `false` | Whether it is listening now. |
| `enabled` | `bool` | `true` | Whether dictation is available at all. |
| `unavailableReason` | `String?` | — | Why it is unavailable, shown as the tooltip. |


> **Accessibility**
>
> Dictation is an *alternative* input, never the only one: a composer whose field is unusable without speech excludes anybody who cannot or will not talk to their computer. It sits beside the field, not instead of it.

## Related

- [AstryxChatSendButton](chat_send_button.md) — the control it sits beside.
- [AstryxChatComposer](chat_composer.md) — the `trailing` slot it goes in.

