---
title: AstryxTokenizer
description: The field that turns typed text into tokens.
component: true
group: Chat & AI
source: lib/src/components/chat/token.dart
upstream: Tokenizer
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TokenizerDemoExample extends StatefulWidget {
  const TokenizerDemoExample({super.key});

  @override
  State<TokenizerDemoExample> createState() => _TokenizerDemoExampleState();
}

class _TokenizerDemoExampleState extends State<TokenizerDemoExample> {
  List<String> _to = <String>['ada@example.com'];

  @override
  Widget build(BuildContext context) {
    // Type and press Enter, or paste a comma-separated list. Backspace on an
    // empty field takes the last one back.
    return AstryxTokenizer(
      label: 'Recipients',
      description: 'Enter or a comma commits. Backspace removes the last.',
      values: _to,
      validate: (candidate) => candidate.contains('@'),
      status: _to.isEmpty
          ? const AstryxFieldStatus.error('At least one recipient')
          : null,
      onChanged: (values) => setState(() => _to = values),
    );
  }
}
```


## Usage

```dart
AstryxTokenizer(
  label: 'Recipients',
  values: _to,
  validate: (candidate) => candidate.contains('@'),
  onChanged: (values) => setState(() => _to = values),
)
```

For free text that becomes a set — recipients, tags, labels — where the values are **not** from a list. When they are, [AstryxMultiSelector](multi_selector.md) is the widget: it can show what the options are, and this cannot.

## Keyboard

| Key | Does |
| --- | --- |
| `Enter` | Commits the draft as a token. |
| A delimiter — `,` by default | Commits everything before it, so pasting "a@x.com, b@x.com" lands as two tokens rather than one long string. |
| `Backspace` on an empty draft | Takes the last token back — the only way to undo one without reaching for the pointer. |

A batch commits as **one** change. That is not a detail: `values` is the parent’s list and does not update until it rebuilds, so committing twice in a frame built the second value on top of a stale list and threw the first away. Pasting a comma-separated list is exactly that case.

## Refusing a value

`validate` decides what may be committed. A refused candidate **keeps its text**, so the user can see what was refused and fix it; a duplicate does not, because it is already there and leaving it in the field reads as the press not registering. Say *why* with `status`.

### AstryxTokenizer

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `values` *(required)* | `List<String>` | — | The committed values, in the order they were added. |
| `onChanged` | `ValueChanged<List<String>>?` | — | Called with the new set whenever one is added or removed. |
| `label` | `String?` | — | The field’s label and accessible name. |
| `validate` | `bool Function(String)?` | — | Whether a candidate may be committed. |
| `allowDuplicates` | `bool` | `false` | Whether the same value may appear twice. |
| `delimiters` | `List<String>` | `const <String>[',']` | Characters that commit the current text. |
| `icon` | `AstryxIconName?` | — | A glyph on every token. |


> **Accessibility**
>
> The field announces **how many values it holds** as its value, so a reader tabbing onto it is told what is already there rather than having to walk the tokens. Each token keeps its own node, and each remove button is named after its token.

## Related

- [AstryxTokenChip](token.md) — the chips it makes.
- [AstryxMultiSelector](multi_selector.md) — when the values come from a list.
- [AstryxField](field.md) — the label and validation wrapper around it.

