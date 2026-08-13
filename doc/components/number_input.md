---
title: AstryxNumberInput
description: A numeric field with steppers, a range and unit text.
component: true
group: Forms
source: lib/src/components/forms/number_input.dart
upstream: NumberInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A field that holds a number, with the two affordances a number wants: steppers, and a range it refuses to leave.

```dart
class NumberInputDemoExample extends StatefulWidget {
  const NumberInputDemoExample({super.key});

  @override
  State<NumberInputDemoExample> createState() => _NumberInputDemoExampleState();
}

class _NumberInputDemoExampleState extends State<NumberInputDemoExample> {
  num? _replicas = 3;

  @override
  Widget build(BuildContext context) {
    // The steppers are drawn rather than inherited from a platform widget: a
    // browser's number input has them, and a thumb has no arrow keys.
    return AstryxNumberInput(
      label: 'Replicas',
      description: 'Between 1 and 20.',
      value: _replicas,
      min: 1,
      max: 20,
      integerOnly: true,
      width: 240,
      onChanged: (value) => setState(() => _replicas = value),
    );
  }
}
```


## Usage

```dart
AstryxNumberInput(
  label: 'Replicas',
  value: _replicas,
  min: 1,
  max: 20,
  integerOnly: true,
  onChanged: (value) => setState(() => _replicas = value),
)
```

`onChanged` fires when a value is **committed** — a stepper, an arrow key, or blur and Enter after typing — not on every keystroke, because half a number is not a number. It is a `num?`, so `integerOnly` gives you `int`s and a fractional `step` gives you `double`s without a second widget.

> **Careful**
>
> Out-of-range typing is **rejected, not clamped**. Type 200 into a field whose `max` is 20 and the value does not move: the text reverts on blur and the refusal is announced. That is upstream’s `parseNumberInput`, which returns null rather than the nearest legal number — quietly changing what somebody typed is worse than declining it. Pressing a stepper *does* stop at the boundary, as a browser’s spinner does.

## Range, step and units

```dart
class NumberInputRangeExample extends StatefulWidget {
  const NumberInputRangeExample({super.key});

  @override
  State<NumberInputRangeExample> createState() =>
      _NumberInputRangeExampleState();
}

class _NumberInputRangeExampleState extends State<NumberInputRangeExample> {
  num? _timeout = 2.5;
  num? _year = 1999;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // A fractional step and a unit. Typing 99 here is refused rather than
        // pulled down to 10 — the value stays what it was, and the rejection is
        // announced.
        AstryxNumberInput(
          label: 'Timeout',
          value: _timeout,
          min: 0.5,
          max: 10,
          step: 0.5,
          units: 'seconds',
          width: 260,
          onChanged: (value) => setState(() => _timeout = value),
        ),
        // No steppers: nobody increments a year one at a time.
        AstryxNumberInput(
          label: 'Year',
          value: _year,
          min: 1900,
          max: 2100,
          integerOnly: true,
          steppers: false,
          showClear: true,
          width: 260,
          onChanged: (value) => setState(() => _year = value),
        ),
      ],
    );
  }
}
```


`units` is a suffix inside the field. `steppers: false` removes the buttons for a field nobody increments one at a time — a year, an ID — and the arrow keys keep working. `showClear` gives a way back to null.

## What a browser gave upstream, and what this had to build

Upstream is an `<input type="number">`, so three of its behaviours are the browser’s rather than the design system’s. All three are here, written out:

- **The arrow keys step the value.** Handled above the text field, so the arrows are seen before the caret takes them.
- **The steppers are drawn.** A UA spinner appears on hover in a browser; nothing important may live behind hover here, and a thumb has no arrow keys. They are on by default and can be turned off.
- **Letters are refused as they are typed**, by an input formatter, rather than accepted and rejected later.

What is *not* ported is the mouse wheel changing a focused field’s value. Upstream inherits it from the native control; a wheel that silently edits a number under a scrolling page is a hazard worth losing.

> **Accessibility**
>
> A rejected entry is announced through a live region — see [AstryxVisuallyHidden](visually_hidden.md). Reverting in silence leaves a screen-reader user with no idea their entry was thrown away, which is WCAG 3.3.1, and it is the one thing a hand-built number field almost always misses. The steppers carry names of their own — "Increase Replicas" — and disable themselves at the ends of the range.

### AstryxNumberInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `num?` | — | The committed value, or null for an empty field. |
| `onChanged` | `ValueChanged<num?>?` | — | Called with a newly committed value, or null when cleared. |
| `min` | `num?` | — | The smallest accepted value. |
| `max` | `num?` | — | The largest accepted value. |
| `step` | `num` | `1` | How much a stepper or an arrow key moves the value. |
| `integerOnly` | `bool` | `false` | Whether to refuse anything that is not a whole number. |
| `units` | `String?` | — | A suffix inside the field. |
| `steppers` | `bool` | `true` | Whether to draw the increment and decrement buttons. |
| `showClear` | `bool` | `false` | Whether to show a button that empties the field, committing null. |
| `placeholder` | `String?` | — | Shown while the field is empty. |
| `leading` | `Widget?` | — | Content before the number. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. |
| `size` | `AstryxInputSize?` | — | The control height. |
| `width` | `double?` | — | A fixed width for the whole field. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


## Related

- [AstryxTextInput](text_input.md) — what this is built on.
- [AstryxVisuallyHidden](visually_hidden.md) — how the rejection is announced.

---

Something wrong with `AstryxNumberInput`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxNumberInput&component=AstryxNumberInput) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxNumberInput&area=AstryxNumberInput) — both templates arrive with the component filled in.
