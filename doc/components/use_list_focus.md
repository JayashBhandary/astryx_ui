---
title: AstryxRovingFocus.list
description: Arrow-key traversal across a list as one tab stop.
component: true
group: Hooks & controllers
source: lib/src/foundation/roving_focus.dart
upstream: useListFocus
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookListFocusExample extends StatefulWidget {
  const HookListFocusExample({super.key});

  @override
  State<HookListFocusExample> createState() => _HookListFocusExampleState();
}

class _HookListFocusExampleState extends State<HookListFocusExample> {
  static const List<String> _filters = <String>[
    'Open',
    'Merged',
    'Closed',
    'Draft',
  ];

  final Set<int> _on = <int>{0};

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Tab onto the strip, then use the arrows — one tab stop for four chips.
    // `Draft` is disabled, and movement skips it rather than landing on it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxRovingFocus.list(
          length: _filters.length,
          label: 'Filters',
          gap: AstryxSpacingToken.spacing2,
          isEnabled: (index) => _filters[index] != 'Draft',
          onActivate: (index) => setState(() {
            _on.contains(index) ? _on.remove(index) : _on.add(index);
          }),
          itemBuilder: (context, item) {
            final selected = _on.contains(item.index);
            final enabled = _filters[item.index] != 'Draft';

            return Semantics(
              // The items are announced individually even though only the group
              // takes focus: `explicitChildNodes` on the group keeps them.
              inMutuallyExclusiveGroup: false,
              checked: selected,
              enabled: enabled,
              label: _filters[item.index],
              child: ExcludeSemantics(
                child: AstryxFocusRing(
                  focused: item.showsFocusRing,
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                  child: AstryxBadge(
                    _filters[item.index],
                    variant: selected
                        ? AstryxBadgeVariant.info
                        : AstryxBadgeVariant.neutral,
                  ),
                ),
              ),
            );
          },
        ),
        AstryxText(
          'Enter or Space toggles. Selected: '
          '${_on.map((i) => _filters[i]).join(', ')}',
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
AstryxRovingFocus.list(
  length: chips.length,
  label: 'Filters',
  onActivate: (index) => _toggle(chips[index]),
  itemBuilder: (context, item) => AstryxFocusRing(
    focused: item.showsFocusRing,
    child: _Chip(chips[item.index]),
  ),
)
```

**One tab stop.** Tab moves onto the group and off it again; the arrows move within it. A strip of twelve chips is twelve presses to walk past otherwise, which is the whole reason the ARIA composite pattern exists.

Every composite in this package already behaves this way — `AstryxRadioList`, `AstryxTabList`, `AstryxToolbar`, `AstryxSegmentedControl`, `AstryxCalendar`. Reach for this to build one the package does not have.

## Roving focus is not selection

This moves an *active index*; what that means is yours. Two shapes, both correct in the right place:

- **Activate on `Enter` and `Space`** — `onActivate`. What a menu, a grid or a toolbar wants: a user can look before committing.
- **Select as the focus moves** — `onActiveChanged`. What a radio group does, because there the focus *is* the choice.

## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the group, and off it. |
| `←` / `→` | Moves along a horizontal list. **Mirrored under RTL.** |
| `↑` / `↓` | Moves along a vertical one. Both axes work in either orientation, which is what a user who does not know which way the group runs will try. |
| `Home` / `End` | The first and last available item. |
| `Enter` / `Space` | Calls `onActivate` with the index. |

`wrap` is on for a list: the arrows cycle rather than stopping, so a user never has to reverse. `isEnabled` marks the items movement should skip — a disabled chip is passed over rather than landed on.

> **Careful**
>
> **Nothing `itemBuilder` returns may be focusable.** A focusable item would be its own tab stop, and the group would stop being one — the exact thing this widget exists to prevent. Build plain visuals, and use `item.showsFocusRing` to draw the ring.

### AstryxRovingFocus

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `length` *(required)* | `int` | — | How many items there are. |
| `itemBuilder` *(required)* | `Widget Function(context, AstryxRovingFocusItem)` | — | Builds one item, told whether the focus is on it. |
| `columns` | `int` | — | Required by `AstryxRovingFocus.grid`; absent for a list. |
| `orientation` | `Axis` | `Axis.horizontal` | Which way a list runs. |
| `wrap` | `bool` | `true` | Whether movement cycles at the ends. True for a list, false for a grid. |
| `onActivate` | `ValueChanged<int>?` | — | Called with the index `Enter` or `Space` was pressed on. |
| `isEnabled` | `bool Function(int)?` | — | Whether an index can hold the focus. Movement skips the rest. |
| `activeIndex` | `int?` | — | The active index, for a caller that owns it. Null keeps it internal. |
| `onActiveChanged` | `ValueChanged<int>?` | — | Called with the index the focus moved to. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The gap in the default layout. |
| `layoutBuilder` | `Widget Function(context, List<Widget>)?` | — | Lays the items out. Null uses a row, a column or a grid. |
| `label` | `String?` | — | An accessible name for the group. |


### AstryxRovingFocusItem

What each item is told about itself.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `int` | — | Which item this is. |
| `isActive` | `bool` | — | Whether the roving focus sits here — true for exactly one item, whether or not the group is focused. |
| `groupHasFocus` | `bool` | — | Whether the group holds focus. |
| `showsFocusRing` | `bool` | — | Both conditions in one place: active **and** the group focused. Hand it to `AstryxFocusRing.focused`. |


> **Accessibility**
>
> The group carries the accessible name and `explicitChildNodes`, so each item keeps a node of its own — a reader hears "Open, checked" rather than one field of indeterminate content. Give every item a `Semantics` with its label and state; the group cannot infer either.

## Related

- [useGridFocus](use_grid_focus.md) — the same widget in two dimensions.
- [useTreeFocus](use_tree_focus.md) — why a tree is not this.
- [AstryxToolbar](toolbar.md) — a band of controls that is one tab stop.
- [Accessibility](../guides/accessibility.md) — the composite rule, in context.

---

Something wrong with `AstryxRovingFocus.list`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxRovingFocus.list&component=AstryxRovingFocus.list) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxRovingFocus.list&area=AstryxRovingFocus.list) — both templates arrive with the component filled in.
