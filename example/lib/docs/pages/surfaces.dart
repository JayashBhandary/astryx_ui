import 'package:example/docs/model.dart';

/// Surfaces — the containers, and the labels that sit on them.
final List<DocPage> surfacePages = <DocPage>[_card, _badge, _banner];

const String _group = 'Surfaces';

final DocPage _card = DocPage(
  id: 'card',
  title: 'AstryxCard',
  group: _group,
  description:
      'A bordered surface with a header, a body and a footer — pressable when '
      'you give it something to do.',
  source: 'lib/src/components/surface/card.dart',
  upstream: 'Card / ClickableCard',
  blocks: <DocBlock>[
    const DocExample('card_demo'),
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
    const DocExample('card_slots'),
    const DocHeading('Variants'),
    const DocProse(
      'Three neutral fills. `transparent` is for grouping without visual '
      'weight — structure without claiming to be a distinct surface. Pair it '
      'with `showBorder: false`.',
    ),
    const DocExample('card_variants', align: DocExampleAlign.stretch),
    const DocProse(
      'Plus the nine categorical families, through '
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
    const DocExample('card_scrollable'),
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
    'One of the nine categorical families.',
  ),
];

final DocPage _badge = DocPage(
  id: 'badge',
  title: 'AstryxBadge',
  group: _group,
  description: 'A small label: a status, a count, a category.',
  source: 'lib/src/components/surface/badge.dart',
  upstream: 'Badge',
  blocks: <DocBlock>[
    const DocExample('badge_demo'),
    const DocHeading('Usage'),
    const DocCode(
      "const AstryxBadge('Healthy', variant: AstryxBadgeVariant.success)",
    ),
    const DocHeading('Variants'),
    const DocProse('Five semantic fills.'),
    const DocExample('badge_variants'),
    const DocProse('Plus the nine categorical families.'),
    const DocExample('badge_palettes'),
    const DocHeading('Icons'),
    const DocProse(
      'An icon before the text does two jobs: it reads faster, and it means '
      'the badge is not relying on colour alone.',
    ),
    const DocExample('badge_icons'),
    const DocHeading('Counts'),
    const DocProse(
      '"3" spoken aloud means nothing. `semanticsLabel` is what a screen '
      'reader hears instead of the bare number.',
    ),
    const DocExample('badge_counts'),
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
