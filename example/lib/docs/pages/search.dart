import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Command & search — the palette, the two typeaheads, and the filter bar.
///
/// One engine and three surfaces on it. The engine is the page worth reading
/// first: everything the other three get right about the keyboard, they get
/// from there.
final List<DocPage> searchPages = <DocPage>[
  _commandPalette,
  _typeahead,
  _baseTypeahead,
  _powerSearch,
];

const String _group = DocGroup.commandSearch;

const DocPage _commandPalette = DocPage(
  id: 'command_palette',
  title: 'AstryxCommandPalette',
  group: _group,
  description:
      'The keyboard-first command surface: a query, grouped results, and a '
      'footer of shortcuts.',
  source: 'lib/src/components/search/command_palette.dart',
  upstream:
      'CommandPalette / CommandPaletteEmpty / CommandPaletteFooter / '
      'CommandPaletteGroup / CommandPaletteInput / CommandPaletteItem / '
      'CommandPaletteList',
  upstreamPath: '/components/CommandPalette',
  blocks: <DocBlock>[
    DocExample('command_palette_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxHotkeys(
  autofocus: true,
  bindings: <AstryxHotkey, VoidCallback>{
    const AstryxHotkey.mod(LogicalKeyboardKey.keyK): _palette.show,
  },
  child: Stack(
    children: <Widget>[
      page,
      AstryxCommandPalette(controller: _palette, groups: _commands),
    ],
  ),
)'''),
    DocProse(
      'Upstream ships the input, the list, the group, the item, the empty '
      'state and the footer separately. They are one widget here, because a '
      'palette assembled from six pieces is six chances to get the keyboard '
      'wrong — and the keyboard is the entire reason a palette exists.',
    ),
    DocProse(
      'Like every overlay in this package it is a **widget in the tree**, not '
      'a `show…` call: it renders nothing until the controller opens it, so it '
      'sits next to whatever opens it and there is no `BuildContext` to '
      'smuggle across an async gap.',
    ),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>[
          'Typing',
          'Filters. The query field takes focus on open, so there is nothing '
              'to click first.',
        ],
        <String>[
          '`↑` / `↓`',
          'Moves the highlight, **skipping headings and disabled commands** '
              'and wrapping at the ends.',
        ],
        <String>['`Enter`', 'Runs the highlighted command and closes.'],
        <String>['`Esc`', 'Closes. Nothing is run.'],
      ],
    ),
    DocProse(
      'The highlight returns to the top on every keystroke: the best match for '
      'what is typed *now* is the first row, and leaving it three rows down '
      'means `Enter` runs something the user has stopped looking at. The first '
      'runnable row is active on open, so `Enter` straight away does the '
      'obvious thing rather than nothing.',
    ),
    DocHeading('Finding a command'),
    DocProse(
      'A query matches the label, the description **and the keywords**. Those '
      'matter more than they look: "Log out" has to be findable by "sign out", '
      '"exit" and "quit", and a command nobody can find by the word they '
      'thought of is a command that is not there.',
    ),
    DocProse(
      'Each row draws its own shortcut from the `AstryxHotkey` that is *bound* '
      'elsewhere in the application — so the palette teaches the real chord '
      'and cannot describe one that has moved. Empty groups disappear rather '
      'than showing a heading over nothing.',
    ),
    DocCallout.accessibility(
      'The palette is a modal layer: the scrim marks the page behind it inert, '
      'focus is trapped, Escape closes it and focus returns to whatever opened '
      'it. The footer states the three keys rather than assuming they are '
      'known — a palette is often the first keyboard-only surface a user '
      'meets.',
    ),
    DocCallout.note(
      'It closes **before** running the command. A command that opens a dialog '
      'would otherwise open it behind the palette.',
    ),
    DocApi('AstryxCommandPalette', <DocProp>[
      DocProp(
        'controller',
        'AstryxOverlayController',
        'Opens and closes it.',
        required: true,
      ),
      DocProp(
        'groups',
        'List<AstryxCommandGroup>',
        'The commands. A group with an empty label draws no heading.',
        required: true,
      ),
      DocProp('empty', 'Widget?', 'Shown when the query matches nothing.'),
      DocProp(
        'footer',
        'Widget?',
        'Replaces the shortcut legend.',
      ),
      DocProp(
        'showFooter',
        'bool',
        'Whether to draw the footer at all.',
        defaultValue: 'true',
      ),
      DocProp('width', 'double', 'How wide it is.', defaultValue: '560'),
      DocProp(
        'maxHeight',
        'double',
        'The tallest the result list grows before it scrolls.',
        defaultValue: '420',
      ),
      DocProp(
        'clearOnClose',
        'bool',
        'Whether closing empties the query. A palette reopened on last week’s '
            'half-typed query has to be cleared before it is useful.',
        defaultValue: 'true',
      ),
    ]),
    DocApi(
      'AstryxCommandItem',
      <DocProp>[
        DocProp(
          'label',
          'String',
          'What the command is called.',
          required: true,
        ),
        DocProp(
          'onSelected',
          'VoidCallback',
          'What running it does.',
          required: true,
        ),
        DocProp('description', 'String?', 'A qualifying second line.'),
        DocProp('icon', 'AstryxIconName?', 'A glyph before the label.'),
        DocProp(
          'hotkey',
          'AstryxHotkey?',
          'The shortcut that runs it elsewhere, drawn on the row.',
        ),
        DocProp(
          'keywords',
          'List<String>',
          'Extra words the query should match.',
          defaultValue: 'const <String>[]',
        ),
        DocProp(
          'enabled',
          'bool',
          'Whether it can be run now. Disabled rows are shown and skipped.',
          defaultValue: 'true',
        ),
      ],
      description:
          'One command. `AstryxCommandGroup` is a label and a list of these.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxHotkeys](use_hotkeys) — binding the shortcut that opens it.',
      '[AstryxKbd](kbd) — the caps on each row.',
      '[AstryxDropdownMenu](dropdown_menu) — for a short list of actions '
          'attached to a control rather than to the application.',
    ]),
  ],
);

const DocPage _typeahead = DocPage(
  id: 'typeahead',
  title: 'AstryxTypeahead',
  group: _group,
  description: 'A text field that suggests completions as you type.',
  source: 'lib/src/components/search/typeahead.dart',
  upstream: 'Typeahead / TypeaheadItem',
  upstreamPath: '/components/Typeahead',
  blocks: <DocBlock>[
    DocExample('typeahead_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxTypeahead<Project>(
  label: 'Project',
  controller: _query,
  source: (query) async => <AstryxTypeaheadItem<Project>>[
    for (final project in await api.search(query))
      AstryxTypeaheadItem(value: project, label: project.name),
  ],
  onSelected: _open,
)'''),
    DocProse(
      '[AstryxBaseTypeahead](base_typeahead) with this package’s own field and '
      'rows on it: a search glyph, a spinner while a request is in flight, a '
      'clear button, and an `AstryxItem` per suggestion.',
    ),
    DocHeading('It is not a selector'),
    DocCallout.warning(
      'An [AstryxSelector](selector) picks from a set it can **show** you; a '
      'typeahead searches a set it cannot — a thousand projects, every user, '
      'the whole log. If the options fit in a list, use the selector: it can '
      'be browsed, and this can only be queried. Reaching for a typeahead over '
      'twelve options hides all twelve behind a guess about what to type.',
    ),
    DocHeading('After choosing'),
    DocProse(
      'By default the chosen label replaces the query — a field left holding '
      '"atl" after picking "Atlas" reads as a failed search. `clearOnSelect` '
      'empties it instead, which is right for a search box that dispatches '
      'somewhere and comes back ready for the next query.',
    ),
    DocApi('AstryxTypeahead', <DocProp>[
      DocProp(
        'controller',
        'TextEditingController',
        'The query being typed.',
        required: true,
      ),
      DocProp(
        'source',
        'AstryxTypeaheadSource<AstryxTypeaheadItem<T>>',
        'Where suggestions come from.',
        required: true,
      ),
      DocProp(
        'onSelected',
        'ValueChanged<T>?',
        'Called with the value of the chosen suggestion.',
      ),
      DocProp(
        'minQueryLength',
        'int',
        'How many characters before the source is called.',
        defaultValue: '1',
      ),
      DocProp(
        'debounce',
        'Duration',
        'How long to wait after a keystroke.',
        defaultValue: 'Duration(milliseconds: 200)',
      ),
      DocProp(
        'clearOnSelect',
        'bool',
        'Whether choosing empties the field.',
        defaultValue: 'false',
      ),
      DocProp(
        'openOnFocus',
        'bool',
        'Whether to search as soon as the field takes focus.',
        defaultValue: 'false',
      ),
      DocProp(
        'emptyBuilder',
        'Widget Function(context, query)?',
        'What the surface shows when a search returned nothing.',
      ),
    ]),
    DocApi(
      'AstryxTypeaheadItem',
      <DocProp>[
        DocProp('value', 'T', 'What choosing this produces.', required: true),
        DocProp('label', 'String', 'The visible text.', required: true),
        DocProp(
          'description',
          'String?',
          'A second line — what tells two similar labels apart.',
        ),
        DocProp('icon', 'AstryxIconName?', 'A glyph before the label.'),
        DocProp('trailing', 'Widget?', 'Content at the end of the row.'),
      ],
      description: 'One suggestion.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxBaseTypeahead](base_typeahead) — the engine, and the keyboard '
          'contract.',
      '[AstryxSelector](selector) — when the options can be shown.',
      '[AstryxPowerSearch](power_search) — when the query needs filters as '
          'well as text.',
    ]),
  ],
);

const DocPage _baseTypeahead = DocPage(
  id: 'base_typeahead',
  title: 'AstryxBaseTypeahead',
  group: _group,
  description: 'The unstyled typeahead the other search inputs are built from.',
  source: 'lib/src/components/search/base_typeahead.dart',
  upstream: 'BaseTypeahead',
  upstreamPath: '/components/BaseTypeahead',
  blocks: <DocBlock>[
    DocExample('base_typeahead_demo', align: DocExampleAlign.stretch),
    DocProse(
      'It owns the parts that are the same whatever the thing looks like — the '
      'query, the debounce, the in-flight request, the keyboard, the overlay '
      'and the announcements — and leaves the field and the rows entirely to '
      '`fieldBuilder` and `itemBuilder`.',
    ),
    DocHeading('The field never loses focus'),
    DocProse(
      'Arrow keys move an **active index** inside the surface while the caret '
      'stays where it is. That is the ARIA combobox pattern, and the only '
      'arrangement in which typing, correcting and choosing are one gesture — '
      'a suggestion list that steals focus makes the user tab back to keep '
      'typing.',
    ),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>[
          '`↑` / `↓`',
          'Moves the active row, and scrolls it into view.',
        ],
        <String>[
          '`Enter`',
          'Chooses the active row — and is **left to the form** when there is '
              'none, because a typeahead must not swallow the key that submits '
              'the search.',
        ],
        <String>[
          '`Esc`',
          'Closes the surface and nothing else: the query stays, and the '
              'dialog behind it stays open.',
        ],
      ],
    ),
    DocHeading('Requests'),
    DocList(<String>[
      '`debounce` is what makes a typeahead over a network affordable: without '
          'it, a request per keystroke is exactly what you get.',
      '`minQueryLength` stops the empty-query request. Zero searches on focus, '
          'which is right for a list of recents and wrong for anything costly.',
      '**A stale response cannot overwrite a newer one.** Each call carries a '
          'generation and a late arrival is dropped — the bug every search box '
          'ships once, where the slow first request lands after the fast '
          'second and the user sees results for what they typed three '
          'keystrokes ago.',
      'A source that throws leaves an **empty list**, not a crash: a dropped '
          'request is not a reason to take the screen down. Report it yourself '
          'if it matters.',
    ]),
    DocCallout.accessibility(
      '**The result count is announced.** A dropdown appearing is silent to a '
      'screen reader, so "3 results" is spoken through a live region — '
      'otherwise there is no way to know a search answered at all. Draw the '
      'active row as selected in `itemBuilder`, so the keyboard and the '
      'pointer agree about where you are.',
    ),
    DocApi('AstryxBaseTypeahead', <DocProp>[
      DocProp(
        'controller',
        'TextEditingController',
        'The text being edited.',
        required: true,
      ),
      DocProp(
        'source',
        'AstryxTypeaheadSource<T>',
        'Where suggestions come from — `Future<List<T>> Function(String)`.',
        required: true,
      ),
      DocProp(
        'fieldBuilder',
        'Widget Function(context, state)',
        'Builds the field. Wire it to `state.controller` and '
            '`state.focusNode`.',
        required: true,
      ),
      DocProp(
        'itemBuilder',
        'Widget Function(context, suggestion, state)',
        'Builds one row.',
        required: true,
      ),
      DocProp(
        'headerBuilder',
        'Widget Function(context, state)?',
        'Content above the suggestions.',
      ),
      DocProp(
        'footerBuilder',
        'Widget Function(context, state)?',
        'Content below them.',
      ),
      DocProp(
        'matchFieldWidth',
        'bool',
        'Whether the surface takes the field’s width.',
        defaultValue: 'true',
      ),
    ]),
    DocApi(
      'AstryxTypeaheadState',
      <DocProp>[
        DocProp('query', 'String', 'What has been typed.'),
        DocProp('suggestions', 'List<T>', 'What the source last returned.'),
        DocProp('loading', 'bool', 'Whether a call is in flight.'),
        DocProp(
          'activeIndex',
          'int',
          'The row the arrows are on, or -1. **Not a selection.**',
        ),
        DocProp(
          'isActive(index)',
          'bool',
          'Whether that row is the active one.',
        ),
        DocProp('select(item)', 'void', 'Chooses, as pressing would.'),
        DocProp('open()', 'void', 'Searches with the current text.'),
        DocProp('close()', 'void', 'Hides the surface.'),
      ],
      description: 'What both builders are told, and everything they can do.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTypeahead](typeahead) — this with a field and rows already '
          'drawn.',
      '[AstryxComplexSelector](complex_selector) — the same split for a '
          'selector: a trigger this package draws and a surface you do.',
    ]),
  ],
);

const DocPage _powerSearch = DocPage(
  id: 'power_search',
  title: 'AstryxPowerSearch',
  group: _group,
  description:
      'A search input with structured filters alongside the free text.',
  source: 'lib/src/components/search/power_search.dart',
  upstream: 'PowerSearch',
  upstreamPath: '/components/PowerSearch',
  blocks: <DocBlock>[
    DocExample('power_search_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxPowerSearch(
  query: _query,
  options: <AstryxSearchFilterOption>[
    AstryxSearchFilterOption(
      field: 'status',
      label: 'Status',
      values: <String>['failed', 'running', 'succeeded'],
    ),
  ],
  onChanged: (query) => setState(() => _query = query),
)'''),
    DocHeading('Chips, not syntax'),
    DocProse(
      'The filters sit **beside** the text as chips rather than inside it as '
      '`status:failed`. Syntax in a search box is a thing a user has to learn, '
      'get wrong, and be told off about — and the error message for a mistyped '
      'query is a whole feature nobody budgets for.',
    ),
    DocProse(
      'The values are a closed list for the same reason. A power search whose '
      'filters accept free text is a query language, and a query language '
      'needs a grammar, a parser and an error message this component cannot '
      'write for you.',
    ),
    DocProse(
      'The filter menu is one menu with a **section per field**, not a flyout '
      'per field: the values are what the user came for, and a submenu puts '
      'them behind a hover a touch user cannot perform.',
    ),
    DocHeading('What comes back'),
    DocProse(
      '`AstryxSearchQuery` is the whole state — the free text and the filters '
      'together — so a caller has one object to hold, compare and put in a '
      'URL. It is `==` by value, which is what makes "did the search change" a '
      'question you can answer.',
    ),
    DocProse(
      '`Backspace` on empty text takes the last filter back, the same bargain '
      '[AstryxTokenizer](tokenizer) makes: it is the only way to undo one from '
      'the keyboard. The clear button takes the text and the filters at once, '
      'because clearing half a search is not a thing anybody wants.',
    ),
    DocCallout.accessibility(
      'The field announces **how many filters are applied** as its value, so a '
      'reader knows the search is narrowed before wondering why it found '
      'nothing. Each chip keeps its own node and its remove button is named '
      'after the filter it removes.',
    ),
    DocApi('AstryxPowerSearch', <DocProp>[
      DocProp(
        'query',
        'AstryxSearchQuery',
        'What is being searched for now.',
        required: true,
      ),
      DocProp(
        'options',
        'List<AstryxSearchFilterOption>',
        'The filters that can be added.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<AstryxSearchQuery>?',
        'Called whenever the text or the filters change.',
      ),
      DocProp(
        'onSubmitted',
        'ValueChanged<AstryxSearchQuery>?',
        'Called when the search is submitted from the keyboard.',
      ),
      DocProp(
        'labelHidden',
        'bool',
        'Hidden by default: a search field beside a magnifier is the one case '
            'where a visible label is redundant to everybody who can see it.',
        defaultValue: 'true',
      ),
    ]),
    DocApi(
      'AstryxSearchQuery',
      <DocProp>[
        DocProp('text', 'String', 'The free text.', defaultValue: "''"),
        DocProp(
          'filters',
          'List<AstryxSearchFilter>',
          'The structured filters.',
          defaultValue: 'const <AstryxSearchFilter>[]',
        ),
        DocProp('isEmpty', 'bool', 'Whether there is nothing to search for.'),
      ],
      description: 'A search, as one value.',
    ),
    DocApi(
      'AstryxSearchFilter',
      <DocProp>[
        DocProp(
          'field',
          'String',
          'What is being filtered on.',
          required: true,
        ),
        DocProp('value', 'String', 'What it is filtered to.', required: true),
        DocProp(
          'label',
          'String?',
          'How to write it. Defaults to '
              '`field:value`.',
        ),
        DocProp('icon', 'AstryxIconName?', 'A glyph on the chip.'),
      ],
      description:
          'One applied filter. `AstryxSearchFilterOption` is the offer — a '
          'field, its label and the values it takes.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTokenChip](token) — the chips the filters are drawn as.',
      '[AstryxTypeahead](typeahead) — when the query is a lookup rather than a '
          'filter.',
      '[AstryxTable](table) — what a power search usually narrows.',
    ]),
  ],
);
