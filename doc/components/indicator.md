---
title: The indicators
description: The stateful control visuals, as widgets in their own right.
component: true
group: Forms
source: lib/src/components/forms/indicator.dart
upstream: CheckboxIndicator / RadioIndicator / CheckIndicator
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class IndicatorDemoExample extends StatelessWidget {
  const IndicatorDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The three visuals, on their own. Each is decoration: it owns no role, no
    // focus and no gesture, and the control that renders one keeps all of
    // that. Reach for AstryxCheckbox or AstryxRadioList first.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxCheckboxIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Checkbox', type: AstryxTextType.supporting),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxRadioIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Radio', type: AstryxTextType.supporting),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxCheckIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Check', type: AstryxTextType.supporting),
          ],
        ),
      ],
    );
  }
}
```


An **indicator** is the picture a control draws for its state: the box a checkbox fills, the circle a radio fills, the mark on a chosen row. Upstream componentised them so a theme can restyle or replace one and every control that draws it follows. The same three are here for that reason, and for the case a registry cannot cover: a row this package has no widget for — a custom listbox, a menu of layer visibilities, a table cell — that has to draw the *same* box as a real checkbox rather than an approximation of one.

> **Careful**
>
> Reach for [AstryxCheckbox](checkbox.md), [AstryxRadioList](radio_list.md) or [AstryxSelectableCard](selectable_card.md) first. They are these visuals plus the label, the semantics, the focus ring and the tap target, and hand-building those around a bare indicator is how a control ends up unreachable by keyboard.

## States

A checkbox draws all three states; a radio and a check draw two, and assert in debug if handed `indeterminate` — a radio stands for one choice out of several, and "partly this one" is not a thing it can mean. The partial state is a bar rather than a half-tick, because a tick at any weight says "all of these"; it fills the chrome too, since a partially checked parent is not an unchecked one.

```dart
class IndicatorStatesExample extends StatelessWidget {
  const IndicatorStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A checkbox has three states; a radio and a check have two. The partial
    // state is a bar rather than a half-tick, because a tick at any weight
    // says "all of these".
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final state in AstryxIndicatorState.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxCheckboxIndicator(state: state),
              if (state != AstryxIndicatorState.indeterminate) ...<Widget>[
                AstryxRadioIndicator(state: state),
                AstryxCheckIndicator(state: state),
              ],
              AstryxText(state.name, type: AstryxTextType.supporting),
            ],
          ),
      ],
    );
  }
}
```


## In a row of your own

What they are for. The row keeps the role, the accessible name, the focus and the gesture; the indicator only turns state into a picture. `AstryxCheckIndicator` draws no chrome of its own — it *is* the glyph, in a reserved 16px slot so the row does not shift when the mark appears — which is what makes it right for a menu row or a selector option, where a full checkbox beside every line would turn a list of choices into a form.

```dart
class IndicatorRowExample extends StatefulWidget {
  const IndicatorRowExample({super.key});

  @override
  State<IndicatorRowExample> createState() => _IndicatorRowExampleState();
}

class _IndicatorRowExampleState extends State<IndicatorRowExample> {
  final Set<String> _visible = <String>{'Roads', 'Labels'};

  @override
  Widget build(BuildContext context) {
    // What an indicator is for: a row this package has no widget for — here a
    // layer list — that has to draw the *same* box as a real checkbox rather
    // than an approximation of one. The row keeps the semantics and the
    // gesture; the indicator only turns state into a picture.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final layer in const <String>['Roads', 'Labels', 'Terrain'])
          AstryxItem(
            label: layer,
            leading: AstryxCheckboxIndicator(
              state: _visible.contains(layer)
                  ? AstryxIndicatorState.checked
                  : AstryxIndicatorState.unchecked,
              size: AstryxIndicatorSize.sm,
            ),
            onPressed: () => setState(() {
              _visible.contains(layer)
                  ? _visible.remove(layer)
                  : _visible.add(layer);
            }),
          ),
      ],
    );
  }
}
```


> **Accessibility**
>
> All three are **decorative**: each is hidden from assistive technology and owns no role, no focus and no gesture. An indicator announced next to the control that owns the name is the same thing said twice. `hovered` is the host’s to decide, because only it knows whether the pointer is over the row or only over the box — gate it on `AstryxTheme.densityOf(context).supportsHover`, since touch has no hover at all.

### AstryxCheckboxIndicator, AstryxRadioIndicator

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `state` *(required)* | `AstryxIndicatorState` | — | Which state to draw: `unchecked`, `checked` or — checkbox only — `indeterminate`. |
| `size` | `AstryxIndicatorSize` | `AstryxIndicatorSize.md` | The control size: `sm` is a 20px box, `md` a 24px one. |
| `enabled` | `bool` | `true` | Whether the hosting control accepts input. Purely visual — the host still owns the disabled semantics. |
| `hovered` | `bool` | `false` | Whether hover styling applies. The host decides. |
| `child` | `Widget?` | — | Drawn inside the chrome instead of the state mark — a spinner, while a change is in flight. |


### AstryxCheckIndicator

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `state` *(required)* | `AstryxIndicatorState` | — | Which state to draw. Never `indeterminate`. |
| `size` | `AstryxIndicatorSize` | `AstryxIndicatorSize.md` | The control size. The glyph is `sm` at both — this only reserves the slot. |
| `enabled` | `bool` | `true` | Whether the hosting control accepts input. |
| `child` | `Widget?` | — | Drawn in the slot instead of the mark. |


---

Something wrong with `The indicators`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+The+indicators&component=The+indicators) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+The+indicators&area=The+indicators) — both templates arrive with the component filled in.
