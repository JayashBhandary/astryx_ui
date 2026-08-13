---
title: AstryxSelector
description: A dropdown that picks one value, with optional search.
component: true
group: Forms
source: lib/src/components/forms/selector.dart
upstream: Selector / SelectorOption
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SelectorDemoExample extends StatefulWidget {
  const SelectorDemoExample({super.key});

  @override
  State<SelectorDemoExample> createState() => _SelectorDemoExampleState();
}

class _SelectorDemoExampleState extends State<SelectorDemoExample> {
  String? _owner = 'ada';

  @override
  Widget build(BuildContext context) {
    return AstryxSelector<String>(
      label: 'Owner',
      value: _owner,
      width: 320,
      onChanged: (value) => setState(() => _owner = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
      ],
    );
  }
}
```


## Usage

```dart
AstryxSelector<String>(
  label: 'Owner',
  value: _owner,
  onChanged: (value) => setState(() => _owner = value),
  options: const <AstryxSelectorEntry<String>>[
    AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
    AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
  ],
)
```

Note the `onChanged` signature: `ValueChanged<T?>`, because clearing the selection is a change too. The trigger is the same input container as [AstryxTextInput](text_input.md), so a selector and a text field in the same form line up exactly.

## Composition

The list takes three kinds of entry. Sections and dividers are skipped by the keyboard, so arrowing never lands on one.

```text
AstryxSelector
├── trigger              ← the input container, showing the value
└── list                 ← an anchored overlay
    ├── search           ← when showSearch is true
    ├── AstryxSelectorSection('Engineering')
    ├── AstryxSelectorOption(value: …, label: …)
    ├── AstryxSelectorDivider()
    └── AstryxSelectorOption(value: …, label: …)
```

```dart
class SelectorSectionsExample extends StatefulWidget {
  const SelectorSectionsExample({super.key});

  @override
  State<SelectorSectionsExample> createState() =>
      _SelectorSectionsExampleState();
}

class _SelectorSectionsExampleState extends State<SelectorSectionsExample> {
  String? _owner;

  @override
  Widget build(BuildContext context) {
    // Three entry types: options, section headings and dividers. Headings and
    // dividers are skipped by the keyboard, so arrowing never lands on one.
    return AstryxSelector<String>(
      label: 'Assign to',
      placeholder: 'Nobody yet',
      value: _owner,
      showClear: true,
      width: 320,
      onChanged: (value) => setState(() => _owner = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorSection('Engineering'),
        AstryxSelectorOption(
          value: 'ada',
          label: 'Ada Lovelace',
          description: 'Platform',
        ),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection('Design'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
        AstryxSelectorOption(
          value: 'katherine',
          label: 'Katherine Johnson',
          enabled: false,
        ),
      ],
    );
  }
}
```


## Search

Worth turning on past roughly a dozen options. Below that it is a box to tab past for no gain.

```dart
class SelectorSearchExample extends StatefulWidget {
  const SelectorSearchExample({super.key});

  @override
  State<SelectorSearchExample> createState() => _SelectorSearchExampleState();
}

class _SelectorSearchExampleState extends State<SelectorSearchExample> {
  String? _zone;

  static final List<AstryxSelectorEntry<String>> _zones =
      <AstryxSelectorEntry<String>>[
        for (var hour = -11; hour <= 12; hour++)
          AstryxSelectorOption<String>(
            value: 'UTC$hour',
            label: 'UTC${hour >= 0 ? '+' : ''}$hour',
          ),
      ];

  @override
  Widget build(BuildContext context) {
    // Worth turning `showSearch` on past roughly a dozen options. Below that it
    // is a box to tab past for no gain.
    return AstryxSelector<String>(
      label: 'Timezone',
      value: _zone,
      showSearch: true,
      searchPlaceholder: 'Filter zones',
      emptyLabel: 'No zone matches',
      width: 320,
      onChanged: (value) => setState(() => _zone = value),
      options: _zones,
    );
  }
}
```


## Icons

`leading` sits in the trigger; `AstryxSelectorOption.icon` sits in the row. Both take any widget.

```dart
class SelectorIconsExample extends StatefulWidget {
  const SelectorIconsExample({super.key});

  @override
  State<SelectorIconsExample> createState() => _SelectorIconsExampleState();
}

class _SelectorIconsExampleState extends State<SelectorIconsExample> {
  String? _status = 'open';

  @override
  Widget build(BuildContext context) {
    return AstryxSelector<String>(
      label: 'Status',
      value: _status,
      width: 320,
      leading: const AstryxIcon(
        AstryxIconName.funnel,
        size: AstryxIconSize.sm,
        color: AstryxIconColor.secondary,
      ),
      onChanged: (value) => setState(() => _status = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(
          value: 'open',
          label: 'Open',
          icon: AstryxIcon(AstryxIconName.info),
        ),
        AstryxSelectorOption(
          value: 'done',
          label: 'Done',
          icon: AstryxIcon(AstryxIconName.check),
        ),
        AstryxSelectorOption(
          value: 'blocked',
          label: 'Blocked',
          icon: AstryxIcon(AstryxIconName.warning),
        ),
      ],
    );
  }
}
```


## States

```dart
class SelectorStatesExample extends StatelessWidget {
  const SelectorStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSelector<String>(
          label: 'Required, nothing chosen',
          value: null,
          required: true,
          width: 320,
          status: AstryxFieldStatus.error('Pick a status'),
          options: <AstryxSelectorEntry<String>>[
            AstryxSelectorOption(value: 'open', label: 'Open'),
          ],
        ),
        AstryxSelector<String>(
          label: 'Disabled',
          value: null,
          enabled: false,
          width: 320,
          placeholder: 'Managed by your admin',
          options: <AstryxSelectorEntry<String>>[
            AstryxSelectorOption(value: 'open', label: 'Open'),
          ],
        ),
      ],
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Enter` / `Space` / `↓` | Opens the list. |
| `↑` / `↓` | Moves the highlight without choosing anything, wrapping. |
| `Home` / `End` | Jumps to the first or last option. |
| a letter | Jumps to the first option starting with what you typed. The buffer resets after a second of silence. |
| `Enter` | Chooses the highlighted option and closes. |
| `Escape` | Closes the list — and only the list. |

> **Note**
>
> The list is at most `maxListHeight` tall, and the positioner may shrink it further to fit the viewport. It flips above the trigger when there is no room below.

### AstryxSelector

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `options` *(required)* | `List<AstryxSelectorEntry<T>>` | — | The entries to show, in order. |
| `value` *(required)* | `T?` | — | The selected value, or null for none. |
| `onChanged` | `ValueChanged<T?>?` | — | Called with the newly chosen value, or null when it is cleared. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `placeholder` | `String?` | — | Text shown when nothing is selected. |
| `size` | `AstryxInputSize?` | — | The trigger height. |
| `showClear` | `bool` | `false` | Whether to offer a button that clears the selection. |
| `showSearch` | `bool` | `false` | Whether the list has a search box at the top. |
| `searchPlaceholder` | `String?` | — | Placeholder for the search box. |
| `emptyLabel` | `String?` | — | Text shown when the search matches nothing. |
| `leading` | `Widget?` | — | Content before the value in the trigger. |
| `maxListHeight` | `double` | `320` | The tallest the list may be before it scrolls. |
| `width` | `double?` | — | A fixed width. |
| `focusNode` | `FocusNode?` | — | The trigger’s focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxSelectorOption

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What choosing this option produces. |
| `label` *(required)* | `String` | — | The visible text, and this option’s accessible name. |
| `description` | `String?` | — | Secondary text below the label. |
| `icon` | `Widget?` | — | An icon before the label. |
| `enabled` | `bool` | `true` | Whether the option can be chosen. |


## Related

- [AstryxRadioList](radio_list.md) — the same choice, all options visible.
- [AstryxDropdownMenu](dropdown_menu.md) — for *actions*, not for a value.

---

Something wrong with `AstryxSelector`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSelector&component=AstryxSelector) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSelector&area=AstryxSelector) — both templates arrive with the component filled in.
