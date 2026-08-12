---
title: AstryxBaseTypeahead
description: The unstyled typeahead the other search inputs are built from.
component: true
group: Command & search
source: lib/src/components/search/base_typeahead.dart
upstream: BaseTypeahead
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BaseTypeaheadDemoExample extends StatefulWidget {
  const BaseTypeaheadDemoExample({super.key});

  @override
  State<BaseTypeaheadDemoExample> createState() =>
      _BaseTypeaheadDemoExampleState();
}

class _BaseTypeaheadDemoExampleState extends State<BaseTypeaheadDemoExample> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // The engine with a field and rows of the caller's own: a token chip per
    // suggestion rather than a list row, which the styled one cannot draw.
    return AstryxBaseTypeahead<String>(
      controller: _query,
      minQueryLength: 0,
      openOnFocus: true,
      onSelected: (owner) => _query.clear(),
      source: (text) async => <String>[
        for (final owner in <String>{
          for (final project in _projects) project.owner,
        })
          if (owner.contains(text.toLowerCase())) owner,
      ],
      headerBuilder: (context, state) => Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing2)),
        child: AstryxText(
          state.suggestions.isEmpty ? 'No owners' : 'Owners',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
      fieldBuilder: (context, state) => AstryxTextInput(
        label: 'Owner',
        controller: state.controller,
        focusNode: state.focusNode,
        placeholder: 'Focus me',
        leading: const AstryxIcon(
          AstryxIconName.search,
          size: AstryxIconSize.sm,
          color: AstryxIconColor.secondary,
        ),
      ),
      itemBuilder: (context, owner, state) {
        final active = state.isActive(state.suggestions.indexOf(owner));

        return Padding(
          padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing1)),
          child: AstryxFocusRing(
            focused: active,
            borderRadius: theme.borderRadius(AstryxRadiusToken.full),
            child: AstryxTokenChip(owner, onPressed: () => state.select(owner)),
          ),
        );
      },
    );
  }
}
```


It owns the parts that are the same whatever the thing looks like — the query, the debounce, the in-flight request, the keyboard, the overlay and the announcements — and leaves the field and the rows entirely to `fieldBuilder` and `itemBuilder`.

## The field never loses focus

Arrow keys move an **active index** inside the surface while the caret stays where it is. That is the ARIA combobox pattern, and the only arrangement in which typing, correcting and choosing are one gesture — a suggestion list that steals focus makes the user tab back to keep typing.

| Key | Does |
| --- | --- |
| `↑` / `↓` | Moves the active row, and scrolls it into view. |
| `Enter` | Chooses the active row — and is **left to the form** when there is none, because a typeahead must not swallow the key that submits the search. |
| `Esc` | Closes the surface and nothing else: the query stays, and the dialog behind it stays open. |

## Requests

- `debounce` is what makes a typeahead over a network affordable: without it, a request per keystroke is exactly what you get.
- `minQueryLength` stops the empty-query request. Zero searches on focus, which is right for a list of recents and wrong for anything costly.
- **A stale response cannot overwrite a newer one.** Each call carries a generation and a late arrival is dropped — the bug every search box ships once, where the slow first request lands after the fast second and the user sees results for what they typed three keystrokes ago.
- A source that throws leaves an **empty list**, not a crash: a dropped request is not a reason to take the screen down. Report it yourself if it matters.

> **Accessibility**
>
> **The result count is announced.** A dropdown appearing is silent to a screen reader, so "3 results" is spoken through a live region — otherwise there is no way to know a search answered at all. Draw the active row as selected in `itemBuilder`, so the keyboard and the pointer agree about where you are.

### AstryxBaseTypeahead

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `TextEditingController` | — | The text being edited. |
| `source` *(required)* | `AstryxTypeaheadSource<T>` | — | Where suggestions come from — `Future<List<T>> Function(String)`. |
| `fieldBuilder` *(required)* | `Widget Function(context, state)` | — | Builds the field. Wire it to `state.controller` and `state.focusNode`. |
| `itemBuilder` *(required)* | `Widget Function(context, suggestion, state)` | — | Builds one row. |
| `headerBuilder` | `Widget Function(context, state)?` | — | Content above the suggestions. |
| `footerBuilder` | `Widget Function(context, state)?` | — | Content below them. |
| `matchFieldWidth` | `bool` | `true` | Whether the surface takes the field’s width. |


### AstryxTypeaheadState

What both builders are told, and everything they can do.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `query` | `String` | — | What has been typed. |
| `suggestions` | `List<T>` | — | What the source last returned. |
| `loading` | `bool` | — | Whether a call is in flight. |
| `activeIndex` | `int` | — | The row the arrows are on, or -1. **Not a selection.** |
| `isActive(index)` | `bool` | — | Whether that row is the active one. |
| `select(item)` | `void` | — | Chooses, as pressing would. |
| `open()` | `void` | — | Searches with the current text. |
| `close()` | `void` | — | Hides the surface. |


## Related

- [AstryxTypeahead](typeahead.md) — this with a field and rows already drawn.
- [AstryxComplexSelector](complex_selector.md) — the same split for a selector: a trigger this package draws and a surface you do.

