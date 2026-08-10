import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example dialog_demo -> DialogDemoExample
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
// #end

// #example dialog_form -> DialogFormExample
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
// #end

// #example dialog_scrolling -> DialogScrollingExample
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
// #end

// #example dialog_blocking -> DialogBlockingExample
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
// #end
