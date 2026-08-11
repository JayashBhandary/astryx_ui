import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// The action components: the buttons, and the groups that gather them.
final List<DocPage> actionPages = <DocPage>[
  _button,
  _iconButton,
  _buttonGroup,
  _toggleButton,
  _toggleButtonGroup,
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

final DocPage _toggleButton = DocPage(
  id: 'toggle_button',
  title: 'AstryxToggleButton',
  group: _group,
  description: 'A button that stays pressed — a setting, not an action.',
  source: 'lib/src/components/action/toggle_button.dart',
  upstream: 'ToggleButton',
  upstreamPath: '/components/ToggleButton',
  blocks: <DocBlock>[
    const DocProse(
      'A toolbar’s **Bold**, a filter that stays on, a list-or-grid switch. It '
      'looks like a button and behaves like a setting: pressing it does not '
      'start something, it changes what is true.',
    ),
    const DocExample('toggle_button_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxToggleButton(
  label: 'Only my issues',
  icon: const AstryxIcon(AstryxIconName.funnel),
  pressed: _pressed,
  onChanged: (value) => setState(() => _pressed = value),
)'''),
    const DocProse(
      'The button holds nothing. `onChanged` reports the state it should move '
      'to, and the caller owns the boolean — the same contract as '
      '[AstryxCheckbox](checkbox) and [AstryxSwitch](switch). Upstream calls '
      'this `onPressedChange`; it is `onChanged` here so that every stateful '
      'control in the package answers to one name.',
    ),
    const DocCallout.note(
      'There is no `variant`. A toggle is always a ghost button, because the '
      'pressed fill *is* its visual language — a filled variant would have '
      'nothing left to say when it went on.',
    ),
    const DocHeading('Which widget, though'),
    const DocTable(
      headers: <String>['Reach for', 'When'],
      rows: <List<String>>[
        <String>[
          '`AstryxToggleButton`',
          'A toolbar control, a formatting mark, a filter chip that stays '
              'down. It lives beside other buttons and looks like one.',
        ],
        <String>[
          '[AstryxSwitch](switch)',
          'A setting in a form. It is labelled, announced as a switch, and '
              'reads as configuration rather than as a control you press.',
        ],
        <String>[
          '[AstryxCheckbox](checkbox)',
          'A value being selected, especially in a list or a set of options.',
        ],
        <String>[
          '[AstryxTabList](tab_list)',
          'Switching what a panel shows. Tabs, not toggles — a tab strip '
              'always has exactly one selection.',
        ],
      ],
    ),
    const DocHeading('Icon only'),
    const DocProse(
      'Upstream calls this `isIconOnly`; here it is `labelHidden`, the name '
      'the form controls already use for "keep the name, drop the text". The '
      'button squares off and — unless you pass a `tooltip` of your own — '
      'takes the label as its tooltip, so a reader who does not know the glyph '
      'still has somewhere to look.',
    ),
    const DocExample('toggle_button_icon_only'),
    const DocCode('''
AstryxToggleButton(
  label: 'Watch this repository',
  labelHidden: true,
  icon: const AstryxIcon(AstryxIconName.eyeSlash),
  pressedIcon: const AstryxIcon(AstryxIconName.check),
  pressed: _watching,
  onChanged: (value) => setState(() => _watching = value),
)'''),
    const DocProse(
      '`pressedIcon` swaps the glyph while the button is on — an outline '
      'becoming a fill, upstream’s own use for it. It falls back to `icon`, so '
      'a toggle with one glyph needs nothing extra. Colour a pressed glyph by '
      'passing an already-coloured widget.',
    ),
    const DocHeading('States'),
    const DocExample('toggle_button_states', align: DocExampleAlign.stretch),
    const DocProse(
      'Disabled and loading both refuse the press; loading also announces the '
      'wait and keeps the button’s width, so a toolbar does not jump. The '
      'pressed fill is `--color-overlay-pressed` over the transparent ghost '
      'background.',
    ),
    const DocCallout.note(
      'A pressed toggle does not change under a pointer. Upstream applies the '
      'pressed fill unconditionally, which overrides its own hover tint, and '
      'that is reproduced here — two overlapping "this one is active" signals '
      'read worse than one that holds still. Focus and press feedback are '
      'unaffected.',
    ),
    const DocHeading('Accessibility'),
    const DocList(<String>[
      'The label is **required**, and is the accessible name whether it is '
          'painted or not.',
      'A toggle reports a **selected** state; a plain button has no such state '
          'at all, so nothing announces "not selected" about a Save button. '
          'Upstream spells it `aria-pressed`; Flutter’s nearest flag is '
          '`selected`, which is what `SegmentedButton` uses in the framework '
          'itself.',
      'Enter and Space activate it, and the focus ring lands on the painted '
          'bounds while the touch target grows underneath. See '
          '[Density](density).',
      'The pressed state is never colour alone: the label also shifts to '
          'semibold.',
    ]),
    const DocCallout.warning(
      'Windows High Contrast is not covered. Upstream repaints the pressed '
      'state with the platform `Highlight` colours under `forced-colors`, and '
      'Flutter has no equivalent — `MediaQuery.highContrast` is a preference, '
      'not a forced palette. On a forced-colours desktop the pressed fill may '
      'be dropped, and the weight shift is what remains.',
    ),
    const DocHeading('Two things upstream has that this does not'),
    const DocList(<String>[
      '**`pressedChangeAction`.** Upstream takes an async callback, runs it in '
          'a React transition, and shows an optimistic pressed state with a '
          'spinner until it settles. There is no transition model to port it '
          'onto; drive `pressed` and `loading` yourself, which is how every '
          'other control in this package reports work in flight.',
      '**`children`.** Upstream lets visible content replace the label. Here '
          'the label is the text, as on [AstryxButton](button) — one way to '
          'name a button rather than two.',
    ]),
    DocApi('AstryxToggleButton', _toggleButtonProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxToggleButtonGroup](toggle_button_group) — several of these as '
          'one control.',
      '[AstryxButton](button) — the action that does not stay pressed.',
      '[AstryxSwitch](switch) — the setting that does not look like a button.',
    ]),
  ],
);

final List<DocProp> _toggleButtonProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The visible text, and the accessible name.',
    required: true,
  ),
  const DocProp(
    'pressed',
    'bool',
    'Whether the button is on. Ignored inside a group.',
    defaultValue: 'false',
  ),
  const DocProp(
    'onChanged',
    'ValueChanged<bool>?',
    'Called with the state to move to. Null makes the button inert; ignored '
        'inside a group.',
  ),
  const DocProp(
    'value',
    'String?',
    'This button’s identity inside an `AstryxToggleButtonGroup`. Required '
        'there, meaningless outside.',
  ),
  const DocProp('icon', 'Widget?', 'Content before the label.'),
  const DocProp(
    'pressedIcon',
    'Widget?',
    'The glyph shown while pressed. Falls back to `icon`.',
  ),
  const DocProp(
    'labelHidden',
    'bool',
    'Keeps the label as the accessible name without painting it: the button '
        'squares off and tooltips itself.',
    defaultValue: 'false',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize?',
    'The control height. Null takes the group’s, then the inherited size.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the button accepts interaction. **Ignored inside a group**, which '
        'decides for its children.',
    defaultValue: 'true',
  ),
  const DocProp(
    'loading',
    'bool',
    'Whether work is in flight. Suppresses activation and shows a spinner.',
    defaultValue: 'false',
  ),
  const DocProp(
    'tooltip',
    'String?',
    'Hover text. Defaults to `label` when `labelHidden`.',
  ),
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
    'Visual overrides, merged over `AstryxThemeData.button`.',
  ),
];

final DocPage _toggleButtonGroup = DocPage(
  id: 'toggle_button_group',
  title: 'AstryxToggleButtonGroup',
  group: _group,
  description: 'Toggle buttons as one control — single or multiple selection.',
  source: 'lib/src/components/action/toggle_button.dart',
  upstream: 'ToggleButtonGroup',
  upstreamPath: '/components/ToggleButtonGroup',
  blocks: <DocBlock>[
    const DocProse(
      'The group owns the selection, so its children carry a `value` rather '
      'than a boolean. Which may be on at once is the constructor’s job, '
      'not a flag: `.single` for at most one, `.multiple` for any number.',
    ),
    const DocHeading('At most one'),
    const DocExample(
      'toggle_button_group_single',
      align: DocExampleAlign.start,
    ),
    const DocCode('''
AstryxToggleButtonGroup.single(
  label: 'View mode',
  value: _view,
  onChanged: (value) => setState(() => _view = value),
  children: const <Widget>[
    AstryxToggleButton(value: 'list', label: 'List'),
    AstryxToggleButton(value: 'grid', label: 'Grid'),
    AstryxToggleButton(value: 'board', label: 'Board'),
  ],
)'''),
    const DocProse(
      'Pressing the button that is already on **clears** the group, and '
      '`onChanged` receives null. That is upstream’s behaviour and the reason '
      'the value is nullable: "none" stays reachable. If your screen cannot '
      'represent none, a [tab list](tab_list) is the honest control.',
    ),
    const DocHeading('Any number'),
    const DocExample(
      'toggle_button_group_multiple',
      align: DocExampleAlign.start,
    ),
    const DocCode('''
AstryxToggleButtonGroup.multiple(
  label: 'Filter by status',
  values: _statuses,
  onChanged: (values) => setState(() => _statuses = values),
  children: const <Widget>[
    AstryxToggleButton(value: 'passing', label: 'Passing'),
    AstryxToggleButton(value: 'failing', label: 'Failing'),
    AstryxToggleButton(value: 'queued', label: 'Queued'),
  ],
)'''),
    const DocProse(
      'Each change hands you a **new set**; the group never edits the one it '
      'was given. Upstream splits these two modes with a discriminated union '
      'on a `type` prop — two named constructors are how Dart says the same '
      'thing, and they make the wrong `onChanged` signature a compile error '
      'rather than a runtime surprise.',
    ),
    const DocHeading('Vertical'),
    const DocExample('toggle_button_group_vertical'),
    const DocProse(
      'A vertical group stretches its buttons to one width, so labels of '
      'different lengths still line up. `size` cascades to every child that '
      'does not set its own.',
    ),
    const DocHeading('Not a segmented control'),
    const DocProse(
      'The buttons are spaced by `--spacing-1` rather than joined, and each is '
      'its own tab stop — a set of related controls, not one widget with an '
      'internal cursor. For a joined row of *actions* see '
      '[AstryxButtonGroup](button_group); for choosing what a panel shows, '
      '[AstryxTabList](tab_list), which has roving focus and a single stop.',
    ),
    const DocCallout.accessibility(
      'The group’s `label` is required: it is the accessible name of the set, '
      'and without it a reader meets three unrelated buttons. Each child keeps '
      'its own node and its own selected state.',
    ),
    const DocCallout.warning(
      'Inside a group, a child’s own `enabled` is **ignored** — the group '
      'decides. Upstream does the same (`group?.isDisabled ?? isDisabled`), so '
      'it is reproduced and pinned by a test rather than quietly improved. '
      'Disable the group, not its children. A grouped button without a `value` '
      'asserts in debug, because the group would have no way to know which one '
      'is on.',
    ),
    DocApi('AstryxToggleButtonGroup', _toggleButtonGroupProps),
    DocApi(
      'AstryxToggleButtonGroupScope',
      _toggleButtonGroupScopeProps,
      description:
          'The inherited widget the group installs, and the buttons read. The '
          'port of upstream’s `ToggleButtonGroupContext` — reach for it only '
          'when building a control of your own that has to know what is '
          'selected.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxToggleButton](toggle_button) — the child, and the states it '
          'paints.',
      '[AstryxButtonGroup](button_group) — actions joined into one shape.',
      '[AstryxRadioList](radio_list) — one choice from a set, as a form '
          'control.',
    ]),
  ],
);

final List<DocProp> _toggleButtonGroupProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'The group’s accessible name — "View mode", "Text formatting".',
    required: true,
  ),
  const DocProp(
    'value',
    'String?',
    '`.single` only: the value that is on, or null for none.',
    required: true,
  ),
  const DocProp(
    'onChanged',
    'ValueChanged<String?>',
    '`.single` only: the new value, or null when the group has been cleared.',
    required: true,
  ),
  const DocProp(
    'values',
    'Set<String>',
    '`.multiple` only: the values that are on.',
    required: true,
  ),
  const DocProp(
    'onChanged',
    'ValueChanged<Set<String>>',
    '`.multiple` only: a new set, each time.',
    required: true,
  ),
  const DocProp(
    'children',
    'List<Widget>',
    'The toggle buttons, in order. Each needs a `value`.',
    required: true,
  ),
  const DocProp(
    'axis',
    'Axis',
    'Whether the group runs horizontally or vertically.',
    defaultValue: 'Axis.horizontal',
  ),
  const DocProp(
    'size',
    'AstryxButtonSize?',
    'The size every child takes unless it sets its own.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the whole group accepts interaction. The only place to disable a '
        'grouped toggle.',
    defaultValue: 'true',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken?',
    'The space between the buttons.',
    defaultValue: 'AstryxSpacingToken.spacing1',
  ),
];

final List<DocProp> _toggleButtonGroupScopeProps = <DocProp>[
  const DocProp(
    'selectedValues',
    'Set<String>',
    'The values currently on.',
    required: true,
  ),
  const DocProp(
    'toggle',
    'void Function(String value)',
    'Reports that a button’s value has been pressed.',
    required: true,
  ),
  const DocProp(
    'size',
    'AstryxButtonSize?',
    'The size children inherit.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the group accepts interaction.',
    defaultValue: 'true',
  ),
];
