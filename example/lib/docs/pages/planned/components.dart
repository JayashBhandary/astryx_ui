/// Components upstream ships that this port has not written up yet.
///
/// One page per widget, not per upstream URL: a sub-component that is not a
/// public Dart type in its own right is a section on its parent's page, and is
/// listed in that page's `upstream:` so the parity check can see it.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// Every component page that is a placeholder, in upstream nav order.
final List<DocPage> plannedComponentPages = <DocPage>[
  stubPage(
    id: 'calendar',
    title: 'Calendar',
    group: DocGroup.dateTime,
    description: 'A month grid for picking a date, keyboard-navigable.',
    upstream: 'Calendar',
    upstreamPath: '/components/Calendar',
  ),
  stubPage(
    id: 'date_input',
    title: 'DateInput',
    group: DocGroup.dateTime,
    description: 'A text field that parses and formats a single date.',
    upstream: 'DateInput',
    upstreamPath: '/components/DateInput',
  ),
  stubPage(
    id: 'date_range_input',
    title: 'DateRangeInput',
    group: DocGroup.dateTime,
    description:
        'Two dates as one field, with the range validated across '
        'them.',
    upstream: 'DateRangeInput',
    upstreamPath: '/components/DateRangeInput',
  ),
  stubPage(
    id: 'date_time_input',
    title: 'DateTimeInput',
    group: DocGroup.dateTime,
    description: 'A date and a time in one field.',
    upstream: 'DateTimeInput',
    upstreamPath: '/components/DateTimeInput',
  ),
  stubPage(
    id: 'time_input',
    title: 'TimeInput',
    group: DocGroup.dateTime,
    description: 'A text field for a time of day.',
    upstream: 'TimeInput',
    upstreamPath: '/components/TimeInput',
  ),
  stubPage(
    id: 'timestamp',
    title: 'Timestamp',
    group: DocGroup.dateTime,
    description:
        'An absolute time rendered relative — "3 minutes ago" — and '
        're-rendered as it ages.',
    upstream: 'Timestamp',
    upstreamPath: '/components/Timestamp',
  ),
  stubPage(
    id: 'command_palette',
    title: 'CommandPalette',
    group: DocGroup.commandSearch,
    description:
        'The keyboard-first command surface: a query, grouped '
        'results, and a footer of shortcuts.',
    upstream:
        'CommandPalette / CommandPaletteEmpty / '
        'CommandPaletteFooter / CommandPaletteGroup / '
        'CommandPaletteInput / CommandPaletteItem / '
        'CommandPaletteList',
    upstreamPath: '/components/CommandPalette',
  ),
  stubPage(
    id: 'typeahead',
    title: 'Typeahead',
    group: DocGroup.commandSearch,
    description: 'A text field that suggests completions as you type.',
    upstream: 'Typeahead / TypeaheadItem',
    upstreamPath: '/components/Typeahead',
  ),
  stubPage(
    id: 'base_typeahead',
    title: 'BaseTypeahead',
    group: DocGroup.commandSearch,
    description:
        'The unstyled typeahead the other search inputs are built '
        'from.',
    upstream: 'BaseTypeahead',
    upstreamPath: '/components/BaseTypeahead',
  ),
  stubPage(
    id: 'power_search',
    title: 'PowerSearch',
    group: DocGroup.commandSearch,
    description:
        'A search input with structured filters alongside the free '
        'text.',
    upstream: 'PowerSearch',
    upstreamPath: '/components/PowerSearch',
  ),
  stubPage(
    id: 'chat_layout',
    title: 'ChatLayout',
    group: DocGroup.chat,
    description:
        'The frame of a conversation: a scrolling transcript and a '
        'pinned composer.',
    upstream: 'ChatLayout / ChatLayoutScrollButton',
    upstreamPath: '/components/ChatLayout',
  ),
  stubPage(
    id: 'chat_message',
    title: 'ChatMessage',
    group: DocGroup.chat,
    description:
        'One turn in a conversation — the bubble, its metadata, and '
        'the list that holds them.',
    upstream:
        'ChatMessage / ChatMessageBubble / ChatMessageList / '
        'ChatMessageMetadata',
    upstreamPath: '/components/ChatMessage',
  ),
  stubPage(
    id: 'chat_composer',
    title: 'ChatComposer',
    group: DocGroup.chat,
    description:
        'The input a message is written in, with its drawer and '
        'inline tokens.',
    upstream:
        'ChatComposer / ChatComposerDrawer / ChatComposerInput / '
        'ChatComposerTokenElement',
    upstreamPath: '/components/ChatComposer',
  ),
  stubPage(
    id: 'chat_send_button',
    title: 'ChatSendButton',
    group: DocGroup.chat,
    description:
        "The composer's submit control, reflecting sending and "
        'stop-generating.',
    upstream: 'ChatSendButton',
    upstreamPath: '/components/ChatSendButton',
  ),
  stubPage(
    id: 'chat_dictation_button',
    title: 'ChatDictationButton',
    group: DocGroup.chat,
    description: "The composer's speech-to-text control.",
    upstream: 'ChatDictationButton',
    upstreamPath: '/components/ChatDictationButton',
  ),
  stubPage(
    id: 'chat_system_message',
    title: 'ChatSystemMessage',
    group: DocGroup.chat,
    description:
        'A turn that came from the system rather than either '
        'participant.',
    upstream: 'ChatSystemMessage',
    upstreamPath: '/components/ChatSystemMessage',
  ),
  stubPage(
    id: 'chat_tokenized_text',
    title: 'ChatTokenizedText',
    group: DocGroup.chat,
    description:
        'Message text with mentions and references rendered as '
        'tokens.',
    upstream: 'ChatTokenizedText',
    upstreamPath: '/components/ChatTokenizedText',
  ),
  stubPage(
    id: 'chat_tool_calls',
    title: 'ChatToolCalls',
    group: DocGroup.chat,
    description:
        'The tool calls a model made, and their results, inside a '
        'turn.',
    upstream: 'ChatToolCalls',
    upstreamPath: '/components/ChatToolCalls',
  ),
  stubPage(
    id: 'citation',
    title: 'Citation',
    group: DocGroup.chat,
    description:
        'A numbered reference from generated text back to its '
        'source.',
    upstream: 'Citation',
    upstreamPath: '/components/Citation',
  ),
  stubPage(
    id: 'markdown',
    title: 'Markdown',
    group: DocGroup.chat,
    description:
        'Rendered markdown, for model output and authored prose '
        'alike.',
    upstream: 'Markdown',
    upstreamPath: '/components/Markdown',
  ),
  stubPage(
    id: 'token',
    title: 'Token',
    group: DocGroup.chat,
    description:
        'One inline chip standing for an entity inside a text '
        'field.',
    upstream: 'Token',
    upstreamPath: '/components/Token',
  ),
  stubPage(
    id: 'tokenizer',
    title: 'Tokenizer',
    group: DocGroup.chat,
    description: 'The field that turns typed text into tokens.',
    upstream: 'Tokenizer',
    upstreamPath: '/components/Tokenizer',
  ),
  stubPage(
    id: 'avatar',
    title: 'Avatar',
    group: DocGroup.media,
    description:
        'A person or entity as an image, initials or icon, with an '
        'optional status dot.',
    upstream: 'Avatar / AvatarStatusDot',
    upstreamPath: '/components/Avatar',
  ),
  stubPage(
    id: 'avatar_group',
    title: 'AvatarGroup',
    group: DocGroup.media,
    description:
        'Overlapping avatars with a count for the ones that did not '
        'fit.',
    upstream: 'AvatarGroup / AvatarGroupOverflow',
    upstreamPath: '/components/AvatarGroup',
  ),
  stubPage(
    id: 'thumbnail',
    title: 'Thumbnail',
    group: DocGroup.media,
    description: 'A small fixed-ratio preview of an image or file.',
    upstream: 'Thumbnail',
    upstreamPath: '/components/Thumbnail',
  ),
  stubPage(
    id: 'aspect_ratio',
    title: 'AspectRatio',
    group: DocGroup.media,
    description: 'A box that keeps its width-to-height ratio as it resizes.',
    upstream: 'AspectRatio',
    upstreamPath: '/components/AspectRatio',
  ),
  stubPage(
    id: 'carousel',
    title: 'Carousel',
    group: DocGroup.media,
    description:
        'A horizontally paged strip of items, with the controls and '
        'keyboard traversal.',
    upstream: 'Carousel',
    upstreamPath: '/components/Carousel',
  ),
  stubPage(
    id: 'lightbox',
    title: 'Lightbox',
    group: DocGroup.media,
    description: 'A full-screen media viewer, navigable between items.',
    upstream: 'Lightbox',
    upstreamPath: '/components/Lightbox',
  ),
  stubPage(
    id: 'media_theme',
    title: 'MediaTheme',
    group: DocGroup.media,
    description:
        'The theme overrides that apply to media surfaces — '
        'captions and controls over an image.',
    upstream: 'MediaTheme',
    upstreamPath: '/components/MediaTheme',
  ),
  stubPage(
    id: 'stack_item',
    title: 'StackItem',
    group: DocGroup.layout,
    description: 'A stack child with its own flex, alignment and order.',
    upstream: 'StackItem',
    upstreamPath: '/components/StackItem',
  ),
  stubPage(
    id: 'theme',
    title: 'Theme',
    group: DocGroup.providers,
    description:
        'The provider that puts a resolved theme in scope. Ported '
        'as `AstryxThemeProvider`; this page records the upstream '
        'mapping.',
    upstream: 'Theme',
    upstreamPath: '/components/Theme',
  ),
  stubPage(
    id: 'layer_provider',
    title: 'LayerProvider',
    group: DocGroup.providers,
    description: 'The stacking context overlays are raised into.',
    upstream: 'LayerProvider',
    upstreamPath: '/components/LayerProvider',
  ),
  stubPage(
    id: 'link_provider',
    title: 'LinkProvider',
    group: DocGroup.providers,
    description:
        'How links navigate — supplied once, so components need not '
        'know the router.',
    upstream: 'LinkProvider',
    upstreamPath: '/components/LinkProvider',
  ),
  stubPage(
    id: 'internationalization_provider',
    title: 'InternationalizationProvider',
    group: DocGroup.providers,
    description:
        'Locale, text direction and the translator, supplied to the '
        'tree.',
    upstream: 'InternationalizationProvider',
    upstreamPath: '/components/InternationalizationProvider',
  ),
  stubPage(
    id: 'syntax_theme',
    title: 'SyntaxTheme',
    group: DocGroup.providers,
    description: 'The token colours a code block highlights with.',
    upstream: 'SyntaxTheme',
    upstreamPath: '/components/SyntaxTheme',
  ),
];
