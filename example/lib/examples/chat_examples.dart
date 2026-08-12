import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example chat_layout_demo -> ChatLayoutDemoExample
class ChatLayoutDemoExample extends StatefulWidget {
  const ChatLayoutDemoExample({super.key});

  @override
  State<ChatLayoutDemoExample> createState() => _ChatLayoutDemoExampleState();
}

class _ChatLayoutDemoExampleState extends State<ChatLayoutDemoExample> {
  final TextEditingController _draft = TextEditingController();
  final List<({AstryxChatRole role, String text})> _turns =
      <({AstryxChatRole role, String text})>[
        (role: AstryxChatRole.user, text: 'Why did the 14:02 deploy fail?'),
        (
          role: AstryxChatRole.assistant,
          text:
              'The health check timed out. The scheduler took 41 seconds to '
              'bind its port, and the check gives up at 30.',
        ),
        (role: AstryxChatRole.user, text: 'Can we raise the timeout?'),
        (
          role: AstryxChatRole.assistant,
          text:
              'You can, but the bind is the real problem — it used to take '
              'four seconds. I would look at the migration that ships with '
              'this release first.',
        ),
      ];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    setState(() {
      _turns
        ..add((role: AstryxChatRole.user, text: text))
        ..add((
          role: AstryxChatRole.assistant,
          text: 'Noted. (This example does not actually answer.)',
        ));
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The layout owns the scrolling: it opens on the newest turn, stays put as
    // turns arrive, and offers a jump-to-latest button once you scroll back.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      // Bounded inside the card: a card lays its body out in a column, and a
      // column hands its child unbounded height — which the layout needs to
      // divide between the transcript and the composer.
      child: SizedBox(
        height: 420,
        child: AstryxChatLayout(
          messages: <Widget>[
            for (final turn in _turns)
              AstryxChatMessage(
                role: turn.role,
                author: turn.role == AstryxChatRole.user
                    ? 'You'
                    : 'Assistant',
                child: AstryxText(turn.text),
              ),
          ],
          composer: AstryxChatComposer(
            controller: _draft,
            onSubmit: _send,
          ),
        ),
      ),
    );
  }
}
// #end

// #example chat_layout_empty -> ChatLayoutEmptyExample
class ChatLayoutEmptyExample extends StatefulWidget {
  const ChatLayoutEmptyExample({super.key});

  @override
  State<ChatLayoutEmptyExample> createState() => _ChatLayoutEmptyExampleState();
}

class _ChatLayoutEmptyExampleState extends State<ChatLayoutEmptyExample> {
  final TextEditingController _draft = TextEditingController();

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // An empty conversation is the first thing most people see, so it is a slot
    // rather than a blank — and centred, which a reversed transcript could not
    // manage on its own.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      child: SizedBox(
        height: 380,
        child: AstryxChatLayout(
          messages: const <Widget>[],
          empty: AstryxEmptyState(
            title: 'Ask about a deploy',
            description:
                'Logs, timings and health checks for the last 30 days.',
            actions: <Widget>[
              AstryxButton(label: 'Why did 14:02 fail?', onPressed: () {}),
            ],
          ),
          composer: AstryxChatComposer(
            controller: _draft,
            onSubmit: (_) {},
          ),
        ),
      ),
    );
  }
}
// #end

// #example chat_message_roles -> ChatMessageRolesExample
class ChatMessageRolesExample extends StatelessWidget {
  const ChatMessageRolesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // A bubble for the user, plain page content for the answer, and a centred
    // notice for the system. The actions under the answer are always there:
    // hover-only controls are unreachable on a phone.
    return AstryxChatMessageList(
      children: <Widget>[
        AstryxChatMessage(
          role: AstryxChatRole.user,
          author: 'You',
          timestamp: AstryxTimestamp(
            now.subtract(const Duration(minutes: 4)),
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          child: const AstryxText('Why did the 14:02 deploy fail?'),
        ),
        AstryxChatMessage(
          author: 'Assistant',
          timestamp: AstryxTimestamp(
            now.subtract(const Duration(minutes: 3)),
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.copy,
              label: 'Copy the answer',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
            AstryxIconButton(
              icon: AstryxIconName.arrowsUpDown,
              label: 'Try again',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
          footer: const AstryxText(
            'Sources: deploy-log/14:02, scheduler/health',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          child: const AstryxText(
            'The health check timed out: the scheduler took 41 seconds to bind '
            'its port and the check gives up at 30.',
          ),
        ),
        const AstryxChatMessage(
          role: AstryxChatRole.system,
          child: AstryxText('The model changed to the long-context one'),
        ),
      ],
    );
  }
}
// #end

// #example chat_message_streaming -> ChatMessageStreamingExample
class ChatMessageStreamingExample extends StatefulWidget {
  const ChatMessageStreamingExample({super.key});

  @override
  State<ChatMessageStreamingExample> createState() =>
      _ChatMessageStreamingExampleState();
}

class _ChatMessageStreamingExampleState
    extends State<ChatMessageStreamingExample> {
  static const String _answer =
      'Three services restarted and the health check passed on the first '
      'attempt. Total time was 41 seconds, most of it waiting on the port '
      'bind.';

  String _shown = '';

  void _stream() => setState(() => _shown = _answer);

  @override
  Widget build(BuildContext context) {
    // A turn whose content is `AstryxStreamingText`: the transcript does not
    // move as it types, because the layout keeps the newest turn at offset 0.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxChatMessage(
          author: 'Assistant',
          child: _shown.isEmpty
              ? const AstryxSpinner(label: 'Thinking')
              : AstryxStreamingText(
                  _shown,
                  streaming: false,
                  charactersPerSecond: 45,
                ),
        ),
        AstryxButton(
          label: _shown.isEmpty ? 'Stream the answer' : 'Reset',
          onPressed: () => _shown.isEmpty
              ? _stream()
              : setState(() => _shown = ''),
        ),
      ],
    );
  }
}
// #end

// #example chat_composer_demo -> ChatComposerDemoExample
class ChatComposerDemoExample extends StatefulWidget {
  const ChatComposerDemoExample({super.key});

  @override
  State<ChatComposerDemoExample> createState() =>
      _ChatComposerDemoExampleState();
}

class _ChatComposerDemoExampleState extends State<ChatComposerDemoExample> {
  final TextEditingController _draft = TextEditingController();
  final List<String> _sent = <String>[];

  bool _generating = false;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    setState(() {
      _sent.insert(0, text);
      _draft.clear();
      _generating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Enter sends, Shift+Enter starts a line, and the send button is disabled
    // until there is something to send. While generating it becomes stop.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxChatComposer(
          controller: _draft,
          generating: _generating,
          onSubmit: _send,
          onStop: () => setState(() => _generating = false),
          leading: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.wrench,
              label: 'Tools',
              variant: AstryxButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
          trailing: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.microphone,
              label: 'Dictate',
              variant: AstryxButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
          footer: const AstryxText(
            'Enter sends · Shift+Enter starts a line',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ),
        if (_sent.isNotEmpty)
          AstryxText(
            'Sent: ${_sent.first}',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
      ],
    );
  }
}
// #end

// #example chat_composer_drawer -> ChatComposerDrawerExample
class ChatComposerDrawerExample extends StatefulWidget {
  const ChatComposerDrawerExample({super.key});

  @override
  State<ChatComposerDrawerExample> createState() =>
      _ChatComposerDrawerExampleState();
}

class _ChatComposerDrawerExampleState extends State<ChatComposerDrawerExample> {
  final TextEditingController _draft = TextEditingController();
  final List<String> _attached = <String>['deploy-log-14-02.txt'];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The drawer is part of the composer's surface rather than floating above
    // it, so what is about to be sent is unmistakable.
    return AstryxChatComposer(
      controller: _draft,
      onSubmit: (_) => setState(_draft.clear),
      drawer: _attached.isEmpty
          ? null
          : AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                for (final file in _attached)
                  AstryxBadge(file),
                AstryxButton(
                  label: 'Remove all',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () => setState(_attached.clear),
                ),
              ],
            ),
      leading: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Attach a file',
          variant: AstryxButtonVariant.ghost,
          onPressed: () => setState(() => _attached.add('metrics.csv')),
        ),
      ],
    );
  }
}
// #end

// #example token_demo -> TokenDemoExample
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
// #end

// #example tokenizer_demo -> TokenizerDemoExample
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
// #end

// #example chat_composer_token -> ChatComposerTokenExample
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
// #end

// #example chat_tokenized_text_demo -> ChatTokenizedTextDemoExample
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
// #end

// #example chat_dictation_states -> ChatDictationStatesExample
class ChatDictationStatesExample extends StatefulWidget {
  const ChatDictationStatesExample({super.key});

  @override
  State<ChatDictationStatesExample> createState() =>
      _ChatDictationStatesExampleState();
}

class _ChatDictationStatesExampleState
    extends State<ChatDictationStatesExample> {
  bool _listening = false;

  @override
  Widget build(BuildContext context) {
    // Idle, listening, and unavailable. Listening is a pressed button rather
    // than an animation, so the state survives reduced motion — and the
    // unavailable one says why instead of just going dim.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxChatDictationButton(
          listening: _listening,
          onStart: () => setState(() => _listening = true),
          onStop: () => setState(() => _listening = false),
        ),
        const AstryxChatDictationButton(
          enabled: false,
          unavailableReason: 'No microphone permission',
        ),
      ],
    );
  }
}
// #end

// #example chat_send_button_states -> ChatSendButtonStatesExample
class ChatSendButtonStatesExample extends StatefulWidget {
  const ChatSendButtonStatesExample({super.key});

  @override
  State<ChatSendButtonStatesExample> createState() =>
      _ChatSendButtonStatesExampleState();
}

class _ChatSendButtonStatesExampleState
    extends State<ChatSendButtonStatesExample> {
  bool _hasDraft = false;
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    // One control, two jobs — in the place the hand is already going. Two
    // buttons side by side, one always inert, is the arrangement this replaces.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxSwitch(
              label: 'Has a draft',
              value: _hasDraft,
              onChanged: (value) => setState(() => _hasDraft = value),
            ),
            AstryxSwitch(
              label: 'Generating',
              value: _generating,
              onChanged: (value) => setState(() => _generating = value),
            ),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxChatSendButton(
              canSend: _hasDraft,
              generating: _generating,
              onSend: () {},
              onStop: () {},
            ),
          ],
        ),
      ],
    );
  }
}
// #end

// #example chat_system_message_demo -> ChatSystemMessageDemoExample
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
// #end

// #example chat_tool_calls_demo -> ChatToolCallsDemoExample
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
// #end

// #example citation_demo -> CitationDemoExample
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
// #end

// #example markdown_demo -> MarkdownDemoExample
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
// #end
