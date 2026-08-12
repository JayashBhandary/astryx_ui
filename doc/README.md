# astryx_ui documentation

Generated from `example/lib/docs/pages/`. Every code block is extracted from a real, compiling widget in `example/lib/examples/`, so a snippet here cannot describe something the package does not do.

The same pages render as a live site: `cd example && flutter run -d chrome`.

## Getting started

- [astryx_ui](guides/introduction.md) — An unofficial Flutter port of Astryx, Meta’s design system for internal tools.
- [Installation](guides/installation.md) — Add the package, wrap your app once, and you are done.
- [Principles](guides/principles.md) — What the design system optimises for, and the decisions that follow from it.
- [Theming](guides/theming.md) — Seven themes, two brightnesses, and an engine for your own.
- [Design tokens](guides/tokens.md) — The values every component resolves through.
- [Colour](guides/color.md) — The colour system: the families, the semantic roles, and which one to reach for.
- [Typography](guides/typography.md) — The type scale, the roles, and how a heading level maps onto them.
- [Spacing](guides/spacing.md) — The spacing scale, and the rule that gaps come from tokens rather than magic numbers.
- [Shape](guides/shape.md) — Corner radii and how they compose when surfaces nest.
- [Elevation](guides/elevation.md) — The elevation levels, what each is for, and how they read in dark mode.
- [Motion](guides/motion.md) — Durations, easings, and what must not move when motion is reduced.
- [Layout](guides/layout_guide.md) — Page structure: the shell, the content column, and the breakpoints between them.
- [Icons](guides/icons.md) — The icon registry, the Lucide mapping, and how to supply your own set.
- [Illustrations](guides/illustrations.md) — The upstream illustration set, and what a Flutter port would need to carry it.
- [Styling](guides/styling.md) — Extending a component's appearance without leaving the token system.
- [The token engine](guides/core.md) — How a theme definition becomes resolved tokens, and where the resolution happens.
- [Platform support](guides/platform_support.md) — Which Flutter platforms are exercised, and where behaviour differs. The Flutter counterpart of upstream's browser-support page.
- [Density](guides/density.md) — One widget set that is honest on a mouse and on a thumb.
- [Right-to-left](guides/rtl.md) — Logical throughout, so RTL is a `Directionality` and nothing more.
- [Accessibility](guides/accessibility.md) — The rules the whole widget set is built to, in one place.
- [Migration](guides/migration.md) — Coming from Material or Cupertino: what maps, what does not, and what to stop doing.
- [Working with AI](guides/working_with_ai.md) — The generated agent skill, what it contains, and how to keep it current.
- [Themes](guides/themes.md) — The eight themes side by side, and the same components rendered in each.
- [Changelog](guides/changelog.md) — What changed in each release. Rendered from `CHANGELOG.md`.
- [Community](guides/community.md) — The repository, the issue tracker, and how to contribute a component.
- Styling libraries — Upstream covers integrating StyleX with other CSS-in-JS libraries. There is no Flutter counterpart. *(not planned)*
- The Astryx CLI — Upstream ships a Node CLI for agents and scaffolding. This port has no Dart equivalent; the agent skill covers the same ground. *(not planned)*
- CLI integrations — Editor and agent integrations for the upstream Node CLI. Not applicable. *(not planned)*

## Layout & typography

- [AstryxText](components/text.md) — A run of text, sized and coloured from the type scale.
- [AstryxHeading](components/heading.md) — A heading: a size from the scale, and a level in the outline.
- [AstryxHStack & AstryxVStack](components/stack.md) — A row and a column whose gap comes from the spacing scale.
- [AstryxGrid](components/grid.md) — A CSS-style grid: fixed tracks, or as many as the width allows.
- [AstryxCenter](components/center.md) — Centres a child, with token padding and a measure.
- [AstryxDivider](components/divider.md) — A rule between sections, optionally labelled.
- [AstryxIcon](components/icon.md) — A glyph named semantically and resolved through the theme.
- [AstryxVisuallyHidden](components/visually_hidden.md) — Content present for a screen reader and absent from the screen.
- StackItem — A stack child with its own flex, alignment and order. *(not ported yet)*

## Actions

- [AstryxButton](components/button.md) — A labelled action, in four levels of prominence.
- [AstryxIconButton](components/icon_button.md) — A square button holding a glyph instead of words.
- [AstryxButtonGroup](components/button_group.md) — Joins related actions into one control, or spaces them as a set.
- [AstryxToggleButton](components/toggle_button.md) — A button that stays pressed — a setting, not an action.
- [AstryxToggleButtonGroup](components/toggle_button_group.md) — Toggle buttons as one control — single or multiple selection.

## Forms

- [AstryxField](components/field.md) — Gives any control a label, a description, a required marker and a validation message.
- [AstryxTextInput](components/text_input.md) — A single-line or multi-line text field, with validation.
- [AstryxTextArea](components/text_area.md) — A multi-line text field that grows with its content.
- [AstryxCheckbox](components/checkbox.md) — A two-state or three-state checkbox with a required label.
- [AstryxCheckboxList](components/checkbox_list.md) — A group of checkboxes sharing one label and one validation state.
- [AstryxRadioList](components/radio_list.md) — One choice out of several, as an ARIA radio group.
- [AstryxSwitch](components/switch.md) — A setting that takes effect the moment it is flipped.
- [AstryxSelector](components/selector.md) — A dropdown that picks one value, with optional search.
- [AstryxNumberInput](components/number_input.md) — A numeric field with steppers, a range and unit text.
- [AstryxFileInput](components/file_input.md) — A file field: the chooser, the chosen list, and the limits.
- [AstryxSlider](components/slider.md) — A value, or a range, chosen by dragging along a track.
- [AstryxMultiSelector](components/multi_selector.md) — A selector that keeps several choices, shown as tokens.
- [AstryxComplexSelector](components/complex_selector.md) — A selector with a trigger this package draws and a surface you draw.
- [AstryxInputGroup](components/input_group.md) — Adjacent inputs and affixes joined into one bordered control.
- [AstryxFormLayout](components/form_layout.md) — The column and label geometry a form’s fields share.

## Date & time

- [AstryxCalendar](components/calendar.md) — A month grid for picking a date, keyboard-navigable.
- [AstryxDateInput](components/date_input.md) — A text field that parses and formats a single date.
- [AstryxDateRangeInput](components/date_range_input.md) — Two dates as one field, with the range validated across them.
- [AstryxDateTimeInput](components/date_time_input.md) — A date and a time in one field.
- [AstryxTimeInput](components/time_input.md) — A text field for a time of day.
- [AstryxTimestamp](components/timestamp.md) — An absolute time rendered relative — "3 minutes ago" — and re-rendered as it ages.

## Status

- [AstryxSpinner](components/spinner.md) — An indeterminate wait, in three sizes.
- [AstryxSkeleton](components/skeleton.md) — A placeholder in the shape of the content that is coming.
- [AstryxProgressBar](components/progress_bar.md) — A determinate or indeterminate bar, with an announced label.
- [AstryxStatusDot](components/status_dot.md) — A small coloured dot standing for a state, always paired with text.

## Overlays

- [AstryxPopover](components/popover.md) — A floating panel anchored to a trigger, with trapped focus.
- [AstryxTooltip](components/tooltip.md) — A short phrase on hover, focus, or long-press.
- [AstryxHoverCard](components/hover_card.md) — A rich preview on hover, that stays open when you reach it.
- [AstryxDropdownMenu](components/dropdown_menu.md) — A list of actions, with sections, submenus and full keyboard support.
- [AstryxContextMenu](components/context_menu.md) — A menu raised by a secondary click, at the pointer.
- [AstryxDialog](components/dialog.md) — A modal panel anchored to the viewport, with a scrolling body.
- [AstryxAlertDialog](components/alert_dialog.md) — A modal that interrupts to confirm one consequential action.
- [AstryxOverlay](components/overlay.md) — The scrim-and-layer primitive the modals are built on.
- [AstryxToast](components/toast.md) — A transient message in the corner, with an optional action.
- [AstryxCollapsible](components/collapsible.md) — A disclosure: a header that shows and hides its own content.
- [AstryxCollapsibleGroup](components/collapsible_group.md) — Several collapsibles as one section, optionally an accordion.

## Surfaces

- [AstryxCard](components/card.md) — A bordered surface with a header, a body and a footer — pressable when you give it something to do.
- [AstryxSelectableCard](components/selectable_card.md) — A card that carries selection state — a card-shaped radio or checkbox.
- [AstryxBadge](components/badge.md) — A small label: a status, a count, a category.
- [AstryxBanner](components/banner.md) — An inline message with a severity, announced when it appears.

## Data display

- [AstryxTabList](components/tab_list.md) — A strip of tabs that reports a value and owns no panel.
- [AstryxTable](components/table.md) — A typed data table with sorting, selection, row actions and three column-width strategies.
- [AstryxItem](components/item.md) — The row the lists are built from — something at the start, a label, and something at the end.
- [AstryxList](components/list.md) — A vertical list of rows, with the separators and density the design system expects.
- [AstryxTreeList](components/tree_list.md) — A list of nested, expandable rows.
- [AstryxOverflowList](components/overflow_list.md) — A row of items that measures itself and moves the tail into a menu.
- [AstryxMetadataList](components/metadata_list.md) — Label-and-value pairs, for the details panel of a record.
- [AstryxEmptyState](components/empty_state.md) — What a list, table or panel shows when it has nothing to show.
- [AstryxCode](components/code.md) — Inline monospace, for a symbol or a value inside a sentence.
- [AstryxCodeBlock](components/code_block.md) — A fenced block of code, with the language, copy control and optional line numbers.
- [AstryxBlockquote](components/blockquote.md) — A quotation set apart from the surrounding prose.
- [AstryxKbd](components/kbd.md) — A keyboard key or chord, rendered as a key.

## Navigation

- [AstryxSideNav](components/side_nav.md) — A vertical navigation rail with sections, headings, and a collapsed state.
- [AstryxTopNav](components/top_nav.md) — A horizontal application bar, with menus and an optional mega menu.
- [AstryxMobileNav](components/mobile_nav.md) — The navigation drawer a narrow viewport gets instead of the rail.
- [AstryxNavHeadingMenu](components/nav_heading_menu.md) — A navigation heading that is itself a menu trigger.
- [AstryxNavIcon](components/nav_icon.md) — The icon slot in a navigation item, sized and aligned for the rail.
- [AstryxBreadcrumbs](components/breadcrumbs.md) — The trail back up a hierarchy, collapsing in the middle when it will not fit.
- [AstryxLink](components/link.md) — Inline navigation in running text, with the visited and external affordances.
- [AstryxSegmentedControl](components/segmented_control.md) — A small set of mutually exclusive views, all labels visible at once.
- [AstryxToolbar](components/toolbar.md) — A horizontal band of controls, with arrow-key traversal as one tab stop.
- [AstryxMoreMenu](components/more_menu.md) — The overflow menu a toolbar or nav collapses its tail into.
- [AstryxTabMenu](components/tab_menu.md) — A tab whose selection opens a menu rather than switching a panel.
- [AstryxPagination](components/pagination.md) — Page-at-a-time controls for a list or table too long to scroll.

## App shell

- [AstryxAppShell](components/app_shell.md) — The outer frame of an application: header, navigation, content, and the responsive behaviour joining them.
- [AstryxLayout](components/layout.md) — The content frame inside the shell — header, footer, panel and scrolling body.
- [AstryxSection](components/section.md) — A titled band of page content, with its own heading level and spacing.
- [AstryxResizeHandle](components/resize_handle.md) — A draggable divider that resizes the panel beside it.
- [AstryxOutline](components/outline.md) — An on-this-page table of contents, tracking the reader’s position.

## Media

- [AstryxAvatar](components/avatar.md) — A person or entity as an image, initials or icon, with an optional status dot.
- [AstryxAvatarGroup](components/avatar_group.md) — Overlapping avatars with a count for the ones that did not fit.
- [AstryxThumbnail](components/thumbnail.md) — A small fixed-ratio preview of an image or file.
- [AstryxAspectRatio](components/aspect_ratio.md) — A box that keeps its width-to-height ratio as it resizes.
- [AstryxCarousel](components/carousel.md) — A horizontally paged strip of items, with the controls and keyboard traversal.
- [AstryxLightbox](components/lightbox.md) — A full-screen media viewer, navigable between items.
- [AstryxMediaTheme](components/media_theme.md) — The theme overrides that apply to media surfaces — captions and controls over an image.

## Command & search

- [AstryxCommandPalette](components/command_palette.md) — The keyboard-first command surface: a query, grouped results, and a footer of shortcuts.
- [AstryxTypeahead](components/typeahead.md) — A text field that suggests completions as you type.
- [AstryxBaseTypeahead](components/base_typeahead.md) — The unstyled typeahead the other search inputs are built from.
- [AstryxPowerSearch](components/power_search.md) — A search input with structured filters alongside the free text.

## Chat & AI

- [AstryxChatLayout](components/chat_layout.md) — The frame of a conversation: a scrolling transcript and a pinned composer.
- [AstryxChatMessage](components/chat_message.md) — One turn in a conversation — the bubble, its metadata, and the list that holds them.
- [AstryxChatComposer](components/chat_composer.md) — The input a message is written in, with its drawer.
- [AstryxTokenTextController](components/chat_composer_token.md) — A mention styled inside the text being typed.
- [AstryxChatSendButton](components/chat_send_button.md) — The composer's submit control, reflecting sending and stop-generating.
- [AstryxChatDictationButton](components/chat_dictation_button.md) — The composer's speech-to-text control.
- [AstryxChatSystemMessage](components/chat_system_message.md) — A turn that came from the system rather than either participant.
- [AstryxChatTokenizedText](components/chat_tokenized_text.md) — Message text with mentions and references rendered as tokens.
- [AstryxChatToolCalls](components/chat_tool_calls.md) — The tool calls a model made, and their results, inside a turn.
- [AstryxCitation](components/citation.md) — A numbered reference from generated text back to its source.
- [AstryxMarkdown](components/markdown.md) — Rendered markdown, for model output and authored prose alike.
- [AstryxTokenChip](components/token.md) — One inline chip standing for an entity inside a text field.
- [AstryxTokenizer](components/tokenizer.md) — The field that turns typed text into tokens.

## Providers

- [AstryxThemeProvider](components/theme.md) — The provider that puts a resolved theme in scope — and everything else the widgets need.
- [The overlay layer](components/layer_provider.md) — The stacking context overlays are raised into.
- [AstryxLinkScope](components/link_provider.md) — How links navigate — supplied once, so components need not know the router.
- [AstryxLocalizationsScope](components/internationalization_provider.md) — Locale, text direction and the strings, supplied to the tree.
- [AstryxSyntaxTheme](components/syntax_theme.md) — The token colours a code block highlights with.

## Hooks & controllers

- [useTheme → AstryxTheme.of](components/use_theme.md) — Reading the theme in scope, and why there is no hook.
- [useMediaQuery → MediaQuery](components/use_media_query.md) — Responding to viewport size, pointer, and motion preference.
- [AstryxHotkeys](components/use_hotkeys.md) — Binding keyboard shortcuts to actions.
- [AstryxFocusTrap](components/use_focus_trap.md) — Holding focus inside an open overlay, and giving it back.
- [AstryxScrollLock](components/use_scroll_lock.md) — Freezing the page behind a modal.
- [AstryxScrollOverflow](components/use_scroll_overflow.md) — Knowing whether a scroller has content beyond either edge, for fading its edges.
- [useOverflow → AstryxOverflowList](components/use_overflow.md) — Measuring which children do not fit, so a component can collapse its tail.
- [AstryxRovingFocus.list](components/use_list_focus.md) — Arrow-key traversal across a list as one tab stop.
- [AstryxRovingFocus.grid](components/use_grid_focus.md) — Two-dimensional arrow-key traversal across a grid.
- [useTreeFocus → AstryxTreeList](components/use_tree_focus.md) — Arrow-key traversal across a tree, including expand and collapse.
- [useLayer → Overlay and the stack](components/use_layer.md) — Placing content in the overlay stack at the right depth.
- [useClickableContainer → onPressed](components/use_clickable_container.md) — Making a container behave as one control without nesting interactive elements.
- [useInputContainer → the field](components/use_input_container.md) — Sharing focus, hover and validation state between a field and its affixes.
- [AstryxKeyboardHint](components/use_keyboard_hint.md) — Showing shortcut hints only once the user is navigating by keyboard.
- [AstryxEntryAnimation](components/use_entry_animation.md) — Animating an element as it enters, respecting reduced-motion.
- [AstryxContainerReveal](components/use_container_reveal.md) — Revealing content as its container scrolls into view.
- [useImageMode → the resolved mode](components/use_image_mode.md) — Choosing the light or dark variant of an image.
- [AstryxStreamingText](components/use_streaming_text.md) — Rendering text as it arrives token by token.
- [useTranslator → AstryxLocalizations.of](components/use_translator.md) — Looking up a translated string.

## Templates

- [Login](components/login.md) — A centred sign-in form, with the validation, error and loading states a real one has.
- [Login card](components/login_card.md) — Sign-in inside a bordered card, using all three card slots.
- [SSO login](components/login_sso.md) — Sign-in through identity providers, with an email link as the fallback.
- [Split login](components/login_split.md) — Sign-in beside a full-height panel.
- [Contact form](components/contact_form.md) — A single-column form with validation, an in-flight state and a success state that replaces it.
- [Two-column form](components/form_two_column.md) — A long form split into labelled sections, with the section heading beside its fields.
- [Payment form](components/payment_form.md) — Card details, a billing address, and the summary beside them.
- [Settings](components/settings.md) — Grouped preference rows with inline controls, each applying the moment it changes.
- [Settings dialog](components/settings_dialog.md) — Settings inside a modal, with its own navigation.
- [Settings with sidebar](components/settings_sidebar.md) — Settings sections reached from a sidebar.
- [Centred hero](components/centered_hero.md) — A headline, a supporting line, and one action.
- [Gallery hero](components/gallery_hero.md) — A hero whose supporting content is a media grid.
- [Detail page](components/detail_page.md) — One record: header, status, tabs, metadata and actions.
- [Dashboard](components/dashboard.md) — Summary tiles above a table of what needs attention.
- [Portfolio dashboard](components/dashboard_portfolio.md) — A dashboard built around a chart and a holdings table.
- [Table](components/table_template.md) — A data table as a screen: a toolbar, filtering, sorting, selection and row actions.
- [Grouped table](components/table_grouped.md) — A table whose rows are grouped under collapsible headers.
- [Table page](components/table_page.md) — A table as a whole screen: filters in a pinned header, pagination in a pinned footer.
- [Table page with chart](components/table_page_chart.md) — A table screen with a summary chart above it.
- [Table page with heatmap](components/table_page_heatmap_status.md) — A table screen whose cells carry heatmap and status colouring.
- [Retail heatmap table](components/table_page_shoe_store_heatmap.md) — The heatmap table screen with a retail data set.
- [Kanban board](components/kanban_board.md) — Columns of draggable cards.
- [Incident console](components/incident_console.md) — A live operations view: severity, timeline, and the current on-call.
- [Classic gallery](components/classic_gallery.md) — A uniform wall of media tiles, each opening the same viewer on the item that was pressed.
- [Mixed gallery](components/mixed_gallery.md) — A gallery of items at mixed sizes.
- [Side gallery](components/side_gallery.md) — A gallery with the selected item beside the strip.
- [Product gallery](components/product_gallery.md) — A filterable grid of products.
- [Product detail](components/product_detail.md) — Gallery, price, options, and the add-to-cart action.
- [AI chat](components/ai_chat.md) — A full conversation screen: transcript, composer, tool calls, and the empty state before the first turn.
- [AI chat landing](components/ai_chat_landing.md) — The pre-conversation screen: prompt suggestions and a centred composer.
- [Shell navigation](components/shell_nav.md) — The application frame with both bars in place: a full-width header and a collapsible rail beside the content.
- [Shell with side nav](components/shell_side_nav.md) — The shell with a vertical rail only.
- [Shell with top nav](components/shell_top_nav.md) — The shell with a horizontal bar only.
- [Documentation](components/documentation.md) — A docs page: side navigation, a measured content column, and an on-this-page outline that tracks the reader.
- [Design documentation](components/documentation_design.md) — A docs page for a design topic, heavy on specimens.
- [Technical documentation](components/documentation_technical.md) — A docs page for an API, heavy on code and property tables.
- [Editor](components/editor.md) — A document editor: toolbar, canvas, and an inspector panel.
- [File explorer](components/file_explorer.md) — A tree of folders beside a list of files.
- [IDE](components/ide.md) — A code workspace: file tree, tabbed editors, and a panel.
- [Library](components/library.md) — A browsable collection with filters beside the results.
- [Messaging shell](components/messaging_shell.md) — A conversation list beside the open conversation.
- [Theme showcase](components/theme_showcase.md) — One of everything on one screen, for judging a theme rather than imagining it.

