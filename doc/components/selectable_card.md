---
title: AstryxSelectableCard
description: A card that carries selection state — a card-shaped radio or checkbox.
component: true
group: Surfaces
source: lib/src/components/surface/selectable_card.dart
upstream: SelectableCard
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SelectableCardDemoExample extends StatefulWidget {
  const SelectableCardDemoExample({super.key});

  @override
  State<SelectableCardDemoExample> createState() =>
      _SelectableCardDemoExampleState();
}

class _SelectableCardDemoExampleState extends State<SelectableCardDemoExample> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    // One choice out of three, where each option carries a price and a line of
    // detail — more than a radio row can hold, which is the whole reason to
    // reach for a card here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final plan in const <List<String>>[
          <String>['starter', 'Starter', r'$0', 'One project, one seat'],
          <String>['pro', 'Pro', r'$20', 'Unlimited projects, five seats'],
          <String>['scale', 'Scale', r'$80', 'Unlimited seats, SSO, audit log'],
        ])
          AstryxSelectableCard(
            label: '${plan[1]} plan',
            semanticsHint: '${plan[2]} per month. ${plan[3]}',
            control: AstryxSelectableCardControl.radio,
            selected: _plan == plan[0],
            onSelectedChanged: (_) => setState(() => _plan = plan[0]),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  justify: AstryxStackJustify.between,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: AstryxText(plan[1], type: AstryxTextType.large),
                    ),
                    AstryxText('${plan[2]}/mo'),
                  ],
                ),
                AstryxText(
                  plan[3],
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
AstryxSelectableCard(
  label: 'Pro plan',
  control: AstryxSelectableCardControl.radio,
  selected: plan == Plan.pro,
  onSelectedChanged: (_) => setState(() => plan = Plan.pro),
  child: const AstryxText('Unlimited projects'),
)
```

A [card](card.md) records nothing and a pressable one *does* something; this one *records* something. Reach for it when a choice needs more than a line of text — a plan with a price, a region with a latency, an integration with a logo. Below that the choice belongs in an [AstryxRadioList](radio_list.md) or an [AstryxCheckboxList](checkbox_list.md), which are cheaper to scan and cheaper to operate.

## Checkbox or radio

`control` is the same distinction as a [checkbox](checkbox.md) against a [radio group](radio_list.md), moved onto a card: a checkbox card is one of several independent choices, a radio card is one choice out of several. It changes the control that is drawn, what a screen reader is told, and what a second press does.

| Control | Announced as | Pressing it again |
| --- | --- | --- |
| `checkbox` | a checkbox, checked or not | deselects it |
| `radio` | a radio, `inMutuallyExclusiveGroup` | **reports nothing** |

A radio card reporting nothing is deliberate, and is what a native radio does: a choice out of several cannot be un-made by pressing it again, and reporting `false` would let a group end up with nothing selected.

```dart
class SelectableCardControlsExample extends StatefulWidget {
  const SelectableCardControlsExample({super.key});

  @override
  State<SelectableCardControlsExample> createState() =>
      _SelectableCardControlsExampleState();
}

class _SelectableCardControlsExampleState
    extends State<SelectableCardControlsExample> {
  final Set<String> _regions = <String>{'iad'};

  @override
  Widget build(BuildContext context) {
    // A checkbox card is an independent choice, so any number of these can be
    // on at once — the same distinction as `AstryxCheckbox` against
    // `AstryxRadioList`, moved onto a card.
    return AstryxGrid(
      minWidth: 200,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final region in const <List<String>>[
          <String>['iad', 'us-east', '12 ms'],
          <String>['fra', 'eu-central', '86 ms'],
          <String>['bom', 'ap-south', '148 ms'],
        ])
          AstryxSelectableCard(
            label: '${region[1]} region',
            selected: _regions.contains(region[0]),
            onSelectedChanged: (selected) => setState(() {
              if (selected) {
                _regions.add(region[0]);
              } else {
                _regions.remove(region[0]);
              }
            }),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(region[1]),
                AstryxText(
                  '${region[2]} from here',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```


## Anatomy

```text
AstryxSelectableCard
├── control   ← a checkbox or a radio, at the reading-start edge
└── child     ← the content. Required, and arbitrary
```

There is one slot, not the card’s three: a header above the control would put the choice’s title out of line with the thing that records it. Compose the inside with the stacks, as the examples do. `padding` is both the card’s inset and the gap between the control and the content, so the rhythm cannot drift.

## Selection

Selection shows three ways at once — the control fills, the border takes the accent, and the surface takes `--color-accent-muted`. A card is large enough that a user scanning for the selected one should not have to hunt for a small tick.

The border and the tint are dropped when the card cannot be operated, because a tint that survives that reads as an affordance the card does not have — the same rule [AstryxCheckboxList](checkbox_list.md) applies to a checked row. The control still fills, so a card the user cannot change is still visibly the selected one.

```dart
class SelectableCardStatesExample extends StatelessWidget {
  const SelectableCardStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The three ways a card stops being an ordinary control, side by side. Note
    // that the last two still fill the box: a card the user cannot change is
    // still visibly the selected one, even though the accent border and the
    // tint — which read as an affordance — are gone.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSelectableCard(
          label: 'Selected',
          selected: true,
          onSelectedChanged: (_) {},
          child: const AstryxText('Selected, and yours to change'),
        ),
        const AstryxSelectableCard(
          label: 'Shown elsewhere',
          selected: true,
          child: AstryxText('A null callback: inert, but not dimmed'),
        ),
        AstryxSelectableCard(
          label: 'Unavailable',
          selected: true,
          enabled: false,
          onSelectedChanged: (_) {},
          child: const AstryxText('Disabled: dimmed, and skipped by Tab'),
        ),
      ],
    );
  }
}
```


| State | Set by | Reads as |
| --- | --- | --- |
| Interactive | `onSelectedChanged` non-null, `enabled: true` | hover, press, a focus ring, a tap target |
| Inert | `onSelectedChanged: null` | not dimmed, still focusable and still announced, no tap action |
| Disabled | `enabled: false` | dimmed, skipped by Tab, `enabled: false` announced |

## Size

`controlSize` sizes the control, not the card: `AstryxToggleSize.sm` is a 20px box rather than 24px, the same two sizes the [checkbox](checkbox.md) comes in. With `padding` one step down it is what a card holding a single line wants, so the card is not mostly box.

```dart
class SelectableCardCompactExample extends StatefulWidget {
  const SelectableCardCompactExample({super.key});

  @override
  State<SelectableCardCompactExample> createState() =>
      _SelectableCardCompactExampleState();
}

class _SelectableCardCompactExampleState
    extends State<SelectableCardCompactExample> {
  String _speed = 'balanced';

  @override
  Widget build(BuildContext context) {
    // `controlSize` sizes the control, not the card. At `sm`, with the padding
    // one step down, a card holding a single line stops being mostly box.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final speed in const <String>['fast', 'balanced', 'thorough'])
          AstryxSelectableCard(
            label: speed,
            control: AstryxSelectableCardControl.radio,
            controlSize: AstryxToggleSize.sm,
            padding: AstryxSpacingToken.spacing3,
            selected: _speed == speed,
            onSelectedChanged: (_) => setState(() => _speed = speed),
            child: AstryxText(speed),
          ),
      ],
    );
  }
}
```


> **Accessibility**
>
> `label` is **required**, and is not painted. Without it a screen reader announces the card’s whole contents as the control’s name, which for a heading, a price and a badge is a sentence nobody can act on. The content keeps its own semantics nodes, so it is still read — after the user has been told what the card is. Put anything else it needs to hear in `semanticsHint`.

> **Note**
>
> Each card is its own tab stop, unlike [AstryxRadioList](radio_list.md), which is one tab stop with arrow-key traversal. A set of cards is a set of separate controls — there is no shared `name` to group them the way a browser groups native radios — so Tab visits each one. That is the cost of the extra content; for four or more terse options, the radio list is the better control.

### AstryxSelectableCard

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content beside the control. |
| `label` *(required)* | `String` | — | The accessible name. Required, and never painted. |
| `selected` *(required)* | `bool` | — | Whether the card is selected. |
| `onSelectedChanged` | `ValueChanged<bool>?` | — | Called with the selection a press would produce. Null leaves the card inert without dimming it. |
| `control` | `AstryxSelectableCardControl` | `AstryxSelectableCardControl.checkbox` | Whether the card behaves as a checkbox or as a radio. |
| `controlSize` | `AstryxToggleSize` | `AstryxToggleSize.md` | The size of the control, not of the card. |
| `variant` | `AstryxCardVariant` | `AstryxCardVariant.standard` | The unselected fill. Selection overrides it. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The inner padding, and the gap between the control and the content. |
| `enabled` | `bool` | `true` | Whether the card accepts input. |
| `semanticsHint` | `String?` | — | What a screen reader reads after the name — a price, a caveat, why the card is unavailable. |
| `width` | `double?` | — | A fixed width. Null sizes to the parent. |
| `maxWidth` | `double?` | — | A ceiling on the width. |
| `minHeight` | `double?` | — | A floor under the height. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxSelectableCardControl

Which control the card draws, and therefore what it means.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `checkbox` | `AstryxSelectableCardControl` | — | A checkbox. Any number of cards in the set may be selected, and pressing a selected card deselects it. The default. |
| `radio` | `AstryxSelectableCardControl` | — | A radio. One card in the set is selected, and pressing it again reports nothing. |


## Related

- [AstryxCard](card.md) — the same surface, for content rather than a choice.
- [AstryxRadioList](radio_list.md) — one choice out of several, as rows.
- [AstryxCheckboxList](checkbox_list.md) — independent choices, as rows.

---

Something wrong with `AstryxSelectableCard`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSelectableCard&component=AstryxSelectableCard) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSelectableCard&area=AstryxSelectableCard) — both templates arrive with the component filled in.
