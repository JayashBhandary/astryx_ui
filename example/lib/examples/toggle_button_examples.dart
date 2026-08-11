import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example toggle_button_demo -> ToggleButtonDemoExample
class ToggleButtonDemoExample extends StatefulWidget {
  const ToggleButtonDemoExample({super.key});

  @override
  State<ToggleButtonDemoExample> createState() =>
      _ToggleButtonDemoExampleState();
}

class _ToggleButtonDemoExampleState extends State<ToggleButtonDemoExample> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // The button owns no state. It reports the state it should move to, and the
    // caller decides — the same contract as every other control here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButton(
          label: 'Only my issues',
          icon: const AstryxIcon(AstryxIconName.funnel),
          pressed: _pressed,
          onChanged: (value) => setState(() => _pressed = value),
        ),
        AstryxText(
          _pressed ? 'Showing 12 of 240 issues.' : 'Showing all 240 issues.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example toggle_button_icon_only -> ToggleButtonIconOnlyExample
class ToggleButtonIconOnlyExample extends StatefulWidget {
  const ToggleButtonIconOnlyExample({super.key});

  @override
  State<ToggleButtonIconOnlyExample> createState() =>
      _ToggleButtonIconOnlyExampleState();
}

class _ToggleButtonIconOnlyExampleState
    extends State<ToggleButtonIconOnlyExample> {
  bool _watching = false;

  @override
  Widget build(BuildContext context) {
    // `labelHidden` keeps the label as the accessible name and stops painting
    // it: the button squares off and takes the label as its tooltip, so the
    // glyph is never the only thing a reader has.
    return AstryxToggleButton(
      label: 'Watch this repository',
      labelHidden: true,
      icon: const AstryxIcon(AstryxIconName.eyeSlash),
      pressedIcon: const AstryxIcon(AstryxIconName.check),
      pressed: _watching,
      onChanged: (value) => setState(() => _watching = value),
    );
  }
}
// #end

// #example toggle_button_group_single -> ToggleButtonGroupSingleExample
class ToggleButtonGroupSingleExample extends StatefulWidget {
  const ToggleButtonGroupSingleExample({super.key});

  @override
  State<ToggleButtonGroupSingleExample> createState() =>
      _ToggleButtonGroupSingleExampleState();
}

class _ToggleButtonGroupSingleExampleState
    extends State<ToggleButtonGroupSingleExample> {
  String? _view = 'grid';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: _view,
          onChanged: (value) => setState(() => _view = value),
          children: const <Widget>[
            AstryxToggleButton(value: 'list', label: 'List'),
            AstryxToggleButton(value: 'grid', label: 'Grid'),
            AstryxToggleButton(value: 'board', label: 'Board'),
          ],
        ),
        // Pressing the one that is already on clears the group, so "none" is
        // always reachable — upstream's behaviour, and the reason the value is
        // nullable.
        AstryxText(
          _view == null ? 'No view chosen.' : 'Showing the $_view view.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example toggle_button_group_multiple -> ToggleButtonGroupMultipleExample
class ToggleButtonGroupMultipleExample extends StatefulWidget {
  const ToggleButtonGroupMultipleExample({super.key});

  @override
  State<ToggleButtonGroupMultipleExample> createState() =>
      _ToggleButtonGroupMultipleExampleState();
}

class _ToggleButtonGroupMultipleExampleState
    extends State<ToggleButtonGroupMultipleExample> {
  Set<String> _statuses = <String>{'failing'};

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButtonGroup.multiple(
          label: 'Filter by status',
          values: _statuses,
          // A new set arrives each time; the group never edits the one it was
          // given.
          onChanged: (values) => setState(() => _statuses = values),
          children: const <Widget>[
            AstryxToggleButton(value: 'passing', label: 'Passing'),
            AstryxToggleButton(value: 'failing', label: 'Failing'),
            AstryxToggleButton(value: 'queued', label: 'Queued'),
          ],
        ),
        AstryxText(
          _statuses.isEmpty
              ? 'No filter: every run.'
              : 'Filtering: ${_statuses.join(', ')}.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example toggle_button_group_vertical -> ToggleButtonGroupVerticalExample
class ToggleButtonGroupVerticalExample extends StatefulWidget {
  const ToggleButtonGroupVerticalExample({super.key});

  @override
  State<ToggleButtonGroupVerticalExample> createState() =>
      _ToggleButtonGroupVerticalExampleState();
}

class _ToggleButtonGroupVerticalExampleState
    extends State<ToggleButtonGroupVerticalExample> {
  String? _environment = 'staging';

  @override
  Widget build(BuildContext context) {
    // A vertical group stretches its buttons to one width, so the labels line
    // up however long they are.
    return AstryxToggleButtonGroup.single(
      label: 'Environment',
      value: _environment,
      axis: Axis.vertical,
      size: AstryxButtonSize.sm,
      onChanged: (value) => setState(() => _environment = value),
      children: const <Widget>[
        AstryxToggleButton(value: 'production', label: 'Production'),
        AstryxToggleButton(value: 'staging', label: 'Staging'),
        AstryxToggleButton(value: 'dev', label: 'Development'),
      ],
    );
  }
}
// #end

// #example toggle_button_states -> ToggleButtonStatesExample
class ToggleButtonStatesExample extends StatelessWidget {
  const ToggleButtonStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Disabled and loading both refuse the press. Loading also reports the wait
    // to a screen reader, and keeps the button's width so the row cannot jump.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxToggleButton(label: 'Off'),
        AstryxToggleButton(label: 'On', pressed: true),
        AstryxToggleButton(label: 'Disabled', enabled: false),
        AstryxToggleButton(label: 'Saving', pressed: true, loading: true),
      ],
    );
  }
}

// #end
