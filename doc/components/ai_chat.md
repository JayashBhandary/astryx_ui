---
title: AI chat
description: 'A full conversation screen: transcript, composer, tool calls, and the empty state before the first turn.'
component: true
group: Templates
source: example/lib/examples/template_chat_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One turn of the conversation this template pretends to have had.
///
/// A record rather than a widget list: the transcript is data, and the widgets
/// are how it is drawn. Swapping the drawing is then a local change.
typedef _Turn = ({
  AstryxChatRole role,
  String text,
  List<AstryxToolCall> calls,
  bool cited,
});

class AiChatTemplate extends StatefulWidget {
  const AiChatTemplate({super.key});

  @override
  State<AiChatTemplate> createState() => _AiChatTemplateState();
}

class _AiChatTemplateState extends State<AiChatTemplate> {
  static const List<_Turn> _conversation = <_Turn>[
    (
      role: AstryxChatRole.user,
      text: 'Why did the 14:02 deploy fail?',
      calls: <AstryxToolCall>[],
      cited: false,
    ),
    (
      role: AstryxChatRole.assistant,
      text: '''
The health check **timed out**. The scheduler took 41 seconds to bind its port
and the check gives up at `30`.

- Three services restarted before the rollback
- The bind is the *real* problem — it used to take four seconds

1. Raise the timeout to 60 seconds to stop the bleeding
2. Look at the migration that ships with this release
''',
      calls: <AstryxToolCall>[
        AstryxToolCall(
          name: 'search_logs',
          summary: 'Searched 412 lines in deploy-log.txt',
          arguments: '{"query": "bind", "limit": 500}',
          result: '{"matches": 3, "first": "14:02:41"}',
        ),
        AstryxToolCall(
          name: 'read_file',
          summary: 'scheduler/health.md',
          result: 'timeout: 30s',
          language: 'yaml',
        ),
      ],
      cited: true,
    ),
  ];

  final TextEditingController _draft = TextEditingController();
  final List<_Turn> _turns = List<_Turn>.of(_conversation);

  bool _generating = false;
  bool _listening = false;
  String _model = 'long';

  /// The prompts the empty state offers, and what a fresh screen starts from.
  static const List<String> _suggestions = <String>[
    'Why did the 14:02 deploy fail?',
    'Which service restarted most this week?',
    'Summarise last night’s on-call',
  ];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _turns.add((
        role: AstryxChatRole.user,
        text: text.trim(),
        calls: <AstryxToolCall>[],
        cited: false,
      ));
      _draft.clear();
      _generating = true;
    });
  }

  /// Stands in for the answer arriving. A real screen appends tokens here.
  void _finish() {
    setState(() {
      _generating = false;
      _turns.add((
        role: AstryxChatRole.assistant,
        text:
            'This example does not actually answer — but this is where the '
            'streamed reply lands.',
        calls: <AstryxToolCall>[],
        cited: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bounded height: the chat layout divides what it is given between the
    // transcript and the composer, and a column hands its child an unbounded
    // height it cannot divide.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        padding: AstryxSpacingToken.spacing0,
        // The transcript owns its own scrolling — it opens at the newest turn
        // and stays there as turns arrive. Two scroll views is one too many.
        scrollable: false,
        header: _ChatHeader(
          turns: _turns.length,
          model: _model,
          onModelChanged: (value) => setState(() => _model = value ?? _model),
          onNew: () => setState(() {
            _turns.clear();
            _generating = false;
          }),
        ),
        child: AstryxChatLayout(
          messages: <Widget>[
            for (final turn in _turns) _turnMessage(turn),
            if (_generating)
              AstryxChatMessage(
                author: 'Assistant',
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    const AstryxSpinner(
                      size: AstryxSpinnerSize.sm,
                      label: 'Thinking',
                    ),
                    AstryxButton(
                      label: 'Skip the wait',
                      variant: AstryxButtonVariant.ghost,
                      size: AstryxButtonSize.sm,
                      onPressed: _finish,
                    ),
                  ],
                ),
              ),
          ],
          empty: AstryxCenter(
            maxWidth: 460,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing4,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxHeading(
                  'Ask about a deploy',
                  justify: AstryxTextJustify.center,
                ),
                const AstryxText(
                  'Logs, timings and health checks for the last 30 days.',
                  color: AstryxTextColor.secondary,
                  justify: AstryxTextJustify.center,
                ),
                // Suggestions are buttons, not placeholder text: a prompt you
                // have to retype is a prompt nobody uses.
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing2,
                  justify: AstryxStackJustify.center,
                  children: <Widget>[
                    for (final prompt in _suggestions)
                      AstryxButton(
                        label: prompt,
                        size: AstryxButtonSize.sm,
                        onPressed: () => _send(prompt),
                      ),
                  ],
                ),
              ],
            ),
          ),
          composer: AstryxChatComposer(
            controller: _draft,
            generating: _generating,
            placeholder: 'Ask about a deploy, a service or an incident',
            onSubmit: _send,
            onStop: () => setState(() => _generating = false),
            leading: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'Attach a file',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
            trailing: <Widget>[
              AstryxChatDictationButton(
                listening: _listening,
                onStart: () => setState(() => _listening = true),
                onStop: () => setState(() => _listening = false),
              ),
            ],
            footer: const AstryxText(
              'Answers cite the logs they came from. Check anything you are '
              'about to act on.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ),
        ),
      ),
    );
  }

  /// One turn, drawn according to who said it.
  ///
  /// The user's words are their own — plain text, never markdown, because
  /// rendering what somebody typed changes what they said. The assistant's
  /// answer is markdown, which is the format it arrives in.
  Widget _turnMessage(_Turn turn) {
    if (turn.role == AstryxChatRole.user) {
      return AstryxChatMessage(
        role: AstryxChatRole.user,
        author: 'You',
        child: AstryxText(turn.text),
      );
    }

    return AstryxChatMessage(
      author: 'Assistant',
      timestamp: AstryxTimestamp(
        DateTime.utc(2026, 8, 12, 14, 4),
        format: AstryxTimestampFormat.time,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      actions: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Copy this answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowUp,
          label: 'Good answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowDown,
          label: 'Bad answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
      footer: turn.calls.isEmpty
          ? null
          : AstryxChatToolCalls(calls: turn.calls),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxMarkdown(turn.text, onLinkPressed: (_) {}),
          if (turn.cited)
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: 'From '),
                  AstryxCitation.span(
                    1,
                    source: 'scheduler/health.md',
                    onPressed: () {},
                  ),
                  const TextSpan(text: ' and '),
                  AstryxCitation.span(
                    2,
                    source: 'deploy-log.txt#L412',
                    onPressed: () {},
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The band above the transcript: which model, and a way out of this thread.
class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.turns,
    required this.model,
    required this.onModelChanged,
    required this.onNew,
  });

  final int turns;
  final String model;
  final ValueChanged<String?> onModelChanged;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const Flexible(
                child: AstryxHeading('Why did 14:02 fail?', level: 1),
              ),
              AstryxBadge('$turns turns'),
            ],
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSelector<String>(
              label: 'Model',
              labelHidden: true,
              value: model,
              // A field stretches to whatever it is given, and a hugging row
              // gives it nothing to stretch to — so the width is stated here.
              width: 168,
              size: AstryxInputSize.sm,
              onChanged: onModelChanged,
              options: const <AstryxSelectorOption<String>>[
                AstryxSelectorOption(value: 'fast', label: 'Fast'),
                AstryxSelectorOption(value: 'long', label: 'Long context'),
              ],
            ),
            AstryxButton(
              label: 'New chat',
              size: AstryxButtonSize.sm,
              onPressed: onNew,
            ),
          ],
        ),
      ],
    );
  }
}
```

Send something to see the waiting state, then **Skip the wait** for the reply. **New chat** empties the transcript, which is how to see the empty state and its suggestions.


## Four states, not one screen

| State | Shown by | Why |
| --- | --- | --- |
| Nothing said yet | `empty:` on [AstryxChatLayout](chat_layout.md) | It is the first thing most people see, so it is a slot rather than a blank — and centred, which a transcript could not manage on its own. |
| Waiting for the answer | `generating: true` on the composer | The send button becomes stop. A spinner beside a live send button invites a second request nobody wanted. |
| Answered | [AstryxMarkdown](markdown.md) plus [AstryxChatToolCalls](chat_tool_calls.md) | The reply arrives as markdown and the work behind it is summarised, collapsed, underneath it. |
| Answered from sources | [AstryxCitation](citation.md) spans | The marker is a number, but its **name** is the source — a row of bare numerals is a puzzle, not a bibliography. |

## The user’s words are never markdown

The transcript renders the assistant’s turn with [AstryxMarkdown](markdown.md) and the user’s turn with plain [AstryxText](text.md). That asymmetry is deliberate. Rendering what somebody typed changes what they said: an underscore around a variable name becomes italics, and a line starting with `#` becomes a heading.

```dart
Widget _turnMessage(_Turn turn) {
  if (turn.role == AstryxChatRole.user) {
    return AstryxChatMessage(
      role: AstryxChatRole.user,
      author: 'You',
      child: AstryxText(turn.text),          // ← their words, as typed
    );
  }
  return AstryxChatMessage(
    author: 'Assistant',
    footer: AstryxChatToolCalls(calls: turn.calls),
    child: AstryxMarkdown(turn.text, onLinkPressed: _open),
  );
}
```

## Suggestions are buttons

The empty state offers three prompts and each one is an [AstryxButton](button.md) that sends itself. A suggestion you have to retype is a suggestion nobody uses, and placeholder text that disappears the moment you type is not a suggestion at all.

## Composition

```text
AstryxLayout(scrollable: false, padding: spacing0)
├── header ← title, turn count, model selector, "New chat"
└── AstryxChatLayout
    ├── messages  ← AstryxChatMessage per turn
    │   ├── actions: copy / good / bad     ← always visible
    │   ├── footer:  AstryxChatToolCalls   ← collapsed
    │   └── child:   AstryxMarkdown + AstryxCitation spans
    ├── empty     ← heading, line, three prompt buttons
    └── composer  ← AstryxChatComposer(generating:, onStop:)
```

> **Careful**
>
> **Bound the height and turn the layout’s scrolling off.** `AstryxChatLayout` divides what it is given between the transcript and the composer, so it needs a bounded height and it owns the scrolling itself. Inside a scrollable [AstryxLayout](layout.md) it would be a scroll view inside a scroll view, and inside a bare column it would be handed an unbounded height it cannot divide.

> **Accessibility**
>
> The per-message actions — copy, good answer, bad answer — are visible at all times and each names *which* answer it acts on. Feedback buttons that appear on hover are feedback no touch user can give.

The composer’s footer carries the disclaimer. It belongs there rather than in a [toast](toast.md) or a [banner](banner.md) at the top: it is a standing fact about every answer, and the moment it matters is the moment somebody is about to ask.

## Related

- [AstryxChatLayout](chat_layout.md) — the transcript, the scroll behaviour and the empty slot.
- [AstryxChatComposer](chat_composer.md) — Enter, Shift+Enter, generating and stop.
- [AstryxChatToolCalls](chat_tool_calls.md) — what the model did, summarised.
- [AstryxMarkdown](markdown.md) — what it renders, and what it does not.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

