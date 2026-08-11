---
title: AstryxMultiSelector
description: A selector that keeps several choices, shown as tokens.
component: true
group: Forms
source: lib/src/components/forms/multi_selector.dart
upstream: MultiSelector
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

The same option list as [AstryxSelector](selector.md) — options, sections and dividers are the same types here, because upstream shares them between the two components as well. What differs is the value (a set), the rows (checkboxes, and the list stays open as they are ticked) and the trigger (tokens rather than one label).

```dart
class MultiSelectorDemoExample extends StatefulWidget {
  const MultiSelectorDemoExample({super.key});

  @override
  State<MultiSelectorDemoExample> createState() =>
      _MultiSelectorDemoExampleState();
}

class _MultiSelectorDemoExampleState extends State<MultiSelectorDemoExample> {
  Set<String> _reviewers = <String>{'ada'};

  @override
  Widget build(BuildContext context) {
    // The list stays open as options are ticked — the difference from a single
    // selector — and the trigger shows a token per choice.
    return AstryxMultiSelector<String>(
      label: 'Reviewers',
      description: 'They are notified when the branch is pushed.',
      values: _reviewers,
      showSearch: true,
      showSelectAll: true,
      maxBadges: 2,
      onChanged: (values) => setState(() => _reviewers = values),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorSection<String>('Maintainers'),
        AstryxSelectorOption<String>(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption<String>(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection<String>('Reviewers'),
        AstryxSelectorOption<String>(
          value: 'grace',
          label: 'Grace Hopper',
          description: 'Away until Friday',
        ),
        AstryxSelectorOption<String>(
          value: 'katherine',
          label: 'Katherine Johnson',
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxMultiSelector<String>(
  label: 'Reviewers',
  values: _reviewers,
  onChanged: (values) => setState(() => _reviewers = values),
  options: const <AstryxSelectorEntry<String>>[
    AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
    AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
  ],
)
```

Each change hands back a **new set**; the one passed in is never edited. `showSearch` filters the list, and drops a section heading whose options have all been filtered away — five headings above nothing is worse than an empty list. `showSelectAll` adds a row that ticks everything, and clears it when everything is already ticked.

## What the trigger shows

```dart
class MultiSelectorCountExample extends StatefulWidget {
  const MultiSelectorCountExample({super.key});

  @override
  State<MultiSelectorCountExample> createState() =>
      _MultiSelectorCountExampleState();
}

class _MultiSelectorCountExampleState extends State<MultiSelectorCountExample> {
  Set<String> _regions = <String>{'us-east-1', 'eu-west-2', 'ap-south-1'};

  @override
  Widget build(BuildContext context) {
    // A count instead of tokens, for a field that is usually full.
    return AstryxMultiSelector<String>(
      label: 'Regions',
      values: _regions,
      triggerDisplay: AstryxMultiSelectorTriggerDisplay.count,
      onChanged: (values) => setState(() => _regions = values),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption<String>(value: 'us-east-1', label: 'us-east-1'),
        AstryxSelectorOption<String>(value: 'eu-west-2', label: 'eu-west-2'),
        AstryxSelectorOption<String>(value: 'ap-south-1', label: 'ap-south-1'),
        AstryxSelectorOption<String>(
          value: 'sa-east-1',
          label: 'sa-east-1',
          enabled: false,
          description: 'Not enabled for this account',
        ),
      ],
    );
  }
}
```


| Set | Trigger shows |
| --- | --- |
| `badges` (default) | A token per choice up to `maxBadges`, then "+n more". One line: a trigger that grew would move every field below it. |
| `count` | "3 selected". For a field that is usually full, where the tokens would never have fitted. |

> **Accessibility**
>
> The field announces **which** options are chosen, not how many: "Ada Lovelace, Grace Hopper" rather than "2 selected". A count is a summary for the eye; a reader needs the list. The clear button keeps a name of its own so that it can be reached at all.

## Or a different widget

- [AstryxSelector](selector.md) — one choice out of many.
- [AstryxCheckboxList](checkbox_list.md) — a handful of choices always worth showing. A dropdown that hides three checkboxes costs a click and saves nothing.
- [AstryxToggleButtonGroup](toggle_button_group.md) — two to four choices that belong on a toolbar.

### AstryxMultiSelector

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `options` *(required)* | `List<AstryxSelectorEntry<T>>` | — | The options, sections and dividers, in order. |
| `values` *(required)* | `Set<T>` | — | The values currently chosen. |
| `onChanged` | `ValueChanged<Set<T>>?` | — | Called with a new set. Null makes the selector inert. |
| `triggerDisplay` | `AstryxMultiSelectorTriggerDisplay` | `badges` | Tokens or a count. |
| `maxBadges` | `int` | `3` | How many tokens before the rest collapse into "+n". |
| `showSelectAll` | `bool` | `false` | Whether to offer a tick-everything row. |
| `showSearch` | `bool` | `false` | Whether to offer a search field above the list. |
| `emptyLabel` | `String?` | — | What to show when a search matches nothing. |
| `loading` | `bool` | `false` | Whether the options are being fetched. |
| `maxListHeight` | `double` | `320` | The tallest the list may be before it scrolls. |
| `label` *(required)* | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


