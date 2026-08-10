---
title: AstryxToast
description: A transient message in the corner, with an optional action.
component: true
group: Overlays
source: lib/src/components/overlay/toast.dart
upstream: Toast / useToast
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ToastDemoExample extends StatelessWidget {
  const ToastDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `AstryxThemeProvider` and `AstryxApp` install the host, so there is
    // nothing to wire: reach for the scope and show one.
    return AstryxButton(
      label: 'Archive project',
      onPressed: () => AstryxToastScope.of(
        context,
      ).show(const AstryxToast(message: 'Project archived')),
    );
  }
}
```


## Usage

```dart
AstryxToastScope.of(context).show(
  const AstryxToast(message: 'Project archived'),
);
```

`AstryxApp` and `AstryxThemeProvider` install the host and the controller, so there is nothing to wire: reach for the scope and show one. `show` returns a callback that dismisses that toast, for the rare case where the code that raised it also knows when it should go.

## Types

```dart
class ToastTypesExample extends StatelessWidget {
  const ToastTypesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxButton(
          label: 'Neutral',
          onPressed: () => AstryxToastScope.of(
            context,
          ).show(const AstryxToast(message: 'Settings saved')),
        ),
        AstryxButton(
          label: 'Error',
          variant: AstryxButtonVariant.destructive,
          onPressed: () => AstryxToastScope.of(context).show(
            const AstryxToast(
              message: 'Could not reach the server',
              type: AstryxToastType.error,
            ),
          ),
        ),
      ],
    );
  }
}
```


## Actions

An action makes a toast worth reading — "Row deleted" plus Undo is a safety net; "Row deleted" alone is a receipt.

```dart
class ToastActionExample extends StatefulWidget {
  const ToastActionExample({super.key});

  @override
  State<ToastActionExample> createState() => _ToastActionExampleState();
}

class _ToastActionExampleState extends State<ToastActionExample> {
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete row',
          onPressed: () {
            setState(() => _deleted = true);
            AstryxToastScope.of(context).show(
              AstryxToast(
                message: 'Row deleted',
                action: AstryxButton(
                  label: 'Undo',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () => setState(() => _deleted = false),
                ),
              ),
            );
          },
        ),
        AstryxText(
          _deleted ? 'Row is deleted' : 'Row is present',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


> **Note**
>
> Hover and focus both pause the timeout. A toast that vanishes while the user is reaching for its Undo button has actively made things worse.

## Duration

Five seconds by default. `Duration.zero` pins it until dismissed.

```dart
class ToastDurationExample extends StatelessWidget {
  const ToastDurationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxButton(
          label: 'Two seconds',
          onPressed: () => AstryxToastScope.of(context).show(
            const AstryxToast(
              message: 'Gone in two',
              duration: Duration(seconds: 2),
            ),
          ),
        ),
        // `Duration.zero` pins it until the user dismisses it. Hover or focus
        // also pauses the timeout — a toast must not vanish while someone is
        // reaching for its Undo.
        AstryxButton(
          label: 'Until dismissed',
          onPressed: () => AstryxToastScope.of(context).show(
            const AstryxToast(
              message: 'Pinned until dismissed',
              duration: Duration.zero,
            ),
          ),
        ),
        AstryxButton(
          label: 'Not dismissible',
          variant: AstryxButtonVariant.ghost,
          onPressed: () => AstryxToastScope.of(context).show(
            const AstryxToast(
              message: 'No dismiss button, five seconds',
              dismissible: false,
            ),
          ),
        ),
      ],
    );
  }
}
```


## Queueing

At most `maxVisible` are on screen — five by default. The rest queue and take their turn rather than burying the page.

```dart
class ToastQueueExample extends StatelessWidget {
  const ToastQueueExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        // Beyond `maxVisible` (five by default) the rest queue and take their
        // turn, rather than burying the screen.
        AstryxButton(
          label: 'Show eight',
          onPressed: () {
            final toasts = AstryxToastScope.of(context);
            for (var i = 1; i <= 8; i++) {
              toasts.show(AstryxToast(message: 'Notification $i'));
            }
          },
        ),
        AstryxButton(
          label: 'Clear',
          variant: AstryxButtonVariant.ghost,
          onPressed: () => AstryxToastScope.of(context).clear(),
        ),
      ],
    );
  }
}
```


## Placement

The default depends on density: a corner on pointer, the bottom on touch. A toast in the top corner of a phone is under the status bar and out of thumb reach; a toast across the bottom of a desktop window is in the way.

```dart
AstryxThemeProvider(
  toastPosition: AstryxToastPosition.topEnd,
  child: const HomePage(),
)
```

> **Accessibility**
>
> A toast is announced when it appears, and can be dismissed from the keyboard. It is still the weakest place to put information: it is gone in five seconds and it is nowhere near what the user was looking at. For anything that must be acted on, use a [banner](banner.md).

### AstryxToast

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `message` *(required)* | `String` | — | What to tell the user. |
| `type` | `AstryxToastType` | `AstryxToastType.neutral` | Which surface to use: `neutral` or `error`. |
| `action` | `Widget?` | — | An optional action — "Undo", "Retry". |
| `duration` | `Duration` | `Duration(seconds: 5)` | How long it stays. `Duration.zero` keeps it until dismissed. |
| `dismissible` | `bool` | `true` | Whether to show a dismiss button. |


### AstryxToastController

Reach it with `AstryxToastScope.of(context)`, or `maybeOf(context)` where a scope might be absent.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `maxVisible` | `int` | `5` | How many toasts are shown at once. |
| `visible` | `List<AstryxToast>` | — | What is on screen, oldest first. |
| `show(toast)` | `VoidCallback` | — | Queues a toast and returns a handle that dismisses it. |
| `clear()` | `void` | — | Removes everything. |


