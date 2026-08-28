import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example stepper_demo -> StepperDemoExample
class StepperDemoExample extends StatefulWidget {
  const StepperDemoExample({super.key});

  @override
  State<StepperDemoExample> createState() => _StepperDemoExampleState();
}

class _StepperDemoExampleState extends State<StepperDemoExample> {
  int _step = 1;

  static const List<AstryxStep> _steps = <AstryxStep>[
    AstryxStep(label: 'Account'),
    AstryxStep(label: 'Profile', description: 'Name and photo'),
    AstryxStep(label: 'Review'),
  ];

  @override
  Widget build(BuildContext context) {
    // A stepper is controlled: it draws the index it is given and reports
    // nothing on its own, which is what lets a flow validate before advancing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxStepper(activeStep: _step, steps: _steps),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(
              label: 'Back',
              variant: AstryxButtonVariant.secondary,
              onPressed: _step == 0
                  ? null
                  : () => setState(() => _step -= 1),
            ),
            AstryxButton(
              label: _step >= _steps.length - 1 ? 'Finish' : 'Next',
              onPressed: _step > _steps.length - 1
                  ? null
                  : () => setState(() => _step += 1),
            ),
          ],
        ),
      ],
    );
  }
}
// #end

// #example stepper_orientations -> StepperOrientationsExample
class StepperOrientationsExample extends StatelessWidget {
  const StepperOrientationsExample({super.key});

  static const List<AstryxStep> _steps = <AstryxStep>[
    AstryxStep(label: 'Connect'),
    AstryxStep(label: 'Map fields'),
    AstryxStep(label: 'Import'),
  ];

  @override
  Widget build(BuildContext context) {
    // Horizontal divides the width evenly between the steps; vertical stacks
    // them, which is the orientation to reach for once labels get long or the
    // steps carry content of their own.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxStepper(activeStep: 1, steps: _steps),
        AstryxStepper(
          activeStep: 1,
          steps: _steps,
          orientation: AstryxStepperOrientation.vertical,
        ),
      ],
    );
  }
}
// #end

// #example stepper_on_track -> StepperOnTrackExample
class StepperOnTrackExample extends StatelessWidget {
  const StepperOnTrackExample({super.key});

  static const List<AstryxStep> _steps = <AstryxStep>[
    AstryxStep(label: 'Cart'),
    AstryxStep(label: 'Delivery'),
    AstryxStep(label: 'Payment'),
    AstryxStep(label: 'Done'),
  ];

  @override
  Widget build(BuildContext context) {
    // `onTrack` slots each indicator into the line as a node, with the label
    // below it. The steps abut so the segments form one continuous track.
    return const AstryxStepper(
      activeStep: 2,
      steps: _steps,
      indicatorPosition: AstryxStepperIndicatorPosition.onTrack,
    );
  }
}
// #end

// #example stepper_status -> StepperStatusExample
class StepperStatusExample extends StatelessWidget {
  const StepperStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Status colours the indicator and, in `auto`, gives it a glyph. It never
    // recolours the connector, which reports progress and nothing else — and
    // the word is in the step's accessible name, because colour is never the
    // only signal.
    return const AstryxStepper(
      activeStep: 3,
      orientation: AstryxStepperOrientation.vertical,
      steps: <AstryxStep>[
        AstryxStep(
          label: 'Upload',
          description: '412 rows read',
          status: AstryxStepStatus.success,
        ),
        AstryxStep(
          label: 'Validate',
          description: '3 rows have no email address',
          status: AstryxStepStatus.warning,
        ),
        AstryxStep(
          label: 'Import',
          description: 'The connection timed out',
          status: AstryxStepStatus.error,
        ),
        AstryxStep(label: 'Notify', optional: true),
      ],
    );
  }
}
// #end

// #example stepper_navigable -> StepperNavigableExample
class StepperNavigableExample extends StatefulWidget {
  const StepperNavigableExample({super.key});

  @override
  State<StepperNavigableExample> createState() =>
      _StepperNavigableExampleState();
}

class _StepperNavigableExampleState extends State<StepperNavigableExample> {
  int _step = 2;

  @override
  Widget build(BuildContext context) {
    // `onStepPressed` makes every enabled step pressable, ahead as well as
    // behind — the free navigation a flow the user may revisit wants. A
    // disabled step stays visible and counted, and simply cannot be reached.
    return AstryxStepper(
      activeStep: _step,
      onStepPressed: (index) => setState(() => _step = index),
      steps: const <AstryxStep>[
        AstryxStep(label: 'Plan'),
        AstryxStep(label: 'Build'),
        AstryxStep(label: 'Test'),
        AstryxStep(label: 'Release', enabled: false),
      ],
    );
  }
}
// #end

// #example stepper_content -> StepperContentExample
class StepperContentExample extends StatefulWidget {
  const StepperContentExample({super.key});

  @override
  State<StepperContentExample> createState() => _StepperContentExampleState();
}

class _StepperContentExampleState extends State<StepperContentExample> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    // A vertical step can carry the fields it is asking for, so the form and
    // the progress through it are one thing rather than two.
    return AstryxStepper(
      activeStep: _step,
      orientation: AstryxStepperOrientation.vertical,
      density: AstryxStepDensity.spacious,
      steps: <AstryxStep>[
        AstryxStep(
          label: 'Workspace name',
          content: _step == 0
              ? AstryxVStack(
                  gap: AstryxSpacingToken.spacing3,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    const AstryxTextInput(
                      label: 'Name',
                      placeholder: 'Acme engineering',
                    ),
                    AstryxHStack(
                      children: <Widget>[
                        AstryxButton(
                          label: 'Continue',
                          onPressed: () => setState(() => _step = 1),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
        ),
        AstryxStep(
          label: 'Invite the team',
          description: 'You can do this later',
          optional: true,
          content: _step == 1
              ? AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxButton(
                      label: 'Back',
                      variant: AstryxButtonVariant.secondary,
                      onPressed: () => setState(() => _step = 0),
                    ),
                    AstryxButton(
                      label: 'Skip',
                      variant: AstryxButtonVariant.ghost,
                      onPressed: () => setState(() => _step = 2),
                    ),
                  ],
                )
              : null,
        ),
        const AstryxStep(label: 'Done'),
      ],
    );
  }
}
// #end
