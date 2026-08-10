# astryx_ui documentation

Generated from `example/lib/docs/pages/`. Every code block is extracted from a real, compiling widget in `example/lib/examples/`, so a snippet here cannot describe something the package does not do.

The same pages render as a live site: `cd example && flutter run -d chrome`.

## Getting started

- [astryx_ui](guides/introduction.md) — An unofficial Flutter port of Astryx, Meta’s design system for internal tools.
- [Installation](guides/installation.md) — Add the package, wrap your app once, and you are done.
- [Theming](guides/theming.md) — Seven themes, two brightnesses, and an engine for your own.
- [Design tokens](guides/tokens.md) — The values every component resolves through.
- [Density](guides/density.md) — One widget set that is honest on a mouse and on a thumb.
- [Right-to-left](guides/rtl.md) — Logical throughout, so RTL is a `Directionality` and nothing more.
- [Accessibility](guides/accessibility.md) — The rules the whole widget set is built to, in one place.

## Layout & typography

- [AstryxText](components/text.md) — A run of text, sized and coloured from the type scale.
- [AstryxHeading](components/heading.md) — A heading: a size from the scale, and a level in the outline.
- [AstryxHStack & AstryxVStack](components/stack.md) — A row and a column whose gap comes from the spacing scale.
- [AstryxGrid](components/grid.md) — A CSS-style grid: fixed tracks, or as many as the width allows.
- [AstryxCenter](components/center.md) — Centres a child, with token padding and a measure.
- [AstryxDivider](components/divider.md) — A rule between sections, optionally labelled.
- [AstryxIcon](components/icon.md) — A glyph named semantically and resolved through the theme.

## Actions

- [AstryxButton](components/button.md) — A labelled action, in four levels of prominence.
- [AstryxIconButton](components/icon_button.md) — A square button holding a glyph instead of words.
- [AstryxButtonGroup](components/button_group.md) — Joins related actions into one control, or spaces them as a set.

## Forms

- [AstryxField](components/field.md) — Gives any control a label, a description, a required marker and a validation message.
- [AstryxTextInput](components/text_input.md) — A single-line or multi-line text field, with validation.
- [AstryxTextArea](components/text_area.md) — A multi-line text field that grows with its content.
- [AstryxCheckbox](components/checkbox.md) — A two-state or three-state checkbox with a required label.
- [AstryxRadioList](components/radio_list.md) — One choice out of several, as an ARIA radio group.
- [AstryxSwitch](components/switch.md) — A setting that takes effect the moment it is flipped.
- [AstryxSelector](components/selector.md) — A dropdown that picks one value, with optional search.

## Status

- [AstryxSpinner](components/spinner.md) — An indeterminate wait, in three sizes.
- [AstryxSkeleton](components/skeleton.md) — A placeholder in the shape of the content that is coming.
- [AstryxProgressBar](components/progress_bar.md) — A determinate or indeterminate bar, with an announced label.

## Overlays

- [AstryxPopover](components/popover.md) — A floating panel anchored to a trigger, with trapped focus.
- [AstryxTooltip](components/tooltip.md) — A short phrase on hover, focus, or long-press.
- [AstryxDropdownMenu](components/dropdown_menu.md) — A list of actions, with sections, submenus and full keyboard support.
- [AstryxDialog](components/dialog.md) — A modal panel anchored to the viewport, with a scrolling body.
- [AstryxToast](components/toast.md) — A transient message in the corner, with an optional action.

## Surfaces

- [AstryxCard](components/card.md) — A bordered surface with a header, a body and a footer — pressable when you give it something to do.
- [AstryxBadge](components/badge.md) — A small label: a status, a count, a category.
- [AstryxBanner](components/banner.md) — An inline message with a severity, announced when it appears.

## Data display

- [AstryxTabList](components/tab_list.md) — A strip of tabs that reports a value and owns no panel.
- [AstryxTable](components/table.md) — A typed data table with sorting, selection, row actions and three column-width strategies.

