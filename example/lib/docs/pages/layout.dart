import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Layout and typography — the primitives everything else composes from.
final List<DocPage> layoutPages = <DocPage>[
  _text,
  _heading,
  _stack,
  _grid,
  _center,
  _divider,
  _icon,
  _visuallyHidden,
];

const String _group = DocGroup.layout;

final DocPage _text = DocPage(
  id: 'text',
  title: 'AstryxText',
  group: _group,
  description: 'A run of text, sized and coloured from the type scale.',
  source: 'lib/src/components/layout/text.dart',
  upstream: 'Text',
  upstreamPath: '/components/Text',
  blocks: <DocBlock>[
    const DocExample('text_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxText('Requests are up 12% this week.')

const AstryxText(
  'Compared with the seven days before.',
  type: AstryxTextType.supporting,
  color: AstryxTextColor.secondary,
)'''),
    const DocProse(
      'Text takes a `type` and a `color`, not a `TextStyle`. The type selects '
      'one row of the type scale — size, weight and line height together — so '
      'two pieces of body copy cannot drift apart by half a pixel. `style` '
      'exists as an escape hatch, and everything else on this page is an '
      'attempt to make reaching for it rare.',
    ),
    const DocHeading('Types'),
    const DocExample('text_types', align: DocExampleAlign.start),
    const DocTable(
      headers: <String>['Type', 'For'],
      rows: <List<String>>[
        <String>[
          '`display1` … `display3`',
          'Marketing-scale numbers and hero '
              'text. Rarely inside a tool.',
        ],
        <String>['`large`', 'Body copy one step up, for emphasis.'],
        <String>['`body`', 'The default.'],
        <String>['`label`', 'Form and control labels.'],
        <String>['`supporting`', 'Hints, captions, helper text.'],
        <String>['`code`', 'Inline and block code, in the code family.'],
      ],
    ),
    const DocHeading('Colours'),
    const DocProse(
      'Semantic, not literal. `inherit` takes the colour from the enclosing '
      '`DefaultTextStyle`, which is what text inside a button or an inverted '
      'banner wants.',
    ),
    const DocExample('text_colors', align: DocExampleAlign.start),
    const DocHeading('Weights'),
    const DocProse(
      '`weight` overrides what the type would give. Prefer a different `type` '
      'where one fits: the scale already pairs weight with size and leading.',
    ),
    const DocExample('text_weights', align: DocExampleAlign.start),
    const DocHeading('Truncation'),
    const DocProse(
      'With `maxLines` set, overflow defaults to an ellipsis. '
      '`truncateTooltip` adds a tooltip carrying the full string — but only '
      'when the text is genuinely cut off, so it never repeats something '
      'already legible. It costs one text layout per build, so leave it off '
      'for text that cannot truncate.',
    ),
    const DocExample('text_truncation', align: DocExampleAlign.start),
    const DocCallout.accessibility(
      'Truncation is a painting concern and never reaches the semantics tree: '
      'a screen reader always gets the whole string, ellipsis or not.',
    ),
    const DocHeading('Numbers'),
    const DocProse(
      '`tabularNumbers` asks the font for fixed-width figures, so a column of '
      'numbers lines up. Fonts without the `tnum` feature render unchanged.',
    ),
    const DocExample('text_numbers', align: DocExampleAlign.start),
    const DocHeading('Semantics'),
    const DocProse(
      '`semanticsLabel` replaces what is read aloud without changing what is '
      r'painted — for text a reader would mangle: `$1.2M`, an abbreviation, a '
      'glyph.',
    ),
    const DocExample('text_semantics', align: DocExampleAlign.start),
    DocApi('AstryxText', _textProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxHeading](heading) — text that is also a document landmark.',
      '[Design tokens](tokens) — the scale these types come from.',
    ]),
  ],
);

final List<DocProp> _textProps = <DocProp>[
  const DocProp(
    'data',
    'String',
    'The text to display. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'type',
    'AstryxTextType',
    'The semantic role, which selects the type-scale row.',
    defaultValue: 'AstryxTextType.body',
  ),
  const DocProp(
    'color',
    'AstryxTextColor',
    'The semantic colour.',
    defaultValue: 'AstryxTextColor.primary',
  ),
  const DocProp(
    'weight',
    'AstryxTextWeight?',
    'Overrides the weight the `type` would give.',
  ),
  const DocProp(
    'size',
    'AstryxTextSizeToken?',
    'Overrides the size from the raw ramp. The line height stays the role’s, '
        'so this changes the leading ratio — usually not what you want.',
  ),
  const DocProp(
    'justify',
    'AstryxTextJustify?',
    'Alignment within the box. Logical, so it flips under RTL.',
  ),
  const DocProp('maxLines', 'int?', 'Lines before the text is truncated.'),
  const DocProp(
    'overflow',
    'TextOverflow?',
    'How overflow is handled. Defaults to `ellipsis` when `maxLines` is set, '
        '`clip` otherwise.',
  ),
  const DocProp(
    'truncateTooltip',
    'bool',
    'Whether to show the full text in a tooltip when — and only when — it is '
        'cut off.',
    defaultValue: 'false',
  ),
  const DocProp(
    'softWrap',
    'bool',
    'Whether the text wraps at soft breaks.',
    defaultValue: 'true',
  ),
  const DocProp(
    'strikethrough',
    'bool',
    'Whether to strike the text through.',
    defaultValue: 'false',
  ),
  const DocProp(
    'tabularNumbers',
    'bool',
    'Whether digits use fixed-width figures.',
    defaultValue: 'false',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'An alternative string for a screen reader.',
  ),
  const DocProp('style', 'TextStyle?', 'Applied over the resolved style.'),
  const DocProp(
    'theme',
    'AstryxTextTheme?',
    'Visual overrides, merged over `AstryxThemeData.text`.',
  ),
];

final DocPage _heading = DocPage(
  id: 'heading',
  title: 'AstryxHeading',
  group: _group,
  description: 'A heading: a size from the scale, and a level in the outline.',
  source: 'lib/src/components/layout/heading.dart',
  upstream: 'Heading',
  upstreamPath: '/components/Heading',
  blocks: <DocBlock>[
    const DocExample('heading_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxHeading('Workspace settings')

const AstryxHeading('Members', level: 3)'''),
    const DocProse(
      '`level` drives both the size and the level announced to assistive '
      'technology, which is the point: a heading that looks like a heading but '
      'is not announced as one leaves a screen-reader user without the '
      "document's structure.",
    ),
    const DocHeading('Levels'),
    const DocExample('heading_levels', align: DocExampleAlign.start),
    const DocHeading('Display sizes'),
    const DocProse(
      '`type` changes the size only — the announced level stays `level`. So a '
      'hero heading can be enormous and still be the page’s h1.',
    ),
    const DocExample('heading_display', align: DocExampleAlign.start),
    const DocHeading('When the outline and the design disagree'),
    const DocProse(
      '`accessibilityLevel` overrides the announced level alone. It exists for '
      'the rare case where the visual hierarchy and the document outline '
      'genuinely differ. Prefer fixing the design.',
    ),
    const DocExample(
      'heading_accessibility_level',
      align: DocExampleAlign.start,
    ),
    const DocCallout.accessibility(
      'Do not skip levels to get a size. An h2 followed by an h4 tells a '
      'screen-reader user a section is missing. Use `type` for the size and '
      'keep `level` honest.',
    ),
    DocApi('AstryxHeading', _headingProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxText](text) — everything that is not a heading.',
    ]),
  ],
);

final List<DocProp> _headingProps = <DocProp>[
  const DocProp(
    'data',
    'String',
    'The heading text. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'level',
    'int',
    'The heading level, 1–6. Drives both size and semantics.',
    defaultValue: '2',
  ),
  const DocProp(
    'type',
    'AstryxHeadingType?',
    'A display size to use instead of `level`’s own. The semantic level is '
        'unaffected.',
  ),
  const DocProp(
    'color',
    'AstryxTextColor',
    'The semantic colour.',
    defaultValue: 'AstryxTextColor.primary',
  ),
  const DocProp(
    'accessibilityLevel',
    'int?',
    'Overrides the level announced to assistive technology.',
  ),
  const DocProp('justify', 'AstryxTextJustify?', 'Alignment within the box.'),
  const DocProp('maxLines', 'int?', 'Lines before truncation.'),
  const DocProp('overflow', 'TextOverflow?', 'How overflow is handled.'),
  const DocProp(
    'softWrap',
    'bool',
    'Whether the heading wraps.',
    defaultValue: 'true',
  ),
  const DocProp(
    'strikethrough',
    'bool',
    'Whether to strike it through.',
    defaultValue: 'false',
  ),
  const DocProp(
    'semanticsLabel',
    'String?',
    'An alternative string for a screen reader.',
  ),
  const DocProp('style', 'TextStyle?', 'Applied over the resolved style.'),
  const DocProp(
    'theme',
    'AstryxTextTheme?',
    'Visual overrides, merged over `AstryxThemeData.heading`.',
  ),
];

final DocPage _stack = DocPage(
  id: 'stack',
  title: 'AstryxHStack & AstryxVStack',
  group: _group,
  description: 'A row and a column whose gap comes from the spacing scale.',
  source: 'lib/src/components/layout/stack.dart',
  upstream: 'HStack / VStack',
  upstreamPath: '/components/HStack',
  blocks: <DocBlock>[
    const DocExample('stack_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxVStack(
  gap: AstryxSpacingToken.spacing3,
  align: AstryxStackAlign.stretch,
  children: <Widget>[
    const AstryxHeading('Invite teammates', level: 4),
    AstryxButton(label: 'Send invites', onPressed: send),
  ],
)'''),
    const DocProse(
      'A `Row` with a token gap, in short — plus two differences from Flutter '
      'that are worth knowing. `mainAxisSize` defaults to `min`, not `max`, '
      'because a design-system stack is usually a small cluster inside a '
      'larger layout; and `AstryxHStack` centres on the cross axis by default, '
      'which is what puts an icon on the text’s optical centre.',
    ),
    const DocCallout.warning(
      '`justify` appears to do nothing when the stack is only as wide as its '
      'children. That is `mainAxisSize: min` doing its job — ask for '
      '`MainAxisSize.max` when you want the space distributed.',
    ),
    const DocHeading('Justify'),
    const DocExample('stack_justify', align: DocExampleAlign.stretch),
    const DocHeading('Align'),
    const DocProse(
      'The cross axis. `stretch` is what makes a column of buttons the same '
      'width. It has no `Wrap` equivalent, so a wrapping stack falls back to '
      '`start`.',
    ),
    const DocExample('stack_align', align: DocExampleAlign.stretch),
    const DocHeading('Wrapping'),
    const DocProse(
      '`wrap: true` flows children onto further lines, spaced by `runGap` — '
      'the right shape for a bag of tags, and never for a form.',
    ),
    const DocExample('stack_wrap', align: DocExampleAlign.start),
    const DocHeading('Nesting'),
    const DocProse(
      'The everyday shape of a settings row: a spreading row holding a column '
      'that hugs.',
    ),
    const DocExample('stack_nested', align: DocExampleAlign.start),
    DocApi(
      'AstryxHStack',
      _stackProps,
      description:
          'A horizontal stack. `AstryxVStack` takes exactly the same '
          'parameters; only the default `align` differs — `start` rather than '
          '`center`.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxGrid](grid) — for two-dimensional layout.',
      '[AstryxCenter](center) — for centring one child.',
      '[Design tokens](tokens) — the spacing scale `gap` names.',
    ]),
  ],
);

final List<DocProp> _stackProps = <DocProp>[
  const DocProp(
    'children',
    'List<Widget>',
    'The widgets to lay out, in order.',
    required: true,
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken?',
    'The space between children.',
  ),
  const DocProp(
    'justify',
    'AstryxStackJustify',
    'Distribution along the main axis.',
    defaultValue: 'AstryxStackJustify.start',
  ),
  const DocProp(
    'align',
    'AstryxStackAlign',
    'Alignment across the cross axis.',
    defaultValue: 'center (HStack) / start (VStack)',
  ),
  const DocProp(
    'wrap',
    'bool',
    'Whether children wrap onto further lines.',
    defaultValue: 'false',
  ),
  const DocProp(
    'runGap',
    'AstryxSpacingToken?',
    'The space between wrapped lines. Defaults to `gap`.',
  ),
  const DocProp(
    'mainAxisSize',
    'MainAxisSize',
    'Whether the stack takes all the main-axis space or only what it needs.',
    defaultValue: 'MainAxisSize.min',
  ),
];

final DocPage _grid = DocPage(
  id: 'grid',
  title: 'AstryxGrid',
  group: _group,
  description:
      'A CSS-style grid: fixed tracks, or as many as the width allows.',
  source: 'lib/src/components/layout/grid.dart',
  upstream: 'Grid / GridSpan',
  upstreamPath: '/components/Grid',
  blocks: <DocBlock>[
    const DocExample('grid_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxGrid(
  columns: 3,
  gap: AstryxSpacingToken.spacing3,
  children: <Widget>[...],
)'''),
    const DocProse(
      'Either `columns` for a fixed track count, or `minWidth` for a '
      'responsive one. Not both.',
    ),
    const DocHeading('Responsive'),
    const DocProse(
      'With `minWidth`, the column count falls out of the space available — '
      '`repeat(auto-fit, minmax(180px, 1fr))`, in CSS terms. No breakpoints to '
      'keep in step with the design, and `maxColumns` stops a grid spreading '
      'indefinitely on a wide display.',
    ),
    const DocExample('grid_responsive', align: DocExampleAlign.stretch),
    const DocHeading('Short rows'),
    const DocProse(
      'Five items in a four-track row leave one short. `fit` collapses the '
      'empty tracks so the row stretches; `fill` keeps them, so the last item '
      'stays the width it would have had in a full row.',
    ),
    const DocExample('grid_repeat', align: DocExampleAlign.stretch),
    const DocHeading('Gaps'),
    const DocProse(
      '`gap` sets both axes; `rowGap` and `columnGap` override it per axis.',
    ),
    const DocExample('grid_gaps', align: DocExampleAlign.stretch),
    const DocCallout.note(
      'The grid lays its children out in rows and never scrolls. For hundreds '
      'of tiles, put it in a scroll view — or reach for a Flutter sliver grid, '
      'which builds lazily.',
    ),
    DocApi('AstryxGrid', _gridProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxHStack & AstryxVStack](stack) — for one-dimensional layout.',
      '[AstryxCard](card) — the usual tile.',
    ]),
  ],
);

final List<DocProp> _gridProps = <DocProp>[
  const DocProp(
    'children',
    'List<Widget>',
    'The widgets to lay out, in order.',
    required: true,
  ),
  const DocProp('columns', 'int?', 'A fixed number of equal columns.'),
  const DocProp(
    'minWidth',
    'double?',
    'The minimum column width, for a responsive track list.',
  ),
  const DocProp(
    'maxColumns',
    'int?',
    'A ceiling on the responsive column count.',
  ),
  const DocProp(
    'repeat',
    'AstryxGridRepeat',
    'Whether empty tracks collapse. Only meaningful with `minWidth`.',
    defaultValue: 'AstryxGridRepeat.fit',
  ),
  const DocProp(
    'gap',
    'AstryxSpacingToken?',
    'The space between items on both axes.',
  ),
  const DocProp('rowGap', 'AstryxSpacingToken?', 'The space between rows.'),
  const DocProp(
    'columnGap',
    'AstryxSpacingToken?',
    'The space between columns.',
  ),
];

final DocPage _center = DocPage(
  id: 'center',
  title: 'AstryxCenter',
  group: _group,
  description: 'Centres a child, with token padding and a measure.',
  source: 'lib/src/components/layout/center.dart',
  upstream: 'Center',
  upstreamPath: '/components/Center',
  blocks: <DocBlock>[
    const DocExample('center_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxCenter(
  minHeight: 200,
  padding: AstryxSpacingToken.spacing6,
  child: emptyState,
)'''),
    const DocProse(
      'The empty-state box, mostly. `minHeight` stops it collapsing to the '
      'height of its message, and the padding parameters are logical: '
      '`paddingInline` flips under RTL, `paddingBlock` does not.',
    ),
    const DocHeading('Axis'),
    const DocExample('center_axis', align: DocExampleAlign.stretch),
    const DocHeading('Measure'),
    const DocProse(
      '`maxWidth` is what keeps centred prose readable on a wide display: the '
      'box centres, the line length stays put.',
    ),
    const DocExample('center_measure', align: DocExampleAlign.stretch),
    DocApi('AstryxCenter', _centerProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxHStack & AstryxVStack](stack) — for more than one child.',
      '[AstryxTable](table) — whose `emptyState` this usually holds.',
    ]),
  ],
);

final List<DocProp> _centerProps = <DocProp>[
  const DocProp('child', 'Widget', 'The widget to centre.', required: true),
  const DocProp(
    'axis',
    'AstryxCenterAxis',
    'Which axes to centre on.',
    defaultValue: 'AstryxCenterAxis.both',
  ),
  const DocProp(
    'padding',
    'AstryxSpacingToken?',
    'Padding on every side. The two axis-specific values override it.',
  ),
  const DocProp(
    'paddingInline',
    'AstryxSpacingToken?',
    'Padding on the inline axis — start and end, so it flips under RTL.',
  ),
  const DocProp(
    'paddingBlock',
    'AstryxSpacingToken?',
    'Padding on the block axis — top and bottom.',
  ),
  const DocProp('width', 'double?', 'A fixed width.'),
  const DocProp('height', 'double?', 'A fixed height.'),
  const DocProp(
    'maxWidth',
    'double?',
    'A ceiling on the width, for a centred column of text.',
  ),
  const DocProp(
    'minHeight',
    'double?',
    'A floor under the height, so an empty state does not collapse.',
  ),
];

final DocPage _divider = DocPage(
  id: 'divider',
  title: 'AstryxDivider',
  group: _group,
  description: 'A rule between sections, optionally labelled.',
  source: 'lib/src/components/layout/divider.dart',
  upstream: 'Divider',
  upstreamPath: '/components/Divider',
  blocks: <DocBlock>[
    const DocExample('divider_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('const AstryxDivider()'),
    const DocHeading('Variants'),
    const DocExample('divider_variants', align: DocExampleAlign.stretch),
    const DocCallout.warning(
      'The `subtle` variant is roughly 1.1:1 against its background — '
      'deliberately, matching upstream. It is decoration. Never use it as a '
      "control's only visible boundary, and never to convey information.",
    ),
    const DocHeading('Labelled'),
    const DocProse(
      'A label sits in the middle of the rule. Horizontal dividers only. A '
      'labelled divider is announced; an unlabelled one is not, because a rule '
      'with nothing to say should not interrupt.',
    ),
    const DocExample('divider_labelled', align: DocExampleAlign.start),
    const DocHeading('Vertical'),
    const DocProse(
      'A vertical rule needs a bounded height from its parent — a stretched '
      'row, or an `IntrinsicHeight`. Without one it has nothing to measure and '
      'paints nothing.',
    ),
    const DocExample('divider_vertical', align: DocExampleAlign.start),
    DocApi('AstryxDivider', _dividerProps),
  ],
);

final List<DocProp> _dividerProps = <DocProp>[
  const DocProp(
    'axis',
    'Axis',
    'Whether the rule runs horizontally or vertically.',
    defaultValue: 'Axis.horizontal',
  ),
  const DocProp(
    'variant',
    'AstryxDividerVariant',
    'How prominent the rule is.',
    defaultValue: 'AstryxDividerVariant.subtle',
  ),
  const DocProp(
    'label',
    'String?',
    'Text shown in the middle of the rule. Horizontal only.',
  ),
  const DocProp(
    'theme',
    'AstryxDividerTheme?',
    'Visual overrides, merged over `AstryxThemeData.divider`.',
  ),
];

final DocPage _icon = DocPage(
  id: 'icon',
  title: 'AstryxIcon',
  group: _group,
  description: 'A glyph named semantically and resolved through the theme.',
  source: 'lib/src/components/layout/icon.dart',
  upstream: 'Icon',
  upstreamPath: '/components/Icon',
  blocks: <DocBlock>[
    const DocExample('icon_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success)'''),
    const DocProse(
      'An icon is named by *meaning*, not by glyph: `AstryxIconName.success`, '
      'not `check-circle`. The theme’s registry maps names to glyphs — Lucide '
      'by default, matching upstream — so swapping icon sets is a theme change '
      'rather than a hundred call-site edits.',
    ),
    const DocHeading('Sizes'),
    const DocProse(
      'Four steps. A null `size` inherits from the enclosing `IconTheme`, '
      'which is how a button sizes the icons in its slots — and why a spinner '
      'replacing one cannot shift the layout.',
    ),
    const DocExample('icon_sizes', align: DocExampleAlign.start),
    const DocHeading('Colours'),
    const DocProse(
      '`inherit` — the default — takes the colour from the enclosing text '
      'style. That is what an icon inside a button or a coloured banner wants.',
    ),
    const DocExample('icon_colors', align: DocExampleAlign.start),
    const DocHeading('Decorative or meaningful'),
    const DocProse(
      'Leave `label` null for an icon beside text that already says the same '
      'thing: the icon is then hidden from assistive technology rather than '
      'announced as an unnamed image. Set it when the icon is the only thing '
      'carrying the meaning.',
    ),
    const DocExample('icon_labelled', align: DocExampleAlign.start),
    const DocHeading('The registry'),
    const DocProse(
      'The 28 names the default registry knows. An application needing "edit" '
      'or "delete" passes any icon widget instead — every slot that takes an '
      'icon takes a `Widget`, precisely so the registry does not have to grow '
      'to cover every product.',
    ),
    const DocExample('icon_registry', align: DocExampleAlign.stretch),
    const DocHeading('RTL'),
    const DocProse(
      'Directional glyphs mirror under RTL automatically — chevrons and arrows '
      'do, a calendar does not. `mirrorForRtl` overrides that decision for a '
      'custom registry whose glyph points a different way.',
    ),
    DocApi('AstryxIcon', _iconProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxIconButton](icon_button) — an icon that does something.',
      '[Theming](theming) — how to install a different registry.',
    ]),
  ],
);

final List<DocProp> _iconProps = <DocProp>[
  const DocProp(
    'name',
    'AstryxIconName',
    'The semantic name. The positional first argument.',
    required: true,
  ),
  const DocProp(
    'size',
    'AstryxIconSize?',
    'The size step. Null inherits from the enclosing `IconTheme`, then falls '
        'back to `md`.',
  ),
  const DocProp(
    'color',
    'AstryxIconColor',
    'The semantic colour.',
    defaultValue: 'AstryxIconColor.inherit',
  ),
  const DocProp(
    'label',
    'String?',
    'An accessible name. Null — the default — marks the icon decorative.',
  ),
  const DocProp(
    'mirrorForRtl',
    'bool?',
    'Overrides whether the glyph mirrors under RTL.',
  ),
  const DocProp(
    'theme',
    'AstryxIconTheme?',
    'Visual overrides, merged over `AstryxThemeData.icon`.',
  ),
];

final DocPage _visuallyHidden = DocPage(
  id: 'visually_hidden',
  title: 'AstryxVisuallyHidden',
  group: _group,
  description:
      'Content present for a screen reader and absent from the screen.',
  source: 'lib/src/foundation/semantics.dart',
  upstream: 'VisuallyHidden',
  upstreamPath: '/components/VisuallyHidden',
  blocks: <DocBlock>[
    const DocProse(
      'A child that is announced but never painted, and that measures nothing. '
      'It exists for one situation: a change the user has to hear about, with '
      'no widget for it to be the name of.',
    ),
    const DocCallout.warning(
      'Upstream’s `VisuallyHidden` does **two** jobs, and only one of them '
      'needs a widget here. Reaching for it to name a control is the most '
      'common false friend in the whole port — read both sections below before '
      'using it.',
    ),
    const DocHeading('The job it is for'),
    const DocProse(
      'A count, a result total, a status that has just changed. Nothing on '
      'screen owns the string, so there is no label to hang it on; a region of '
      'its own is the only place it can go.',
    ),
    const DocExample('visually_hidden_live', align: DocExampleAlign.start),
    const DocCode(r'''
AstryxVisuallyHidden(
  liveRegion: true,
  child: Text('$remaining characters remaining'),
)'''),
    const DocProse(
      'Rebuilding it with different content is what announces the change. '
      '`liveRegion` is what makes that announcement interrupt, rather than '
      'wait to be found.',
    ),
    const DocHeading('The job it is not for'),
    const DocProse(
      'In React, hidden text inside a button is how the button gets its '
      'accessible name. Flutter has a better answer, and using this widget for '
      'it produces a control with an empty name and a stray label loose in the '
      'tree beside it.',
    ),
    const DocCode('''
// Wrong — a hidden label is not how a control is named.
AstryxIconButton(
  icon: AstryxIconName.close,
  label: '',
  onPressed: _close,
)

// Right — the name is a parameter, and it is required.
AstryxIconButton(
  icon: AstryxIconName.close,
  label: 'Close',
  onPressed: _close,
)'''),
    const DocProse(
      'Every control in the package takes its accessible name directly: '
      '`label` on [AstryxButton](button) and [AstryxIconButton](icon_button), '
      '`label` on [AstryxField](field) and on every input. Where a name has to '
      'be kept but not shown, that is `labelHidden` on the control itself — '
      '[AstryxTextInput](text_input), [AstryxCheckbox](checkbox), '
      '[AstryxSwitch](switch), [AstryxSelector](selector) and '
      '[AstryxTable](table) all have one.',
    ),
    const DocCallout.accessibility(
      'A live region interrupts whatever is being read. Reserve it for changes '
      'the user must hear — an error, a destructive result, a limit reached. '
      'Progress that merely happens should not talk over the thing the reader '
      'is trying to listen to. See [Accessibility](accessibility).',
    ),
    const DocHeading('It occupies no space'),
    const DocProse(
      'The hidden child below sits between the two badges, and the row is laid '
      'out exactly as it would be without it.',
    ),
    const DocExample('visually_hidden_space', align: DocExampleAlign.start),
    const DocProse(
      'A zero-sized box around a fully transparent child — not an `Offstage`, '
      'and not a `Visibility`. Both of those drop the subtree from the '
      'semantics tree as well as from the screen, which is the opposite of the '
      'point, and a plain `Opacity` would too: `alwaysIncludeSemantics` is '
      'what keeps the content readable. A test pins the size at `Size.zero` '
      'and the label in the tree.',
    ),
    DocApi('AstryxVisuallyHidden', _visuallyHiddenProps),
    const DocHeading('Related'),
    const DocList(<String>[
      '[Accessibility](accessibility) — the announcement rules in full.',
      '[AstryxField](field) — labelling anything, including a control the '
          'package does not supply.',
      '[Migration](migration) — the other React and Material habits that do '
          'not carry over.',
    ]),
  ],
);

final List<DocProp> _visuallyHiddenProps = <DocProp>[
  const DocProp(
    'child',
    'Widget',
    'The content to announce but not paint.',
    required: true,
  ),
  const DocProp(
    'liveRegion',
    'bool',
    'Whether a change to the content is announced as it happens, '
        'interrupting.',
    defaultValue: 'false',
  ),
];
