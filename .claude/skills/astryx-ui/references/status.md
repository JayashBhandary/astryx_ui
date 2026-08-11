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

## AstryxStatusDot

`lib/src/components/feedback/status_dot.dart` · upstream `StatusDot`

A small coloured dot standing for a state, always paired with text.

```dart
class StatusDotDemoExample extends StatelessWidget {
  const StatusDotDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The dot is never the whole message: the words beside it are what a
    // reader who cannot tell green from amber relies on.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (variant, label) in const <(AstryxStatusDotVariant, String)>[
          (AstryxStatusDotVariant.success, 'Healthy'),
          (AstryxStatusDotVariant.warning, 'Degraded'),
          (AstryxStatusDotVariant.error, 'Unreachable'),
          (AstryxStatusDotVariant.accent, 'Deploying'),
          (AstryxStatusDotVariant.neutral, 'Not configured'),
        ])
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxStatusDot(variant, label: label),
              AstryxText(label),
            ],
          ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Never the only thing that says what the state is. Upstream's own description of this component is "always paired with text", and that is the whole rule: colour alone excludes anybody who cannot tell green from amber, and a dot is too small to carry a shape or an icon as well. `label` is required and keeps the state readable to a screen reader — but a sighted reader who cannot see the hue needs the words on the screen. See Colour (references/guides.md).
- **Note:** Upstream's `neutral` theme nudges this component's success, warning and error fills through a per-component style override, and it is transcribed in `lib/src/theme/themes/neutral.dart`. Nothing in this port reads those maps yet — every widget resolves the plain token — so the dot is a shade off upstream in that one theme. It is the same gap for `badge`, `banner`, `switch` and `progressbar`.

| Variant | Token | For |
| --- | --- | --- |
| `success` | `--color-success` | Healthy, online, passing. |
| `warning` | `--color-warning` | Degraded, nearly out — needs attention but is not down. |
| `error` | `--color-error` | Down, failed, rejected. |
| `accent` | `--color-accent` | In progress, or "this one" — a state the accent describes better than a status colour does. |
| `neutral` | `--color-icon-secondary` | Off, idle, unknown. Deliberately not the disabled grey: an unknown state is a state. |

### AstryxStatusDot

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `variant` **(required)** | `AstryxStatusDotVariant` | — | What the dot means, and therefore its colour. Positional. |
| `label` **(required)** | `String` | — | What the state is, in words. The dot's accessible name. |
| `pulsing` | `bool` | `false` | Whether the dot breathes, to say the state is live. Honours reduced motion. |
| `tooltip` | `String?` | — | Hover text explaining the state. |

---

