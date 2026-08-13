---
title: AstryxToggleButton
description: A button that stays pressed — a setting, not an action.
component: true
group: Actions
source: lib/src/components/action/toggle_button.dart
upstream: ToggleButton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A toolbar’s **Bold**, a filter that stays on, a list-or-grid switch. It looks like a button and behaves like a setting: pressing it does not start something, it changes what is true.

```dart
class ToggleButtonDemoExample extends StatefulWidget {
  const ToggleButtonDemoExample({super.key});

  @override
  State<ToggleButtonDemoExample> createState() =>
      _ToggleButtonDemoExampleState();
}

class _ToggleButtonDemoExampleState extends State<ToggleButtonDemoExample> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // The button owns no state. It reports the state it should move to, and the
    // caller decides — the same contract as every other control here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButton(
          label: 'Only my issues',
          icon: const AstryxIcon(AstryxIconName.funnel),
          pressed: _pressed,
          onChanged: (value) => setState(() => _pressed = value),
        ),
        AstryxText(
          _pressed ? 'Showing 12 of 240 issues.' : 'Showing all 240 issues.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxToggleButton(
  label: 'Only my issues',
  icon: const AstryxIcon(AstryxIconName.funnel),
  pressed: _pressed,
  onChanged: (value) => setState(() => _pressed = value),
)
```

The button holds nothing. `onChanged` reports the state it should move to, and the caller owns the boolean — the same contract as [AstryxCheckbox](checkbox.md) and [AstryxSwitch](switch.md). Upstream calls this `onPressedChange`; it is `onChanged` here so that every stateful control in the package answers to one name.

> **Note**
>
> There is no `variant`. A toggle is always a ghost button, because the pressed fill *is* its visual language — a filled variant would have nothing left to say when it went on.

## Which widget, though

| Reach for | When |
| --- | --- |
| `AstryxToggleButton` | A toolbar control, a formatting mark, a filter chip that stays down. It lives beside other buttons and looks like one. |
| [AstryxSwitch](switch.md) | A setting in a form. It is labelled, announced as a switch, and reads as configuration rather than as a control you press. |
| [AstryxCheckbox](checkbox.md) | A value being selected, especially in a list or a set of options. |
| [AstryxTabList](tab_list.md) | Switching what a panel shows. Tabs, not toggles — a tab strip always has exactly one selection. |

## Icon only

Upstream calls this `isIconOnly`; here it is `labelHidden`, the name the form controls already use for "keep the name, drop the text". The button squares off and — unless you pass a `tooltip` of your own — takes the label as its tooltip, so a reader who does not know the glyph still has somewhere to look.

```dart
class ToggleButtonIconOnlyExample extends StatefulWidget {
  const ToggleButtonIconOnlyExample({super.key});

  @override
  State<ToggleButtonIconOnlyExample> createState() =>
      _ToggleButtonIconOnlyExampleState();
}

class _ToggleButtonIconOnlyExampleState
    extends State<ToggleButtonIconOnlyExample> {
  bool _watching = false;

  @override
  Widget build(BuildContext context) {
    // `labelHidden` keeps the label as the accessible name and stops painting
    // it: the button squares off and takes the label as its tooltip, so the
    // glyph is never the only thing a reader has.
    return AstryxToggleButton(
      label: 'Watch this repository',
      labelHidden: true,
      icon: const AstryxIcon(AstryxIconName.eyeSlash),
      pressedIcon: const AstryxIcon(AstryxIconName.check),
      pressed: _watching,
      onChanged: (value) => setState(() => _watching = value),
    );
  }
}
```


```dart
AstryxToggleButton(
  label: 'Watch this repository',
  labelHidden: true,
  icon: const AstryxIcon(AstryxIconName.eyeSlash),
  pressedIcon: const AstryxIcon(AstryxIconName.check),
  pressed: _watching,
  onChanged: (value) => setState(() => _watching = value),
)
```

`pressedIcon` swaps the glyph while the button is on — an outline becoming a fill, upstream’s own use for it. It falls back to `icon`, so a toggle with one glyph needs nothing extra. Colour a pressed glyph by passing an already-coloured widget.

## States

```dart
class ToggleButtonStatesExample extends StatelessWidget {
  const ToggleButtonStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Disabled and loading both refuse the press. Loading also reports the wait
    // to a screen reader, and keeps the button's width so the row cannot jump.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxToggleButton(label: 'Off'),
        AstryxToggleButton(label: 'On', pressed: true),
        AstryxToggleButton(label: 'Disabled', enabled: false),
        AstryxToggleButton(label: 'Saving', pressed: true, loading: true),
      ],
    );
  }
}
```


Disabled and loading both refuse the press; loading also announces the wait and keeps the button’s width, so a toolbar does not jump. The pressed fill is `--color-overlay-pressed` over the transparent ghost background.

> **Note**
>
> A pressed toggle does not change under a pointer. Upstream applies the pressed fill unconditionally, which overrides its own hover tint, and that is reproduced here — two overlapping "this one is active" signals read worse than one that holds still. Focus and press feedback are unaffected.

## Accessibility

- The label is **required**, and is the accessible name whether it is painted or not.
- A toggle reports a **selected** state; a plain button has no such state at all, so nothing announces "not selected" about a Save button. Upstream spells it `aria-pressed`; Flutter’s nearest flag is `selected`, which is what `SegmentedButton` uses in the framework itself.
- Enter and Space activate it, and the focus ring lands on the painted bounds while the touch target grows underneath. See [Density](../guides/density.md).
- The pressed state is never colour alone: the label also shifts to semibold.

> **Careful**
>
> Windows High Contrast is not covered. Upstream repaints the pressed state with the platform `Highlight` colours under `forced-colors`, and Flutter has no equivalent — `MediaQuery.highContrast` is a preference, not a forced palette. On a forced-colours desktop the pressed fill may be dropped, and the weight shift is what remains.

## Two things upstream has that this does not

- **`pressedChangeAction`.** Upstream takes an async callback, runs it in a React transition, and shows an optimistic pressed state with a spinner until it settles. There is no transition model to port it onto; drive `pressed` and `loading` yourself, which is how every other control in this package reports work in flight.
- **`children`.** Upstream lets visible content replace the label. Here the label is the text, as on [AstryxButton](button.md) — one way to name a button rather than two.

### AstryxToggleButton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the accessible name. |
| `pressed` | `bool` | `false` | Whether the button is on. Ignored inside a group. |
| `onChanged` | `ValueChanged<bool>?` | — | Called with the state to move to. Null makes the button inert; ignored inside a group. |
| `value` | `String?` | — | This button’s identity inside an `AstryxToggleButtonGroup`. Required there, meaningless outside. |
| `icon` | `Widget?` | — | Content before the label. |
| `pressedIcon` | `Widget?` | — | The glyph shown while pressed. Falls back to `icon`. |
| `labelHidden` | `bool` | `false` | Keeps the label as the accessible name without painting it: the button squares off and tooltips itself. |
| `size` | `AstryxButtonSize?` | — | The control height. Null takes the group’s, then the inherited size. |
| `enabled` | `bool` | `true` | Whether the button accepts interaction. **Ignored inside a group**, which decides for its children. |
| `loading` | `bool` | `false` | Whether work is in flight. Suppresses activation and shows a spinner. |
| `tooltip` | `String?` | — | Hover text. Defaults to `label` when `labelHidden`. |
| `focusNode` | `FocusNode?` | — | The focus node, if you own one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides, merged over `AstryxThemeData.button`. |


## Related

- [AstryxToggleButtonGroup](toggle_button_group.md) — several of these as one control.
- [AstryxButton](button.md) — the action that does not stay pressed.
- [AstryxSwitch](switch.md) — the setting that does not look like a button.

---

Something wrong with `AstryxToggleButton`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxToggleButton&component=AstryxToggleButton) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxToggleButton&area=AstryxToggleButton) — both templates arrive with the component filled in.
