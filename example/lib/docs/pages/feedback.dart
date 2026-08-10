import 'package:example/docs/model.dart';

/// The status indicators.
final List<DocPage> feedbackPages = <DocPage>[_spinner, _skeleton, _progress];

const String _group = 'Status';

final DocPage _spinner = DocPage(
  id: 'spinner',
  title: 'AstryxSpinner',
  group: _group,
  description: 'An indeterminate wait, in three sizes.',
  source: 'lib/src/components/feedback/spinner.dart',
  upstream: 'Spinner',
  blocks: <DocBlock>[
    const DocExample('spinner_demo'),
    const DocHeading('Usage'),
    const DocCode("const AstryxSpinner(label: 'Loading projects')"),
    const DocProse(
      'Reach for a spinner when the wait has no measurable extent. When it '
      'does, [AstryxProgressBar](progress_bar) says more; when the shape of '
      'what is arriving is known, [AstryxSkeleton](skeleton) says more still.',
    ),
    const DocHeading('Sizes'),
    const DocProse('Diameter and stroke width move together.'),
    const DocExample('spinner_sizes'),
    const DocHeading('Shades'),
    const DocProse(
      '`inherit` takes the colour from the enclosing text or icon theme, which '
      'is what a button uses so the spinner matches the label it replaced.',
    ),
    const DocExample('spinner_shades'),
    const DocHeading('Inside a control'),
    const DocProse(
      'Rarely place one by hand. `loading: true` on either button installs a '
      'spinner at the right size and colour, and keeps the control’s width so '
      'the layout does not jump.',
    ),
    const DocExample('spinner_in_button'),
    const DocCallout.accessibility(
      '`label` is announced, and defaults to a localised "Loading" string. Set '
      'it to null *only* when a surrounding container already announces the '
      'wait — two live regions competing is worse than one.',
    ),
    const DocCallout.note(
      'Under `prefers-reduced-motion` the spinner stops rotating and paints a '
      'complete ring instead, so the state is still legible without the '
      'movement.',
    ),
    DocApi('AstryxSpinner', _spinnerProps),
  ],
);

final List<DocProp> _spinnerProps = <DocProp>[
  const DocProp(
    'size',
    'AstryxSpinnerSize',
    'The diameter and stroke width: `sm` 10px, `md` 14px, `lg` 18px.',
    defaultValue: 'AstryxSpinnerSize.md',
  ),
  const DocProp(
    'shade',
    'AstryxSpinnerShade',
    'How prominent the spinner is: `accent`, `subtle`, `onMedia` or `inherit`.',
    defaultValue: 'AstryxSpinnerShade.accent',
  ),
  const DocProp(
    'label',
    'String?',
    'What is being waited for, announced to assistive technology. Null uses '
        'the localised default.',
  ),
  const DocProp(
    'color',
    'Color?',
    'Overrides the colour the `shade` resolves to.',
  ),
];

final DocPage _skeleton = DocPage(
  id: 'skeleton',
  title: 'AstryxSkeleton',
  group: _group,
  description: 'A placeholder in the shape of the content that is coming.',
  source: 'lib/src/components/feedback/skeleton.dart',
  upstream: 'Skeleton',
  blocks: <DocBlock>[
    const DocExample('skeleton_demo'),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxVStack(
  gap: AstryxSpacingToken.spacing2,
  align: AstryxStackAlign.stretch,
  children: <Widget>[
    AstryxSkeleton.text(),
    AstryxSkeleton.text(),
    AstryxSkeleton.text(widthFactor: 0.6),
  ],
)'''),
    const DocHeading('Shapes'),
    const DocProse(
      'Three constructors: the default rectangle, `.text()` for a line of '
      'copy, and `.circle()` for an avatar. `widthFactor` shortens a text line '
      '— a paragraph’s last line is rarely full width, and placeholders that '
      'are all the same length read as a table.',
    ),
    const DocExample('skeleton_shapes'),
    const DocHeading('Matching the real thing'),
    const DocProse(
      'A placeholder earns its place only when it has the shape of what '
      'arrives. Mirror the real card’s slots; a generic grey box is a worse '
      'answer than a spinner.',
    ),
    const DocExample('skeleton_card'),
    const DocHeading('The delay'),
    const DocProse(
      'The block is visible immediately; only the pulse waits — 250ms by '
      'default. Content that loads quickly should not flash an animation on '
      'its way past.',
    ),
    const DocExample('skeleton_delay'),
    const DocCallout.accessibility(
      'A skeleton is decoration and is hidden from assistive technology. '
      'Announce the wait once, at the container — a screen reader reading '
      'twelve "loading" boxes has been told nothing twelve times.',
    ),
    DocApi('AstryxSkeleton', _skeletonProps),
  ],
);

final List<DocProp> _skeletonProps = <DocProp>[
  const DocProp(
    'width',
    'double?',
    'A fixed width. Null fills the available space. Default constructor only.',
  ),
  const DocProp(
    'widthFactor',
    'double?',
    'The fraction of the available width to fill. `AstryxSkeleton.text` only.',
  ),
  const DocProp(
    'height',
    'double',
    'The height.',
    defaultValue: '16 (14 for `.text`)',
  ),
  const DocProp(
    'radius',
    'AstryxRadiusToken',
    'The corner radius token.',
    defaultValue: 'AstryxRadiusToken.inner',
  ),
  const DocProp(
    'delay',
    'Duration',
    'How long to wait before the pulse begins.',
    defaultValue: 'Duration(milliseconds: 250)',
  ),
];

final DocPage _progress = DocPage(
  id: 'progress_bar',
  title: 'AstryxProgressBar',
  group: _group,
  description: 'A determinate or indeterminate bar, with an announced label.',
  source: 'lib/src/components/feedback/progress_bar.dart',
  upstream: 'ProgressBar',
  blocks: <DocBlock>[
    const DocExample('progress_demo'),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxProgressBar(
  label: 'Uploading footage.mov',
  value: 0.62,
  showValueLabel: true,
)'''),
    const DocProse(
      '`value` is a fraction from 0 to 1, not upstream’s `value`/`max` pair: '
      'two numbers that must agree is a bug waiting to happen, and the caller '
      'already knows how to divide.',
    ),
    const DocHeading('Variants'),
    const DocExample('progress_variants'),
    const DocHeading('Indeterminate'),
    const DocProse(
      'A null `value` means "in progress, extent unknown". Under reduced '
      'motion the fill stops travelling — the bar stays, the animation does '
      'not.',
    ),
    const DocExample('progress_indeterminate'),
    const DocHeading('Labels'),
    const DocProse(
      '`showLabel: false` hides the text without taking the accessible name '
      'away. `formatValue` replaces the percentage with something more '
      'meaningful — "18 of 24 seats" beats "75%".',
    ),
    const DocExample('progress_labels'),
    const DocHeading('In motion'),
    const DocExample('progress_live'),
    const DocCallout.accessibility(
      'The bar is announced with its label and its percentage, and the value '
      'is published to assistive technology as it changes. Colour alone never '
      'carries the outcome: pair a `success` or `error` variant with text.',
    ),
    DocApi('AstryxProgressBar', _progressProps),
  ],
);

final List<DocProp> _progressProps = <DocProp>[
  const DocProp(
    'label',
    'String',
    'What is progressing. Always the accessible name, shown or not.',
    required: true,
  ),
  const DocProp(
    'value',
    'double?',
    'Progress from 0 to 1, or null for indeterminate.',
  ),
  const DocProp(
    'variant',
    'AstryxProgressVariant',
    'What the fill colour means: `accent`, `success`, `warning`, `error` or '
        '`neutral`.',
    defaultValue: 'AstryxProgressVariant.accent',
  ),
  const DocProp(
    'showLabel',
    'bool',
    'Whether to render the label above the track.',
    defaultValue: 'true',
  ),
  const DocProp(
    'showValueLabel',
    'bool',
    'Whether to render the percentage beside the label.',
    defaultValue: 'false',
  ),
  const DocProp(
    'formatValue',
    'String Function(double)?',
    'Formats the value label. Defaults to a whole percentage.',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the bar reads as active.',
    defaultValue: 'true',
  ),
];
