---
title: AstryxTooltip
description: A short phrase on hover, focus, or long-press.
component: true
group: Overlays
source: lib/src/components/overlay/tooltip.dart
upstream: Tooltip / useTooltip
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TooltipDemoExample extends StatelessWidget {
  const TooltipDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTooltip(
      message: 'Archive this conversation',
      child: AstryxIconButton(
        icon: AstryxIconName.check,
        label: 'Archive',
        onPressed: () {},
      ),
    );
  }
}
```


## Usage

```dart
AstryxTooltip(
  message: 'Archive this conversation',
  child: AstryxIconButton(
    icon: AstryxIconName.check,
    label: 'Archive',
    onPressed: archive,
  ),
)
```

Unlike every other overlay here, a tooltip takes a `child` rather than a builder — it opens on hover and long-press, not on a tap, so it never competes with the trigger for the press.

> **Careful**
>
> Never put anything essential in a tooltip alone. On touch it is unreachable until someone thinks to long-press, and on a keyboard it arrives only on focus. A tooltip repeats or clarifies; it does not inform.

## Positioning

Above by default, as upstream does.

```dart
class TooltipSidesExample extends StatelessWidget {
  const TooltipSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final side in AstryxOverlaySide.values)
          AstryxTooltip(
            message: 'Anchored ${side.name}',
            side: side,
            showArrow: true,
            child: AstryxButton(label: side.name, onPressed: () {}),
          ),
      ],
    );
  }
}
```


## Timing

The wait is what stops a tooltip firing at everything a mouse crosses on its way somewhere else. `showDuration` applies only to the touch path: a touch tooltip cannot hide on release, because the finger is over the thing it describes and letting go is how you get out of the way to read it — so it lingers instead.

```dart
class TooltipTimingExample extends StatelessWidget {
  const TooltipTimingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The wait is what stops a tooltip firing at everything the mouse crosses
    // on its way somewhere else.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxTooltip(
          message: 'Appears at once',
          waitDuration: Duration.zero,
          child: AstryxButton(label: 'No wait', onPressed: () {}),
        ),
        AstryxTooltip(
          message: 'Appears after 200ms — the default',
          child: AstryxButton(label: 'Default', onPressed: () {}),
        ),
        AstryxTooltip(
          message: 'Appears after a second',
          waitDuration: const Duration(seconds: 1),
          exitDuration: const Duration(milliseconds: 400),
          child: AstryxButton(label: 'Patient', onPressed: () {}),
        ),
      ],
    );
  }
}
```


## Semantics

Set `excludeFromSemantics: true` when the message repeats the trigger’s own accessible name. An icon button labelled "Archive" with the tooltip "Archive" announces it twice otherwise.

```dart
class TooltipSemanticsExample extends StatelessWidget {
  const TooltipSemanticsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // The tooltip repeats the button's own name, so it is left out of the
        // semantics tree. Hearing "Archive, Archive" is worse than silence.
        AstryxTooltip(
          message: 'Archive',
          excludeFromSemantics: true,
          child: AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Archive',
            onPressed: () {},
          ),
        ),
        // This one says something the name does not, so it stays announced.
        AstryxTooltip(
          message: 'Archived items are kept for 30 days',
          child: AstryxIconButton(
            icon: AstryxIconName.info,
            label: 'About archiving',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
```


## Long messages

```dart
class TooltipWrappingExample extends StatelessWidget {
  const TooltipWrappingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTooltip(
      maxWidth: 220,
      message:
          'Long tooltips wrap at maxWidth. Even so: never put anything '
          'essential in a tooltip alone — it is unreachable on touch until '
          'someone thinks to long-press.',
      child: AstryxButton(label: 'Hover for a while', onPressed: () {}),
    );
  }
}
```


### AstryxTooltip

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `message` *(required)* | `String` | — | The text to show. Keep it short. |
| `child` *(required)* | `Widget` | — | The trigger. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.top` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.center` | Alignment along the trigger’s edge. |
| `waitDuration` | `Duration` | `Duration(milliseconds: 200)` | How long a pointer must rest before the tooltip appears. |
| `exitDuration` | `Duration` | `Duration.zero` | How long after the pointer leaves before it hides. |
| `showDuration` | `Duration` | `Duration(milliseconds: 1500)` | How long a long-press tooltip stays after the finger lifts. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `maxWidth` | `double` | `300` | The widest the tooltip may be before its text wraps. |
| `enabled` | `bool` | `true` | Whether the tooltip responds at all. |
| `excludeFromSemantics` | `bool` | `false` | Whether to leave the message out of the trigger’s semantics. |


---

Something wrong with `AstryxTooltip`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTooltip&component=AstryxTooltip) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTooltip&area=AstryxTooltip) — both templates arrive with the component filled in.
