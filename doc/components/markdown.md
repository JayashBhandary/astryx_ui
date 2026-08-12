---
title: AstryxMarkdown
description: Rendered markdown, for model output and authored prose alike.
component: true
group: Chat & AI
source: lib/src/components/chat/markdown.dart
upstream: Markdown
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class MarkdownDemoExample extends StatelessWidget {
  const MarkdownDemoExample({super.key});

  static const String _answer = '''
# Why the deploy failed

The health check **timed out**. The scheduler took 41 seconds to bind its port
and the check gives up at `30`.

- Three services restarted
- The bind is the *real* problem — it used to take four seconds

1. Raise the timeout to 60 seconds
2. Look at the migration in this release

> Worth reading the migration notes before changing the timeout.

---

```dart
final healthy = await check(timeout: const Duration(seconds: 60));
```

See [the runbook](https://example.com/runbook) for the rollback steps.
''';

  @override
  Widget build(BuildContext context) {
    // Drawn with the design system's own widgets, so an answer looks like part
    // of the application rather than a web page inside it.
    return AstryxMarkdown(_answer, onLinkPressed: (target) {});
  }
}
```


## Usage

```dart
AstryxMarkdown(reply.text, onLinkPressed: _open)
```

A model answers in markdown, so something has to draw it — and drawing it with `AstryxHeading`, `AstryxCodeBlock`, `AstryxBlockquote` and `AstryxLink` is what keeps an answer looking like part of the application rather than a web page inside it.

## What it renders

| Markdown | Drawn as |
| --- | --- |
| `#` … `######` | `AstryxHeading`, at the matching level |
| Paragraphs | `AstryxText` |
| `- `, `* `, `1. ` | A bullet or number and its text |
| Fenced blocks | `AstryxCodeBlock`, language and all |
| `> ` | `AstryxBlockquote` |
| `---` | `AstryxDivider` |
| `**bold**`, `*italic*`, `` `code` ``, `[text](url)` | Inline spans — the last one an `AstryxLink` |

## What it does not

> **Careful**
>
> **Tables, images, footnotes, nested lists, task lists, inline HTML — and text selection across blocks.** They are absent rather than half-drawn: a table rendered as run-together text is worse than a table nobody rendered, because the reader cannot tell it *was* a table. Unsupported input degrades to paragraphs and never throws, which is what matters for arbitrary model output.

Reach for a real markdown package where the input is arbitrary and the output matters that much. This exists so a chat answer looks right, and it says what it can do.

## Links

Without `onLinkPressed` a link is drawn as **plain text**. Looking like a control and not being one is the worse of the two failures, and this package does not decide what following a link means — see [AstryxLinkScope](link_provider.md).

### AstryxMarkdown

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `source` *(required)* | `String` | — | The markdown. |
| `onLinkPressed` | `ValueChanged<String>?` | — | Called with the target of a link that was followed. Null draws links as text. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The space between blocks. |


> **Accessibility**
>
> Heading levels come straight from the `#` count, so the outline a reader navigates by is the one the author wrote. `AstryxHeading` derives its size from that level rather than the other way round, which is why there is nothing here to get wrong.

## Related

- [AstryxCodeBlock](code_block.md) — fenced blocks, and the copy control.
- [AstryxStreamingText](use_streaming_text.md) — for an answer still arriving; render markdown once it has.
- [AstryxCitation](citation.md) — the markers that go in cited prose.

