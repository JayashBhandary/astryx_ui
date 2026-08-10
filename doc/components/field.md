---
title: AstryxField
description: Gives any control a label, a description, a required marker and a validation message.
component: true
group: Forms
source: lib/src/components/forms/field.dart
upstream: Field
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class FieldDemoExample extends StatefulWidget {
  const FieldDemoExample({super.key});

  @override
  State<FieldDemoExample> createState() => _FieldDemoExampleState();
}

class _FieldDemoExampleState extends State<FieldDemoExample> {
  double _budget = 40;

  @override
  Widget build(BuildContext context) {
    // `AstryxField` gives a label, description, required marker and status
    // message to a control that has none of its own — here a plain Flutter
    // slider. The field publishes all of that to its child through
    // `AstryxFieldScope`, so the control does not have to take the props.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Monthly budget',
        description: 'Alerts fire at 80% of this.',
        required: true,
        status: _budget > 80
            ? const AstryxFieldStatus.warning('Above your usual spend')
            : null,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: _Slider(
                value: _budget,
                onChanged: (value) => setState(() => _budget = value),
              ),
            ),
            AstryxText(
              '\$${_budget.round()}',
              tabularNumbers: true,
            ),
          ],
        ),
      ),
    );
  }
}
```


## Usage

```dart
AstryxField(
  label: 'Monthly budget',
  description: 'Alerts fire at 80% of this.',
  required: true,
  child: mySlider,
)
```

The built-in controls already take `label`, `description`, `status` and the rest — they wrap themselves in a field. Reach for `AstryxField` directly when the control is *yours*: a slider, a colour picker, a date range, anything the design system has no widget for.

## Composition

```text
AstryxField
├── label      ← plus the Required / Optional marker
├── description
├── child      ← your control, inside an AstryxFieldScope
└── status     ← icon and message, announced
```

## The scope

A field publishes itself through `AstryxFieldScope`, and every built-in control reads it. So `enabled` and `status` set on the field reach the controls inside it without being passed down by hand.

```dart
class FieldScopeExample extends StatelessWidget {
  const FieldScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Controls that *do* have their own label read the scope instead of
    // repeating it: `enabled` and `status` cascade down from the field.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Region',
        description: 'Both controls inherit the field being disabled.',
        enabled: false,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxTextInput(label: 'Region', labelHidden: true),
            AstryxCheckbox(
              label: 'Replicate to a second region',
              value: false,
            ),
          ],
        ),
      ),
    );
  }
}
```


## Markers

Mark whichever is the exception in your form. Marking every field as required says nothing at all.

```dart
class FieldMarkersExample extends StatelessWidget {
  const FieldMarkersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `required` and `optional` are mutually exclusive. Mark whichever is the
    // exception in your form — marking every field says nothing.
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxField(
            label: 'Company name',
            required: true,
            child: AstryxTextInput(label: 'Company name', labelHidden: true),
          ),
          AstryxField(
            label: 'VAT number',
            optional: true,
            child: AstryxTextInput(label: 'VAT number', labelHidden: true),
          ),
          AstryxField(
            label: 'Internal reference',
            labelHidden: true,
            description: 'The label is hidden, but still announced.',
            child: AstryxTextInput(
              label: 'Internal reference',
              labelHidden: true,
            ),
          ),
        ],
      ),
    );
  }
}
```


## Statuses

`AstryxFieldStatus` has three types and a message. A null message colours the control and shows its icon without adding text — for a field whose problem is described elsewhere, such as a summary at the top of the form.

```dart
class FieldStatusesExample extends StatelessWidget {
  const FieldStatusesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxField(
            label: 'Error',
            status: AstryxFieldStatus.error('This field is required'),
            child: AstryxTextInput(label: 'Error', labelHidden: true),
          ),
          AstryxField(
            label: 'Warning',
            status: AstryxFieldStatus.warning('Unusual for this account'),
            child: AstryxTextInput(label: 'Warning', labelHidden: true),
          ),
          AstryxField(
            label: 'Success',
            status: AstryxFieldStatus.success('Available'),
            child: AstryxTextInput(label: 'Success', labelHidden: true),
          ),
        ],
      ),
    );
  }
}
```


| Constructor | Type | Announced |
| --- | --- | --- |
| `AstryxFieldStatus.error(message)` | error | **assertively** — it blocks the user |
| `AstryxFieldStatus.warning(message)` | warning | politely |
| `AstryxFieldStatus.success(message)` | success | politely |

> **Accessibility**
>
> The description *and* the status message both become the control’s hint, joined rather than one winning: both matter to a screen-reader user, and neither is reachable any other way.

### AstryxField

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The field’s name. |
| `child` *(required)* | `Widget` | — | The control this field describes. |
| `description` | `String?` | — | Helper text. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `required` | `bool` | `false` | Whether the field must be filled in. |
| `optional` | `bool` | `false` | Marks the field optional. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `width` | `double?` | — | A fixed width. Null fills the available space. |


## Related

- [AstryxTextInput](text_input.md) — a control that wraps itself in a field.
- [AstryxSelector](selector.md) — likewise.

