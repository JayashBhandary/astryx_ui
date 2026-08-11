# Changelog

All notable changes to `astryx_ui` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Forty-four new components, and the documentation for them. **Navigation is
complete**: every component upstream ships in that group is ported. Two
existing widgets changed — both fixes, both in **Fixed**.

### Added

- **`AstryxLink`**, with `AstryxLinkUnderline` — text that goes somewhere. An
  `href` is handed to the `AstryxLinkDelegate` and this package never decides
  what following means; an `onPressed` is called directly. `AstryxLink.span`
  puts one inside a sentence, the same wall `AstryxCode` runs into.
  - An external link says so **in its accessible name**, not only in its glyph:
    the user who cannot see the glyph is the one most disrupted by a window
    they did not expect. The underline is on by default for a related reason —
    in running text colour alone separates a link from an emphasised word, and
    for a colour-blind reader it separates nothing.
  - `visited` is the caller's to track. A browser knows a link's history and
    Flutter does not, so there is nothing here to read it from.
- **`AstryxSegmentedControl`**, with `AstryxSegment` — one choice out of a few,
  every label visible. **Keyboarded as an ARIA radiogroup**: one tab stop, the
  arrows move *and* choose, they wrap at both ends, both axes work, and the
  inline pair mirrors under RTL. It is not `AstryxTabList` (which switches what
  a page shows) and not `AstryxToggleButtonGroup` (settings that sit together),
  and it announces itself as the radio group it is.
- **`AstryxToolbar`** and `AstryxToolbarDivider` — a band of controls that is
  **one tab stop**. A formatting bar of twelve buttons is twelve presses to
  walk past otherwise, which is why the ARIA toolbar pattern exists.
  - The children stay ordinary traversable widgets, which is how Tab *enters*
    on the first one. What makes the band a single stop is that Tab pressed
    inside it leaves: the toolbar steps focus to its edge and lets Flutter's
    own traversal carry past. Nothing is asked of the children, so anything
    focusable can go in.
- **`AstryxMoreMenu`** — the "…" trigger and its menu as one widget, because
  that composition is the one people get subtly wrong: an unnamed trigger, or
  one opening a menu with no name of its own. One `label` is the trigger's
  name, its tooltip and the menu's. `AstryxBreadcrumbs` now uses it for its
  collapsed steps rather than assembling the same button by hand.
- **`AstryxTabMenu`** — a tab that opens a menu. Drawn as a tab, indicator and
  all, so a reader looking at a report still sees something in the strip
  claiming it; **announced as a menu button**, because telling a screen-reader
  user this is a tab and then opening a menu is a promise the widget cannot
  keep.
- **`AstryxPagination`** — page-at-a-time controls, **one-based** as they are
  to the person reading them. The ends are always shown and the middle gaps; a
  gap of exactly one page is drawn as the page, since "1 … 3" hides nothing and
  costs a press. The gap is not a button — it stands for a range, and a control
  that cannot say where it would take you is not worth offering.
  - The arrows **disable at the ends rather than disappearing**: a control that
    vanishes moves everything beside it. `AstryxPagination.pagesFor` is the
    arithmetic on its own, static and pure, so what a reader sees can be tested
    without a widget tree.
- `AstryxLocalizations.linkExternal`, `toolbarLabel`, `moreMenuLabel`,
  `paginationLabel`, `paginationPrevious`, `paginationNext` and
  `paginationPage`.

- **The navigation set**, on one shared model: `AstryxNavEntry` with
  `AstryxNavItem`, `AstryxNavSection` and `AstryxNavDivider`. The rail, the bar
  and the drawer take the *same* list, so a navigation written once can be
  shown three ways — which is what stops an application from having a rail and
  a drawer that disagree about where its pages are.
  - **`AstryxSideNav`** — upstream's `SideNav`, `SideNavSection`,
    `SideNavHeading`, `SideNavItem` and `SideNavCollapseButton` as one widget,
    three entry types and a button that appears the moment `onCollapsedChanged`
    is passed. The rows scroll and the `footer` does not, so a rail of forty
    destinations cannot push the account row off the bottom of the window.
    - **Collapsed, the labels leave the screen and not the semantics tree.**
      Each row keeps its label as its accessible name and gains a tooltip that
      shows on *focus as well as hover*. That is the only concession to hover
      in the whole widget set, and it is allowed only because the name is still
      announced and still reachable without a pointer.
  - **`AstryxTopNav`** — the same entries along a row. An item with `children`
    opens a menu rather than indenting them, an item with a `panel` opens that
    panel (upstream's mega menu, which is any widget here rather than four
    components), and a section becomes a menu named after the group: a bar has
    no room for a heading over a group, and a menu is exactly what holds one.
  - **`AstryxMobileNav`** and **`AstryxMobileNavToggle`** — the drawer and its
    button, ported from `MobileNav` and `MobileNavToggle`. The drawer is a real
    `AstryxOverlay`; the toggle with no controller drives the enclosing
    `AstryxAppShell`'s drawer, because two sources of truth for whether the
    navigation is open is one too many. Closing after a choice is the caller's:
    a drawer that closed itself would take a mis-tap as a navigation.
  - **`AstryxNavIcon`** — the fixed square a row reserves for its icon. The
    square is the point, not the icon: labels line up whether or not their
    neighbours have icons, and a collapsed rail keeps its glyphs on one axis.
    It carries the row's state too, taking `--color-icon-accent` when the row
    is the current destination.
  - **`AstryxNavHeadingMenu`** — the workspace switcher: the name of the thing
    you are looking at, and the way to look at a different one. Announced as
    one name — "Acme Corp, Production" — because that is one fact about where
    the user is.
- **`AstryxBreadcrumbs`**, with `AstryxBreadcrumb` — the trail back up a
  hierarchy. **It collapses in the middle, never at the ends**: the first step
  is the way out to the top and the last is where the user is, so dropping
  either to save room throws away the two the trail exists for. What is dropped
  goes into a menu where it was, and stays reachable.
  - The row is measured by a render object rather than counted, so the answer
    is right at every width, and the count settles for the reason
    `AstryxOverflowList`'s does. A step with no `onPressed` is a label rather
    than a link, because a link to the page you are on is a link that does
    nothing.
- `AstryxItem.labelHidden`, which is what a collapsed rail row is. The same
  escape hatch `AstryxCheckbox` has, and the same rule: never to skip a label.
- `AstryxLocalizations.navLabel`, `navCollapse`, `navExpand`, `navOpen`,
  `breadcrumbsLabel` and `breadcrumbsMore`.

- **`AstryxSection`**, with `AstryxSectionScope` — a titled band of page
  content. **The heading level looks after itself**: a section inside another
  section is one level deeper, so a page assembled from parts nobody wrote
  together still produces an outline a screen reader can navigate. That fault —
  an outline that jumps from `h2` to `h4`, or repeats `h2` for something that
  is plainly a sub-part — is the commonest accessibility defect on a long page,
  and the one nobody can see by looking at the screen. The top level is 2,
  because 1 belongs to the page's own title in `AstryxLayout.header`; nesting
  stops at 6, where HTML stops.
- **`AstryxResizeHandle`**, with `AstryxResizeEdge` — the drag target between
  two regions, ported from `ResizeHandle` and `useResizable`. It holds no size
  of its own: `size` in, `onResize` out, so the number lives in the state that
  also lays the region out.
  - **Operable from the keyboard**, which is the part hand-rolled resize
    handles almost always miss: Tab reaches it, the arrows move it by `step`,
    Home and End go to `min` and `max`, and it announces itself as a slider
    carrying the current size. `label` is required — nothing is painted on a
    handle, so without one a screen reader has a slider and no idea what it
    sizes.
  - `edge` is one value rather than an axis and a direction, because those two
    can be set inconsistently and this cannot. The inline edges mirror under
    RTL so the same physical drag grows the panel either way; the block edges
    never mirror.
- **`AstryxOutline`**, with `AstryxOutlineEntry` — the on-this-page contents.
  **What it tracks is where the anchors are, not what the scroll offset says**:
  an offset means nothing on its own, since a page of short sections and a page
  of long ones put the same number in different places. The active entry is the
  last one whose heading has passed the top of the viewport, with `topOffset`
  as the slack that stops it flickering between two.
  - An entry's `anchor` — usually an `AstryxSection.headerKey` — earns its keep
    twice: without it the outline cannot know where the heading is, and
    pressing the entry has nowhere to scroll to. Upstream gets both from the
    DOM id it links to.
  - The entry being read is marked by an accent rule *and* `selected` in the
    semantics tree, so it is not conveyed by colour alone.

- **`AstryxAppShell`**, with `AstryxAppShellController` and
  `AstryxAppShellScope` — the frame an application sits in: a full-width
  header, navigation beside the content, and the content itself. Below
  `compactBelow` the navigation moves behind a drawer, and **the drawer is a
  real `AstryxOverlay`** — it traps focus, closes on Escape or a press on the
  scrim, hands focus back to the button that opened it, and joins the same
  dismissal stack as every dialog and menu. Growing back out of the compact
  layout closes it, because a drawer left open would be a second copy of the
  navigation now sitting beside the content.
  - `AstryxAppShell.of(context)` is the port of `useAppShellMobile`: a header
    cannot know whether to draw a menu button without knowing where the
    navigation went, and that answer belongs to the shell.
  - `compactBelow` is a number, not an entry in a breakpoint table. The
    package still has no breakpoint system, and this does not introduce one:
    the width at which a particular navigation stops fitting is a fact about
    that navigation.
  - `header` and `sidebar` take any widget. `SideNav`, `TopNav` and `MobileNav`
    are not ported yet, and the shell does not wait for them.
- **`AstryxLayout`**, with `AstryxLayoutPanelSide` — the page inside the shell:
  a pinned header, a scrolling body, an optional panel beside it and a pinned
  footer. A page title that scrolls away takes the reader's place in the
  hierarchy with it, and a Save button that scrolls away is a Save button
  people cannot find — which is the whole reason this is a widget rather than a
  `Column`. The panel scrolls on its own, because one tied to the body's scroll
  position disappears while you are reading it.
  - Upstream's five components — `Layout`, `LayoutHeader`, `LayoutContent`,
    `LayoutPanel`, `LayoutFooter` — are slots here. A slot cannot be put in the
    wrong order, left out of its parent, or nested inside another by mistake.

- **`AstryxCode`** — a symbol or a value in the code family. Flutter has no
  inline element, so `AstryxCode.span` returns the same chip as an
  `InlineSpan` for `Text.rich`, middle-aligned rather than baseline-aligned
  because the chip carries padding of its own. This is the one place the port
  cannot follow upstream's shape, and the span is the bridge.
- **`AstryxCodeBlock`** — a fenced block with the language, a copy button and
  optional line numbers. **Nothing is highlighted**: upstream colours its
  blocks with a JavaScript tokeniser that has no counterpart here, and code
  coloured by a grammar that does not match the language is code that lies
  about what it means. `language` is a label the reader sees, not an
  instruction.
  - The copy button carries the whole string, including the lines scrolled out
    of sight, and reports back in place by becoming a tick for two seconds
    rather than raising a toast — a page of ten blocks that shouts once per
    copy is a page nobody reads.
  - Long lines scroll sideways rather than wrapping, because in code a line
    break is not a neutral event; `wrap: true` where the layout matters more.
    Line numbers are decoration: not copied, and not read aloud.
- **`AstryxBlockquote`** — a quotation with a rule down its reading-start edge,
  an optional `attribution` (the em dash is the widget's), and a `child` for
  the quotations that are not one paragraph of plain text.
- **`AstryxKbd`**, with `AstryxKbdSize` — one key cap or a chord of them.
  `AstryxKbd('K')` for the common case, `AstryxKbd.chord` for the rest. **The
  glyphs are the caller's**: this does not translate `Ctrl` to `⌘` on a Mac,
  because only the caller knows whether the shortcut is the platform's or the
  product's own. A chord is one semantics node, and `semanticsLabel` is what
  turns `⌘ ⇧ P` into a shortcut somebody can follow.
- `AstryxLocalizations.codeCopy` and `codeCopied`, for the code block's button.
  Separate from `textCopy`, which is the selection menu's own verb.
- **`AstryxItem`**, with `AstryxItemDensity` — the row the lists are built
  from: something at the reading-start edge, a label and a description, and
  something at the end. Ported from `Item`. A non-null `onPressed` makes it a
  button, the same rule `AstryxCard` follows; `selected` is a selection rather
  than a press state, and survives the pointer leaving. A disabled row **stays
  in the semantics tree** — a control that vanishes when it is disabled tells a
  screen-reader user the option does not exist rather than that it is
  unavailable.
- **`AstryxList`** — upstream's `List` and `ListItem`, where the item is
  `AstryxItem` and this is only the container: the dividers, the density every
  row inherits through a scope, and the `list`/`listItem` roles that let a
  screen reader say "Recent deploys, list, 3 items" before reading the first
  row. `empty` is what shows when there are no rows, because a list that
  renders nothing reads as a bug. It is a `Column`: it does not scroll and does
  not virtualise, the same limit `AstryxTable` carries.
- **`AstryxTreeList`**, with `AstryxTreeNode` — nested, expandable rows.
  **Keyboarded as an ARIA tree**: the whole tree is one tab stop, Down and Up
  move, Right opens a branch and then steps into it, Left closes it and then
  steps out to the parent, Home and End jump to the ends, and the inline arrows
  mirror under RTL. The arrows deliberately do not wrap, unlike
  `AstryxRadioList` — a tree is a hierarchy, and jumping from the last leaf
  back to the first root loses the reader's place.
  - Expansion and selection are carried as **ids**, not as flags on the nodes,
    so rebuilding the tree from fresh data does not lose which branches were
    open. Expansion is controlled (`expanded`) or uncontrolled
    (`initiallyExpanded`); selection is always the caller's, as on
    `AstryxRadioList`.
  - Pressing a leaf chooses it; pressing a branch opens or closes it *and*
    chooses it. A tree where clicking a folder does not select it is a tree
    where the folder can never be the answer.
- **`AstryxOverflowList`**, with `AstryxOverflowItem` — a row that measures
  itself and moves its tail into a menu. An item carries both a `child`, drawn
  while it fits, and a `label`, which names it in a real `AstryxDropdownMenu`
  row once it does not: **nothing is hidden that a user cannot get to**, and
  the items the menu stands in for leave the semantics tree so nobody hears the
  same list twice.
  - The count is only known during layout, so it reaches the label through a
    `ValueNotifier` rather than `setState`. The trigger's width depends on the
    count and the count depends on the trigger's width, but that circle only
    turns one way — a wider label hides more items, and hiding more never
    narrows the label — so the row settles within a frame or two of a resize.
- **`AstryxMetadataList`**, with `AstryxMetadataItem` and
  `AstryxMetadataListDirection` — the label-and-value pairs of a details panel,
  `stacked` or `inline`. A pair is one semantics node, so a screen reader reads
  "Owner, Ada Lovelace" rather than stopping between the two halves of one
  fact; `semanticsValue` is what a widget-valued pair announces, because a
  badge left to describe itself contributes one word of information.
- **`AstryxEmptyState`**, with `AstryxEmptyStateSize` — what a list, a table or
  a panel shows when it has nothing to show. **Not an error**: nothing has gone
  wrong when a new project has no deploys, so it does not announce itself, take
  a status colour, or borrow `AstryxBanner`'s urgency. The title is a level-3
  heading, standing in the outline where the missing content would have been,
  and the icon is decorative and excluded.
- `AstryxLocalizations.overflowMore` and `overflowMenuLabel`, for the overflow
  trigger. Deliberately not `multiSelectorMore`: that one names *chosen*
  options that are not shown, this one names items that did not fit, and the
  two are not the same sentence in every language.
- **`AstryxSelectableCard`**, with `AstryxSelectableCardControl` — a card that
  is also a checkbox or a radio, for a choice that needs more than a line of
  text. Ported from `SelectableCard`. The whole card is the target; Space and
  Enter both activate it, as they do on a pressable `AstryxCard`. Selection
  shows three ways at once — the control fills, the border takes the accent,
  and the surface takes `--color-accent-muted` — and the border and the tint are
  dropped when the card cannot be operated, the same rule `AstryxCheckboxList`
  applies to a checked row.
  - **A radio card reports nothing when it is already selected**, which is what
    a native radio does: reporting `false` would let a group end up with nothing
    chosen. A checkbox card deselects, as a checkbox does.
  - `label` is required and never painted, and the content keeps its own
    semantics nodes — the opposite of `AstryxCheckbox`, whose label *is* the
    whole of it. A card announced by its contents is a sentence nobody can act
    on.
  - Each card is its own tab stop. There is no shared `name` to group a set the
    way a browser groups native radios, so `AstryxRadioList` remains the control
    for four or more terse options.
- **`AstryxSlider`**, with `AstryxSlider.range`, `AstryxSliderMark`,
  `AstryxSliderOrientation` and `AstryxSliderValueDisplay` — ported from
  `packages/core/src/Slider/`. `min`/`max`/`step`, marks, `formatValue`, both
  orientations, `onChanged` during a drag and `onChangeEnd` when it settles. A
  range keeps its thumbs in order and no closer than `minStepsBetweenThumbs`
  steps; each thumb is its own tab stop and its own announced `slider` carrying
  the *formatted* value, plus increase and decrease actions for a switch or
  voice user.
  - Upstream is a native `input[type=range]`, so the keyboard map is written out
    here: arrows a step (mirrored under RTL), Page keys ten, Home and End the
    ends. A keyboard move fires `onChangeEnd` too, since there is no drag to
    end.
  - `valueDisplay: tooltip` shows nothing yet — upstream gets that bubble from
    the browser on hover. `text` is the visible-to-everyone alternative and is
    what the page demonstrates.
- **`AstryxMultiSelector`**, with `AstryxMultiSelectorTriggerDisplay` — the same
  `AstryxSelectorEntry` options as `AstryxSelector`, because upstream shares
  those types between the two as well. A `Set<T>` value, checkbox rows, and a
  list that **stays open** as options are ticked. `showSearch` filters and drops
  a heading whose options all filtered away; `showSelectAll` ticks everything
  and clears it when everything is ticked; the trigger shows tokens up to
  `maxBadges` then "+n more", or a count. The field announces *which* options
  are chosen rather than how many.
- **`AstryxComplexSelector`**, with `AstryxComplexSelectorState` — the headless
  half of upstream's selector family: this package draws the field, the trigger,
  the overlay, the focus trap and the barrier, and `surfaceBuilder` draws the
  contents. For a calendar, a swatch grid, a two-pane picker. Reporting a value
  deliberately does not close the surface, so a multi-step picker can stay open;
  upstream's four-argument render prop arrives as one state object.
- **`AstryxInputGroup`**, with `AstryxInputGroupText`,
  `AstryxInputGroupPosition` and `AstryxInputGroupScope` — inputs and affixes
  joined into one bordered control. The group carries the label, description and
  status for the row; each child learns its position from the scope and squares
  the corners that meet a neighbour, directionally, so a group mirrors under RTL
  without being told which way it runs. `AstryxInputContainer` reads that scope,
  which is how a plain `AstryxTextInput` joins a group without being changed.
- **`AstryxFormLayout`**, with `AstryxFormLayoutDirection` and
  `AstryxFormLayoutScope` — `vertical`, `horizontal` (equal columns) and
  `horizontalLabels`. The last one is the only one that does more than space
  fields out: `AstryxField` reads the scope and moves its label and description
  beside the control, collapsing back to a stack below upstream's own 480px.
  Upstream sizes that column to its widest label, which CSS grid does for free;
  `labelWidth` is the honest Flutter version rather than laying every label out
  twice.
- **`AstryxCheckboxList`**, with `AstryxCheckboxOption` and
  `AstryxCheckboxListDensity` — several independent choices under one label, one
  description and one validation state. Generic over the value type like
  `AstryxRadioList`, rather than upstream's `string[]`. Ported from
  `packages/core/src/CheckboxList/`: the checked-row tint, `compact` and
  `balanced` densities, optional dividers, per-row `description`, `trailing`,
  `enabled` and `loading`, and a group-wide `readOnly` that does *not* dim.
  - **Keyboarded as a checkbox group, not a radio group.** Every row is its own
    tab stop and Space toggles the focused one — the opposite of
    `AstryxRadioList`, whose whole group is one stop with the arrows moving
    inside it. A checkbox list built on the radio pattern swallows Tab and traps
    anyone using a keyboard, so a test pins the difference by counting
    traversable stops in both.
  - Upstream composes its own `List`/`ListItem`, which this port does not have.
    The rows are `AstryxCheckbox`es in a tinted, inset container instead, and
    the inset is paid whether a row is checked or not so nothing shifts sideways
    as rows are ticked.
- **`AstryxNumberInput`** — a numeric field over `AstryxTextInput`, ported from
  `packages/core/src/NumberInput/`. `min`, `max`, `step`, `integerOnly`,
  `units`, `showClear`, and a `num?` value so `integerOnly` yields `int`s and a
  fractional step yields `double`s without a second widget. Commits on a
  stepper, an arrow key, blur or Enter — never mid-keystroke.
  - **Out-of-range typing is rejected, not clamped**, which is upstream's
    `parseNumberInput` returning null rather than the nearest legal number. The
    text reverts and the refusal is announced through a live region
    (`AstryxVisuallyHidden`), because reverting in silence tells a screen-reader
    user nothing — WCAG 3.3.1. Pressing a *stepper* does stop at the boundary,
    as a browser's spinner does.
  - Upstream is an `<input type="number">`, so three behaviours it gets from the
    browser are written out here: the arrow keys stepping the value, the
    steppers themselves (drawn rather than left to a UA hover affordance —
    nothing important may live behind hover, and a thumb has no arrow keys), and
    refusing letters as they are typed. The wheel-changes-a-focused-number
    behaviour is deliberately **not** ported.
- **`AstryxFileInput`**, with `AstryxFile`, `AstryxFilePicker`,
  `AstryxFilePickRequest` and `AstryxFileInputMode` — the chooser, the chosen
  list, and the limits, ported from `packages/core/src/FileInput/` including
  `validateFiles` message for message and `formatFileSize` figure for figure.
  `accept` matches an extension, a `type/*` family or an exact MIME type;
  `maxSize` rejects; `maxFiles` truncates with a complaint; a caller's `status`
  beats the field's own so a server rejection is not overwritten locally.
  - **The dialog is a seam, not a feature.** Flutter ships no file picker and
    this package depends on no plugins, so `onPick` asks the application to open
    one — the same shape as `AstryxLinkDelegate`. `AstryxFile` is a description
    (name, optional size and MIME type, plus an untouched `handle`) rather than
    `dart:io`'s `File`, which does not exist on the web.
  - A file of **unknown** size passes a `maxSize` check: a reticent picker is
    not a large file.
  - `dropzone` mode is a zone, not a drop target. External file drag-and-drop
    needs a platform channel Flutter does not ship; the panel takes clicks,
    taps and the keyboard, and the page says so.
- Fourteen localised strings for the above, on `AstryxLocalizations`: the
  stepper names, the rejected-number announcement, the file prompts and the four
  file validation messages, and the multiple selector's count, tail,
  select-all row and no-matches line.
- **`AstryxToggleButton`** — a button with a sticky on state, for a toolbar
  control or a filter that stays down rather than for an action. Ported from
  upstream's `packages/core/src/ToggleButton/ToggleButton.tsx`: always a ghost
  button, `--color-overlay-pressed` as the pressed fill, the label shifting to
  semibold, `pressedIcon` for an outline-to-filled swap, and the pressed state
  coming from the group when it is in one. Reports through `onChanged` like
  every other stateful control here, not upstream's `onPressedChange`.
  - The pressed label's **width is reserved** so a toolbar cannot shuffle
    sideways as toggles are pressed. Upstream reserves it by rendering a second
    hidden copy of the label at semibold; ported literally that leaks — every
    toggle would answer `find.text('Bold')` twice, in your tests as well as
    these — so the port measures with a `TextPainter` instead and renders one
    `Text`. Same stable width, one node.
  - Upstream's `isIconOnly` arrives as **`labelHidden`**, the name the form
    controls already use for "keep the accessible name, drop the text". As
    upstream does, it squares the button and takes the label as its tooltip.
  - **Two upstream props are deliberately absent.** `pressedChangeAction` is a
    React transition with an optimistic pressed state and no Flutter
    counterpart — drive `pressed` and `loading` yourself, as with every other
    control. `children` is not ported because the label is the text here, as on
    `AstryxButton`.
- **`AstryxToggleButtonGroup`**, with `AstryxToggleButtonGroupScope` — several
  toggles acting as one control, the port of upstream's discriminated union on
  `type`. Two named constructors instead: `.single` takes a `String?` and
  clearing is reachable by pressing the button that is already on, `.multiple`
  takes a `Set<String>` and hands back a new set each time. Dart makes the
  wrong `onChanged` signature a compile error rather than a runtime surprise.
  A child's own `enabled` is ignored inside a group, which is upstream's
  behaviour (`group?.isDisabled ?? isDisabled`) reproduced and pinned rather
  than quietly improved; a grouped button with no `value` asserts in debug.
- Pages for both, in **Actions**, with six examples: a filter toggle, an
  icon-only watch button with an icon swap, single and multiple groups, a
  vertical group, and the four states side by side.
- **The five remaining guide pages**, which had been placeholders since the
  site was scaffolded. `Getting started` now holds no *Soon* badges at all;
  the three that remain there are the deliberate `N/A` omissions.
  - **Migration** — what maps from Material and Cupertino, and what actually
    differs about each: `IconButton` requiring a name, a dialog being a widget
    rather than a route, one radio *group* rather than a tile per option. Plus
    the habits that survive a migration and quietly undo it, how two theme
    systems behave in one tree, and an order of work that keeps the app
    running throughout.
  - **Working with AI** — the generated agent skill: installing it as a Claude
    Code plugin, what each reference file holds, why it is generated rather
    than written, and why a page that is not finished is never published to
    it.
  - **Themes** — the gallery upstream's `/themes` is, with the four new
    examples below. Also what actually differs between the eight (accent,
    type scale, corner radii, motion), that the named typefaces are not
    bundled by either implementation, and that `gothic` renders the same in
    both brightnesses because its tokens are single values rather than pairs.
  - **Changelog** — this file, rendered.
  - **Community** — where to report what, the fidelity rule that decides
    whether a divergence is a bug, the loop for contributing a component, and
    the checklist a component has to pass to be called finished.
- **`AstryxVisuallyHidden` has a page.** It was badged *Soon* while the widget
  had been exported since 0.0.1-dev — the placeholder was written from the
  upstream sitemap and never rechecked against the package. The page leads with
  the distinction the widget's own doc comment calls the most common false
  friend in the port: upstream's `VisuallyHidden` both names controls and
  announces changes, and only the second needs a widget here, because every
  control in this package takes its accessible name as a required parameter.
  Two examples: a live region announcing a character count, and proof that the
  hidden child measures `Size.zero`.
- `example/tool/gen_changelog.dart` — parses `CHANGELOG.md` into
  `lib/docs/changelog.g.dart` as documentation blocks. The changelog stays a
  single file at the repository root, where pub and GitHub look for it, and the
  site compiles it rather than keeping a second copy somebody has to remember
  to update.
- Four examples in `example/lib/examples/themes_examples.dart`: all eight
  themes side by side, each in both brightnesses, six colour tokens sampled
  from inside each one, and the same four controls rendered eight times.
- **Links that leave the site now open.** Every page carries them — the
  upstream page it ports, the repository, the issue tracker — and until now
  they were painted, underlined and inert, which reads as a failed click. The
  documentation app installs an `AstryxLinkDelegate`, so they go through the
  same seam an `AstryxButton(destination:)` uses; the web half is a conditional
  import in the shape of `url_strategy.dart`, and off the web it declines
  rather than guessing.

- **`AstryxOverlay`** — the scrim-and-layer primitive, ported from upstream's
  `Overlay`. The modal contract with no opinion about what is on the layer:
  scrim, focus trap with restore, Escape closing one layer rather than the
  stack, and an entry that honours reduced motion. `alignment` is what makes a
  sheet a sheet, so there is no separate component for one.
- **`AstryxAlertDialog`** — a dialog with the answers built in, and three
  deliberate differences from one: the barrier does not dismiss, there is no
  close button, and focus starts on **cancel** so an Enter pressed out of habit
  deletes nothing. `description` is required, because a confirmation whose
  consequence is left to the title cannot be consented to. `showCancel: false`
  makes it an acknowledgement.
- **`AstryxHoverCard`** — the preview a tooltip is too small to hold. It stays
  open while the pointer is *on the card*, which is the whole component: that is
  what lets the content hold a link or a button. `waitDuration` filters a mouse
  passing through, `exitDuration` is the grace period for crossing the gap. A
  long-press reaches it on touch, and that path alone arms a dismissing barrier
  since touch has no pointer-exit.
- **`AstryxContextMenu`** — the same `AstryxMenuEntry` rows as
  `AstryxDropdownMenu`, with the same keyboard model, raised by a secondary
  click at the pointer or by a long-press on touch. `maxWidth` bounds it because
  a menu anchored to a point has nothing else to bound it. Documented with what
  it cannot fix: a right-click is undiscoverable and has no keyboard
  equivalent, so nothing may live only there.
- **`AstryxCollapsible`**, with `AstryxCollapsibleController` — a disclosure
  whose **whole header** is the button, carrying `expanded` in its semantics
  rather than leaving a rotated chevron to say it. Collapsed content is not in
  the tree at all: no layout, no semantics, no focus stops behind a closed
  section.
- **`AstryxCollapsibleGroup`** — sections as one block, and `exclusive: true`
  for an accordion, where the group owns which one is open. Not the default, and
  documented as such: it saves space by removing the one thing a set of sections
  is good for.
- `AstryxLocalizations.alertDialogCancel` — "Cancel". Separate from
  `dialogClose`, which is the same gesture but not the same sentence.

### Changed

- **`AstryxDialog` is now `AstryxOverlay` plus a panel.** The portal, the
  dismissal stack, the focus trap, the barrier and the animation moved into the
  primitive, so the two cannot drift; `AstryxDialogController` extends
  `AstryxOverlayController` and gains `toggle()`. No behaviour changed — the
  Phase 9 dialog tests pass untouched.
- The menu surface and the row vocabulary moved out of `dropdown_menu.dart`
  into `menu_surface.dart` (internal) and `menu_entry.dart`, so the dropdown
  and the context menu render the same rows and arrow the same way. The public
  names are unchanged.
- The selection box and the block-box width rule are now shared rather than
  copied. `AstryxSelectionIndicator` (internal) is the bordered box the
  checkbox, the radio and the selectable card all fill — one copy of upstream's
  three hover percentages instead of three — and `AstryxBlockWidth` (internal)
  is the card's fill-a-bounded-width, shrink-to-fit-an-unbounded-one rule,
  moved out of `card.dart`. No pixel changed: the existing goldens pass
  untouched.
- `AstryxButtonSurface` takes an optional `selected`, which the toggle button
  passes and the other two buttons do not. Absent rather than false on a plain
  action, so nothing announces "not selected" about a Save button. Upstream
  spells it `aria-pressed`; Flutter's `toggled` flag is the switch's on/off, so
  `selected` carries it — the mapping `SegmentedButton` uses in the framework
  itself. Internal: `AstryxButtonSurface` is `@internal` and no call site
  outside the package can pass it.
- `gen_skill.dart` publishes every written page except `changelog` and
  `community`. An agent gains nothing from the release history or from how to
  file an issue, and the changelog alone would put every bullet of every
  release into the reference file it opens to learn what a token is.
- `sidebar_test.dart` picks a `planned` page rather than merely an unwritten
  one for its badge count. `Getting started` no longer has a `planned` page,
  and the old expression could open a group with nothing to count.

### Fixed

- **`AstryxInputGroup` exposed a latent layout fault in the affix.** Stretching
  the joined row handed every child an infinite height, which the affix's own
  minimum height then tried to honour and asserted on. The row lets each child
  take the height its size token gives it instead. Found by the tests, not by a
  consumer.
- **`AstryxMultiSelector`'s clear button announced as nothing**, for the same
  reason the file field's did an entry ago: an `ExcludeSemantics` around the
  whole trigger. Removed before it shipped, and now pinned by a test that
  reaches the button by name.
- **`AstryxTextInput`'s `leading` and `trailing` slots were invisible to
  assistive technology.** The whole input container sat inside an
  `ExcludeSemantics`, which had been there to stop the editable announcing its
  content twice — and took the slots with it. The clear button `showClear` draws
  therefore announced as nothing at all while staying perfectly clickable, and
  the same held for anything a caller put in either slot. Only the editable is
  excluded now. Found while building `AstryxNumberInput`, whose steppers live in
  that slot.
- The documentation site's API tables keyed their rows by property name, so a
  class documenting two constructors with a parameter of the same name — the
  new group's `onChanged`, once per constructor — crashed the page with a
  duplicate `GlobalKey`. Keyed by position now. No library code involved; it is
  listed because the first legitimate content of that shape found it.

## [0.0.6-dev]

Documentation and tooling only. No library code changed, so nothing here can
break a consumer.

### Added

- **Fourteen template pages.** Whole screens, assembled only from what the
  package exports and extracted from compiling widgets in
  `example/lib/examples/template_*.dart`: four sign-in screens (bare, carded,
  SSO, split), three forms (contact, two-column, payment), settings as a page
  and as a dialog, a centred hero, a record detail page, a dashboard, a table
  screen, and a theme showcase holding one of every component. Each page states
  what it is made of and why each control was chosen over the one next to it.
- **A monitor / phone switch on every preview.** The phone pins the example to
  390 logical pixels and draws the frame's edge, which is the only way to watch
  a `LayoutBuilder` reflow — a two-column form becoming one, a tile row
  restacking. Width only: touch density is a separate axis with its own picker.
  It is not drawn when the viewport is already about phone-width, and the frame
  gives way rather than overflowing if the window is narrowed after the fact.
  The choice sits on `DocsController` with the other pickers, so it is made once
  for every example on the page and survives navigation.
  The glyphs are Lucide's, reached directly by the documentation app:
  `AstryxIconName` names neither a monitor nor a phone, and it stays a
  transcription of upstream's `IconName` union rather than growing to suit this
  site.
- `example/lib/docs_ui/segmented.dart` — the button-group picker the top bar and
  the new width switch share, instead of the private copy the top bar had. It
  also names the group to a screen reader, so "Mobile" is a choice *about*
  something.

### Fixed

- The previous/next page footer overflowed below about 520 logical pixels: some
  page titles are long — `InternationalizationProvider` — and two of them will
  not sit side by side on a phone. The pair now stacks.
- `example/lib/docs/version.g.dart` had fallen a release behind `pubspec.yaml`;
  regenerating the snippets brings it back to the package version.

### Known limitations, now documented

Three layout traps found while building the templates, all of them the same
root cause — a widget that measures its children intrinsically cannot measure
the touch-target wrapper or a `LayoutBuilder` inside them, so they assert in
touch density:

- `AstryxText(truncateTooltip: true)` cannot be used inside an `AstryxTable`
  cell.
- An `AstryxGrid` cell cannot hold a wrapped row of interactive widgets, or an
  `AstryxTable`. Cells of text, badges and figures are fine.

## [0.0.5-dev]

Documentation, tooling and tests only. No library code changed, so nothing here
can break a consumer.

### Added

- **The page registry mirrors upstream.** Every page on `astryx.atmeta.com` now
  has a route here — 163 placeholders alongside the 37 written pages, across
  seventeen groups, including the ones that are entirely unwritten: Navigation,
  App shell, Chat & AI, Command & search, Date & time, Media, Providers, Hooks
  & controllers and Templates. Each placeholder carries a description, the
  upstream page it will be written from, and a `DocStatus` — `ready`, `stub`
  (ported, not written up), `planned` (not ported yet) or `notPlanned`
  (deliberately omitted). A missing route and a widget nobody has thought about
  are no longer indistinguishable.
- **A sidebar that survives two hundred pages.** Groups collapse, each showing
  how many pages it holds; the group containing the current page opens on load
  and on every navigation; a *Written pages only* switch hides the
  placeholders; a search expands every group so a match is never hidden in a
  collapsed one. Placeholders carry a status badge, and say *not written yet*
  in their accessible name, so a screen-reader user does not have to open a
  page to find out it is empty.
- **A sitemap parity test.** `example/test/upstream_pages.txt` is every URL in
  upstream's `sitemap.xml`, captured 2026-08-10; the test fails when a
  component upstream ships is claimed by no page here. The fixture lives beside
  the test rather than in the git-ignored `scrape/`, so it is present in a
  fresh clone.
- **A contrast test for the documentation site's own colours.** Every
  foreground the docs chrome paints over every background it paints it on, in
  all eight themes and both brightnesses, against WCAG 2.1 AA — 4.5:1 for body
  text, 3:1 for large text and control furniture. The package's existing
  contrast tests check the engine; this checks the choices.
- Sidebar tests covering the three behaviours the flat list did not have:
  staying collapsed, marking empty pages, and hiding them.
- `example/lib/docs/groups.dart` — the group names and the reference file each
  is published to, in one place. `tool/gen_skill.dart` carried its own private
  copy of that map, and a group added to a page file but forgotten there made
  the generator exit 1.

### Changed

- The generators publish written pages only. `doc/` gets no file for a
  placeholder; the index names it with its status instead of linking it. The
  agent skill omits a group whose pages are all placeholders entirely — an
  agent told about a widget the package does not export will call it, and the
  call will not compile.
- Inline `` `code` `` in the documentation renders as a padded, rounded chip
  rather than text with a background colour, which put the first and last
  character flush against the edge of the highlight.
- `upstream:` on a page now claims every upstream sub-component it absorbs —
  `Table / TableCell / TableHeaderCell / useTableSelection / …` — which is what
  lets the sitemap check tell an absorbed component from a missing one. Names
  are corrected where they were wrong, so the checkbox page ports
  `CheckboxInput` rather than `Checkbox`.
- Documentation spacing: more room above a heading than between paragraphs,
  more between list items than between the lines inside one, and a bullet
  column sized to its bullet rather than to `10.`.
- `scrape/` is git-ignored.

### Fixed

- The sidebar threw *The Scrollbar's ScrollController has no ScrollPosition
  attached* on desktop and web, where `PrimaryScrollController.shouldInherit`
  is false and the scroll view and its scrollbar disagreed about inheriting it.
  The sidebar owns its controller now.

## [0.0.4-dev]

### Added

- Package metadata for pub.dev: `homepage` and `documentation` now point at
  <https://astryxui.web.app>, where the documentation site is hosted.
- Installation instructions for the published package, in the README and on the
  site's installation page. The version constraint they quote is generated from
  `pubspec.yaml`, so a released constraint cannot fall behind the release.
- **The repository is a Claude Code plugin marketplace**, so the agent skill
  installs with `/plugin marketplace add JayashBhandary/astryx_ui` followed by
  `/plugin install astryx-ui@astryx-ui`. The plugin's version is copied from
  `pubspec.yaml` when the skill is generated, so it cannot fall behind a
  release either.

### Changed

- The documentation site is deployed to Firebase Hosting at
  <https://astryxui.web.app>. The Hosting configuration is deliberately not in
  version control, and so is absent from the published archive; the deploy
  command and the target it needs are documented in `example/README.md`.

### Fixed

- The README linked a `dev/` directory that is not part of this repository, so
  five links 404'd on GitHub and on pub.dev. They now point at the
  documentation, the changelog, or the issue tracker.
- The README and the installation page still said the package was unpublished.

## [0.0.3-dev]

Documentation only. No library code changed, so nothing here can break a
consumer.

### Added

- **A documentation site**, in `example/`. Every component with prose, live
  examples, the source that produced them, and an API reference — viewable in
  any of the eight themes, either brightness, both densities and both text
  directions. Built from `astryx_ui` itself, with no Material anywhere: the
  navigation is a column of pressable cards, the example frames are cards, the
  Preview/Code switch is an `AstryxTabList`, the API references are
  `AstryxTable`s. Pages are addressable by URL fragment on the web.
- **`doc/`** — the same content as markdown: 30 component pages under
  `components/`, seven guides under `guides/` (installation, theming, design
  tokens, density, right-to-left, accessibility), and an index. Generated from
  the page model by `example/tool/gen_docs_md.dart`.
- **A skill for AI coding agents**, in `.claude/skills/astryx-ui/`. The rules
  the widget set is built to, a component index, per-group API references, every
  public enum's values, and the mistakes a generator makes without them.
  Generated from the same source by `example/tool/gen_skill.dart`.
- **Snippet extraction.** Every code block in the site, the markdown and the
  skill is lifted from a real, compiling widget in `example/lib/examples/` by
  `example/tool/gen_snippets.dart`. A snippet cannot describe something the
  package does not do, because the preview and the code come from the same
  lines.
- Example tests that render every page and build all 156 examples, so a layout
  error in a documented example fails the suite rather than being found by a
  reader.

### Changed

- `example/` is the documentation site rather than a gallery of demo pages. The
  theme, brightness, density and direction pickers survive; the demo and gallery
  scaffolding they lived in does not.

## [0.0.2-dev]

### Fixed

- `AstryxCard` no longer asserts `BoxConstraints forces an infinite width`
  when given an unbounded width — inside a `Row`, an `AstryxHStack`, or a
  horizontal list. It fills a bounded width as before and shrinks to fit an
  unbounded one, matching how a block box sizes itself in CSS.

## [0.0.1-dev]

First development preview. The API is unstable and may change without a major
version bump until 0.1.0.

### Added

- Package scaffold: pubspec, lint configuration, directory layout, license and
  attribution files.
- Token layer: colour primitives (OKLCH, RGBA, CSS colour parsing, light/dark
  pairs) and the full token set — colour, spacing, radius, size, border,
  shadow, duration, ease, font weight, text size and typography tokens.
- Theme engine: `defineTheme`, the token resolver, scale expansion for colour,
  type, radius and motion, contrast and HCT helpers, style overrides, syntax
  themes and the theme registry.
- Theme runtime: `AstryxThemeData`, `ResolvedTokenSet`, `AstryxTheme`,
  `AstryxShadow`, font stacks, token-to-Flutter conversions, and per-component
  theme classes.
- Prebuilt themes: neutral, stone, butter, chocolate, gothic, matcha and y2k.
- App layer: `AstryxApp` and `AstryxThemeProvider`.
- Foundation: density, focus ring, focus trap, focus-visible tracking, link
  delegate, motion, overlay positioning and stack, RTL helpers, semantics,
  size scope, states controller and tap targets.
- Components — layout and typography (stack, grid, center, divider, heading,
  text, icon), actions (button, icon button, button group), feedback
  (progress bar, skeleton, spinner), forms (text input, checkbox, radio list,
  selector, switch, toggle row, field), overlays (dialog, dropdown menu,
  popover, toast, tooltip, anchored overlay), surfaces (badge, banner, card,
  palette) and data display (table, tab list).
- Icon registry backed by Lucide, mirroring Astryx's semantic icon names.
- Localizations via `AstryxLocalizations`.
- Secondary entry point `package:astryx_ui/theme.dart` for the theme layer
  without components.

[Unreleased]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.6-dev...HEAD
[0.0.6-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.5-dev...v0.0.6-dev
[0.0.5-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.4-dev...v0.0.5-dev
[0.0.4-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.3-dev...v0.0.4-dev
[0.0.3-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.2-dev...v0.0.3-dev
[0.0.2-dev]: https://github.com/JayashBhandary/astryx_ui/compare/v0.0.1-dev...v0.0.2-dev
[0.0.1-dev]: https://github.com/JayashBhandary/astryx_ui/releases/tag/v0.0.1-dev
