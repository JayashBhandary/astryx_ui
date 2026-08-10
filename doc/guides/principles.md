---
title: Principles
description: What the design system optimises for, and the decisions that follow from it.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Astryx is a design system for internal tools: dense screens, long-lived software, people who use the same view every day and would rather it were fast than novel. Every decision below follows from that, and each one is taken once, here, rather than argued again at each call site.

## Fidelity beats improvement

Where this port and upstream disagree about a value, upstream wins. The token defaults, the scale expanders, the HCT colour model and the contrast maths are checked against the upstream test suite, so a theme defined in Dart resolves to the values the TypeScript version produces.

That holds even when upstream is wrong. The `stone` theme sets `--color-on-error` equal to `--color-error` — a 1.00:1 contrast failure — and the port reproduces it, pinned by a test, rather than quietly correcting it. A design system that renders one way in React and another in Flutter is two design systems; a documented defect is cheaper than a silent divergence, and a theme’s `tokens` map overrides it in one line.

## No component holds a value

Not a colour, not a padding, not a radius, not a duration, not a `TextStyle`. Every one is a token read from the theme at build time. That is the whole reason seven themes, two brightnesses, two densities and a custom accent are a configuration change rather than a rewrite — and the reason a widget you write yourself stays in step with the ones you did not.

The escape hatch is a token override, never a literal: `defineTheme` takes a `tokens` map that beats every generated value, so "our brand needs a tighter radius" stays inside the system instead of leaking a `BorderRadius.circular(6)` into a hundred files.

## Accessibility is construction, not review

A rule that is checked at review time is a rule that ships broken on a busy week. The components make the accessible thing the only thing that compiles instead: `AstryxButton` takes a `label` rather than a `child`, `AstryxIconButton` requires one even though it paints none, and `labelHidden` hides a label from sight while keeping it as the accessible name.

The same principle covers focus, announcements and colour: overlays trap focus and return it, `Escape` closes one layer at a time, only errors interrupt a screen reader, and every status carries an icon as well as a fill. [Accessibility](accessibility.md) is the full list.

## Pointer and touch are both first class

Not a mobile variant bolted on afterwards. Density resolves from the platform *and* the pointer precision `MediaQuery` reports, and touch grows the region that responds to a finger without growing the painted control — so a form does not reflow when someone plugs in a mouse.

The corollary is the strictest rule in the package: nothing important may live behind hover, because a third of the users have no hover at all. Table row actions stay visible where upstream reveals them; every hover interaction has a gesture path beside it. See [Density](density.md).

## Logical, never left and right

Components are written in start and end terms throughout, so right-to-left is a `Directionality` and nothing else — no mode to switch on, no mirrored copy of a widget, no page that works only in English. If an example looks wrong in RTL, the bug is in the widget. See [Right-to-left](rtl.md).

## Compose with Flutter, do not replace it

The widgets are built on `flutter/widgets` rather than Material, because inheriting Material’s colour, typography and spacing model would mean every widget spending its first ten lines neutralising defaults. But the theme is a value, not a global: `AstryxThemeProvider` works anywhere in a tree, including inside a `MaterialApp`, so one screen can adopt the design system without the application converting.

## Fewer components, finished

Upstream ships around a hundred components; roughly 30 are in scope for 1.0. The ones that are here are meant to be complete — keyboard, semantics, RTL, both densities, reduced motion — rather than to be many. Where two upstream components differ only by a prop they arrive as one: there is a single `AstryxCard`, and a non-null `onPressed` is what makes it pressable.

> **Note**
>
> Everything upstream ships that is not ported yet still has a page here, marked *Soon* in the sidebar. A missing route is indistinguishable from a component nobody has thought about; a placeholder says which one this is.

## The documentation is the package

This site is built out of `astryx_ui` — the navigation is a column of cards, the example frames are cards, the API references are tables. Every snippet under a `Code` tab is extracted from the widget rendered beside it by `tool/gen_snippets.dart`, so a snippet cannot drift from its preview, and a page that looks wrong in one of the eight themes is a bug you can see without leaving the page.

## Related

- [Design tokens](tokens.md) — the values everything resolves through.
- [Density](density.md) — pointer and touch, side by side.
- [Accessibility](accessibility.md) — the rules, and what enforces each.
- [Theming](theming.md) — the seven themes, and defining your own.

