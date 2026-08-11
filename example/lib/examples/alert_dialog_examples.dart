import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example alert_dialog_demo -> AlertDialogDemoExample
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
// #end

// #example alert_dialog_acknowledge -> AlertDialogAcknowledgeExample
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
// #end

// #example alert_dialog_extra -> AlertDialogExtraExample
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
// #end
