/// Upstream hooks with no component family of their own.
///
/// A React hook is not a Flutter idiom. Each of these resolves to a controller,
/// a mixin, an existing framework API, or nothing — which is what the page will
/// say once it is written. The hooks that belong to a component (`usePopover`,
/// every `useTable*`) are folded into that component's page instead.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// One page per unfamilied upstream hook, alphabetical by upstream name.
final List<DocPage> plannedHookPages = <DocPage>[
  stubPage(
    id: 'use_theme',
    title: 'useTheme',
    group: DocGroup.hooks,
    description:
        'Reading the theme in scope. In Flutter this is '
        '`AstryxTheme.of(context)` — the page records why there is '
        'no hook.',
    upstream: 'useTheme',
    upstreamPath: '/components/useTheme',
  ),
  stubPage(
    id: 'use_media_query',
    title: 'useMediaQuery',
    group: DocGroup.hooks,
    description:
        "Responding to viewport size. Flutter's `MediaQuery` covers "
        'it; the page records the mapping.',
    upstream: 'useMediaQuery',
    upstreamPath: '/components/useMediaQuery',
  ),
  stubPage(
    id: 'use_hotkeys',
    title: 'useHotkeys',
    group: DocGroup.hooks,
    description: 'Binding keyboard shortcuts to actions.',
    upstream: 'useHotkeys',
    upstreamPath: '/components/useHotkeys',
  ),
  stubPage(
    id: 'use_focus_trap',
    title: 'useFocusTrap',
    group: DocGroup.hooks,
    description: 'Holding focus inside an open overlay.',
    upstream: 'useFocusTrap',
    upstreamPath: '/components/useFocusTrap',
  ),
  stubPage(
    id: 'use_scroll_lock',
    title: 'useScrollLock',
    group: DocGroup.hooks,
    description: 'Freezing the page behind a modal.',
    upstream: 'useScrollLock',
    upstreamPath: '/components/useScrollLock',
  ),
  stubPage(
    id: 'use_scroll_overflow',
    title: 'useScrollOverflow',
    group: DocGroup.hooks,
    description:
        'Knowing whether a scroller has content beyond either edge, '
        'for fading its edges.',
    upstream: 'useScrollOverflow',
    upstreamPath: '/components/useScrollOverflow',
  ),
  stubPage(
    id: 'use_overflow',
    title: 'useOverflow',
    group: DocGroup.hooks,
    description:
        'Measuring which children do not fit, so a component can '
        'collapse its tail.',
    upstream: 'useOverflow',
    upstreamPath: '/components/useOverflow',
  ),
  stubPage(
    id: 'use_list_focus',
    title: 'useListFocus',
    group: DocGroup.hooks,
    description: 'Arrow-key traversal across a list as one tab stop.',
    upstream: 'useListFocus',
    upstreamPath: '/components/useListFocus',
  ),
  stubPage(
    id: 'use_grid_focus',
    title: 'useGridFocus',
    group: DocGroup.hooks,
    description: 'Two-dimensional arrow-key traversal across a grid.',
    upstream: 'useGridFocus',
    upstreamPath: '/components/useGridFocus',
  ),
  stubPage(
    id: 'use_tree_focus',
    title: 'useTreeFocus',
    group: DocGroup.hooks,
    description:
        'Arrow-key traversal across a tree, including expand and '
        'collapse.',
    upstream: 'useTreeFocus',
    upstreamPath: '/components/useTreeFocus',
  ),
  stubPage(
    id: 'use_layer',
    title: 'useLayer',
    group: DocGroup.hooks,
    description: 'Placing content in the overlay stack at the right depth.',
    upstream: 'useLayer',
    upstreamPath: '/components/useLayer',
  ),
  stubPage(
    id: 'use_clickable_container',
    title: 'useClickableContainer',
    group: DocGroup.hooks,
    description:
        'Making a container behave as one control without nesting '
        'interactive elements.',
    upstream: 'useClickableContainer',
    upstreamPath: '/components/useClickableContainer',
  ),
  stubPage(
    id: 'use_input_container',
    title: 'useInputContainer',
    group: DocGroup.hooks,
    description:
        'Sharing focus, hover and validation state between a field '
        'and its affixes.',
    upstream: 'useInputContainer',
    upstreamPath: '/components/useInputContainer',
  ),
  stubPage(
    id: 'use_keyboard_hint',
    title: 'useKeyboardHint',
    group: DocGroup.hooks,
    description:
        'Showing shortcut hints only once the user is navigating by '
        'keyboard.',
    upstream: 'useKeyboardHint',
    upstreamPath: '/components/useKeyboardHint',
  ),
  stubPage(
    id: 'use_entry_animation',
    title: 'useEntryAnimation',
    group: DocGroup.hooks,
    description:
        'Animating an element as it enters, respecting '
        'reduced-motion.',
    upstream: 'useEntryAnimation',
    upstreamPath: '/components/useEntryAnimation',
  ),
  stubPage(
    id: 'use_container_reveal',
    title: 'useContainerReveal',
    group: DocGroup.hooks,
    description: 'Revealing content as its container scrolls into view.',
    upstream: 'useContainerReveal',
    upstreamPath: '/components/useContainerReveal',
  ),
  stubPage(
    id: 'use_image_mode',
    title: 'useImageMode',
    group: DocGroup.hooks,
    description: 'Choosing the light or dark variant of an image.',
    upstream: 'useImageMode',
    upstreamPath: '/components/useImageMode',
  ),
  stubPage(
    id: 'use_streaming_text',
    title: 'useStreamingText',
    group: DocGroup.hooks,
    description: 'Rendering text as it arrives token by token.',
    upstream: 'useStreamingText',
    upstreamPath: '/components/useStreamingText',
  ),
  stubPage(
    id: 'use_translator',
    title: 'useTranslator',
    group: DocGroup.hooks,
    description: 'Looking up a translated string.',
    upstream: 'useTranslator',
    upstreamPath: '/components/useTranslator',
  ),
];
