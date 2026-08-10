---
title: Accessibility
description: The rules the whole widget set is built to, in one place.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

These are not aspirations. Each one is enforced by the components themselves, and most are pinned by tests.

## Names are required, not optional

- `AstryxButton` takes a `label`, never a `child` — a button whose content is arbitrary is a button whose accessible name is a guess.
- `AstryxIconButton` requires a `label` even though it paints none.
- `AstryxCheckbox` requires a `label`; upstream does too, for the same reason.
- A pressable `AstryxCard` wants a `semanticsLabel`, or a screen reader announces its entire contents as the button’s name.
- `labelHidden` hides a label from sight and keeps it as the name. It is the right tool when a visible label would be redundant — never a reason to omit one.

## Focus

- The focus ring appears for keyboard focus and not for a click — CSS’s `:focus-visible`, ported.
- Overlays trap focus while open and return it to the trigger on close.
- `Escape` closes **one layer at a time**: a popover inside a dialog closes without taking the dialog with it.
- Composite controls are one tab stop, not one per child: a radio group, a tab strip and a menu are each entered once and navigated with arrows.

## Announcements

- Only errors interrupt. A `warning` or `success` banner and a field’s success message wait their turn — interrupting for good news is its own problem.
- A field’s description *and* its status message both become the control’s hint, joined rather than one winning.
- A `loading` button reports itself as disabled while the work is in flight.
- `AstryxBanner.announce: false` for a banner that is part of the page’s initial state and has nothing to announce.

## Nothing behind hover alone

- Table row actions are always visible. Upstream reveals them on hover; hover does not exist on touch.
- Every hover interaction has a gesture path — a tooltip opens on long-press and lingers, because the finger is over the thing it describes.
- Touch density raises every tap target to 48px, the strictest of the guidelines that apply.

## Colour is never the only signal

- Every status carries an icon as well as a fill.
- The ten categorical palettes are for *categories*, never severity: a colour-blind user tells error from success by icon and position.
- The `subtle` divider is roughly 1.1:1 and therefore decoration — never a control’s only visible boundary.

## Motion

Every animation goes through `AstryxMotion`, which honours `MediaQuery.disableAnimations`. Transitions become instantaneous; the spinner paints a complete ring instead of rotating; the indeterminate progress bar stops travelling. Nothing disappears — the state stays legible without the movement.

## Known defects, kept

> **Careful**
>
> Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error` — a 1.00:1 contrast failure. It is reproduced faithfully rather than corrected, and pinned by a test, because silently diverging from upstream is worse than a documented defect. An error [badge](../components/badge.md) is where it shows. Override the token if it affects you.

The status icons are stroked, not solid. Upstream fills them for legibility at small sizes; Lucide ships no filled variants. Swap the icon registry if this matters to you.

