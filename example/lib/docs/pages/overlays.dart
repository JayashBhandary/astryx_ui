import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Everything that floats above the page.
final List<DocPage> overlayPages = <DocPage>[
  _popover,
  _tooltip,
  _dropdownMenu,
  _dialog,
  _toast,
];

const String _group = DocGroup.overlays;

/// The rows every anchored overlay shares.
const List<List<String>> _positioningRows = <List<String>>[
  <String>[
    '`side`',
    'The **preferred** side. The positioner flips to the opposite one when '
        'there is no room.',
  ],
  <String>[
    '`align`',
    'Alignment along the anchor’s edge: `start`, `center` or `end`. The '
        'overlay shifts along that edge to stay on screen.',
  ],
];

const DocPage _popover = DocPage(
  id: 'popover',
  title: 'AstryxPopover',
  group: _group,
  description: 'A floating panel anchored to a trigger, with trapped focus.',
  source: 'lib/src/components/overlay/popover.dart',
  upstream: 'Popover / usePopover',
  upstreamPath: '/components/Popover',
  blocks: <DocBlock>[
    DocExample('popover_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxPopover(
  label: 'Filters',
  width: 260,
  content: filterForm,
  triggerBuilder: (context, controller) =>
      AstryxButton(label: 'Filters', onPressed: controller.toggle),
)'''),
    DocProse(
      '`triggerBuilder`, not `child`. A button consumes its own taps, so a '
      'popover cannot open itself by wrapping one — instead it hands you the '
      'controller and lets you wire it to the trigger’s own callback. That is '
      'also what makes any widget a valid trigger.',
    ),
    DocHeading('Positioning'),
    DocProse(
      'One positioner serves the popover, the tooltip, the menu and the '
      'selector: it flips, shifts and shrinks to keep the panel on screen.',
    ),
    DocTable(headers: <String>['Property', 'Does'], rows: _positioningRows),
    DocExample('popover_sides'),
    DocExample(
      'popover_align',
      title: 'Alignment along the trigger’s edge',
    ),
    DocHeading('Controlled and uncontrolled'),
    DocProse(
      'With no `controller` the popover owns one and toggles on a press. Pass '
      'one and the open state is yours: anything can open it, and you can '
      'watch it.',
    ),
    DocExample('popover_controlled'),
    DocHeading('Matching the trigger'),
    DocProse(
      '`matchTriggerWidth` makes the panel at least as wide as what opened it '
      '— which is what makes it read as belonging to that control. Upstream '
      'gets the same effect from `min-width: anchor-size(width)`.',
    ),
    DocExample('popover_match_width'),
    DocHeading('Dismissal'),
    DocProse(
      'A press outside closes it, and so does `Escape` — but Escape closes '
      '**one layer at a time**. Open a popover inside a dialog, press Escape, '
      'and the popover closes while the dialog stays.',
    ),
    DocCallout.accessibility(
      'Focus is trapped in the panel while it is open and returns to the '
      'trigger when it closes. Give the panel a `label`: it is a container a '
      'screen reader will announce on entry, and "group" is not a useful name.',
    ),
    DocApi('AstryxPopover', <DocProp>[
      DocProp(
        'triggerBuilder',
        'Widget Function(BuildContext, AstryxOverlayController)',
        'Builds the trigger, given the controller that opens the panel.',
        required: true,
      ),
      DocProp(
        'content',
        'Widget',
        'The floating content.',
        required: true,
      ),
      DocProp(
        'controller',
        'AstryxOverlayController?',
        'Drives the popover from outside. Null makes it uncontrolled.',
      ),
      DocProp('label', 'String?', 'An accessible name for the panel.'),
      DocProp(
        'side',
        'AstryxOverlaySide',
        'The preferred side.',
        defaultValue: 'AstryxOverlaySide.bottom',
      ),
      DocProp(
        'align',
        'AstryxOverlayAlign',
        'Alignment along the trigger’s edge.',
        defaultValue: 'AstryxOverlayAlign.center',
      ),
      DocProp(
        'width',
        'double?',
        'A fixed width. Null sizes to the content.',
      ),
      DocProp(
        'matchTriggerWidth',
        'bool',
        'Whether the panel is at least as wide as its trigger.',
        defaultValue: 'false',
      ),
      DocProp(
        'showArrow',
        'bool',
        'Whether to draw a pointer at the trigger.',
        defaultValue: 'false',
      ),
      DocProp(
        'trapFocus',
        'bool',
        'Whether focus is trapped inside while open.',
        defaultValue: 'true',
      ),
      DocProp(
        'barrierDismissible',
        'bool',
        'Whether a press outside closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'escapeDismissible',
        'bool',
        'Whether Escape closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'onOpenChange',
        'ValueChanged<bool>?',
        'Called whenever the panel opens or closes.',
      ),
    ]),
    DocApi(
      'AstryxOverlayController',
      <DocProp>[
        DocProp('isOpen', 'bool', 'Whether the overlay is showing.'),
        DocProp('show()', 'void', 'Shows it.'),
        DocProp('hide()', 'void', 'Hides it.'),
        DocProp(
          'toggle()',
          'void',
          'Shows it if hidden, hides it if '
              'shown.',
        ),
      ],
      description:
          'A `ChangeNotifier`. The same controller drives the popover, the '
          'dropdown menu and the tooltip. Dispose one you own.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTooltip](tooltip) — for a phrase, not a panel.',
      '[AstryxDropdownMenu](dropdown_menu) — for a list of actions.',
      '[AstryxDialog](dialog) — for something that must be dealt with.',
    ]),
  ],
);

const DocPage _tooltip = DocPage(
  id: 'tooltip',
  title: 'AstryxTooltip',
  group: _group,
  description: 'A short phrase on hover, focus, or long-press.',
  source: 'lib/src/components/overlay/tooltip.dart',
  upstream: 'Tooltip / useTooltip',
  upstreamPath: '/components/Tooltip',
  blocks: <DocBlock>[
    DocExample('tooltip_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxTooltip(
  message: 'Archive this conversation',
  child: AstryxIconButton(
    icon: AstryxIconName.check,
    label: 'Archive',
    onPressed: archive,
  ),
)'''),
    DocProse(
      'Unlike every other overlay here, a tooltip takes a `child` rather than '
      'a builder — it opens on hover and long-press, not on a tap, so it never '
      'competes with the trigger for the press.',
    ),
    DocCallout.warning(
      'Never put anything essential in a tooltip alone. On touch it is '
      'unreachable until someone thinks to long-press, and on a keyboard it '
      'arrives only on focus. A tooltip repeats or clarifies; it does not '
      'inform.',
    ),
    DocHeading('Positioning'),
    DocProse('Above by default, as upstream does.'),
    DocExample('tooltip_sides'),
    DocHeading('Timing'),
    DocProse(
      'The wait is what stops a tooltip firing at everything a mouse crosses '
      'on its way somewhere else. `showDuration` applies only to the touch '
      'path: a touch tooltip cannot hide on release, because the finger is '
      'over the thing it describes and letting go is how you get out of the '
      'way to read it — so it lingers instead.',
    ),
    DocExample('tooltip_timing'),
    DocHeading('Semantics'),
    DocProse(
      'Set `excludeFromSemantics: true` when the message repeats the trigger’s '
      'own accessible name. An icon button labelled "Archive" with the tooltip '
      '"Archive" announces it twice otherwise.',
    ),
    DocExample('tooltip_semantics'),
    DocHeading('Long messages'),
    DocExample('tooltip_wrapping'),
    DocApi('AstryxTooltip', <DocProp>[
      DocProp(
        'message',
        'String',
        'The text to show. Keep it short.',
        required: true,
      ),
      DocProp('child', 'Widget', 'The trigger.', required: true),
      DocProp(
        'side',
        'AstryxOverlaySide',
        'The preferred side.',
        defaultValue: 'AstryxOverlaySide.top',
      ),
      DocProp(
        'align',
        'AstryxOverlayAlign',
        'Alignment along the trigger’s edge.',
        defaultValue: 'AstryxOverlayAlign.center',
      ),
      DocProp(
        'waitDuration',
        'Duration',
        'How long a pointer must rest before the tooltip appears.',
        defaultValue: 'Duration(milliseconds: 200)',
      ),
      DocProp(
        'exitDuration',
        'Duration',
        'How long after the pointer leaves before it hides.',
        defaultValue: 'Duration.zero',
      ),
      DocProp(
        'showDuration',
        'Duration',
        'How long a long-press tooltip stays after the finger lifts.',
        defaultValue: 'Duration(milliseconds: 1500)',
      ),
      DocProp(
        'showArrow',
        'bool',
        'Whether to draw a pointer at the trigger.',
        defaultValue: 'false',
      ),
      DocProp(
        'maxWidth',
        'double',
        'The widest the tooltip may be before its text wraps.',
        defaultValue: '300',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the tooltip responds at all.',
        defaultValue: 'true',
      ),
      DocProp(
        'excludeFromSemantics',
        'bool',
        'Whether to leave the message out of the trigger’s semantics.',
        defaultValue: 'false',
      ),
    ]),
  ],
);

const DocPage _dropdownMenu = DocPage(
  id: 'dropdown_menu',
  title: 'AstryxDropdownMenu',
  group: _group,
  description:
      'A list of actions, with sections, submenus and full keyboard '
      'support.',
  source: 'lib/src/components/overlay/dropdown_menu.dart',
  upstream:
      'DropdownMenu / DropdownMenuItem / DropdownMenuCheckboxItem / DropdownMenuRadioGroup / DropdownMenuRadioItem / DropdownMenuSubMenu',
  upstreamPath: '/components/DropdownMenu',
  blocks: <DocBlock>[
    DocExample('dropdown_menu_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxDropdownMenu(
  label: 'Actions',
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: delete),
  ],
  triggerBuilder: (context, controller) =>
      AstryxButton(label: 'Actions', onPressed: controller.toggle),
)'''),
    DocCallout.note(
      'A menu performs **actions**. To pick a *value*, use '
      '[AstryxSelector](selector) — it reports a selection, shows which option '
      'is current, and can be validated.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxDropdownMenu
└── entries
    ├── AstryxMenuSection('Manage')     ← a heading. Not focusable
    ├── AstryxMenuItem(label: …)
    │   └── submenu: <AstryxMenuEntry>[…]  ← a non-empty list makes a flyout
    ├── AstryxMenuDivider()             ← a rule. Not focusable
    └── AstryxMenuItem(destructive: true)'''),
    DocExample('dropdown_menu_sections'),
    DocHeading('Submenus'),
    DocProse(
      'A submenu is an item with `submenu` entries — not a separate row type, '
      'because a submenu row *is* an item in every respect except what happens '
      'when you choose it. Opening and closing are delayed slightly so '
      'diagonal mouse travel from the parent row to its flyout does not close '
      'the thing it is travelling to.',
    ),
    DocExample('dropdown_menu_submenu'),
    DocHeading('Trailing content'),
    DocProse(
      'A shortcut hint, a badge, a count — `trailing` takes any widget.',
    ),
    DocExample('dropdown_menu_trailing'),
    DocHeading('Placement'),
    DocExample('dropdown_menu_placement'),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Enter` on the trigger', 'Opens the menu.'],
        <String>[
          '`↑` / `↓`',
          'Moves the highlight without choosing anything, wrapping.',
        ],
        <String>['`Home` / `End`', 'Jumps to the first or last item.'],
        <String>['a letter', 'Jumps to the first item starting with it.'],
        <String>['`→`', 'Opens a submenu. Mirrored under RTL.'],
        <String>['`←`', 'Closes it. Mirrored under RTL.'],
        <String>[
          '`Enter`',
          'Chooses the highlighted item; the menu closes '
              'first, then the callback runs.',
        ],
        <String>['`Escape`', 'Closes the menu, not the page behind it.'],
      ],
    ),
    DocCallout.accessibility(
      'Sections and dividers are skipped by the keyboard, so arrowing never '
      'lands on something that does nothing. A disabled item stays visible and '
      'is announced as disabled — with a `description` it can even say why.',
    ),
    DocApi('AstryxDropdownMenu', <DocProp>[
      DocProp(
        'entries',
        'List<AstryxMenuEntry>',
        'The rows, in order.',
        required: true,
      ),
      DocProp(
        'triggerBuilder',
        'Widget Function(BuildContext, AstryxOverlayController)',
        'Builds the trigger, given the controller that opens the menu.',
        required: true,
      ),
      DocProp(
        'controller',
        'AstryxOverlayController?',
        'Drives the menu from outside.',
      ),
      DocProp('label', 'String?', 'An accessible name for the surface.'),
      DocProp(
        'side',
        'AstryxOverlaySide',
        'The preferred side.',
        defaultValue: 'AstryxOverlaySide.bottom',
      ),
      DocProp(
        'align',
        'AstryxOverlayAlign',
        'Alignment along the trigger’s edge.',
        defaultValue: 'AstryxOverlayAlign.start',
      ),
      DocProp(
        'width',
        'double?',
        'A fixed width. Null sizes to the widest row.',
      ),
      DocProp(
        'matchTriggerWidth',
        'bool',
        'Whether the menu is at least as wide as its trigger.',
        defaultValue: 'true',
      ),
      DocProp(
        'maxHeight',
        'double',
        'The tallest the menu may be before it scrolls.',
        defaultValue: '300',
      ),
      DocProp(
        'onOpenChange',
        'ValueChanged<bool>?',
        'Called whenever the menu opens or closes.',
      ),
    ]),
    DocApi('AstryxMenuItem', <DocProp>[
      DocProp(
        'label',
        'String',
        'The visible text, and this item’s accessible name.',
        required: true,
      ),
      DocProp(
        'onSelected',
        'VoidCallback?',
        'Called when the item is chosen. The menu closes first.',
      ),
      DocProp('icon', 'Widget?', 'An icon before the label.'),
      DocProp('description', 'String?', 'Secondary text below the label.'),
      DocProp(
        'trailing',
        'Widget?',
        'Content after the label — a shortcut hint, a badge.',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the item can be chosen.',
        defaultValue: 'true',
      ),
      DocProp(
        'destructive',
        'bool',
        'Whether the action is irreversible, which colours it with '
            '`--color-error`.',
        defaultValue: 'false',
      ),
      DocProp(
        'submenu',
        'List<AstryxMenuEntry>',
        'Nested entries. A non-empty list turns this row into a submenu.',
        defaultValue: 'const <AstryxMenuEntry>[]',
      ),
    ]),
  ],
);

const DocPage _dialog = DocPage(
  id: 'dialog',
  title: 'AstryxDialog',
  group: _group,
  description: 'A modal panel anchored to the viewport, with a scrolling body.',
  source: 'lib/src/components/overlay/dialog.dart',
  upstream: 'Dialog / DialogHeader / useImperativeDialog',
  upstreamPath: '/components/Dialog',
  blocks: <DocBlock>[
    DocExample('dialog_demo'),
    DocHeading('Usage'),
    DocCode('''
final AstryxDialogController _dialog = AstryxDialogController();

// …then, somewhere in the tree:
AstryxDialog(
  controller: _dialog,
  title: 'Delete project',
  description: 'This cannot be undone.',
  footer: AstryxButton(label: 'Cancel', onPressed: _dialog.hide),
  child: const AstryxText('Everything will be permanently removed.'),
)'''),
    DocProse(
      'A dialog is a **widget in the tree**, not a `showDialog` call. It '
      'renders nothing until its controller opens it. That means it can sit '
      'next to whatever opens it, the open state lives where your other state '
      'lives, and there is no `BuildContext` to smuggle into an async gap.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxDialog
├── title           ← the heading, and the dialog’s accessible name
├── description     ← supporting text
├── child           ← the body. Scrolls
└── footer          ← the action row. Pinned below the body'''),
    DocHeading('A form in a dialog'),
    DocProse(
      '`autofocus` on the first field is worth setting: a modal that opens '
      'with focus nowhere in particular costs a keyboard user a Tab or three.',
    ),
    DocExample('dialog_form'),
    DocHeading('Long content'),
    DocProse(
      'The body scrolls; the header and footer do not. A long dialog never '
      'pushes its actions off the screen.',
    ),
    DocExample('dialog_scrolling'),
    DocHeading('When the choice must be made'),
    DocProse(
      'Turning off the barrier, Escape and the close button leaves no way out '
      'but a decision. Be certain that is true before doing it — most dialogs '
      'that feel unskippable are not.',
    ),
    DocExample('dialog_blocking'),
    DocCallout.accessibility(
      'Focus is trapped inside while the dialog is open and returns to the '
      'trigger when it closes. `title` is the accessible name, so a dialog '
      'without one is announced as an unnamed container.',
    ),
    DocApi('AstryxDialog', <DocProp>[
      DocProp(
        'controller',
        'AstryxDialogController',
        'The open/closed state.',
        required: true,
      ),
      DocProp('child', 'Widget', 'The body.', required: true),
      DocProp(
        'title',
        'String?',
        'The heading, which also names the dialog for a screen reader.',
      ),
      DocProp(
        'description',
        'String?',
        'Supporting text below the title.',
      ),
      DocProp(
        'footer',
        'Widget?',
        'The action row, pinned below the scrolling body.',
      ),
      DocProp(
        'width',
        'double',
        'The dialog’s width. Never exceeds the viewport minus its padding.',
        defaultValue: '480',
      ),
      DocProp(
        'showCloseButton',
        'bool',
        'Whether to show a close button in the header.',
        defaultValue: 'true',
      ),
      DocProp(
        'barrierDismissible',
        'bool',
        'Whether a press on the barrier closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'escapeDismissible',
        'bool',
        'Whether Escape closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'onDismiss',
        'VoidCallback?',
        'Called when the dialog dismisses itself.',
      ),
    ]),
    DocApi(
      'AstryxDialogController',
      <DocProp>[
        DocProp('isOpen', 'bool', 'Whether the dialog is showing.'),
        DocProp('show()', 'void', 'Shows it.'),
        DocProp('hide()', 'void', 'Hides it.'),
      ],
      description: 'A `ChangeNotifier`. Dispose it with your state.',
    ),
  ],
);

const DocPage _toast = DocPage(
  id: 'toast',
  title: 'AstryxToast',
  group: _group,
  description: 'A transient message in the corner, with an optional action.',
  source: 'lib/src/components/overlay/toast.dart',
  upstream: 'Toast / useToast',
  upstreamPath: '/components/Toast',
  blocks: <DocBlock>[
    DocExample('toast_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxToastScope.of(context).show(
  const AstryxToast(message: 'Project archived'),
);'''),
    DocProse(
      '`AstryxApp` and `AstryxThemeProvider` install the host and the '
      'controller, so there is nothing to wire: reach for the scope and show '
      'one. `show` returns a callback that dismisses that toast, for the rare '
      'case where the code that raised it also knows when it should go.',
    ),
    DocHeading('Types'),
    DocExample('toast_types'),
    DocHeading('Actions'),
    DocProse(
      'An action makes a toast worth reading — "Row deleted" plus Undo is a '
      'safety net; "Row deleted" alone is a receipt.',
    ),
    DocExample('toast_action'),
    DocCallout.note(
      'Hover and focus both pause the timeout. A toast that vanishes while the '
      'user is reaching for its Undo button has actively made things worse.',
    ),
    DocHeading('Duration'),
    DocProse(
      'Five seconds by default. `Duration.zero` pins it until dismissed.',
    ),
    DocExample('toast_duration'),
    DocHeading('Queueing'),
    DocProse(
      'At most `maxVisible` are on screen — five by default. The rest queue '
      'and take their turn rather than burying the page.',
    ),
    DocExample('toast_queue'),
    DocHeading('Placement'),
    DocProse(
      'The default depends on density: a corner on pointer, the bottom on '
      'touch. A toast in the top corner of a phone is under the status bar and '
      'out of thumb reach; a toast across the bottom of a desktop window is in '
      'the way.',
    ),
    DocCode('''
AstryxThemeProvider(
  toastPosition: AstryxToastPosition.topEnd,
  child: const HomePage(),
)'''),
    DocCallout.accessibility(
      'A toast is announced when it appears, and can be dismissed from the '
      'keyboard. It is still the weakest place to put information: it is gone '
      'in five seconds and it is nowhere near what the user was looking at. '
      'For anything that must be acted on, use a [banner](banner).',
    ),
    DocApi('AstryxToast', <DocProp>[
      DocProp(
        'message',
        'String',
        'What to tell the user.',
        required: true,
      ),
      DocProp(
        'type',
        'AstryxToastType',
        'Which surface to use: `neutral` or `error`.',
        defaultValue: 'AstryxToastType.neutral',
      ),
      DocProp(
        'action',
        'Widget?',
        'An optional action — "Undo", "Retry".',
      ),
      DocProp(
        'duration',
        'Duration',
        'How long it stays. `Duration.zero` keeps it until dismissed.',
        defaultValue: 'Duration(seconds: 5)',
      ),
      DocProp(
        'dismissible',
        'bool',
        'Whether to show a dismiss button.',
        defaultValue: 'true',
      ),
    ]),
    DocApi(
      'AstryxToastController',
      <DocProp>[
        DocProp(
          'maxVisible',
          'int',
          'How many toasts are shown at once.',
          defaultValue: '5',
        ),
        DocProp(
          'visible',
          'List<AstryxToast>',
          'What is on screen, '
              'oldest first.',
        ),
        DocProp(
          'show(toast)',
          'VoidCallback',
          'Queues a toast and returns a handle that dismisses it.',
        ),
        DocProp('clear()', 'void', 'Removes everything.'),
      ],
      description:
          'Reach it with `AstryxToastScope.of(context)`, or '
          '`maybeOf(context)` where a scope might be absent.',
    ),
  ],
);
