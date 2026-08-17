# Contributing to astryx_ui

Thanks for looking. This is a small project with a specific way of working, and most of it exists to keep the
documentation from lying — almost everything a reader sees is generated from code that compiles. Knowing that
saves you the two mistakes everyone makes first.

## The shortest useful thing you can do

File an issue. There are four templates and they are worth using rather than routing around:

| Template | For |
| --- | --- |
| **Bug report** | A widget or the theme engine behaves incorrectly. The theme, brightness, density and text direction are most of the report. |
| **Feature request** | New behaviour on something that already exists. |
| **Component request** | A component the package does not have yet. Your use case decides the order. |
| **Show what you built** | You shipped something with the package. Screenshots of real screens are the most useful thing this project receives. |

## Two things to know before you write code

**The documentation is generated.** `doc/`, the live site, the code under every `Code` tab and the agent skill
in `.claude/skills/astryx-ui/` all come from `example/`. Editing a file in `doc/` does nothing — the next
generator run overwrites it. [`example/README.md`](../example/README.md) explains the whole pipeline; the short
version is that a documentation change starts in `example/lib/docs/pages/` or `example/lib/examples/`.

**Astryx is the reference.** Where this package and [Astryx](https://astryx.atmeta.com) disagree, Astryx wins,
even when Astryx is wrong: the `stone` theme's 1.00:1 `--color-on-error` is reproduced and pinned by a test
rather than corrected. A divergence is a bug; a faithfully reproduced defect is a documented limitation. What is
unlikely to be accepted is invention — a component Astryx does not have, or a "better" value than the one the
engine derives. Improvements to the design language belong upstream, where both implementations can inherit
them. Improvements to *this* implementation — a Dart API that fights Flutter, a missing controller hook, a
platform behaviour React never had to have — are exactly what this repository is for.

## Setup

```sh
git clone https://github.com/JayashBhandary/astryx_ui.git
cd astryx_ui
flutter pub get
(cd example && flutter pub get)
```

Run the documentation site, which is also the fastest way to see your change in every theme, both densities and
both directions:

```sh
cd example && flutter run -d chrome
```

## Repository layout

```
lib/src/
├── theme/          the token engine — scales, HCT, contrast, the prebuilt themes
├── components/     the widgets, grouped: action, forms, data, overlays, shell, chat, …
├── foundation/     focus-visible, density, overlay positioning, the pieces components share
└── utils/
doc/                GENERATED markdown — do not edit
example/
├── lib/examples/   one compiling widget per example, in `// #example` regions
├── lib/docs/pages/ the page model: prose, examples, API tables
└── tool/           the four generators
test/               package tests, mirroring lib/src/
.claude/skills/     GENERATED agent skill — do not edit
```

## Adding a component

The pages marked *Soon* in the sidebar are the list, and each one names the Astryx page it will be written from.
The loop is short because everything downstream of the widget is generated:

1. **Write the widget** under `lib/src/components/<group>/`, on `flutter/widgets` — not Material. No literal
   values: every colour, length, radius and duration comes from the theme.
2. **Test it** — the keyboard map, the semantics, both densities, both directions, and the token values against
   Astryx wherever there is a fixture to compare with.
3. **Add a real example** to `example/lib/examples/`, wrapped in an `// #example id -> Widget` region. The
   preview and the code block both come from it, so they cannot drift.
4. **Write the page** — a `DocPage` in `example/lib/docs/pages/`, replacing the stub in `pages/planned/`. Prose,
   examples, the API table.
5. **Export it** from `lib/astryx_ui.dart`.
6. **Run the generators and the tests.** `sitemap_parity_test.dart` will tell you if the Astryx page you claimed
   is not the one you documented.

```sh
cd example
dart run tool/gen_snippets.dart      # lib/examples/ → snippets.g.dart, previews.g.dart
dart run tool/gen_changelog.dart     # ../CHANGELOG.md → changelog.g.dart
dart run tool/gen_readme.dart        # ../README.md → readme.g.dart
dart run tool/gen_docs_md.dart       # the page model → ../doc/
dart run tool/gen_skill.dart         # the page model → ../.claude/skills/astryx-ui/
flutter test && (cd .. && flutter test)
```

Commit whatever the generators changed. A PR with stale generated files fails the parity test.

## What "finished" means here

Fewer components, finished, rather than many that are nearly right. A component is done when all of this is
true — which is also the review checklist, and the same list as in the pull request template:

- Every value is a token. No colour, padding, radius or duration is written into the widget.
- It is operable from the keyboard, and the focus ring is visible where it lands.
- It has an accessible name that cannot be omitted, and it announces state changes without interrupting for
  anything less than an error.
- It is correct in both densities, and nothing important is behind hover alone.
- It is logical throughout, so right-to-left is a `Directionality` and nothing else.
- It honours reduced motion without losing information.
- It reads correctly in every theme, in both brightnesses.
- Its limitations are written down, in the doc comment and on its page.

## Tests

```sh
flutter analyze                      # clean, no new warnings
flutter test                         # the package
(cd example && flutter test)         # the site, the snippets, the sitemap parity
```

Golden tests live in `test/goldens/`. If a change moves pixels on purpose, regenerate them with
`flutter test --update-goldens` and say so in the PR — a golden diff nobody explained is treated as a
regression.

## Changelog

Every user-visible change gets an entry in `CHANGELOG.md` under the unreleased heading, in
[Keep a Changelog](https://keepachangelog.com/) form. The site's changelog page is compiled from that file, so
the entry is the release note — write it for someone deciding whether to upgrade, not for the person who wrote
the diff.

## Pull requests

Branch off `main`, keep one change per PR, and fill in the template. Small PRs with a screenshot get merged;
large ones that touch a widget, its page, the goldens and the generators at once take a long time to review. If
you are about to spend a weekend on something, open an issue first and check the shape is right.

By contributing you agree your work is licensed under the repository's [MIT licence](../LICENSE).
