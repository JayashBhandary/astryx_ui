---
title: AstryxStatusDot
description: A small coloured dot standing for a state, always paired with text.
component: true
group: Status
source: lib/src/components/feedback/status_dot.dart
upstream: StatusDot
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

An 8px circle in one of five semantic colours. It exists to make a state **scannable** down a column of rows — not to state it.

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


## Usage

```dart
AstryxHStack(
  gap: AstryxSpacingToken.spacing2,
  children: const <Widget>[
    AstryxStatusDot(AstryxStatusDotVariant.success, label: 'Online'),
    AstryxText('api-gateway'),
  ],
)
```

> **Accessibility**
>
> Never the only thing that says what the state is. Upstream's own description of this component is "always paired with text", and that is the whole rule: colour alone excludes anybody who cannot tell green from amber, and a dot is too small to carry a shape or an icon as well. `label` is required and keeps the state readable to a screen reader — but a sighted reader who cannot see the hue needs the words on the screen. See [Colour](../guides/color.md).

## Variants

| Variant | Token | For |
| --- | --- | --- |
| `success` | `--color-success` | Healthy, online, passing. |
| `warning` | `--color-warning` | Degraded, nearly out — needs attention but is not down. |
| `error` | `--color-error` | Down, failed, rejected. |
| `accent` | `--color-accent` | In progress, or "this one" — a state the accent describes better than a status colour does. |
| `neutral` | `--color-icon-secondary` | Off, idle, unknown. Deliberately not the disabled grey: an unknown state is a state. |

## Where it earns its keep

A list or a table whose rows already say what the state is. The dot adds nothing to a single line of prose, and everything to forty rows somebody is looking down.

```dart
class StatusDotInPlaceExample extends StatelessWidget {
  const StatusDotInPlaceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Where a dot earns its keep: a list of rows whose text already says what
    // the state is, so the dot only has to make it scannable.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final (variant, service, state, pulsing)
            in const <(AstryxStatusDotVariant, String, String, bool)>[
          (AstryxStatusDotVariant.success, 'api-gateway', 'Healthy', false),
          (AstryxStatusDotVariant.accent, 'billing', 'Deploying', true),
          (AstryxStatusDotVariant.warning, 'search', 'Degraded', false),
          (AstryxStatusDotVariant.error, 'mailer', 'Unreachable', false),
        ])
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                AstryxStatusDot(
                  variant,
                  label: state,
                  pulsing: pulsing,
                  tooltip: '$service is $state'.toLowerCase(),
                ),
                Expanded(child: AstryxText(service)),
                AstryxText(
                  state,
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


`pulsing` says the state is live rather than settled — a deploy in flight, a stream connected. Under reduced motion the dot holds still at full opacity rather than disappearing, which is the same rule the [spinner](spinner.md) and the [progress bar](progress_bar.md) follow: the state stays legible without the movement.

`tooltip` explains a state a word cannot. It is not a substitute for `label`, and not a substitute for the text beside the dot — a third of users have no hover at all. See [Density](../guides/density.md).

## Or a badge

[AstryxBadge](badge.md) carries its own text and can stand alone; a dot cannot. Reach for a dot when the words are already there — a table cell, a list row, a header — and a badge when they are not. A dot beside a badge saying the same thing is one of them too many.

> **Note**
>
> Upstream's `neutral` theme nudges this component's success, warning and error fills through a per-component style override, and it is transcribed in `lib/src/theme/themes/neutral.dart`. Nothing in this port reads those maps yet — every widget resolves the plain token — so the dot is a shade off upstream in that one theme. It is the same gap for `badge`, `banner`, `switch` and `progressbar`.

### AstryxStatusDot

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `variant` *(required)* | `AstryxStatusDotVariant` | — | What the dot means, and therefore its colour. Positional. |
| `label` *(required)* | `String` | — | What the state is, in words. The dot's accessible name. |
| `pulsing` | `bool` | `false` | Whether the dot breathes, to say the state is live. Honours reduced motion. |
| `tooltip` | `String?` | — | Hover text explaining the state. |


## Related

- [AstryxBadge](badge.md) — a state that carries its own text.
- [AstryxBanner](banner.md) — a state that needs a sentence and an action.
- [Colour](../guides/color.md) — why a categorical palette is never severity.

---

Something wrong with `AstryxStatusDot`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxStatusDot&component=AstryxStatusDot) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxStatusDot&area=AstryxStatusDot) — both templates arrive with the component filled in.
