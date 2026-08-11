import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Data display — the row, the lists, and the state a list has when it is
/// empty.
final List<DocPage> listPages = <DocPage>[
  _item,
  _list,
  _treeList,
  _overflowList,
  _metadataList,
  _emptyState,
  _code,
  _codeBlock,
  _blockquote,
  _kbd,
];

const String _group = DocGroup.dataDisplay;

// -----------------------------------------------------------------------------
// AstryxItem
// -----------------------------------------------------------------------------

final DocPage _item = DocPage(
  id: 'item',
  title: 'AstryxItem',
  group: _group,
  description:
      'The row the lists are built from — something at the start, a label, and '
      'something at the end.',
  source: 'lib/src/components/data/item.dart',
  upstream: 'Item',
  upstreamPath: '/components/Item',
  blocks: <DocBlock>[
    const DocExample('item_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode("import 'package:astryx_ui/astryx_ui.dart';"),
    const DocCode('''
AstryxItem(
  leading: const AstryxIcon(AstryxIconName.check),
  label: 'ada@example.com',
  description: 'Owner',
  trailing: const AstryxBadge('Active'),
  onPressed: open,
)'''),
    const DocHeading('Anatomy'),
    const DocTree('''
AstryxItem
├── leading      ← optional. An icon, an avatar, a checkbox
├── label        ← required. Also the accessible name
│   └── description ← optional, under the label
└── trailing     ← optional. A badge, a count, a chevron'''),
    const DocProse(
      'One line each by default. `maxLines: null` lets them wrap, but a list '
      'whose rows wrap has stopped being scannable, which is most of what a '
      'list is for.',
    ),
    const DocHeading('Pressable, selected, disabled'),
    const DocProse(
      'A non-null `onPressed` makes the row a button — the same rule '
      '[AstryxCard](card) follows, for the same reason. `selected` is not a '
      'press state: it survives the pointer leaving, and is what marks the row '
      'a list is currently showing.',
    ),
    const DocExample('item_states', align: DocExampleAlign.stretch),
    const DocTable(
      headers: <String>['State', 'Set by', 'Reads as'],
      rows: <List<String>>[
        <String>[
          'Pressable',
          '`onPressed` non-null',
          'a button: hover, press, a focus ring, a tap target',
        ],
        <String>[
          'Selected',
          '`selected: true`',
          'tinted, and announced `selected`',
        ],
        <String>[
          'Inert',
          '`onPressed: null`',
          'a plain row, contributing nothing of its own to semantics',
        ],
        <String>[
          'Disabled',
          '`enabled: false`',
          'dimmed, still announced as a button, no tap action',
        ],
      ],
    ),
    const DocCallout.accessibility(
      'A disabled row stays in the semantics tree. A control that vanishes '
      'when it is disabled tells a screen-reader user the option does not '
      'exist, rather than that it is unavailable — which are different facts.',
    ),
    const DocHeading('Density'),
    const DocProse(
      'A row inside an [AstryxList](list) takes the list’s density, so no row '
      'repeats it and no row can disagree with its neighbours by accident. '
      '`density` on the row itself overrides that.',
    ),
    DocApi('AstryxItem', _itemProps),
    DocApi(
      'AstryxItemDensity',
      _densityProps,
      description:
          'The same two names `AstryxCheckboxList` uses, because they mean the '
          'same thing.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxList](list) — stacks rows with dividers and one density.',
      '[AstryxTreeList](tree_list) — the same row, nested.',
      '[AstryxDropdownMenu](dropdown_menu) — rows in a menu, which carry their '
          'own highlight and submenu state and so are drawn by the menu.',
    ]),
  ],
);

final List<DocProp> _itemProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The visible text, and the row’s accessible name.',
    required: true,
  ),
  const DocProp('leading', 'Widget?', 'Content at the reading-start edge.'),
  const DocProp('description', 'String?', 'Secondary text below the label.'),
  const DocProp('trailing', 'Widget?', 'Content at the reading-end edge.'),
  const DocProp(
    'onPressed',
    'VoidCallback?',
    'Makes the whole row a button. Null leaves it inert.',
  ),
  const DocProp(
    'selected',
    'bool',
    'Whether the row is the chosen one, which tints it.',
    defaultValue: 'false',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the row accepts input.',
    defaultValue: 'true',
  ),
  const DocProp(
    'density',
    'AstryxItemDensity?',
    'Overrides the density inherited from the enclosing list.',
  ),
  const DocProp(
    'maxLines',
    'int?',
    'How many lines the label and description may each take. Null lets them '
        'wrap freely.',
    defaultValue: '1',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'Overrides what a screen reader announces instead of `label`.',
  ),
  const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _densityProps = <DocProp>[
  const DocProp(
    'compact',
    'AstryxItemDensity',
    'Tight rows, for a long list in a dense screen.',
  ),
  const DocProp('balanced', 'AstryxItemDensity', 'The default.'),
];

// -----------------------------------------------------------------------------
// AstryxList
// -----------------------------------------------------------------------------

final DocPage _list = DocPage(
  id: 'list',
  title: 'AstryxList',
  group: _group,
  description:
      'A vertical list of rows, with the separators and density the design '
      'system expects.',
  source: 'lib/src/components/data/list.dart',
  upstream: 'List / ListItem',
  upstreamPath: '/components/List',
  blocks: <DocBlock>[
    const DocExample('list_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxList(
  label: 'Team',
  children: <Widget>[
    AstryxItem(label: 'Ada Lovelace', description: 'Owner'),
    AstryxItem(label: 'Alan Turing', description: 'Admin'),
  ],
)'''),
    const DocProse(
      'Upstream ships `List` and `ListItem`. The item here is '
      '[AstryxItem](item), which is also usable on its own, so this widget is '
      'only the container: the dividers, the density every row inherits, and '
      'the name a screen reader reads before the first row.',
    ),
    const DocCallout.warning(
      '**It does not scroll and does not virtualise.** A list is a `Column`, '
      'so a long one belongs inside the page’s scroll view, and a very long '
      'one belongs in a paginated [AstryxTable](table) instead — the same '
      'limit the table carries, for the same reason.',
    ),
    const DocHeading('Dividers and density'),
    const DocProse(
      'Rules are for rows that would otherwise run together — two lines of '
      'text each. A list of one-line rows reads better spaced than ruled, '
      'which is why `showDividers` is off by default.',
    ),
    const DocExample('list_density', align: DocExampleAlign.stretch),
    const DocHeading('Nothing to show'),
    const DocProse(
      'A list with no rows renders nothing at all, which reads as a bug. '
      '`empty` is where an [AstryxEmptyState](empty_state) goes.',
    ),
    const DocExample('list_empty', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'The list announces itself as a list, and each row as one of its items, '
      'so a screen reader can say "list, 3 items" before reading the first. '
      'Give it a `label`: "list, 3 items" is a start, "Recent deploys, list, 3 '
      'items" is an answer.',
    ),
    DocApi('AstryxList', _listProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxItem](item) — the row.',
      '[AstryxTreeList](tree_list) — when the rows nest.',
      '[AstryxTable](table) — when the rows have columns.',
    ]),
  ],
);

final List<DocProp> _listProps = <DocProp>[
  const DocProp(
    'children',
    'List<Widget>',
    'The rows, in order. Usually `AstryxItem`s.',
    required: true,
  ),
  const DocProp(
    'label',
    'String?',
    'The list’s accessible name, announced before the first row.',
  ),
  const DocProp(
    'density',
    'AstryxItemDensity',
    'The vertical rhythm every row inherits.',
    defaultValue: 'AstryxItemDensity.balanced',
  ),
  const DocProp(
    'showDividers',
    'bool',
    'Whether to draw a rule between rows.',
    defaultValue: 'false',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken?',
    'Overrides the space between rows. Defaults to nothing when dividers are '
        'drawn: a rule and a gap doing the same job is one too many.',
  ),
  const DocProp(
    'empty',
    'Widget?',
    'What to show when `children` is empty. Null renders nothing.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxTreeList
// -----------------------------------------------------------------------------

final DocPage _treeList = DocPage(
  id: 'tree_list',
  title: 'AstryxTreeList',
  group: _group,
  description: 'A list of nested, expandable rows.',
  source: 'lib/src/components/data/tree_list.dart',
  upstream: 'TreeList',
  upstreamPath: '/components/TreeList',
  blocks: <DocBlock>[
    const DocExample('tree_list_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxTreeList(
  label: 'Files',
  selected: selectedId,
  onSelectedChanged: (id) => setState(() => selectedId = id),
  nodes: const <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'lib',
      label: 'lib',
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'main', label: 'main.dart'),
      ],
    ),
  ],
)'''),
    const DocProse(
      'A node’s identity is its `id`, and expansion and selection are carried '
      'as ids rather than as flags on the node. A caller rebuilding the tree '
      'from fresh data therefore does not lose which branches were open — the '
      'usual failure of a tree that stores its state in its own nodes.',
    ),
    const DocHeading('Keyboard'),
    const DocProse(
      '**The whole tree is one tab stop**, and the arrows move inside it. A '
      'tree whose every row were its own tab stop would take forty presses to '
      'walk past, which is why the ARIA tree pattern exists and why it is '
      'built by hand here.',
    ),
    const DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Down` / `Up`', 'Moves to the next or previous visible row.'],
        <String>[
          '`Right`',
          'Opens a closed branch; steps into an open one. Mirrored under RTL.',
        ],
        <String>[
          '`Left`',
          'Closes an open branch; steps out to the parent. Mirrored under RTL.',
        ],
        <String>['`Home` / `End`', 'The first and last visible rows.'],
        <String>['`Enter` / `Space`', 'Presses the row.'],
        <String>['`Tab`', 'Leaves the tree entirely.'],
      ],
    ),
    const DocProse(
      'The arrows do not wrap, unlike [AstryxRadioList](radio_list): a tree is '
      'a hierarchy, and jumping from the last leaf back to the first root '
      'loses the reader’s place.',
    ),
    const DocHeading('Pressing a row'),
    const DocProse(
      'A leaf is chosen. A branch is opened or closed **and** chosen — a tree '
      'where clicking a folder does not select it is a tree where the folder '
      'can never be the answer.',
    ),
    const DocHeading('Who owns the open branches'),
    const DocProse(
      'Either you or the widget. Pass `expanded` and `onExpandedChanged` to '
      'drive it — which is what lets a button outside the tree expand all of '
      'it — or leave `expanded` null and let the tree keep its own set, seeded '
      'from `initiallyExpanded`. Selection is always yours, as it is on '
      '[AstryxRadioList](radio_list).',
    ),
    const DocExample('tree_list_controlled', align: DocExampleAlign.stretch),
    const DocCallout.note(
      'A closed branch builds none of its children, so a tree of a thousand '
      'nodes costs only what is open. What *is* open is built in full — this '
      'is a `Column`, like [AstryxList](list), and does not virtualise.',
    ),
    DocApi('AstryxTreeList', _treeProps),
    DocApi('AstryxTreeNode', _treeNodeProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxList](list) — when the rows do not nest.',
      '[AstryxCollapsible](collapsible) — one section that opens, rather than '
          'a tree of them.',
    ]),
  ],
);

final List<DocProp> _treeProps = <DocProp>[
  const DocProp(
    'nodes',
    'List<AstryxTreeNode>',
    'The roots, in order.',
    required: true,
  ),
  const DocProp(
    'expanded',
    'Set<String>?',
    'The ids of the open branches. Null keeps the set inside the widget.',
  ),
  const DocProp(
    'initiallyExpanded',
    'Set<String>',
    'The branches open on the first build. Ignored when `expanded` is set.',
    defaultValue: 'const <String>{}',
  ),
  const DocProp(
    'onExpandedChanged',
    'ValueChanged<Set<String>>?',
    'Called with the whole new set whenever a branch opens or closes.',
  ),
  const DocProp('selected', 'String?', 'The id of the chosen row.'),
  const DocProp(
    'onSelectedChanged',
    'ValueChanged<String>?',
    'Called with the id of the row the user chose. Null makes the tree '
        'read-only: it still expands and still traverses.',
  ),
  const DocProp('label', 'String?', 'The tree’s accessible name.'),
  const DocProp(
    'density',
    'AstryxItemDensity',
    'The vertical rhythm every row takes.',
    defaultValue: 'AstryxItemDensity.balanced',
  ),
  const DocProp('focusNode', 'FocusNode?', 'The focus node for the tree.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _treeNodeProps = <DocProp>[
  const DocProp(
    'id',
    'String',
    'This node’s identity, unique across the whole tree.',
    required: true,
  ),
  const DocProp(
    'label',
    'String',
    'The visible text, and this row’s accessible name.',
    required: true,
  ),
  const DocProp(
    'children',
    'List<AstryxTreeNode>',
    'The nodes under this one. A non-empty list makes the row expandable.',
    defaultValue: 'const <AstryxTreeNode>[]',
  ),
  const DocProp(
    'leading',
    'Widget?',
    'Content between the chevron and the label.',
  ),
  const DocProp('description', 'String?', 'Secondary text below the label.'),
  const DocProp('trailing', 'Widget?', 'Content at the reading-end edge.'),
  const DocProp(
    'enabled',
    'bool',
    'Whether this row can be chosen or opened.',
    defaultValue: 'true',
  ),
];

// -----------------------------------------------------------------------------
// AstryxOverflowList
// -----------------------------------------------------------------------------

final DocPage _overflowList = DocPage(
  id: 'overflow_list',
  title: 'AstryxOverflowList',
  group: _group,
  description:
      'A row of items that measures itself and moves the tail into a menu.',
  source: 'lib/src/components/data/overflow_list.dart',
  upstream: 'OverflowList',
  upstreamPath: '/components/OverflowList',
  blocks: <DocBlock>[
    const DocExample('overflow_list_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxOverflowList(
  items: <AstryxOverflowItem>[
    for (final tag in tags)
      AstryxOverflowItem(
        label: tag,
        child: AstryxBadge(tag),
        onSelected: () => open(tag),
      ),
  ],
)'''),
    const DocProse(
      'For a toolbar, a breadcrumb trail, a row of tags — anywhere the number '
      'of items is not known in advance and wrapping onto a second line would '
      'break the layout around it.',
    ),
    const DocHeading('Two representations of one item'),
    const DocProse(
      'An item carries both a `child`, drawn while it fits, and a `label`, '
      'which names it in the menu once it does not. A widget cannot be turned '
      'into a menu row automatically — and asking for both is also the only '
      'way the menu row can be a real, operable row rather than a picture of '
      'one.',
    ),
    const DocExample('overflow_list_widths', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      '**Nothing is hidden that a user cannot get to.** What falls off the end '
      'becomes a row in a real [AstryxDropdownMenu](dropdown_menu), reachable '
      'by pointer, keyboard and screen reader alike — and the items it stands '
      'in for leave the semantics tree, so nobody hears the same list twice. '
      'That is the difference between this and clipping the row.',
    ),
    const DocHeading('How it settles'),
    const DocProse(
      'The trigger’s width depends on the count it shows, and the count '
      'depends on how many items fit, which depends on the trigger’s width. '
      'The circle only ever turns one way — a wider label hides more items, '
      'and hiding more items never narrows the label — so the row reaches its '
      'answer within a frame or two of any resize and holds it. In a test, '
      '`pumpAndSettle` is enough.',
    ),
    DocApi('AstryxOverflowList', _overflowProps),
    DocApi('AstryxOverflowItem', _overflowItemProps),
  ],
);

final List<DocProp> _overflowProps = <DocProp>[
  const DocProp(
    'items',
    'List<AstryxOverflowItem>',
    'The items, in order. The tail is what overflows.',
    required: true,
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken',
    'The space between items, and before the trigger.',
    defaultValue: 'AstryxSpacingToken.spacing2',
  ),
  const DocProp(
    'menuLabel',
    'String?',
    'An accessible name for the overflow menu.',
  ),
  const DocProp(
    'minVisible',
    'int',
    'How many items stay on the row however narrow it gets.',
    defaultValue: '1',
  ),
];

final List<DocProp> _overflowItemProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The item’s name, used for its menu row.',
    required: true,
  ),
  const DocProp(
    'child',
    'Widget',
    'What is drawn on the row while the item fits.',
    required: true,
  ),
  const DocProp(
    'onSelected',
    'VoidCallback?',
    'Called when the item is chosen from the menu. Null makes the menu row '
        'inert — right for a tag rather than an action.',
  ),
  const DocProp('icon', 'Widget?', 'An icon before the label in the menu.'),
  const DocProp(
    'enabled',
    'bool',
    'Whether the menu row can be chosen.',
    defaultValue: 'true',
  ),
];

// -----------------------------------------------------------------------------
// AstryxMetadataList
// -----------------------------------------------------------------------------

final DocPage _metadataList = DocPage(
  id: 'metadata_list',
  title: 'AstryxMetadataList',
  group: _group,
  description: 'Label-and-value pairs, for the details panel of a record.',
  source: 'lib/src/components/data/metadata_list.dart',
  upstream: 'MetadataList / MetadataListItem',
  upstreamPath: '/components/MetadataList',
  blocks: <DocBlock>[
    const DocExample('metadata_list_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxMetadataList(
  items: <AstryxMetadataItem>[
    AstryxMetadataItem.text(label: 'Owner', value: 'Ada Lovelace'),
    AstryxMetadataItem(label: 'Status', value: const AstryxBadge('Live')),
  ],
)'''),
    const DocProse(
      'For facts about **one** thing. For rows *of* things use '
      '[AstryxList](list), and for many things sharing the same fields use '
      '[AstryxTable](table).',
    ),
    const DocHeading('Stacked or inline'),
    const DocProse(
      'Inline reads faster when the values are short and there are many of '
      'them; stacked survives a narrow column, which inline does not.',
    ),
    const DocExample('metadata_list_inline', align: DocExampleAlign.stretch),
    const DocProse(
      '`labelWidth` is a number rather than "as wide as the widest label", '
      'which CSS grid does for free and Flutter would pay for by laying every '
      'label out twice — the same trade [AstryxFormLayout](form_layout) makes.',
    ),
    const DocCallout.accessibility(
      'A pair is one semantics node, so a screen reader reads "Owner, Ada '
      'Lovelace" rather than stopping between the two halves of one fact. Set '
      '`semanticsValue` whenever the value is not plain text: a badge '
      'announces its own contents, and "green dot, Healthy" has one word of '
      'information in it.',
    ),
    DocApi('AstryxMetadataList', _metadataProps),
    DocApi('AstryxMetadataItem', _metadataItemProps),
  ],
);

final List<DocProp> _metadataProps = <DocProp>[
  const DocProp(
    'items',
    'List<AstryxMetadataItem>',
    'The pairs, in order.',
    required: true,
  ),
  const DocProp(
    'direction',
    'AstryxMetadataListDirection',
    'Whether a label sits above its value (`stacked`) or beside it '
        '(`inline`).',
    defaultValue: 'AstryxMetadataListDirection.stacked',
  ),
  const DocProp(
    'labelWidth',
    'double',
    'The width of the label column when inline.',
    defaultValue: '140',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken',
    'The space between pairs.',
    defaultValue: 'AstryxSpacingToken.spacing3',
  ),
];

final List<DocProp> _metadataItemProps = <DocProp>[
  const DocProp('label', 'String', 'What the value is.', required: true),
  const DocProp(
    'value',
    'Widget',
    'The value itself. `AstryxMetadataItem.text` builds it from a string and '
        'sets the announcement to match.',
    required: true,
  ),
  const DocProp('icon', 'Widget?', 'An icon before the label.'),
  const DocProp(
    'semanticsValue',
    'String?',
    'What a screen reader reads as the value. Required in practice whenever '
        '`value` is not plain text.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxEmptyState
// -----------------------------------------------------------------------------

final DocPage _emptyState = DocPage(
  id: 'empty_state',
  title: 'AstryxEmptyState',
  group: _group,
  description: 'What a list, table or panel shows when it has nothing to show.',
  source: 'lib/src/components/data/empty_state.dart',
  upstream: 'EmptyState',
  upstreamPath: '/components/EmptyState',
  blocks: <DocBlock>[
    const DocExample('empty_state_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxEmptyState(
  icon: const AstryxIcon(AstryxIconName.search),
  title: 'No matching deploys',
  description: 'Try a wider date range.',
  actions: <Widget>[AstryxButton(label: 'Clear filters', onPressed: clear)],
)'''),
    const DocCallout.warning(
      '**An empty state is not an error.** Nothing has gone wrong when a new '
      'project has no deploys, so this does not announce itself, take a status '
      'colour, or borrow [AstryxBanner](banner)’s urgency. What it carries '
      'instead is the one action that ends the emptiness — the difference '
      'between "No results" and a screen a user can leave.',
    ),
    const DocHeading('Sizes'),
    const DocProse(
      '`compact` is for an empty state inside something — a card, a popover, a '
      'table body — where the standard one would push the container open.',
    ),
    const DocExample('empty_state_sizes', align: DocExampleAlign.stretch),
    const DocHeading('Where it goes'),
    const DocList(<String>[
      '[AstryxList](list) — as `empty`.',
      '[AstryxTable](table) — which shows its own "No data" when it has no '
          'rows.',
      'A page, when a whole screen has nothing on it yet.',
    ]),
    const DocCallout.accessibility(
      'The title is a level-3 heading: an empty state stands in for content, '
      'so it belongs in the outline where that content would have been. The '
      'icon is decorative and stays out of the semantics tree — the title '
      'carries the meaning.',
    ),
    DocApi('AstryxEmptyState', _emptyProps),
    DocApi('AstryxEmptyStateSize', _emptySizeProps),
  ],
);

final List<DocProp> _emptyProps = <DocProp>[
  const DocProp(
    'title',
    'String',
    'What is missing, in a few words.',
    required: true,
  ),
  const DocProp(
    'description',
    'String?',
    'A line under the title, saying why, or what would fill it.',
  ),
  const DocProp('icon', 'Widget?', 'A decorative icon above the title.'),
  const DocProp(
    'actions',
    'List<Widget>',
    'The way out: one action, or two at most.',
    defaultValue: 'const <Widget>[]',
  ),
  const DocProp(
    'size',
    'AstryxEmptyStateSize',
    'How much room the block takes.',
    defaultValue: 'AstryxEmptyStateSize.standard',
  ),
  const DocProp(
    'minHeight',
    'double?',
    'A floor under the height, so a list’s height does not jump when rows '
        'arrive.',
  ),
  const DocProp(
    'maxWidth',
    'double',
    'A ceiling on the text’s width, so the description stays readable.',
    defaultValue: '380',
  ),
];

final List<DocProp> _emptySizeProps = <DocProp>[
  const DocProp(
    'compact',
    'AstryxEmptyStateSize',
    'For an empty state inside a card, a popover or a table body.',
  ),
  const DocProp(
    'standard',
    'AstryxEmptyStateSize',
    'The default, for an empty page or a full-width panel.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxCode
// -----------------------------------------------------------------------------

final DocPage _code = DocPage(
  id: 'code',
  title: 'AstryxCode',
  group: _group,
  description: 'Inline monospace, for a symbol or a value inside a sentence.',
  source: 'lib/src/components/data/code.dart',
  upstream: 'Code',
  upstreamPath: '/components/Code',
  blocks: <DocBlock>[
    const DocExample('code_demo'),
    const DocHeading('Usage'),
    const DocCode("const AstryxCode('AstryxSpacingToken.spacing4')"),
    const DocProse(
      'For the things that are wrong when they are re-typed with a capital '
      'letter in the wrong place: a class name, a flag, an environment '
      'variable, a token.',
    ),
    const DocHeading('Inside a sentence'),
    const DocProse(
      'Flutter has no inline element, so a widget cannot simply sit inside a '
      'string — the one place this port cannot follow upstream’s shape. '
      '`AstryxCode.span` is the bridge: a `WidgetSpan`, aligned to the middle '
      'of the line rather than the baseline, because the chip has padding of '
      'its own.',
    ),
    const DocExample('code_span', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'Set `semanticsLabel` for a string that is unreadable aloud — a hex '
      'colour, a token with no spaces in it. What a screen reader makes of '
      '`#0064E0` is noise, and "hex 0064E0" is not.',
    ),
    DocApi('AstryxCode', _codeProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxCodeBlock](code_block) — more than a phrase of it.',
      '[AstryxKbd](kbd) — a key, not a symbol. `Ctrl` is not code.',
    ]),
  ],
);

final List<DocProp> _codeProps = <DocProp>[
  const DocProp(
    'data',
    'String',
    'The code. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'Overrides what a screen reader announces.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxCodeBlock
// -----------------------------------------------------------------------------

final DocPage _codeBlock = DocPage(
  id: 'code_block',
  title: 'AstryxCodeBlock',
  group: _group,
  description:
      'A fenced block of code, with the language, copy control and optional '
      'line numbers.',
  source: 'lib/src/components/data/code.dart',
  upstream: 'CodeBlock',
  upstreamPath: '/components/CodeBlock',
  blocks: <DocBlock>[
    const DocExample('code_block_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxCodeBlock(
  'flutter pub add astryx_ui',
  language: 'bash',
)'''),
    const DocCallout.warning(
      '**Nothing is highlighted.** Upstream colours its blocks with a '
      'JavaScript tokeniser that has no counterpart here, and a half-right '
      'highlighter is worse than none: code coloured by a grammar that does '
      'not match the language is code that lies about what it means. '
      '`language` is a label the reader sees, not an instruction.',
    ),
    const DocHeading('Copying'),
    const DocProse(
      'The copy button carries the **whole** string, including the lines '
      'scrolled out of sight — which is the difference between a copy button '
      'and a selection. It reports back in place, by becoming a tick for two '
      'seconds, rather than raising a [toast](toast): a page of ten blocks '
      'that shouts once per copy is a page nobody reads.',
    ),
    const DocHeading('Line numbers and long lines'),
    const DocProse(
      'A long line scrolls sideways rather than wrapping, because in code a '
      'line break is not a neutral event and the indentation a reader follows '
      'is destroyed by one. `wrap: true` where the code matters less than the '
      'layout around it.',
    ),
    const DocExample('code_block_numbers', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'The line numbers are decoration: they are not copied with the code and '
      'not read aloud, because "1 2 3 4" is not the program.',
    ),
    DocApi('AstryxCodeBlock', _codeBlockProps),
  ],
);

final List<DocProp> _codeBlockProps = <DocProp>[
  const DocProp(
    'code',
    'String',
    'The code, newline-separated. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'language',
    'String?',
    'The language, shown in the header. A label, not a highlighting '
        'instruction.',
  ),
  const DocProp(
    'showLineNumbers',
    'bool',
    'Whether to number the lines.',
    defaultValue: 'false',
  ),
  const DocProp(
    'showCopy',
    'bool',
    'Whether to offer a copy button.',
    defaultValue: 'true',
  ),
  const DocProp(
    'wrap',
    'bool',
    'Whether long lines wrap instead of scrolling sideways.',
    defaultValue: 'false',
  ),
  const DocProp(
    'maxHeight',
    'double?',
    'The tallest the block may be before it scrolls.',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'What a screen reader announces instead of the code.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxBlockquote
// -----------------------------------------------------------------------------

final DocPage _blockquote = DocPage(
  id: 'blockquote',
  title: 'AstryxBlockquote',
  group: _group,
  description: 'A quotation set apart from the surrounding prose.',
  source: 'lib/src/components/data/blockquote.dart',
  upstream: 'Blockquote',
  upstreamPath: '/components/Blockquote',
  blocks: <DocBlock>[
    const DocExample('blockquote_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxBlockquote(
  'The deploy took eleven minutes and nobody could tell why.',
  attribution: 'Postmortem, 3 March',
)'''),
    const DocProse(
      'For **someone else’s words**: a customer’s complaint in a case study, a '
      'line from a spec, the sentence an incident report turns on. Not for '
      'emphasis — a paragraph of your own set in a quote is a paragraph '
      'pretending to have a source. For a message the page itself is making, '
      'use [AstryxBanner](banner).',
    ),
    const DocProse(
      'The em dash before the attribution is the widget’s, not yours.',
    ),
    const DocHeading('Longer quotations'),
    const DocProse(
      'A long quotation is not always one paragraph of plain text, and a '
      'blockquote that cannot hold the rest is one people work around. `child` '
      'takes anything.',
    ),
    const DocExample('blockquote_child', align: DocExampleAlign.stretch),
    DocApi('AstryxBlockquote', _blockquoteProps),
  ],
);

final List<DocProp> _blockquoteProps = <DocProp>[
  const DocProp(
    'quote',
    'String',
    'The quoted text. The positional first argument, and empty when `child` '
        'carries the quotation instead.',
    required: true,
  ),
  const DocProp(
    'attribution',
    'String?',
    'Who or what is being quoted, shown under it.',
  ),
  const DocProp(
    'child',
    'Widget?',
    'Replaces `quote` with arbitrary content — a list, a table, code.',
  ),
];

// -----------------------------------------------------------------------------
// AstryxKbd
// -----------------------------------------------------------------------------

final DocPage _kbd = DocPage(
  id: 'kbd',
  title: 'AstryxKbd',
  group: _group,
  description: 'A keyboard key or chord, rendered as a key.',
  source: 'lib/src/components/data/kbd.dart',
  upstream: 'Kbd',
  upstreamPath: '/components/Kbd',
  blocks: <DocBlock>[
    const DocExample('kbd_demo'),
    const DocHeading('Usage'),
    const DocCode('''
AstryxKbd('K')
const AstryxKbd.chord(<String>['Ctrl', 'K'])'''),
    const DocProse(
      'Two constructors because a single key is the common case and '
      "`AstryxKbd(<String>['K'])` is a list nobody wants to type.",
    ),
    const DocCallout.note(
      '**The glyphs are yours.** This does not translate `Ctrl` to `⌘` on a '
      'Mac, because only the caller knows whether the shortcut is the '
      'platform’s or the product’s own — and a key cap showing the wrong '
      'modifier is worse than one showing a name.',
    ),
    const DocHeading('Beside what it does'),
    const DocProse(
      'Where a key cap usually belongs: at the trailing edge of the row whose '
      'action it triggers.',
    ),
    const DocExample('kbd_in_context', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'A chord is one semantics node, not one per cap. Set `semanticsLabel` '
      'whenever the caps are symbols: `⌘ ⇧ P` read out as a string of glyphs '
      'is not a shortcut anyone can follow.',
    ),
    DocApi('AstryxKbd', _kbdProps),
    DocApi('AstryxKbdSize', _kbdSizeProps),
  ],
);

final List<DocProp> _kbdProps = <DocProp>[
  const DocProp(
    'keys',
    'List<String>',
    'The keys, in the order they are shown. The positional argument of '
        '`AstryxKbd.chord`; the default constructor takes one `String`.',
    required: true,
  ),
  const DocProp(
    'size',
    'AstryxKbdSize',
    'How large the caps are drawn.',
    defaultValue: 'AstryxKbdSize.md',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'What a screen reader announces. Defaults to the keys, space-separated.',
  ),
];

final List<DocProp> _kbdSizeProps = <DocProp>[
  const DocProp(
    'sm',
    'AstryxKbdSize',
    'Beside `supporting` text — a hint in a menu row, a footnote.',
  ),
  const DocProp('md', 'AstryxKbdSize', 'The default, beside `body` text.'),
];
