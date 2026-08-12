---
title: AstryxChatToolCalls
description: The tool calls a model made, and their results, inside a turn.
component: true
group: Chat & AI
source: lib/src/components/chat/tool_calls.dart
upstream: ChatToolCalls
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ChatToolCallsDemoExample extends StatelessWidget {
  const ChatToolCallsDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Under the answer, collapsed, summarised in the row: what a reader wants
    // from a tool call is usually "did it work" rather than the JSON.
    return const AstryxChatMessage(
      author: 'Assistant',
      footer: AstryxChatToolCalls(
        calls: <AstryxToolCall>[
          AstryxToolCall(
            name: 'search_logs',
            summary: 'Searched 412 lines in deploy-log.txt',
            arguments: '{"query": "bind", "limit": 500}',
            result: '{"matches": 3, "first": "14:02:41"}',
          ),
          AstryxToolCall(
            name: 'read_metrics',
            status: AstryxToolCallStatus.running,
            summary: 'Reading the last hour',
          ),
          AstryxToolCall(
            name: 'read_file',
            status: AstryxToolCallStatus.failed,
            summary: 'scheduler/health.md',
            result: 'ENOENT: no such file',
            language: 'text',
          ),
        ],
      ),
      child: AstryxText(
        'The health check timed out — the port bind took 41 seconds.',
      ),
    );
  }
}
```


## Usage

```dart
AstryxChatMessage(
  author: 'Assistant',
  footer: AstryxChatToolCalls(calls: reply.toolCalls),
  child: AstryxMarkdown(reply.text),
)
```

A tool call is *how* an answer was reached, so it belongs in the turn’s `footer` — under the answer rather than in place of it. Each call is a disclosure, **collapsed by default and summarised in the row**: what a reader wants is usually "did it work" rather than the JSON.

The `summary` is worth more on the row than the arguments are, which is why the arguments are behind the disclosure and it is not. "Searched 412 log lines" answers the question; `{"query": "bind", "limit": 500}` restates it.

| `AstryxToolCallStatus` | Drawn as |
| --- | --- |
| `pending` | A neutral dot — queued, not started. |
| `running` | A spinner, labelled. Not a bare spinner: a wait with no words is a wait nobody can name. |
| `succeeded` | A success dot, and "Finished". |
| `failed` | An error dot, and "Failed". |

> **Accessibility**
>
> **Every status is paired with its word**, on the row and in the disclosure’s own content. Colour is never the only signal, and a dot is too small to carry a shape as well — so "Failed" is written next to the red one.

> **Careful**
>
> `initiallyExpanded` is false, and should usually stay false. A turn that unfolds four screens of JSON on arrival has buried the answer the reader was waiting for.

### AstryxChatToolCalls

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `calls` *(required)* | `List<AstryxToolCall>` | — | The calls, in the order they were made. |
| `label` | `String?` | — | Names the run. Defaults to "Tool calls". |
| `initiallyExpanded` | `bool` | `false` | Whether every call starts open. |


### AstryxToolCall

One call. Already-formatted strings rather than a `Map`: the model sent JSON, and re-encoding it here would only be a chance to encode it differently from the log beside it.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` *(required)* | `String` | — | The tool’s name. |
| `status` | `AstryxToolCallStatus` | `AstryxToolCallStatus.succeeded` | How far along it is. |
| `summary` | `String?` | — | A one-line description, for the collapsed row. |
| `arguments` | `String?` | — | What it was called with, formatted. |
| `result` | `String?` | — | What it returned, formatted. |
| `language` | `String` | `'json'` | The language of the two code blocks. |


## Related

- [AstryxCollapsible](collapsible.md) — the disclosure each call is.
- [AstryxCodeBlock](code_block.md) — where the payloads are drawn.
- [AstryxChatMessage](chat_message.md) — the `footer` these go in.

