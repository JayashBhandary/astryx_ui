---
title: AstryxComplexSelector
description: A selector with a trigger this package draws and a surface you draw.
component: true
group: Forms
source: lib/src/components/forms/complex_selector.dart
upstream: ComplexSelector
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

[AstryxSelector](selector.md) covers a list of options and [AstryxMultiSelector](multi_selector.md) covers several of them. This covers everything else: a calendar, a grid of swatches, a two-pane picker, a small form inside a popover.

It supplies the parts that are tedious and easy to get wrong — the field, the trigger and its status, the overlay and its positioning, focus trapping, Escape, the barrier — and leaves the contents entirely to you.

```dart
class ComplexSelectorDemoExample extends StatefulWidget {
  const ComplexSelectorDemoExample({super.key});

  @override
  State<ComplexSelectorDemoExample> createState() =>
      _ComplexSelectorDemoExampleState();
}

class _ComplexSelectorDemoExampleState
    extends State<ComplexSelectorDemoExample> {
  AstryxPalette? _palette;

  @override
  Widget build(BuildContext context) {
    // A surface a list of options cannot express: a grid of swatches. The
    // package supplies the field, the trigger and the overlay; the contents are
    // entirely the caller's.
    return AstryxComplexSelector<AstryxPalette?>(
      label: 'Label colour',
      value: _palette,
      placeholder: 'No colour',
      triggerLabel: _palette == null
          ? null
          : AstryxBadge(
              _palette!.name,
              variant: AstryxBadgeVariant.palette(_palette!),
            ),
      onChanged: (value) => setState(() => _palette = value),
      surfaceBuilder: (context, state) => Padding(
        padding: const EdgeInsets.all(8),
        child: AstryxGrid(
          minWidth: 96,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final palette in AstryxPalette.values)
              AstryxButton(
                label: palette.name,
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: AstryxBadge(
                  '  ',
                  variant: AstryxBadgeVariant.palette(palette),
                ),
                onPressed: () {
                  state.onChanged(palette);
                  state.close();
                },
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
AstryxComplexSelector<AstryxPalette?>(
  label: 'Label colour',
  value: _palette,
  triggerLabel: _palette == null ? null : AstryxBadge(_palette!.name),
  onChanged: (value) => setState(() => _palette = value),
  surfaceBuilder: (context, state) => MySwatchGrid(
    selected: state.value,
    onPicked: (palette) {
      state.onChanged(palette);
      state.close();
    },
  ),
)
```

The builder is handed one `AstryxComplexSelectorState`: the current value, a callback to report a new one, and `close`. Reporting does **not** close the surface — a multi-step picker wants to stay open — so closing is a decision of its own, which is why both are on the state. Upstream passes four positional arguments to a render prop; one object is the same information at a call site somebody can read.

`triggerLabel` is a widget rather than a string, because the whole point is a value one string cannot describe: two dates, a swatch, a row of avatars. Null falls back to `placeholder`.

> **Accessibility**
>
> The trigger announces itself as a button, expanded or collapsed, and the overlay traps focus and returns it on Escape. What you build inside is yours to name — nothing else about your surface can be checked from here, which is the price of the freedom.

### AstryxComplexSelector

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | The value, handed to the builder unchanged. |
| `surfaceBuilder` *(required)* | `Widget Function(BuildContext, AstryxComplexSelectorState<T>)` | — | Builds the surface inside the overlay. |
| `onChanged` | `ValueChanged<T>?` | — | Called with a new value. Null makes the selector inert. |
| `triggerLabel` | `Widget?` | — | What the trigger shows. Null shows the placeholder. |
| `side` | `AstryxOverlaySide` | `bottom` | Which side of the trigger the surface opens on. |
| `matchTriggerWidth` | `bool` | `true` | Whether the surface takes the trigger width. |
| `surfaceWidth` | `double?` | — | A fixed surface width. Ignored when `matchTriggerWidth`. |
| `loading` | `bool` | `false` | Whether the value is being fetched. |
| `label` *(required)* | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


## Related

- [AstryxPopover](popover.md) — the overlay this is built on, for a surface that is not a field.
- [AstryxSelector](selector.md) — when a list of options is all you need.

