import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Surfaces — the containers, and the labels that sit on them.
final List<DocPage> surfacePages = <DocPage>[
  _card,
  _selectableCard,
  _badge,
  _banner,
];

const String _group = DocGroup.surfaces;

final DocPage _card = DocPage(
  id: 'card',
  title: 'AstryxCard',
  group: _group,
  description:
      'A bordered surface with a header, a body and a footer — pressable when '
      'you give it something to do.',
  source: 'lib/src/components/surface/card.dart',
  upstream: 'Card / ClickableCard',
  upstreamPath: '/components/Card',
  blocks: <DocBlock>[
    const DocExample('card_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode("import 'package:astryx_ui/astryx_ui.dart';"),
    const DocCode('''
AstryxCard(
  header: const AstryxHeading('Usage', level: 4),
  footer: AstryxButton(label: 'See details', onPressed: open),
  child: const AstryxText('4,201 requests this month.'),
)'''),
    const DocHeading('Composition'),
    const DocProse(
      'Three slots, and one number governing all of them. `padding` is both '
      'the card’s inset *and* the gap between its slots, which is why a card’s '
      'internal rhythm cannot drift the way a hand-spaced column can.',
    ),
    const DocTree('''
AstryxCard
├── header    ← optional. A heading, a row, an image
├── child     ← the body. Required
└── footer    ← optional. Usually actions'''),
    const DocExample('card_slots', align: DocExampleAlign.start),
    const DocHeading('Variants'),
    const DocProse(
      'Three neutral fills. `transparent` is for grouping without visual '
      'weight — structure without claiming to be a distinct surface. Pair it '
      'with `showBorder: false`.',
    ),
    const DocExample('card_variants', align: DocExampleAlign.stretch),
    const DocProse(
      'Plus the ten categorical families, through '
      '`AstryxCardVariant.palette`.',
    ),
    const DocExample('card_palettes', align: DocExampleAlign.stretch),
    const DocCallout.warning(
      'The palettes are **categorical, not semantic**. Use them for "this '
      'belongs to the Red team", never for severity: a colour-blind user tells '
      'error from success by icon and position, not by hue. Severity belongs '
      'to [AstryxBanner](banner) and the `error`/`warning` tokens.',
    ),
    const DocHeading('Elevation'),
    const DocExample('card_elevation', align: DocExampleAlign.stretch),
    const DocHeading('Pressable'),
    const DocProse(
      'Upstream ships two widgets — `Card` and `ClickableCard`. This is one, '
      'because a nullable `onPressed` says the same thing with half the API, '
      'and that is how every other Flutter widget expresses the distinction.',
    ),
    const DocProse(
      'With `onPressed` set, the card gains hover and press states, a focus '
      'ring, `Semantics(button: true)` and tap-target enforcement. Without it '
      'the card is inert and contributes nothing to the semantics tree beyond '
      'its children.',
    ),
    const DocExample('card_pressable', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'Give a pressable card a `semanticsLabel`. Without one, a screen reader '
      'announces the card’s entire contents as the button’s name — which for a '
      'card with a heading, three lines of copy and a badge is a sentence '
      'nobody can act on.',
    ),
    const DocHeading('Scrolling'),
    const DocProse(
      'With a fixed `height`, `scrollable: true` scrolls the body only — the '
      'header and the footer stay put. Without a height the card grows '
      'instead, and `scrollable` does nothing.',
    ),
    const DocExample('card_scrollable', align: DocExampleAlign.start),
    const DocHeading('Width'),
    const DocProse(
      'A card fills a definite width and shrinks to fit an indefinite one — '
      'CSS’s own block-box rule. So a card in a `Row` or a horizontal list '
      'sizes to its content instead of asserting, and one in a column fills '
      'it.',
    ),
    const DocExample('card_unbounded', align: DocExampleAlign.stretch),
    DocApi('AstryxCard', _cardProps),
    DocApi(
      'AstryxCardVariant',
      _cardVariantProps,
      description:
          'Three neutral constants plus a palette constructor — thirteen fills '
          'in all, matching upstream’s `variantStyles` exactly.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxSelectableCard](selectable_card) — a card that records a choice '
          'rather than performing an action.',
      '[AstryxBanner](banner) — for a message with a severity.',
      '[AstryxGrid](grid) — for a wall of cards.',
      '[AstryxPopover](popover) — a floating surface rather than an inline '
          'one.',
    ]),
  ],
);

final List<DocProp> _cardProps = <DocProp>[
  const DocProp('child', 'Widget', 'The body.', required: true),
  const DocProp(
    'header',
    'Widget?',
    'Content above the body, separated by the card’s own padding.',
  ),
  const DocProp('footer', 'Widget?', 'Content below the body.'),
  const DocProp(
    'variant',
    'AstryxCardVariant',
    'The fill.',
    defaultValue: 'AstryxCardVariant.standard',
  ),
  const DocProp(
    'elevation',
    'AstryxElevation',
    'The resting shadow.',
    defaultValue: 'AstryxElevation.none',
  ),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inner padding, and the gap between slots.',
    defaultValue: 'AstryxSpacingToken.spacing4',
  ),
  const DocProp(
    'showBorder',
    'bool',
    'Whether to draw a hairline border.',
    defaultValue: 'true',
  ),
  const DocProp(
    'onPressed',
    'VoidCallback?',
    'Makes the whole card a button. Null leaves it inert.',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'The card’s accessible name when it is pressable.',
  ),
  const DocProp('width', 'double?', 'A fixed width. Null sizes to the parent.'),
  const DocProp('height', 'double?', 'A fixed height.'),
  const DocProp('maxWidth', 'double?', 'A ceiling on the width.'),
  const DocProp('minHeight', 'double?', 'A floor under the height.'),
  const DocProp(
    'focusNode',
    'FocusNode?',
    'The focus node. Only used when pressable.',
  ),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
  const DocProp(
    'scrollable',
    'bool',
    'Whether the body scrolls when it exceeds `height`.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _cardVariantProps = <DocProp>[
  const DocProp(
    'standard',
    'AstryxCardVariant',
    '`--color-background-card`. The default.',
  ),
  const DocProp(
    'muted',
    'AstryxCardVariant',
    '`--color-background-muted`, for a de-emphasised card.',
  ),
  const DocProp('transparent', 'AstryxCardVariant', 'No fill at all.'),
  const DocProp(
    'palette',
    'AstryxCardVariant.palette(AstryxPalette)',
    'One of the ten categorical families.',
  ),
];

final DocPage _selectableCard = DocPage(
  id: 'selectable_card',
  title: 'AstryxSelectableCard',
  group: _group,
  description:
      'A card that carries selection state — a card-shaped radio or checkbox.',
  source: 'lib/src/components/surface/selectable_card.dart',
  upstream: 'SelectableCard',
  upstreamPath: '/components/SelectableCard',
  blocks: <DocBlock>[
    const DocExample('selectable_card_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode("import 'package:astryx_ui/astryx_ui.dart';"),
    const DocCode('''
AstryxSelectableCard(
  label: 'Pro plan',
  control: AstryxSelectableCardControl.radio,
  selected: plan == Plan.pro,
  onSelectedChanged: (_) => setState(() => plan = Plan.pro),
  child: const AstryxText('Unlimited projects'),
)'''),
    const DocProse(
      'A [card](card) records nothing and a pressable one *does* something; '
      'this one *records* something. Reach for it when a choice needs more '
      'than a line of text — a plan with a price, a region with a latency, an '
      'integration with a logo. Below that the choice belongs in an '
      '[AstryxRadioList](radio_list) or an '
      '[AstryxCheckboxList](checkbox_list), which are cheaper to scan and '
      'cheaper to operate.',
    ),
    const DocHeading('Checkbox or radio'),
    const DocProse(
      '`control` is the same distinction as a [checkbox](checkbox) against a '
      '[radio group](radio_list), moved onto a card: a checkbox card is one of '
      'several independent choices, a radio card is one choice out of several. '
      'It changes the control that is drawn, what a screen reader is told, and '
      'what a second press does.',
    ),
    const DocTable(
      headers: <String>['Control', 'Announced as', 'Pressing it again'],
      rows: <List<String>>[
        <String>[
          '`checkbox`',
          'a checkbox, checked or not',
          'deselects it',
        ],
        <String>[
          '`radio`',
          'a radio, `inMutuallyExclusiveGroup`',
          '**reports nothing**',
        ],
      ],
    ),
    const DocProse(
      'A radio card reporting nothing is deliberate, and is what a native '
      'radio does: a choice out of several cannot be un-made by pressing it '
      'again, and reporting `false` would let a group end up with nothing '
      'selected.',
    ),
    const DocExample(
      'selectable_card_controls',
      align: DocExampleAlign.stretch,
    ),
    const DocHeading('Anatomy'),
    const DocTree('''
AstryxSelectableCard
├── control   ← a checkbox or a radio, at the reading-start edge
└── child     ← the content. Required, and arbitrary'''),
    const DocProse(
      'There is one slot, not the card’s three: a header above the control '
      'would put the choice’s title out of line with the thing that records '
      'it. Compose the inside with the stacks, as the examples do. `padding` '
      'is both the card’s inset and the gap between the control and the '
      'content, so the rhythm cannot drift.',
    ),
    const DocHeading('Selection'),
    const DocProse(
      'Selection shows three ways at once — the control fills, the border '
      'takes the accent, and the surface takes `--color-accent-muted`. A card '
      'is large enough that a user scanning for the selected one should not '
      'have to hunt for a small tick.',
    ),
    const DocProse(
      'The border and the tint are dropped when the card cannot be operated, '
      'because a tint that survives that reads as an affordance the card does '
      'not have — the same rule [AstryxCheckboxList](checkbox_list) applies to '
      'a checked row. The control still fills, so a card the user cannot '
      'change is still visibly the selected one.',
    ),
    const DocExample('selectable_card_states', align: DocExampleAlign.stretch),
    const DocTable(
      headers: <String>['State', 'Set by', 'Reads as'],
      rows: <List<String>>[
        <String>[
          'Interactive',
          '`onSelectedChanged` non-null, `enabled: true`',
          'hover, press, a focus ring, a tap target',
        ],
        <String>[
          'Inert',
          '`onSelectedChanged: null`',
          'not dimmed, still focusable and still announced, no tap action',
        ],
        <String>[
          'Disabled',
          '`enabled: false`',
          'dimmed, skipped by Tab, `enabled: false` announced',
        ],
      ],
    ),
    const DocHeading('Size'),
    const DocProse(
      '`controlSize` sizes the control, not the card: `AstryxToggleSize.sm` is '
      'a 20px box rather than 24px, the same two sizes the '
      '[checkbox](checkbox) comes in. With `padding` one step down it is what '
      'a card holding a single line wants, so the card is not mostly box.',
    ),
    const DocExample('selectable_card_compact', align: DocExampleAlign.start),
    const DocCallout.accessibility(
      '`label` is **required**, and is not painted. Without it a screen reader '
      'announces the card’s whole contents as the control’s name, which for a '
      'heading, a price and a badge is a sentence nobody can act on. The '
      'content keeps its own semantics nodes, so it is still read — after the '
      'user has been told what the card is. Put anything else it needs to hear '
      'in `semanticsHint`.',
    ),
    const DocCallout.note(
      'Each card is its own tab stop, unlike [AstryxRadioList](radio_list), '
      'which is one tab stop with arrow-key traversal. A set of cards is a set '
      'of separate controls — there is no shared `name` to group them the way '
      'a browser groups native radios — so Tab visits each one. That is the '
      'cost of the extra content; for four or more terse options, the radio '
      'list is the better control.',
    ),
    DocApi('AstryxSelectableCard', _selectableCardProps),
    DocApi(
      'AstryxSelectableCardControl',
      _selectableCardControlProps,
      description: 'Which control the card draws, and therefore what it means.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxCard](card) — the same surface, for content rather than a '
          'choice.',
      '[AstryxRadioList](radio_list) — one choice out of several, as rows.',
      '[AstryxCheckboxList](checkbox_list) — independent choices, as rows.',
    ]),
  ],
);

final List<DocProp> _selectableCardProps = <DocProp>[
  const DocProp(
    'child',
    'Widget',
    'The content beside the control.',
    required: true,
  ),
  const DocProp(
    'label',
    'String',
    'The accessible name. Required, and never painted.',
    required: true,
  ),
  const DocProp(
    'selected',
    'bool',
    'Whether the card is selected.',
    required: true,
  ),
  const DocProp(
    'onSelectedChanged',
    'ValueChanged<bool>?',
    'Called with the selection a press would produce. Null leaves the card '
        'inert without dimming it.',
  ),
  const DocProp(
    'control',
    'AstryxSelectableCardControl',
    'Whether the card behaves as a checkbox or as a radio.',
    defaultValue: 'AstryxSelectableCardControl.checkbox',
  ),
  const DocProp(
    'controlSize',
    'AstryxToggleSize',
    'The size of the control, not of the card.',
    defaultValue: 'AstryxToggleSize.md',
  ),
  const DocProp(
    'variant',
    'AstryxCardVariant',
    'The unselected fill. Selection overrides it.',
    defaultValue: 'AstryxCardVariant.standard',
  ),
  const DocProp(
    'elevation',
    'AstryxElevation',
    'The resting shadow.',
    defaultValue: 'AstryxElevation.none',
  ),
  const DocProp(
    'padding',
    'AstryxSpacingToken',
    'The inner padding, and the gap between the control and the content.',
    defaultValue: 'AstryxSpacingToken.spacing4',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the card accepts input.',
    defaultValue: 'true',
  ),
  const DocProp(
    'semanticsHint',
    'String?',
    'What a screen reader reads after the name — a price, a caveat, why the '
        'card is unavailable.',
  ),
  const DocProp('width', 'double?', 'A fixed width. Null sizes to the parent.'),
  const DocProp('maxWidth', 'double?', 'A ceiling on the width.'),
  const DocProp('minHeight', 'double?', 'A floor under the height.'),
  const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
];

final List<DocProp> _selectableCardControlProps = <DocProp>[
  const DocProp(
    'checkbox',
    'AstryxSelectableCardControl',
    'A checkbox. Any number of cards in the set may be selected, and pressing '
        'a selected card deselects it. The default.',
  ),
  const DocProp(
    'radio',
    'AstryxSelectableCardControl',
    'A radio. One card in the set is selected, and pressing it again reports '
        'nothing.',
  ),
];

final DocPage _badge = DocPage(
  id: 'badge',
  title: 'AstryxBadge',
  group: _group,
  description: 'A small label: a status, a count, a category.',
  source: 'lib/src/components/surface/badge.dart',
  upstream: 'Badge',
  upstreamPath: '/components/Badge',
  blocks: <DocBlock>[
    const DocExample('badge_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode(
      "const AstryxBadge('Healthy', variant: AstryxBadgeVariant.success)",
    ),
    const DocHeading('Variants'),
    const DocProse('Five semantic fills.'),
    const DocExample('badge_variants', align: DocExampleAlign.start),
    const DocProse('Plus the ten categorical families.'),
    const DocExample('badge_palettes', align: DocExampleAlign.start),
    const DocHeading('Icons'),
    const DocProse(
      'An icon before the text does two jobs: it reads faster, and it means '
      'the badge is not relying on colour alone.',
    ),
    const DocExample('badge_icons', align: DocExampleAlign.start),
    const DocHeading('Counts'),
    const DocProse(
      '"3" spoken aloud means nothing. `semanticsLabel` is what a screen '
      'reader hears instead of the bare number.',
    ),
    const DocExample('badge_counts', align: DocExampleAlign.start),
    const DocCallout.accessibility(
      'A badge is not a button. It has no press state, no focus and no tap '
      'target — if it needs to be pressable, it is a [button](button) or a '
      'pressable [card](card) with a badge inside it.',
    ),
    const DocCallout.note(
      'Upstream’s `stone` theme sets `--color-on-error` equal to '
      '`--color-error` — a 1.00:1 contrast failure reproduced faithfully here '
      'rather than corrected, and pinned by a test. An error badge is where '
      'that defect is most visible. Pick a different theme, or override the '
      'token.',
    ),
    DocApi('AstryxBadge', _badgeProps),
  ],
);

final List<DocProp> _badgeProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The text. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'variant',
    'AstryxBadgeVariant',
    'The colour: `neutral`, `info`, `success`, `warning`, `error`, or '
        '`AstryxBadgeVariant.palette(...)`.',
    defaultValue: 'AstryxBadgeVariant.neutral',
  ),
  const DocProp(
    'icon',
    'Widget?',
    'An icon before the text. Any widget; size and colour come from the badge.',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'Overrides what a screen reader announces.',
  ),
];

final DocPage _banner = DocPage(
  id: 'banner',
  title: 'AstryxBanner',
  group: _group,
  description: 'An inline message with a severity, announced when it appears.',
  source: 'lib/src/components/surface/banner.dart',
  upstream: 'Banner',
  upstreamPath: '/components/Banner',
  blocks: <DocBlock>[
    const DocExample('banner_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxBanner(
  status: AstryxBannerStatus.warning,
  title: 'Your trial ends in three days',
  description: 'Add a payment method to keep your projects running.',
)'''),
    const DocProse(
      'A banner is for a message tied to the page it sits on — a condition to '
      'resolve, a state to know about. For something transient and unrelated '
      'to the current view, use a [toast](toast).',
    ),
    const DocHeading('Statuses'),
    const DocProse(
      'Each status brings its own muted fill, its own icon, and its own '
      'urgency. **Only an error interrupts** a screen reader; a success banner '
      'that talks over what the user is doing has turned good news into an '
      'obstacle.',
    ),
    const DocExample('banner_statuses', align: DocExampleAlign.stretch),
    const DocTable(
      headers: <String>['Status', 'Announced', 'For'],
      rows: <List<String>>[
        <String>['`info`', 'politely', 'Neutral information.'],
        <String>['`warning`', 'politely', 'Worth attention, not blocking.'],
        <String>['`error`', '**assertively**', 'Something is wrong.'],
        <String>['`success`', 'politely', 'Confirmation.'],
      ],
    ),
    const DocHeading('Actions and dismissal'),
    const DocProse(
      'A null `onDismiss` means the banner cannot be dismissed — correct for a '
      'condition the user has to *resolve* rather than acknowledge.',
    ),
    const DocExample('banner_actions', align: DocExampleAlign.stretch),
    const DocHeading('Detail'),
    const DocProse(
      'Detail belongs in `content`, which sits on the card background below '
      'the header. The coloured area’s contrast tokens are tuned for one line '
      'of text, not for a paragraph or a list.',
    ),
    const DocExample('banner_content', align: DocExampleAlign.stretch),
    const DocTree('''
AstryxBanner
├── header      ← icon, title, description, actions, dismiss
│   ├── icon    ← from `status`, or your own
│   └── actions ← buttons at the trailing edge
└── content     ← optional detail, on the card background'''),
    const DocHeading('Icons'),
    const DocExample('banner_icon', align: DocExampleAlign.stretch),
    const DocCallout.accessibility(
      'Set `announce: false` for a banner that is part of the page’s initial '
      'state. A permanent notice at the top of a settings screen has nothing '
      'to announce, and announcing it on every visit is noise.',
    ),
    DocApi('AstryxBanner', _bannerProps),
  ],
);

final List<DocProp> _bannerProps = <DocProp>[
  const DocProp(
    'title',
    'String',
    'The headline. Short and specific.',
    required: true,
  ),
  const DocProp(
    'status',
    'AstryxBannerStatus',
    'The sentiment, which sets the fill, the icon and the urgency.',
    defaultValue: 'AstryxBannerStatus.info',
  ),
  const DocProp(
    'description',
    'String?',
    'Supporting text below the title.',
  ),
  const DocProp(
    'actions',
    'List<Widget>',
    'Buttons at the trailing edge of the header.',
    defaultValue: 'const <Widget>[]',
  ),
  const DocProp(
    'onDismiss',
    'VoidCallback?',
    'Shows a dismiss button that calls this. Null means it cannot be '
        'dismissed.',
  ),
  const DocProp(
    'icon',
    'Widget?',
    'Overrides the status’s default icon.',
  ),
  const DocProp(
    'showIcon',
    'bool',
    'Whether to show an icon at all.',
    defaultValue: 'true',
  ),
  const DocProp(
    'content',
    'Widget?',
    'Extra content below the header, on the card background.',
  ),
  const DocProp(
    'announce',
    'bool',
    'Whether to announce the banner when it appears or its text changes.',
    defaultValue: 'true',
  ),
];
