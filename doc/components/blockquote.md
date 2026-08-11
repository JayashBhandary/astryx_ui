---
title: AstryxBlockquote
description: A quotation set apart from the surrounding prose.
component: true
group: Data display
source: lib/src/components/data/blockquote.dart
upstream: Blockquote
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BlockquoteDemoExample extends StatelessWidget {
  const BlockquoteDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxBlockquote(
      'The deploy took eleven minutes and nobody could tell why until we read '
      'the logs in the wrong order and found it by accident.',
      attribution: 'Incident 412, postmortem',
    );
  }
}
```


## Usage

```dart
const AstryxBlockquote(
  'The deploy took eleven minutes and nobody could tell why.',
  attribution: 'Postmortem, 3 March',
)
```

For **someone else’s words**: a customer’s complaint in a case study, a line from a spec, the sentence an incident report turns on. Not for emphasis — a paragraph of your own set in a quote is a paragraph pretending to have a source. For a message the page itself is making, use [AstryxBanner](banner.md).

The em dash before the attribution is the widget’s, not yours.

## Longer quotations

A long quotation is not always one paragraph of plain text, and a blockquote that cannot hold the rest is one people work around. `child` takes anything.

```dart
class BlockquoteChildExample extends StatelessWidget {
  const BlockquoteChildExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A long quotation is not always one paragraph of plain text. `child`
    // takes anything — here the command the report is quoting.
    return const AstryxBlockquote(
      '',
      attribution: 'Runbook, step 4',
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(
            'Drain the node before restarting it, or in-flight requests are '
            'dropped:',
            color: AstryxTextColor.secondary,
          ),
          AstryxCodeBlock(
            'kubectl drain node-7 --ignore-daemonsets',
            language: 'bash',
          ),
        ],
      ),
    );
  }
}
```


### AstryxBlockquote

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `quote` *(required)* | `String` | — | The quoted text. The positional first argument, and empty when `child` carries the quotation instead. |
| `attribution` | `String?` | — | Who or what is being quoted, shown under it. |
| `child` | `Widget?` | — | Replaces `quote` with arbitrary content — a list, a table, code. |


