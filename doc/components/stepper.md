---
title: AstryxStepper
description: Progress through a sequence of steps, and the steps themselves.
component: true
group: Navigation
source: lib/src/components/navigation/stepper.dart
upstream: Stepper / Step
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```


## Usage

```dart
AstryxStepper(
  activeStep: _step,
  steps: const <AstryxStep>[
    AstryxStep(label: 'Account'),
    AstryxStep(label: 'Profile', description: 'Name and photo'),
    AstryxStep(label: 'Review'),
  ],
)
```

A stepper says *where in a flow the user is*. It is not navigation: the steps are the stages of one task, not the destinations of an application, so it announces itself as a labelled group of steps rather than as a landmark. `activeStep` is a zero-based index, and a value past the last step marks the whole flow complete — which is what a confirmation screen wants.

It is **controlled**: it draws the index it is given and changes nothing on its own, which is what makes a flow that validates before advancing possible. Upstream asks each `Step` to declare its own index; here a step’s index is its position in `steps`, so two steps cannot claim the same one.

## Orientation

Horizontal divides the width evenly between the steps, so a long label wraps inside its own slice rather than spilling into its neighbour. Vertical stacks them, and is the orientation to reach for once the steps carry content of their own.

```dart
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
```


## Indicator position

`separated` — the default — puts the indicator in the label row with the connector as a bar of its own. `onTrack` slots it into the line as a node, with the label below it (horizontal) or beside it (vertical); the steps then abut so their segments form one continuous track.

```dart
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
```


## Status

`status` colours the indicator, and in the default `auto` mode gives it a glyph. It is **not** a lifecycle: whether a step is done comes from `activeStep`, and the step the flow is on keeps its current-step indicator whatever its status says. It never recolours the connector, which reports progress and nothing else.

```dart
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
```


> **Accessibility**
>
> The glyphs are decorative, so every one of them also reaches assistive technology as words: a step announces its position ("Step 2 of 3"), its label, its description, whether it is optional, whether the flow has passed it, and its status. Colour is never the only signal.

## Navigable steps

`onStepPressed` makes every enabled step pressable — the ones ahead as well as the ones behind, which is the free navigation a flow the user may revisit wants. A step with `enabled: false` stays visible and counted; it simply cannot be reached.

```dart
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
```


## Content in a step

A vertical step can carry the fields it is asking for, so the form and the progress through it are one thing rather than two. Give `content` to the step the flow is on and null to the rest.

```dart
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
```


> **Note**
>
> The connector paints at its final length on the first frame: a stepper that opens on step three shows three filled segments rather than playing its own history back at the reader. Only a change animates.

### AstryxStepper

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `activeStep` *(required)* | `int` | — | The zero-based index of the step the flow is on. Past the last step marks the flow complete. |
| `steps` *(required)* | `List<AstryxStep>` | — | The steps, in order. Each one’s index is its position here. |
| `orientation` | `AstryxStepperOrientation` | `AstryxStepperOrientation.horizontal` | Which way the stepper runs: `horizontal` or `vertical`. |
| `indicatorPosition` | `AstryxStepperIndicatorPosition` | `AstryxStepperIndicatorPosition.separated` | Whether the indicator sits in the label row (`separated`) or in the connector (`onTrack`). |
| `onStepPressed` | `ValueChanged<int>?` | — | Called with the index of a step the user pressed. Null makes the stepper a read-out. |
| `label` | `String?` | — | The stepper’s accessible name. Null uses the localised "Progress". |
| `density` | `AstryxStepDensity` | `AstryxStepDensity.balanced` | The vertical rhythm the steps take: `compact`, `balanced` or `spacious`. |


### AstryxStep

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The step’s name, and its accessible name. |
| `description` | `String?` | — | A supporting line below the label. |
| `status` | `AstryxStepStatus?` | — | A semantic colour — `accent`, `success`, `warning` or `error` — and, in `auto`, a matching glyph. |
| `enabled` | `bool` | `true` | Whether the step can be chosen. A disabled step is still shown and still counted. |
| `optional` | `bool` | `false` | Whether the step may be skipped, which appends an "Optional" note. |
| `trailing` | `Widget?` | — | Content at the end of the label row — a timestamp, a badge. |
| `indicator` | `AstryxStepIndicator` | `AstryxStepIndicator.auto` | Which preset to draw: `auto` (a number until the step is passed, then a check), `number`, or `none`. |
| `icon` | `Widget?` | — | An indicator of your own, drawn instead of the preset and sized into the same 16px box. |
| `content` | `Widget?` | — | Content below the label — the fields of this step of a form. |
| `density` | `AstryxStepDensity?` | — | Overrides the stepper’s density for this step. |


---

Something wrong with `AstryxStepper`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxStepper&component=AstryxStepper) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxStepper&area=AstryxStepper) — both templates arrive with the component filled in.
