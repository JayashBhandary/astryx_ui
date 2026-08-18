/// The assistant screen: a transcript, a composer, and the empty state that
/// comes before either of them exists — plus the *landing*, which is the
/// screen you get when that empty state is the whole product rather than a
/// slot inside it.
///
/// Neither is exported. Both are compositions worth copying, built from
/// nothing but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_ai_chat -> AiChatTemplate
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
    // Wrapping, so the title and the controls take a line each rather than
    // fighting over one. `Flexible` alone cannot save this row: the model
    // selector and the New chat button have a width they cannot go under, and
    // below about 500 logical pixels there is no share of the line that leaves
    // the heading anything to say.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            const Flexible(
              child: AstryxHeading('Why did 14:02 fail?', level: 1),
            ),
            AstryxBadge('$turns turns'),
          ],
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
// #end

// #example template_ai_chat_landing -> AiChatLandingTemplate
/// One offered prompt, and what it is for.
typedef Prompt = ({String group, String label, String text});

class AiChatLandingTemplate extends StatefulWidget {
  const AiChatLandingTemplate({super.key});

  @override
  State<AiChatLandingTemplate> createState() => _AiChatLandingTemplateState();
}

class _AiChatLandingTemplateState extends State<AiChatLandingTemplate> {
  static const List<Prompt> _prompts = <Prompt>[
    (
      group: 'Diagnose',
      label: 'Why did the last deploy fail?',
      text: 'Why did the 14:02 deploy fail?',
    ),
    (
      group: 'Diagnose',
      label: 'What changed before the latency spike?',
      text: 'What changed in the hour before the 13:40 latency spike?',
    ),
    (
      group: 'Summarise',
      label: 'Last night’s on-call',
      text: 'Summarise last night’s on-call in five bullets.',
    ),
    (
      group: 'Summarise',
      label: 'This week’s incidents',
      text: 'Summarise every incident opened this week, worst first.',
    ),
    (
      group: 'Write',
      label: 'Draft a post-mortem',
      text: 'Draft a post-mortem for INC-4102 from the timeline.',
    ),
  ];

  static const List<String> _recent = <String>[
    'Why did 14:02 fail?',
    'Scheduler bind times, last 30 days',
    'Who owns the artifacts service?',
  ];

  final TextEditingController _draft = TextEditingController();

  /// The one turn the conversation has, once it has one.
  String? _asked;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _asked = text.trim();
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560,
      child: _asked == null ? _landing(context) : _conversation(context),
    );
  }

  /// Before the first turn: the composer is the middle of the page.
  ///
  /// That is the whole difference between this and the `empty:` slot of
  /// [AiChatTemplate]. A slot sits above a composer pinned to the bottom; a
  /// landing puts the composer where the reader is already looking, because
  /// there is no transcript for it to be beneath.
  Widget _landing(BuildContext context) {
    final groups = <String>{for (final prompt in _prompts) prompt.group};

    return SingleChildScrollView(
      child: AstryxCenter(
        maxWidth: 680,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.center,
              children: <Widget>[
                AstryxHeading(
                  'What do you want to know?',
                  level: 1,
                  type: AstryxHeadingType.display3,
                  justify: AstryxTextJustify.center,
                ),
                AstryxText(
                  'Logs, timings and health checks for the last 30 days.',
                  type: AstryxTextType.large,
                  color: AstryxTextColor.secondary,
                  justify: AstryxTextJustify.center,
                ),
              ],
            ),
            // The same widget the conversation ends up using. A landing that
            // drew its own input would be a second field with its own
            // shortcuts, its own send button and its own bugs.
            AstryxChatComposer(
              controller: _draft,
              placeholder: 'Ask about a deploy, a service or an incident',
              label: 'Ask a question',
              onSubmit: _send,
              leading: <Widget>[
                AstryxIconButton(
                  icon: AstryxIconName.copy,
                  label: 'Attach a file',
                  variant: AstryxButtonVariant.ghost,
                  onPressed: () {},
                ),
              ],
              footer: const AstryxText(
                'Answers cite the logs they came from. Check anything you are '
                'about to act on.',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
            // Suggestions are grouped, and every one of them is a button that
            // sends itself. A prompt the reader has to retype is a prompt
            // nobody uses; a wall of twelve ungrouped ones is a menu nobody
            // reads.
            for (final group in groups)
              AstryxSection(
                title: group,
                level: 2,
                gap: AstryxSpacingToken.spacing2,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    for (final prompt in _prompts.where(
                      (prompt) => prompt.group == group,
                    ))
                      AstryxButton(
                        label: prompt.label,
                        size: AstryxButtonSize.sm,
                        onPressed: () => _send(prompt.text),
                      ),
                  ],
                ),
              ),
            const AstryxDivider(),
            AstryxSection(
              title: 'Recent',
              level: 2,
              gap: AstryxSpacingToken.spacing2,
              child: AstryxList(
                label: 'Recent conversations',
                density: AstryxItemDensity.compact,
                showDividers: true,
                children: <Widget>[
                  for (final thread in _recent)
                    AstryxItem(
                      label: thread,
                      leading: const AstryxIcon(AstryxIconName.clock),
                      trailing: const AstryxIcon(AstryxIconName.chevronRight),
                      onPressed: () => _send(thread),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// After the first turn: the same composer, now pinned under a transcript.
  Widget _conversation(BuildContext context) {
    return AstryxLayout(
      padding: AstryxSpacingToken.spacing0,
      scrollable: false,
      header: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Flexible(child: AstryxHeading('Atlas assistant', level: 1)),
          AstryxButton(
            label: 'New chat',
            size: AstryxButtonSize.sm,
            onPressed: () => setState(() => _asked = null),
          ),
        ],
      ),
      child: AstryxChatLayout(
        messages: <Widget>[
          AstryxChatMessage(
            role: AstryxChatRole.user,
            author: 'You',
            child: AstryxText(_asked!),
          ),
          const AstryxChatMessage(
            author: 'Assistant',
            child: AstryxText(
              'The landing has handed over. From here the screen is the '
              'ai_chat template — same composer, now at the bottom of a '
              'transcript that owns its own scrolling.',
            ),
          ),
        ],
        composer: AstryxChatComposer(
          controller: _draft,
          placeholder: 'Ask a follow-up',
          onSubmit: _send,
        ),
      ),
    );
  }
}
// #end
