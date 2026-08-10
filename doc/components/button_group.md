---
title: AstryxButtonGroup
description: Joins related actions into one control, or spaces them as a set.
component: true
group: Actions
source: lib/src/components/action/button_group.dart
upstream: ButtonGroup
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ButtonGroupDemoExample extends StatelessWidget {
  const ButtonGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      children: <Widget>[
        AstryxButton(label: 'Day', onPressed: () {}),
        AstryxButton(label: 'Week', onPressed: () {}),
        AstryxButton(label: 'Month', onPressed: () {}),
      ],
    );
  }
}
```


## Usage

```dart
AstryxButtonGroup(
  children: <Widget>[
    AstryxButton(label: 'Day', onPressed: () {}),
    AstryxButton(label: 'Week', onPressed: () {}),
    AstryxButton(label: 'Month', onPressed: () {}),
  ],
)
```

Attached by default: the corners between neighbours are squared, so the buttons read as one control. The rounding is *directional* — the first child rounds its reading-start corners, which flips under RTL without the group being told which way it is running.

## Composition

```text
AstryxButtonGroup
├── AstryxButton        ← rounds its leading corners
├── AstryxButton        ← square both ends
└── AstryxButton        ← rounds its trailing corners
```

## Selection

The group holds **no selection of its own**. A segmented control is a group whose selected child takes a louder variant — which keeps the selected value wherever the application already keeps state, instead of in a widget.

```dart
class ButtonGroupSegmentedExample extends StatefulWidget {
  const ButtonGroupSegmentedExample({super.key});

  @override
  State<ButtonGroupSegmentedExample> createState() =>
      _ButtonGroupSegmentedExampleState();
}

class _ButtonGroupSegmentedExampleState
    extends State<ButtonGroupSegmentedExample> {
  String _range = 'Week';

  @override
  Widget build(BuildContext context) {
    // The group carries no selection of its own. A segmented control is a
    // group whose selected child takes a louder variant — which keeps the
    // selection where the application already holds it.
    return AstryxButtonGroup(
      children: <Widget>[
        for (final range in const <String>['Day', 'Week', 'Month'])
          AstryxButton(
            label: range,
            variant: range == _range
                ? AstryxButtonVariant.primary
                : AstryxButtonVariant.secondary,
            onPressed: () => setState(() => _range = range),
          ),
      ],
    );
  }
}
```


## Detached

`attached: false` leaves every button its own shape and spaces them by `gap`: a related *set* of actions rather than a segmented control. This is the shape a dialog footer wants.

```dart
class ButtonGroupDetachedExample extends StatelessWidget {
  const ButtonGroupDetachedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      attached: false,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxButton(
          label: 'Publish',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Save draft', onPressed: () {}),
        AstryxButton(
          label: 'Discard',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
      ],
    );
  }
}
```


## Inherited variant and size

`variant` and `size` cascade to every child that does not set its own, so a toolbar of eight ghost buttons says "ghost" once.

```dart
class ButtonGroupInheritedExample extends StatelessWidget {
  const ButtonGroupInheritedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `variant` and `size` cascade: no child repeats them.
    return AstryxButtonGroup(
      variant: AstryxButtonVariant.ghost,
      size: AstryxButtonSize.sm,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.arrowUp,
          label: 'Move up',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowDown,
          label: 'Move down',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Duplicate',
          onPressed: () {},
        ),
      ],
    );
  }
}
```


## Vertical

```dart
class ButtonGroupVerticalExample extends StatelessWidget {
  const ButtonGroupVerticalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      axis: Axis.vertical,
      children: <Widget>[
        AstryxButton(label: 'Zoom in', onPressed: () {}),
        AstryxButton(label: 'Zoom out', onPressed: () {}),
        AstryxButton(label: 'Reset', onPressed: () {}),
      ],
    );
  }
}
```


### AstryxButtonGroup

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The buttons, in order. |
| `variant` | `AstryxButtonVariant?` | — | The variant every child takes unless it sets its own. |
| `size` | `AstryxButtonSize?` | — | The size every child takes unless it sets its own. |
| `axis` | `Axis` | `Axis.horizontal` | Whether the group runs horizontally or vertically. |
| `attached` | `bool` | `true` | Whether the buttons are joined into one visual control. |
| `gap` | `AstryxSpacingToken?` | — | The space between detached buttons. Ignored when `attached`. |


### AstryxButtonGroupScope

The inherited widget the group installs. Read it with `AstryxButtonGroupScope.maybeOf(context)` when building a custom child that should follow the group.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `variant` | `AstryxButtonVariant?` | — | The variant descendants inherit. |
| `size` | `AstryxButtonSize?` | — | The size descendants inherit. |
| `buttonTheme` | `AstryxButtonTheme?` | — | Position-dependent visual overrides — chiefly the corner radii. |


## Related

- [AstryxButton](button.md) — the usual child.
- [AstryxTabList](tab_list.md) — for switching *views*, not for actions.

