---
title: AstryxOutline
description: An on-this-page table of contents, tracking the reader’s position.
component: true
group: App shell
source: lib/src/components/shell/outline.dart
upstream: Outline
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class OutlineDemoExample extends StatefulWidget {
  const OutlineDemoExample({super.key});

  @override
  State<OutlineDemoExample> createState() => _OutlineDemoExampleState();
}

class _OutlineDemoExampleState extends State<OutlineDemoExample> {
  final ScrollController _scroll = ScrollController();
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    'setup': GlobalKey(),
    'usage': GlobalKey(),
    'tokens': GlobalKey(),
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scroll the page, and the outline follows: what it tracks is where the
    // headings are, not what the scroll offset says.
    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final section in const <List<String>>[
                    <String>['setup', 'Setup'],
                    <String>['usage', 'Usage'],
                    <String>['tokens', 'Tokens'],
                  ])
                    AstryxSection(
                      title: section[1],
                      headerKey: _anchors[section[0]],
                      child: const AstryxText(
                        'Enough copy to push the next heading past the top of '
                        'the viewport, which is the event the outline is '
                        'listening for.\n\n'
                        'Scroll on, and the entry beside this one takes the '
                        'accent rule.',
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 160,
            child: AstryxOutline(
              label: 'On this page',
              controller: _scroll,
              entries: <AstryxOutlineEntry>[
                for (final section in const <List<String>>[
                  <String>['setup', 'Setup'],
                  <String>['usage', 'Usage'],
                  <String>['tokens', 'Tokens'],
                ])
                  AstryxOutlineEntry(
                    id: section[0],
                    label: section[1],
                    anchor: _anchors[section[0]],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxOutline(
  controller: _scroll,
  entries: <AstryxOutlineEntry>[
    AstryxOutlineEntry(id: 'setup', label: 'Setup', anchor: _setupKey),
    AstryxOutlineEntry(id: 'usage', label: 'Usage', anchor: _usageKey),
  ],
)
```

## What it tracks

**Where the anchors are, not where the scroll offset is.** An offset means nothing on its own — a page of short sections and a page of long ones put the same number in different places — so the active entry is the last one whose heading has passed the top of the viewport, with `topOffset` as the slack that stops it flickering between two.

An entry’s `anchor` earns its keep twice: without it the outline cannot know where the heading is, and pressing the entry has nowhere to scroll to. [AstryxSection](section.md)’s `headerKey` is what usually goes there. Upstream gets both from the DOM id it links to.

| Give it | And it |
| --- | --- |
| a `controller` | follows the reader by itself. |
| an `activeId` | marks that entry instead, whatever the scroll position says — for an outline driven by a router. |
| neither | is a list of links, and nothing is marked. |
| an `onSelected` | reports the press instead of scrolling, for a caller that navigates rather than scrolls. |

> **Accessibility**
>
> The entry being read is marked two ways: the accent rule down its edge and `selected` in the semantics tree — so it is not conveyed by colour alone, and a screen-reader user is told where they are without reading back up the page.

### AstryxOutline

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxOutlineEntry>` | — | The headings, in the order they appear on the page. |
| `controller` | `ScrollController?` | — | The scroll view the anchors live in. Given one, the outline tracks the reader by itself. |
| `activeId` | `String?` | — | Marks an entry active, whatever the scroll position says. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the reader chose. Null scrolls to the anchor instead. |
| `label` | `String?` | — | The outline’s accessible name. |
| `topOffset` | `double` | `24` | How far below the top of the viewport a heading counts as reached. |


### AstryxOutlineEntry

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` *(required)* | `String` | — | This entry’s identity, unique within the outline. |
| `label` *(required)* | `String` | — | The heading text, as it appears in the outline. |
| `level` | `int` | `2` | The heading level, which sets the indent. |
| `anchor` | `GlobalKey?` | — | A key on the heading this entry points at. |


## Related

- [AstryxSection](section.md) — what the entries point at.
- [AstryxLayout](layout.md) — its `panel` is where an outline usually goes.

