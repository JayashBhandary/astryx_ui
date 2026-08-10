---
title: astryx_ui
description: An unofficial Flutter port of Astryx, Meta’s design system for internal tools.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Astryx is a React and StyleX design system. `astryx_ui` reimplements it for Flutter: the token engine, the seven prebuilt themes, and a widget set built on `flutter/widgets` rather than Material.

> **Careful**
>
> Pre-alpha. Not affiliated with, endorsed by, or supported by Meta Platforms, Inc. The API is unstable.

## What this is

- **A faithful theme engine.** Astryx’s token defaults, scale expanders, HCT colour model and contrast maths, ported to Dart and verified against the upstream test suite. A theme defined here produces the same values the TypeScript version does.
- **All seven prebuilt themes** — neutral, matcha, stone, gothic, chocolate, y2k, butter.
- **Components built on `flutter/widgets`**, not Material. Every widget is themeable through the same token layer.
- **Every platform.** Pointer and touch are both first-class: dual density, platform-appropriate tap targets, and a gesture path for every hover interaction.

## What this is not

- A 1:1 port of all ~100 Astryx components. Roughly 30 are in scope for 1.0 — the ones on the left of this page.
- A Material replacement. It composes *with* Material: `AstryxThemeProvider` works inside a `MaterialApp`, which is the incremental adoption path.

## This site

The documentation you are reading is built from `astryx_ui` itself. The navigation is a column of ghost buttons, the example frames are cards, the Preview/Code switch is a tab list, the API references are tables. Use the controls at the top to view every page in any of the eight themes, either brightness, both densities and both text directions.

Every example is a real widget in `example/lib/examples/`, and the code under each `Code` tab is extracted from that file by `tool/gen_snippets.dart`. A snippet cannot drift from the preview beside it, because both come from the same lines.

## Start here

- [Installation](installation.md) — add the package and wrap your app.
- [Principles](principles.md) — what it optimises for, and what follows.
- [Theming](theming.md) — the seven themes, and defining your own.
- [Design tokens](tokens.md) — the values everything resolves to.
- [Density](density.md) — how pointer and touch differ.
- [AstryxButton](../components/button.md) — or just start reading components.

