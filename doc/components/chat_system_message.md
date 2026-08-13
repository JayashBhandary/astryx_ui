---
title: AstryxChatSystemMessage
description: A turn that came from the system rather than either participant.
component: true
group: Chat & AI
source: lib/src/components/chat/chat_system_message.dart
upstream: ChatSystemMessage
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatSystemMessageDemoExample extends StatelessWidget {
  const ChatSystemMessageDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Things that happened *to* the conversation rather than in it. One action
    // slot: a notice with three buttons has become a form.
    return AstryxChatMessageList(
      children: <Widget>[
        const AstryxChatSystemMessage(
          'The model changed to the long-context one',
          icon: AstryxIconName.info,
        ),
        AstryxChatSystemMessage(
          'Context was trimmed to the last 20 turns',
          icon: AstryxIconName.warning,
          action: AstryxButton(
            label: 'Why?',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxChatSystemMessage('The model changed to the long-context one')
```

Things that happened *to* the conversation rather than in it: the model changed, the context was trimmed, the conversation was resumed. Centred, quiet, never in a bubble — because it is not a turn anybody took.

It is [AstryxChatMessage](chat_message.md) with `AstryxChatRole.system` and a shorter way to say so. Use the role directly when the content is not a line of text; use this when it is.

> **Note**
>
> `action` is **one** slot, not a list. A notice with three buttons in it has stopped being a notice and become a form — and a form in the middle of a transcript is a thing readers scroll past.

### AstryxChatSystemMessage

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `message` *(required)* | `String` | — | What happened. |
| `icon` | `AstryxIconName?` | — | A glyph before the text. |
| `action` | `Widget?` | — | One control — "Undo", "Why?". |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |


> **Accessibility**
>
> Announced as a **system message**, not as somebody’s turn. A reader walking a transcript needs to know that this line is not part of the conversation, and neither its position nor its colour conveys that.

## Related

- [AstryxChatMessage](chat_message.md) — the three roles, and what each is drawn as.
- [AstryxBanner](banner.md) — for a message about the *page* rather than the conversation.

---

Something wrong with `AstryxChatSystemMessage`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxChatSystemMessage&component=AstryxChatSystemMessage) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxChatSystemMessage&area=AstryxChatSystemMessage) — both templates arrive with the component filled in.
