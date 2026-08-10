import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example switch_demo -> SwitchDemoExample
class SwitchDemoExample extends StatefulWidget {
  const SwitchDemoExample({super.key});

  @override
  State<SwitchDemoExample> createState() => _SwitchDemoExampleState();
}

class _SwitchDemoExampleState extends State<SwitchDemoExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return AstryxSwitch(
      label: 'Email notifications',
      description: 'Applies immediately.',
      value: _enabled,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
// #end

// #example switch_settings_list -> SwitchSettingsListExample
class SwitchSettingsListExample extends StatefulWidget {
  const SwitchSettingsListExample({super.key});

  @override
  State<SwitchSettingsListExample> createState() =>
      _SwitchSettingsListExampleState();
}

class _SwitchSettingsListExampleState extends State<SwitchSettingsListExample> {
  final Set<String> _on = <String>{'digest'};

  @override
  Widget build(BuildContext context) {
    // The settings-list shape: label at the reading edge, switch at the
    // trailing one, the row spread between them.
    return AstryxCard(
      maxWidth: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final setting in const <List<String>>[
            <String>['digest', 'Weekly digest', 'Every Monday, 9am'],
            <String>['mentions', 'Mentions', 'When someone @s you'],
            <String>['deploys', 'Deploy failures', 'Errors only'],
          ])
            AstryxSwitch(
              label: setting[1],
              description: setting[2],
              value: _on.contains(setting[0]),
              labelPosition: AstryxToggleLabelPosition.start,
              labelSpacing: AstryxToggleLabelSpacing.spread,
              onChanged: (value) => setState(() {
                if (value) {
                  _on.add(setting[0]);
                } else {
                  _on.remove(setting[0]);
                }
              }),
            ),
        ],
      ),
    );
  }
}
// #end

// #example switch_sizes -> SwitchSizesExample
class SwitchSizesExample extends StatelessWidget {
  const SwitchSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxSwitch(
            label: size.name,
            size: size,
            value: true,
            onChanged: (_) {},
          ),
      ],
    );
  }
}
// #end

// #example switch_states -> SwitchStatesExample
class SwitchStatesExample extends StatelessWidget {
  const SwitchStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        const AstryxSwitch(
          label: 'Managed by your admin',
          value: true,
          enabled: false,
        ),
        const AstryxSwitch(label: 'Saving', value: false, loading: true),
        AstryxSwitch(
          label: 'Read-only',
          value: true,
          readOnly: true,
          onChanged: (_) {},
        ),
        const AstryxSwitch(
          label: 'Beta features',
          value: false,
          status: AstryxFieldStatus.warning('These can change without notice'),
        ),
      ],
    );
  }
}
// #end
