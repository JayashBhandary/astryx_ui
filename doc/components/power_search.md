---
title: AstryxPowerSearch
description: A search input with structured filters alongside the free text.
component: true
group: Command & search
source: lib/src/components/search/power_search.dart
upstream: PowerSearch
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class PowerSearchDemoExample extends StatefulWidget {
  const PowerSearchDemoExample({super.key});

  @override
  State<PowerSearchDemoExample> createState() => _PowerSearchDemoExampleState();
}

class _PowerSearchDemoExampleState extends State<PowerSearchDemoExample> {
  AstryxSearchQuery _query = const AstryxSearchQuery();

  Iterable<({String name, String kind, String owner})> get _results =>
      _projects.where((project) {
        final text = _query.text.trim().toLowerCase();
        if (text.isNotEmpty && !project.name.toLowerCase().contains(text)) {
          return false;
        }
        return _query.filters.every((filter) => switch (filter.field) {
          'kind' => project.kind == filter.value,
          'owner' => project.owner == filter.value,
          _ => true,
        });
      });

  @override
  Widget build(BuildContext context) {
    // Filters are chips beside the text, not syntax inside it: nothing to
    // learn, nothing to mistype, and no error message to write.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxPowerSearch(
          query: _query,
          options: const <AstryxSearchFilterOption>[
            AstryxSearchFilterOption(
              field: 'kind',
              label: 'Kind',
              values: <String>['Service', 'Job', 'Doc'],
            ),
            AstryxSearchFilterOption(
              field: 'owner',
              label: 'Owner',
              values: <String>['ada', 'grace', 'linus'],
            ),
          ],
          onChanged: (query) => setState(() => _query = query),
        ),
        AstryxList(
          children: <Widget>[
            for (final project in _results)
              AstryxItem(
                label: project.name,
                description: '${project.kind} · ${project.owner}',
              ),
          ],
        ),
        if (_results.isEmpty)
          const AstryxEmptyState(
            title: 'Nothing matches',
            description: 'Remove a filter, or search for something else.',
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxPowerSearch(
  query: _query,
  options: <AstryxSearchFilterOption>[
    AstryxSearchFilterOption(
      field: 'status',
      label: 'Status',
      values: <String>['failed', 'running', 'succeeded'],
    ),
  ],
  onChanged: (query) => setState(() => _query = query),
)
```

## Chips, not syntax

The filters sit **beside** the text as chips rather than inside it as `status:failed`. Syntax in a search box is a thing a user has to learn, get wrong, and be told off about — and the error message for a mistyped query is a whole feature nobody budgets for.

The values are a closed list for the same reason. A power search whose filters accept free text is a query language, and a query language needs a grammar, a parser and an error message this component cannot write for you.

The filter menu is one menu with a **section per field**, not a flyout per field: the values are what the user came for, and a submenu puts them behind a hover a touch user cannot perform.

## What comes back

`AstryxSearchQuery` is the whole state — the free text and the filters together — so a caller has one object to hold, compare and put in a URL. It is `==` by value, which is what makes "did the search change" a question you can answer.

`Backspace` on empty text takes the last filter back, the same bargain [AstryxTokenizer](tokenizer.md) makes: it is the only way to undo one from the keyboard. The clear button takes the text and the filters at once, because clearing half a search is not a thing anybody wants.

> **Accessibility**
>
> The field announces **how many filters are applied** as its value, so a reader knows the search is narrowed before wondering why it found nothing. Each chip keeps its own node and its remove button is named after the filter it removes.

### AstryxPowerSearch

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `query` *(required)* | `AstryxSearchQuery` | — | What is being searched for now. |
| `options` *(required)* | `List<AstryxSearchFilterOption>` | — | The filters that can be added. |
| `onChanged` | `ValueChanged<AstryxSearchQuery>?` | — | Called whenever the text or the filters change. |
| `onSubmitted` | `ValueChanged<AstryxSearchQuery>?` | — | Called when the search is submitted from the keyboard. |
| `labelHidden` | `bool` | `true` | Hidden by default: a search field beside a magnifier is the one case where a visible label is redundant to everybody who can see it. |


### AstryxSearchQuery

A search, as one value.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `String` | `''` | The free text. |
| `filters` | `List<AstryxSearchFilter>` | `const <AstryxSearchFilter>[]` | The structured filters. |
| `isEmpty` | `bool` | — | Whether there is nothing to search for. |


### AstryxSearchFilter

One applied filter. `AstryxSearchFilterOption` is the offer — a field, its label and the values it takes.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `field` *(required)* | `String` | — | What is being filtered on. |
| `value` *(required)* | `String` | — | What it is filtered to. |
| `label` | `String?` | — | How to write it. Defaults to `field:value`. |
| `icon` | `AstryxIconName?` | — | A glyph on the chip. |


## Related

- [AstryxTokenChip](token.md) — the chips the filters are drawn as.
- [AstryxTypeahead](typeahead.md) — when the query is a lookup rather than a filter.
- [AstryxTable](table.md) — what a power search usually narrows.

