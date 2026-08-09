import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/widgets.dart';

/// `AstryxTextInput`, `AstryxTextArea` and `AstryxField`.
abstract final class TextInputDemo {
  static Widget build(BuildContext context) => const _TextInputDemo();
}

class _TextInputDemo extends StatefulWidget {
  const _TextInputDemo();

  @override
  State<_TextInputDemo> createState() => _TextInputDemoState();
}

class _TextInputDemoState extends State<_TextInputDemo> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _search = TextEditingController(text: 'invoice');
  final TextEditingController _notes = TextEditingController();

  AstryxFieldStatus? get _emailStatus {
    final value = _email.text;
    if (value.isEmpty) return null;
    return value.contains('@')
        ? const AstryxFieldStatus.success('That looks right')
        : const AstryxFieldStatus.error('Enter a valid email address');
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _search.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Sizes',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (final size in AstryxInputSize.values)
              AstryxTextInput(
                label: size.name,
                size: size,
                placeholder: 'Placeholder text',
                width: 320,
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'Validation — the status is announced, not just coloured',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxTextInput(
              label: 'Email',
              controller: _email,
              required: true,
              description: 'We only use this to sign you in.',
              placeholder: 'you@example.com',
              status: _emailStatus,
              onChanged: (_) => setState(() {}),
              width: 320,
            ),
            const AstryxTextInput(
              label: 'Workspace',
              status: AstryxFieldStatus.warning('This name is nearly taken'),
              width: 320,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Affordances',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxTextInput(
              label: 'Password',
              controller: _password,
              obscureText: true,
              placeholder: '••••••••',
              width: 320,
            ),
            AstryxTextInput(
              label: 'Search',
              controller: _search,
              showClear: true,
              onChanged: (_) => setState(() {}),
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
              width: 320,
            ),
            const AstryxTextInput(
              label: 'Account ID',
              enabled: false,
              placeholder: 'acct_0192',
              width: 320,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'TextArea',
        child: SizedBox(
          width: 420,
          child: AstryxTextArea(
            label: 'Notes',
            controller: _notes,
            optional: true,
            placeholder: 'What happened?',
            description: 'Markdown is not interpreted.',
          ),
        ),
      ),
    ],
  );
}

/// `AstryxCheckbox`, `AstryxRadioList` and `AstryxSwitch`.
abstract final class ToggleDemo {
  static Widget build(BuildContext context) => const _ToggleDemo();
}

enum _Plan { free, pro, enterprise }

class _ToggleDemo extends StatefulWidget {
  const _ToggleDemo();

  @override
  State<_ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<_ToggleDemo> {
  bool _terms = false;
  bool _notify = true;
  bool _digest = false;
  _Plan _plan = _Plan.pro;

  final Set<String> _scopes = <String>{'read'};

  /// The parent checkbox is indeterminate when only some scopes are on — the
  /// case the tri-state constructor exists for.
  AstryxCheckboxValue get _allScopes => switch (_scopes.length) {
    0 => AstryxCheckboxValue.unchecked,
    3 => AstryxCheckboxValue.checked,
    _ => AstryxCheckboxValue.indeterminate,
  };

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Checkbox',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxCheckbox(
              label: 'Accept terms',
              description: 'You can withdraw consent at any time.',
              value: _terms,
              onChanged: (value) => setState(() => _terms = value),
            ),
            AstryxCheckbox(
              label: 'Small',
              size: AstryxToggleSize.sm,
              value: _terms,
              onChanged: (value) => setState(() => _terms = value),
            ),
            AstryxCheckbox(label: 'Disabled', value: true, enabled: false),
            AstryxCheckbox(label: 'Saving', value: true, loading: true),
            AstryxCheckbox(
              label: 'With an error',
              value: false,
              status: const AstryxFieldStatus.error('This must be checked'),
              onChanged: (_) {},
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Indeterminate — a parent over its children',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxCheckbox.tristate(
              label: 'All scopes',
              value: _allScopes,
              onChanged: (value) => setState(() {
                _scopes
                  ..clear()
                  ..addAll(
                    value == AstryxCheckboxValue.checked
                        ? const <String>{'read', 'write', 'admin'}
                        : const <String>{},
                  );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  for (final scope in const <String>['read', 'write', 'admin'])
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
        ),
      ),
      DemoSection(
        title: 'RadioList — arrows move and select, Tab leaves the group',
        child: AstryxRadioList<_Plan>(
          label: 'Plan',
          value: _plan,
          onChanged: (value) => setState(() => _plan = value),
          options: const <AstryxRadioOption<_Plan>>[
            AstryxRadioOption(
              value: _Plan.free,
              label: 'Free',
              description: 'One project, community support.',
            ),
            AstryxRadioOption(
              value: _Plan.pro,
              label: 'Pro',
              description: 'Unlimited projects.',
            ),
            AstryxRadioOption(
              value: _Plan.enterprise,
              label: 'Enterprise',
              description: 'Contact sales.',
              enabled: false,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Switch',
        child: SizedBox(
          width: 360,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxSwitch(
                label: 'Email notifications',
                description: 'Applies immediately.',
                value: _notify,
                labelPosition: AstryxToggleLabelPosition.start,
                labelSpacing: AstryxToggleLabelSpacing.spread,
                onChanged: (value) => setState(() => _notify = value),
              ),
              AstryxSwitch(
                label: 'Weekly digest',
                value: _digest,
                labelPosition: AstryxToggleLabelPosition.start,
                labelSpacing: AstryxToggleLabelSpacing.spread,
                onChanged: (value) => setState(() => _digest = value),
              ),
              AstryxSwitch(
                label: 'Small',
                size: AstryxToggleSize.sm,
                value: _notify,
                onChanged: (value) => setState(() => _notify = value),
              ),
              const AstryxSwitch(
                label: 'Managed by your admin',
                value: true,
                enabled: false,
              ),
              const AstryxSwitch(label: 'Saving', value: false, loading: true),
            ],
          ),
        ),
      ),
    ],
  );
}

/// `AstryxSelector`.
abstract final class SelectorDemo {
  static Widget build(BuildContext context) => const _SelectorDemo();
}

class _SelectorDemo extends StatefulWidget {
  const _SelectorDemo();

  @override
  State<_SelectorDemo> createState() => _SelectorDemoState();
}

class _SelectorDemoState extends State<_SelectorDemo> {
  String? _owner = 'ada';
  String? _status;
  String? _timezone;

  static const List<AstryxSelectorEntry<String>> _owners =
      <AstryxSelectorEntry<String>>[
        AstryxSelectorSection('Engineering'),
        AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection('Design'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
        AstryxSelectorOption(
          value: 'katherine',
          label: 'Katherine Johnson',
          enabled: false,
        ),
      ];

  static const List<AstryxSelectorEntry<String>> _statuses =
      <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(
          value: 'open',
          label: 'Open',
          icon: AstryxIcon(AstryxIconName.info),
        ),
        AstryxSelectorOption(
          value: 'closed',
          label: 'Closed',
          icon: AstryxIcon(AstryxIconName.check),
        ),
      ];

  /// Long enough that the search box earns its place — and long enough to
  /// prove the list scrolls and flips rather than running off the screen.
  static final List<AstryxSelectorEntry<String>> _timezones =
      <AstryxSelectorEntry<String>>[
        for (var hour = -11; hour <= 12; hour++)
          AstryxSelectorOption<String>(
            value: 'UTC$hour',
            label: 'UTC${hour >= 0 ? '+' : ''}$hour',
          ),
      ];

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Sections, dividers and a disabled option',
        child: AstryxSelector<String>(
          label: 'Owner',
          value: _owner,
          showClear: true,
          onChanged: (value) => setState(() => _owner = value),
          options: _owners,
          width: 320,
        ),
      ),
      DemoSection(
        title: 'Icons and validation',
        child: AstryxSelector<String>(
          label: 'Status',
          value: _status,
          required: true,
          status: _status == null
              ? const AstryxFieldStatus.error('Pick a status')
              : null,
          onChanged: (value) => setState(() => _status = value),
          options: _statuses,
          width: 320,
        ),
      ),
      DemoSection(
        title: 'Search — and a list tall enough to flip near the bottom',
        child: AstryxSelector<String>(
          label: 'Timezone',
          value: _timezone,
          showSearch: true,
          onChanged: (value) => setState(() => _timezone = value),
          options: _timezones,
          width: 320,
        ),
      ),
      const DemoSection(
        title: 'Disabled',
        child: AstryxSelector<String>(
          label: 'Region',
          value: null,
          enabled: false,
          placeholder: 'Managed by your admin',
          options: _statuses,
          width: 320,
        ),
      ),
    ],
  );
}
