import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Everything that floats above the page — and the disclosures that do the
/// same job inside it.
final List<DocPage> overlayPages = <DocPage>[
  _popover,
  _tooltip,
  _hoverCard,
  _dropdownMenu,
  _contextMenu,
  _dialog,
  _alertDialog,
  _overlay,
  _toast,
  _collapsible,
  _collapsibleGroup,
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

const DocPage _hoverCard = DocPage(
  id: 'hover_card',
  title: 'AstryxHoverCard',
  group: _group,
  description: 'A rich preview on hover, that stays open when you reach it.',
  source: 'lib/src/components/overlay/hover_card.dart',
  upstream: 'HoverCard / useHoverCard',
  upstreamPath: '/components/HoverCard',
  blocks: <DocBlock>[
    DocExample('hover_card_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxHoverCard(
  label: 'Ada Lovelace',
  content: const UserSummary(),
  child: const AstryxText('@ada'),
)'''),
    DocProse(
      'A `child`, not a builder — like a tooltip and unlike a popover. It '
      'opens on hover rather than on a press, so it never competes for the '
      'tap, and the trigger stays whatever it already was: a link, a '
      'mention, an avatar.',
    ),
    DocHeading('Why it is not a tooltip'),
    DocProse(
      'The card **survives the pointer arriving on it**. That single behaviour '
      'is the component: it is what lets the content hold a button, a link, or '
      'text worth selecting, none of which a tooltip can do because a tooltip '
      'disappears the moment you reach for it.',
    ),
    DocTable(
      headers: <String>['', 'Tooltip', 'Hover card', 'Popover'],
      rows: <List<String>>[
        <String>['Opens on', 'hover, focus, long-press', 'the same', 'a press'],
        <String>['Content', 'one phrase', 'a panel', 'a panel'],
        <String>['Interactive', 'no', 'yes', 'yes'],
        <String>['Traps focus', 'no', 'no', 'yes, by default'],
      ],
    ),
    DocHeading('Timing'),
    DocProse(
      '`waitDuration` filters a mouse on its way somewhere else — longer than '
      'a tooltip’s, because a panel under every passing pointer makes a '
      'page feel booby-trapped. `exitDuration` is the grace period for '
      'crossing the gap from the trigger onto the card; set it to zero and it '
      'becomes unreachable.',
    ),
    DocExample('hover_card_timing'),
    DocHeading('Positioning'),
    DocProse(
      'The same positioner as every other anchored overlay: it flips, shifts '
      'and shrinks to stay on screen.',
    ),
    DocTable(headers: <String>['Property', 'Does'], rows: _positioningRows),
    DocExample('hover_card_sides'),
    DocHeading('Touch'),
    DocProse(
      'A long-press opens it, and — because touch has no pointer-exit to '
      'close it with — the next press anywhere closes it again. That is the '
      'only path here that arms a barrier.',
    ),
    DocCallout.warning(
      'Nothing may live **only** in a hover card. It needs a pointer or a '
      'deliberate long-press, it is gone as soon as attention moves, and a '
      'screen-reader user meets it only if they happen to focus the trigger. '
      'Treat it as a shortcut to something reachable by going there.',
    ),
    DocCallout.accessibility(
      'Focus on the trigger opens the card immediately, with no wait — the '
      'delay exists to filter passing pointers, and a keyboard user did not '
      'pass through by accident. Focus is never trapped: the page behind it is '
      'still live.',
    ),
    DocApi('AstryxHoverCard', <DocProp>[
      DocProp('child', 'Widget', 'The trigger.', required: true),
      DocProp('content', 'Widget', 'The card’s content.', required: true),
      DocProp(
        'controller',
        'AstryxOverlayController?',
        'Drives the card from outside. Null makes it uncontrolled.',
      ),
      DocProp('label', 'String?', 'An accessible name for the card.'),
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
        'The card’s width. Null sizes to the content.',
        defaultValue: '300',
      ),
      DocProp(
        'waitDuration',
        'Duration',
        'How long a pointer must rest on the trigger first.',
        defaultValue: 'Duration(milliseconds: 300)',
      ),
      DocProp(
        'exitDuration',
        'Duration',
        'The grace period after the pointer leaves both the trigger and the '
            'card.',
        defaultValue: 'Duration(milliseconds: 200)',
      ),
      DocProp(
        'showArrow',
        'bool',
        'Whether to draw a pointer at the trigger.',
        defaultValue: 'false',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the card responds at all.',
        defaultValue: 'true',
      ),
      DocProp(
        'onOpenChange',
        'ValueChanged<bool>?',
        'Called whenever the card opens or closes.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTooltip](tooltip) — for a phrase, not a panel.',
      '[AstryxPopover](popover) — when a press should open it and keep it '
          'open.',
    ]),
  ],
);

const DocPage _contextMenu = DocPage(
  id: 'context_menu',
  title: 'AstryxContextMenu',
  group: _group,
  description: 'A menu raised by a secondary click, at the pointer.',
  source: 'lib/src/components/overlay/context_menu.dart',
  upstream: 'ContextMenu / ContextMenuItem',
  upstreamPath: '/components/ContextMenu',
  blocks: <DocBlock>[
    DocExample('context_menu_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxContextMenu(
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: delete),
  ],
  child: const RowOfTheTable(),
)'''),
    DocProse(
      'The same `AstryxMenuEntry` rows as a '
      '[dropdown menu](dropdown_menu), with the same keyboard model — arrows, '
      'Home and End, type-ahead, submenus, Escape. What differs is what opens '
      'it and where it lands.',
    ),
    DocTable(
      headers: <String>['', 'Dropdown menu', 'Context menu'],
      rows: <List<String>>[
        <String>['Opened by', 'a press on its trigger', 'a secondary click'],
        <String>['On touch', 'the same press', 'a long-press'],
        <String>['Anchored to', 'the trigger’s edge', 'the pointer'],
        <String>['Discoverable', 'yes — it is a control', '**no**'],
      ],
    ),
    DocCallout.warning(
      'Because it is not discoverable, **nothing may live only here**. A '
      'right-click has no keyboard equivalent and no visible affordance: a '
      'user who never tries it never learns the actions exist. Give each entry '
      'second home — a toolbar, a row menu, a details panel — and let this be '
      'the shortcut for people who already know.',
    ),
    DocHeading('The same rows as a menu'),
    DocExample('context_menu_sections'),
    DocHeading('Width'),
    DocProse(
      'A dropdown is bounded by its trigger; this one is anchored to a point, '
      'so `maxWidth` bounds it instead — 280 by default. Without a bound the '
      'rows would stretch to the viewport, which is not a menu.',
    ),
    DocHeading('On the web'),
    DocProse(
      'The browser’s own menu appears over this one unless the app turns '
      'it off once at startup.',
    ),
    DocCode('''
if (kIsWeb) await BrowserContextMenu.disableContextMenu();'''),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`↑` / `↓`', 'Moves the highlight, wrapping.'],
        <String>['`Home` / `End`', 'Jumps to the first or last item.'],
        <String>['a letter', 'Jumps to the first item starting with it.'],
        <String>[
          '`→` / `←`',
          'Opens and closes a submenu. Mirrored under RTL.',
        ],
        <String>[
          '`Enter`',
          'Chooses the highlighted item; the menu closes '
              'first, then the callback runs.',
        ],
        <String>['`Escape`', 'Closes the menu, not the page behind it.'],
      ],
    ),
    DocCallout.accessibility(
      'The menu takes focus when it opens, so the arrows have somewhere to '
      'land, and gives it back when it closes. Every row is announced as a '
      'button; sections and dividers are skipped.',
    ),
    DocApi('AstryxContextMenu', <DocProp>[
      DocProp(
        'entries',
        'List<AstryxMenuEntry>',
        'The rows, in order. Shared with `AstryxDropdownMenu`.',
        required: true,
      ),
      DocProp(
        'child',
        'Widget',
        'The region a secondary click opens the menu over.',
        required: true,
      ),
      DocProp('label', 'String?', 'An accessible name for the surface.'),
      DocProp(
        'enabled',
        'bool',
        'Whether the menu can be opened.',
        defaultValue: 'true',
      ),
      DocProp(
        'width',
        'double?',
        'A fixed width. Null sizes the menu up to `maxWidth`.',
      ),
      DocProp(
        'maxWidth',
        'double',
        'The widest the menu may become.',
        defaultValue: '280',
      ),
      DocProp(
        'maxHeight',
        'double',
        'The tallest the menu may be before it scrolls.',
        defaultValue: '300',
      ),
      DocProp(
        'longPressOnTouch',
        'bool',
        'Whether a long-press opens it in touch density.',
        defaultValue: 'true',
      ),
      DocProp(
        'onOpenChange',
        'ValueChanged<bool>?',
        'Called whenever the menu opens or closes.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDropdownMenu](dropdown_menu) — the discoverable version, and '
          'where the row types are documented.',
    ]),
  ],
);

const DocPage _alertDialog = DocPage(
  id: 'alert_dialog',
  title: 'AstryxAlertDialog',
  group: _group,
  description: 'A modal that interrupts to confirm one consequential action.',
  source: 'lib/src/components/overlay/alert_dialog.dart',
  upstream: 'AlertDialog / useImperativeAlertDialog',
  upstreamPath: '/components/AlertDialog',
  blocks: <DocBlock>[
    DocExample('alert_dialog_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxAlertDialog(
  controller: _confirm,
  title: 'Delete Atlas?',
  description: 'Atlas and its 4,102 requests will be removed. This cannot '
      'be undone.',
  confirmLabel: 'Delete project',
  destructive: true,
  onConfirm: _delete,
)'''),
    DocProse(
      'It takes the same `AstryxDialogController` a [dialog](dialog) does, '
      'because an alert dialog **is** a dialog with the answers built in. What '
      'differs is not how it looks: it is that it is deliberately harder to '
      'leave by accident.',
    ),
    DocTable(
      headers: <String>['', 'Dialog', 'Alert dialog'],
      rows: <List<String>>[
        <String>['Barrier press', 'closes it', '**does nothing**'],
        <String>['Close button', 'yes', 'no — the buttons are the way out'],
        <String>['Escape', 'closes it', 'cancels'],
        <String>['Focus on open', 'the first control', '**cancel**'],
        <String>['Body', 'anything', 'a consequence, then anything'],
      ],
    ),
    DocProse(
      'Focus starting on cancel is the decision the rest follows from: a user '
      'who presses Enter out of habit must not delete anything. `description` '
      'is required for the same reason — a confirmation whose consequence is '
      'left to the title is one nobody can give informed consent to.',
    ),
    DocHeading('An acknowledgement'),
    DocProse(
      '`showCancel: false` for something there is no declining. One button, '
      'which then holds focus because it is the only way out.',
    ),
    DocExample('alert_dialog_acknowledge'),
    DocHeading('Carrying a decision'),
    DocProse(
      '`child` is for what a sentence cannot hold — a list of what will go, or '
      'one choice that travels with the answer.',
    ),
    DocExample('alert_dialog_extra'),
    DocCallout.note(
      'Use a [dialog](dialog) whenever the user is *doing* something rather '
      'than confirming something. An alert dialog spent on ordinary work '
      'trains people to dismiss the one that matters.',
    ),
    DocCallout.accessibility(
      'Focus is trapped while it is open and returns to whatever opened it. '
      '`title` is the accessible name, and the confirming button should name '
      'the action — "Delete project", not "OK", because that button is read on '
      'its own by anyone tabbing to it.',
    ),
    DocApi('AstryxAlertDialog', <DocProp>[
      DocProp(
        'controller',
        'AstryxDialogController',
        'The open/closed state.',
        required: true,
      ),
      DocProp(
        'title',
        'String',
        'The question, as a statement. Also the accessible name.',
        required: true,
      ),
      DocProp(
        'description',
        'String',
        'What confirming will do.',
        required: true,
      ),
      DocProp(
        'confirmLabel',
        'String',
        'The label on the confirming button. Name the action.',
        required: true,
      ),
      DocProp(
        'onConfirm',
        'VoidCallback?',
        'Called after the dialog closes on confirm.',
      ),
      DocProp(
        'cancelLabel',
        'String?',
        'The label on the cancelling button. Defaults to the localised '
            '"Cancel".',
      ),
      DocProp(
        'onCancel',
        'VoidCallback?',
        'Called on cancel — by the button, by Escape, or by the barrier where '
            'it is dismissible.',
      ),
      DocProp(
        'destructive',
        'bool',
        'Whether confirming is irreversible, which colours that button with '
            '`--color-error`.',
        defaultValue: 'false',
      ),
      DocProp('width', 'double', 'The dialog’s width.', defaultValue: '420'),
      DocProp(
        'showCancel',
        'bool',
        'Whether to offer a cancelling button at all.',
        defaultValue: 'true',
      ),
      DocProp(
        'barrierDismissible',
        'bool',
        'Whether a press on the barrier cancels.',
        defaultValue: 'false',
      ),
      DocProp(
        'escapeDismissible',
        'bool',
        'Whether Escape cancels.',
        defaultValue: 'true',
      ),
      DocProp('child', 'Widget?', 'Extra content below the description.'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDialog](dialog) — for anything with more than one outcome.',
      '[AstryxOverlay](overlay) — the layer both are built on.',
    ]),
  ],
);

const DocPage _overlay = DocPage(
  id: 'overlay',
  title: 'AstryxOverlay',
  group: _group,
  description: 'The scrim-and-layer primitive the modals are built on.',
  source: 'lib/src/components/overlay/overlay_layer.dart',
  upstream: 'Overlay',
  upstreamPath: '/components/Overlay',
  blocks: <DocBlock>[
    DocExample('overlay_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxOverlay(
  controller: _lightbox,
  label: 'Preview',
  child: AstryxCard(child: Image.network(url)),
)'''),
    DocProse(
      'The modal contract with **no opinion about what is on the layer**. '
      '[AstryxDialog](dialog) is this widget plus a header, a scrolling body '
      'and a footer; [AstryxAlertDialog](alert_dialog) is that plus the '
      'answers. Reach for this one directly when that shape is wrong — a '
      'lightbox, a command palette, a sheet.',
    ),
    DocHeading('What it guarantees'),
    DocList(<String>[
      'A scrim that dims the page and closes on a press.',
      'Focus trapped inside while open, and **restored to whatever opened '
          'it**.',
      'Escape closes it — and only it, never the layer beneath.',
      'An entry and exit that honour reduced motion.',
    ]),
    DocProse(
      'Like every overlay here it is a **widget in the tree**, not a '
      '`showDialog` call: it renders nothing until its controller opens it, so '
      'it can sit next to whatever opens it and there is no `BuildContext` to '
      'smuggle across an async gap.',
    ),
    DocHeading('Placement'),
    DocProse(
      '`alignment` puts the layer anywhere in the viewport. A sheet is an '
      'overlay aligned to the bottom edge, not a separate component.',
    ),
    DocExample('overlay_placement'),
    DocHeading('Composition'),
    DocTree('''
AstryxOverlay
├── scrim        ← dims the page. Presses dismiss unless told otherwise
└── child        ← positioned by `alignment`, inside `padding`
    └── focus trap, and the semantics that make the page behind it inert'''),
    DocCallout.note(
      'Turning `showScrim` off leaves focus trapped unless `trapFocus` is off '
      'too. A layer that looks non-modal while behaving modally is worse than '
      'either one on its own.',
    ),
    DocCallout.accessibility(
      '`scopesRoute` is what tells a screen reader the rest of the page is '
      'inert, and `label` is what names the layer. Set `scopesRoute: false` '
      'for something merely floating — announcing a page as unavailable when '
      'it is not is worse than saying nothing.',
    ),
    DocApi('AstryxOverlay', <DocProp>[
      DocProp(
        'controller',
        'AstryxOverlayController',
        'The open/closed state.',
        required: true,
      ),
      DocProp('child', 'Widget', 'What sits on the layer.', required: true),
      DocProp(
        'alignment',
        'AlignmentGeometry',
        'Where the child sits in the viewport.',
        defaultValue: 'Alignment.center',
      ),
      DocProp(
        'padding',
        'EdgeInsetsGeometry?',
        'The inset from the viewport edge.',
        defaultValue: '--spacing-4',
      ),
      DocProp(
        'showScrim',
        'bool',
        'Whether to dim the page behind it.',
        defaultValue: 'true',
      ),
      DocProp(
        'scrimColor',
        'AstryxColorToken?',
        'The scrim’s colour.',
        defaultValue: 'AstryxColorToken.overlay',
      ),
      DocProp(
        'barrierDismissible',
        'bool',
        'Whether a press on the scrim closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'escapeDismissible',
        'bool',
        'Whether Escape closes it.',
        defaultValue: 'true',
      ),
      DocProp(
        'trapFocus',
        'bool',
        'Whether focus is trapped inside while open.',
        defaultValue: 'true',
      ),
      DocProp(
        'restoreFocus',
        'bool',
        'Whether focus returns to whatever opened it.',
        defaultValue: 'true',
      ),
      DocProp(
        'transition',
        'AstryxOverlayTransition',
        'How it enters and leaves. `slide` has no anchor here and fades.',
        defaultValue: 'AstryxOverlayTransition.scale',
      ),
      DocProp(
        'duration',
        'AstryxDurationToken',
        'How long the entry and exit take.',
        defaultValue: 'AstryxDurationToken.mediumMax',
      ),
      DocProp('label', 'String?', 'The layer’s accessible name.'),
      DocProp(
        'scopesRoute',
        'bool',
        'Whether the page behind it is announced as inert.',
        defaultValue: 'true',
      ),
      DocProp(
        'onDismiss',
        'VoidCallback?',
        'Called when the layer dismisses itself.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxDialog](dialog) — this, with a panel.',
      '[AstryxAlertDialog](alert_dialog) — that, with the answers.',
    ]),
  ],
);

const DocPage _collapsible = DocPage(
  id: 'collapsible',
  title: 'AstryxCollapsible',
  group: _group,
  description: 'A disclosure: a header that shows and hides its own content.',
  source: 'lib/src/components/overlay/collapsible.dart',
  upstream: 'Collapsible / useCollapsible',
  upstreamPath: '/components/Collapsible',
  blocks: <DocBlock>[
    DocExample('collapsible_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxCollapsible(
  title: 'Advanced settings',
  description: 'Timeouts, retries and headers',
  child: const SettingsForm(),
)'''),
    DocProse(
      '**The whole header is the button.** Not the chevron: a disclosure whose '
      'arrow alone is pressable fails on a phone and on a keyboard both.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxCollapsible
├── leading       ← an icon, a status dot
├── title         ← the header text, and its accessible name
├── description   ← secondary text, announced as a hint
├── trailing      ← a count, a badge. Never a control
└── child         ← the content. Built only while it is showing'''),
    DocExample('collapsible_rich'),
    DocHeading('Controlled and uncontrolled'),
    DocProse(
      'With no `controller` it owns its own state and starts from '
      '`initiallyExpanded`. Pass one and the state is yours: anything can open '
      'the section, and you can watch it. Drop it into a '
      '[group](collapsible_group) instead and the group owns it.',
    ),
    DocExample('collapsible_controlled'),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves to the header, which takes focus.'],
        <String>['`Enter` / `Space`', 'Expands or collapses it.'],
      ],
    ),
    DocCallout.accessibility(
      'The header is a button that carries `expanded` in its semantics, so a '
      'screen reader announces the state rather than the user inferring it '
      'from a rotated chevron. Collapsed content is **not in the tree** — no '
      'layout, no semantics, and no focus stops behind a closed section.',
    ),
    DocApi('AstryxCollapsible', <DocProp>[
      DocProp(
        'title',
        'String',
        'The header text, and the header button’s accessible name.',
        required: true,
      ),
      DocProp(
        'child',
        'Widget',
        'The content shown while expanded.',
        required: true,
      ),
      DocProp(
        'controller',
        'AstryxCollapsibleController?',
        'Drives the expanded state from outside. Null keeps it internal.',
      ),
      DocProp(
        'initiallyExpanded',
        'bool',
        'Whether the content starts visible. Ignored with a `controller`.',
        defaultValue: 'false',
      ),
      DocProp('description', 'String?', 'Secondary text below the title.'),
      DocProp('leading', 'Widget?', 'A widget before the title.'),
      DocProp(
        'trailing',
        'Widget?',
        'A widget after the title. Not interactive — the header is one button.',
      ),
      DocProp(
        'enabled',
        'bool',
        'Whether the header responds.',
        defaultValue: 'true',
      ),
      DocProp(
        'onExpansionChanged',
        'ValueChanged<bool>?',
        'Called with the new state whenever it expands or collapses.',
      ),
    ]),
    DocApi(
      'AstryxCollapsibleController',
      <DocProp>[
        DocProp('isExpanded', 'bool', 'Whether the content is showing.'),
        DocProp('expand()', 'void', 'Shows it.'),
        DocProp('collapse()', 'void', 'Hides it.'),
        DocProp('toggle()', 'void', 'Shows it if hidden, hides it if shown.'),
      ],
      description: 'A `ChangeNotifier`. Dispose one you own.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCollapsibleGroup](collapsible_group) — several of these as one '
          'section.',
      '[AstryxTabList](tab_list) — when the sections are alternatives rather '
          'than details.',
    ]),
  ],
);

const DocPage _collapsibleGroup = DocPage(
  id: 'collapsible_group',
  title: 'AstryxCollapsibleGroup',
  group: _group,
  description: 'Several collapsibles as one section, optionally an accordion.',
  source: 'lib/src/components/overlay/collapsible_group.dart',
  upstream: 'CollapsibleGroup',
  upstreamPath: '/components/CollapsibleGroup',
  blocks: <DocBlock>[
    DocExample('collapsible_group_demo'),
    DocHeading('Usage'),
    DocCode('''
AstryxCollapsibleGroup(
  children: <AstryxCollapsible>[
    AstryxCollapsible(title: 'Billing', child: BillingPanel()),
    AstryxCollapsible(title: 'Members', child: MembersPanel()),
  ],
)'''),
    DocProse(
      'By default the group is only presentation: rules between the sections, '
      'so they read as a list rather than a pile of unrelated headers. Each '
      'section still owns its own state, and two can be open at once.',
    ),
    DocHeading('Exclusive — the accordion'),
    DocProse(
      '`exclusive: true` moves ownership to the group: opening one section '
      'closes the last, and `onChanged` reports which index is open, or null '
      'when they are all shut.',
    ),
    DocExample('collapsible_group_exclusive'),
    DocCallout.warning(
      'Exclusive is not the default, and should not be your default either. It '
      'saves vertical space by removing the one thing a set of sections is '
      'good for — comparing two of them. Use it where the panels are long '
      'enough that two open at once is worse than switching.',
    ),
    DocApi('AstryxCollapsibleGroup', <DocProp>[
      DocProp(
        'children',
        'List<AstryxCollapsible>',
        'The sections, in order.',
        required: true,
      ),
      DocProp(
        'exclusive',
        'bool',
        'Whether opening one section closes the others.',
        defaultValue: 'false',
      ),
      DocProp(
        'initialIndex',
        'int?',
        'Which section starts open when `exclusive`. Null opens none.',
      ),
      DocProp(
        'divided',
        'bool',
        'Whether to draw a rule between sections.',
        defaultValue: 'true',
      ),
      DocProp(
        'onChanged',
        'ValueChanged<int?>?',
        'Called with the index now open. Only fires for an exclusive group.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxCollapsible](collapsible) — one section, and where the header is '
          'documented.',
    ]),
  ],
);
