# Chat & AI

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxChatLayout

`lib/src/components/chat/chat_layout.dart` · upstream `ChatLayout / ChatLayoutScrollButton`

The frame of a conversation: a scrolling transcript and a pinned composer.

```dart
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
```

**Rules**

- **Note:** The reversal is an implementation detail and does not reach the caller. One place it is visible: a `controller` you pass sees offset zero as the **newest** turn and the maximum extent as the oldest.
- **Accessibility:** Reversed in the widget tree, **oldest-first on screen** — so semantics traversal, which follows visual order, reads the conversation the way it happened. The transcript is a named container, and each turn keeps its own node inside it.

### AstryxChatLayout

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `messages` **(required)** | `List<Widget>` | — | The turns, oldest first. |
| `composer` **(required)** | `Widget` | — | Pinned below the transcript. |
| `header` | `Widget?` | — | Pinned above it — a title, a model picker, a banner. |
| `empty` | `Widget?` | — | Shown when there are no turns yet. |
| `controller` | `ScrollController?` | — | The transcript's controller. Offset zero is the newest turn. |
| `maxWidth` | `double` | `760` | The widest the transcript and composer grow — a measure, for the same reason prose has one. |
| `showScrollButton` | `bool` | `true` | Whether to offer the jump-to-latest button. |
| `scrollButtonThreshold` | `double` | `240` | How far from the newest turn the button appears. |

---

## AstryxChatMessage

`lib/src/components/chat/chat_message.dart` · upstream `ChatMessage / ChatMessageBubble / ChatMessageList / ChatMessageMetadata`

One turn in a conversation — the bubble, its metadata, and the list that holds them.

```dart
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
```

**Rules**

- **Careful:** Upstream reveals a turn's controls on hover. **This does not**, and cannot: touch has no hover, and the density system actively suppresses hover styling there. A retry button nobody can reach on a phone is not a retry button. Keep the set small if the row feels busy — do not hide it.
- **Accessibility:** **Every turn is announced with who said it.** Layout carries that for a sighted reader — a bubble on the right is obviously yours — and carries nothing at all for anybody else, so `author` is the turn's accessible name and the role supplies a fallback ("You", "Assistant") when there is none. The content keeps its own nodes: a transcript read as one long string with no turn boundaries is not a transcript.

| `AstryxChatRole` | Drawn as |
| --- | --- |
| `user` | A bubble, aligned to the reading end and capped at `maxWidth` — the shape that says "you wrote this" without a label. |
| `assistant` | **Not** a bubble. An answer is the content of the page: often long, often containing a code block or a table, and wrapping all of that in a rounded box makes it read as an aside. |
| `system` | Centred and quiet. "The model changed", "This conversation was resumed" — not a turn anybody took. |

### AstryxChatMessage

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The turn's content — text, a code block, a table, a card. |
| `role` | `AstryxChatRole` | `AstryxChatRole.assistant` | Who it came from. |
| `author` | `String?` | — | The name shown above the turn, and its accessible name. |
| `timestamp` | `Widget?` | — | Shown beside the author. |
| `leading` | `Widget?` | — | A widget before the turn — an avatar. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls for this turn. Always visible. |
| `footer` | `Widget?` | — | Below the turn and its actions — sources, a tool call, a warning. |
| `maxWidth` | `double?` | `480` | How wide a `user` bubble may get. An assistant turn is unconstrained. |

### AstryxChatMessageList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The turns, oldest first. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing6` | The space between turns. Generous, because the gap is what separates a question from its answer. |
| `label` | `String?` | — | Names the transcript. |

---

## AstryxChatComposer

`lib/src/components/chat/chat_composer.dart` · upstream `ChatComposer / ChatComposerDrawer / ChatComposerInput`

The input a message is written in, with its drawer.

```dart
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
```

**Rules**

- **Note:** Clearing it after a send is **yours**. A send that failed should not have thrown the text away — which is what an automatic clear does to somebody on a bad connection.
- **Careful:** **Inline tokens are not ported.** Upstream's `ChatComposerTokenElement` renders a mention as a chip *inside* the editable text, which needs a rich-text editing controller this package does not have — `EditableText` edits a `String`. A half-working version that lets a caret walk into the middle of a chip would be worse than the gap, so the field is plain text for now.
- **Accessibility:** The field is named without being labelled on screen: a visible label above a chat input is one nobody needs, and its absence would leave a screen reader with nothing. `label` overrides the name — "Message" by default — and the send control is named for what it will do *now*.

| Key | Does |
| --- | --- |
| `Enter` | Sends, if there is a non-empty draft. |
| `Shift` + `Enter` | Starts a line. |
| `Enter` while generating | Nothing. The reply in flight is the answer to the last one. |

### AstryxChatComposer

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `TextEditingController` | — | The draft being written. |
| `onSubmit` | `ValueChanged<String>?` | — | Called with the trimmed draft. Never with an empty one. |
| `onStop` | `VoidCallback?` | — | Called when the user asks to stop generating. |
| `generating` | `bool` | `false` | Whether a reply is in flight. Turns send into stop. |
| `placeholder` | `String?` | — | Shown while empty. Defaults to "Send a message…". |
| `label` | `String?` | — | The field's accessible name. Announced, not shown. |
| `leading` | `List<Widget>` | `const <Widget>[]` | Controls before the field — attach, a model picker, a tool menu. |
| `trailing` | `List<Widget>` | `const <Widget>[]` | Controls between the field and the send button. |
| `drawer` | `Widget?` | — | Content above the field, in the same surface. |
| `footer` | `Widget?` | — | Content below the composer — a hint, a count, a disclaimer. |
| `maxLines` | `int` | `8` | The most lines before the field scrolls instead of growing. |
| `submitOnEnter` | `bool` | `true` | Whether Enter sends. |

---

## AstryxTokenTextController

`lib/src/components/chat/token_text.dart` · upstream `ChatComposerTokenElement`

A mention styled inside the text being typed.

```dart
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
```

**Rules**

- **Careful:** Upstream puts a real element inside a `contenteditable`. Flutter’s `EditableText` edits a **`String`**, and a `WidgetSpan` in an editable’s span tree breaks the caret: arrow keys step over a chip as if it were one character, selection maths goes wrong, and backspace deletes something other than what is highlighted. So a token here is an accent colour on a tinted ground — it reads as a chip, and every character still counts as itself.
- **Note:** Matching is by literal run, longest first, so `@ada` and `@adam` can both be tokens without the shorter one eating the longer. Composing text is left alone: styling a half-typed IME candidate would fight the underline the platform draws under it.

### AstryxTokenTextController

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `tokens` | `Map<String, AstryxTextToken>` | — | The runs to style, keyed by the literal text they appear as. Settable: the field repaints when what the text *means* changes. |
| `present` | `List<String>` | — | The token runs in the current text, in order. |
| `text` | `String` | — | Inherited, and unchanged by any of this — which is the point. |

---

## AstryxChatSendButton

`lib/src/components/chat/chat_buttons.dart` · upstream `ChatSendButton`

The composer's submit control, reflecting sending and stop-generating.

```dart
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
```

**Rules**

- **Accessibility:** A screen reader announces the *name*, not the glyph, so the name is what has to change between the two states. The control is also always present rather than revealed: on a touch keyboard the return key inserts a newline and there is no Shift to hold, which makes the button the only way to send.

| State | Shows |
| --- | --- |
| `canSend: false` | A disabled send. An empty draft is not an error and not a disabled composer — it is a button with nothing to do yet. |
| `canSend: true` | A primary send. |
| `generating: true` | A stop control, named "Stop generating" — a separate string, because a button whose meaning changes needs a name that changes with it. |

### AstryxChatSendButton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `onSend` | `VoidCallback?` | — | Called to send. |
| `onStop` | `VoidCallback?` | — | Called to stop a reply in flight. |
| `canSend` | `bool` | `false` | Whether there is something to send. |
| `generating` | `bool` | `false` | Whether a reply is being generated. |
| `enabled` | `bool` | `true` | Whether the control responds at all. |

---

## AstryxChatDictationButton

`lib/src/components/chat/chat_buttons.dart` · upstream `ChatDictationButton`

The composer's speech-to-text control.

```dart
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
```

**Rules**

- **Careful:** **This package does no speech recognition.** There is no platform channel here and no dependency that would bring one. What it provides is the control and its states, so a caller wiring `speech_to_text` or a platform API has somewhere to put it that looks and behaves like the rest of the composer.
- **Accessibility:** Dictation is an *alternative* input, never the only one: a composer whose field is unusable without speech excludes anybody who cannot or will not talk to their computer. It sits beside the field, not instead of it.

### AstryxChatDictationButton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `onStart` | `VoidCallback?` | — | Called to begin listening. |
| `onStop` | `VoidCallback?` | — | Called to stop listening. |
| `listening` | `bool` | `false` | Whether it is listening now. |
| `enabled` | `bool` | `true` | Whether dictation is available at all. |
| `unavailableReason` | `String?` | — | Why it is unavailable, shown as the tooltip. |

---

## AstryxChatSystemMessage

`lib/src/components/chat/chat_system_message.dart` · upstream `ChatSystemMessage`

A turn that came from the system rather than either participant.

```dart
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
```

**Rules**

- **Note:** `action` is **one** slot, not a list. A notice with three buttons in it has stopped being a notice and become a form — and a form in the middle of a transcript is a thing readers scroll past.
- **Accessibility:** Announced as a **system message**, not as somebody’s turn. A reader walking a transcript needs to know that this line is not part of the conversation, and neither its position nor its colour conveys that.

### AstryxChatSystemMessage

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `message` **(required)** | `String` | — | What happened. |
| `icon` | `AstryxIconName?` | — | A glyph before the text. |
| `action` | `Widget?` | — | One control — "Undo", "Why?". |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |

---

## AstryxChatTokenizedText

`lib/src/components/chat/token_text.dart` · upstream `ChatTokenizedText`

Message text with mentions and references rendered as tokens.

```dart
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
```

**Rules**

- **Accessibility:** **The plain sentence is what is announced.** "Ask at-ada about deploy-log.txt" is the message; a chip announced as a separate control mid-sentence is a sentence nobody can follow. The chips are excluded from semantics and the container carries the text.

### AstryxChatTokenizedText

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `text` **(required)** | `String` | — | The whole message. |
| `tokens` **(required)** | `Map<String, AstryxTextToken>` | — | The runs to draw as chips, keyed by the literal text they appear as. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to `text`. |

### AstryxTextToken

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `icon` | `AstryxIconName?` | — | A glyph on the chip. |
| `onPressed` | `VoidCallback?` | — | Called when it is pressed. |
| `value` | `Object?` | — | What the entity *is*, for the caller’s own use. |
| `tooltip` | `String?` | — | A phrase describing the entity, if the label alone is cryptic. |

---

## AstryxChatToolCalls

`lib/src/components/chat/tool_calls.dart` · upstream `ChatToolCalls`

The tool calls a model made, and their results, inside a turn.

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

**Rules**

- **Accessibility:** **Every status is paired with its word**, on the row and in the disclosure’s own content. Colour is never the only signal, and a dot is too small to carry a shape as well — so "Failed" is written next to the red one.
- **Careful:** `initiallyExpanded` is false, and should usually stay false. A turn that unfolds four screens of JSON on arrival has buried the answer the reader was waiting for.

| `AstryxToolCallStatus` | Drawn as |
| --- | --- |
| `pending` | A neutral dot — queued, not started. |
| `running` | A spinner, labelled. Not a bare spinner: a wait with no words is a wait nobody can name. |
| `succeeded` | A success dot, and "Finished". |
| `failed` | An error dot, and "Failed". |

### AstryxChatToolCalls

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `calls` **(required)** | `List<AstryxToolCall>` | — | The calls, in the order they were made. |
| `label` | `String?` | — | Names the run. Defaults to "Tool calls". |
| `initiallyExpanded` | `bool` | `false` | Whether every call starts open. |

### AstryxToolCall

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `name` **(required)** | `String` | — | The tool’s name. |
| `status` | `AstryxToolCallStatus` | `AstryxToolCallStatus.succeeded` | How far along it is. |
| `summary` | `String?` | — | A one-line description, for the collapsed row. |
| `arguments` | `String?` | — | What it was called with, formatted. |
| `result` | `String?` | — | What it returned, formatted. |
| `language` | `String` | `'json'` | The language of the two code blocks. |

---

## AstryxCitation

`lib/src/components/chat/citation.dart` · upstream `Citation`

A numbered reference from generated text back to its source.

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

**Rules**

- **Accessibility:** **"1" is not a destination.** The visible marker is a number because a number is all that fits, but the accessible name is "Source 1: scheduler/health.md" — a screen-reader user offered a row of bare numerals has been given a puzzle instead of a bibliography. The source is in the name whether or not it is in the tooltip, so it is never pointer-only.

### AstryxCitation

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `number` **(required)** | `int` | — | Which reference this is, as the reader counts them. One-based. |
| `source` | `String?` | — | What it points at. Shown on hover and focus, and always part of the accessible name. |
| `onPressed` | `VoidCallback?` | — | Called when it is pressed. |
| `AstryxCitation.span(…)` | `static` | — | The same marker as an `InlineSpan`, aligned to sit with the text. |

---

## AstryxMarkdown

`lib/src/components/chat/markdown.dart` · upstream `Markdown`

Rendered markdown, for model output and authored prose alike.

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

**Rules**

- **Careful:** **Tables, images, footnotes, nested lists, task lists, inline HTML — and text selection across blocks.** They are absent rather than half-drawn: a table rendered as run-together text is worse than a table nobody rendered, because the reader cannot tell it *was* a table. Unsupported input degrades to paragraphs and never throws, which is what matters for arbitrary model output.
- **Accessibility:** Heading levels come straight from the `#` count, so the outline a reader navigates by is the one the author wrote. `AstryxHeading` derives its size from that level rather than the other way round, which is why there is nothing here to get wrong.

| Markdown | Drawn as |
| --- | --- |
| `#` … `######` | `AstryxHeading`, at the matching level |
| Paragraphs | `AstryxText` |
| `- `, `* `, `1. ` | A bullet or number and its text |
| Fenced blocks | `AstryxCodeBlock`, language and all |
| `> ` | `AstryxBlockquote` |
| `---` | `AstryxDivider` |
| `**bold**`, `*italic*`, `` `code` ``, `text (url)` | Inline spans — the last one an `AstryxLink` |

### AstryxMarkdown

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `source` **(required)** | `String` | — | The markdown. |
| `onLinkPressed` | `ValueChanged<String>?` | — | Called with the target of a link that was followed. Null draws links as text. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The space between blocks. |

---

## AstryxTokenChip

`lib/src/components/chat/token.dart` · upstream `Token`

One inline chip standing for an entity inside a text field.

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

**Rules**

- **Note:** Upstream calls it `Token`; here it is `AstryxTokenChip`, because `AstryxToken` is already the **design token** interface every token enum implements. A design system cannot have two things called Token, and the older one is load-bearing in every theme.
- **Accessibility:** The remove button is named after **what it removes** — "Remove deploy-log.txt", not "Remove". A row of five buttons with identical names is a row a screen-reader user cannot choose from. A pressable token keeps its remove button as a node of its own, which is the one case where nesting controls is right: they do different things, and a reader has to be able to pick.

### AstryxTokenChip

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The entity’s name. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `onRemove` | `VoidCallback?` | — | Called when the remove button is pressed. Null omits the button. |
| `onPressed` | `VoidCallback?` | — | Called when the token itself is pressed. |
| `enabled` | `bool` | `true` | Whether the token responds. |

---

## AstryxTokenizer

`lib/src/components/chat/token.dart` · upstream `Tokenizer`

The field that turns typed text into tokens.

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

**Rules**

- **Accessibility:** The field announces **how many values it holds** as its value, so a reader tabbing onto it is told what is already there rather than having to walk the tokens. Each token keeps its own node, and each remove button is named after its token.

| Key | Does |
| --- | --- |
| `Enter` | Commits the draft as a token. |
| A delimiter — `,` by default | Commits everything before it, so pasting "a@x.com, b@x.com" lands as two tokens rather than one long string. |
| `Backspace` on an empty draft | Takes the last token back — the only way to undo one without reaching for the pointer. |

### AstryxTokenizer

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `values` **(required)** | `List<String>` | — | The committed values, in the order they were added. |
| `onChanged` | `ValueChanged<List<String>>?` | — | Called with the new set whenever one is added or removed. |
| `label` | `String?` | — | The field’s label and accessible name. |
| `validate` | `bool Function(String)?` | — | Whether a candidate may be committed. |
| `allowDuplicates` | `bool` | `false` | Whether the same value may appear twice. |
| `delimiters` | `List<String>` | `const <String>[',']` | Characters that commit the current text. |
| `icon` | `AstryxIconName?` | — | A glyph on every token. |

---

