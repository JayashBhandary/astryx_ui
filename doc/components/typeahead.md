---
title: AstryxTypeahead
description: A text field that suggests completions as you type.
component: true
group: Command & search
source: lib/src/components/search/typeahead.dart
upstream: Typeahead / TypeaheadItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TypeaheadDemoExample extends StatefulWidget {
  const TypeaheadDemoExample({super.key});

  @override
  State<TypeaheadDemoExample> createState() => _TypeaheadDemoExampleState();
}

class _TypeaheadDemoExampleState extends State<TypeaheadDemoExample> {
  final TextEditingController _query = TextEditingController();
  String? _picked;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Type "a". The field keeps focus while the arrows move a highlighted row,
    // so typing, correcting and choosing are one gesture.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTypeahead<String>(
          label: 'Project',
          description: 'Arrow keys move; Enter chooses; Escape closes.',
          controller: _query,
          onSelected: (name) => setState(() => _picked = name),
          source: (text) async {
            // A real source is a request. This one is a list and a small delay,
            // so the spinner and the debounce are visible.
            await Future<void>.delayed(const Duration(milliseconds: 180));
            return <AstryxTypeaheadItem<String>>[
              for (final project in _projects)
                if (project.name.toLowerCase().contains(text.toLowerCase()))
                  AstryxTypeaheadItem(
                    value: project.name,
                    label: project.name,
                    description: '${project.kind} · ${project.owner}',
                  ),
            ];
          },
        ),
        AstryxText(
          _picked == null ? 'Nothing chosen' : 'Chose $_picked',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxTypeahead<Project>(
  label: 'Project',
  controller: _query,
  source: (query) async => <AstryxTypeaheadItem<Project>>[
    for (final project in await api.search(query))
      AstryxTypeaheadItem(value: project, label: project.name),
  ],
  onSelected: _open,
)
```

[AstryxBaseTypeahead](base_typeahead.md) with this package’s own field and rows on it: a search glyph, a spinner while a request is in flight, a clear button, and an `AstryxItem` per suggestion.

## It is not a selector

> **Careful**
>
> An [AstryxSelector](selector.md) picks from a set it can **show** you; a typeahead searches a set it cannot — a thousand projects, every user, the whole log. If the options fit in a list, use the selector: it can be browsed, and this can only be queried. Reaching for a typeahead over twelve options hides all twelve behind a guess about what to type.

## After choosing

By default the chosen label replaces the query — a field left holding "atl" after picking "Atlas" reads as a failed search. `clearOnSelect` empties it instead, which is right for a search box that dispatches somewhere and comes back ready for the next query.

### AstryxTypeahead

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `TextEditingController` | — | The query being typed. |
| `source` *(required)* | `AstryxTypeaheadSource<AstryxTypeaheadItem<T>>` | — | Where suggestions come from. |
| `onSelected` | `ValueChanged<T>?` | — | Called with the value of the chosen suggestion. |
| `minQueryLength` | `int` | `1` | How many characters before the source is called. |
| `debounce` | `Duration` | `Duration(milliseconds: 200)` | How long to wait after a keystroke. |
| `clearOnSelect` | `bool` | `false` | Whether choosing empties the field. |
| `openOnFocus` | `bool` | `false` | Whether to search as soon as the field takes focus. |
| `emptyBuilder` | `Widget Function(context, query)?` | — | What the surface shows when a search returned nothing. |


### AstryxTypeaheadItem

One suggestion.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What choosing this produces. |
| `label` *(required)* | `String` | — | The visible text. |
| `description` | `String?` | — | A second line — what tells two similar labels apart. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `trailing` | `Widget?` | — | Content at the end of the row. |


## Related

- [AstryxBaseTypeahead](base_typeahead.md) — the engine, and the keyboard contract.
- [AstryxSelector](selector.md) — when the options can be shown.
- [AstryxPowerSearch](power_search.md) — when the query needs filters as well as text.

