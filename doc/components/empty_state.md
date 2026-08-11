---
title: AstryxEmptyState
description: What a list, table or panel shows when it has nothing to show.
component: true
group: Data display
source: lib/src/components/data/empty_state.dart
upstream: EmptyState
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class EmptyStateDemoExample extends StatelessWidget {
  const EmptyStateDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxEmptyState(
      icon: const AstryxIcon(AstryxIconName.search),
      title: 'No deploys yet',
      description: 'Push to the main branch and the first one will show here.',
      actions: <Widget>[
        AstryxButton(
          label: 'Read the guide',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Import a project', onPressed: () {}),
      ],
    );
  }
}
```


## Usage

```dart
AstryxEmptyState(
  icon: const AstryxIcon(AstryxIconName.search),
  title: 'No matching deploys',
  description: 'Try a wider date range.',
  actions: <Widget>[AstryxButton(label: 'Clear filters', onPressed: clear)],
)
```

> **Careful**
>
> **An empty state is not an error.** Nothing has gone wrong when a new project has no deploys, so this does not announce itself, take a status colour, or borrow [AstryxBanner](banner.md)’s urgency. What it carries instead is the one action that ends the emptiness — the difference between "No results" and a screen a user can leave.

## Sizes

`compact` is for an empty state inside something — a card, a popover, a table body — where the standard one would push the container open.

```dart
class EmptyStateSizesExample extends StatelessWidget {
  const EmptyStateSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `compact` is for an empty state inside something — a card, a popover, a
    // table body — where the standard one would push the container open.
    return AstryxGrid(
      minWidth: 240,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxEmptyStateSize.values)
          AstryxCard(
            child: AstryxEmptyState(
              size: size,
              icon: const AstryxIcon(AstryxIconName.funnel),
              title: 'No matches',
              description: size.name,
              actions: <Widget>[
                AstryxButton(
                  label: 'Clear filters',
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```


## Where it goes

- [AstryxList](list.md) — as `empty`.
- [AstryxTable](table.md) — which shows its own "No data" when it has no rows.
- A page, when a whole screen has nothing on it yet.

> **Accessibility**
>
> The title is a level-3 heading: an empty state stands in for content, so it belongs in the outline where that content would have been. The icon is decorative and stays out of the semantics tree — the title carries the meaning.

### AstryxEmptyState

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `title` *(required)* | `String` | — | What is missing, in a few words. |
| `description` | `String?` | — | A line under the title, saying why, or what would fill it. |
| `icon` | `Widget?` | — | A decorative icon above the title. |
| `actions` | `List<Widget>` | `const <Widget>[]` | The way out: one action, or two at most. |
| `size` | `AstryxEmptyStateSize` | `AstryxEmptyStateSize.standard` | How much room the block takes. |
| `minHeight` | `double?` | — | A floor under the height, so a list’s height does not jump when rows arrive. |
| `maxWidth` | `double` | `380` | A ceiling on the text’s width, so the description stays readable. |


### AstryxEmptyStateSize

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `compact` | `AstryxEmptyStateSize` | — | For an empty state inside a card, a popover or a table body. |
| `standard` | `AstryxEmptyStateSize` | — | The default, for an empty page or a full-width panel. |


