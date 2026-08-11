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
- [AstryxBadge](components/badge.md) — A small label: a status, a count, a category.
- [AstryxBanner](components/banner.md) — An inline message with a severity, announced when it appears.
- SelectableCard — A card that carries selection state, for a card-shaped radio or checkbox. *(not ported yet)*

## Data display

- [AstryxTabList](components/tab_list.md) — A strip of tabs that reports a value and owns no panel.
- [AstryxTable](components/table.md) — A typed data table with sorting, selection, row actions and three column-width strategies.
- List — A vertical list of rows, with the separators and density the design system expects. *(not ported yet)*
- TreeList — A list of nested, expandable rows. *(not ported yet)*
- OverflowList — A row of items that measures itself and moves the tail into a menu. *(not ported yet)*
- MetadataList — Label-and-value pairs, for the details panel of a record. *(not ported yet)*
- Item — The row primitive the lists and menus share — icon, label, description, trailing slot. *(not ported yet)*
- EmptyState — What a list, table or panel shows when it has nothing to show. *(not ported yet)*
- Code — Inline monospace, for a symbol or a value inside a sentence. *(not ported yet)*
- CodeBlock — A fenced block of code, with the language, copy control and optional line numbers. *(not ported yet)*
- Blockquote — A quotation set apart from the surrounding prose. *(not ported yet)*
- Kbd — A keyboard key or chord, rendered as a key. *(not ported yet)*

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
- [Centred hero](components/centered_hero.md) — A headline, a supporting line, and one action.
- [Detail page](components/detail_page.md) — One record: header, status, tabs, metadata and actions.
- [Dashboard](components/dashboard.md) — Summary tiles above a table of what needs attention.
- [Table](components/table_template.md) — A data table as a screen: a toolbar, filtering, sorting, selection and row actions.
- [Theme showcase](components/theme_showcase.md) — One of everything on one screen, for judging a theme rather than imagining it.
- AI chat — A full conversation screen: transcript, composer, and the empty state before the first turn. *(not ported yet)*
- AI chat landing — The pre-conversation screen: prompt suggestions and a centred composer. *(not ported yet)*
- Classic gallery — A uniform grid of media cards. *(not ported yet)*
- Portfolio dashboard — A dashboard built around a chart and a holdings table. *(not ported yet)*
- Documentation — A docs page: side navigation, content column, and an on-this-page outline. *(not ported yet)*
- Design documentation — A docs page for a design topic, heavy on specimens. *(not ported yet)*
- Technical documentation — A docs page for an API, heavy on code and property tables. *(not ported yet)*
- Editor — A document editor: toolbar, canvas, and an inspector panel. *(not ported yet)*
- File explorer — A tree of folders beside a list of files. *(not ported yet)*
- Gallery hero — A hero whose supporting content is a media grid. *(not ported yet)*
- IDE — A code workspace: file tree, tabbed editors, and a panel. *(not ported yet)*
- Incident console — A live operations view: severity, timeline, and the current on-call. *(not ported yet)*
- Kanban board — Columns of draggable cards. *(not ported yet)*
- Library — A browsable collection with filters beside the results. *(not ported yet)*
- Messaging shell — A conversation list beside the open conversation. *(not ported yet)*
- Mixed gallery — A gallery of items at mixed sizes. *(not ported yet)*
- Product detail — Gallery, price, options, and the add-to-cart action. *(not ported yet)*
- Product gallery — A filterable grid of products. *(not ported yet)*
- Settings with sidebar — Settings sections reached from a sidebar. *(not ported yet)*
- Shell navigation — The application shell with both bars in place. *(not ported yet)*
- Shell with side nav — The shell with a vertical rail only. *(not ported yet)*
- Shell with top nav — The shell with a horizontal bar only. *(not ported yet)*
- Side gallery — A gallery with the selected item beside the strip. *(not ported yet)*
- Grouped table — A table whose rows are grouped under collapsible headers. *(not ported yet)*
- Table page — A table as a whole screen: filters, table, pagination. *(not ported yet)*
- Table page with chart — A table screen with a summary chart above it. *(not ported yet)*
- Table page with heatmap — A table screen whose cells carry heatmap and status colouring. *(not ported yet)*
- Retail heatmap table — The heatmap table screen with a retail data set. *(not ported yet)*

## App shell

- AppShell — The outer frame of an application: header, navigation, content, and the responsive behaviour joining them. *(not ported yet)*
- Layout — The content frame inside the shell — header, footer, panel and scrolling body. *(not ported yet)*
- Section — A titled band of page content, with its own heading level and spacing. *(not ported yet)*
- ResizeHandle — A draggable divider that resizes the panel beside it. *(not ported yet)*
- Outline — An on-this-page table of contents, tracking the reader's position. *(not ported yet)*

## Navigation

- Breadcrumbs — The trail back up a hierarchy, collapsing in the middle when it will not fit. *(not ported yet)*
- TopNav — A horizontal application bar, with menus and an optional mega menu. *(not ported yet)*
- SideNav — A vertical navigation rail with sections, headings, and a collapsed state. *(not ported yet)*
- MobileNav — The navigation drawer a narrow viewport gets instead of the rail. *(not ported yet)*
- NavIcon — The icon slot in a navigation item, sized and aligned for the rail. *(not ported yet)*
- NavHeadingMenu — A navigation heading that is itself a menu trigger. *(not ported yet)*
- TabMenu — A tab whose selection opens a menu rather than switching a panel. *(not ported yet)*
- MoreMenu — The overflow menu a toolbar or nav collapses its tail into. *(not ported yet)*
- Toolbar — A horizontal band of controls, with arrow-key traversal as one tab stop. *(not ported yet)*
- Pagination — Page-at-a-time controls for a list or table too long to scroll. *(not ported yet)*
- SegmentedControl — A small set of mutually exclusive views, all labels visible at once. *(not ported yet)*
- Link — Inline navigation in running text, with the visited and external affordances. *(not ported yet)*

## Date & time

- Calendar — A month grid for picking a date, keyboard-navigable. *(not ported yet)*
- DateInput — A text field that parses and formats a single date. *(not ported yet)*
- DateRangeInput — Two dates as one field, with the range validated across them. *(not ported yet)*
- DateTimeInput — A date and a time in one field. *(not ported yet)*
- TimeInput — A text field for a time of day. *(not ported yet)*
- Timestamp — An absolute time rendered relative — "3 minutes ago" — and re-rendered as it ages. *(not ported yet)*

## Command & search

- CommandPalette — The keyboard-first command surface: a query, grouped results, and a footer of shortcuts. *(not ported yet)*
- Typeahead — A text field that suggests completions as you type. *(not ported yet)*
- BaseTypeahead — The unstyled typeahead the other search inputs are built from. *(not ported yet)*
- PowerSearch — A search input with structured filters alongside the free text. *(not ported yet)*

## Chat & AI

- ChatLayout — The frame of a conversation: a scrolling transcript and a pinned composer. *(not ported yet)*
- ChatMessage — One turn in a conversation — the bubble, its metadata, and the list that holds them. *(not ported yet)*
- ChatComposer — The input a message is written in, with its drawer and inline tokens. *(not ported yet)*
- ChatSendButton — The composer's submit control, reflecting sending and stop-generating. *(not ported yet)*
- ChatDictationButton — The composer's speech-to-text control. *(not ported yet)*
- ChatSystemMessage — A turn that came from the system rather than either participant. *(not ported yet)*
- ChatTokenizedText — Message text with mentions and references rendered as tokens. *(not ported yet)*
- ChatToolCalls — The tool calls a model made, and their results, inside a turn. *(not ported yet)*
- Citation — A numbered reference from generated text back to its source. *(not ported yet)*
- Markdown — Rendered markdown, for model output and authored prose alike. *(not ported yet)*
- Token — One inline chip standing for an entity inside a text field. *(not ported yet)*
- Tokenizer — The field that turns typed text into tokens. *(not ported yet)*

## Media

- Avatar — A person or entity as an image, initials or icon, with an optional status dot. *(not ported yet)*
- AvatarGroup — Overlapping avatars with a count for the ones that did not fit. *(not ported yet)*
- Thumbnail — A small fixed-ratio preview of an image or file. *(not ported yet)*
- AspectRatio — A box that keeps its width-to-height ratio as it resizes. *(not ported yet)*
- Carousel — A horizontally paged strip of items, with the controls and keyboard traversal. *(not ported yet)*
- Lightbox — A full-screen media viewer, navigable between items. *(not ported yet)*
- MediaTheme — The theme overrides that apply to media surfaces — captions and controls over an image. *(not ported yet)*

## Providers

- Theme — The provider that puts a resolved theme in scope. Ported as `AstryxThemeProvider`; this page records the upstream mapping. *(not ported yet)*
- LayerProvider — The stacking context overlays are raised into. *(not ported yet)*
- LinkProvider — How links navigate — supplied once, so components need not know the router. *(not ported yet)*
- InternationalizationProvider — Locale, text direction and the translator, supplied to the tree. *(not ported yet)*
- SyntaxTheme — The token colours a code block highlights with. *(not ported yet)*

## Hooks & controllers

- useTheme — Reading the theme in scope. In Flutter this is `AstryxTheme.of(context)` — the page records why there is no hook. *(not ported yet)*
- useMediaQuery — Responding to viewport size. Flutter's `MediaQuery` covers it; the page records the mapping. *(not ported yet)*
- useHotkeys — Binding keyboard shortcuts to actions. *(not ported yet)*
- useFocusTrap — Holding focus inside an open overlay. *(not ported yet)*
- useScrollLock — Freezing the page behind a modal. *(not ported yet)*
- useScrollOverflow — Knowing whether a scroller has content beyond either edge, for fading its edges. *(not ported yet)*
- useOverflow — Measuring which children do not fit, so a component can collapse its tail. *(not ported yet)*
- useListFocus — Arrow-key traversal across a list as one tab stop. *(not ported yet)*
- useGridFocus — Two-dimensional arrow-key traversal across a grid. *(not ported yet)*
- useTreeFocus — Arrow-key traversal across a tree, including expand and collapse. *(not ported yet)*
- useLayer — Placing content in the overlay stack at the right depth. *(not ported yet)*
- useClickableContainer — Making a container behave as one control without nesting interactive elements. *(not ported yet)*
- useInputContainer — Sharing focus, hover and validation state between a field and its affixes. *(not ported yet)*
- useKeyboardHint — Showing shortcut hints only once the user is navigating by keyboard. *(not ported yet)*
- useEntryAnimation — Animating an element as it enters, respecting reduced-motion. *(not ported yet)*
- useContainerReveal — Revealing content as its container scrolls into view. *(not ported yet)*
- useImageMode — Choosing the light or dark variant of an image. *(not ported yet)*
- useStreamingText — Rendering text as it arrives token by token. *(not ported yet)*
- useTranslator — Looking up a translated string. *(not ported yet)*

