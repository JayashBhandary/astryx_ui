---
title: AstryxToggleButtonGroup
description: Toggle buttons as one control — single or multiple selection.
component: true
group: Actions
source: lib/src/components/action/toggle_button.dart
upstream: ToggleButtonGroup
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

The group owns the selection, so its children carry a `value` rather than a boolean. Which may be on at once is the constructor’s job, not a flag: `.single` for at most one, `.multiple` for any number.

## At most one

```dart
class ToggleButtonGroupSingleExample extends StatefulWidget {
  const ToggleButtonGroupSingleExample({super.key});

  @override
  State<ToggleButtonGroupSingleExample> createState() =>
      _ToggleButtonGroupSingleExampleState();
}

class _ToggleButtonGroupSingleExampleState
    extends State<ToggleButtonGroupSingleExample> {
  String? _view = 'grid';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: _view,
          onChanged: (value) => setState(() => _view = value),
          children: const <Widget>[
            AstryxToggleButton(value: 'list', label: 'List'),
            AstryxToggleButton(value: 'grid', label: 'Grid'),
            AstryxToggleButton(value: 'board', label: 'Board'),
          ],
        ),
        // Pressing the one that is already on clears the group, so "none" is
        // always reachable — upstream's behaviour, and the reason the value is
        // nullable.
        AstryxText(
          _view == null ? 'No view chosen.' : 'Showing the $_view view.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


```dart
AstryxToggleButtonGroup.single(
  label: 'View mode',
  value: _view,
  onChanged: (value) => setState(() => _view = value),
  children: const <Widget>[
    AstryxToggleButton(value: 'list', label: 'List'),
    AstryxToggleButton(value: 'grid', label: 'Grid'),
    AstryxToggleButton(value: 'board', label: 'Board'),
  ],
)
```

Pressing the button that is already on **clears** the group, and `onChanged` receives null. That is upstream’s behaviour and the reason the value is nullable: "none" stays reachable. If your screen cannot represent none, a [tab list](tab_list.md) is the honest control.

## Any number

```dart
class ToggleButtonGroupMultipleExample extends StatefulWidget {
  const ToggleButtonGroupMultipleExample({super.key});

  @override
  State<ToggleButtonGroupMultipleExample> createState() =>
      _ToggleButtonGroupMultipleExampleState();
}

class _ToggleButtonGroupMultipleExampleState
    extends State<ToggleButtonGroupMultipleExample> {
  Set<String> _statuses = <String>{'failing'};

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButtonGroup.multiple(
          label: 'Filter by status',
          values: _statuses,
          // A new set arrives each time; the group never edits the one it was
          // given.
          onChanged: (values) => setState(() => _statuses = values),
          children: const <Widget>[
            AstryxToggleButton(value: 'passing', label: 'Passing'),
            AstryxToggleButton(value: 'failing', label: 'Failing'),
            AstryxToggleButton(value: 'queued', label: 'Queued'),
          ],
        ),
        AstryxText(
          _statuses.isEmpty
              ? 'No filter: every run.'
              : 'Filtering: ${_statuses.join(', ')}.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


```dart
AstryxToggleButtonGroup.multiple(
  label: 'Filter by status',
  values: _statuses,
  onChanged: (values) => setState(() => _statuses = values),
  children: const <Widget>[
    AstryxToggleButton(value: 'passing', label: 'Passing'),
    AstryxToggleButton(value: 'failing', label: 'Failing'),
    AstryxToggleButton(value: 'queued', label: 'Queued'),
  ],
)
```

Each change hands you a **new set**; the group never edits the one it was given. Upstream splits these two modes with a discriminated union on a `type` prop — two named constructors are how Dart says the same thing, and they make the wrong `onChanged` signature a compile error rather than a runtime surprise.

## Vertical

```dart
class ToggleButtonGroupVerticalExample extends StatefulWidget {
  const ToggleButtonGroupVerticalExample({super.key});

  @override
  State<ToggleButtonGroupVerticalExample> createState() =>
      _ToggleButtonGroupVerticalExampleState();
}

class _ToggleButtonGroupVerticalExampleState
    extends State<ToggleButtonGroupVerticalExample> {
  String? _environment = 'staging';

  @override
  Widget build(BuildContext context) {
    // A vertical group stretches its buttons to one width, so the labels line
    // up however long they are.
    return AstryxToggleButtonGroup.single(
      label: 'Environment',
      value: _environment,
      axis: Axis.vertical,
      size: AstryxButtonSize.sm,
      onChanged: (value) => setState(() => _environment = value),
      children: const <Widget>[
        AstryxToggleButton(value: 'production', label: 'Production'),
        AstryxToggleButton(value: 'staging', label: 'Staging'),
        AstryxToggleButton(value: 'dev', label: 'Development'),
      ],
    );
  }
}
```


A vertical group stretches its buttons to one width, so labels of different lengths still line up. `size` cascades to every child that does not set its own.

## Not a segmented control

The buttons are spaced by `--spacing-1` rather than joined, and each is its own tab stop — a set of related controls, not one widget with an internal cursor. For a joined row of *actions* see [AstryxButtonGroup](button_group.md); for choosing what a panel shows, [AstryxTabList](tab_list.md), which has roving focus and a single stop.

> **Accessibility**
>
> The group’s `label` is required: it is the accessible name of the set, and without it a reader meets three unrelated buttons. Each child keeps its own node and its own selected state.

> **Careful**
>
> Inside a group, a child’s own `enabled` is **ignored** — the group decides. Upstream does the same (`group?.isDisabled ?? isDisabled`), so it is reproduced and pinned by a test rather than quietly improved. Disable the group, not its children. A grouped button without a `value` asserts in debug, because the group would have no way to know which one is on.

### AstryxToggleButtonGroup

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The group’s accessible name — "View mode", "Text formatting". |
| `value` *(required)* | `String?` | — | `.single` only: the value that is on, or null for none. |
| `onChanged` *(required)* | `ValueChanged<String?>` | — | `.single` only: the new value, or null when the group has been cleared. |
| `values` *(required)* | `Set<String>` | — | `.multiple` only: the values that are on. |
| `onChanged` *(required)* | `ValueChanged<Set<String>>` | — | `.multiple` only: a new set, each time. |
| `children` *(required)* | `List<Widget>` | — | The toggle buttons, in order. Each needs a `value`. |
| `axis` | `Axis` | `Axis.horizontal` | Whether the group runs horizontally or vertically. |
| `size` | `AstryxButtonSize?` | — | The size every child takes unless it sets its own. |
| `enabled` | `bool` | `true` | Whether the whole group accepts interaction. The only place to disable a grouped toggle. |
| `gap` | `AstryxSpacingToken?` | `AstryxSpacingToken.spacing1` | The space between the buttons. |


### AstryxToggleButtonGroupScope

The inherited widget the group installs, and the buttons read. The port of upstream’s `ToggleButtonGroupContext` — reach for it only when building a control of your own that has to know what is selected.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `selectedValues` *(required)* | `Set<String>` | — | The values currently on. |
| `toggle` *(required)* | `void Function(String value)` | — | Reports that a button’s value has been pressed. |
| `size` | `AstryxButtonSize?` | — | The size children inherit. |
| `enabled` | `bool` | `true` | Whether the group accepts interaction. |


## Related

- [AstryxToggleButton](toggle_button.md) — the child, and the states it paints.
- [AstryxButtonGroup](button_group.md) — actions joined into one shape.
- [AstryxRadioList](radio_list.md) — one choice from a set, as a form control.

