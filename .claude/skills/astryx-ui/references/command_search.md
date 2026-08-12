# Command & search

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxCommandPalette

`lib/src/components/search/command_palette.dart` · upstream `CommandPalette / CommandPaletteEmpty / CommandPaletteFooter / CommandPaletteGroup / CommandPaletteInput / CommandPaletteItem / CommandPaletteList`

The keyboard-first command surface: a query, grouped results, and a footer of shortcuts.

```dart
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
```

**Rules**

- **Accessibility:** The palette is a modal layer: the scrim marks the page behind it inert, focus is trapped, Escape closes it and focus returns to whatever opened it. The footer states the three keys rather than assuming they are known — a palette is often the first keyboard-only surface a user meets.
- **Note:** It closes **before** running the command. A command that opens a dialog would otherwise open it behind the palette.

| Key | Does |
| --- | --- |
| Typing | Filters. The query field takes focus on open, so there is nothing to click first. |
| `↑` / `↓` | Moves the highlight, **skipping headings and disabled commands** and wrapping at the ends. |
| `Enter` | Runs the highlighted command and closes. |
| `Esc` | Closes. Nothing is run. |

### AstryxCommandPalette

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxOverlayController` | — | Opens and closes it. |
| `groups` **(required)** | `List<AstryxCommandGroup>` | — | The commands. A group with an empty label draws no heading. |
| `empty` | `Widget?` | — | Shown when the query matches nothing. |
| `footer` | `Widget?` | — | Replaces the shortcut legend. |
| `showFooter` | `bool` | `true` | Whether to draw the footer at all. |
| `width` | `double` | `560` | How wide it is. |
| `maxHeight` | `double` | `420` | The tallest the result list grows before it scrolls. |
| `clearOnClose` | `bool` | `true` | Whether closing empties the query. A palette reopened on last week’s half-typed query has to be cleared before it is useful. |

### AstryxCommandItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | What the command is called. |
| `onSelected` **(required)** | `VoidCallback` | — | What running it does. |
| `description` | `String?` | — | A qualifying second line. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `hotkey` | `AstryxHotkey?` | — | The shortcut that runs it elsewhere, drawn on the row. |
| `keywords` | `List<String>` | `const <String>[]` | Extra words the query should match. |
| `enabled` | `bool` | `true` | Whether it can be run now. Disabled rows are shown and skipped. |

---

## AstryxTypeahead

`lib/src/components/search/typeahead.dart` · upstream `Typeahead / TypeaheadItem`

A text field that suggests completions as you type.

```dart
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
```

**Rules**

- **Careful:** An AstryxSelector (references/forms.md) picks from a set it can **show** you; a typeahead searches a set it cannot — a thousand projects, every user, the whole log. If the options fit in a list, use the selector: it can be browsed, and this can only be queried. Reaching for a typeahead over twelve options hides all twelve behind a guess about what to type.

### AstryxTypeahead

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `TextEditingController` | — | The query being typed. |
| `source` **(required)** | `AstryxTypeaheadSource<AstryxTypeaheadItem<T>>` | — | Where suggestions come from. |
| `onSelected` | `ValueChanged<T>?` | — | Called with the value of the chosen suggestion. |
| `minQueryLength` | `int` | `1` | How many characters before the source is called. |
| `debounce` | `Duration` | `Duration(milliseconds: 200)` | How long to wait after a keystroke. |
| `clearOnSelect` | `bool` | `false` | Whether choosing empties the field. |
| `openOnFocus` | `bool` | `false` | Whether to search as soon as the field takes focus. |
| `emptyBuilder` | `Widget Function(context, query)?` | — | What the surface shows when a search returned nothing. |

### AstryxTypeaheadItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What choosing this produces. |
| `label` **(required)** | `String` | — | The visible text. |
| `description` | `String?` | — | A second line — what tells two similar labels apart. |
| `icon` | `AstryxIconName?` | — | A glyph before the label. |
| `trailing` | `Widget?` | — | Content at the end of the row. |

---

## AstryxBaseTypeahead

`lib/src/components/search/base_typeahead.dart` · upstream `BaseTypeahead`

The unstyled typeahead the other search inputs are built from.

```dart
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
```

**Rules**

- **Accessibility:** **The result count is announced.** A dropdown appearing is silent to a screen reader, so "3 results" is spoken through a live region — otherwise there is no way to know a search answered at all. Draw the active row as selected in `itemBuilder`, so the keyboard and the pointer agree about where you are.

| Key | Does |
| --- | --- |
| `↑` / `↓` | Moves the active row, and scrolls it into view. |
| `Enter` | Chooses the active row — and is **left to the form** when there is none, because a typeahead must not swallow the key that submits the search. |
| `Esc` | Closes the surface and nothing else: the query stays, and the dialog behind it stays open. |

### AstryxBaseTypeahead

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `TextEditingController` | — | The text being edited. |
| `source` **(required)** | `AstryxTypeaheadSource<T>` | — | Where suggestions come from — `Future<List<T>> Function(String)`. |
| `fieldBuilder` **(required)** | `Widget Function(context, state)` | — | Builds the field. Wire it to `state.controller` and `state.focusNode`. |
| `itemBuilder` **(required)** | `Widget Function(context, suggestion, state)` | — | Builds one row. |
| `headerBuilder` | `Widget Function(context, state)?` | — | Content above the suggestions. |
| `footerBuilder` | `Widget Function(context, state)?` | — | Content below them. |
| `matchFieldWidth` | `bool` | `true` | Whether the surface takes the field’s width. |

### AstryxTypeaheadState

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `query` | `String` | — | What has been typed. |
| `suggestions` | `List<T>` | — | What the source last returned. |
| `loading` | `bool` | — | Whether a call is in flight. |
| `activeIndex` | `int` | — | The row the arrows are on, or -1. **Not a selection.** |
| `isActive(index)` | `bool` | — | Whether that row is the active one. |
| `select(item)` | `void` | — | Chooses, as pressing would. |
| `open()` | `void` | — | Searches with the current text. |
| `close()` | `void` | — | Hides the surface. |

---

## AstryxPowerSearch

`lib/src/components/search/power_search.dart` · upstream `PowerSearch`

A search input with structured filters alongside the free text.

```dart
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
```

**Rules**

- **Accessibility:** The field announces **how many filters are applied** as its value, so a reader knows the search is narrowed before wondering why it found nothing. Each chip keeps its own node and its remove button is named after the filter it removes.

### AstryxPowerSearch

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `query` **(required)** | `AstryxSearchQuery` | — | What is being searched for now. |
| `options` **(required)** | `List<AstryxSearchFilterOption>` | — | The filters that can be added. |
| `onChanged` | `ValueChanged<AstryxSearchQuery>?` | — | Called whenever the text or the filters change. |
| `onSubmitted` | `ValueChanged<AstryxSearchQuery>?` | — | Called when the search is submitted from the keyboard. |
| `labelHidden` | `bool` | `true` | Hidden by default: a search field beside a magnifier is the one case where a visible label is redundant to everybody who can see it. |

### AstryxSearchQuery

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `text` | `String` | `''` | The free text. |
| `filters` | `List<AstryxSearchFilter>` | `const <AstryxSearchFilter>[]` | The structured filters. |
| `isEmpty` | `bool` | — | Whether there is nothing to search for. |

### AstryxSearchFilter

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `field` **(required)** | `String` | — | What is being filtered on. |
| `value` **(required)** | `String` | — | What it is filtered to. |
| `label` | `String?` | — | How to write it. Defaults to `field:value`. |
| `icon` | `AstryxIconName?` | — | A glyph on the chip. |

---

