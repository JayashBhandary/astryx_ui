---
title: AstryxChatTokenizedText
description: Message text with mentions and references rendered as tokens.
component: true
group: Chat & AI
source: lib/src/components/chat/token_text.dart
upstream: ChatTokenizedText
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatTokenizedTextDemoExample extends StatelessWidget {
  const ChatTokenizedTextDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Once a message is sent there is no caret to protect, so the mentions are
    // real chips — pressable, and part of the sentence for a screen reader.
    return AstryxChatMessage(
      role: AstryxChatRole.user,
      author: 'You',
      child: AstryxChatTokenizedText(
        'Ask @ada whether deploy-log.txt explains the 14:02 failure',
        tokens: <String, AstryxTextToken>{
          '@ada': AstryxTextToken(onPressed: () {}, tooltip: 'Ada Lovelace'),
          'deploy-log.txt': AstryxTextToken(
            icon: AstryxIconName.copy,
            onPressed: () {},
          ),
        },
      ),

    );
  }
}
```


## Usage

```dart
AstryxChatTokenizedText(
  'Ask @ada about deploy-log.txt',
  tokens: <String, AstryxTextToken>{
    '@ada': AstryxTextToken(value: ada.id, onPressed: _openProfile),
    'deploy-log.txt': AstryxTextToken(icon: AstryxIconName.copy),
  },
)
```

Read-only, which is what makes it straightforward: the chips are `WidgetSpan`s inside a `Text.rich`, and there is no caret to walk into the middle of one. That is the difference from [the composer’s controller](chat_composer_token.md), which cannot use widgets at all.

Matching is by literal run, **longest first**, so `@ada` and `@adam` can both be tokens without the shorter one chopping the longer in half. The value a caller cares about travels in `AstryxTextToken.value`, so a press acts on the thing rather than on the string that named it.

> **Accessibility**
>
> **The plain sentence is what is announced.** "Ask at-ada about deploy-log.txt" is the message; a chip announced as a separate control mid-sentence is a sentence nobody can follow. The chips are excluded from semantics and the container carries the text.

### AstryxChatTokenizedText

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `text` *(required)* | `String` | — | The whole message. |
| `tokens` *(required)* | `Map<String, AstryxTextToken>` | — | The runs to draw as chips, keyed by the literal text they appear as. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to `text`. |


### AstryxTextToken

What one entity in a run of text stands for.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `icon` | `AstryxIconName?` | — | A glyph on the chip. |
| `onPressed` | `VoidCallback?` | — | Called when it is pressed. |
| `value` | `Object?` | — | What the entity *is*, for the caller’s own use. |
| `tooltip` | `String?` | — | A phrase describing the entity, if the label alone is cryptic. |


## Related

- [AstryxTokenTextController](chat_composer_token.md) — the same tokens while they are being typed.
- [AstryxTokenChip](token.md) — the chip on its own.
- [AstryxMarkdown](markdown.md) — for an answer whose structure matters more than its mentions.

---

Something wrong with `AstryxChatTokenizedText`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxChatTokenizedText&component=AstryxChatTokenizedText) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxChatTokenizedText&area=AstryxChatTokenizedText) — both templates arrive with the component filled in.
