import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Chat & AI — the frame of a conversation, its turns, and the composer.
///
/// Thirteen pages over eighteen upstream components. What each page cannot do
/// is on the page: two of these — the composer's inline tokens and the markdown
/// renderer — are deliberate subsets, and saying so is the point.
final List<DocPage> chatPages = <DocPage>[
  _chatLayout,
  _chatMessage,
  _chatComposer,
  _chatComposerToken,
  _chatSendButton,
  _chatDictationButton,
  _chatSystemMessage,
  _chatTokenizedText,
  _chatToolCalls,
  _citation,
  _markdown,
  _token,
  _tokenizer,
];

const String _group = DocGroup.chat;

const DocPage _chatLayout = DocPage(
  id: 'chat_layout',
  title: 'AstryxChatLayout',
  group: _group,
  description:
      'The frame of a conversation: a scrolling transcript and a pinned '
      'composer.',
  source: 'lib/src/components/chat/chat_layout.dart',
  upstream: 'ChatLayout / ChatLayoutScrollButton',
  upstreamPath: '/components/ChatLayout',
  blocks: <DocBlock>[
    DocExample('chat_layout_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxChatLayout(
  messages: <Widget>[
    for (final turn in conversation) AstryxChatMessage(…),
  ],
  composer: AstryxChatComposer(controller: _draft, onSubmit: _send),
)'''),
    DocProse(
      'The turns go in **oldest first**, as they read. The layout owns the '
      'scrolling, which is the part that is easy to get wrong in three '
      'separate ways.',
    ),
    DocHeading('It does not jump'),
    DocProse(
      'The transcript is built **reversed**: the newest turn sits at offset '
      'zero. Growing content therefore cannot move what is on screen — no '
      'scroll correction, no post-frame `jumpTo`, none of the jitter those '
      'produce. It opens on the newest turn for the same reason, without '
      'animating there first.',
    ),
    DocProse(
      'That also means it **stays put when the reader has scrolled up**. A '
      'transcript that yanks itself back to the bottom as an answer streams in '
      'is one nobody can re-read a paragraph of.',
    ),
    DocCallout.note(
      'The reversal is an implementation detail and does not reach the caller. '
      'One place it is visible: a `controller` you pass sees offset zero as '
      'the **newest** turn and the maximum extent as the oldest.',
    ),
    DocHeading('Jump to latest'),
    DocProse(
      'Once the reader is more than `scrollButtonThreshold` from the newest '
      'turn, a button appears to take them back. A conversation that moved on '
      'while you were reading is otherwise something you have to scroll to '
      'discover — and the button is present or absent rather than faded, '
      'because a control that is half-there is one a user cannot decide about.',
    ),
    DocHeading('The empty state'),
    DocProse(
      'A conversation with nothing in it is the *first* thing most people '
      'using one see, so `empty` is a slot rather than a blank: a heading, a '
      'line of guidance, a few suggested prompts. With no turns the scroller '
      'is not built at all — a centred welcome inside a reversed list would '
      'sit at the bottom.',
    ),
    DocExample('chat_layout_empty', align: DocExampleAlign.stretch),
    DocCallout.accessibility(
      'Reversed in the widget tree, **oldest-first on screen** — so semantics '
      'traversal, which follows visual order, reads the conversation the way '
      'it happened. The transcript is a named container, and each turn keeps '
      'its own node inside it.',
    ),
    DocApi('AstryxChatLayout', <DocProp>[
      DocProp(
        'messages',
        'List<Widget>',
        'The turns, oldest first.',
        required: true,
      ),
      DocProp(
        'composer',
        'Widget',
        'Pinned below the transcript.',
        required: true,
      ),
      DocProp(
        'header',
        'Widget?',
        'Pinned above it — a title, a model picker, a banner.',
      ),
      DocProp('empty', 'Widget?', 'Shown when there are no turns yet.'),
      DocProp(
        'controller',
        'ScrollController?',
        "The transcript's controller. Offset zero is the newest turn.",
      ),
      DocProp(
        'maxWidth',
        'double',
        'The widest the transcript and composer grow — a measure, for the same '
            'reason prose has one.',
        defaultValue: '760',
      ),
      DocProp(
        'showScrollButton',
        'bool',
        'Whether to offer the jump-to-latest button.',
        defaultValue: 'true',
      ),
      DocProp(
        'scrollButtonThreshold',
        'double',
        'How far from the newest turn the button appears.',
        defaultValue: '240',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatMessage](chat_message) — the turns that go in it.',
      '[AstryxChatComposer](chat_composer) — the input at the foot.',
      '[AstryxLayout](layout) — the frame for a page that is not a '
          'conversation.',
    ]),
  ],
);

const DocPage _chatMessage = DocPage(
  id: 'chat_message',
  title: 'AstryxChatMessage',
  group: _group,
  description:
      'One turn in a conversation — the bubble, its metadata, and the list '
      'that holds them.',
  source: 'lib/src/components/chat/chat_message.dart',
  upstream:
      'ChatMessage / ChatMessageBubble / ChatMessageList / '
      'ChatMessageMetadata',
  upstreamPath: '/components/ChatMessage',
  blocks: <DocBlock>[
    DocExample('chat_message_roles', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxChatMessage(
  role: AstryxChatRole.assistant,
  author: 'Assistant',
  timestamp: AstryxTimestamp(reply.at),
  actions: <Widget>[copyButton, retryButton],
  child: AstryxText(reply.text),
)'''),
    DocProse(
      "Upstream's `ChatMessage`, `ChatMessageBubble` and "
      '`ChatMessageMetadata` are one widget here, because the three are never '
      'useful apart: a bubble with no metadata has nothing to say about who '
      'wrote it, and metadata with no bubble has nothing to attach to.',
    ),
    DocHeading('Only one role gets a bubble'),
    DocTable(
      headers: <String>['`AstryxChatRole`', 'Drawn as'],
      rows: <List<String>>[
        <String>[
          '`user`',
          'A bubble, aligned to the reading end and capped at `maxWidth` — the '
              'shape that says "you wrote this" without a label.',
        ],
        <String>[
          '`assistant`',
          '**Not** a bubble. An answer is the content of the page: often long, '
              'often containing a code block or a table, and wrapping all of '
              'that in a rounded box makes it read as an aside.',
        ],
        <String>[
          '`system`',
          'Centred and quiet. "The model changed", "This conversation was '
              'resumed" — not a turn anybody took.',
        ],
      ],
    ),
    DocHeading('The actions are always visible'),
    DocCallout.warning(
      "Upstream reveals a turn's controls on hover. **This does not**, and "
      'cannot: touch has no hover, and the density system actively suppresses '
      'hover styling there. A retry button nobody can reach on a phone is not '
      'a retry button. Keep the set small if the row feels busy — do not hide '
      'it.',
    ),
    DocHeading('A turn still arriving'),
    DocProse(
      'Put [AstryxStreamingText](use_streaming_text) in the `child` for an '
      'answer that is streaming, and a [spinner](spinner) for the wait before '
      'the first token. Neither moves the transcript, because the layout keeps '
      'the newest turn at offset zero.',
    ),
    DocExample('chat_message_streaming', align: DocExampleAlign.stretch),
    DocCallout.accessibility(
      '**Every turn is announced with who said it.** Layout carries that for a '
      'sighted reader — a bubble on the right is obviously yours — and carries '
      "nothing at all for anybody else, so `author` is the turn's accessible "
      'name and the role supplies a fallback ("You", "Assistant") when there '
      'is none. The content keeps its own nodes: a transcript read as one long '
      'string with no turn boundaries is not a transcript.',
    ),
    DocApi('AstryxChatMessage', <DocProp>[
      DocProp(
        'child',
        'Widget',
        "The turn's content — text, a code block, a table, a card.",
        required: true,
      ),
      DocProp(
        'role',
        'AstryxChatRole',
        'Who it came from.',
        defaultValue: 'AstryxChatRole.assistant',
      ),
      DocProp(
        'author',
        'String?',
        'The name shown above the turn, and its accessible name.',
      ),
      DocProp('timestamp', 'Widget?', 'Shown beside the author.'),
      DocProp('leading', 'Widget?', 'A widget before the turn — an avatar.'),
      DocProp(
        'actions',
        'List<Widget>',
        'Controls for this turn. Always visible.',
        defaultValue: 'const <Widget>[]',
      ),
      DocProp(
        'footer',
        'Widget?',
        'Below the turn and its actions — sources, a tool call, a warning.',
      ),
      DocProp(
        'maxWidth',
        'double?',
        'How wide a `user` bubble may get. An assistant turn is '
            'unconstrained.',
        defaultValue: '480',
      ),
    ]),
    DocApi(
      'AstryxChatMessageList',
      <DocProp>[
        DocProp(
          'children',
          'List<Widget>',
          'The turns, oldest first.',
          required: true,
        ),
        DocProp(
          'gap',
          'AstryxSpacingToken',
          'The space between turns. Generous, because the gap is what '
              'separates a question from its answer.',
          defaultValue: 'AstryxSpacingToken.spacing6',
        ),
        DocProp('label', 'String?', 'Names the transcript.'),
      ],
      description:
          "Upstream's `ChatMessageList`. **Not a scroller** — "
          '`AstryxChatLayout` owns that, and a list scrolling inside a '
          'scroller is the nested-viewport bug every chat UI ships once.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatLayout](chat_layout) — the frame that scrolls these.',
      '[AstryxStreamingText](use_streaming_text) — an answer as it arrives.',
      '[AstryxCodeBlock](code_block) — what an answer full of code goes in.',
    ]),
  ],
);

const DocPage _chatComposer = DocPage(
  id: 'chat_composer',
  title: 'AstryxChatComposer',
  group: _group,
  description: 'The input a message is written in, with its drawer.',
  source: 'lib/src/components/chat/chat_composer.dart',
  upstream: 'ChatComposer / ChatComposerDrawer / ChatComposerInput',
  upstreamPath: '/components/ChatComposer',
  blocks: <DocBlock>[
    DocExample('chat_composer_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxChatComposer(
  controller: _draft,
  generating: _isGenerating,
  onSubmit: _send,
  onStop: _stop,
)'''),
    DocProse(
      "The `controller` is required, unlike most fields here: a composer's "
      'text is read by the send button, cleared on submit and often restored '
      'from a draft, so an internal controller nobody could reach would be '
      'useless.',
    ),
    DocCallout.note(
      'Clearing it after a send is **yours**. A send that failed should not '
      'have thrown the text away — which is what an automatic clear does to '
      'somebody on a bad connection.',
    ),
    DocHeading('Enter sends'),
    DocProse(
      '**Enter sends; Shift+Enter starts a line.** That is the convention '
      'every chat interface has settled on, and getting it backwards is the '
      'fastest way to make a composer feel wrong. `submitOnEnter: false` swaps '
      'it for a composer whose messages are routinely several paragraphs.',
    ),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Enter`', 'Sends, if there is a non-empty draft.'],
        <String>['`Shift` + `Enter`', 'Starts a line.'],
        <String>[
          '`Enter` while generating',
          'Nothing. The reply in flight is the answer to the last one.',
        ],
      ],
    ),
    DocProse(
      'An empty or whitespace-only draft is never sent, by key or by button, '
      'so a stray Enter cannot post nothing. An Enter that could not send is '
      'still *claimed* — it must not silently insert a line instead.',
    ),
    DocHeading('Send, and stop'),
    DocProse(
      'One control, two jobs: it sends while there is a draft, and becomes '
      '**stop generating** while `generating`. Two separate strings name it, '
      'because a button whose meaning changes needs a name that changes with '
      'it. Without an `onStop` it is disabled rather than dishonest.',
    ),
    DocProse(
      'The button is always present, never revealed. On a touch keyboard the '
      'return key inserts a newline and there is no Shift to hold, so the '
      'button is the *only* way to send there.',
    ),
    DocHeading('The drawer'),
    DocProse(
      "Upstream's `ChatComposerDrawer`: the attachments, the referenced "
      "files, the selected context. It sits inside the composer's own surface "
      'rather than floating above it, so what is about to be sent is '
      'unmistakable.',
    ),
    DocExample('chat_composer_drawer', align: DocExampleAlign.stretch),
    DocCallout.warning(
      "**Inline tokens are not ported.** Upstream's "
      '`ChatComposerTokenElement` renders a mention as a chip *inside* the '
      'editable text, which needs a rich-text editing controller this package '
      'does not have — `EditableText` edits a `String`. A half-working version '
      'that lets a caret walk into the middle of a chip would be worse than '
      'the gap, so the field is plain text for now.',
    ),
    DocCallout.accessibility(
      'The field is named without being labelled on screen: a visible label '
      'above a chat input is one nobody needs, and its absence would leave a '
      'screen reader with nothing. `label` overrides the name — "Message" by '
      'default — and the send control is named for what it will do *now*.',
    ),
    DocApi('AstryxChatComposer', <DocProp>[
      DocProp(
        'controller',
        'TextEditingController',
        'The draft being written.',
        required: true,
      ),
      DocProp(
        'onSubmit',
        'ValueChanged<String>?',
        'Called with the trimmed draft. Never with an empty one.',
      ),
      DocProp(
        'onStop',
        'VoidCallback?',
        'Called when the user asks to stop generating.',
      ),
      DocProp(
        'generating',
        'bool',
        'Whether a reply is in flight. Turns send into stop.',
        defaultValue: 'false',
      ),
      DocProp(
        'placeholder',
        'String?',
        'Shown while empty. Defaults to "Send a message…".',
      ),
      DocProp(
        'label',
        'String?',
        "The field's accessible name. Announced, not shown.",
      ),
      DocProp(
        'leading',
        'List<Widget>',
        'Controls before the field — attach, a model picker, a tool menu.',
        defaultValue: 'const <Widget>[]',
      ),
      DocProp(
        'trailing',
        'List<Widget>',
        'Controls between the field and the send button.',
        defaultValue: 'const <Widget>[]',
      ),
      DocProp(
        'drawer',
        'Widget?',
        'Content above the field, in the same '
            'surface.',
      ),
      DocProp(
        'footer',
        'Widget?',
        'Content below the composer — a hint, a '
            'count, a disclaimer.',
      ),
      DocProp(
        'maxLines',
        'int',
        'The most lines before the field scrolls instead of growing.',
        defaultValue: '8',
      ),
      DocProp(
        'submitOnEnter',
        'bool',
        'Whether Enter sends.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatLayout](chat_layout) — where a composer is pinned.',
      '[AstryxTextArea](text_area) — the growing field underneath it.',
      '[AstryxFileInput](file_input) — for attachments outside a '
          'conversation.',
    ]),
  ],
);

const DocPage _chatComposerToken = DocPage(
  id: 'chat_composer_token',
  title: 'AstryxTokenTextController',
  group: _group,
  description: 'A mention styled inside the text being typed.',
  source: 'lib/src/components/chat/token_text.dart',
  upstream: 'ChatComposerTokenElement',
  upstreamPath: '/components/ChatComposerTokenElement',
  blocks: <DocBlock>[
    DocExample('chat_composer_token', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
final controller = AstryxTokenTextController(
  tokens: <String, AstryxTextToken>{'@ada': const AstryxTextToken()},
);

AstryxChatComposer(controller: controller, onSubmit: _send)'''),
    DocProse(
      'A `TextEditingController` that styles the token runs inside what is '
      'being typed. Hand it to any Astryx text field — the composer is only '
      'the obvious one.',
    ),
    DocHeading('Styled text, not a widget'),
    DocCallout.warning(
      'Upstream puts a real element inside a `contenteditable`. Flutter’s '
      '`EditableText` edits a **`String`**, and a `WidgetSpan` in an '
      'editable’s span tree breaks the caret: arrow keys step over a chip as '
      'if it were one character, selection maths goes wrong, and backspace '
      'deletes something other than what is highlighted. So a token here is an '
      'accent colour on a tinted ground — it reads as a chip, and every '
      'character still counts as itself.',
    ),
    DocProse(
      'That is the whole difference, and it is confined to the composer. Once '
      'a message is sent there is no caret to protect, so '
      '[AstryxChatTokenizedText](chat_tokenized_text) draws real, pressable '
      'chips.',
    ),
    DocHeading('What is in the draft'),
    DocProse(
      '`present` lists the token runs in the current text, in order — what a '
      'caller sends alongside the message when the server needs the ids of '
      'everybody mentioned. It is derived from the text, so deleting a mention '
      'removes it with no bookkeeping.',
    ),
    DocApi('AstryxTokenTextController', <DocProp>[
      DocProp(
        'tokens',
        'Map<String, AstryxTextToken>',
        'The runs to style, keyed by the literal text they appear as. '
            'Settable: the field repaints when what the text *means* changes.',
      ),
      DocProp(
        'present',
        'List<String>',
        'The token runs in the current text, in order.',
      ),
      DocProp(
        'text',
        'String',
        'Inherited, and unchanged by any of this — which is the point.',
      ),
    ]),
    DocCallout.note(
      'Matching is by literal run, longest first, so `@ada` and `@adam` can '
      'both be tokens without the shorter one eating the longer. Composing '
      'text is left alone: styling a half-typed IME candidate would fight the '
      'underline the platform draws under it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatTokenizedText](chat_tokenized_text) — the same tokens as '
          'real chips, after sending.',
      '[AstryxTokenChip](token) — the chip itself.',
      '[AstryxChatComposer](chat_composer) — where this controller usually '
          'goes.',
    ]),
  ],
);

const DocPage _chatSendButton = DocPage(
  id: 'chat_send_button',
  title: 'AstryxChatSendButton',
  group: _group,
  description:
      "The composer's submit control, reflecting sending and stop-generating.",
  source: 'lib/src/components/chat/chat_buttons.dart',
  upstream: 'ChatSendButton',
  upstreamPath: '/components/ChatSendButton',
  blocks: <DocBlock>[
    DocExample('chat_send_button_states', align: DocExampleAlign.stretch),
    DocHeading('One control, two jobs'),
    DocProse(
      'The thing you press to start a reply is the thing you press to stop it, '
      'in the place your hand is already going. Two buttons side by side, one '
      'of them always inert, is the arrangement this replaces.',
    ),
    DocTable(
      headers: <String>['State', 'Shows'],
      rows: <List<String>>[
        <String>[
          '`canSend: false`',
          'A disabled send. An empty draft is not an error and not a disabled '
              'composer — it is a button with nothing to do yet.',
        ],
        <String>['`canSend: true`', 'A primary send.'],
        <String>[
          '`generating: true`',
          'A stop control, named "Stop generating" — a separate string, '
              'because a button whose meaning changes needs a name that '
              'changes with it.',
        ],
      ],
    ),
    DocProse(
      '`AstryxChatComposer` builds one of these itself, so most callers never '
      'name it. Reach for it directly when assembling a composer of your own — '
      'and note that it is deliberately not a private class, because two '
      'implementations of send-becomes-stop would eventually disagree.',
    ),
    DocCallout.accessibility(
      'A screen reader announces the *name*, not the glyph, so the name is '
      'what has to change between the two states. The control is also always '
      'present rather than revealed: on a touch keyboard the return key '
      'inserts a newline and there is no Shift to hold, which makes the button '
      'the only way to send.',
    ),
    DocApi('AstryxChatSendButton', <DocProp>[
      DocProp('onSend', 'VoidCallback?', 'Called to send.'),
      DocProp('onStop', 'VoidCallback?', 'Called to stop a reply in flight.'),
      DocProp(
        'canSend',
        'bool',
        'Whether there is something to send.',
        defaultValue: 'false',
      ),
      DocProp(
        'generating',
        'bool',
        'Whether a reply is being generated.',
        defaultValue: 'false',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the control responds at all.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatComposer](chat_composer) — where it sits, and the Enter key.',
      '[AstryxChatDictationButton](chat_dictation_button) — the other control '
          'beside the field.',
    ]),
  ],
);

const DocPage _chatDictationButton = DocPage(
  id: 'chat_dictation_button',
  title: 'AstryxChatDictationButton',
  group: _group,
  description: "The composer's speech-to-text control.",
  source: 'lib/src/components/chat/chat_buttons.dart',
  upstream: 'ChatDictationButton',
  upstreamPath: '/components/ChatDictationButton',
  blocks: <DocBlock>[
    DocExample('chat_dictation_states', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxChatDictationButton(
  listening: _listening,
  onStart: _startDictation,
  onStop: _stopDictation,
)'''),
    DocCallout.warning(
      '**This package does no speech recognition.** There is no platform '
      'channel here and no dependency that would bring one. What it provides '
      'is the control and its states, so a caller wiring `speech_to_text` or a '
      'platform API has somewhere to put it that looks and behaves like the '
      'rest of the composer.',
    ),
    DocProse(
      'The name follows the state — "Dictate", then "Stop dictating" — for the '
      'same reason the send control’s does. Listening is drawn as a pressed '
      'button rather than an animation, so the state survives reduced motion.',
    ),
    DocProse(
      '`unavailableReason` is the tooltip on a disabled control. A control '
      'that is dim for no stated reason is one a user assumes is broken; "No '
      'microphone permission" is a sentence they can act on.',
    ),
    DocApi('AstryxChatDictationButton', <DocProp>[
      DocProp('onStart', 'VoidCallback?', 'Called to begin listening.'),
      DocProp('onStop', 'VoidCallback?', 'Called to stop listening.'),
      DocProp(
        'listening',
        'bool',
        'Whether it is listening now.',
        defaultValue: 'false',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether dictation is available at all.',
        defaultValue: 'true',
      ),
      DocProp(
        'unavailableReason',
        'String?',
        'Why it is unavailable, shown as the tooltip.',
      ),
    ]),
    DocCallout.accessibility(
      'Dictation is an *alternative* input, never the only one: a composer '
      'whose field is unusable without speech excludes anybody who cannot or '
      'will not talk to their computer. It sits beside the field, not instead '
      'of it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatSendButton](chat_send_button) — the control it sits beside.',
      '[AstryxChatComposer](chat_composer) — the `trailing` slot it goes in.',
    ]),
  ],
);

const DocPage _chatSystemMessage = DocPage(
  id: 'chat_system_message',
  title: 'AstryxChatSystemMessage',
  group: _group,
  description:
      'A turn that came from the system rather than either participant.',
  source: 'lib/src/components/chat/chat_system_message.dart',
  upstream: 'ChatSystemMessage',
  upstreamPath: '/components/ChatSystemMessage',
  blocks: <DocBlock>[
    DocExample('chat_system_message_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode(
      "const AstryxChatSystemMessage('The model changed to the "
      "long-context one')",
    ),
    DocProse(
      'Things that happened *to* the conversation rather than in it: the model '
      'changed, the context was trimmed, the conversation was resumed. '
      'Centred, quiet, never in a bubble — because it is not a turn anybody '
      'took.',
    ),
    DocProse(
      'It is [AstryxChatMessage](chat_message) with '
      '`AstryxChatRole.system` and a shorter way to say so. Use the role '
      'directly when the content is not a line of text; use this when it is.',
    ),
    DocCallout.note(
      '`action` is **one** slot, not a list. A notice with three buttons in it '
      'has stopped being a notice and become a form — and a form in the middle '
      'of a transcript is a thing readers scroll past.',
    ),
    DocApi('AstryxChatSystemMessage', <DocProp>[
      DocProp('message', 'String', 'What happened.', required: true),
      DocProp('icon', 'AstryxIconName?', 'A glyph before the text.'),
      DocProp('action', 'Widget?', 'One control — "Undo", "Why?".'),
      DocProp(
        'semanticsLabel',
        'String?',
        'Overrides what a screen reader announces.',
      ),
    ]),
    DocCallout.accessibility(
      'Announced as a **system message**, not as somebody’s turn. A reader '
      'walking a transcript needs to know that this line is not part of the '
      'conversation, and neither its position nor its colour conveys that.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatMessage](chat_message) — the three roles, and what each is '
          'drawn as.',
      '[AstryxBanner](banner) — for a message about the *page* rather than the '
          'conversation.',
    ]),
  ],
);

const DocPage _chatTokenizedText = DocPage(
  id: 'chat_tokenized_text',
  title: 'AstryxChatTokenizedText',
  group: _group,
  description: 'Message text with mentions and references rendered as tokens.',
  source: 'lib/src/components/chat/token_text.dart',
  upstream: 'ChatTokenizedText',
  upstreamPath: '/components/ChatTokenizedText',
  blocks: <DocBlock>[
    DocExample('chat_tokenized_text_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxChatTokenizedText(
  'Ask @ada about deploy-log.txt',
  tokens: <String, AstryxTextToken>{
    '@ada': AstryxTextToken(value: ada.id, onPressed: _openProfile),
    'deploy-log.txt': AstryxTextToken(icon: AstryxIconName.copy),
  },
)'''),
    DocProse(
      'Read-only, which is what makes it straightforward: the chips are '
      '`WidgetSpan`s inside a `Text.rich`, and there is no caret to walk into '
      'the middle of one. That is the difference from '
      '[the composer’s controller](chat_composer_token), which cannot use '
      'widgets at all.',
    ),
    DocProse(
      'Matching is by literal run, **longest first**, so `@ada` and `@adam` '
      'can both be tokens without the shorter one chopping the longer in half. '
      'The value a caller cares about travels in `AstryxTextToken.value`, so a '
      'press acts on the thing rather than on the string that named it.',
    ),
    DocCallout.accessibility(
      '**The plain sentence is what is announced.** "Ask at-ada about '
      'deploy-log.txt" is the message; a chip announced as a separate control '
      'mid-sentence is a sentence nobody can follow. The chips are excluded '
      'from semantics and the container carries the text.',
    ),
    DocApi('AstryxChatTokenizedText', <DocProp>[
      DocProp('text', 'String', 'The whole message.', required: true),
      DocProp(
        'tokens',
        'Map<String, AstryxTextToken>',
        'The runs to draw as chips, keyed by the literal text they appear as.',
        required: true,
      ),
      DocProp(
        'semanticsLabel',
        'String?',
        'What a screen reader announces. Defaults to `text`.',
      ),
    ]),
    DocApi(
      'AstryxTextToken',
      <DocProp>[
        DocProp('icon', 'AstryxIconName?', 'A glyph on the chip.'),
        DocProp('onPressed', 'VoidCallback?', 'Called when it is pressed.'),
        DocProp(
          'value',
          'Object?',
          'What the entity *is*, for the caller’s own use.',
        ),
        DocProp(
          'tooltip',
          'String?',
          'A phrase describing the entity, if the label alone is cryptic.',
        ),
      ],
      description: 'What one entity in a run of text stands for.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTokenTextController](chat_composer_token) — the same tokens '
          'while they are being typed.',
      '[AstryxTokenChip](token) — the chip on its own.',
      '[AstryxMarkdown](markdown) — for an answer whose structure matters more '
          'than its mentions.',
    ]),
  ],
);

const DocPage _chatToolCalls = DocPage(
  id: 'chat_tool_calls',
  title: 'AstryxChatToolCalls',
  group: _group,
  description: 'The tool calls a model made, and their results, inside a turn.',
  source: 'lib/src/components/chat/tool_calls.dart',
  upstream: 'ChatToolCalls',
  upstreamPath: '/components/ChatToolCalls',
  blocks: <DocBlock>[
    DocExample('chat_tool_calls_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxChatMessage(
  author: 'Assistant',
  footer: AstryxChatToolCalls(calls: reply.toolCalls),
  child: AstryxMarkdown(reply.text),
)'''),
    DocProse(
      'A tool call is *how* an answer was reached, so it belongs in the turn’s '
      '`footer` — under the answer rather than in place of it. Each call is a '
      'disclosure, **collapsed by default and summarised in the row**: what a '
      'reader wants is usually "did it work" rather than the JSON.',
    ),
    DocProse(
      'The `summary` is worth more on the row than the arguments are, which is '
      'why the arguments are behind the disclosure and it is not. "Searched '
      '412 log lines" answers the question; `{"query": "bind", "limit": 500}` '
      'restates it.',
    ),
    DocTable(
      headers: <String>['`AstryxToolCallStatus`', 'Drawn as'],
      rows: <List<String>>[
        <String>['`pending`', 'A neutral dot — queued, not started.'],
        <String>[
          '`running`',
          'A spinner, labelled. Not a bare spinner: a wait with no words is a '
              'wait nobody can name.',
        ],
        <String>['`succeeded`', 'A success dot, and "Finished".'],
        <String>['`failed`', 'An error dot, and "Failed".'],
      ],
    ),
    DocCallout.accessibility(
      '**Every status is paired with its word**, on the row and in the '
      'disclosure’s own content. Colour is never the only signal, and a dot is '
      'too small to carry a shape as well — so "Failed" is written next to the '
      'red one.',
    ),
    DocCallout.warning(
      '`initiallyExpanded` is false, and should usually stay false. A turn '
      'that unfolds four screens of JSON on arrival has buried the answer the '
      'reader was waiting for.',
    ),
    DocApi('AstryxChatToolCalls', <DocProp>[
      DocProp(
        'calls',
        'List<AstryxToolCall>',
        'The calls, in the order they were made.',
        required: true,
      ),
      DocProp('label', 'String?', 'Names the run. Defaults to "Tool calls".'),
      DocProp(
        'initiallyExpanded',
        'bool',
        'Whether every call starts open.',
        defaultValue: 'false',
      ),
    ]),
    DocApi(
      'AstryxToolCall',
      <DocProp>[
        DocProp('name', 'String', 'The tool’s name.', required: true),
        DocProp(
          'status',
          'AstryxToolCallStatus',
          'How far along it is.',
          defaultValue: 'AstryxToolCallStatus.succeeded',
        ),
        DocProp(
          'summary',
          'String?',
          'A one-line description, for the collapsed row.',
        ),
        DocProp('arguments', 'String?', 'What it was called with, formatted.'),
        DocProp('result', 'String?', 'What it returned, formatted.'),
        DocProp(
          'language',
          'String',
          'The language of the two code blocks.',
          defaultValue: "'json'",
        ),
      ],
      description:
          'One call. Already-formatted strings rather than a `Map`: the model '
          'sent JSON, and re-encoding it here would only be a chance to encode '
          'it differently from the log beside it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCollapsible](collapsible) — the disclosure each call is.',
      '[AstryxCodeBlock](code_block) — where the payloads are drawn.',
      '[AstryxChatMessage](chat_message) — the `footer` these go in.',
    ]),
  ],
);

const DocPage _citation = DocPage(
  id: 'citation',
  title: 'AstryxCitation',
  group: _group,
  description: 'A numbered reference from generated text back to its source.',
  source: 'lib/src/components/chat/citation.dart',
  upstream: 'Citation',
  upstreamPath: '/components/Citation',
  blocks: <DocBlock>[
    DocExample('citation_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
Text.rich(
  TextSpan(
    children: <InlineSpan>[
      const TextSpan(text: 'The check gives up at 30 seconds'),
      AstryxCitation.span(1, source: 'scheduler/health.md',
          onPressed: _open),
    ],
  ),
)'''),
    DocProse(
      '`AstryxCitation.span` puts one inside a sentence; the widget on its own '
      'is for a list of sources under an answer.',
    ),
    DocHeading('Named for its source'),
    DocCallout.accessibility(
      '**"1" is not a destination.** The visible marker is a number because a '
      'number is all that fits, but the accessible name is "Source 1: '
      'scheduler/health.md" — a screen-reader user offered a row of bare '
      'numerals has been given a puzzle instead of a bibliography. The source '
      'is in the name whether or not it is in the tooltip, so it is never '
      'pointer-only.',
    ),
    DocProse(
      'A citation with no `onPressed` is not announced as a button and takes '
      'no focus: a marker that looks pressable and does nothing is worse than '
      'a plain one. With one, `Enter` and `Space` follow it like any other '
      'control.',
    ),
    DocApi('AstryxCitation', <DocProp>[
      DocProp(
        'number',
        'int',
        'Which reference this is, as the reader counts them. One-based.',
        required: true,
      ),
      DocProp(
        'source',
        'String?',
        'What it points at. Shown on hover and focus, and always part of the '
            'accessible name.',
      ),
      DocProp('onPressed', 'VoidCallback?', 'Called when it is pressed.'),
      DocProp(
        'AstryxCitation.span(…)',
        'static',
        'The same marker as an `InlineSpan`, aligned to sit with the text.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxMarkdown](markdown) — what the cited text is usually drawn with.',
      '[AstryxLink](link) — for a reference that is a destination rather than '
          'a footnote.',
      '[AstryxChatMessage](chat_message) — the `footer` a source list goes in.',
    ]),
  ],
);

const DocPage _markdown = DocPage(
  id: 'markdown',
  title: 'AstryxMarkdown',
  group: _group,
  description: 'Rendered markdown, for model output and authored prose alike.',
  source: 'lib/src/components/chat/markdown.dart',
  upstream: 'Markdown',
  upstreamPath: '/components/Markdown',
  blocks: <DocBlock>[
    DocExample('markdown_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('AstryxMarkdown(reply.text, onLinkPressed: _open)'),
    DocProse(
      'A model answers in markdown, so something has to draw it — and drawing '
      'it with `AstryxHeading`, `AstryxCodeBlock`, `AstryxBlockquote` and '
      '`AstryxLink` is what keeps an answer looking like part of the '
      'application rather than a web page inside it.',
    ),
    DocHeading('What it renders'),
    DocTable(
      headers: <String>['Markdown', 'Drawn as'],
      rows: <List<String>>[
        <String>['`#` … `######`', '`AstryxHeading`, at the matching level'],
        <String>['Paragraphs', '`AstryxText`'],
        <String>['`- `, `* `, `1. `', 'A bullet or number and its text'],
        <String>['Fenced blocks', '`AstryxCodeBlock`, language and all'],
        <String>['`> `', '`AstryxBlockquote`'],
        <String>['`---`', '`AstryxDivider`'],
        <String>[
          '`**bold**`, `*italic*`, `` `code` ``, `[text](url)`',
          'Inline spans — the last one an `AstryxLink`',
        ],
      ],
    ),
    DocHeading('What it does not'),
    DocCallout.warning(
      '**Tables, images, footnotes, nested lists, task lists, inline HTML — '
      'and text selection across blocks.** They are absent rather than '
      'half-drawn: a table rendered as run-together text is worse than a table '
      'nobody rendered, because the reader cannot tell it *was* a table. '
      'Unsupported input degrades to paragraphs and never throws, which is '
      'what matters for arbitrary model output.',
    ),
    DocProse(
      'Reach for a real markdown package where the input is arbitrary and the '
      'output matters that much. This exists so a chat answer looks right, and '
      'it says what it can do.',
    ),
    DocHeading('Links'),
    DocProse(
      'Without `onLinkPressed` a link is drawn as **plain text**. Looking like '
      'a control and not being one is the worse of the two failures, and this '
      'package does not decide what following a link means — see '
      '[AstryxLinkScope](link_provider).',
    ),
    DocApi('AstryxMarkdown', <DocProp>[
      DocProp('source', 'String', 'The markdown.', required: true),
      DocProp(
        'onLinkPressed',
        'ValueChanged<String>?',
        'Called with the target of a link that was followed. Null draws links '
            'as text.',
      ),
      DocProp(
        'gap',
        'AstryxSpacingToken',
        'The space between blocks.',
        defaultValue: 'AstryxSpacingToken.spacing3',
      ),
    ]),
    DocCallout.accessibility(
      'Heading levels come straight from the `#` count, so the outline a '
      'reader navigates by is the one the author wrote. `AstryxHeading` '
      'derives its size from that level rather than the other way round, which '
      'is why there is nothing here to get wrong.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCodeBlock](code_block) — fenced blocks, and the copy control.',
      '[AstryxStreamingText](use_streaming_text) — for an answer still '
          'arriving; render markdown once it has.',
      '[AstryxCitation](citation) — the markers that go in cited prose.',
    ]),
  ],
);

const DocPage _token = DocPage(
  id: 'token',
  title: 'AstryxTokenChip',
  group: _group,
  description: 'One inline chip standing for an entity inside a text field.',
  source: 'lib/src/components/chat/token.dart',
  upstream: 'Token',
  upstreamPath: '/components/Token',
  blocks: <DocBlock>[
    DocExample('token_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxTokenChip(
  'deploy-log.txt',
  icon: AstryxIconName.copy,
  onRemove: () => _detach(file),
)'''),
    DocCallout.note(
      'Upstream calls it `Token`; here it is `AstryxTokenChip`, because '
      '`AstryxToken` is already the **design token** interface every token '
      'enum implements. A design system cannot have two things called Token, '
      'and the older one is load-bearing in every theme.',
    ),
    DocHeading('Not a badge'),
    DocProse(
      'An [AstryxBadge](badge) is a *label*: static, never removable, and '
      'often not about anything the user chose. A token is a **value somebody '
      'put there** and can take away again. The two look similar and behave '
      'nothing alike, which is why they are separate widgets rather than a '
      'flag.',
    ),
    DocProse(
      '`onRemove` adds the remove button; without it the token is presented '
      'rather than chosen — a mention inside a message that has already been '
      'sent. `onPressed` makes the chip itself open what it stands for.',
    ),
    DocCallout.accessibility(
      'The remove button is named after **what it removes** — "Remove '
      'deploy-log.txt", not "Remove". A row of five buttons with identical '
      'names is a row a screen-reader user cannot choose from. A pressable '
      'token keeps its remove button as a node of its own, which is the one '
      'case where nesting controls is right: they do different things, and a '
      'reader has to be able to pick.',
    ),
    DocApi('AstryxTokenChip', <DocProp>[
      DocProp('label', 'String', 'The entity’s name.', required: true),
      DocProp('icon', 'AstryxIconName?', 'A glyph before the label.'),
      DocProp(
        'onRemove',
        'VoidCallback?',
        'Called when the remove button is pressed. Null omits the button.',
      ),
      DocProp(
        'onPressed',
        'VoidCallback?',
        'Called when the token itself is pressed.',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the token responds.',
        defaultValue: 'true',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTokenizer](tokenizer) — the field that makes these.',
      '[AstryxChatTokenizedText](chat_tokenized_text) — the same chips inside '
          'a sentence.',
      '[AstryxBadge](badge) — the label this is not.',
    ]),
  ],
);

const DocPage _tokenizer = DocPage(
  id: 'tokenizer',
  title: 'AstryxTokenizer',
  group: _group,
  description: 'The field that turns typed text into tokens.',
  source: 'lib/src/components/chat/token.dart',
  upstream: 'Tokenizer',
  upstreamPath: '/components/Tokenizer',
  blocks: <DocBlock>[
    DocExample('tokenizer_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxTokenizer(
  label: 'Recipients',
  values: _to,
  validate: (candidate) => candidate.contains('@'),
  onChanged: (values) => setState(() => _to = values),
)'''),
    DocProse(
      'For free text that becomes a set — recipients, tags, labels — where the '
      'values are **not** from a list. When they are, '
      '[AstryxMultiSelector](multi_selector) is the widget: it can show what '
      'the options are, and this cannot.',
    ),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Enter`', 'Commits the draft as a token.'],
        <String>[
          'A delimiter — `,` by default',
          'Commits everything before it, so pasting "a@x.com, b@x.com" lands '
              'as two tokens rather than one long string.',
        ],
        <String>[
          '`Backspace` on an empty draft',
          'Takes the last token back — the only way to undo one without '
              'reaching for the pointer.',
        ],
      ],
    ),
    DocProse(
      'A batch commits as **one** change. That is not a detail: `values` is '
      'the parent’s list and does not update until it rebuilds, so committing '
      'twice in a frame built the second value on top of a stale list and '
      'threw the first away. Pasting a comma-separated list is exactly that '
      'case.',
    ),
    DocHeading('Refusing a value'),
    DocProse(
      '`validate` decides what may be committed. A refused candidate **keeps '
      'its text**, so the user can see what was refused and fix it; a '
      'duplicate does not, because it is already there and leaving it in the '
      'field reads as the press not registering. Say *why* with `status`.',
    ),
    DocApi('AstryxTokenizer', <DocProp>[
      DocProp(
        'values',
        'List<String>',
        'The committed values, in the order they were added.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<List<String>>?',
        'Called with the new set whenever one is added or removed.',
      ),
      DocProp('label', 'String?', 'The field’s label and accessible name.'),
      DocProp(
        'validate',
        'bool Function(String)?',
        'Whether a candidate may be committed.',
      ),
      DocProp(
        'allowDuplicates',
        'bool',
        'Whether the same value may appear twice.',
        defaultValue: 'false',
      ),
      DocProp(
        'delimiters',
        'List<String>',
        'Characters that commit the current text.',
        defaultValue: "const <String>[',']",
      ),
      DocProp('icon', 'AstryxIconName?', 'A glyph on every token.'),
    ]),
    DocCallout.accessibility(
      'The field announces **how many values it holds** as its value, so a '
      'reader tabbing onto it is told what is already there rather than having '
      'to walk the tokens. Each token keeps its own node, and each remove '
      'button is named after its token.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTokenChip](token) — the chips it makes.',
      '[AstryxMultiSelector](multi_selector) — when the values come from a '
          'list.',
      '[AstryxField](field) — the label and validation wrapper around it.',
    ]),
  ],
);
