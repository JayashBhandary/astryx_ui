---
title: AI chat landing
description: 'The pre-conversation screen: prompt suggestions and a centred composer.'
component: true
group: Templates
source: example/lib/examples/template_chat_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Press a suggestion, or type something: the composer moves from the middle of the page to the bottom of a transcript. **New chat** brings the landing back.


## Not the same as an empty state

The [AI chat](ai_chat.md) template has an `empty:` slot, and it is a slot *above a composer pinned to the bottom*. This screen is the other thing: there is no transcript for the composer to be beneath, so it goes where the reader is already looking — the middle of the page.

Which to build is a question about what the product is. If the conversation is a feature inside an application, the empty slot is right: the frame stays put and the transcript fills in. If the conversation *is* the application, the landing is right, and the handover to the transcript is a real change of screen.

> **Note**
>
> **It is the same [AstryxChatComposer](chat_composer.md) in both states.** A landing that drew its own input would be a second field with its own Enter handling, its own send button, its own disclaimer and its own bugs — and the reader would notice the swap at exactly the moment they pressed Enter.

## Suggestions are grouped, and each one sends itself

Twelve ungrouped prompts is a menu nobody reads. Three groups of two or three — **Diagnose**, **Summarise**, **Write** — is a statement about what the assistant is *for*, which is the actual question a first-time reader has.

Every suggestion is an [AstryxButton](button.md) that sends its own text. A prompt you have to retype is a prompt nobody uses, and placeholder text that vanishes the moment you type is not a suggestion at all.

```text
AstryxCenter(maxWidth: 680)          ← before the first turn
├── heading + one supporting line
├── AstryxChatComposer               ← in the middle of the page
├── AstryxSection per group          ← the prompt buttons
└── AstryxSection("Recent")          ← AstryxList of previous threads

AstryxLayout(scrollable: false)      ← after it
└── AstryxChatLayout(messages:, composer:)   ← the same composer, pinned
```

The **Recent** list is the other half of a landing: for anybody who has used the product before, going back to a thread is the more likely errand than starting a new one, and it should not require remembering what the thread was called.

> **Accessibility**
>
> The composer takes an explicit `label` — "Ask a question" — because its placeholder disappears the moment anything is typed. A field whose only name is its placeholder is a field with no name for exactly the reader who most needs one.

The disclaimer is in the composer’s `footer` on both screens. It is a standing fact about every answer, and the moment it matters is the moment somebody is about to ask — not a [banner](banner.md) at the top they scrolled past on the way here.

## Related

- [AI chat](ai_chat.md) — the conversation, with tool calls and citations.
- [AstryxChatComposer](chat_composer.md) — Enter, Shift+Enter, generating and stop.
- [AstryxChatLayout](chat_layout.md) — the transcript, and the `empty:` slot this screen is the alternative to.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

