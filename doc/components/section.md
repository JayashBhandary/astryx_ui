---
title: AstryxSection
description: A titled band of page content, with its own heading level and spacing.
component: true
group: App shell
source: lib/src/components/shell/section.dart
upstream: Section
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SectionDemoExample extends StatelessWidget {
  const SectionDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxSection(
      title: 'Environments',
      description: 'Where this project is deployed.',
      showDivider: true,
      actions: <Widget>[
        AstryxButton(
          label: 'New environment',
          size: AstryxButtonSize.sm,
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
      ],
      child: AstryxGrid(
        minWidth: 160,
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          for (final env in const <String>['production', 'staging', 'preview'])
            AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText(env),
            ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxSection(
  title: 'Environments',
  description: 'Where this project is deployed.',
  actions: <Widget>[
    AstryxButton(label: 'New environment', onPressed: create),
  ],
  child: const EnvironmentGrid(),
)
```

```text
AstryxSection
├── title       ← the heading. Its level is worked out, not given
│   ├── description ← under the title
│   └── actions     ← at the trailing edge of the heading row
└── child       ← the content
```

## The heading level looks after itself

**A section inside another section is one level deeper.** So a page assembled from parts nobody wrote together still produces an outline a screen reader can navigate — and getting that wrong is the commonest accessibility fault on a long page, because it is one nobody can see by looking at the screen.

```dart
class SectionNestingExample extends StatelessWidget {
  const SectionNestingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // No section here is told its level. A page assembled from parts nobody
    // wrote together still produces an outline a screen reader can navigate —
    // which is the fault this exists to prevent, and one nobody can see by
    // looking at the screen.
    return const AstryxSection(
      title: 'Environments',
      child: AstryxSection(
        title: 'Production',
        description: 'Heading level 3, without being told.',
        child: AstryxSection(
          title: 'Regions',
          description: 'And 4 here.',
          child: AstryxText('us-east-1, eu-central-1'),
        ),
      ),
    );
  }
}
```


The top level is 2, because 1 belongs to the page’s own title — usually in [AstryxLayout](layout.md)’s `header`. Pass `level` explicitly only when the nesting and the outline genuinely disagree; a section deeper than 6 stops there, where HTML stops and where a heading stops meaning anything.

> **Accessibility**
>
> The rule under the heading is decoration; the *level* is the structure. A screen-reader user navigates a page by heading level, so a section that looks like a sub-part and announces itself as a peer has lied about the shape of the page.

## Anchoring an outline

`headerKey` goes on the heading row, which is what an [AstryxOutline](outline.md) entry points at — both to know where the heading is and to have somewhere to scroll to.

### AstryxSection

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The section’s content. |
| `title` | `String?` | — | The heading. Null for a band that is grouped but not titled. |
| `description` | `String?` | — | A line under the title, saying what the section is for. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls at the trailing edge of the heading row. |
| `level` | `int?` | — | Overrides the heading level. Defaults to one deeper than the enclosing section, and to 2 at the top of a page. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The space between the heading block and the content. |
| `showDivider` | `bool` | `false` | Whether to draw a rule under the heading block. |
| `headerKey` | `Key?` | — | A key on the heading, for an `AstryxOutline` to find and scroll to. |


## Related

- [AstryxLayout](layout.md) — the page these sit in.
- [AstryxOutline](outline.md) — the same structure, read back as a table of contents.
- [AstryxCard](card.md) — for a band that is a *surface* rather than a part of the document.

