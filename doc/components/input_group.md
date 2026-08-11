---
title: AstryxInputGroup
description: Adjacent inputs and affixes joined into one bordered control.
component: true
group: Forms
source: lib/src/components/forms/input_group.dart
upstream: InputGroup / InputGroupText
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

`https://` before a field, `USD` after an amount, a unit at the end of a number. The children keep their border where the group’s edge is and square it where they meet, so a reader sees one control rather than three.

```dart
class InputGroupDemoExample extends StatelessWidget {
  const InputGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three children, one border. The affixes size to their text; the field in
    // the middle takes what is left.
    return AstryxInputGroup(
      label: 'Project URL',
      description: 'Lower case, no spaces.',
      children: <Widget>[
        const AstryxInputGroupText('https://'),
        Expanded(
          child: AstryxTextInput(
            label: 'Project URL',
            labelHidden: true,
            placeholder: 'my-project',
            onChanged: (_) {},
          ),
        ),
        const AstryxInputGroupText('.example.com'),
      ],
    );
  }
}
```


## Usage

```dart
AstryxInputGroup(
  label: 'Project URL',
  children: <Widget>[
    const AstryxInputGroupText('https://'),
    Expanded(
      child: AstryxTextInput(
        label: 'Project URL',
        labelHidden: true,
        controller: _slug,
      ),
    ),
    const AstryxInputGroupText('.example.com'),
  ],
)
```

The group carries the label, the description and the status for the whole row, so the input inside takes `labelHidden: true` and says nothing of its own — upstream’s arrangement too. Wrap whichever child should take the leftover width in an `Expanded`; the affixes size to their text.

## One border, one status

```dart
class InputGroupStatusExample extends StatelessWidget {
  const InputGroupStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The status belongs to the group, so the whole joined border carries it
    // rather than one child of it turning red on its own.
    return AstryxInputGroup(
      label: 'Amount',
      status: const AstryxFieldStatus.error('Enter an amount above zero.'),
      children: <Widget>[
        const AstryxInputGroupText(r'$'),
        Expanded(
          child: AstryxTextInput(
            label: 'Amount',
            labelHidden: true,
            placeholder: '0.00',
            onChanged: (_) {},
          ),
        ),
        const AstryxInputGroupText('USD'),
      ],
    );
  }
}
```


A status belongs to the group, and every child paints it — rather than one of them turning red beside two that did not, which would read as one part being wrong instead of the field.

> **Accessibility**
>
> An affix is decoration: no focus, no value, not announced. Anything it *says* — a currency, a unit — belongs in the group’s label or description as well, or a screen-reader user gets the number without knowing what it counts.

## How the joining works

Each child is wrapped in an `AstryxInputGroupScope` carrying its position, and the input container reads it: the first child rounds its reading-start corners, the last its end corners, and the ones between stay square. Directional throughout, so a group mirrors under RTL without being told which way it runs.

### AstryxInputGroup

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The inputs and affixes, in reading order. |
| `size` | `AstryxInputSize?` | — | The size every input inside takes unless it sets its own. |
| `label` *(required)* | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


## Related

- [AstryxTextInput](text_input.md) — the usual child.
- [AstryxButtonGroup](button_group.md) — the same idea for actions.
- [AstryxNumberInput](number_input.md) — which has a `units` slot already, for when a whole group is more than you need.

