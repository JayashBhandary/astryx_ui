import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example toast_demo -> ToastDemoExample
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
// #end

// #example toast_types -> ToastTypesExample
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
// #end

// #example toast_action -> ToastActionExample
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
// #end

// #example toast_duration -> ToastDurationExample
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
// #end

// #example toast_queue -> ToastQueueExample
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
// #end
