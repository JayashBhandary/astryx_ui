import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The rows a search example pretends to search.
const List<({String name, String kind, String owner})> _projects =
    <({String name, String kind, String owner})>[
      (name: 'Atlas scheduler', kind: 'Service', owner: 'ada'),
      (name: 'Atlas metrics', kind: 'Service', owner: 'grace'),
      (name: 'Billing exports', kind: 'Job', owner: 'ada'),
      (name: 'Beacon gateway', kind: 'Service', owner: 'linus'),
      (name: 'Ledger reconciler', kind: 'Job', owner: 'grace'),
      (name: 'Runbook: deploys', kind: 'Doc', owner: 'ada'),
    ];

// #example typeahead_demo -> TypeaheadDemoExample
class TypeaheadDemoExample extends StatefulWidget {
  const TypeaheadDemoExample({super.key});

  @override
  State<TypeaheadDemoExample> createState() => _TypeaheadDemoExampleState();
}

class _TypeaheadDemoExampleState extends State<TypeaheadDemoExample> {
  final TextEditingController _query = TextEditingController();
  String? _picked;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Type "a". The field keeps focus while the arrows move a highlighted row,
    // so typing, correcting and choosing are one gesture.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTypeahead<String>(
          label: 'Project',
          description: 'Arrow keys move; Enter chooses; Escape closes.',
          controller: _query,
          onSelected: (name) => setState(() => _picked = name),
          source: (text) async {
            // A real source is a request. This one is a list and a small delay,
            // so the spinner and the debounce are visible.
            await Future<void>.delayed(const Duration(milliseconds: 180));
            return <AstryxTypeaheadItem<String>>[
              for (final project in _projects)
                if (project.name.toLowerCase().contains(text.toLowerCase()))
                  AstryxTypeaheadItem(
                    value: project.name,
                    label: project.name,
                    description: '${project.kind} · ${project.owner}',
                  ),
            ];
          },
        ),
        AstryxText(
          _picked == null ? 'Nothing chosen' : 'Chose $_picked',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example base_typeahead_demo -> BaseTypeaheadDemoExample
class BaseTypeaheadDemoExample extends StatefulWidget {
  const BaseTypeaheadDemoExample({super.key});

  @override
  State<BaseTypeaheadDemoExample> createState() =>
      _BaseTypeaheadDemoExampleState();
}

class _BaseTypeaheadDemoExampleState extends State<BaseTypeaheadDemoExample> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // The engine with a field and rows of the caller's own: a token chip per
    // suggestion rather than a list row, which the styled one cannot draw.
    return AstryxBaseTypeahead<String>(
      controller: _query,
      minQueryLength: 0,
      openOnFocus: true,
      onSelected: (owner) => _query.clear(),
      source: (text) async => <String>[
        for (final owner in <String>{
          for (final project in _projects) project.owner,
        })
          if (owner.contains(text.toLowerCase())) owner,
      ],
      headerBuilder: (context, state) => Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing2)),
        child: AstryxText(
          state.suggestions.isEmpty ? 'No owners' : 'Owners',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
      fieldBuilder: (context, state) => AstryxTextInput(
        label: 'Owner',
        controller: state.controller,
        focusNode: state.focusNode,
        placeholder: 'Focus me',
        leading: const AstryxIcon(
          AstryxIconName.search,
          size: AstryxIconSize.sm,
          color: AstryxIconColor.secondary,
        ),
      ),
      itemBuilder: (context, owner, state) {
        final active = state.isActive(state.suggestions.indexOf(owner));

        return Padding(
          padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing1)),
          child: AstryxFocusRing(
            focused: active,
            borderRadius: theme.borderRadius(AstryxRadiusToken.full),
            child: AstryxTokenChip(owner, onPressed: () => state.select(owner)),
          ),
        );
      },
    );
  }
}
// #end

// #example command_palette_demo -> CommandPaletteDemoExample
class CommandPaletteDemoExample extends StatefulWidget {
  const CommandPaletteDemoExample({super.key});

  @override
  State<CommandPaletteDemoExample> createState() =>
      _CommandPaletteDemoExampleState();
}

class _CommandPaletteDemoExampleState extends State<CommandPaletteDemoExample> {
  static const AstryxHotkey _open = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

  final AstryxOverlayController _palette = AstryxOverlayController();
  String _last = 'Nothing run yet';

  @override
  void dispose() {
    _palette.dispose();
    super.dispose();
  }

  void _run(String what) => setState(() => _last = what);

  @override
  Widget build(BuildContext context) {
    // Press the button, or ⌘K / Ctrl+K. The shortcut on each row is drawn from
    // the hotkey that is bound, so the palette cannot teach a stale chord.
    return AstryxHotkeys(
      autofocus: true,
      bindings: <AstryxHotkey, VoidCallback>{_open: _palette.show},
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Open the palette',
                trailing: const AstryxKbd.hotkey(_open),
                onPressed: _palette.show,
              ),
            ],
          ),
          AstryxText(
            _last,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxCommandPalette(
            controller: _palette,
            groups: <AstryxCommandGroup>[
              AstryxCommandGroup(
                label: 'Navigate',
                items: <AstryxCommandItem>[
                  AstryxCommandItem(
                    label: 'Go to deploys',
                    icon: AstryxIconName.arrowUp,
                    hotkey: const AstryxHotkey.mod(LogicalKeyboardKey.keyD),
                    onSelected: () => _run('Went to deploys'),
                  ),
                  AstryxCommandItem(
                    label: 'Go to settings',
                    icon: AstryxIconName.wrench,
                    keywords: const <String>['preferences', 'config'],
                    onSelected: () => _run('Went to settings'),
                  ),
                ],
              ),
              AstryxCommandGroup(
                label: 'Deploy',
                items: <AstryxCommandItem>[
                  AstryxCommandItem(
                    label: 'Roll back the last deploy',
                    icon: AstryxIconName.arrowDown,
                    description: 'Reverts to 13:41',
                    onSelected: () => _run('Rolled back'),
                  ),
                  const AstryxCommandItem(
                    label: 'Promote to production',
                    enabled: false,
                    description: 'Needs an approval first',
                    onSelected: _noop,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _noop() {}
}
// #end

// #example power_search_demo -> PowerSearchDemoExample
class PowerSearchDemoExample extends StatefulWidget {
  const PowerSearchDemoExample({super.key});

  @override
  State<PowerSearchDemoExample> createState() => _PowerSearchDemoExampleState();
}

class _PowerSearchDemoExampleState extends State<PowerSearchDemoExample> {
  AstryxSearchQuery _query = const AstryxSearchQuery();

  Iterable<({String name, String kind, String owner})> get _results =>
      _projects.where((project) {
        final text = _query.text.trim().toLowerCase();
        if (text.isNotEmpty && !project.name.toLowerCase().contains(text)) {
          return false;
        }
        return _query.filters.every((filter) => switch (filter.field) {
          'kind' => project.kind == filter.value,
          'owner' => project.owner == filter.value,
          _ => true,
        });
      });

  @override
  Widget build(BuildContext context) {
    // Filters are chips beside the text, not syntax inside it: nothing to
    // learn, nothing to mistype, and no error message to write.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxPowerSearch(
          query: _query,
          options: const <AstryxSearchFilterOption>[
            AstryxSearchFilterOption(
              field: 'kind',
              label: 'Kind',
              values: <String>['Service', 'Job', 'Doc'],
            ),
            AstryxSearchFilterOption(
              field: 'owner',
              label: 'Owner',
              values: <String>['ada', 'grace', 'linus'],
            ),
          ],
          onChanged: (query) => setState(() => _query = query),
        ),
        AstryxList(
          children: <Widget>[
            for (final project in _results)
              AstryxItem(
                label: project.name,
                description: '${project.kind} · ${project.owner}',
              ),
          ],
        ),
        if (_results.isEmpty)
          const AstryxEmptyState(
            title: 'Nothing matches',
            description: 'Remove a filter, or search for something else.',
          ),
      ],
    );
  }
}
// #end
