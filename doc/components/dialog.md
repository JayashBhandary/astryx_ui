---
title: AstryxDialog
description: A modal panel anchored to the viewport, with a scrolling body.
component: true
group: Overlays
source: lib/src/components/overlay/dialog.dart
upstream: Dialog
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DialogDemoExample extends StatefulWidget {
  const DialogDemoExample({super.key});

  @override
  State<DialogDemoExample> createState() => _DialogDemoExampleState();
}

class _DialogDemoExampleState extends State<DialogDemoExample> {
  final AstryxDialogController _controller = AstryxDialogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The dialog is a widget in the tree, not a `showDialog` call. It renders
    // nothing until its controller opens it — so it can sit next to whatever
    // opens it, and the state that drives it stays yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete project',
          variant: AstryxButtonVariant.destructive,
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Delete project',
          description: 'This cannot be undone.',
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Cancel', onPressed: _controller.hide),
              AstryxButton(
                label: 'Delete',
                variant: AstryxButtonVariant.destructive,
                onPressed: _controller.hide,
              ),
            ],
          ),
          child: const AstryxText(
            'Everything in this project will be permanently removed, '
            'including its request history.',
          ),
        ),
      ],
    );
  }
}
```


## Usage

```dart
final AstryxDialogController _dialog = AstryxDialogController();

// …then, somewhere in the tree:
AstryxDialog(
  controller: _dialog,
  title: 'Delete project',
  description: 'This cannot be undone.',
  footer: AstryxButton(label: 'Cancel', onPressed: _dialog.hide),
  child: const AstryxText('Everything will be permanently removed.'),
)
```

A dialog is a **widget in the tree**, not a `showDialog` call. It renders nothing until its controller opens it. That means it can sit next to whatever opens it, the open state lives where your other state lives, and there is no `BuildContext` to smuggle into an async gap.

## Composition

```text
AstryxDialog
├── title           ← the heading, and the dialog’s accessible name
├── description     ← supporting text
├── child           ← the body. Scrolls
└── footer          ← the action row. Pinned below the body
```

## A form in a dialog

`autofocus` on the first field is worth setting: a modal that opens with focus nowhere in particular costs a keyboard user a Tab or three.

```dart
class DialogFormExample extends StatefulWidget {
  const DialogFormExample({super.key});

  @override
  State<DialogFormExample> createState() => _DialogFormExampleState();
}

class _DialogFormExampleState extends State<DialogFormExample> {
  final AstryxDialogController _controller = AstryxDialogController();
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'New project',
          variant: AstryxButtonVariant.primary,
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'New project',
          width: 420,
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Cancel', onPressed: _controller.hide),
              AstryxButton(
                label: 'Create',
                variant: AstryxButtonVariant.primary,
                onPressed: _controller.hide,
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxTextInput(
                label: 'Name',
                controller: _name,
                required: true,
                autofocus: true,
                placeholder: 'Atlas',
              ),
              const AstryxSelector<String>(
                label: 'Region',
                value: 'eu',
                options: <AstryxSelectorEntry<String>>[
                  AstryxSelectorOption(value: 'eu', label: 'Europe'),
                  AstryxSelectorOption(value: 'us', label: 'United States'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```


## Long content

The body scrolls; the header and footer do not. A long dialog never pushes its actions off the screen.

```dart
class DialogScrollingExample extends StatefulWidget {
  const DialogScrollingExample({super.key});

  @override
  State<DialogScrollingExample> createState() =>
      _DialogScrollingExampleState();
}

class _DialogScrollingExampleState extends State<DialogScrollingExample> {
  final AstryxDialogController _controller = AstryxDialogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The body scrolls; the header and footer do not. A long dialog never
    // pushes its actions off the screen.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Terms of service', onPressed: _controller.show),
        AstryxDialog(
          controller: _controller,
          title: 'Terms of service',
          description: 'Last updated 4 March.',
          footer: AstryxButton(
            label: 'Accept',
            variant: AstryxButtonVariant.primary,
            onPressed: _controller.hide,
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (var clause = 1; clause <= 30; clause++)
                AstryxText('Clause $clause. Everything in moderation.'),
            ],
          ),
        ),
      ],
    );
  }
}
```


## When the choice must be made

Turning off the barrier, Escape and the close button leaves no way out but a decision. Be certain that is true before doing it — most dialogs that feel unskippable are not.

```dart
class DialogBlockingExample extends StatefulWidget {
  const DialogBlockingExample({super.key});

  @override
  State<DialogBlockingExample> createState() => _DialogBlockingExampleState();
}

class _DialogBlockingExampleState extends State<DialogBlockingExample> {
  final AstryxDialogController _controller = AstryxDialogController();
  String _outcome = '—';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _answer(String outcome) {
    setState(() => _outcome = outcome);
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    // No barrier dismissal, no Escape, no close button — the choice has to be
    // made. Be certain it does before reaching for this.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Migrate data', onPressed: _controller.show),
        AstryxText(
          'Outcome: $_outcome',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Keep or discard the old rows?',
          showCloseButton: false,
          barrierDismissible: false,
          escapeDismissible: false,
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(
                label: 'Discard',
                variant: AstryxButtonVariant.destructive,
                onPressed: () => _answer('Discarded'),
              ),
              AstryxButton(
                label: 'Keep',
                variant: AstryxButtonVariant.primary,
                onPressed: () => _answer('Kept'),
              ),
            ],
          ),
          child: const AstryxText(
            'The migration cannot run twice, so this decision is final.',
          ),
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> Focus is trapped inside while the dialog is open and returns to the trigger when it closes. `title` is the accessible name, so a dialog without one is announced as an unnamed container.

### AstryxDialog

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxDialogController` | — | The open/closed state. |
| `child` *(required)* | `Widget` | — | The body. |
| `title` | `String?` | — | The heading, which also names the dialog for a screen reader. |
| `description` | `String?` | — | Supporting text below the title. |
| `footer` | `Widget?` | — | The action row, pinned below the scrolling body. |
| `width` | `double` | `480` | The dialog’s width. Never exceeds the viewport minus its padding. |
| `showCloseButton` | `bool` | `true` | Whether to show a close button in the header. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the barrier closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `onDismiss` | `VoidCallback?` | — | Called when the dialog dismisses itself. |


### AstryxDialogController

A `ChangeNotifier`. Dispose it with your state.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `isOpen` | `bool` | — | Whether the dialog is showing. |
| `show()` | `void` | — | Shows it. |
| `hide()` | `void` | — | Hides it. |


