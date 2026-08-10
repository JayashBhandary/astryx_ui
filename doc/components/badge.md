---
title: AstryxBadge
description: 'A small label: a status, a count, a category.'
component: true
group: Surfaces
source: lib/src/components/surface/badge.dart
upstream: Badge
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class BadgeDemoExample extends StatelessWidget {
  const BadgeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText('atlas-api'),
        AstryxBadge('Healthy', variant: AstryxBadgeVariant.success),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxBadge('Healthy', variant: AstryxBadgeVariant.success)
```

## Variants

Five semantic fills.

```dart
class BadgeVariantsExample extends StatelessWidget {
  const BadgeVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge('neutral'),
        AstryxBadge('info', variant: AstryxBadgeVariant.info),
        AstryxBadge('success', variant: AstryxBadgeVariant.success),
        AstryxBadge('warning', variant: AstryxBadgeVariant.warning),
        AstryxBadge('error', variant: AstryxBadgeVariant.error),
      ],
    );
  }
}
```


Plus the ten categorical families.

```dart
class BadgePalettesExample extends StatelessWidget {
  const BadgePalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxBadge(
            palette.name,
            variant: AstryxBadgeVariant.palette(palette),
          ),
      ],
    );
  }
}
```


## Icons

An icon before the text does two jobs: it reads faster, and it means the badge is not relying on colour alone.

```dart
class BadgeIconsExample extends StatelessWidget {
  const BadgeIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge(
          'Deployed',
          icon: AstryxIcon(AstryxIconName.check),
          variant: AstryxBadgeVariant.success,
        ),
        AstryxBadge(
          'Degraded',
          icon: AstryxIcon(AstryxIconName.warning),
          variant: AstryxBadgeVariant.warning,
        ),
        AstryxBadge(
          'Queued',
          icon: AstryxIcon(AstryxIconName.clock),
        ),
      ],
    );
  }
}
```


## Counts

"3" spoken aloud means nothing. `semanticsLabel` is what a screen reader hears instead of the bare number.

```dart
class BadgeCountsExample extends StatelessWidget {
  const BadgeCountsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // "3" spoken aloud means nothing. `semanticsLabel` is what a screen reader
    // hears instead of the bare number.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxBadge('3', semanticsLabel: '3 unread messages'),
        AstryxBadge(
          '12',
          semanticsLabel: '12 failing checks',
          variant: AstryxBadgeVariant.error,
        ),
        AstryxBadge(
          '99+',
          semanticsLabel: 'More than 99 notifications',
          variant: AstryxBadgeVariant.info,
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> A badge is not a button. It has no press state, no focus and no tap target — if it needs to be pressable, it is a [button](button.md) or a pressable [card](card.md) with a badge inside it.

> **Note**
>
> Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error` — a 1.00:1 contrast failure reproduced faithfully here rather than corrected, and pinned by a test. An error badge is where that defect is most visible. Pick a different theme, or override the token.

### AstryxBadge

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The text. The positional first argument. |
| `variant` | `AstryxBadgeVariant` | `AstryxBadgeVariant.neutral` | The colour: `neutral`, `info`, `success`, `warning`, `error`, or `AstryxBadgeVariant.palette(...)`. |
| `icon` | `Widget?` | — | An icon before the text. Any widget; size and colour come from the badge. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |


