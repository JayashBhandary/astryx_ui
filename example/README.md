# astryx_ui documentation site

A documentation site for `astryx_ui`, built with `astryx_ui`. Every component,
with prose, live examples, the source that produced them, and an API reference —
viewable in any of the eight themes, either brightness, both densities and both
text directions.

Live at **[astryxui.web.app](https://astryxui.web.app)**. Locally:

```sh
flutter run -d chrome     # or any other device
```

There is no Material here. The navigation is a column of pressable cards, the
example frames are cards, the Preview/Code switch is a tab list, the API
references are `AstryxTable`s. That is the point: if a widget is awkward to
build a real application with, this is where it shows.

## The one rule

**Every code block on the site is extracted from a real, compiling widget.**

Each example lives in `lib/examples/` inside a marked region:

```dart
// #example card_slots -> CardSlotsExample
class CardSlotsExample extends StatelessWidget {
  // …
}
// #end
```

`tool/gen_snippets.dart` reads those regions and writes two generated
libraries — one mapping each id to its source, one mapping it to a builder. The
page then renders the widget under `Preview` and the source under `Code`. They
cannot disagree, because they come from the same lines.

Run it after touching anything in `lib/examples/`:

```sh
dart run tool/gen_snippets.dart
```

## Markdown output

The page model in `lib/docs/pages/` is pure Dart — no `flutter` import — so a
plain Dart script can render the same documentation to markdown:

```sh
dart run tool/gen_docs_md.dart
```

That writes [`../doc/`](../doc/README.md): one file per component under
`components/`, the guides under `guides/`, and an index. Same content as the
site, same snippets, generated from the same source.

## Agent skill

```sh
dart run tool/gen_skill.dart
```

Writes [`../.claude/skills/astryx-ui/`](../.claude/skills/astryx-ui/SKILL.md) —
the same documentation shaped for an AI coding agent. `SKILL.md` carries the
rules, a widget-choosing table, the mistakes agents make, and an index;
`references/` carries a file per component group with one canonical snippet and
the property tables, plus `enums.md` — **every public enum and its values,
scraped from the package source at generation time**, which is how two wrong
enum names in this documentation were caught.

The curated half of that skill (the rules, the mistakes) lives in
`tool/gen_skill.dart`; everything else comes from the page model.

### Releasing it

The repository root is a Claude Code plugin marketplace —
`../.claude-plugin/marketplace.json` lists one plugin whose source is the
repository itself, and `../.claude-plugin/plugin.json` points its `skills` field
at `.claude/skills/`. So releasing the skill is releasing the repository:

1. Bump `version` in `../pubspec.yaml`.
2. Run `dart run tool/gen_skill.dart`. It regenerates the skill **and copies the
   package version into `plugin.json`** — that version is what decides whether
   installed users are offered an update, so it must not go stale.
3. `claude plugin validate ..` — checks both manifests.
4. Commit, push, and tag (`v0.0.3-dev`), so users can pin a release.

Users then run `/plugin marketplace add JayashBhandary/astryx_ui` and
`/plugin install astryx-ui@astryx-ui`, and `/plugin marketplace update` for
later versions.

## Layout

```text
lib/
├── main.dart              the app, and the preview harness the tests use
├── docs/
│   ├── model.dart         DocPage, DocBlock, DocApi — pure Dart
│   ├── pages.dart         the registry, plus previous/next resolution
│   ├── pages/             the content: one file per group
│   ├── snippets.g.dart    generated — every example's source
│   └── previews.g.dart    generated — every example's builder
├── docs_ui/               the chrome, built from astryx_ui
│   ├── docs_shell.dart    sidebar, top bar, page area
│   ├── doc_page_view.dart renders a DocPage
│   ├── example_block.dart the Preview / Code card
│   ├── code_block.dart    Dart highlighting, from theme tokens
│   ├── api_table.dart     the property tables
│   └── inline_markup.dart `code`, **bold**, [links](introduction)
└── examples/              one file per component, in marked regions
tool/
├── gen_snippets.dart      lib/examples/ → snippets.g.dart, previews.g.dart
├── gen_docs_md.dart       the page model → ../doc/
└── gen_skill.dart         the page model → ../.claude/skills/astryx-ui/
```

After changing any page or example, all three:

```sh
dart run tool/gen_snippets.dart && \
  dart run tool/gen_docs_md.dart && \
  dart run tool/gen_skill.dart
```

## Hosting

The site is deployed to Firebase Hosting at
[astryxui.web.app](https://astryxui.web.app) — site `astryxui`, project
`svt-b3a6c`.

The Hosting configuration is **not in version control** (`.gitignore` covers
`firebase.json`, `.firebaserc` and `.firebase/`), which also keeps it out of the
published pub archive. Recreate it with `firebase init hosting` from the
repository root, answering:

- public directory: `example/build/web`
- single-page app rewrite: yes
- site: `astryxui`

Worth adding by hand afterwards: a predeploy hook that builds the bundle, so a
deploy can never ship a stale one, and `no-cache` headers on `/`,
`**/index.html`, `flutter_bootstrap.js`, `flutter_service_worker.js`,
`main.dart.js`, `version.json` and `manifest.json`, so a redeploy is visible at
once. Leave everything else on Hosting's default hour — Flutter web asset URLs
are not content-hashed, so a long immutable TTL would serve stale asset
manifests after a deploy.

Then, from the repository root:

```sh
firebase deploy --only hosting:astryxui
```

## Tests

```sh
flutter test
```

Six checks, and they are cheap insurance rather than ceremony:

- the app boots;
- every example a page references exists in both generated maps;
- every extracted example is documented somewhere — no orphans;
- page ids are unique;
- **every page renders in the wide layout** without a layout error;
- **every one of the examples builds** without a layout error.

The last two are what catch an overflowing row in an example nobody has looked
at lately.

## Adding a component page

1. Write the examples in `lib/examples/<component>_examples.dart`, each in its
   own `// #example id -> WidgetName` region.
2. Run `dart run tool/gen_snippets.dart`.
3. Add a `DocPage` to the right file in `lib/docs/pages/`, referencing those ids
   with `DocExample('id')`.
4. Run `flutter test` — the orphan check will tell you if you missed one.
5. Run `gen_docs_md.dart` and `gen_skill.dart` to refresh the markdown and the
   agent skill.
