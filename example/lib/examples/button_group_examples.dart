import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example button_group_demo -> ButtonGroupDemoExample
class ButtonGroupDemoExample extends StatelessWidget {
  const ButtonGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      children: <Widget>[
        AstryxButton(label: 'Day', onPressed: () {}),
        AstryxButton(label: 'Week', onPressed: () {}),
        AstryxButton(label: 'Month', onPressed: () {}),
      ],
    );
  }
}
// #end

// #example button_group_segmented -> ButtonGroupSegmentedExample
class ButtonGroupSegmentedExample extends StatefulWidget {
  const ButtonGroupSegmentedExample({super.key});

  @override
  State<ButtonGroupSegmentedExample> createState() =>
      _ButtonGroupSegmentedExampleState();
}

class _ButtonGroupSegmentedExampleState
    extends State<ButtonGroupSegmentedExample> {
  String _range = 'Week';

  @override
  Widget build(BuildContext context) {
    // The group carries no selection of its own. A segmented control is a
    // group whose selected child takes a louder variant — which keeps the
    // selection where the application already holds it.
    return AstryxButtonGroup(
      children: <Widget>[
        for (final range in const <String>['Day', 'Week', 'Month'])
          AstryxButton(
            label: range,
            variant: range == _range
                ? AstryxButtonVariant.primary
                : AstryxButtonVariant.secondary,
            onPressed: () => setState(() => _range = range),
          ),
      ],
    );
  }
}
// #end

// #example button_group_detached -> ButtonGroupDetachedExample
class ButtonGroupDetachedExample extends StatelessWidget {
  const ButtonGroupDetachedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      attached: false,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxButton(
          label: 'Publish',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Save draft', onPressed: () {}),
        AstryxButton(
          label: 'Discard',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end

// #example button_group_inherited -> ButtonGroupInheritedExample
class ButtonGroupInheritedExample extends StatelessWidget {
  const ButtonGroupInheritedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `variant` and `size` cascade: no child repeats them.
    return AstryxButtonGroup(
      variant: AstryxButtonVariant.ghost,
      size: AstryxButtonSize.sm,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.arrowUp,
          label: 'Move up',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowDown,
          label: 'Move down',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Duplicate',
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end

// #example button_group_vertical -> ButtonGroupVerticalExample
class ButtonGroupVerticalExample extends StatelessWidget {
  const ButtonGroupVerticalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      axis: Axis.vertical,
      children: <Widget>[
        AstryxButton(label: 'Zoom in', onPressed: () {}),
        AstryxButton(label: 'Zoom out', onPressed: () {}),
        AstryxButton(label: 'Reset', onPressed: () {}),
      ],
    );
  }
}
// #end
