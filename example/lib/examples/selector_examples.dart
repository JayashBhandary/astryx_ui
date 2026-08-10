import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example selector_demo -> SelectorDemoExample
class SelectorDemoExample extends StatefulWidget {
  const SelectorDemoExample({super.key});

  @override
  State<SelectorDemoExample> createState() => _SelectorDemoExampleState();
}

class _SelectorDemoExampleState extends State<SelectorDemoExample> {
  String? _owner = 'ada';

  @override
  Widget build(BuildContext context) {
    return AstryxSelector<String>(
      label: 'Owner',
      value: _owner,
      width: 320,
      onChanged: (value) => setState(() => _owner = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
      ],
    );
  }
}
// #end

// #example selector_sections -> SelectorSectionsExample
class SelectorSectionsExample extends StatefulWidget {
  const SelectorSectionsExample({super.key});

  @override
  State<SelectorSectionsExample> createState() =>
      _SelectorSectionsExampleState();
}

class _SelectorSectionsExampleState extends State<SelectorSectionsExample> {
  String? _owner;

  @override
  Widget build(BuildContext context) {
    // Three entry types: options, section headings and dividers. Headings and
    // dividers are skipped by the keyboard, so arrowing never lands on one.
    return AstryxSelector<String>(
      label: 'Assign to',
      placeholder: 'Nobody yet',
      value: _owner,
      showClear: true,
      width: 320,
      onChanged: (value) => setState(() => _owner = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorSection('Engineering'),
        AstryxSelectorOption(
          value: 'ada',
          label: 'Ada Lovelace',
          description: 'Platform',
        ),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection('Design'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
        AstryxSelectorOption(
          value: 'katherine',
          label: 'Katherine Johnson',
          enabled: false,
        ),
      ],
    );
  }
}
// #end

// #example selector_search -> SelectorSearchExample
class SelectorSearchExample extends StatefulWidget {
  const SelectorSearchExample({super.key});

  @override
  State<SelectorSearchExample> createState() => _SelectorSearchExampleState();
}

class _SelectorSearchExampleState extends State<SelectorSearchExample> {
  String? _zone;

  static final List<AstryxSelectorEntry<String>> _zones =
      <AstryxSelectorEntry<String>>[
        for (var hour = -11; hour <= 12; hour++)
          AstryxSelectorOption<String>(
            value: 'UTC$hour',
            label: 'UTC${hour >= 0 ? '+' : ''}$hour',
          ),
      ];

  @override
  Widget build(BuildContext context) {
    // Worth turning `showSearch` on past roughly a dozen options. Below that it
    // is a box to tab past for no gain.
    return AstryxSelector<String>(
      label: 'Timezone',
      value: _zone,
      showSearch: true,
      searchPlaceholder: 'Filter zones',
      emptyLabel: 'No zone matches',
      width: 320,
      onChanged: (value) => setState(() => _zone = value),
      options: _zones,
    );
  }
}
// #end

// #example selector_icons -> SelectorIconsExample
class SelectorIconsExample extends StatefulWidget {
  const SelectorIconsExample({super.key});

  @override
  State<SelectorIconsExample> createState() => _SelectorIconsExampleState();
}

class _SelectorIconsExampleState extends State<SelectorIconsExample> {
  String? _status = 'open';

  @override
  Widget build(BuildContext context) {
    return AstryxSelector<String>(
      label: 'Status',
      value: _status,
      width: 320,
      leading: const AstryxIcon(
        AstryxIconName.funnel,
        size: AstryxIconSize.sm,
        color: AstryxIconColor.secondary,
      ),
      onChanged: (value) => setState(() => _status = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(
          value: 'open',
          label: 'Open',
          icon: AstryxIcon(AstryxIconName.info),
        ),
        AstryxSelectorOption(
          value: 'done',
          label: 'Done',
          icon: AstryxIcon(AstryxIconName.check),
        ),
        AstryxSelectorOption(
          value: 'blocked',
          label: 'Blocked',
          icon: AstryxIcon(AstryxIconName.warning),
        ),
      ],
    );
  }
}
// #end

// #example selector_states -> SelectorStatesExample
class SelectorStatesExample extends StatelessWidget {
  const SelectorStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSelector<String>(
          label: 'Required, nothing chosen',
          value: null,
          required: true,
          width: 320,
          status: AstryxFieldStatus.error('Pick a status'),
          options: <AstryxSelectorEntry<String>>[
            AstryxSelectorOption(value: 'open', label: 'Open'),
          ],
        ),
        AstryxSelector<String>(
          label: 'Disabled',
          value: null,
          enabled: false,
          width: 320,
          placeholder: 'Managed by your admin',
          options: <AstryxSelectorEntry<String>>[
            AstryxSelectorOption(value: 'open', label: 'Open'),
          ],
        ),
      ],
    );
  }
}
// #end
