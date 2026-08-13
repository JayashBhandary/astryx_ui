---
title: AstryxSlider
description: A value, or a range, chosen by dragging along a track.
component: true
group: Forms
source: lib/src/components/forms/slider.dart
upstream: Slider
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

For a value where *approximately* is the point: a threshold, a volume, a tolerance. A slider that has to land on an exact number is the wrong control — use [AstryxNumberInput](number_input.md), or put one beside it.

```dart
class SliderDemoExample extends StatefulWidget {
  const SliderDemoExample({super.key});

  @override
  State<SliderDemoExample> createState() => _SliderDemoExampleState();
}

class _SliderDemoExampleState extends State<SliderDemoExample> {
  num _threshold = 40;

  @override
  Widget build(BuildContext context) {
    return AstryxSlider(
      label: 'Alert threshold',
      description: 'Warn when usage passes this share of the quota.',
      value: _threshold,
      step: 5,
      marks: const <AstryxSliderMark>[
        AstryxSliderMark(0),
        AstryxSliderMark(50),
        AstryxSliderMark(100),
      ],
      formatValue: (value) => '$value%',
      valueDisplay: AstryxSliderValueDisplay.text,
      onChanged: (value) => setState(() => _threshold = value),
    );
  }
}
```


## Usage

```dart
AstryxSlider(
  label: 'Alert threshold',
  value: _threshold,
  step: 5,
  formatValue: (value) => '$value%',
  onChanged: (value) => setState(() => _threshold = value),
)
```

`onChanged` fires throughout a drag; `onChangeEnd` fires once it settles, and is where a request belongs. A keyboard move fires both, because there is no drag to end and a consumer listening only for the end would never hear about it.

## A range

```dart
class SliderRangeExample extends StatefulWidget {
  const SliderRangeExample({super.key});

  @override
  State<SliderRangeExample> createState() => _SliderRangeExampleState();
}

class _SliderRangeExampleState extends State<SliderRangeExample> {
  (num, num) _band = (20, 60);

  @override
  Widget build(BuildContext context) {
    // Two thumbs that cannot cross, and cannot come closer than two steps.
    // Each is its own tab stop and its own announced control.
    return AstryxSlider.range(
      label: 'Acceptable latency',
      values: _band,
      max: 200,
      step: 10,
      minStepsBetweenThumbs: 2,
      formatValue: (value) => '${value}ms',
      valueDisplay: AstryxSliderValueDisplay.text,
      onChanged: (values) => setState(() => _band = values),
    );
  }
}
```


`AstryxSlider.range` takes two values as a tuple and keeps them in order: a thumb stops where the other one is, less `minStepsBetweenThumbs` steps. Each thumb is its own tab stop and its own announced control — "Acceptable latency, start" and "…, end".

## Marks, and how the value reads

| Set | Gets you |
| --- | --- |
| `marks` | Ticks at the values you name. Decoration only: not snap targets, and not announced. |
| `formatValue` | How a value is written **and** announced — "40%", "150ms". Without it a value is written plainly and an integral one drops its `.0`. |
| `valueDisplay` | `text` puts the value above the track, `none` shows nothing. |
| `orientation` | Vertical runs bottom to top and needs a `length`, having nothing to stretch to. |

## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves to the thumb — each thumb of a range in turn. |
| `←` `→` | One step, mirrored under RTL. |
| `↑` `↓` | One step. Never mirrored. |
| `Page Up` `Page Down` | Ten steps. |
| `Home` `End` | The bottom or the top of the scale. |

> **Accessibility**
>
> Each thumb is a `slider` to assistive technology, carrying the **formatted** value and increase and decrease actions — so a switch or voice user can move it without a keyboard. The thumb also carries a full tap target, which is why it answers a thumb as well as a mouse.

> **Careful**
>
> Upstream inherits its thumb from a native `input[type=range]`, and the browser supplies a value tooltip on hover. `valueDisplay: tooltip` therefore shows nothing here yet — use `text`, which is visible to everyone rather than only to a pointer, and is what this page uses.

### AstryxSlider

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `num` | — | The value. Single-thumb constructor. |
| `values` *(required)* | `(num, num)` | — | The two values, low then high. `AstryxSlider.range` only. |
| `onChanged` | `ValueChanged?` | — | Fires throughout a drag. |
| `onChangeEnd` | `ValueChanged?` | — | Fires once a drag settles, and on every keyboard move. |
| `min` | `num` | `0` | The bottom of the scale. |
| `max` | `num` | `100` | The top of the scale. |
| `step` | `num` | `1` | The granularity. |
| `minStepsBetweenThumbs` | `int` | `0` | The fewest steps between the two thumbs of a range. |
| `orientation` | `AstryxSliderOrientation` | `horizontal` | Which way the track runs. |
| `valueDisplay` | `AstryxSliderValueDisplay` | `tooltip` | How the value is shown. |
| `marks` | `List<AstryxSliderMark>` | `const []` | Ticks along the track. |
| `formatValue` | `String Function(num)?` | — | Formats a value for display and for assistive technology. |
| `length` | `double` | `200` | The track extent. Horizontal sliders stretch and ignore it. |
| `label` *(required)* | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


## Related

- [AstryxNumberInput](number_input.md) — for a value that must be exact.
- [AstryxProgressBar](progress_bar.md) — which looks similar and is not a control: progress is reported, not chosen.

---

Something wrong with `AstryxSlider`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSlider&component=AstryxSlider) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSlider&area=AstryxSlider) — both templates arrive with the component filled in.
