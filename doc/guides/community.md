---
title: Community
description: The repository, the issue tracker, and how to contribute a component.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

This is an unofficial port, maintained in the open by one person. There is no forum, no chat and no support contract — the repository is the whole of it, and an issue is the fastest way to be heard.

| Where | For |
| --- | --- |
| [The repository](https://github.com/JayashBhandary/astryx_ui) | The package, this site, the tests and the generators. |
| [Issues](https://github.com/JayashBhandary/astryx_ui/issues) | Bugs, divergences from upstream, and a component you need that is still marked *Soon*. |
| [pub.dev](https://pub.dev/packages/astryx_ui) | Releases, the API reference generated from the source, and the version constraint to copy. |
| [Upstream](https://astryx.atmeta.com) | Meta’s own Astryx: the React design system this ports, and the reference every disagreement is settled against. |

## Reporting something

A widget bug in this package is nearly always a bug in one configuration and not another, so the configuration is most of the report:

- The **theme**, the **brightness**, the **density** and the **text direction** — the four pickers at the top of this site. Reproduce it here first if you can; a page URL plus four settings is a complete report.
- The **platform** and the Flutter version, from `flutter doctor`.
- The smallest widget tree that shows it. The package has no runtime configuration to rule out, so a small tree really is enough.
- **What upstream does.** If `astryx.atmeta.com` behaves the same way, it is fidelity rather than a bug — see below.

> **Note**
>
> Where this port and upstream disagree, upstream wins, even when upstream is wrong: the `stone` theme’s 1.00:1 `--color-on-error` is reproduced and pinned by a test rather than corrected. A divergence is a bug; a faithfully reproduced defect is a documented limitation. [Principles](principles.md) explains why that trade is made.

## Contributing a component

The pages marked *Soon* in the sidebar are the list, and each one names the upstream page it will be written from. The loop is short because everything downstream of the widget is generated:

1. Write the widget under `lib/src/components/<group>/`, on `flutter/widgets`. No literal values — every colour, length, radius and duration comes from the theme.
2. Test it: the keyboard map, the semantics, both densities, both directions, and the token values against upstream where there is a fixture to compare with.
3. Add a real example to `example/lib/examples/`, wrapped in an `// #example id -> Widget` region. The preview and the code block both come from it, so they cannot drift.
4. Write the page: a `DocPage` in `example/lib/docs/pages/`, replacing the stub in `pages/planned/`. Prose, examples, the API table.
5. Run the generators and the tests. The parity test will tell you if the upstream page you claimed is not the one you documented.

```bash
cd example
dart run tool/gen_snippets.dart
dart run tool/gen_docs_md.dart
dart run tool/gen_skill.dart
flutter test && (cd .. && flutter test)
```

## What "finished" means here

Fewer components, finished, rather than many that are nearly right. A component is done when all of this is true — which is also the review checklist:

- Every value is a token. No colour, padding, radius or duration is written into the widget.
- It is operable from the keyboard, and the focus ring is visible where it lands.
- It has an accessible name that cannot be omitted, and it announces state changes without interrupting for anything less than an error.
- It is correct in both densities, and nothing important is behind hover.
- It is logical throughout, so right-to-left is a `Directionality` and nothing else.
- It honours reduced motion without losing information.
- It reads correctly in all eight themes, in both brightnesses.
- Its limitations are written down, in the doc comment and on its page.

What is unlikely to be accepted is invention: a component upstream does not have, or a "better" value than the one the engine derives. The value of a port is that it is one. Improvements belong upstream, where both implementations can inherit them.

## Licence

MIT. Not affiliated with, endorsed by, or supported by Meta Platforms, Inc. — the name and the design decisions are theirs, the Dart is not. The repository’s `NOTICE` records what is derived from upstream and under what terms.

## Related

- [Principles](principles.md) — the trades this project has already made.
- [Changelog](changelog.md) — what shipped, and what broke.
- [Working with AI](working_with_ai.md) — the generators, and the skill they produce.

