---
title: AstryxCitation
description: A numbered reference from generated text back to its source.
component: true
group: Chat & AI
source: lib/src/components/chat/citation.dart
upstream: Citation
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CitationDemoExample extends StatelessWidget {
  const CitationDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The marker is a number; the *name* is the source. "1" is not a
    // destination, and a row of bare numerals is a puzzle rather than a
    // bibliography.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'The check gives up at 30 seconds'),
              AstryxCitation.span(
                1,
                source: 'scheduler/health.md',
                onPressed: () {},
              ),
              const TextSpan(text: ' and the bind took 41'),
              AstryxCitation.span(
                2,
                source: 'deploy-log.txt#L412',
                onPressed: () {},
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const AstryxText(
          'Hover or focus a marker for its source; both are in its name too.',
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
Text.rich(
  TextSpan(
    children: <InlineSpan>[
      const TextSpan(text: 'The check gives up at 30 seconds'),
      AstryxCitation.span(1, source: 'scheduler/health.md',
          onPressed: _open),
    ],
  ),
)
```

`AstryxCitation.span` puts one inside a sentence; the widget on its own is for a list of sources under an answer.

## Named for its source

> **Accessibility**
>
> **"1" is not a destination.** The visible marker is a number because a number is all that fits, but the accessible name is "Source 1: scheduler/health.md" — a screen-reader user offered a row of bare numerals has been given a puzzle instead of a bibliography. The source is in the name whether or not it is in the tooltip, so it is never pointer-only.

A citation with no `onPressed` is not announced as a button and takes no focus: a marker that looks pressable and does nothing is worse than a plain one. With one, `Enter` and `Space` follow it like any other control.

### AstryxCitation

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `number` *(required)* | `int` | — | Which reference this is, as the reader counts them. One-based. |
| `source` | `String?` | — | What it points at. Shown on hover and focus, and always part of the accessible name. |
| `onPressed` | `VoidCallback?` | — | Called when it is pressed. |
| `AstryxCitation.span(…)` | `static` | — | The same marker as an `InlineSpan`, aligned to sit with the text. |


## Related

- [AstryxMarkdown](markdown.md) — what the cited text is usually drawn with.
- [AstryxLink](link.md) — for a reference that is a destination rather than a footnote.
- [AstryxChatMessage](chat_message.md) — the `footer` a source list goes in.

---

Something wrong with `AstryxCitation`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCitation&component=AstryxCitation) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCitation&area=AstryxCitation) — both templates arrive with the component filled in.
