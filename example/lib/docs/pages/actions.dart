import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// The action components: the two buttons and the group that joins them.
final List<DocPage> actionPages = <DocPage>[
  _button,
  _iconButton,
  _buttonGroup,
];

const String _group = DocGroup.actions;

final DocPage _button = DocPage(
  id: 'button',
  title: 'AstryxButton',
  group: _group,
  description: 'A labelled action, in four levels of prominence.',
  source: 'lib/src/components/action/button.dart',
  upstream: 'Button',
  upstreamPath: '/components/Button',
  blocks: <DocBlock>[
    const DocExample('button_demo'),
    const DocHeading('Usage'),
    const DocCode(
      "import 'package:astryx_ui/astryx_ui.dart';",
    ),
    const DocCode('''
AstryxButton(
  label: 'Save changes',
  variant: AstryxButtonVariant.primary,
  onPressed: () => save(),
)'''),
    const DocProse(
      'A button is *always* labelled. There is no `child` slot, because a '
      'button whose content is arbitrary is a button whose accessible name is '
      'a guess — and `label` is both the visible text and that name. For an '
      'action with no room for words, use [AstryxIconButton](icon_button), '
      'which requires a label anyway and simply does not paint it.',
    ),
    const DocHeading('Variants'),
    const DocProse(
      'Prominence, not colour: pick the one that matches how important the '
      'action is, and let the theme decide what that looks like.',
    ),
    const DocExample('button_variants'),
    const DocTable(
      headers: <String>['Variant', 'For'],
      rows: <List<String>>[
        <String>[
          '`primary`',
          'The single most important action in a view. Filled with the accent.',
        ],
        <String>[
          '`secondary`',
          'The default. Reads as an action without competing with `primary`.',
        ],
        <String>[
          '`ghost`',
          'Transparent until interacted with. Low-emphasis or repeated '
              'actions — a toolbar, a row action.',
        ],
        <String>[
          '`destructive`',
          'Irreversible. Filled with the error colour. Pair it with a '
              'confirmation, not with regret.',
        ],
      ],
    ),
    const DocCallout.warning(
      'One `primary` per view. Two primary buttons side by side is a question, '
      'not a recommendation.',
    ),
    const DocHeading('Sizes'),
    const DocProse(
      'Three heights, from the size scale: `sm` is 28px, `md` 32px, `lg` 36px.',
    ),
    const DocExample('button_sizes'),
    const DocProse(
      'A button with no `size` takes it from an enclosing `AstryxSizeScope`, '
      'so a dense toolbar sets the size once and everything inside it follows. '
      'The same cascade drives `AstryxIconButton` and the form controls.',
    ),
    const DocExample('button_size_scope'),
    const DocHeading('Icons and badges'),
    const DocProse(
      'The `leading` and `trailing` slots take any widget. Their size and '
      'colour come from the button, so an `AstryxIcon` with the default '
      '`inherit` colour comes out right without being told anything.',
    ),
    const DocExample('button_icons'),
    const DocHeading('States'),
    const DocProse(
      'Three different things are often confused. A null `onPressed` is a '
      'button that does nothing. `enabled: false` is a button that could do '
      'something but not now. `loading: true` is a button whose action is in '
      'flight — it keeps its callback *and* its width, so the layout cannot '
      'jump, and it reports itself as disabled to assistive technology.',
    ),
    const DocExample('button_states'),
    const DocHeading('Elevation'),
    const DocProse(
      'Flat by default. Elevation is for a button that floats above the page, '
      'not for making an ordinary button look important — that is what '
      '`variant` is for.',
    ),
    const DocExample('button_elevation'),
    const DocHeading('Width'),
    const DocProse(
      'A button sizes to its label. `width` fixes it; a stretched stack fills '
      'the available space, which is usually what a form footer wants.',
    ),
    const DocExample('button_width'),
    const DocHeading('Links'),
    const DocProse(
      'Set `href` for an action that navigates. Navigation is not this '
      "package's concern, so the URI goes to the `AstryxLinkDelegate` the "
      'application installs — the seam is provided, the policy is yours.',
    ),
    const DocCode('''
AstryxThemeProvider(
  linkDelegate: AstryxLinkDelegate(
    onFollow: (uri) => launchUrl(uri),
  ),
  child: AstryxButton(
    label: 'Read the changelog',
    href: Uri.parse('https://example.com/changelog'),
    trailing: const AstryxIcon(AstryxIconName.externalLink),
  ),
)'''),
    const DocHeading('Keyboard'),
    const DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves focus to the button.'],
        <String>['`Enter`', 'Activates it.'],
        <String>['`Space`', 'Activates it.'],
      ],
    ),
    const DocCallout.accessibility(
      'The focus ring appears for keyboard focus and not for a click, which is '
      "CSS's `:focus-visible` rule ported wholesale. A disabled or loading "
      'button is announced as disabled rather than silently ignoring presses.',
    ),
    DocApi('AstryxButton', _buttonProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxIconButton](icon_button) — the same button, glyph only.',
      '[AstryxButtonGroup](button_group) — join or space a set of them.',
      '[AstryxSpinner](spinner) — what `loading` puts in the leading slot.',
    ]),
  ],
);

final List<DocProp> _buttonProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The visible text, and the accessible name.',
    required: true,
  ),
  const DocProp(
    'onPressed',
    'VoidCallback?',
    'Called on activation, by pointer or keyboard. Null makes the button '
        'inert.',
  ),
  const DocProp(
    'variant',
    'AstryxButtonVariant?',
    'How prominent the button is. Null inherits from an enclosing '
        '`AstryxButtonGroup`, then falls back to `secondary`.',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize?',
    'The control height. Null inherits from an enclosing `AstryxSizeScope`, '
        'then falls back to `md`.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the button accepts interaction.',
    defaultValue: 'true',
  ),
  const DocProp(
    'loading',
    'bool',
    'Whether an action is in flight. Shows a spinner, suppresses activation, '
        'and keeps the width.',
    defaultValue: 'false',
  ),
  const DocProp(
    'leading',
    'Widget?',
    'Content before the label — usually an `AstryxIcon`.',
  ),
  const DocProp(
    'trailing',
    'Widget?',
    'Content after the label — an icon or a badge.',
  ),
  const DocProp(
    'elevation',
    'AstryxElevation',
    'The resting shadow.',
    defaultValue: 'AstryxElevation.none',
  ),
  const DocProp(
    'width',
    'double?',
    'A fixed width. Null lets the label decide.',
  ),
  const DocProp(
    'href',
    'Uri?',
    'A destination, handed to the `AstryxLinkDelegate`.',
  ),
  const DocProp(
    'focusNode',
    'FocusNode?',
    'The focus node, if the caller owns one.',
  ),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
  const DocProp(
    'theme',
    'AstryxButtonTheme?',
    'Visual overrides, merged over `AstryxThemeData.button`.',
  ),
];

final DocPage _iconButton = DocPage(
  id: 'icon_button',
  title: 'AstryxIconButton',
  group: _group,
  description: 'A square button holding a glyph instead of words.',
  source: 'lib/src/components/action/icon_button.dart',
  upstream: 'IconButton',
  upstreamPath: '/components/IconButton',
  blocks: <DocBlock>[
    const DocExample('icon_button_demo'),
    const DocHeading('Usage'),
    const DocCode('''
AstryxIconButton(
  icon: AstryxIconName.search,
  label: 'Search',
  tooltip: 'Search',
  onPressed: () => openSearch(),
)'''),
    const DocCallout.accessibility(
      '`label` is **required**, and it is not the tooltip. A glyph has no '
      'accessible name of its own, so without a label the button is announced '
      'as "button" and nothing more. `tooltip` is the sighted-user version of '
      'the same information, and it is optional.',
    ),
    const DocProse(
      'When both are set the tooltip is left out of the semantics tree — '
      'hearing "Archive, Archive" is worse than not hearing the tooltip at '
      'all. Set `tooltip` to something the label does not already say if you '
      'want it announced.',
    ),
    const DocHeading('Variants'),
    const DocProse(
      'The same four as [AstryxButton](button). `ghost` is the usual choice '
      'for a toolbar or a row action, where a filled square in every row is '
      'noise.',
    ),
    const DocExample('icon_button_variants'),
    const DocHeading('Sizes'),
    const DocProse(
      'The three control heights, square. The glyph does not step in lockstep '
      'with the height: `sm` and `md` both take the 16px icon, `lg` takes '
      '20px — upstream figures, kept.',
    ),
    const DocExample('icon_button_sizes'),
    const DocHeading('Custom content'),
    const DocProse(
      'The default constructor goes through the icon registry, so a theme can '
      'swap every glyph in the app. `AstryxIconButton.custom` takes any widget '
      'instead — an avatar, a flag, a brand mark.',
    ),
    const DocExample('icon_button_custom'),
    const DocHeading('States'),
    const DocExample('icon_button_states'),
    DocApi('AstryxIconButton', _iconButtonProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxButton](button) — with a visible label.',
      '[AstryxIcon](icon) — the registry these names resolve through.',
      '[AstryxTooltip](tooltip) — what `tooltip` installs.',
    ]),
  ],
);

final List<DocProp> _iconButtonProps = <DocProp>[
  const DocProp(
    'icon',
    'AstryxIconName?',
    'The semantic name, resolved through the theme’s registry. Required for '
        'the default constructor.',
  ),
  const DocProp(
    'child',
    'Widget?',
    'The custom content, for `AstryxIconButton.custom`.',
  ),
  const DocProp(
    'label',
    'String',
    'The accessible name. Always required.',
    required: true,
  ),
  const DocProp(
    'tooltip',
    'String?',
    'Text shown on hover, for sighted users. Not a substitute for `label`.',
  ),
  const DocProp('onPressed', 'VoidCallback?', 'The action.'),
  const DocProp('variant', 'AstryxButtonVariant?', 'How prominent it is.'),
  const DocProp('size', 'AstryxButtonSize?', 'The control height.'),
  const DocProp(
    'enabled',
    'bool',
    'Whether it accepts interaction.',
    defaultValue: 'true',
  ),
  const DocProp(
    'loading',
    'bool',
    'Whether an action is in flight.',
    defaultValue: 'false',
  ),
  const DocProp(
    'elevation',
    'AstryxElevation',
    'The resting shadow.',
    defaultValue: 'AstryxElevation.none',
  ),
  const DocProp('href', 'Uri?', 'A destination for the link delegate.'),
  const DocProp('focusNode', 'FocusNode?', 'The focus node, if you own one.'),
  const DocProp(
    'autofocus',
    'bool',
    'Whether to take focus when first built.',
    defaultValue: 'false',
  ),
  const DocProp(
    'theme',
    'AstryxButtonTheme?',
    'Visual overrides for this button.',
  ),
];

final DocPage _buttonGroup = DocPage(
  id: 'button_group',
  title: 'AstryxButtonGroup',
  group: _group,
  description:
      'Joins related actions into one control, or spaces them as a set.',
  source: 'lib/src/components/action/button_group.dart',
  upstream: 'ButtonGroup',
  upstreamPath: '/components/ButtonGroup',
  blocks: <DocBlock>[
    const DocExample('button_group_demo'),
    const DocHeading('Usage'),
    const DocCode('''
AstryxButtonGroup(
  children: <Widget>[
    AstryxButton(label: 'Day', onPressed: () {}),
    AstryxButton(label: 'Week', onPressed: () {}),
    AstryxButton(label: 'Month', onPressed: () {}),
  ],
)'''),
    const DocProse(
      'Attached by default: the corners between neighbours are squared, so the '
      'buttons read as one control. The rounding is *directional* — the first '
      'child rounds its reading-start corners, which flips under RTL without '
      'the group being told which way it is running.',
    ),
    const DocHeading('Composition'),
    const DocTree('''
AstryxButtonGroup
├── AstryxButton        ← rounds its leading corners
├── AstryxButton        ← square both ends
└── AstryxButton        ← rounds its trailing corners'''),
    const DocHeading('Selection'),
    const DocProse(
      'The group holds **no selection of its own**. A segmented control is a '
      'group whose selected child takes a louder variant — which keeps the '
      'selected value wherever the application already keeps state, instead of '
      'in a widget.',
    ),
    const DocExample('button_group_segmented'),
    const DocHeading('Detached'),
    const DocProse(
      '`attached: false` leaves every button its own shape and spaces them by '
      '`gap`: a related *set* of actions rather than a segmented control. This '
      'is the shape a dialog footer wants.',
    ),
    const DocExample('button_group_detached'),
    const DocHeading('Inherited variant and size'),
    const DocProse(
      '`variant` and `size` cascade to every child that does not set its own, '
      'so a toolbar of eight ghost buttons says "ghost" once.',
    ),
    const DocExample('button_group_inherited'),
    const DocHeading('Vertical'),
    const DocExample('button_group_vertical'),
    DocApi('AstryxButtonGroup', _buttonGroupProps),
    DocApi(
      'AstryxButtonGroupScope',
      _buttonGroupScopeProps,
      description:
          'The inherited widget the group installs. Read it with '
          '`AstryxButtonGroupScope.maybeOf(context)` when building a custom '
          'child that should follow the group.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxButton](button) — the usual child.',
      '[AstryxTabList](tab_list) — for switching *views*, not for actions.',
    ]),
  ],
);

final List<DocProp> _buttonGroupProps = <DocProp>[
  const DocProp(
    'children',
    'List<Widget>',
    'The buttons, in order.',
    required: true,
  ),
  const DocProp(
    'variant',
    'AstryxButtonVariant?',
    'The variant every child takes unless it sets its own.',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize?',
    'The size every child takes unless it sets its own.',
  ),
  const DocProp(
    'axis',
    'Axis',
    'Whether the group runs horizontally or vertically.',
    defaultValue: 'Axis.horizontal',
  ),
  const DocProp(
    'attached',
    'bool',
    'Whether the buttons are joined into one visual control.',
    defaultValue: 'true',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken?',
    'The space between detached buttons. Ignored when `attached`.',
  ),
];

final List<DocProp> _buttonGroupScopeProps = <DocProp>[
  const DocProp(
    'variant',
    'AstryxButtonVariant?',
    'The variant descendants inherit.',
  ),
  const DocProp('size', 'AstryxButtonSize?', 'The size descendants inherit.'),
  const DocProp(
    'buttonTheme',
    'AstryxButtonTheme?',
    'Position-dependent visual overrides — chiefly the corner radii.',
  ),
];
