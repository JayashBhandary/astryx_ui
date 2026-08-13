---
title: AstryxFormLayout
description: The column and label geometry a form’s fields share.
component: true
group: Forms
source: lib/src/components/forms/form_layout.dart
upstream: FormLayout
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

One gap and one label geometry for a set of fields. It is **not** a `Form`: submission, validation and state stay yours, and this decides only where the fields sit.

```dart
class FormLayoutDirectionsExample extends StatelessWidget {
  const FormLayoutDirectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three arrangements of the same two fields. Nesting works: the horizontal
    // pair below is a row of fields inside a column of them.
    return AstryxFormLayout(
      children: <Widget>[
        AstryxTextInput(label: 'Project name', onChanged: (_) {}),
        AstryxFormLayout(
          direction: AstryxFormLayoutDirection.horizontal,
          children: <Widget>[
            AstryxTextInput(label: 'Region', onChanged: (_) {}),
            AstryxTextInput(label: 'Owner', onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxFormLayout(
  children: <Widget>[
    AstryxTextInput(label: 'Project name', controller: _name),
    AstryxFormLayout(
      direction: AstryxFormLayoutDirection.horizontal,
      children: <Widget>[
        AstryxTextInput(label: 'Region', controller: _region),
        AstryxTextInput(label: 'Owner', controller: _owner),
      ],
    ),
  ],
)
```

| Direction | Arranges |
| --- | --- |
| `vertical` | Stacked. The default, and what most forms want. |
| `horizontal` | Equal columns, one per child — `grid-auto-columns: 1fr` upstream. |
| `horizontalLabels` | Stacked, with each label beside its own control. Collapses to a stack below 480 logical pixels. |

## Labels beside their controls

The settings-panel arrangement, and the only direction that does more than space things out: every [AstryxField](field.md) below it moves its label — and its description — to the side.

```dart
class FormLayoutLabelsExample extends StatelessWidget {
  const FormLayoutLabelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every field below moves its label beside its control, and puts it back
    // above when the form is narrower than 480 logical pixels. Switch the
    // preview to a phone and watch it collapse.
    return AstryxFormLayout(
      direction: AstryxFormLayoutDirection.horizontalLabels,
      labelWidth: 140,
      children: <Widget>[
        AstryxTextInput(label: 'Display name', onChanged: (_) {}),
        AstryxTextInput(
          label: 'Contact email',
          description: 'Only used for alerts.',
          onChanged: (_) {},
        ),
        AstryxSwitch(label: 'Public profile', value: true, onChanged: (_) {}),
      ],
    );
  }
}
```


> **Note**
>
> Switch the preview above to a phone. Below 480 logical pixels — upstream’s own threshold — the labels go back above their controls, because a label column and a usable control do not both fit. It is a change of arrangement rather than a squeeze, so the fields under it stop reserving a column at all.

`labelWidth` sets that column and defaults to 160. Upstream sizes it to its widest label, which CSS grid does for free; Flutter would have to lay every label out twice to match, so a number is the honest version — pick one that fits the longest label in the form.

### AstryxFormLayout

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The fields, in order. |
| `direction` | `AstryxFormLayoutDirection` | `vertical` | How to arrange them. |
| `gap` | `AstryxSpacingToken?` | `spacing4` | The space between fields. |
| `labelWidth` | `double?` | `160` | The label column, under `horizontalLabels`. |


## Related

- [AstryxField](field.md) — the widget that reads this and moves its label.
- [AstryxGrid](grid.md) — for laying out anything that is not a form.
- [Two-column form](form_two_column.md) — a whole screen, assembled.

---

Something wrong with `AstryxFormLayout`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxFormLayout&component=AstryxFormLayout) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxFormLayout&area=AstryxFormLayout) — both templates arrive with the component filled in.
