---
title: AstryxSegmentedControl
description: A small set of mutually exclusive views, all labels visible at once.
component: true
group: Navigation
source: lib/src/components/navigation/segmented_control.dart
upstream: SegmentedControl / SegmentedControlItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SegmentedControlDemoExample extends StatefulWidget {
  const SegmentedControlDemoExample({super.key});

  @override
  State<SegmentedControlDemoExample> createState() =>
      _SegmentedControlDemoExampleState();
}

class _SegmentedControlDemoExampleState
    extends State<SegmentedControlDemoExample> {
  String _range = 'week';
  String _density = 'balanced';

  @override
  Widget build(BuildContext context) {
    // One tab stop; the arrows move *and* choose, and wrap at both ends. It
    // announces itself as a radio group, which is what it is.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSegmentedControl<String>(
          label: 'Range',
          value: _range,
          onChanged: (value) => setState(() => _range = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(value: 'day', label: 'Day'),
            AstryxSegment(value: 'week', label: 'Week'),
            AstryxSegment(value: 'month', label: 'Month'),
            AstryxSegment(value: 'year', label: 'Year', enabled: false),
          ],
        ),
        AstryxSegmentedControl<String>(
          label: 'Density',
          value: _density,
          onChanged: (value) => setState(() => _density = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(
              value: 'compact',
              label: 'Compact',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.menu),
            ),
            AstryxSegment(
              value: 'balanced',
              label: 'Balanced',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.viewColumns),
            ),
          ],
        ),
        AstryxText(
          'Showing $_range, $_density',
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
AstryxSegmentedControl<Range>(
  label: 'Range',
  value: _range,
  onChanged: (range) => setState(() => _range = range),
  segments: const <AstryxSegment<Range>>[
    AstryxSegment(value: Range.day, label: 'Day'),
    AstryxSegment(value: Range.week, label: 'Week'),
  ],
)
```

## Which of the four this is

| Use | When |
| --- | --- |
| `AstryxSegmentedControl` | One choice out of a few — a range, a filter, a density. Announced as a radio group. |
| [AstryxTabList](tab_list.md) | Switching what a page *shows*, at the top of the thing it switches. Announced as tabs. |
| [AstryxToggleButtonGroup](toggle_button.md) | Settings that happen to sit together. Announced as pressed or not. |
| [AstryxRadioList](radio_list.md) | The same choice with more than about five options, or labels longer than a word or two. |

> **Accessibility**
>
> **Keyboarded as an ARIA radiogroup**: one tab stop, the arrows move *and choose*, and they wrap at both ends so nobody has to reverse out of the end. Both axes work, because a user who does not know which way the control runs will try either, and the inline arrows mirror under RTL.

`labelHidden` gives an icon-only segment — a list-or-grid switch — its name without painting it. It needs an `icon`: a segment with neither is a segment nobody can see.

### AstryxSegmentedControl

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `segments` *(required)* | `List<AstryxSegment<T>>` | — | The choices, in the order they are shown and traversed. |
| `value` *(required)* | `T?` | — | The chosen value. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly chosen value. Null makes the control read-only. |
| `label` | `String?` | — | The control’s accessible name. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.md` | The control’s size. |
| `expand` | `bool` | `false` | Whether the segments share the width equally. False hugs the labels. |
| `focusNode` | `FocusNode?` | — | The focus node for the control. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxSegment

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What choosing this segment produces. |
| `label` *(required)* | `String` | — | The visible text, and this segment’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. |
| `enabled` | `bool` | `true` | Whether this segment can be chosen. |
| `labelHidden` | `bool` | `false` | Whether the label is a name for a screen reader only. Requires `icon`. |


---

Something wrong with `AstryxSegmentedControl`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSegmentedControl&component=AstryxSegmentedControl) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSegmentedControl&area=AstryxSegmentedControl) — both templates arrive with the component filled in.
