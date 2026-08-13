---
title: AstryxTokenChip
description: One inline chip standing for an entity inside a text field.
component: true
group: Chat & AI
source: lib/src/components/chat/token.dart
upstream: Token
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TokenDemoExample extends StatefulWidget {
  const TokenDemoExample({super.key});

  @override
  State<TokenDemoExample> createState() => _TokenDemoExampleState();
}

class _TokenDemoExampleState extends State<TokenDemoExample> {
  final List<String> _attached = <String>[
    'deploy-log.txt',
    'metrics.csv',
    'scheduler/health.md',
  ];

  @override
  Widget build(BuildContext context) {
    // A token is a value somebody put there and can take away again — which is
    // what separates it from a badge, whatever they look like.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final file in _attached)
              AstryxTokenChip(
                file,
                onRemove: () => setState(() => _attached.remove(file)),
              ),
            const AstryxTokenChip('read-only.txt'),
          ],
        ),
        const AstryxText(
          'The last one has no remove button: it was presented, not chosen.',
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
AstryxTokenChip(
  'deploy-log.txt',
  icon: AstryxIconName.copy,
  onRemove: () => _detach(file),
)
```

> **Note**
>
> Upstream calls it `Token`; here it is `AstryxTokenChip`, because `AstryxToken` is already the **design token** interface every token enum implements. A design system cannot have two things called Token, and the older one is load-bearing in every theme.

## Not a badge

An [AstryxBadge](badge.md) is a *label*: static, never removable, and often not about anything the user chose. A token is a **value somebody put there** and can take away again. The two look similar and behave nothing alike, which is why they are separate widgets rather than a flag.

`onRemove` adds the remove button; without it the token is presented rather than chosen — a mention inside a message that has already been sent. `onPressed` makes the chip itself open what it stands for.

> **Accessibility**
>
> The remove button is named after **what it removes** — "Remove deploy-log.txt", not "Remove". A row of five buttons with identical names is a row a screen-reader user cannot choose from. A pressable token keeps its remove button as a node of its own, which is the one case where nesting controls is right: they do different things, and a reader has to be able to pick.

### AstryxTokenChip

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The entity’s name. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `onRemove` | `VoidCallback?` | — | Called when the remove button is pressed. Null omits the button. |
| `onPressed` | `VoidCallback?` | — | Called when the token itself is pressed. |
| `enabled` | `bool` | `true` | Whether the token responds. |


## Related

- [AstryxTokenizer](tokenizer.md) — the field that makes these.
- [AstryxChatTokenizedText](chat_tokenized_text.md) — the same chips inside a sentence.
- [AstryxBadge](badge.md) — the label this is not.

---

Something wrong with `AstryxTokenChip`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTokenChip&component=AstryxTokenChip) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTokenChip&area=AstryxTokenChip) — both templates arrive with the component filled in.
