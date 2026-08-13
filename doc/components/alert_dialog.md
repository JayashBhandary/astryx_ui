---
title: AstryxAlertDialog
description: A modal that interrupts to confirm one consequential action.
component: true
group: Overlays
source: lib/src/components/overlay/alert_dialog.dart
upstream: AlertDialog / useImperativeAlertDialog
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class AlertDialogDemoExample extends StatefulWidget {
  const AlertDialogDemoExample({super.key});

  @override
  State<AlertDialogDemoExample> createState() => _AlertDialogDemoExampleState();
}

class _AlertDialogDemoExampleState extends State<AlertDialogDemoExample> {
  final AstryxDialogController _controller = AstryxDialogController();
  String _outcome = '—';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The barrier does not dismiss, there is no close button, and focus starts
    // on Cancel. All three exist so the question cannot be answered by
    // accident.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete project',
          variant: AstryxButtonVariant.destructive,
          onPressed: _controller.show,
        ),
        AstryxText(
          'Last answer: $_outcome',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        AstryxAlertDialog(
          controller: _controller,
          title: 'Delete Atlas?',
          description:
              'Atlas and its 4,102 saved requests will be removed for everyone '
              'in the workspace. This cannot be undone.',
          confirmLabel: 'Delete project',
          destructive: true,
          onConfirm: () => setState(() => _outcome = 'deleted'),
          onCancel: () => setState(() => _outcome = 'kept'),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxAlertDialog(
  controller: _confirm,
  title: 'Delete Atlas?',
  description: 'Atlas and its 4,102 requests will be removed. This cannot '
      'be undone.',
  confirmLabel: 'Delete project',
  destructive: true,
  onConfirm: _delete,
)
```

It takes the same `AstryxDialogController` a [dialog](dialog.md) does, because an alert dialog **is** a dialog with the answers built in. What differs is not how it looks: it is that it is deliberately harder to leave by accident.

|   | Dialog | Alert dialog |
| --- | --- | --- |
| Barrier press | closes it | **does nothing** |
| Close button | yes | no — the buttons are the way out |
| Escape | closes it | cancels |
| Focus on open | the first control | **cancel** |
| Body | anything | a consequence, then anything |

Focus starting on cancel is the decision the rest follows from: a user who presses Enter out of habit must not delete anything. `description` is required for the same reason — a confirmation whose consequence is left to the title is one nobody can give informed consent to.

## An acknowledgement

`showCancel: false` for something there is no declining. One button, which then holds focus because it is the only way out.

```dart
class AlertDialogAcknowledgeExample extends StatefulWidget {
  const AlertDialogAcknowledgeExample({super.key});

  @override
  State<AlertDialogAcknowledgeExample> createState() =>
      _AlertDialogAcknowledgeExampleState();
}

class _AlertDialogAcknowledgeExampleState
    extends State<AlertDialogAcknowledgeExample> {
  final AstryxDialogController _controller = AstryxDialogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `showCancel: false` for something there is no declining — one button,
    // which holds focus because it is the only way out.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Show session notice', onPressed: _controller.show),
        AstryxAlertDialog(
          controller: _controller,
          title: 'Your session expired',
          description:
              'You were signed out after 30 minutes of inactivity. Anything '
              'unsaved has been kept as a draft.',
          confirmLabel: 'Sign in again',
          showCancel: false,
        ),
      ],
    );
  }
}
```


## Carrying a decision

`child` is for what a sentence cannot hold — a list of what will go, or one choice that travels with the answer.

```dart
class AlertDialogExtraExample extends StatefulWidget {
  const AlertDialogExtraExample({super.key});

  @override
  State<AlertDialogExtraExample> createState() =>
      _AlertDialogExtraExampleState();
}

class _AlertDialogExtraExampleState extends State<AlertDialogExtraExample> {
  final AstryxDialogController _controller = AstryxDialogController();
  bool _alsoRevoke = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `child` is for what the description cannot say in a sentence — a list of
    // what goes, or one decision that travels with the answer.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Remove member', onPressed: _controller.show),
        AstryxAlertDialog(
          controller: _controller,
          title: 'Remove Priya from Atlas?',
          description:
              'They lose access immediately. Their comments and history stay.',
          confirmLabel: 'Remove member',
          destructive: true,
          child: AstryxCheckbox(
            label: 'Also revoke their API tokens',
            value: _alsoRevoke,
            onChanged: (value) => setState(() => _alsoRevoke = value),
          ),
        ),
      ],
    );
  }
}
```


> **Note**
>
> Use a [dialog](dialog.md) whenever the user is *doing* something rather than confirming something. An alert dialog spent on ordinary work trains people to dismiss the one that matters.

> **Accessibility**
>
> Focus is trapped while it is open and returns to whatever opened it. `title` is the accessible name, and the confirming button should name the action — "Delete project", not "OK", because that button is read on its own by anyone tabbing to it.

### AstryxAlertDialog

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxDialogController` | — | The open/closed state. |
| `title` *(required)* | `String` | — | The question, as a statement. Also the accessible name. |
| `description` *(required)* | `String` | — | What confirming will do. |
| `confirmLabel` *(required)* | `String` | — | The label on the confirming button. Name the action. |
| `onConfirm` | `VoidCallback?` | — | Called after the dialog closes on confirm. |
| `cancelLabel` | `String?` | — | The label on the cancelling button. Defaults to the localised "Cancel". |
| `onCancel` | `VoidCallback?` | — | Called on cancel — by the button, by Escape, or by the barrier where it is dismissible. |
| `destructive` | `bool` | `false` | Whether confirming is irreversible, which colours that button with `--color-error`. |
| `width` | `double` | `420` | The dialog’s width. |
| `showCancel` | `bool` | `true` | Whether to offer a cancelling button at all. |
| `barrierDismissible` | `bool` | `false` | Whether a press on the barrier cancels. |
| `escapeDismissible` | `bool` | `true` | Whether Escape cancels. |
| `child` | `Widget?` | — | Extra content below the description. |


## Related

- [AstryxDialog](dialog.md) — for anything with more than one outcome.
- [AstryxOverlay](overlay.md) — the layer both are built on.

---

Something wrong with `AstryxAlertDialog`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxAlertDialog&component=AstryxAlertDialog) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxAlertDialog&area=AstryxAlertDialog) — both templates arrive with the component filled in.
