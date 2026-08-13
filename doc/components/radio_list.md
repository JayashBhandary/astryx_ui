---
title: AstryxRadioList
description: One choice out of several, as an ARIA radio group.
component: true
group: Forms
source: lib/src/components/forms/radio_list.dart
upstream: RadioList / RadioListItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class RadioListDemoExample extends StatefulWidget {
  const RadioListDemoExample({super.key});

  @override
  State<RadioListDemoExample> createState() => _RadioListDemoExampleState();
}

class _RadioListDemoExampleState extends State<RadioListDemoExample> {
  Plan _plan = Plan.pro;

  @override
  Widget build(BuildContext context) {
    return AstryxRadioList<Plan>(
      label: 'Plan',
      value: _plan,
      onChanged: (value) => setState(() => _plan = value),
      options: const <AstryxRadioOption<Plan>>[
        AstryxRadioOption(
          value: Plan.free,
          label: 'Free',
          description: 'One project, community support.',
        ),
        AstryxRadioOption(
          value: Plan.pro,
          label: 'Pro',
          description: 'Unlimited projects, email support.',
        ),
        AstryxRadioOption(
          value: Plan.enterprise,
          label: 'Enterprise',
          description: 'Contact sales.',
          enabled: false,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxRadioList<Plan>(
  label: 'Plan',
  value: _plan,
  onChanged: (value) => setState(() => _plan = value),
  options: const <AstryxRadioOption<Plan>>[
    AstryxRadioOption(value: Plan.free, label: 'Free'),
    AstryxRadioOption(value: Plan.pro, label: 'Pro'),
  ],
)
```

The group is one tab stop, not one per option — which is what makes it a radio group rather than a list of radios. Arrows move *and* select, and they wrap, so a user never has to reverse.

## Orientation

Horizontal suits two or three short labels and nothing longer.

```dart
class RadioListHorizontalExample extends StatefulWidget {
  const RadioListHorizontalExample({super.key});

  @override
  State<RadioListHorizontalExample> createState() =>
      _RadioListHorizontalExampleState();
}

class _RadioListHorizontalExampleState
    extends State<RadioListHorizontalExample> {
  String _visibility = 'private';

  @override
  Widget build(BuildContext context) {
    // Horizontal suits two or three short labels and nothing longer.
    return AstryxRadioList<String>(
      label: 'Visibility',
      orientation: AstryxRadioListOrientation.horizontal,
      value: _visibility,
      onChanged: (value) => setState(() => _visibility = value),
      options: const <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'private', label: 'Private'),
        AstryxRadioOption(value: 'team', label: 'Team'),
        AstryxRadioOption(value: 'public', label: 'Public'),
      ],
    );
  }
}
```


## Validation

A null `value` is a group with nothing chosen — where a required group starts, and what its error message is for.

```dart
class RadioListValidationExample extends StatefulWidget {
  const RadioListValidationExample({super.key});

  @override
  State<RadioListValidationExample> createState() =>
      _RadioListValidationExampleState();
}

class _RadioListValidationExampleState
    extends State<RadioListValidationExample> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    // A null value is a group with nothing chosen — which is where a required
    // group starts, and what its error message is for.
    return AstryxRadioList<String>(
      label: 'Why are you leaving?',
      description: 'This goes to the product team, not to support.',
      required: true,
      value: _reason,
      status: _reason == null
          ? const AstryxFieldStatus.error('Choose one to continue')
          : const AstryxFieldStatus.success('Thanks — that helps'),
      onChanged: (value) => setState(() => _reason = value),
      options: const <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'price', label: 'Too expensive'),
        AstryxRadioOption(value: 'missing', label: 'Missing a feature'),
        AstryxRadioOption(value: 'other', label: 'Something else'),
      ],
    );
  }
}
```


## Sizes

```dart
class RadioListSizesExample extends StatelessWidget {
  const RadioListSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxRadioList<String>(
            label: size.name,
            size: size,
            value: 'a',
            onChanged: (_) {},
            options: const <AstryxRadioOption<String>>[
              AstryxRadioOption(value: 'a', label: 'First'),
              AstryxRadioOption(value: 'b', label: 'Second'),
            ],
          ),
      ],
    );
  }
}
```


## Disabled

`enabled: false` on the group disables every option; `AstryxRadioOption.enabled` disables one.

```dart
class RadioListDisabledExample extends StatelessWidget {
  const RadioListDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxRadioList<String>(
      label: 'Data region',
      description: 'Managed by your administrator.',
      enabled: false,
      value: 'eu',
      options: <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'eu', label: 'Europe'),
        AstryxRadioOption(value: 'us', label: 'United States'),
      ],
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Enters the group, or leaves it — one stop, not one per option. |
| `↓` / `→` | Selects the next enabled option, wrapping. |
| `↑` / `←` | Selects the previous one, wrapping. Mirrored under RTL. |
| `Space` | Selects the focused option. |

> **Accessibility**
>
> An empty group still has to put focus somewhere when it is tabbed into. It goes to the first enabled option, which is what the ARIA pattern says — not to the first option regardless.

### AstryxRadioList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `options` *(required)* | `List<AstryxRadioOption<T>>` | — | The options, in the order they are shown and traversed. |
| `value` *(required)* | `T?` | — | The selected value, or null for no selection. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly selected value. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size. |
| `orientation` | `AstryxRadioListOrientation` | `AstryxRadioListOrientation.vertical` | Which way the options run. |
| `focusNode` | `FocusNode?` | — | The focus node for the group. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxRadioOption

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What selecting this option produces. |
| `label` *(required)* | `String` | — | The visible text, and this option’s accessible name. |
| `description` | `String?` | — | Helper text below the label. |
| `enabled` | `bool` | `true` | Whether this option can be chosen. |


## Related

- [AstryxSelector](selector.md) — the same choice, collapsed into a dropdown. Past about seven options, prefer it.

---

Something wrong with `AstryxRadioList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxRadioList&component=AstryxRadioList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxRadioList&area=AstryxRadioList) — both templates arrive with the component filled in.
