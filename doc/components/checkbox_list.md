---
title: AstryxCheckboxList
description: A group of checkboxes sharing one label and one validation state.
component: true
group: Forms
source: lib/src/components/forms/checkbox_list.dart
upstream: CheckboxList / CheckboxListItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Several independent choices under one heading, one description and one validation state. That last part is the reason to reach for this rather than a column of [checkboxes](checkbox.md): "choose at least one region" is a complaint about the set, and repeating it on every row says it three times to a screen reader.

```dart
class CheckboxListDemoExample extends StatefulWidget {
  const CheckboxListDemoExample({super.key});

  @override
  State<CheckboxListDemoExample> createState() =>
      _CheckboxListDemoExampleState();
}

class _CheckboxListDemoExampleState extends State<CheckboxListDemoExample> {
  Set<String> _channels = <String>{'email'};

  @override
  Widget build(BuildContext context) {
    // One label, one description and one status for the whole set — which is
    // the reason to reach for this rather than a column of checkboxes.
    return AstryxCheckboxList<String>(
      label: 'Notify me about',
      description: 'Applies to every project you watch.',
      values: _channels,
      onChanged: (values) => setState(() => _channels = values),
      options: const <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(
          value: 'email',
          label: 'Email',
          description: 'Digested once an hour.',
        ),
        AstryxCheckboxOption(value: 'sms', label: 'SMS'),
        AstryxCheckboxOption(
          value: 'push',
          label: 'Push',
          description: 'Needs the mobile app.',
          enabled: false,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxCheckboxList<String>(
  label: 'Notify me about',
  values: _channels,
  onChanged: (values) => setState(() => _channels = values),
  options: const <AstryxCheckboxOption<String>>[
    AstryxCheckboxOption(value: 'email', label: 'Email'),
    AstryxCheckboxOption(value: 'sms', label: 'SMS'),
  ],
)
```

Each change hands back a **new set**; the one passed in is never edited, so a `setState` that assigns it is enough. Upstream takes a `string[]`; this is generic over the value type, like [AstryxRadioList](radio_list.md) — an enum reads better than a string at a call site and cannot be misspelled.

> **Accessibility**
>
> Each row is its own tab stop, and Space toggles the row that has focus. That is the ARIA checkbox pattern, and the **opposite** of [AstryxRadioList](radio_list.md), where the whole group is one stop and the arrows move within it. A checkbox group keyboarded as a radio group swallows Tab and traps anyone using one; a test pins the difference.

## Density and dividers

Compact takes the small control and tightens the rows. Dividers turn a set of options into a list of them — worth it when the rows carry trailing content of their own.

```dart
class CheckboxListDensityExample extends StatefulWidget {
  const CheckboxListDensityExample({super.key});

  @override
  State<CheckboxListDensityExample> createState() =>
      _CheckboxListDensityExampleState();
}

class _CheckboxListDensityExampleState
    extends State<CheckboxListDensityExample> {
  Set<String> _scopes = <String>{'read'};

  @override
  Widget build(BuildContext context) {
    // Compact takes the small control and tightens the rows; dividers turn a
    // set of options into a list of them.
    return AstryxCheckboxList<String>(
      label: 'Token scopes',
      values: _scopes,
      density: AstryxCheckboxListDensity.compact,
      dividers: true,
      onChanged: (values) => setState(() => _scopes = values),
      options: const <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(
          value: 'read',
          label: 'read',
          trailing: AstryxBadge('safe', variant: AstryxBadgeVariant.success),
        ),
        AstryxCheckboxOption(value: 'write', label: 'write'),
        AstryxCheckboxOption(
          value: 'admin',
          label: 'admin',
          trailing: AstryxBadge('broad', variant: AstryxBadgeVariant.warning),
        ),
      ],
    );
  }
}
```


A checked row is tinted with `--color-accent-muted`, as upstream tints it, and not when the row is disabled or read-only: a tint that survives those advertises an affordance the row does not have. The inset is paid either way, so nothing shifts sideways as rows are ticked.

## Validation

```dart
class CheckboxListStatusExample extends StatelessWidget {
  const CheckboxListStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The status belongs to the group: "pick at least one" is not a complaint
    // about any single row, and repeating it on each would be three times the
    // noise for a screen reader.
    return const AstryxCheckboxList<String>(
      label: 'Regions',
      values: <String>{},
      required: true,
      status: AstryxFieldStatus.error('Choose at least one region.'),
      options: <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(value: 'us', label: 'us-east-1'),
        AstryxCheckboxOption(value: 'eu', label: 'eu-west-2'),
      ],
    );
  }
}
```


## States

| Set | Gets you |
| --- | --- |
| `enabled: false` | The whole group refuses and dims. For one row, use the option’s own `enabled`. |
| `readOnly: true` | The values are shown at full strength and cannot be changed. Not dimmed — the values are the point. |
| an option’s `loading` | A spinner in place of that row’s control while something settles. Upstream drives this from a pending `changeAction`; here the caller owns it, as everywhere else in this package. |
| an option’s `trailing` | Content after the label — a badge, a count. Upstream’s `endContent`. Not part of the row’s accessible name, so put anything it *says* in the description too. |

### AstryxCheckboxList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `options` *(required)* | `List<AstryxCheckboxOption<T>>` | — | The rows, in order. |
| `values` *(required)* | `Set<T>` | — | The values currently checked. |
| `onChanged` | `ValueChanged<Set<T>>?` | — | Called with a new set. Null makes the group inert. |
| `density` | `AstryxCheckboxListDensity` | `balanced` | How much room each row gets. |
| `dividers` | `bool` | `false` | Whether to draw a rule between rows. |
| `readOnly` | `bool` | `false` | Whether the selection can be read but not changed. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


### AstryxCheckboxOption

One row.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What checking the row selects. |
| `label` *(required)* | `String` | — | The visible text, and the row’s accessible name. |
| `description` | `String?` | — | Helper text below the label. |
| `trailing` | `Widget?` | — | Content after the label. |
| `enabled` | `bool` | `true` | Whether the row can be checked. |
| `loading` | `bool` | `false` | Whether the row is waiting on something. |


## Related

- [AstryxCheckbox](checkbox.md) — one independent choice.
- [AstryxRadioList](radio_list.md) — one choice among several, keyboarded the other way.
- [AstryxField](field.md) — the label, description and status this reuses.

