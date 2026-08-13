---
title: Working with AI
description: The generated agent skill, what it contains, and how to keep it current.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

An agent writing `astryx_ui` code fails in a particular way: it writes Material. It reaches for `ElevatedButton`, pads with `EdgeInsets.all`, gives an icon button no name, and hides the row actions behind hover — all of it plausible, all of it wrong here. The package ships a skill to stop that, and the skill is generated from the same pages you are reading.

## Install it

The repository is a Claude Code plugin marketplace, so the skill installs in two commands:

```text
/plugin marketplace add JayashBhandary/astryx_ui
/plugin install astryx-ui@astryx-ui
```

Pin a release by appending a tag — `JayashBhandary/astryx_ui@v0.0.6-dev` — and take later ones with `/plugin marketplace update`. The plugin’s version is copied from `pubspec.yaml` by the generator, so the skill you install and the package you depend on cannot silently be different releases.

Not using Claude Code? Copy `.claude/skills/astryx-ui/` into your own project, or point the agent at `doc/`, which is this site as plain markdown. Inside the repository itself the skill loads whether or not the plugin is installed.

## What is in it

| File | Holds |
| --- | --- |
| `SKILL.md` | The short half: setup, the rules that must not be broken, a table for choosing between two similar components, the mistakes a generator makes without it, and an index of every component. |
| `references/guides.md` | The guide pages — tokens, colour, typography, density, RTL, accessibility. |
| `references/*.md` per group | One file per sidebar group — actions, forms, overlays, surfaces, data, layout, status, templates. Each component has a canonical snippet and its full property table. |
| `references/enums.md` | Every public enum and its values, scraped from the package source. The names are not always the obvious ones, and an invented variant does not compile. |
| `references/patterns.md` | Whole screens: a form in a card, a table with row actions, a destructive flow, a settings list. |

> **Note**
>
> Only written pages are published to it. A component that is stubbed or still *Soon* is left out entirely, because an agent told about a widget the package does not export will call it, and the call will not compile.

## Why it is generated

The pages in `example/lib/docs/pages/` are pure Dart — no `flutter` import — which is what lets three different generators read them on the plain Dart VM. This site, the markdown in `doc/`, and the skill are three renderings of one registry, so they cannot describe different APIs. Hand-written agent instructions rot; these go stale only if the documentation does.

```bash
cd example
dart run tool/gen_snippets.dart    # examples -> snippets + previews
dart run tool/gen_changelog.dart   # CHANGELOG.md -> the changelog page
dart run tool/gen_docs_md.dart     # pages -> ../doc/
dart run tool/gen_skill.dart       # pages -> ../.claude/skills/
```

## Getting a useful answer

The skill loads on relevance, so naming the package in the request is usually enough — "build the settings screen with `astryx_ui`" rather than "build a settings screen". Two more things are worth asking for explicitly:

- **A review, not just code.** "Check this file against the astryx_ui rules" catches the literals and the missing labels that compile perfectly well.
- **A component choice, with the reason.** "Selector or dropdown menu here?" — the skill carries the table that answers it, and the answer is about values versus commands.

What it will still not do is invent a component. If the answer is that the package has no navigation bar yet, that is the honest answer, and the [Migration](migration.md) page says what to do instead.

> **Careful**
>
> Pre-alpha: the API changes between releases. Pin the plugin to the tag matching the version in your `pubspec.yaml`, or the agent will confidently write against a package you are not using.

## Upstream’s answer, and why this differs

Astryx ships a Node CLI for agents and scaffolding, with editor integrations around it. There is no Dart equivalent and none is planned: a generated skill covers the same ground without a second toolchain in a Flutter project. Both upstream pages are here, marked *N/A* — [The Astryx CLI](astryx_cli.md) and [CLI integrations](cli_integrations.md).

## Related

- [Principles](principles.md) — the reasoning the rules compress.
- [Accessibility](accessibility.md) — the rules themselves.
- [Migration](migration.md) — what an agent trained on Material must unlearn.
- [Community](community.md) — the repository the skill is released from.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Working+with+AI&component=Docs%3A+Working+with+AI) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Working+with+AI&area=Docs%3A+Working+with+AI) — both templates arrive with the page filled in.
