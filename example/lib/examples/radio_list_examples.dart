import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// The choices the examples on this page offer.
enum Plan { free, pro, enterprise }

// #example radio_list_demo -> RadioListDemoExample
class RadioListDemoExample extends StatefulWidget {
  const RadioListDemoExample({super.key});

  @override
  State<RadioListDemoExample> createState() => _RadioListDemoExampleState();
}

class _RadioListDemoExampleState extends State<RadioListDemoExample> {
  Plan _plan = Plan.pro;

  @override
  Widget build(BuildContext context) {
    return AstryxRadioList<Plan>(
      label: 'Plan',
      value: _plan,
      onChanged: (value) => setState(() => _plan = value),
      options: const <AstryxRadioOption<Plan>>[
        AstryxRadioOption(
          value: Plan.free,
          label: 'Free',
          description: 'One project, community support.',
        ),
        AstryxRadioOption(
          value: Plan.pro,
          label: 'Pro',
          description: 'Unlimited projects, email support.',
        ),
        AstryxRadioOption(
          value: Plan.enterprise,
          label: 'Enterprise',
          description: 'Contact sales.',
          enabled: false,
        ),
      ],
    );
  }
}
// #end

// #example radio_list_horizontal -> RadioListHorizontalExample
class RadioListHorizontalExample extends StatefulWidget {
  const RadioListHorizontalExample({super.key});

  @override
  State<RadioListHorizontalExample> createState() =>
      _RadioListHorizontalExampleState();
}

class _RadioListHorizontalExampleState
    extends State<RadioListHorizontalExample> {
  String _visibility = 'private';

  @override
  Widget build(BuildContext context) {
    // Horizontal suits two or three short labels and nothing longer.
    return AstryxRadioList<String>(
      label: 'Visibility',
      orientation: AstryxRadioListOrientation.horizontal,
      value: _visibility,
      onChanged: (value) => setState(() => _visibility = value),
      options: const <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'private', label: 'Private'),
        AstryxRadioOption(value: 'team', label: 'Team'),
        AstryxRadioOption(value: 'public', label: 'Public'),
      ],
    );
  }
}
// #end

// #example radio_list_validation -> RadioListValidationExample
class RadioListValidationExample extends StatefulWidget {
  const RadioListValidationExample({super.key});

  @override
  State<RadioListValidationExample> createState() =>
      _RadioListValidationExampleState();
}

class _RadioListValidationExampleState
    extends State<RadioListValidationExample> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    // A null value is a group with nothing chosen — which is where a required
    // group starts, and what its error message is for.
    return AstryxRadioList<String>(
      label: 'Why are you leaving?',
      description: 'This goes to the product team, not to support.',
      required: true,
      value: _reason,
      status: _reason == null
          ? const AstryxFieldStatus.error('Choose one to continue')
          : const AstryxFieldStatus.success('Thanks — that helps'),
      onChanged: (value) => setState(() => _reason = value),
      options: const <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'price', label: 'Too expensive'),
        AstryxRadioOption(value: 'missing', label: 'Missing a feature'),
        AstryxRadioOption(value: 'other', label: 'Something else'),
      ],
    );
  }
}
// #end

// #example radio_list_sizes -> RadioListSizesExample
class RadioListSizesExample extends StatelessWidget {
  const RadioListSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxRadioList<String>(
            label: size.name,
            size: size,
            value: 'a',
            onChanged: (_) {},
            options: const <AstryxRadioOption<String>>[
              AstryxRadioOption(value: 'a', label: 'First'),
              AstryxRadioOption(value: 'b', label: 'Second'),
            ],
          ),
      ],
    );
  }
}
// #end

// #example radio_list_disabled -> RadioListDisabledExample
class RadioListDisabledExample extends StatelessWidget {
  const RadioListDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxRadioList<String>(
      label: 'Data region',
      description: 'Managed by your administrator.',
      enabled: false,
      value: 'eu',
      options: <AstryxRadioOption<String>>[
        AstryxRadioOption(value: 'eu', label: 'Europe'),
        AstryxRadioOption(value: 'us', label: 'United States'),
      ],
    );
  }
}
// #end
