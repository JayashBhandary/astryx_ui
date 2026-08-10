# Status

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxSpinner

`lib/src/components/feedback/spinner.dart` · upstream `Spinner`

An indeterminate wait, in three sizes.

```dart
class SpinnerDemoExample extends StatelessWidget {
  const SpinnerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxSpinner(label: 'Loading projects'),
        AstryxText('Loading projects…', color: AstryxTextColor.secondary),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** `label` is announced, and defaults to a localised "Loading" string. Set it to null *only* when a surrounding container already announces the wait — two live regions competing is worse than one.
- **Note:** Under `prefers-reduced-motion` the spinner stops rotating and paints a complete ring instead, so the state is still legible without the movement.

### AstryxSpinner

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `size` | `AstryxSpinnerSize` | `AstryxSpinnerSize.md` | The diameter and stroke width: `sm` 10px, `md` 14px, `lg` 18px. |
| `shade` | `AstryxSpinnerShade` | `AstryxSpinnerShade.accent` | How prominent the spinner is: `accent`, `subtle`, `onMedia` or `inherit`. |
| `label` | `String?` | — | What is being waited for, announced to assistive technology. Null uses the localised default. |
| `color` | `Color?` | — | Overrides the colour the `shade` resolves to. |

---

## AstryxSkeleton

`lib/src/components/feedback/skeleton.dart` · upstream `Skeleton`

A placeholder in the shape of the content that is coming.

```dart
class SkeletonDemoExample extends StatelessWidget {
  const SkeletonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSkeleton.text(),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.6),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** A skeleton is decoration and is hidden from assistive technology. Announce the wait once, at the container — a screen reader reading twelve "loading" boxes has been told nothing twelve times.

### AstryxSkeleton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `width` | `double?` | — | A fixed width. Null fills the available space. Default constructor only. |
| `widthFactor` | `double?` | — | The fraction of the available width to fill. `AstryxSkeleton.text` only. |
| `height` | `double` | `16 (14 for `.text`)` | The height. |
| `radius` | `AstryxRadiusToken` | `AstryxRadiusToken.inner` | The corner radius token. |
| `delay` | `Duration` | `Duration(milliseconds: 250)` | How long to wait before the pulse begins. |

---

## AstryxProgressBar

`lib/src/components/feedback/progress_bar.dart` · upstream `ProgressBar`

A determinate or indeterminate bar, with an announced label.

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

**Rules**

- **Accessibility:** The bar is announced with its label and its percentage, and the value is published to assistive technology as it changes. Colour alone never carries the outcome: pair a `success` or `error` variant with text.

### AstryxProgressBar

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | What is progressing. Always the accessible name, shown or not. |
| `value` | `double?` | — | Progress from 0 to 1, or null for indeterminate. |
| `variant` | `AstryxProgressVariant` | `AstryxProgressVariant.accent` | What the fill colour means: `accent`, `success`, `warning`, `error` or `neutral`. |
| `showLabel` | `bool` | `true` | Whether to render the label above the track. |
| `showValueLabel` | `bool` | `false` | Whether to render the percentage beside the label. |
| `formatValue` | `String Function(double)?` | — | Formats the value label. Defaults to a whole percentage. |
| `enabled` | `bool` | `true` | Whether the bar reads as active. |

---

