---
title: AstryxPopover
description: A floating panel anchored to a trigger, with trapped focus.
component: true
group: Overlays
source: lib/src/components/overlay/popover.dart
upstream: Popover / usePopover
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class PopoverDemoExample extends StatelessWidget {
  const PopoverDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxPopover(
      label: 'Filters',
      width: 260,
      content: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Filters', level: 5),
          const AstryxTextInput(label: 'Owner', placeholder: 'Anyone'),
          AstryxButton(
            label: 'Apply',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      // A builder, not a child: a button consumes its own taps, so the popover
      // hands you the controller and lets you wire it where it belongs.
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'Filters', onPressed: controller.toggle),
    );
  }
}
```


## Usage

```dart
AstryxPopover(
  label: 'Filters',
  width: 260,
  content: filterForm,
  triggerBuilder: (context, controller) =>
      AstryxButton(label: 'Filters', onPressed: controller.toggle),
)
```

`triggerBuilder`, not `child`. A button consumes its own taps, so a popover cannot open itself by wrapping one — instead it hands you the controller and lets you wire it to the trigger’s own callback. That is also what makes any widget a valid trigger.

## Positioning

One positioner serves the popover, the tooltip, the menu and the selector: it flips, shifts and shrinks to keep the panel on screen.

| Property | Does |
| --- | --- |
| `side` | The **preferred** side. The positioner flips to the opposite one when there is no room. |
| `align` | Alignment along the anchor’s edge: `start`, `center` or `end`. The overlay shifts along that edge to stay on screen. |

```dart
class PopoverSidesExample extends StatelessWidget {
  const PopoverSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `side` is a preference, not a promise: with no room the positioner flips
    // to the opposite side and shifts along the edge to stay on screen.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final side in AstryxOverlaySide.values)
          AstryxPopover(
            side: side,
            width: 180,
            showArrow: true,
            label: side.name,
            content: AstryxText('Anchored ${side.name}.'),
            triggerBuilder: (context, controller) =>
                AstryxButton(label: side.name, onPressed: controller.toggle),
          ),
      ],
    );
  }
}
```


**Alignment along the trigger’s edge**

```dart
class PopoverAlignExample extends StatelessWidget {
  const PopoverAlignExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final align in AstryxOverlayAlign.values)
          AstryxPopover(
            align: align,
            width: 220,
            label: align.name,
            content: AstryxText('align: ${align.name}'),
            triggerBuilder: (context, controller) => AstryxButton(
              label: align.name,
              onPressed: controller.toggle,
            ),
          ),
      ],
    );
  }
}
```


## Controlled and uncontrolled

With no `controller` the popover owns one and toggles on a press. Pass one and the open state is yours: anything can open it, and you can watch it.

```dart
class PopoverControlledExample extends StatefulWidget {
  const PopoverControlledExample({super.key});

  @override
  State<PopoverControlledExample> createState() =>
      _PopoverControlledExampleState();
}

class _PopoverControlledExampleState extends State<PopoverControlledExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _open = _controller.isOpen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Passing a controller makes the popover *controlled*: the open state lives
    // wherever the application already keeps state, and anything can drive it.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxPopover(
          controller: _controller,
          label: 'Details',
          width: 220,
          content: const AstryxText('Focus is trapped in here.'),
          triggerBuilder: (context, controller) =>
              AstryxButton(label: 'Details', onPressed: controller.toggle),
        ),
        AstryxButton(
          label: _open ? 'Close from outside' : 'Open from outside',
          variant: AstryxButtonVariant.ghost,
          onPressed: _controller.toggle,
        ),
      ],
    );
  }
}
```


## Matching the trigger

`matchTriggerWidth` makes the panel at least as wide as what opened it — which is what makes it read as belonging to that control. Upstream gets the same effect from `min-width: anchor-size(width)`.

```dart
class PopoverMatchWidthExample extends StatelessWidget {
  const PopoverMatchWidthExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `matchTriggerWidth` is what makes a panel look like it belongs to the
    // control above it — upstream gets the same effect from `anchor-size()`.
    return SizedBox(
      width: 320,
      child: AstryxPopover(
        matchTriggerWidth: true,
        label: 'Recent searches',
        content: const AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxText('invoice overdue'),
            AstryxText('owner:ada'),
            AstryxText('status:blocked'),
          ],
        ),
        triggerBuilder: (context, controller) => AstryxButton(
          label: 'Recent searches',
          width: double.infinity,
          onPressed: controller.toggle,
        ),
      ),
    );
  }
}
```


## Dismissal

A press outside closes it, and so does `Escape` — but Escape closes **one layer at a time**. Open a popover inside a dialog, press Escape, and the popover closes while the dialog stays.

> **Accessibility**
>
> Focus is trapped in the panel while it is open and returns to the trigger when it closes. Give the panel a `label`: it is a container a screen reader will announce on entry, and "group" is not a useful name.

### AstryxPopover

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `triggerBuilder` *(required)* | `Widget Function(BuildContext, AstryxOverlayController)` | — | Builds the trigger, given the controller that opens the panel. |
| `content` *(required)* | `Widget` | — | The floating content. |
| `controller` | `AstryxOverlayController?` | — | Drives the popover from outside. Null makes it uncontrolled. |
| `label` | `String?` | — | An accessible name for the panel. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.center` | Alignment along the trigger’s edge. |
| `width` | `double?` | — | A fixed width. Null sizes to the content. |
| `matchTriggerWidth` | `bool` | `false` | Whether the panel is at least as wide as its trigger. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `trapFocus` | `bool` | `true` | Whether focus is trapped inside while open. |
| `barrierDismissible` | `bool` | `true` | Whether a press outside closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the panel opens or closes. |


### AstryxOverlayController

A `ChangeNotifier`. The same controller drives the popover, the dropdown menu and the tooltip. Dispose one you own.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `isOpen` | `bool` | — | Whether the overlay is showing. |
| `show()` | `void` | — | Shows it. |
| `hide()` | `void` | — | Hides it. |
| `toggle()` | `void` | — | Shows it if hidden, hides it if shown. |


## Related

- [AstryxTooltip](tooltip.md) — for a phrase, not a panel.
- [AstryxDropdownMenu](dropdown_menu.md) — for a list of actions.
- [AstryxDialog](dialog.md) — for something that must be dealt with.

