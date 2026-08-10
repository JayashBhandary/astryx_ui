import 'package:example/docs/model.dart';

/// The form controls, and the field wrapper they share.
final List<DocPage> formPages = <DocPage>[
  _field,
  _textInput,
  _textArea,
  _checkbox,
  _radioList,
  _switch,
  _selector,
];

const String _group = 'Forms';

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
  upstream: 'Field',
  blocks: <DocBlock>[
    DocExample('field_demo'),
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
    DocExample('field_scope'),
    DocHeading('Markers'),
    DocProse(
      'Mark whichever is the exception in your form. Marking every field as '
      'required says nothing at all.',
    ),
    DocExample('field_markers'),
    DocHeading('Statuses'),
    DocProse(
      '`AstryxFieldStatus` has three types and a message. A null message '
      'colours the control and shows its icon without adding text — for a '
      'field whose problem is described elsewhere, such as a summary at the '
      'top of the form.',
    ),
    DocExample('field_statuses'),
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
  blocks: <DocBlock>[
    const DocExample('text_input_demo'),
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
    const DocExample('text_input_sizes'),
    const DocHeading('Validation'),
    const DocProse(
      'A status draws an inset ring in its colour, shows its icon in the '
      'trailing slot, and prints its message below — announced, not merely '
      'coloured.',
    ),
    const DocExample('text_input_validation'),
    const DocHeading('Affordances'),
    const DocProse(
      '`leading` and `trailing` take any widget. `showClear` adds a clear '
      'button that appears only when there is something to clear, and sits '
      'before the status icon.',
    ),
    const DocExample('text_input_affordances'),
    const DocHeading('Formatters'),
    const DocProse(
      'The Flutter text-input machinery is exposed rather than wrapped: '
      '`inputFormatters`, `keyboardType`, `textInputAction`, `autofillHints` '
      'and `maxLength` all behave exactly as they do on `EditableText`.',
    ),
    const DocExample('text_input_formatters'),
    const DocHeading('States'),
    const DocProse(
      'Read-only is not disabled. A read-only value still means something and '
      'is still selectable and copyable — it is simply not yours to change '
      'here — so it is not dimmed.',
    ),
    const DocExample('text_input_states'),
    const DocHeading('Multi-line'),
    const DocProse(
      '`AstryxTextInput.multiline` grows from `minLines` to `maxLines`, then '
      'scrolls. [AstryxTextArea](text_area) is the friendlier name for the '
      'same control.',
    ),
    const DocExample('text_input_multiline'),
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
  blocks: <DocBlock>[
    const DocExample('text_area_demo'),
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
    const DocExample('text_area_lines'),
    const DocHeading('Counting characters'),
    const DocProse(
      '`maxLength` stops the input; the count and the warning are yours to '
      'render, because where they belong depends on the form.',
    ),
    const DocExample('text_area_counted'),
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
  upstream: 'Checkbox',
  blocks: <DocBlock>[
    DocExample('checkbox_demo'),
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
    DocExample('checkbox_tristate'),
    DocTable(
      headers: <String>['Value', 'Box', 'Pressing it gives'],
      rows: <List<String>>[
        <String>['`unchecked`', 'empty', '`checked`'],
        <String>['`checked`', 'filled, tick', '`unchecked`'],
        <String>['`indeterminate`', 'filled, dash', '`checked`'],
      ],
    ),
    DocHeading('Sizes'),
    DocExample('checkbox_sizes'),
    DocHeading('States'),
    DocProse(
      'A null `onChanged` makes the checkbox non-interactive **without dimming '
      'it** — for a box reflecting state the user changes elsewhere. '
      '`readOnly` says the same thing more loudly; `enabled: false` is the one '
      'that dims.',
    ),
    DocExample('checkbox_states'),
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
  upstream: 'RadioList',
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
        <String>['`Tab`', 'Enters the group, or leaves it — one stop, not one '
            'per option.'],
        <String>['`↓` / `→`', 'Selects the next enabled option, wrapping.'],
        <String>['`↑` / `←`', 'Selects the previous one, wrapping. Mirrored '
            'under RTL.'],
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
    DocExample('switch_settings_list'),
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
  upstream: 'Selector',
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
