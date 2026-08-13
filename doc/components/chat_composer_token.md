---
title: AstryxTokenTextController
description: A mention styled inside the text being typed.
component: true
group: Chat & AI
source: lib/src/components/chat/token_text.dart
upstream: ChatComposerTokenElement
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatComposerTokenExample extends StatefulWidget {
  const ChatComposerTokenExample({super.key});

  @override
  State<ChatComposerTokenExample> createState() =>
      _ChatComposerTokenExampleState();
}

class _ChatComposerTokenExampleState extends State<ChatComposerTokenExample> {
  final AstryxTokenTextController _draft = AstryxTokenTextController(
    tokens: const <String, AstryxTextToken>{
      '@ada': AstryxTextToken(),
      '@grace': AstryxTextToken(),
      'deploy-log.txt': AstryxTextToken(),
    },
    text: 'Ask @ada about deploy-log.txt',
  );

  List<String> _mentioned = <String>[];

  @override
  void initState() {
    super.initState();
    _draft.addListener(_track);
    _mentioned = _draft.present;
  }

  void _track() => setState(() => _mentioned = _draft.present);

  @override
  void dispose() {
    _draft
      ..removeListener(_track)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The tokens are *styled text*, not widgets: edit around them and the
    // caret, selection and backspace behave exactly as they do anywhere else.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxChatComposer(controller: _draft, onSubmit: (_) {}),
        AstryxText(
          _mentioned.isEmpty
              ? 'Nothing mentioned'
              : 'Mentioned: ${_mentioned.join(', ')}',
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
final controller = AstryxTokenTextController(
  tokens: <String, AstryxTextToken>{'@ada': const AstryxTextToken()},
);

AstryxChatComposer(controller: controller, onSubmit: _send)
```

A `TextEditingController` that styles the token runs inside what is being typed. Hand it to any Astryx text field — the composer is only the obvious one.

## Styled text, not a widget

> **Careful**
>
> Upstream puts a real element inside a `contenteditable`. Flutter’s `EditableText` edits a **`String`**, and a `WidgetSpan` in an editable’s span tree breaks the caret: arrow keys step over a chip as if it were one character, selection maths goes wrong, and backspace deletes something other than what is highlighted. So a token here is an accent colour on a tinted ground — it reads as a chip, and every character still counts as itself.

That is the whole difference, and it is confined to the composer. Once a message is sent there is no caret to protect, so [AstryxChatTokenizedText](chat_tokenized_text.md) draws real, pressable chips.

## What is in the draft

`present` lists the token runs in the current text, in order — what a caller sends alongside the message when the server needs the ids of everybody mentioned. It is derived from the text, so deleting a mention removes it with no bookkeeping.

### AstryxTokenTextController

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `tokens` | `Map<String, AstryxTextToken>` | — | The runs to style, keyed by the literal text they appear as. Settable: the field repaints when what the text *means* changes. |
| `present` | `List<String>` | — | The token runs in the current text, in order. |
| `text` | `String` | — | Inherited, and unchanged by any of this — which is the point. |


> **Note**
>
> Matching is by literal run, longest first, so `@ada` and `@adam` can both be tokens without the shorter one eating the longer. Composing text is left alone: styling a half-typed IME candidate would fight the underline the platform draws under it.

## Related

- [AstryxChatTokenizedText](chat_tokenized_text.md) — the same tokens as real chips, after sending.
- [AstryxTokenChip](token.md) — the chip itself.
- [AstryxChatComposer](chat_composer.md) — where this controller usually goes.

---

Something wrong with `AstryxTokenTextController`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTokenTextController&component=AstryxTokenTextController) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTokenTextController&area=AstryxTokenTextController) — both templates arrive with the component filled in.
