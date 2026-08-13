<!-- Thanks for this. CONTRIBUTING.md has the full checklist; this is the short form. -->

## What this changes

<!-- One paragraph. If it closes an issue, write "Closes #123". -->

## Type

- [ ] New component
- [ ] Fix to an existing component
- [ ] Theme engine or tokens
- [ ] Documentation, examples, or the generators
- [ ] Tooling / repository plumbing

## Checklist

- [ ] **Every value is a token.** No colour, padding, radius, duration or font size is written into the widget.
- [ ] **Keyboard operable**, and the focus ring is visible where it lands.
- [ ] **Accessible name** that cannot be omitted; state changes are announced without interrupting for anything less than an error.
- [ ] **Correct in both densities**, and nothing important is behind hover alone.
- [ ] **Logical throughout** — right-to-left is a `Directionality` and nothing else.
- [ ] **Reduced motion** is honoured without losing information.
- [ ] **Reads correctly in all the themes**, in both brightnesses.
- [ ] **Limitations are written down**, in the doc comment and on the component's page.
- [ ] Behaviour is checked against [Astryx](https://astryx.atmeta.com) where there is something to check against.

## Generated files

<!-- The docs, snippets and agent skill are generated. If you touched a widget, an example or a page, run these
     and commit what changes — a PR whose generated files are stale will fail the parity test. -->

- [ ] Ran the generators, and committed what they changed:

```sh
cd example
dart run tool/gen_snippets.dart && \
  dart run tool/gen_changelog.dart && \
  dart run tool/gen_docs_md.dart && \
  dart run tool/gen_skill.dart
```

- [ ] `flutter analyze` is clean
- [ ] `flutter test && (cd example && flutter test)` passes
- [ ] `CHANGELOG.md` has an entry under the unreleased heading

## Screenshots

<!-- For anything visual: light and dark, and both densities if the change touches layout. -->
