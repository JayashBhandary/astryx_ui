---
title: AstryxProgressBar
description: A determinate or indeterminate bar, with an announced label.
component: true
group: Status
source: lib/src/components/feedback/progress_bar.dart
upstream: ProgressBar
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ProgressDemoExample extends StatelessWidget {
  const ProgressDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxProgressBar(
        label: 'Uploading footage.mov',
        value: 0.62,
        showValueLabel: true,
      ),
    );
  }
}
```


## Usage

```dart
const AstryxProgressBar(
  label: 'Uploading footage.mov',
  value: 0.62,
  showValueLabel: true,
)
```

`value` is a fraction from 0 to 1, not upstream’s `value`/`max` pair: two numbers that must agree is a bug waiting to happen, and the caller already knows how to divide.

## Variants

```dart
class ProgressVariantsExample extends StatelessWidget {
  const ProgressVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final variant in AstryxProgressVariant.values)
            AstryxProgressBar(
              label: variant.name,
              value: 0.5,
              variant: variant,
            ),
        ],
      ),
    );
  }
}
```


## Indeterminate

A null `value` means "in progress, extent unknown". Under reduced motion the fill stops travelling — the bar stays, the animation does not.

```dart
class ProgressIndeterminateExample extends StatelessWidget {
  const ProgressIndeterminateExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A null value means "in progress, extent unknown". Under reduced motion
    // the fill stops travelling — the bar stays, the animation does not.
    return const SizedBox(
      width: 320,
      child: AstryxProgressBar(label: 'Reindexing search'),
    );
  }
}
```


## Labels

`showLabel: false` hides the text without taking the accessible name away. `formatValue` replaces the percentage with something more meaningful — "18 of 24 seats" beats "75%".

```dart
class ProgressLabelsExample extends StatelessWidget {
  const ProgressLabelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxProgressBar(
            label: 'Default',
            value: 0.4,
            showValueLabel: true,
          ),
          // `showLabel: false` hides the text without taking the accessible
          // name away — the bar is still announced as "Storage used".
          const AstryxProgressBar(
            label: 'Storage used',
            value: 0.4,
            showLabel: false,
          ),
          AstryxProgressBar(
            label: 'Seats',
            value: 18 / 24,
            showValueLabel: true,
            formatValue: (value) => '${(value * 24).round()} of 24',
          ),
        ],
      ),
    );
  }
}
```


## In motion

```dart
class ProgressLiveExample extends StatefulWidget {
  const ProgressLiveExample({super.key});

  @override
  State<ProgressLiveExample> createState() => _ProgressLiveExampleState();
}

class _ProgressLiveExampleState extends State<ProgressLiveExample> {
  double _value = 0.15;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _run() {
    _ticker?.cancel();
    setState(() => _value = 0);
    _ticker = Timer.periodic(const Duration(milliseconds: 320), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _value = (_value + 0.12).clamp(0.0, 1.0));
      if (_value >= 1) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxProgressBar(
            label: 'Importing 240 rows',
            value: _value,
            showValueLabel: true,
            variant: _value >= 1
                ? AstryxProgressVariant.success
                : AstryxProgressVariant.accent,
          ),
          AstryxButton(
            label: _value >= 1 ? 'Run again' : 'Run',
            size: AstryxButtonSize.sm,
            onPressed: _run,
          ),
        ],
      ),
    );
  }
}
```


> **Accessibility**
>
> The bar is announced with its label and its percentage, and the value is published to assistive technology as it changes. Colour alone never carries the outcome: pair a `success` or `error` variant with text.

### AstryxProgressBar

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | What is progressing. Always the accessible name, shown or not. |
| `value` | `double?` | — | Progress from 0 to 1, or null for indeterminate. |
| `variant` | `AstryxProgressVariant` | `AstryxProgressVariant.accent` | What the fill colour means: `accent`, `success`, `warning`, `error` or `neutral`. |
| `showLabel` | `bool` | `true` | Whether to render the label above the track. |
| `showValueLabel` | `bool` | `false` | Whether to render the percentage beside the label. |
| `formatValue` | `String Function(double)?` | — | Formats the value label. Defaults to a whole percentage. |
| `enabled` | `bool` | `true` | Whether the bar reads as active. |


