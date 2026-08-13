---
name: astryx-ui
description: >-
  Use when writing or reviewing Flutter UI built with the astryx_ui
  package — screens, forms, tables, dialogs, menus, toasts or custom
  themes using AstryxButton, AstryxCard, AstryxTable and the rest of
  the widget set. Covers all 30 components, the token system (never a
  raw colour or pixel value), pointer/touch density, right-to-left
  support, and the accessibility rules the widget set enforces —
  required labels, focus behaviour, and never putting anything behind
  hover alone. Also use when asked to theme an app, pick between two
  similar components, or explain why an astryx_ui widget behaves as it
  does.
---

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

# astryx_ui

A Flutter design system for internal tools, token-compatible with Astryx.
Built on `flutter/widgets`, **not Material**. Roughly 30 components, all
themeable through one token layer.

## Setup

```dart
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);
```

Inside an existing `MaterialApp` or `CupertinoApp`, wrap a subtree instead —
this is the incremental adoption path and behaves identically:

```dart
MaterialApp(
  home: AstryxThemeProvider(
    theme: matchaTheme,          // optional. Defaults to neutralTheme
    mode: AstryxColorMode.system,
    child: const HomePage(),
  ),
)
```

Either one installs the theme, the icon registry, the localisations, the
focus-visible scope and the toast host. Nothing else to wire: toasts, tooltips,
dialogs and focus rings work from here.

For tokens without widgets — a chart, a custom painter, a test — import
`package:astryx_ui/theme.dart` instead.

## Hard rules

Break these and the result compiles, looks fine, and is wrong.

1. **No raw values.** Never a `Color`, a padding number, a radius, a duration or
   a `TextStyle` literal. Read the token:

   ```dart
   final theme = AstryxTheme.of(context);
   theme.color(AstryxColorToken.accent);
   theme.spacing(AstryxSpacingToken.spacing3);
   theme.borderRadius(AstryxRadiusToken.container);
   theme.textStyle(AstryxTypeRole.body);
   ```

   Widget parameters take tokens directly — `gap:`, `padding:`, `variant:`.
   Reach for `AstryxTheme.of` only when building something the design system
   has no widget for.

2. **Everything interactive has an accessible name.** `AstryxButton.label`,
   `AstryxIconButton.label` (required even though nothing is painted),
   `AstryxCheckbox.label`, `AstryxCard.semanticsLabel` when pressable,
   `AstryxTable.label` and `rowLabelOf`, `AstryxTabList.label`, an overlay's
   `label`. Use `labelHidden: true` to hide a label from sight — never to skip
   one.

3. **Nothing lives behind hover.** No hover-only actions, no information that
   appears only in a tooltip. Touch has no hover, and the density system
   actively suppresses hover styling there. Gate any hover styling you write
   yourself on `AstryxTheme.densityOf(context).supportsHover`.

4. **Colour is never the only signal.** Pair every status with an icon or text.
   The nine `AstryxPalette` families are *categorical* — "the Red team" — never
   severity.

5. **Composite controls are one tab stop.** `AstryxRadioList`, `AstryxTabList`,
   `AstryxTreeList`, `AstryxSegmentedControl`, `AstryxToolbar`,
   `AstryxDropdownMenu` and `AstryxSelector` handle their own arrow-key
   navigation. Do not wrap their children in `Focus` or `InkWell`.

6. **Overlays take a `triggerBuilder`, not a child.** A button consumes its own
   taps, so the overlay hands you a controller:

   ```dart
   AstryxPopover(
     content: panel,
     triggerBuilder: (context, controller) =>
         AstryxButton(label: 'Filters', onPressed: controller.toggle),
   )
   ```

   `AstryxDialog` is the exception: it is a widget in the tree driven by an
   `AstryxDialogController`, not a `showDialog` call. Put it next to whatever
   opens it and dispose the controller with your state.

7. **`AstryxHStack` and `AstryxVStack` default to `MainAxisSize.min`**, unlike
   Flutter's `Row` and `Column`. `justify` appears to do nothing until you ask
   for `MainAxisSize.max`. In a spreading row, wrap text in `Flexible` or it
   will overflow.

8. **There is one card.** No `ClickableCard`: a non-null `onPressed` makes
   `AstryxCard` a button, with hover, press, a focus ring, `Semantics(button:
   true)` and tap-target enforcement. The one exception is
   `AstryxSelectableCard`, which is a *control*, not a surface: it reports a
   selection instead of a press, and announces itself as a checkbox or a radio.

9. **Logical directions only.** `start`/`end`, `paddingInline`,
   `EdgeInsetsDirectional`. Never `left`/`right`. RTL is then a
   `Directionality` and nothing else.

10. **A switch applies immediately; a checkbox applies on submit.** Do not put
    an `AstryxSwitch` in a form with a Save button.

11. **`AstryxSelector` picks a value; `AstryxDropdownMenu` performs actions.**
    A menu reports nothing and shows no current selection.

## Choosing a widget

| Want | Use |
| --- | --- |
| An action with words | `AstryxButton` |
| An action with a glyph | `AstryxIconButton` (still needs `label`) |
| A related set of actions | `AstryxButtonGroup(attached: false)` |
| A segmented control | `AstryxSegmentedControl` |
| One choice, ≤7 options, all visible | `AstryxRadioList` |
| One choice, many options | `AstryxSelector` |
| One choice, options needing a price or a badge | `AstryxSelectableCard` |
| A boolean that applies now | `AstryxSwitch` |
| A boolean that applies on submit | `AstryxCheckbox` |
| A label + validation around your own control | `AstryxField` |
| A message tied to the page | `AstryxBanner` |
| A message about something that just happened | toast via `AstryxToastScope.of(context).show(...)` |
| A status word or count | `AstryxBadge` |
| A container, maybe pressable | `AstryxCard` |
| A floating panel | `AstryxPopover` |
| A list of actions | `AstryxDropdownMenu` |
| Something that must be dealt with | `AstryxDialog` |
| A phrase on hover | `AstryxTooltip` (never the only source of the fact) |
| Rows of data | `AstryxTable` (does **not** virtualise — hundreds, not thousands) |
| Switching views | `AstryxTabList` |
| A wait with no known extent | `AstryxSpinner` |
| A wait with a known extent | `AstryxProgressBar` |
| A wait whose result has a known shape | `AstryxSkeleton` |
| Row/column with token spacing | `AstryxHStack` / `AstryxVStack` |
| A responsive tile wall | `AstryxGrid(minWidth: …)` |
| An empty state | `AstryxEmptyState` |
| The frame around an application | `AstryxAppShell` |
| The destinations of an application | `AstryxSideNav` / `AstryxTopNav` / `AstryxMobileNav` (one `AstryxNavEntry` list, three containers) |
| The icon slot in a nav row | `AstryxNavIcon` |
| A workspace switcher | `AstryxNavHeadingMenu` |
| The trail back up a hierarchy | `AstryxBreadcrumbs` |
| A band of controls, one tab stop | `AstryxToolbar` |
| The tail of a toolbar or a row | `AstryxMoreMenu` |
| Page-at-a-time controls | `AstryxPagination` |
| A tab that opens a menu | `AstryxTabMenu` |
| Text that goes somewhere | `AstryxLink` (`AstryxLink.span` in `Text.rich`) |
| A page inside that frame | `AstryxLayout` (pinned header and footer) |
| A titled band of a page | `AstryxSection` (works out its own heading level) |
| A draggable panel edge | `AstryxResizeHandle` |
| An on-this-page contents | `AstryxOutline` |
| A row: something, a label, something | `AstryxItem` |
| A stack of rows | `AstryxList` (does **not** virtualise) |
| Rows that nest | `AstryxTreeList` |
| A row that must not wrap | `AstryxOverflowList` |
| Facts about one record | `AstryxMetadataList` |
| A symbol inside a sentence | `AstryxCode` (`AstryxCode.span` in `Text.rich`) |
| More than a phrase of code | `AstryxCodeBlock` (no highlighting) |
| Someone else's words | `AstryxBlockquote` |
| A keyboard shortcut | `AstryxKbd` |

## Common mistakes

| Wrong | Right |
| --- | --- |
| `AstryxButton(child: Text('Save'))` | `AstryxButton(label: 'Save')` — there is no `child` |
| `AstryxIconButton(icon: …, onPressed: …)` | add `label:` — it is required |
| `padding: EdgeInsets.all(16)` | `padding: AstryxSpacingToken.spacing4` |
| `SizedBox(height: 12)` between children | `gap:` on the enclosing stack |
| `Color(0xFF0F62FE)` | `theme.color(AstryxColorToken.accent)` |
| `TextStyle(fontSize: 14)` | `AstryxText(…, type: AstryxTextType.supporting)` |
| `Text('Hello')` | `AstryxText('Hello')` |
| `ClickableCard(…)` | `AstryxCard(onPressed: …, semanticsLabel: …)` |
| `showDialog(context: context, …)` | an `AstryxDialog` in the tree + `AstryxDialogController` |
| `AstryxPopover(child: button)` | `triggerBuilder: (context, controller) => …` |
| `onChanged` omitted "because it is read-only" | `readOnly: true` — a null `onChanged` is silently inert |
| `enabled: false` for a value shown but not editable | `readOnly: true`; `enabled: false` dims it |
| `EdgeInsets.only(left: 8)` | `EdgeInsetsDirectional.only(start: 8)` |
| Row actions revealed on hover | always visible — `rowActionsBuilder` |
| `AstryxHStack(justify: …)` and nothing moves | add `mainAxisSize: MainAxisSize.max` |
| Long text in a spreading row | wrap it in `Flexible` |
| `AstryxTable` fed 10,000 rows | paginate; it does not virtualise |
| Sorting wired to `onSortChanged` only | a column is sortable only if it has `compare` |

## Components

Open the reference before writing a component you have not written before. Each entry there has a canonical snippet, the rules that apply, and the full property table.

| Component | For | Reference |
| --- | --- | --- |
| `AstryxText` | A run of text, sized and coloured from the type scale. | `references/layout.md` |
| `AstryxHeading` | A heading: a size from the scale, and a level in the outline. | `references/layout.md` |
| `AstryxHStack & AstryxVStack` | A row and a column whose gap comes from the spacing scale. | `references/layout.md` |
| `AstryxGrid` | A CSS-style grid: fixed tracks, or as many as the width allows. | `references/layout.md` |
| `AstryxCenter` | Centres a child, with token padding and a measure. | `references/layout.md` |
| `AstryxDivider` | A rule between sections, optionally labelled. | `references/layout.md` |
| `AstryxIcon` | A glyph named semantically and resolved through the theme. | `references/layout.md` |
| `AstryxVisuallyHidden` | Content present for a screen reader and absent from the screen. | `references/layout.md` |
| `AstryxButton` | A labelled action, in four levels of prominence. | `references/actions.md` |
| `AstryxIconButton` | A square button holding a glyph instead of words. | `references/actions.md` |
| `AstryxButtonGroup` | Joins related actions into one control, or spaces them as a set. | `references/actions.md` |
| `AstryxToggleButton` | A button that stays pressed — a setting, not an action. | `references/actions.md` |
| `AstryxToggleButtonGroup` | Toggle buttons as one control — single or multiple selection. | `references/actions.md` |
| `AstryxField` | Gives any control a label, a description, a required marker and a validation message. | `references/forms.md` |
| `AstryxTextInput` | A single-line or multi-line text field, with validation. | `references/forms.md` |
| `AstryxTextArea` | A multi-line text field that grows with its content. | `references/forms.md` |
| `AstryxCheckbox` | A two-state or three-state checkbox with a required label. | `references/forms.md` |
| `AstryxCheckboxList` | A group of checkboxes sharing one label and one validation state. | `references/forms.md` |
| `AstryxRadioList` | One choice out of several, as an ARIA radio group. | `references/forms.md` |
| `AstryxSwitch` | A setting that takes effect the moment it is flipped. | `references/forms.md` |
| `AstryxSelector` | A dropdown that picks one value, with optional search. | `references/forms.md` |
| `AstryxNumberInput` | A numeric field with steppers, a range and unit text. | `references/forms.md` |
| `AstryxFileInput` | A file field: the chooser, the chosen list, and the limits. | `references/forms.md` |
| `AstryxSlider` | A value, or a range, chosen by dragging along a track. | `references/forms.md` |
| `AstryxMultiSelector` | A selector that keeps several choices, shown as tokens. | `references/forms.md` |
| `AstryxComplexSelector` | A selector with a trigger this package draws and a surface you draw. | `references/forms.md` |
| `AstryxInputGroup` | Adjacent inputs and affixes joined into one bordered control. | `references/forms.md` |
| `AstryxFormLayout` | The column and label geometry a form’s fields share. | `references/forms.md` |
| `AstryxCalendar` | A month grid for picking a date, keyboard-navigable. | `references/date_time.md` |
| `AstryxDateInput` | A text field that parses and formats a single date. | `references/date_time.md` |
| `AstryxDateRangeInput` | Two dates as one field, with the range validated across them. | `references/date_time.md` |
| `AstryxDateTimeInput` | A date and a time in one field. | `references/date_time.md` |
| `AstryxTimeInput` | A text field for a time of day. | `references/date_time.md` |
| `AstryxTimestamp` | An absolute time rendered relative — "3 minutes ago" — and re-rendered as it ages. | `references/date_time.md` |
| `AstryxSpinner` | An indeterminate wait, in three sizes. | `references/status.md` |
| `AstryxSkeleton` | A placeholder in the shape of the content that is coming. | `references/status.md` |
| `AstryxProgressBar` | A determinate or indeterminate bar, with an announced label. | `references/status.md` |
| `AstryxStatusDot` | A small coloured dot standing for a state, always paired with text. | `references/status.md` |
| `AstryxPopover` | A floating panel anchored to a trigger, with trapped focus. | `references/overlays.md` |
| `AstryxTooltip` | A short phrase on hover, focus, or long-press. | `references/overlays.md` |
| `AstryxHoverCard` | A rich preview on hover, that stays open when you reach it. | `references/overlays.md` |
| `AstryxDropdownMenu` | A list of actions, with sections, submenus and full keyboard support. | `references/overlays.md` |
| `AstryxContextMenu` | A menu raised by a secondary click, at the pointer. | `references/overlays.md` |
| `AstryxDialog` | A modal panel anchored to the viewport, with a scrolling body. | `references/overlays.md` |
| `AstryxAlertDialog` | A modal that interrupts to confirm one consequential action. | `references/overlays.md` |
| `AstryxOverlay` | The scrim-and-layer primitive the modals are built on. | `references/overlays.md` |
| `AstryxToast` | A transient message in the corner, with an optional action. | `references/overlays.md` |
| `AstryxCollapsible` | A disclosure: a header that shows and hides its own content. | `references/overlays.md` |
| `AstryxCollapsibleGroup` | Several collapsibles as one section, optionally an accordion. | `references/overlays.md` |
| `AstryxCard` | A bordered surface with a header, a body and a footer — pressable when you give it something to do. | `references/surfaces.md` |
| `AstryxSelectableCard` | A card that carries selection state — a card-shaped radio or checkbox. | `references/surfaces.md` |
| `AstryxBadge` | A small label: a status, a count, a category. | `references/surfaces.md` |
| `AstryxBanner` | An inline message with a severity, announced when it appears. | `references/surfaces.md` |
| `AstryxTabList` | A strip of tabs that reports a value and owns no panel. | `references/data.md` |
| `AstryxTable` | A typed data table with sorting, selection, row actions and three column-width strategies. | `references/data.md` |
| `AstryxItem` | The row the lists are built from — something at the start, a label, and something at the end. | `references/data.md` |
| `AstryxList` | A vertical list of rows, with the separators and density the design system expects. | `references/data.md` |
| `AstryxTreeList` | A list of nested, expandable rows. | `references/data.md` |
| `AstryxOverflowList` | A row of items that measures itself and moves the tail into a menu. | `references/data.md` |
| `AstryxMetadataList` | Label-and-value pairs, for the details panel of a record. | `references/data.md` |
| `AstryxEmptyState` | What a list, table or panel shows when it has nothing to show. | `references/data.md` |
| `AstryxCode` | Inline monospace, for a symbol or a value inside a sentence. | `references/data.md` |
| `AstryxCodeBlock` | A fenced block of code, with the language, copy control and optional line numbers. | `references/data.md` |
| `AstryxBlockquote` | A quotation set apart from the surrounding prose. | `references/data.md` |
| `AstryxKbd` | A keyboard key or chord, rendered as a key. | `references/data.md` |
| `AstryxSideNav` | A vertical navigation rail with sections, headings, and a collapsed state. | `references/navigation.md` |
| `AstryxTopNav` | A horizontal application bar, with menus and an optional mega menu. | `references/navigation.md` |
| `AstryxMobileNav` | The navigation drawer a narrow viewport gets instead of the rail. | `references/navigation.md` |
| `AstryxNavHeadingMenu` | A navigation heading that is itself a menu trigger. | `references/navigation.md` |
| `AstryxNavIcon` | The icon slot in a navigation item, sized and aligned for the rail. | `references/navigation.md` |
| `AstryxBreadcrumbs` | The trail back up a hierarchy, collapsing in the middle when it will not fit. | `references/navigation.md` |
| `AstryxLink` | Inline navigation in running text, with the visited and external affordances. | `references/navigation.md` |
| `AstryxSegmentedControl` | A small set of mutually exclusive views, all labels visible at once. | `references/navigation.md` |
| `AstryxToolbar` | A horizontal band of controls, with arrow-key traversal as one tab stop. | `references/navigation.md` |
| `AstryxMoreMenu` | The overflow menu a toolbar or nav collapses its tail into. | `references/navigation.md` |
| `AstryxTabMenu` | A tab whose selection opens a menu rather than switching a panel. | `references/navigation.md` |
| `AstryxPagination` | Page-at-a-time controls for a list or table too long to scroll. | `references/navigation.md` |
| `AstryxAppShell` | The outer frame of an application: header, navigation, content, and the responsive behaviour joining them. | `references/app_shell.md` |
| `AstryxLayout` | The content frame inside the shell — header, footer, panel and scrolling body. | `references/app_shell.md` |
| `AstryxSection` | A titled band of page content, with its own heading level and spacing. | `references/app_shell.md` |
| `AstryxResizeHandle` | A draggable divider that resizes the panel beside it. | `references/app_shell.md` |
| `AstryxOutline` | An on-this-page table of contents, tracking the reader’s position. | `references/app_shell.md` |
| `AstryxAvatar` | A person or entity as an image, initials or icon, with an optional status dot. | `references/media.md` |
| `AstryxAvatarGroup` | Overlapping avatars with a count for the ones that did not fit. | `references/media.md` |
| `AstryxThumbnail` | A small fixed-ratio preview of an image or file. | `references/media.md` |
| `AstryxAspectRatio` | A box that keeps its width-to-height ratio as it resizes. | `references/media.md` |
| `AstryxCarousel` | A horizontally paged strip of items, with the controls and keyboard traversal. | `references/media.md` |
| `AstryxLightbox` | A full-screen media viewer, navigable between items. | `references/media.md` |
| `AstryxMediaTheme` | The theme overrides that apply to media surfaces — captions and controls over an image. | `references/media.md` |
| `AstryxCommandPalette` | The keyboard-first command surface: a query, grouped results, and a footer of shortcuts. | `references/command_search.md` |
| `AstryxTypeahead` | A text field that suggests completions as you type. | `references/command_search.md` |
| `AstryxBaseTypeahead` | The unstyled typeahead the other search inputs are built from. | `references/command_search.md` |
| `AstryxPowerSearch` | A search input with structured filters alongside the free text. | `references/command_search.md` |
| `AstryxChatLayout` | The frame of a conversation: a scrolling transcript and a pinned composer. | `references/chat.md` |
| `AstryxChatMessage` | One turn in a conversation — the bubble, its metadata, and the list that holds them. | `references/chat.md` |
| `AstryxChatComposer` | The input a message is written in, with its drawer. | `references/chat.md` |
| `AstryxTokenTextController` | A mention styled inside the text being typed. | `references/chat.md` |
| `AstryxChatSendButton` | The composer's submit control, reflecting sending and stop-generating. | `references/chat.md` |
| `AstryxChatDictationButton` | The composer's speech-to-text control. | `references/chat.md` |
| `AstryxChatSystemMessage` | A turn that came from the system rather than either participant. | `references/chat.md` |
| `AstryxChatTokenizedText` | Message text with mentions and references rendered as tokens. | `references/chat.md` |
| `AstryxChatToolCalls` | The tool calls a model made, and their results, inside a turn. | `references/chat.md` |
| `AstryxCitation` | A numbered reference from generated text back to its source. | `references/chat.md` |
| `AstryxMarkdown` | Rendered markdown, for model output and authored prose alike. | `references/chat.md` |
| `AstryxTokenChip` | One inline chip standing for an entity inside a text field. | `references/chat.md` |
| `AstryxTokenizer` | The field that turns typed text into tokens. | `references/chat.md` |
| `AstryxThemeProvider` | The provider that puts a resolved theme in scope — and everything else the widgets need. | `references/providers.md` |
| `The overlay layer` | The stacking context overlays are raised into. | `references/providers.md` |
| `AstryxLinkScope` | How links navigate — supplied once, so components need not know the router. | `references/providers.md` |
| `AstryxLocalizationsScope` | Locale, text direction and the strings, supplied to the tree. | `references/providers.md` |
| `AstryxSyntaxTheme` | The token colours a code block highlights with. | `references/providers.md` |
| `useTheme → AstryxTheme.of` | Reading the theme in scope, and why there is no hook. | `references/hooks.md` |
| `useMediaQuery → MediaQuery` | Responding to viewport size, pointer, and motion preference. | `references/hooks.md` |
| `AstryxHotkeys` | Binding keyboard shortcuts to actions. | `references/hooks.md` |
| `AstryxFocusTrap` | Holding focus inside an open overlay, and giving it back. | `references/hooks.md` |
| `AstryxScrollLock` | Freezing the page behind a modal. | `references/hooks.md` |
| `AstryxScrollOverflow` | Knowing whether a scroller has content beyond either edge, for fading its edges. | `references/hooks.md` |
| `useOverflow → AstryxOverflowList` | Measuring which children do not fit, so a component can collapse its tail. | `references/hooks.md` |
| `AstryxRovingFocus.list` | Arrow-key traversal across a list as one tab stop. | `references/hooks.md` |
| `AstryxRovingFocus.grid` | Two-dimensional arrow-key traversal across a grid. | `references/hooks.md` |
| `useTreeFocus → AstryxTreeList` | Arrow-key traversal across a tree, including expand and collapse. | `references/hooks.md` |
| `useLayer → Overlay and the stack` | Placing content in the overlay stack at the right depth. | `references/hooks.md` |
| `useClickableContainer → onPressed` | Making a container behave as one control without nesting interactive elements. | `references/hooks.md` |
| `useInputContainer → the field` | Sharing focus, hover and validation state between a field and its affixes. | `references/hooks.md` |
| `AstryxKeyboardHint` | Showing shortcut hints only once the user is navigating by keyboard. | `references/hooks.md` |
| `AstryxEntryAnimation` | Animating an element as it enters, respecting reduced-motion. | `references/hooks.md` |
| `AstryxContainerReveal` | Revealing content as its container scrolls into view. | `references/hooks.md` |
| `useImageMode → the resolved mode` | Choosing the light or dark variant of an image. | `references/hooks.md` |
| `AstryxStreamingText` | Rendering text as it arrives token by token. | `references/hooks.md` |
| `useTranslator → AstryxLocalizations.of` | Looking up a translated string. | `references/hooks.md` |
| `Login` | A centred sign-in form, with the validation, error and loading states a real one has. | `references/templates.md` |
| `Login card` | Sign-in inside a bordered card, using all three card slots. | `references/templates.md` |
| `SSO login` | Sign-in through identity providers, with an email link as the fallback. | `references/templates.md` |
| `Split login` | Sign-in beside a full-height panel. | `references/templates.md` |
| `Contact form` | A single-column form with validation, an in-flight state and a success state that replaces it. | `references/templates.md` |
| `Two-column form` | A long form split into labelled sections, with the section heading beside its fields. | `references/templates.md` |
| `Payment form` | Card details, a billing address, and the summary beside them. | `references/templates.md` |
| `Settings` | Grouped preference rows with inline controls, each applying the moment it changes. | `references/templates.md` |
| `Settings dialog` | Settings inside a modal, with its own navigation. | `references/templates.md` |
| `Settings with sidebar` | Settings sections reached from a sidebar. | `references/templates.md` |
| `Centred hero` | A headline, a supporting line, and one action. | `references/templates.md` |
| `Gallery hero` | A hero whose supporting content is a media grid. | `references/templates.md` |
| `Detail page` | One record: header, status, tabs, metadata and actions. | `references/templates.md` |
| `Dashboard` | Summary tiles above a table of what needs attention. | `references/templates.md` |
| `Portfolio dashboard` | A dashboard built around a chart and a holdings table. | `references/templates.md` |
| `Table` | A data table as a screen: a toolbar, filtering, sorting, selection and row actions. | `references/templates.md` |
| `Grouped table` | A table whose rows are grouped under collapsible headers. | `references/templates.md` |
| `Table page` | A table as a whole screen: filters in a pinned header, pagination in a pinned footer. | `references/templates.md` |
| `Table page with chart` | A table screen with a summary chart above it. | `references/templates.md` |
| `Table page with heatmap` | A table screen whose cells carry heatmap and status colouring. | `references/templates.md` |
| `Retail heatmap table` | The heatmap table screen with a retail data set. | `references/templates.md` |
| `Kanban board` | Columns of draggable cards. | `references/templates.md` |
| `Incident console` | A live operations view: severity, timeline, and the current on-call. | `references/templates.md` |
| `Classic gallery` | A uniform wall of media tiles, each opening the same viewer on the item that was pressed. | `references/templates.md` |
| `Mixed gallery` | A gallery of items at mixed sizes. | `references/templates.md` |
| `Side gallery` | A gallery with the selected item beside the strip. | `references/templates.md` |
| `Product gallery` | A filterable grid of products. | `references/templates.md` |
| `Product detail` | Gallery, price, options, and the add-to-cart action. | `references/templates.md` |
| `AI chat` | A full conversation screen: transcript, composer, tool calls, and the empty state before the first turn. | `references/templates.md` |
| `AI chat landing` | The pre-conversation screen: prompt suggestions and a centred composer. | `references/templates.md` |
| `Shell navigation` | The application frame with both bars in place: a full-width header and a collapsible rail beside the content. | `references/templates.md` |
| `Shell with side nav` | The shell with a vertical rail only. | `references/templates.md` |
| `Shell with top nav` | The shell with a horizontal bar only. | `references/templates.md` |
| `Documentation` | A docs page: side navigation, a measured content column, and an on-this-page outline that tracks the reader. | `references/templates.md` |
| `Design documentation` | A docs page for a design topic, heavy on specimens. | `references/templates.md` |
| `Technical documentation` | A docs page for an API, heavy on code and property tables. | `references/templates.md` |
| `Editor` | A document editor: toolbar, canvas, and an inspector panel. | `references/templates.md` |
| `File explorer` | A tree of folders beside a list of files. | `references/templates.md` |
| `IDE` | A code workspace: file tree, tabbed editors, and a panel. | `references/templates.md` |
| `Library` | A browsable collection with filters beside the results. | `references/templates.md` |
| `Messaging shell` | A conversation list beside the open conversation. | `references/templates.md` |
| `Theme showcase` | One of everything on one screen, for judging a theme rather than imagining it. | `references/templates.md` |

## Guides

| Topic | Covers | Reference |
| --- | --- | --- |
| astryx_ui | A Flutter design system for internal tools, token-compatible with Astryx. | `references/guides.md` |
| Installation | Add the package, wrap your app once, and you are done. | `references/guides.md` |
| Principles | What the design system optimises for, and the decisions that follow from it. | `references/guides.md` |
| Theming | Seven themes, two brightnesses, and an engine for your own. | `references/guides.md` |
| Design tokens | The values every component resolves through. | `references/guides.md` |
| Colour | The colour system: the families, the semantic roles, and which one to reach for. | `references/guides.md` |
| Typography | The type scale, the roles, and how a heading level maps onto them. | `references/guides.md` |
| Spacing | The spacing scale, and the rule that gaps come from tokens rather than magic numbers. | `references/guides.md` |
| Shape | Corner radii and how they compose when surfaces nest. | `references/guides.md` |
| Elevation | The elevation levels, what each is for, and how they read in dark mode. | `references/guides.md` |
| Motion | Durations, easings, and what must not move when motion is reduced. | `references/guides.md` |
| Layout | Page structure: the shell, the content column, and the breakpoints between them. | `references/guides.md` |
| Icons | The icon registry, the Lucide mapping, and how to supply your own set. | `references/guides.md` |
| Illustrations | The upstream illustration set, and what a Flutter port would need to carry it. | `references/guides.md` |
| Styling | Extending a component's appearance without leaving the token system. | `references/guides.md` |
| The token engine | How a theme definition becomes resolved tokens, and where the resolution happens. | `references/guides.md` |
| Platform support | Which Flutter platforms are exercised, and where behaviour differs. The Flutter counterpart of upstream's browser-support page. | `references/guides.md` |
| Density | One widget set that is honest on a mouse and on a thumb. | `references/guides.md` |
| Right-to-left | Logical throughout, so RTL is a `Directionality` and nothing more. | `references/guides.md` |
| Accessibility | The rules the whole widget set is built to, in one place. | `references/guides.md` |
| Migration | Coming from Material or Cupertino: what maps, what does not, and what to stop doing. | `references/guides.md` |
| Working with AI | The generated agent skill, what it contains, and how to keep it current. | `references/guides.md` |
| Themes | The eight themes side by side, and the same components rendered in each. | `references/guides.md` |
| Showcase | Apps built with astryx_ui, and how to add yours. | `references/guides.md` |

## All references

- `references/enums.md` — **every public enum and its values.** Check here before naming a variant, a size or a token; the names are not always the obvious ones.
- `references/patterns.md` — whole screens: a form in a card, a table with row actions, a destructive flow, a settings list.
- `references/guides.md` — Getting started.
- `references/layout.md` — Layout & typography.
- `references/actions.md` — Actions.
- `references/forms.md` — Forms.
- `references/date_time.md` — Date & time.
- `references/status.md` — Status.
- `references/overlays.md` — Overlays.
- `references/surfaces.md` — Surfaces.
- `references/data.md` — Data display.
- `references/navigation.md` — Navigation.
- `references/app_shell.md` — App shell.
- `references/media.md` — Media.
- `references/command_search.md` — Command & search.
- `references/chat.md` — Chat & AI.
- `references/providers.md` — Providers.
- `references/hooks.md` — Hooks & controllers.
- `references/templates.md` — Templates.

The prose versions of these pages, for a human, are in `doc/` at the repository root. The live site is `example/`.
