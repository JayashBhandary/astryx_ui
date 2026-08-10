import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example checkbox_demo -> CheckboxDemoExample
class CheckboxDemoExample extends StatefulWidget {
  const CheckboxDemoExample({super.key});

  @override
  State<CheckboxDemoExample> createState() => _CheckboxDemoExampleState();
}

class _CheckboxDemoExampleState extends State<CheckboxDemoExample> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AstryxCheckbox(
      label: 'Accept the terms of service',
      description: 'You can withdraw consent at any time.',
      value: _accepted,
      onChanged: (value) => setState(() => _accepted = value),
    );
  }
}
// #end

// #example checkbox_tristate -> CheckboxTristateExample
class CheckboxTristateExample extends StatefulWidget {
  const CheckboxTristateExample({super.key});

  @override
  State<CheckboxTristateExample> createState() =>
      _CheckboxTristateExampleState();
}

class _CheckboxTristateExampleState extends State<CheckboxTristateExample> {
  static const List<String> _all = <String>['read', 'write', 'admin'];
  final Set<String> _scopes = <String>{'read'};

  /// Indeterminate is what a parent looks like when only some of its children
  /// are on — the case the tri-state constructor exists for.
  AstryxCheckboxValue get _parent => switch (_scopes.length) {
    0 => AstryxCheckboxValue.unchecked,
    3 => AstryxCheckboxValue.checked,
    _ => AstryxCheckboxValue.indeterminate,
  };

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCheckbox.tristate(
          label: 'All scopes',
          value: _parent,
          onChanged: (value) => setState(() {
            _scopes
              ..clear()
              ..addAll(
                value == AstryxCheckboxValue.checked ? _all : const <String>[],
              );
          }),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 28),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              for (final scope in _all)
                AstryxCheckbox(
                  label: scope,
                  value: _scopes.contains(scope),
                  onChanged: (value) => setState(() {
                    if (value) {
                      _scopes.add(scope);
                    } else {
                      _scopes.remove(scope);
                    }
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
// #end

// #example checkbox_sizes -> CheckboxSizesExample
class CheckboxSizesExample extends StatelessWidget {
  const CheckboxSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxCheckbox(
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

// #example checkbox_states -> CheckboxStatesExample
class CheckboxStatesExample extends StatelessWidget {
  const CheckboxStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCheckbox(label: 'Disabled', value: true, enabled: false),
        // Read-only is not disabled: the value still means something, it is
        // just not yours to change here. So it is not dimmed.
        AstryxCheckbox(label: 'Read-only', value: true, readOnly: true),
        AstryxCheckbox(label: 'Saving', value: true, loading: true),
        AstryxCheckbox(
          label: 'With an error',
          value: false,
          status: const AstryxFieldStatus.error('This must be checked'),
          onChanged: (_) {},
        ),
        AstryxCheckbox(
          label: 'Label hidden — still announced',
          labelHidden: true,
          value: false,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
// #end
