import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// The form controls, and the field wrapper they share.
final List<DocPage> formPages = <DocPage>[
  _field,
  _textInput,
  _textArea,
  _checkbox,
  _checkboxList,
  _radioList,
  _switch,
  _selector,
  _numberInput,
  _fileInput,
  _slider,
  _multiSelector,
  _complexSelector,
  _inputGroup,
  _formLayout,
];

const String _group = DocGroup.forms;

/// Every form control takes these. Repeated per page rather than cross-linked,
/// because a reference table you have to leave to read is not a reference.
List<DocProp> _fieldProps({bool labelRequired = false}) => <DocProp>[
  DocProp(
    'label',
    labelRequired ? 'String' : 'String?',
    'The field’s name, shown above the control and used as its accessible '
        'name.',
    required: labelRequired,
  ),
  const DocProp(
    'description',
    'String?',
    'Helper text between the label and the control.',
  ),
  const DocProp(
    'status',
    'AstryxFieldStatus?',
    'The validation state, shown below the control.',
  ),
  const DocProp(
    'required',
    'bool',
    'Whether the field must be filled in. Shows a marker *and* sets the '
        'semantics flag.',
    defaultValue: 'false',
  ),
  const DocProp(
    'optional',
    'bool',
    'Marks the field optional. Mutually exclusive with `required`.',
    defaultValue: 'false',
  ),
  const DocProp(
    'enabled',
    'bool',
    'Whether the field accepts input.',
    defaultValue: 'true',
  ),
  const DocProp(
    'labelHidden',
    'bool',
    'Hides the label visually. It still names the control.',
    defaultValue: 'false',
  ),
];

const DocPage _field = DocPage(
  id: 'field',
  title: 'AstryxField',
  group: _group,
  description:
      'Gives any control a label, a description, a required marker and a '
      'validation message.',
  source: 'lib/src/components/forms/field.dart',
  upstream: 'Field / FieldLabel / FieldStatus',
  upstreamPath: '/components/Field',
  blocks: <DocBlock>[
    DocExample('field_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxField(
  label: 'Monthly budget',
  description: 'Alerts fire at 80% of this.',
  required: true,
  child: mySlider,
)'''),
    DocProse(
      'The built-in controls already take `label`, `description`, `status` and '
      'the rest — they wrap themselves in a field. Reach for `AstryxField` '
      'directly when the control is *yours*: a slider, a colour picker, a '
      'date range, anything the design system has no widget for.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxField
├── label      ← plus the Required / Optional marker
├── description
├── child      ← your control, inside an AstryxFieldScope
└── status     ← icon and message, announced'''),
    DocHeading('The scope'),
    DocProse(
      'A field publishes itself through `AstryxFieldScope`, and every built-in '
      'control reads it. So `enabled` and `status` set on the field reach the '
      'controls inside it without being passed down by hand.',
    ),
    DocExample('field_scope', align: DocExampleAlign.start),
    DocHeading('Markers'),
    DocProse(
      'Mark whichever is the exception in your form. Marking every field as '
      'required says nothing at all.',
    ),
    DocExample('field_markers', align: DocExampleAlign.start),
    DocHeading('Statuses'),
    DocProse(
      '`AstryxFieldStatus` has three types and a message. A null message '
      'colours the control and shows its icon without adding text — for a '
      'field whose problem is described elsewhere, such as a summary at the '
      'top of the form.',
    ),
    DocExample('field_statuses', align: DocExampleAlign.start),
    DocTable(
      headers: <String>['Constructor', 'Type', 'Announced'],
      rows: <List<String>>[
        <String>[
          '`AstryxFieldStatus.error(message)`',
          'error',
          '**assertively** — it blocks the user',
        ],
        <String>[
          '`AstryxFieldStatus.warning(message)`',
          'warning',
          'politely',
        ],
        <String>[
          '`AstryxFieldStatus.success(message)`',
          'success',
          'politely',
        ],
      ],
    ),
    DocCallout.accessibility(
      'The description *and* the status message both become the control’s '
      'hint, joined rather than one winning: both matter to a screen-reader '
      'user, and neither is reachable any other way.',
    ),
    DocApi('AstryxField', <DocProp>[
      DocProp(
        'label',
        'String',
        'The field’s name.',
        required: true,
      ),
      DocProp(
        'child',
        'Widget',
        'The control this field describes.',
        required: true,
      ),
      DocProp('description', 'String?', 'Helper text.'),
      DocProp('status', 'AstryxFieldStatus?', 'The validation state.'),
      DocProp(
        'required',
        'bool',
        'Whether the field must be filled in.',
        defaultValue: 'false',
      ),
      DocProp(
        'optional',
        'bool',
        'Marks the field optional.',
        defaultValue: 'false',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the field accepts input.',
        defaultValue: 'true',
      ),
      DocProp(
        'labelHidden',
        'bool',
        'Hides the label visually.',
        defaultValue: 'false',
      ),
      DocProp(
        'width',
        'double?',
        'A fixed width. Null fills the available space.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTextInput](text_input) — a control that wraps itself in a field.',
      '[AstryxSelector](selector) — likewise.',
    ]),
  ],
);

final DocPage _textInput = DocPage(
  id: 'text_input',
  title: 'AstryxTextInput',
  group: _group,
  description: 'A single-line or multi-line text field, with validation.',
  source: 'lib/src/components/forms/text_input.dart',
  upstream: 'TextInput',
  upstreamPath: '/components/TextInput',
  blocks: <DocBlock>[
    const DocExample('text_input_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxTextInput(
  label: 'Workspace name',
  controller: _controller,
  placeholder: 'Acme Internal Tools',
  description: 'Shown to everyone you invite.',
)'''),
    const DocProse(
      'A `label` wraps the input in an [AstryxField](field) for you. Pass null '
      'to omit the wrapper entirely — for an input inside something that '
      'labels it another way, a table cell or a toolbar.',
    ),
    const DocCallout.note(
      'Bring a `TextEditingController` for anything but a throwaway field. '
      'Without one the widget owns an internal controller and disposes it '
      'itself, which is convenient and unreadable from outside.',
    ),
    const DocHeading('Sizes'),
    const DocProse(
      'The three control heights. A null `size` inherits from an enclosing '
      '`AstryxSizeScope`, the same cascade the buttons use.',
    ),
    const DocExample('text_input_sizes', align: DocExampleAlign.start),
    const DocHeading('Validation'),
    const DocProse(
      'A status draws an inset ring in its colour, shows its icon in the '
      'trailing slot, and prints its message below — announced, not merely '
      'coloured.',
    ),
    const DocExample('text_input_validation', align: DocExampleAlign.start),
    const DocHeading('Affordances'),
    const DocProse(
      '`leading` and `trailing` take any widget. `showClear` adds a clear '
      'button that appears only when there is something to clear, and sits '
      'before the status icon.',
    ),
    const DocExample('text_input_affordances', align: DocExampleAlign.start),
    const DocHeading('Formatters'),
    const DocProse(
      'The Flutter text-input machinery is exposed rather than wrapped: '
      '`inputFormatters`, `keyboardType`, `textInputAction`, `autofillHints` '
      'and `maxLength` all behave exactly as they do on `EditableText`.',
    ),
    const DocExample('text_input_formatters', align: DocExampleAlign.start),
    const DocHeading('States'),
    const DocProse(
      'Read-only is not disabled. A read-only value still means something and '
      'is still selectable and copyable — it is simply not yours to change '
      'here — so it is not dimmed.',
    ),
    const DocExample('text_input_states', align: DocExampleAlign.start),
    const DocHeading('Multi-line'),
    const DocProse(
      '`AstryxTextInput.multiline` grows from `minLines` to `maxLines`, then '
      'scrolls. [AstryxTextArea](text_area) is the friendlier name for the '
      'same control.',
    ),
    const DocExample('text_input_multiline', align: DocExampleAlign.start),
    const DocCallout.accessibility(
      'The selection handles and the context menu are themed from the same '
      'tokens as everything else, and the toolbar’s labels are localised '
      'through `AstryxLocalizations`.',
    ),
    DocApi('AstryxTextInput', <DocProp>[
      ..._fieldProps(),
      const DocProp(
        'controller',
        'TextEditingController?',
        'The text being edited.',
      ),
      const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
      const DocProp(
        'onChanged',
        'ValueChanged<String>?',
        'Called whenever the text changes.',
      ),
      const DocProp(
        'onSubmitted',
        'ValueChanged<String>?',
        'Called when the user submits from the keyboard.',
      ),
      const DocProp(
        'placeholder',
        'String?',
        'Text shown when the field is empty.',
      ),
      const DocProp('size', 'AstryxInputSize?', 'The control height.'),
      const DocProp(
        'readOnly',
        'bool',
        'Whether the value can be read but not changed.',
        defaultValue: 'false',
      ),
      const DocProp(
        'obscureText',
        'bool',
        'Whether to hide the value, as for a password.',
        defaultValue: 'false',
      ),
      const DocProp(
        'showClear',
        'bool',
        'Whether to show a button that clears the value.',
        defaultValue: 'false',
      ),
      const DocProp('leading', 'Widget?', 'Content before the text.'),
      const DocProp(
        'trailing',
        'Widget?',
        'Content after the text, before the clear and status icons.',
      ),
      const DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
      const DocProp(
        'keyboardType',
        'TextInputType?',
        'The keyboard to request.',
      ),
      const DocProp(
        'textInputAction',
        'TextInputAction?',
        'What the keyboard’s action key does.',
      ),
      const DocProp(
        'inputFormatters',
        'List<TextInputFormatter>?',
        'Formatters applied as the user types.',
      ),
      const DocProp(
        'autofillHints',
        'Iterable<String>?',
        'Autofill hints, so the platform can offer to fill the field.',
      ),
      const DocProp('maxLength', 'int?', 'The maximum number of characters.'),
      const DocProp('width', 'double?', 'A fixed width.'),
      const DocProp(
        'minLines',
        'int',
        'The minimum visible lines. `.multiline` only.',
        defaultValue: '3',
      ),
      const DocProp(
        'maxLines',
        'int',
        'The maximum visible lines before scrolling. `.multiline` only.',
        defaultValue: '6',
      ),
    ]),
  ],
);

final DocPage _textArea = DocPage(
  id: 'text_area',
  title: 'AstryxTextArea',
  group: _group,
  description: 'A multi-line text field that grows with its content.',
  source: 'lib/src/components/forms/text_input.dart',
  upstream: 'TextArea',
  upstreamPath: '/components/TextArea',
  blocks: <DocBlock>[
    const DocExample('text_area_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
const AstryxTextArea(
  label: 'Notes',
  optional: true,
  placeholder: 'What happened?',
)'''),
    const DocProse(
      'The same control as `AstryxTextInput.multiline`, under the name people '
      'look for. It carries a narrower surface: no `obscureText`, no '
      '`showClear`, no keyboard action — none of which mean anything for a '
      'paragraph.',
    ),
    const DocHeading('Lines'),
    const DocExample('text_area_lines', align: DocExampleAlign.start),
    const DocHeading('Counting characters'),
    const DocProse(
      '`maxLength` stops the input; the count and the warning are yours to '
      'render, because where they belong depends on the form.',
    ),
    const DocExample('text_area_counted', align: DocExampleAlign.start),
    DocApi('AstryxTextArea', <DocProp>[
      ..._fieldProps(),
      const DocProp(
        'controller',
        'TextEditingController?',
        'The text being edited.',
      ),
      const DocProp('focusNode', 'FocusNode?', 'The focus node.'),
      const DocProp(
        'onChanged',
        'ValueChanged<String>?',
        'Called whenever the text changes.',
      ),
      const DocProp('placeholder', 'String?', 'Text shown when empty.'),
      const DocProp('size', 'AstryxInputSize?', 'The control height step.'),
      const DocProp(
        'readOnly',
        'bool',
        'Whether the value can be read but not changed.',
        defaultValue: 'false',
      ),
      const DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
      const DocProp('maxLength', 'int?', 'The maximum number of characters.'),
      const DocProp('width', 'double?', 'A fixed width.'),
      const DocProp(
        'minLines',
        'int',
        'The minimum number of visible lines.',
        defaultValue: '3',
      ),
      const DocProp(
        'maxLines',
        'int',
        'The maximum number of visible lines before scrolling.',
        defaultValue: '6',
      ),
    ]),
  ],
);

const DocPage _checkbox = DocPage(
  id: 'checkbox',
  title: 'AstryxCheckbox',
  group: _group,
  description: 'A two-state or three-state checkbox with a required label.',
  source: 'lib/src/components/forms/checkbox.dart',
  upstream: 'CheckboxInput',
  upstreamPath: '/components/CheckboxInput',
  blocks: <DocBlock>[
    DocExample('checkbox_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxCheckbox(
  label: 'Accept the terms of service',
  value: _accepted,
  onChanged: (value) => setState(() => _accepted = value),
)'''),
    DocCallout.accessibility(
      '`label` is required — unlike on most controls, and for the same reason '
      'upstream requires it: an unlabelled checkbox is unusable with a screen '
      'reader. Use `labelHidden` when the label would be redundant to a '
      'sighted user; the name survives.',
    ),
    DocHeading('Indeterminate'),
    DocProse(
      '`AstryxCheckbox.tristate` takes an `AstryxCheckboxValue` instead of a '
      'bool. Indeterminate is what a parent looks like when only some of its '
      'children are on; pressing it resolves to checked, matching both the '
      'HTML behaviour and the expectation that pressing a half-filled "select '
      'all" selects all.',
    ),
    DocExample('checkbox_tristate', align: DocExampleAlign.start),
    DocTable(
      headers: <String>['Value', 'Box', 'Pressing it gives'],
      rows: <List<String>>[
        <String>['`unchecked`', 'empty', '`checked`'],
        <String>['`checked`', 'filled, tick', '`unchecked`'],
        <String>['`indeterminate`', 'filled, dash', '`checked`'],
      ],
    ),
    DocHeading('Sizes'),
    DocExample('checkbox_sizes', align: DocExampleAlign.start),
    DocHeading('States'),
    DocProse(
      'A null `onChanged` makes the checkbox non-interactive **without dimming '
      'it** — for a box reflecting state the user changes elsewhere. '
      '`readOnly` says the same thing more loudly; `enabled: false` is the one '
      'that dims.',
    ),
    DocExample('checkbox_states', align: DocExampleAlign.start),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves focus to the checkbox.'],
        <String>['`Space`', 'Toggles it, as on the native control.'],
        <String>[
          '`Enter`',
          'Deliberately nothing — in a form, Enter submits, and a checkbox '
              'that swallows it breaks that.',
        ],
      ],
    ),
    DocApi('AstryxCheckbox', <DocProp>[
      DocProp(
        'label',
        'String',
        'The visible text, and the accessible name. Required.',
        required: true,
      ),
      DocProp(
        'value',
        'bool / AstryxCheckboxValue',
        'The current state. A bool on the default constructor, an '
            '`AstryxCheckboxValue` on `.tristate`.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<bool>? / ValueChanged<AstryxCheckboxValue>?',
        'Called with the state a press would produce. Null is '
            'non-interactive but not dimmed.',
      ),
      DocProp('description', 'String?', 'Helper text below the label.'),
      DocProp('status', 'AstryxFieldStatus?', 'The validation state.'),
      DocProp(
        'size',
        'AstryxToggleSize',
        'The control size: `sm` is 20px, `md` 24px.',
        defaultValue: 'AstryxToggleSize.md',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the control accepts interaction.',
        defaultValue: 'true',
      ),
      DocProp(
        'readOnly',
        'bool',
        'Shown but not changeable. Does not dim.',
        defaultValue: 'false',
      ),
      DocProp(
        'loading',
        'bool',
        'Whether a change is in flight, which shows a spinner in the box.',
        defaultValue: 'false',
      ),
      DocProp(
        'labelHidden',
        'bool',
        'Hides the label visually.',
        defaultValue: 'false',
      ),
      DocProp('focusNode', 'FocusNode?', 'The focus node.'),
      DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxSwitch](switch) — for a setting that applies immediately.',
      '[AstryxRadioList](radio_list) — for one choice out of several.',
    ]),
  ],
);

final DocPage _radioList = DocPage(
  id: 'radio_list',
  title: 'AstryxRadioList',
  group: _group,
  description: 'One choice out of several, as an ARIA radio group.',
  source: 'lib/src/components/forms/radio_list.dart',
  upstream: 'RadioList / RadioListItem',
  upstreamPath: '/components/RadioList',
  blocks: <DocBlock>[
    const DocExample('radio_list_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxRadioList<Plan>(
  label: 'Plan',
  value: _plan,
  onChanged: (value) => setState(() => _plan = value),
  options: const <AstryxRadioOption<Plan>>[
    AstryxRadioOption(value: Plan.free, label: 'Free'),
    AstryxRadioOption(value: Plan.pro, label: 'Pro'),
  ],
)'''),
    const DocProse(
      'The group is one tab stop, not one per option — which is what makes it '
      'a radio group rather than a list of radios. Arrows move *and* select, '
      'and they wrap, so a user never has to reverse.',
    ),
    const DocHeading('Orientation'),
    const DocProse(
      'Horizontal suits two or three short labels and nothing longer.',
    ),
    const DocExample('radio_list_horizontal', align: DocExampleAlign.start),
    const DocHeading('Validation'),
    const DocProse(
      'A null `value` is a group with nothing chosen — where a required group '
      'starts, and what its error message is for.',
    ),
    const DocExample('radio_list_validation', align: DocExampleAlign.start),
    const DocHeading('Sizes'),
    const DocExample('radio_list_sizes', align: DocExampleAlign.start),
    const DocHeading('Disabled'),
    const DocProse(
      '`enabled: false` on the group disables every option; '
      '`AstryxRadioOption.enabled` disables one.',
    ),
    const DocExample('radio_list_disabled', align: DocExampleAlign.start),
    const DocHeading('Keyboard'),
    const DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>[
          '`Tab`',
          'Enters the group, or leaves it — one stop, not one '
              'per option.',
        ],
        <String>['`↓` / `→`', 'Selects the next enabled option, wrapping.'],
        <String>[
          '`↑` / `←`',
          'Selects the previous one, wrapping. Mirrored '
              'under RTL.',
        ],
        <String>['`Space`', 'Selects the focused option.'],
      ],
    ),
    const DocCallout.accessibility(
      'An empty group still has to put focus somewhere when it is tabbed into. '
      'It goes to the first enabled option, which is what the ARIA pattern '
      'says — not to the first option regardless.',
    ),
    DocApi('AstryxRadioList', <DocProp>[
      const DocProp(
        'options',
        'List<AstryxRadioOption<T>>',
        'The options, in the order they are shown and traversed.',
        required: true,
      ),
      const DocProp(
        'value',
        'T?',
        'The selected value, or null for no selection.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<T>?',
        'Called with the newly selected value.',
      ),
      ..._fieldProps(),
      const DocProp(
        'size',
        'AstryxToggleSize',
        'The control size.',
        defaultValue: 'AstryxToggleSize.md',
      ),
      const DocProp(
        'orientation',
        'AstryxRadioListOrientation',
        'Which way the options run.',
        defaultValue: 'AstryxRadioListOrientation.vertical',
      ),
      const DocProp('focusNode', 'FocusNode?', 'The focus node for the group.'),
      const DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
    ]),
    const DocApi('AstryxRadioOption', <DocProp>[
      DocProp(
        'value',
        'T',
        'What selecting this option produces.',
        required: true,
      ),
      DocProp(
        'label',
        'String',
        'The visible text, and this option’s accessible name.',
        required: true,
      ),
      DocProp('description', 'String?', 'Helper text below the label.'),
      DocProp(
        'enabled',
        'bool',
        'Whether this option can be chosen.',
        defaultValue: 'true',
      ),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxSelector](selector) — the same choice, collapsed into a '
          'dropdown. Past about seven options, prefer it.',
    ]),
  ],
);

const DocPage _switch = DocPage(
  id: 'switch',
  title: 'AstryxSwitch',
  group: _group,
  description: 'A setting that takes effect the moment it is flipped.',
  source: 'lib/src/components/forms/switch.dart',
  upstream: 'Switch',
  upstreamPath: '/components/Switch',
  blocks: <DocBlock>[
    DocExample('switch_demo', align: DocExampleAlign.start),
    DocHeading('Usage'),
    DocCode('''
AstryxSwitch(
  label: 'Email notifications',
  description: 'Applies immediately.',
  value: _enabled,
  onChanged: (value) => setState(() => _enabled = value),
)'''),
    DocCallout.note(
      'A switch means **applies now**. A checkbox means *will apply when you '
      'submit*. Putting a switch in a form with a Save button asks the user to '
      'guess which one you meant.',
    ),
    DocHeading('In a settings list'),
    DocProse(
      '`labelPosition: start` with `labelSpacing: spread` gives the settings '
      'row shape: label at the reading edge, control at the trailing one.',
    ),
    DocExample('switch_settings_list', align: DocExampleAlign.start),
    DocHeading('Sizes'),
    DocProse(
      'The thumb grows when the switch is on — upstream’s own behaviour, and '
      'what makes the on state legible without relying on the track colour '
      'alone.',
    ),
    DocExample('switch_sizes', align: DocExampleAlign.start),
    DocHeading('States'),
    DocExample('switch_states', align: DocExampleAlign.start),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Space`', 'Toggles it.'],
        <String>['`→`', 'Turns it on. Mirrored under RTL.'],
        <String>['`←`', 'Turns it off. Mirrored under RTL.'],
      ],
    ),
    DocApi('AstryxSwitch', <DocProp>[
      DocProp(
        'label',
        'String',
        'The visible text, and the accessible name.',
        required: true,
      ),
      DocProp(
        'value',
        'bool',
        'Whether the switch is on.',
        required: true,
      ),
      DocProp(
        'onChanged',
        'ValueChanged<bool>?',
        'Called with the state a press would produce.',
      ),
      DocProp('description', 'String?', 'Helper text below the label.'),
      DocProp('status', 'AstryxFieldStatus?', 'The validation state.'),
      DocProp(
        'size',
        'AstryxToggleSize',
        'The control size.',
        defaultValue: 'AstryxToggleSize.md',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the control accepts input.',
        defaultValue: 'true',
      ),
      DocProp(
        'readOnly',
        'bool',
        'Shown but not changeable. Does not dim.',
        defaultValue: 'false',
      ),
      DocProp(
        'loading',
        'bool',
        'Whether a change is in flight, which shows a spinner in the thumb.',
        defaultValue: 'false',
      ),
      DocProp(
        'labelHidden',
        'bool',
        'Hides the label visually.',
        defaultValue: 'false',
      ),
      DocProp(
        'labelPosition',
        'AstryxToggleLabelPosition',
        'Which side the label sits on.',
        defaultValue: 'AstryxToggleLabelPosition.end',
      ),
      DocProp(
        'labelSpacing',
        'AstryxToggleLabelSpacing',
        'Whether the row hugs its contents or spreads them.',
        defaultValue: 'AstryxToggleLabelSpacing.hug',
      ),
      DocProp('focusNode', 'FocusNode?', 'The focus node.'),
      DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
    ]),
  ],
);

final DocPage _selector = DocPage(
  id: 'selector',
  title: 'AstryxSelector',
  group: _group,
  description: 'A dropdown that picks one value, with optional search.',
  source: 'lib/src/components/forms/selector.dart',
  upstream: 'Selector / SelectorOption',
  upstreamPath: '/components/Selector',
  blocks: <DocBlock>[
    const DocExample('selector_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxSelector<String>(
  label: 'Owner',
  value: _owner,
  onChanged: (value) => setState(() => _owner = value),
  options: const <AstryxSelectorEntry<String>>[
    AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
    AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
  ],
)'''),
    const DocProse(
      'Note the `onChanged` signature: `ValueChanged<T?>`, because clearing '
      'the selection is a change too. The trigger is the same input container '
      'as [AstryxTextInput](text_input), so a selector and a text field in the '
      'same form line up exactly.',
    ),
    const DocHeading('Composition'),
    const DocProse(
      'The list takes three kinds of entry. Sections and dividers are skipped '
      'by the keyboard, so arrowing never lands on one.',
    ),
    const DocTree('''
AstryxSelector
├── trigger              ← the input container, showing the value
└── list                 ← an anchored overlay
    ├── search           ← when showSearch is true
    ├── AstryxSelectorSection('Engineering')
    ├── AstryxSelectorOption(value: …, label: …)
    ├── AstryxSelectorDivider()
    └── AstryxSelectorOption(value: …, label: …)'''),
    const DocExample('selector_sections', align: DocExampleAlign.start),
    const DocHeading('Search'),
    const DocProse(
      'Worth turning on past roughly a dozen options. Below that it is a box '
      'to tab past for no gain.',
    ),
    const DocExample('selector_search', align: DocExampleAlign.start),
    const DocHeading('Icons'),
    const DocProse(
      '`leading` sits in the trigger; `AstryxSelectorOption.icon` sits in the '
      'row. Both take any widget.',
    ),
    const DocExample('selector_icons', align: DocExampleAlign.start),
    const DocHeading('States'),
    const DocExample('selector_states', align: DocExampleAlign.start),
    const DocHeading('Keyboard'),
    const DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Enter` / `Space` / `↓`', 'Opens the list.'],
        <String>[
          '`↑` / `↓`',
          'Moves the highlight without choosing anything, wrapping.',
        ],
        <String>['`Home` / `End`', 'Jumps to the first or last option.'],
        <String>[
          'a letter',
          'Jumps to the first option starting with what you typed. The buffer '
              'resets after a second of silence.',
        ],
        <String>['`Enter`', 'Chooses the highlighted option and closes.'],
        <String>['`Escape`', 'Closes the list — and only the list.'],
      ],
    ),
    const DocCallout.note(
      'The list is at most `maxListHeight` tall, and the positioner may shrink '
      'it further to fit the viewport. It flips above the trigger when there '
      'is no room below.',
    ),
    DocApi('AstryxSelector', <DocProp>[
      const DocProp(
        'options',
        'List<AstryxSelectorEntry<T>>',
        'The entries to show, in order.',
        required: true,
      ),
      const DocProp(
        'value',
        'T?',
        'The selected value, or null for none.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<T?>?',
        'Called with the newly chosen value, or null when it is cleared.',
      ),
      ..._fieldProps(),
      const DocProp(
        'placeholder',
        'String?',
        'Text shown when nothing is selected.',
      ),
      const DocProp('size', 'AstryxInputSize?', 'The trigger height.'),
      const DocProp(
        'showClear',
        'bool',
        'Whether to offer a button that clears the selection.',
        defaultValue: 'false',
      ),
      const DocProp(
        'showSearch',
        'bool',
        'Whether the list has a search box at the top.',
        defaultValue: 'false',
      ),
      const DocProp(
        'searchPlaceholder',
        'String?',
        'Placeholder for the search box.',
      ),
      const DocProp(
        'emptyLabel',
        'String?',
        'Text shown when the search matches nothing.',
      ),
      const DocProp(
        'leading',
        'Widget?',
        'Content before the value in the trigger.',
      ),
      const DocProp(
        'maxListHeight',
        'double',
        'The tallest the list may be before it scrolls.',
        defaultValue: '320',
      ),
      const DocProp('width', 'double?', 'A fixed width.'),
      const DocProp('focusNode', 'FocusNode?', 'The trigger’s focus node.'),
      const DocProp(
        'autofocus',
        'bool',
        'Whether to take focus when first built.',
        defaultValue: 'false',
      ),
    ]),
    const DocApi('AstryxSelectorOption', <DocProp>[
      DocProp(
        'value',
        'T',
        'What choosing this option produces.',
        required: true,
      ),
      DocProp(
        'label',
        'String',
        'The visible text, and this option’s accessible name.',
        required: true,
      ),
      DocProp('description', 'String?', 'Secondary text below the label.'),
      DocProp('icon', 'Widget?', 'An icon before the label.'),
      DocProp(
        'enabled',
        'bool',
        'Whether the option can be chosen.',
        defaultValue: 'true',
      ),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxRadioList](radio_list) — the same choice, all options visible.',
      '[AstryxDropdownMenu](dropdown_menu) — for *actions*, not for a value.',
    ]),
  ],
);

final DocPage _checkboxList = DocPage(
  id: 'checkbox_list',
  title: 'AstryxCheckboxList',
  group: _group,
  description:
      'A group of checkboxes sharing one label and one validation '
      'state.',
  source: 'lib/src/components/forms/checkbox_list.dart',
  upstream: 'CheckboxList / CheckboxListItem',
  upstreamPath: '/components/CheckboxList',
  blocks: <DocBlock>[
    const DocProse(
      'Several independent choices under one heading, one description and one '
      'validation state. That last part is the reason to reach for this rather '
      'than a column of [checkboxes](checkbox): "choose at least one region" '
      'is a complaint about the set, and repeating it on every row says it '
      'three times to a screen reader.',
    ),
    const DocExample('checkbox_list_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxCheckboxList<String>(
  label: 'Notify me about',
  values: _channels,
  onChanged: (values) => setState(() => _channels = values),
  options: const <AstryxCheckboxOption<String>>[
    AstryxCheckboxOption(value: 'email', label: 'Email'),
    AstryxCheckboxOption(value: 'sms', label: 'SMS'),
  ],
)'''),
    const DocProse(
      'Each change hands back a **new set**; the one passed in is never '
      'edited, so a `setState` that assigns it is enough. Upstream takes a '
      '`string[]`; this is generic over the value type, like '
      '[AstryxRadioList](radio_list) — an enum reads better than a string at a '
      'call site and cannot be misspelled.',
    ),
    const DocCallout.accessibility(
      'Each row is its own tab stop, and Space toggles the row that has focus. '
      'That is the ARIA checkbox pattern, and the **opposite** of '
      '[AstryxRadioList](radio_list), where the whole group is one stop and '
      'the arrows move within it. A checkbox group keyboarded as a radio group '
      'swallows Tab and traps anyone using one; a test pins the difference.',
    ),
    const DocHeading('Density and dividers'),
    const DocProse(
      'Compact takes the small control and tightens the rows. Dividers turn a '
      'set of options into a list of them — worth it when the rows carry '
      'trailing content of their own.',
    ),
    const DocExample('checkbox_list_density', align: DocExampleAlign.start),
    const DocProse(
      'A checked row is tinted with `--color-accent-muted`, as upstream tints '
      'it, and not when the row is disabled or read-only: a tint that survives '
      'those advertises an affordance the row does not have. The inset is paid '
      'either way, so nothing shifts sideways as rows are ticked.',
    ),
    const DocHeading('Validation'),
    const DocExample('checkbox_list_status', align: DocExampleAlign.start),
    const DocHeading('States'),
    const DocTable(
      headers: <String>['Set', 'Gets you'],
      rows: <List<String>>[
        <String>[
          '`enabled: false`',
          'The whole group refuses and dims. For one row, use the option’s own '
              '`enabled`.',
        ],
        <String>[
          '`readOnly: true`',
          'The values are shown at full strength and cannot be changed. Not '
              'dimmed — the values are the point.',
        ],
        <String>[
          'an option’s `loading`',
          'A spinner in place of that row’s control while something settles. '
              'Upstream drives this from a pending `changeAction`; here the '
              'caller owns it, as everywhere else in this package.',
        ],
        <String>[
          'an option’s `trailing`',
          'Content after the label — a badge, a count. Upstream’s '
              '`endContent`. Not part of the row’s accessible name, so put '
              'anything it *says* in the description too.',
        ],
      ],
    ),
    DocApi('AstryxCheckboxList', <DocProp>[
      const DocProp(
        'options',
        'List<AstryxCheckboxOption<T>>',
        'The rows, in order.',
        required: true,
      ),
      const DocProp(
        'values',
        'Set<T>',
        'The values currently checked.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<Set<T>>?',
        'Called with a new set. Null makes the group inert.',
      ),
      const DocProp(
        'density',
        'AstryxCheckboxListDensity',
        'How much room each row gets.',
        defaultValue: 'balanced',
      ),
      const DocProp(
        'dividers',
        'bool',
        'Whether to draw a rule between rows.',
        defaultValue: 'false',
      ),
      const DocProp(
        'readOnly',
        'bool',
        'Whether the selection can be read but not changed.',
        defaultValue: 'false',
      ),
      ..._fieldProps(),
    ]),
    const DocApi(
      'AstryxCheckboxOption',
      <DocProp>[
        DocProp(
          'value',
          'T',
          'What checking the row selects.',
          required: true,
        ),
        DocProp(
          'label',
          'String',
          'The visible text, and the row’s '
              'accessible name.',
          required: true,
        ),
        DocProp('description', 'String?', 'Helper text below the label.'),
        DocProp('trailing', 'Widget?', 'Content after the label.'),
        DocProp(
          'enabled',
          'bool',
          'Whether the row can be checked.',
          defaultValue: 'true',
        ),
        DocProp(
          'loading',
          'bool',
          'Whether the row is waiting on '
              'something.',
          defaultValue: 'false',
        ),
      ],
      description: 'One row.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxCheckbox](checkbox) — one independent choice.',
      '[AstryxRadioList](radio_list) — one choice among several, keyboarded '
          'the other way.',
      '[AstryxField](field) — the label, description and status this reuses.',
    ]),
  ],
);

final DocPage _numberInput = DocPage(
  id: 'number_input',
  title: 'AstryxNumberInput',
  group: _group,
  description: 'A numeric field with steppers, a range and unit text.',
  source: 'lib/src/components/forms/number_input.dart',
  upstream: 'NumberInput',
  upstreamPath: '/components/NumberInput',
  blocks: <DocBlock>[
    const DocProse(
      'A field that holds a number, with the two affordances a number wants: '
      'steppers, and a range it refuses to leave.',
    ),
    const DocExample('number_input_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxNumberInput(
  label: 'Replicas',
  value: _replicas,
  min: 1,
  max: 20,
  integerOnly: true,
  onChanged: (value) => setState(() => _replicas = value),
)'''),
    const DocProse(
      '`onChanged` fires when a value is **committed** — a stepper, an arrow '
      'key, or blur and Enter after typing — not on every keystroke, because '
      'half a number is not a number. It is a `num?`, so `integerOnly` gives '
      'you `int`s and a fractional `step` gives you `double`s without a second '
      'widget.',
    ),
    const DocCallout.warning(
      'Out-of-range typing is **rejected, not clamped**. Type 200 into a field '
      'whose `max` is 20 and the value does not move: the text reverts on blur '
      'and the refusal is announced. That is upstream’s `parseNumberInput`, '
      'which returns null rather than the nearest legal number — quietly '
      'changing what somebody typed is worse than declining it. Pressing a '
      'stepper *does* stop at the boundary, as a browser’s spinner does.',
    ),
    const DocHeading('Range, step and units'),
    const DocExample('number_input_range', align: DocExampleAlign.start),
    const DocProse(
      '`units` is a suffix inside the field. `steppers: false` removes the '
      'buttons for a field nobody increments one at a time — a year, an ID — '
      'and the arrow keys keep working. `showClear` gives a way back to null.',
    ),
    const DocHeading(
      'What a browser gave upstream, and what this had to build',
    ),
    const DocProse(
      'Upstream is an `<input type="number">`, so three of its behaviours are '
      'the browser’s rather than the design system’s. All three are here, '
      'written out:',
    ),
    const DocList(<String>[
      '**The arrow keys step the value.** Handled above the text field, so the '
          'arrows are seen before the caret takes them.',
      '**The steppers are drawn.** A UA spinner appears on hover in a browser; '
          'nothing important may live behind hover here, and a thumb has no '
          'arrow keys. They are on by default and can be turned off.',
      '**Letters are refused as they are typed**, by an input formatter, '
          'rather than accepted and rejected later.',
    ]),
    const DocProse(
      'What is *not* ported is the mouse wheel changing a focused field’s '
      'value. Upstream inherits it from the native control; a wheel that '
      'silently edits a number under a scrolling page is a hazard worth '
      'losing.',
    ),
    const DocCallout.accessibility(
      'A rejected entry is announced through a live region — see '
      '[AstryxVisuallyHidden](visually_hidden). Reverting in silence leaves a '
      'screen-reader user with no idea their entry was thrown away, which is '
      'WCAG 3.3.1, and it is the one thing a hand-built number field almost '
      'always misses. The steppers carry names of their own — "Increase '
      'Replicas" — and disable themselves at the ends of the range.',
    ),
    DocApi('AstryxNumberInput', <DocProp>[
      const DocProp(
        'value',
        'num?',
        'The committed value, or null for an empty field.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<num?>?',
        'Called with a newly committed value, or null when cleared.',
      ),
      const DocProp('min', 'num?', 'The smallest accepted value.'),
      const DocProp('max', 'num?', 'The largest accepted value.'),
      const DocProp(
        'step',
        'num',
        'How much a stepper or an arrow key moves the value.',
        defaultValue: '1',
      ),
      const DocProp(
        'integerOnly',
        'bool',
        'Whether to refuse anything that is not a whole number.',
        defaultValue: 'false',
      ),
      const DocProp('units', 'String?', 'A suffix inside the field.'),
      const DocProp(
        'steppers',
        'bool',
        'Whether to draw the increment and decrement buttons.',
        defaultValue: 'true',
      ),
      const DocProp(
        'showClear',
        'bool',
        'Whether to show a button that empties the field, committing null.',
        defaultValue: 'false',
      ),
      const DocProp(
        'placeholder',
        'String?',
        'Shown while the field is empty.',
      ),
      const DocProp('leading', 'Widget?', 'Content before the number.'),
      const DocProp(
        'readOnly',
        'bool',
        'Whether the value can be read but not changed.',
        defaultValue: 'false',
      ),
      const DocProp('size', 'AstryxInputSize?', 'The control height.'),
      const DocProp('width', 'double?', 'A fixed width for the whole field.'),
      ..._fieldProps(),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxTextInput](text_input) — what this is built on.',
      '[AstryxVisuallyHidden](visually_hidden) — how the rejection is '
          'announced.',
    ]),
  ],
);

final DocPage _fileInput = DocPage(
  id: 'file_input',
  title: 'AstryxFileInput',
  group: _group,
  description: 'A file field: the chooser, the chosen list, and the limits.',
  source: 'lib/src/components/forms/file_input.dart',
  upstream: 'FileInput',
  upstreamPath: '/components/FileInput',
  blocks: <DocBlock>[
    const DocProse(
      'The field owns what has been chosen, how it reads, and whether it is '
      'allowed — the count, the size and the accepted types, with upstream’s '
      'own messages. It does not own the dialog.',
    ),
    const DocExample('file_input_demo', align: DocExampleAlign.start),
    const DocCallout.warning(
      'Flutter has **no file picker** in its core libraries, and this package '
      'depends on no plugins — a design system that pulled one in would make '
      'every consumer inherit its platform setup. So `onPick` is a seam, the '
      'same shape as `AstryxLinkDelegate`: the field asks, the application '
      'opens. Wire `file_selector`, `image_picker`, a channel of your own, or '
      'a fake in a test.',
    ),
    const DocHeading('Usage'),
    const DocCode('''
AstryxFileInput(
  label: 'Incident report',
  files: _files,
  accept: const <String>['.pdf'],
  maxSize: 1024 * 1024,
  onPick: (request) async {
    // Whatever your picker returns, described as AstryxFiles.
    final picked = await openFileSelector(
      accept: request.accept,
      multiple: request.multiple,
    );
    return picked
        .map((f) => AstryxFile(name: f.name, size: f.size, handle: f))
        .toList();
  },
  onChanged: (files) => setState(() => _files = files),
)'''),
    const DocProse(
      '`AstryxFile` is a description, not a handle: a name, an optional size '
      'and MIME type, and a `handle` for your own object. Deliberately not '
      '`dart:io`’s `File`, which does not exist on the web — this package '
      'builds everywhere Flutter does. The package never looks inside '
      '`handle`; it is there so the thing you upload survives the round trip.',
    ),
    const DocHeading('Limits, and what happens at them'),
    const DocTable(
      headers: <String>['Set', 'What the field does'],
      rows: <List<String>>[
        <String>[
          '`accept`',
          'Rejects anything that matches none of the patterns — `.pdf` on the '
              'extension, `image/*` on the type family, `text/csv` exactly. A '
              'file whose picker reported no MIME type is matched on its '
              'extension alone.',
        ],
        <String>[
          '`maxSize`',
          'Rejects a file that is larger. A file of **unknown** size passes: a '
              'reticent picker is not a large file.',
        ],
        <String>[
          '`maxFiles`',
          'Truncates a longer selection to the limit and complains — '
              'upstream’s behaviour, not a refusal of the whole batch.',
        ],
        <String>[
          '`multiple: false`',
          'Keeps the first file of whatever came back.',
        ],
      ],
    ),
    const DocProse(
      'Rejected files never reach `onChanged`; the field keeps the ones that '
      'passed and shows the first complaint as an error. A `status` of your '
      'own **wins**, so a server-side rejection is not overwritten a moment '
      'later by a local one.',
    ),
    const DocHeading('Dropzone'),
    const DocProse(
      'The panel presentation, for a form whose subject *is* the upload. It is '
      'pressable anywhere and keyboard-reachable like the field version.',
    ),
    const DocExample('file_input_dropzone', align: DocExampleAlign.stretch),
    const DocCallout.note(
      'It is a *zone*, not a drop target: dragging a file from the desktop '
      'onto it does nothing. External file drag-and-drop needs a channel '
      'Flutter does not ship, so it is the same missing capability as the '
      'dialog — wrap the field in your own drop handler and call the same code '
      '`onPick` would. Upstream’s dropzone accepts drops *and* clicks; this '
      'one accepts clicks, taps and the keyboard.',
    ),
    const DocHeading('Accessibility'),
    const DocList(<String>[
      'The field announces its label and, as its value, what is chosen — '
          '"Incident report, incident-report.pdf · 180.0 KB" rather than '
          '"Incident report, button".',
      'The chooser and the remove button keep their own names, so both are '
          'reachable rather than folded into one node.',
      'A rejection arrives as a field error, which is announced, and never as '
          'a silently shorter list.',
    ]),
    DocApi('AstryxFileInput', <DocProp>[
      const DocProp(
        'files',
        'List<AstryxFile>',
        'The files currently chosen. Empty for none.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<List<AstryxFile>>?',
        'Called with the files that passed validation.',
      ),
      const DocProp(
        'onPick',
        'AstryxFilePicker?',
        'Opens the dialog. Null leaves the field inert.',
      ),
      const DocProp(
        'accept',
        'List<String>',
        'Accepted types, in the HTML `accept` vocabulary.',
        defaultValue: 'const <String>[]',
      ),
      const DocProp(
        'multiple',
        'bool',
        'Whether more than one file may be chosen.',
        defaultValue: 'false',
      ),
      const DocProp('maxFiles', 'int?', 'The most files that may be chosen.'),
      const DocProp('maxSize', 'int?', 'The largest accepted size, in bytes.'),
      const DocProp(
        'mode',
        'AstryxFileInputMode',
        'Whether to present as a field or as a panel.',
        defaultValue: 'AstryxFileInputMode.input',
      ),
      const DocProp(
        'placeholder',
        'String?',
        'The text shown when nothing is chosen.',
      ),
      const DocProp(
        'loading',
        'bool',
        'Whether an upload is in flight. Shows a spinner and refuses the '
            'dialog.',
        defaultValue: 'false',
      ),
      const DocProp('width', 'double?', 'A fixed width for the whole field.'),
      ..._fieldProps(labelRequired: true),
    ]),
    const DocApi(
      'AstryxFile',
      <DocProp>[
        DocProp(
          'name',
          'String',
          'The file name, with its extension.',
          required: true,
        ),
        DocProp(
          'size',
          'int?',
          'The size in bytes, if known. Null passes '
              'a `maxSize` check.',
        ),
        DocProp('mimeType', 'String?', 'The MIME type, if known.'),
        DocProp(
          'handle',
          'Object?',
          'Your own object for this file. '
              'Never inspected.',
        ),
      ],
      description: 'A chosen file, as the field understands it.',
    ),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxField](field) — the label, description and status this reuses.',
      '[AstryxButton](button) — the chooser, and the `AstryxLinkDelegate` seam '
          'that `onPick` is modelled on.',
    ]),
  ],
);

final DocPage _slider = DocPage(
  id: 'slider',
  title: 'AstryxSlider',
  group: _group,
  description: 'A value, or a range, chosen by dragging along a track.',
  source: 'lib/src/components/forms/slider.dart',
  upstream: 'Slider',
  upstreamPath: '/components/Slider',
  blocks: <DocBlock>[
    const DocProse(
      'For a value where *approximately* is the point: a threshold, a volume, '
      'a tolerance. A slider that has to land on an exact number is the wrong '
      'control — use [AstryxNumberInput](number_input), or put one beside it.',
    ),
    const DocExample('slider_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode(r'''
AstryxSlider(
  label: 'Alert threshold',
  value: _threshold,
  step: 5,
  formatValue: (value) => '$value%',
  onChanged: (value) => setState(() => _threshold = value),
)'''),
    const DocProse(
      '`onChanged` fires throughout a drag; `onChangeEnd` fires once it '
      'settles, and is where a request belongs. A keyboard move fires both, '
      'because there is no drag to end and a consumer listening only for the '
      'end would never hear about it.',
    ),
    const DocHeading('A range'),
    const DocExample('slider_range', align: DocExampleAlign.stretch),
    const DocProse(
      '`AstryxSlider.range` takes two values as a tuple and keeps them in '
      'order: a thumb stops where the other one is, less '
      '`minStepsBetweenThumbs` steps. Each thumb is its own tab stop and its '
      'own announced control — "Acceptable latency, start" and "…, end".',
    ),
    const DocHeading('Marks, and how the value reads'),
    const DocTable(
      headers: <String>['Set', 'Gets you'],
      rows: <List<String>>[
        <String>[
          '`marks`',
          'Ticks at the values you name. Decoration only: not snap targets, '
              'and not announced.',
        ],
        <String>[
          '`formatValue`',
          'How a value is written **and** announced — "40%", "150ms". Without '
              'it a value is written plainly and an integral one drops its '
              '`.0`.',
        ],
        <String>[
          '`valueDisplay`',
          '`text` puts the value above the track, `none` shows nothing.',
        ],
        <String>[
          '`orientation`',
          'Vertical runs bottom to top and needs a `length`, having nothing to '
              'stretch to.',
        ],
      ],
    ),
    const DocHeading('Keyboard'),
    const DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>[
          '`Tab`',
          'Moves to the thumb — each thumb of a range in turn.',
        ],
        <String>['`←` `→`', 'One step, mirrored under RTL.'],
        <String>['`↑` `↓`', 'One step. Never mirrored.'],
        <String>['`Page Up` `Page Down`', 'Ten steps.'],
        <String>['`Home` `End`', 'The bottom or the top of the scale.'],
      ],
    ),
    const DocCallout.accessibility(
      'Each thumb is a `slider` to assistive technology, carrying the '
      '**formatted** value and increase and decrease actions — so a switch or '
      'voice user can move it without a keyboard. The thumb also carries a '
      'full tap target, which is why it answers a thumb as well as a mouse.',
    ),
    const DocCallout.warning(
      'Upstream inherits its thumb from a native `input[type=range]`, and the '
      'browser supplies a value tooltip on hover. `valueDisplay: tooltip` '
      'therefore shows nothing here yet — use `text`, which is visible to '
      'everyone rather than only to a pointer, and is what this page uses.',
    ),
    DocApi('AstryxSlider', <DocProp>[
      const DocProp(
        'value',
        'num',
        'The value. Single-thumb constructor.',
        required: true,
      ),
      const DocProp(
        'values',
        '(num, num)',
        'The two values, low then high. `AstryxSlider.range` only.',
        required: true,
      ),
      const DocProp('onChanged', 'ValueChanged?', 'Fires throughout a drag.'),
      const DocProp(
        'onChangeEnd',
        'ValueChanged?',
        'Fires once a drag settles, and on every keyboard move.',
      ),
      const DocProp(
        'min',
        'num',
        'The bottom of the scale.',
        defaultValue: '0',
      ),
      const DocProp('max', 'num', 'The top of the scale.', defaultValue: '100'),
      const DocProp('step', 'num', 'The granularity.', defaultValue: '1'),
      const DocProp(
        'minStepsBetweenThumbs',
        'int',
        'The fewest steps between the two thumbs of a range.',
        defaultValue: '0',
      ),
      const DocProp(
        'orientation',
        'AstryxSliderOrientation',
        'Which way the track runs.',
        defaultValue: 'horizontal',
      ),
      const DocProp(
        'valueDisplay',
        'AstryxSliderValueDisplay',
        'How the value is shown.',
        defaultValue: 'tooltip',
      ),
      const DocProp(
        'marks',
        'List<AstryxSliderMark>',
        'Ticks along the track.',
        defaultValue: 'const []',
      ),
      const DocProp(
        'formatValue',
        'String Function(num)?',
        'Formats a value for display and for assistive technology.',
      ),
      const DocProp(
        'length',
        'double',
        'The track extent. Horizontal sliders stretch and ignore it.',
        defaultValue: '200',
      ),
      ..._fieldProps(labelRequired: true),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxNumberInput](number_input) — for a value that must be exact.',
      '[AstryxProgressBar](progress_bar) — which looks similar and is not a '
          'control: progress is reported, not chosen.',
    ]),
  ],
);

final DocPage _multiSelector = DocPage(
  id: 'multi_selector',
  title: 'AstryxMultiSelector',
  group: _group,
  description: 'A selector that keeps several choices, shown as tokens.',
  source: 'lib/src/components/forms/multi_selector.dart',
  upstream: 'MultiSelector',
  upstreamPath: '/components/MultiSelector',
  blocks: <DocBlock>[
    const DocProse(
      'The same option list as [AstryxSelector](selector) — options, sections '
      'and dividers are the same types here, because upstream shares them '
      'between the two components as well. What differs is the value (a set), '
      'the rows (checkboxes, and the list stays open as they are ticked) and '
      'the trigger (tokens rather than one label).',
    ),
    const DocExample('multi_selector_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxMultiSelector<String>(
  label: 'Reviewers',
  values: _reviewers,
  onChanged: (values) => setState(() => _reviewers = values),
  options: const <AstryxSelectorEntry<String>>[
    AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
    AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
  ],
)'''),
    const DocProse(
      'Each change hands back a **new set**; the one passed in is never '
      'edited. `showSearch` filters the list, and drops a section heading '
      'whose options have all been filtered away — five headings above '
      'nothing is worse than an empty list. `showSelectAll` adds a row that '
      'ticks everything, and clears it when everything is already ticked.',
    ),
    const DocHeading('What the trigger shows'),
    const DocExample('multi_selector_count', align: DocExampleAlign.stretch),
    const DocTable(
      headers: <String>['Set', 'Trigger shows'],
      rows: <List<String>>[
        <String>[
          '`badges` (default)',
          'A token per choice up to `maxBadges`, then "+n more". One line: a '
              'trigger that grew would move every field below it.',
        ],
        <String>[
          '`count`',
          '"3 selected". For a field that is usually full, where the tokens '
              'would never have fitted.',
        ],
      ],
    ),
    const DocCallout.accessibility(
      'The field announces **which** options are chosen, not how many: "Ada '
      'Lovelace, Grace Hopper" rather than "2 selected". A count is a summary '
      'for the eye; a reader needs the list. The clear button keeps a name of '
      'its own so that it can be reached at all.',
    ),
    const DocHeading('Or a different widget'),
    const DocList(<String>[
      '[AstryxSelector](selector) — one choice out of many.',
      '[AstryxCheckboxList](checkbox_list) — a handful of choices always worth '
          'showing. A dropdown that hides three checkboxes costs a click and '
          'saves nothing.',
      '[AstryxToggleButtonGroup](toggle_button_group) — two to four choices '
          'that belong on a toolbar.',
    ]),
    DocApi('AstryxMultiSelector', <DocProp>[
      const DocProp(
        'options',
        'List<AstryxSelectorEntry<T>>',
        'The options, sections and dividers, in order.',
        required: true,
      ),
      const DocProp(
        'values',
        'Set<T>',
        'The values currently chosen.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<Set<T>>?',
        'Called with a new set. Null makes the selector inert.',
      ),
      const DocProp(
        'triggerDisplay',
        'AstryxMultiSelectorTriggerDisplay',
        'Tokens or a count.',
        defaultValue: 'badges',
      ),
      const DocProp(
        'maxBadges',
        'int',
        'How many tokens before the rest collapse into "+n".',
        defaultValue: '3',
      ),
      const DocProp(
        'showSelectAll',
        'bool',
        'Whether to offer a tick-everything row.',
        defaultValue: 'false',
      ),
      const DocProp(
        'showSearch',
        'bool',
        'Whether to offer a search field above the list.',
        defaultValue: 'false',
      ),
      const DocProp(
        'emptyLabel',
        'String?',
        'What to show when a search matches nothing.',
      ),
      const DocProp(
        'loading',
        'bool',
        'Whether the options are being fetched.',
        defaultValue: 'false',
      ),
      const DocProp(
        'maxListHeight',
        'double',
        'The tallest the list may be before it scrolls.',
        defaultValue: '320',
      ),
      ..._fieldProps(labelRequired: true),
    ]),
  ],
);

final DocPage _complexSelector = DocPage(
  id: 'complex_selector',
  title: 'AstryxComplexSelector',
  group: _group,
  description:
      'A selector with a trigger this package draws and a surface you draw.',
  source: 'lib/src/components/forms/complex_selector.dart',
  upstream: 'ComplexSelector',
  upstreamPath: '/components/ComplexSelector',
  blocks: <DocBlock>[
    const DocProse(
      '[AstryxSelector](selector) covers a list of options and '
      '[AstryxMultiSelector](multi_selector) covers several of them. This '
      'covers everything else: a calendar, a grid of swatches, a two-pane '
      'picker, a small form inside a popover.',
    ),
    const DocProse(
      'It supplies the parts that are tedious and easy to get wrong — the '
      'field, the trigger and its status, the overlay and its positioning, '
      'focus trapping, Escape, the barrier — and leaves the contents entirely '
      'to you.',
    ),
    const DocExample('complex_selector_demo', align: DocExampleAlign.start),
    const DocHeading('Usage'),
    const DocCode('''
AstryxComplexSelector<AstryxPalette?>(
  label: 'Label colour',
  value: _palette,
  triggerLabel: _palette == null ? null : AstryxBadge(_palette!.name),
  onChanged: (value) => setState(() => _palette = value),
  surfaceBuilder: (context, state) => MySwatchGrid(
    selected: state.value,
    onPicked: (palette) {
      state.onChanged(palette);
      state.close();
    },
  ),
)'''),
    const DocProse(
      'The builder is handed one `AstryxComplexSelectorState`: the current '
      'value, a callback to report a new one, and `close`. Reporting does '
      '**not** close the surface — a multi-step picker wants to stay open — so '
      'closing is a decision of its own, which is why both are on the state. '
      'Upstream passes four positional arguments to a render prop; one object '
      'is the same information at a call site somebody can read.',
    ),
    const DocProse(
      '`triggerLabel` is a widget rather than a string, because the whole '
      'point is a value one string cannot describe: two dates, a swatch, a '
      'row of avatars. Null falls back to `placeholder`.',
    ),
    const DocCallout.accessibility(
      'The trigger announces itself as a button, expanded or collapsed, and '
      'the overlay traps focus and returns it on Escape. What you build '
      'inside is yours to name — nothing else about your surface can be '
      'checked from here, which is the price of the freedom.',
    ),
    DocApi('AstryxComplexSelector', <DocProp>[
      const DocProp(
        'value',
        'T',
        'The value, handed to the builder unchanged.',
        required: true,
      ),
      const DocProp(
        'surfaceBuilder',
        'Widget Function(BuildContext, AstryxComplexSelectorState<T>)',
        'Builds the surface inside the overlay.',
        required: true,
      ),
      const DocProp(
        'onChanged',
        'ValueChanged<T>?',
        'Called with a new value. Null makes the selector inert.',
      ),
      const DocProp(
        'triggerLabel',
        'Widget?',
        'What the trigger shows. Null shows the placeholder.',
      ),
      const DocProp(
        'side',
        'AstryxOverlaySide',
        'Which side of the trigger the surface opens on.',
        defaultValue: 'bottom',
      ),
      const DocProp(
        'matchTriggerWidth',
        'bool',
        'Whether the surface takes the trigger width.',
        defaultValue: 'true',
      ),
      const DocProp(
        'surfaceWidth',
        'double?',
        'A fixed surface width. Ignored when `matchTriggerWidth`.',
      ),
      const DocProp(
        'loading',
        'bool',
        'Whether the value is being fetched.',
        defaultValue: 'false',
      ),
      ..._fieldProps(labelRequired: true),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxPopover](popover) — the overlay this is built on, for a surface '
          'that is not a field.',
      '[AstryxSelector](selector) — when a list of options is all you need.',
    ]),
  ],
);

final DocPage _inputGroup = DocPage(
  id: 'input_group',
  title: 'AstryxInputGroup',
  group: _group,
  description: 'Adjacent inputs and affixes joined into one bordered control.',
  source: 'lib/src/components/forms/input_group.dart',
  upstream: 'InputGroup / InputGroupText',
  upstreamPath: '/components/InputGroup',
  blocks: <DocBlock>[
    const DocProse(
      '`https://` before a field, `USD` after an amount, a unit at the end of '
      'a number. The children keep their border where the group’s edge is and '
      'square it where they meet, so a reader sees one control rather than '
      'three.',
    ),
    const DocExample('input_group_demo', align: DocExampleAlign.stretch),
    const DocHeading('Usage'),
    const DocCode('''
AstryxInputGroup(
  label: 'Project URL',
  children: <Widget>[
    const AstryxInputGroupText('https://'),
    Expanded(
      child: AstryxTextInput(
        label: 'Project URL',
        labelHidden: true,
        controller: _slug,
      ),
    ),
    const AstryxInputGroupText('.example.com'),
  ],
)'''),
    const DocProse(
      'The group carries the label, the description and the status for the '
      'whole row, so the input inside takes `labelHidden: true` and says '
      'nothing of its own — upstream’s arrangement too. Wrap whichever child '
      'should take the leftover width in an `Expanded`; the affixes size to '
      'their text.',
    ),
    const DocHeading('One border, one status'),
    const DocExample('input_group_status', align: DocExampleAlign.stretch),
    const DocProse(
      'A status belongs to the group, and every child paints it — rather than '
      'one of them turning red beside two that did not, which would read as '
      'one part being wrong instead of the field.',
    ),
    const DocCallout.accessibility(
      'An affix is decoration: no focus, no value, not announced. Anything it '
      '*says* — a currency, a unit — belongs in the group’s label or '
      'description as well, or a screen-reader user gets the number without '
      'knowing what it counts.',
    ),
    const DocHeading('How the joining works'),
    const DocProse(
      'Each child is wrapped in an `AstryxInputGroupScope` carrying its '
      'position, and the input container reads it: the first child rounds its '
      'reading-start corners, the last its end corners, and the ones between '
      'stay square. Directional throughout, so a group mirrors under RTL '
      'without being told which way it runs.',
    ),
    DocApi('AstryxInputGroup', <DocProp>[
      const DocProp(
        'children',
        'List<Widget>',
        'The inputs and affixes, in reading order.',
        required: true,
      ),
      const DocProp(
        'size',
        'AstryxInputSize?',
        'The size every input inside takes unless it sets its own.',
      ),
      ..._fieldProps(labelRequired: true),
    ]),
    const DocHeading('Related'),
    const DocList(<String>[
      '[AstryxTextInput](text_input) — the usual child.',
      '[AstryxButtonGroup](button_group) — the same idea for actions.',
      '[AstryxNumberInput](number_input) — which has a `units` slot already, '
          'for when a whole group is more than you need.',
    ]),
  ],
);

const DocPage _formLayout = DocPage(
  id: 'form_layout',
  title: 'AstryxFormLayout',
  group: _group,
  description: 'The column and label geometry a form’s fields share.',
  source: 'lib/src/components/forms/form_layout.dart',
  upstream: 'FormLayout',
  upstreamPath: '/components/FormLayout',
  blocks: <DocBlock>[
    DocProse(
      'One gap and one label geometry for a set of fields. It is **not** a '
      '`Form`: submission, validation and state stay yours, and this decides '
      'only where the fields sit.',
    ),
    DocExample('form_layout_directions', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxFormLayout(
  children: <Widget>[
    AstryxTextInput(label: 'Project name', controller: _name),
    AstryxFormLayout(
      direction: AstryxFormLayoutDirection.horizontal,
      children: <Widget>[
        AstryxTextInput(label: 'Region', controller: _region),
        AstryxTextInput(label: 'Owner', controller: _owner),
      ],
    ),
  ],
)'''),
    DocTable(
      headers: <String>['Direction', 'Arranges'],
      rows: <List<String>>[
        <String>[
          '`vertical`',
          'Stacked. The default, and what most forms want.',
        ],
        <String>[
          '`horizontal`',
          'Equal columns, one per child — `grid-auto-columns: 1fr` upstream.',
        ],
        <String>[
          '`horizontalLabels`',
          'Stacked, with each label beside its own control. Collapses to a '
              'stack below 480 logical pixels.',
        ],
      ],
    ),
    DocHeading('Labels beside their controls'),
    DocProse(
      'The settings-panel arrangement, and the only direction that does more '
      'than space things out: every [AstryxField](field) below it moves its '
      'label — and its description — to the side.',
    ),
    DocExample('form_layout_labels', align: DocExampleAlign.stretch),
    DocCallout.note(
      'Switch the preview above to a phone. Below 480 logical pixels — '
      'upstream’s own threshold — the labels go back above their controls, '
      'because a label column and a usable control do not both fit. It is a '
      'change of arrangement rather than a squeeze, so the fields under it '
      'stop reserving a column at all.',
    ),
    DocProse(
      '`labelWidth` sets that column and defaults to 160. Upstream sizes it to '
      'its widest label, which CSS grid does for free; Flutter would have to '
      'lay every label out twice to match, so a number is the honest version — '
      'pick one that fits the longest label in the form.',
    ),
    DocApi('AstryxFormLayout', <DocProp>[
      DocProp(
        'children',
        'List<Widget>',
        'The fields, in order.',
        required: true,
      ),
      DocProp(
        'direction',
        'AstryxFormLayoutDirection',
        'How to arrange them.',
        defaultValue: 'vertical',
      ),
      DocProp(
        'gap',
        'AstryxSpacingToken?',
        'The space between fields.',
        defaultValue: 'spacing4',
      ),
      DocProp(
        'labelWidth',
        'double?',
        'The label column, under `horizontalLabels`.',
        defaultValue: '160',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxField](field) — the widget that reads this and moves its label.',
      '[AstryxGrid](grid) — for laying out anything that is not a form.',
      '[Two-column form](form_two_column) — a whole screen, assembled.',
    ]),
  ],
);
