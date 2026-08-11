# Overlays

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxPopover

`lib/src/components/overlay/popover.dart` · upstream `Popover / usePopover`

A floating panel anchored to a trigger, with trapped focus.

```dart
class PopoverDemoExample extends StatelessWidget {
  const PopoverDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxPopover(
      label: 'Filters',
      width: 260,
      content: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Filters', level: 5),
          const AstryxTextInput(label: 'Owner', placeholder: 'Anyone'),
          AstryxButton(
            label: 'Apply',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      // A builder, not a child: a button consumes its own taps, so the popover
      // hands you the controller and lets you wire it where it belongs.
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'Filters', onPressed: controller.toggle),
    );
  }
}
```

**Rules**

- **Accessibility:** Focus is trapped in the panel while it is open and returns to the trigger when it closes. Give the panel a `label`: it is a container a screen reader will announce on entry, and "group" is not a useful name.

| Property | Does |
| --- | --- |
| `side` | The **preferred** side. The positioner flips to the opposite one when there is no room. |
| `align` | Alignment along the anchor’s edge: `start`, `center` or `end`. The overlay shifts along that edge to stay on screen. |

### AstryxPopover

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `triggerBuilder` **(required)** | `Widget Function(BuildContext, AstryxOverlayController)` | — | Builds the trigger, given the controller that opens the panel. |
| `content` **(required)** | `Widget` | — | The floating content. |
| `controller` | `AstryxOverlayController?` | — | Drives the popover from outside. Null makes it uncontrolled. |
| `label` | `String?` | — | An accessible name for the panel. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.center` | Alignment along the trigger’s edge. |
| `width` | `double?` | — | A fixed width. Null sizes to the content. |
| `matchTriggerWidth` | `bool` | `false` | Whether the panel is at least as wide as its trigger. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `trapFocus` | `bool` | `true` | Whether focus is trapped inside while open. |
| `barrierDismissible` | `bool` | `true` | Whether a press outside closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the panel opens or closes. |

### AstryxOverlayController

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `isOpen` | `bool` | — | Whether the overlay is showing. |
| `show()` | `void` | — | Shows it. |
| `hide()` | `void` | — | Hides it. |
| `toggle()` | `void` | — | Shows it if hidden, hides it if shown. |

---

## AstryxTooltip

`lib/src/components/overlay/tooltip.dart` · upstream `Tooltip / useTooltip`

A short phrase on hover, focus, or long-press.

```dart
class TooltipDemoExample extends StatelessWidget {
  const TooltipDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTooltip(
      message: 'Archive this conversation',
      child: AstryxIconButton(
        icon: AstryxIconName.check,
        label: 'Archive',
        onPressed: () {},
      ),
    );
  }
}
```

**Rules**

- **Careful:** Never put anything essential in a tooltip alone. On touch it is unreachable until someone thinks to long-press, and on a keyboard it arrives only on focus. A tooltip repeats or clarifies; it does not inform.

### AstryxTooltip

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `message` **(required)** | `String` | — | The text to show. Keep it short. |
| `child` **(required)** | `Widget` | — | The trigger. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.top` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.center` | Alignment along the trigger’s edge. |
| `waitDuration` | `Duration` | `Duration(milliseconds: 200)` | How long a pointer must rest before the tooltip appears. |
| `exitDuration` | `Duration` | `Duration.zero` | How long after the pointer leaves before it hides. |
| `showDuration` | `Duration` | `Duration(milliseconds: 1500)` | How long a long-press tooltip stays after the finger lifts. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `maxWidth` | `double` | `300` | The widest the tooltip may be before its text wraps. |
| `enabled` | `bool` | `true` | Whether the tooltip responds at all. |
| `excludeFromSemantics` | `bool` | `false` | Whether to leave the message out of the trigger’s semantics. |

---

## AstryxHoverCard

`lib/src/components/overlay/hover_card.dart` · upstream `HoverCard / useHoverCard`

A rich preview on hover, that stays open when you reach it.

```dart
class HoverCardDemoExample extends StatelessWidget {
  const HoverCardDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Hover the mention. The card stays open while the pointer is on it, so
    // what is inside can be read, selected and pressed.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        const AstryxText('Assigned to'),
        AstryxHoverCard(
          label: 'Ada Lovelace',
          content: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const AstryxHeading(
                'Ada Lovelace',
                type: AstryxHeadingType.display3,
              ),
              const AstryxText(
                'Platform team · Cambridge',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              const AstryxText('Owns the scheduler and the retry engine.'),
              AstryxButton(label: 'View profile', onPressed: () {}),
            ],
          ),
          child: const AstryxText('@ada', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** Nothing may live **only** in a hover card. It needs a pointer or a deliberate long-press, it is gone as soon as attention moves, and a screen-reader user meets it only if they happen to focus the trigger. Treat it as a shortcut to something reachable by going there.
- **Accessibility:** Focus on the trigger opens the card immediately, with no wait — the delay exists to filter passing pointers, and a keyboard user did not pass through by accident. Focus is never trapped: the page behind it is still live.

|   | Tooltip | Hover card | Popover |
| --- | --- | --- | --- |
| Opens on | hover, focus, long-press | the same | a press |
| Content | one phrase | a panel | a panel |
| Interactive | no | yes | yes |
| Traps focus | no | no | yes, by default |

| Property | Does |
| --- | --- |
| `side` | The **preferred** side. The positioner flips to the opposite one when there is no room. |
| `align` | Alignment along the anchor’s edge: `start`, `center` or `end`. The overlay shifts along that edge to stay on screen. |

### AstryxHoverCard

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The trigger. |
| `content` **(required)** | `Widget` | — | The card’s content. |
| `controller` | `AstryxOverlayController?` | — | Drives the card from outside. Null makes it uncontrolled. |
| `label` | `String?` | — | An accessible name for the card. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.start` | Alignment along the trigger’s edge. |
| `width` | `double?` | `300` | The card’s width. Null sizes to the content. |
| `waitDuration` | `Duration` | `Duration(milliseconds: 300)` | How long a pointer must rest on the trigger first. |
| `exitDuration` | `Duration` | `Duration(milliseconds: 200)` | The grace period after the pointer leaves both the trigger and the card. |
| `showArrow` | `bool` | `false` | Whether to draw a pointer at the trigger. |
| `enabled` | `bool` | `true` | Whether the card responds at all. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the card opens or closes. |

---

## AstryxDropdownMenu

`lib/src/components/overlay/dropdown_menu.dart` · upstream `DropdownMenu / DropdownMenuItem / DropdownMenuCheckboxItem / DropdownMenuRadioGroup / DropdownMenuRadioItem / DropdownMenuSubMenu`

A list of actions, with sections, submenus and full keyboard support.

```dart
class DropdownMenuDemoExample extends StatefulWidget {
  const DropdownMenuDemoExample({super.key});

  @override
  State<DropdownMenuDemoExample> createState() =>
      _DropdownMenuDemoExampleState();
}

class _DropdownMenuDemoExampleState extends State<DropdownMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxDropdownMenu(
          label: 'Actions',
          width: 220,
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Rename',
              icon: const AstryxIcon(AstryxIconName.wrench),
              onSelected: () => setState(() => _last = 'Rename'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              icon: const AstryxIcon(AstryxIconName.copy),
              onSelected: () => setState(() => _last = 'Duplicate'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'Delete'),
            ),
          ],
          triggerBuilder: (context, controller) =>
              AstryxButton(label: 'Actions', onPressed: controller.toggle),
        ),
        AstryxText(
          'Last chosen: $_last',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** A menu performs **actions**. To pick a *value*, use AstryxSelector (references/forms.md) — it reports a selection, shows which option is current, and can be validated.
- **Accessibility:** Sections and dividers are skipped by the keyboard, so arrowing never lands on something that does nothing. A disabled item stays visible and is announced as disabled — with a `description` it can even say why.

| Key | Does |
| --- | --- |
| `Enter` on the trigger | Opens the menu. |
| `↑` / `↓` | Moves the highlight without choosing anything, wrapping. |
| `Home` / `End` | Jumps to the first or last item. |
| a letter | Jumps to the first item starting with it. |
| `→` | Opens a submenu. Mirrored under RTL. |
| `←` | Closes it. Mirrored under RTL. |
| `Enter` | Chooses the highlighted item; the menu closes first, then the callback runs. |
| `Escape` | Closes the menu, not the page behind it. |

### AstryxDropdownMenu

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxMenuEntry>` | — | The rows, in order. |
| `triggerBuilder` **(required)** | `Widget Function(BuildContext, AstryxOverlayController)` | — | Builds the trigger, given the controller that opens the menu. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |
| `label` | `String?` | — | An accessible name for the surface. |
| `side` | `AstryxOverlaySide` | `AstryxOverlaySide.bottom` | The preferred side. |
| `align` | `AstryxOverlayAlign` | `AstryxOverlayAlign.start` | Alignment along the trigger’s edge. |
| `width` | `double?` | — | A fixed width. Null sizes to the widest row. |
| `matchTriggerWidth` | `bool` | `true` | Whether the menu is at least as wide as its trigger. |
| `maxHeight` | `double` | `300` | The tallest the menu may be before it scrolls. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the menu opens or closes. |

### AstryxMenuItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and this item’s accessible name. |
| `onSelected` | `VoidCallback?` | — | Called when the item is chosen. The menu closes first. |
| `icon` | `Widget?` | — | An icon before the label. |
| `description` | `String?` | — | Secondary text below the label. |
| `trailing` | `Widget?` | — | Content after the label — a shortcut hint, a badge. |
| `enabled` | `bool` | `true` | Whether the item can be chosen. |
| `destructive` | `bool` | `false` | Whether the action is irreversible, which colours it with `--color-error`. |
| `submenu` | `List<AstryxMenuEntry>` | `const <AstryxMenuEntry>[]` | Nested entries. A non-empty list turns this row into a submenu. |

---

## AstryxContextMenu

`lib/src/components/overlay/context_menu.dart` · upstream `ContextMenu / ContextMenuItem`

A menu raised by a secondary click, at the pointer.

```dart
class ContextMenuDemoExample extends StatefulWidget {
  const ContextMenuDemoExample({super.key});

  @override
  State<ContextMenuDemoExample> createState() => _ContextMenuDemoExampleState();
}

class _ContextMenuDemoExampleState extends State<ContextMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    // Secondary-click the card — or long-press it on a touch screen. The menu
    // opens where the pointer is, not against the card's edge.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxContextMenu(
          label: 'Request actions',
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Open in new tab',
              onSelected: () => setState(() => _last = 'opened'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              onSelected: () => setState(() => _last = 'duplicated'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'deleted'),
            ),
          ],
          child: const AstryxCard(
            width: 300,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText('GET /v1/projects/atlas'),
                AstryxText(
                  'Last run 14:02 · 204 ms',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
        ),
        AstryxText(
          'Last action: $_last',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** Because it is not discoverable, **nothing may live only here**. A right-click has no keyboard equivalent and no visible affordance: a user who never tries it never learns the actions exist. Give each entry second home — a toolbar, a row menu, a details panel — and let this be the shortcut for people who already know.
- **Accessibility:** The menu takes focus when it opens, so the arrows have somewhere to land, and gives it back when it closes. Every row is announced as a button; sections and dividers are skipped.

|   | Dropdown menu | Context menu |
| --- | --- | --- |
| Opened by | a press on its trigger | a secondary click |
| On touch | the same press | a long-press |
| Anchored to | the trigger’s edge | the pointer |
| Discoverable | yes — it is a control | **no** |

| Key | Does |
| --- | --- |
| `↑` / `↓` | Moves the highlight, wrapping. |
| `Home` / `End` | Jumps to the first or last item. |
| a letter | Jumps to the first item starting with it. |
| `→` / `←` | Opens and closes a submenu. Mirrored under RTL. |
| `Enter` | Chooses the highlighted item; the menu closes first, then the callback runs. |
| `Escape` | Closes the menu, not the page behind it. |

### AstryxContextMenu

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `entries` **(required)** | `List<AstryxMenuEntry>` | — | The rows, in order. Shared with `AstryxDropdownMenu`. |
| `child` **(required)** | `Widget` | — | The region a secondary click opens the menu over. |
| `label` | `String?` | — | An accessible name for the surface. |
| `enabled` | `bool` | `true` | Whether the menu can be opened. |
| `width` | `double?` | — | A fixed width. Null sizes the menu up to `maxWidth`. |
| `maxWidth` | `double` | `280` | The widest the menu may become. |
| `maxHeight` | `double` | `300` | The tallest the menu may be before it scrolls. |
| `longPressOnTouch` | `bool` | `true` | Whether a long-press opens it in touch density. |
| `onOpenChange` | `ValueChanged<bool>?` | — | Called whenever the menu opens or closes. |

---

## AstryxDialog

`lib/src/components/overlay/dialog.dart` · upstream `Dialog / DialogHeader / useImperativeDialog`

A modal panel anchored to the viewport, with a scrolling body.

```dart
class DialogDemoExample extends StatefulWidget {
  const DialogDemoExample({super.key});

  @override
  State<DialogDemoExample> createState() => _DialogDemoExampleState();
}

class _DialogDemoExampleState extends State<DialogDemoExample> {
  final AstryxDialogController _controller = AstryxDialogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The dialog is a widget in the tree, not a `showDialog` call. It renders
    // nothing until its controller opens it — so it can sit next to whatever
    // opens it, and the state that drives it stays yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete project',
          variant: AstryxButtonVariant.destructive,
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Delete project',
          description: 'This cannot be undone.',
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Cancel', onPressed: _controller.hide),
              AstryxButton(
                label: 'Delete',
                variant: AstryxButtonVariant.destructive,
                onPressed: _controller.hide,
              ),
            ],
          ),
          child: const AstryxText(
            'Everything in this project will be permanently removed, '
            'including its request history.',
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Focus is trapped inside while the dialog is open and returns to the trigger when it closes. `title` is the accessible name, so a dialog without one is announced as an unnamed container.

### AstryxDialog

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxDialogController` | — | The open/closed state. |
| `child` **(required)** | `Widget` | — | The body. |
| `title` | `String?` | — | The heading, which also names the dialog for a screen reader. |
| `description` | `String?` | — | Supporting text below the title. |
| `footer` | `Widget?` | — | The action row, pinned below the scrolling body. |
| `width` | `double` | `480` | The dialog’s width. Never exceeds the viewport minus its padding. |
| `showCloseButton` | `bool` | `true` | Whether to show a close button in the header. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the barrier closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `onDismiss` | `VoidCallback?` | — | Called when the dialog dismisses itself. |

### AstryxDialogController

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `isOpen` | `bool` | — | Whether the dialog is showing. |
| `show()` | `void` | — | Shows it. |
| `hide()` | `void` | — | Hides it. |

---

## AstryxAlertDialog

`lib/src/components/overlay/alert_dialog.dart` · upstream `AlertDialog / useImperativeAlertDialog`

A modal that interrupts to confirm one consequential action.

```dart
class AlertDialogDemoExample extends StatefulWidget {
  const AlertDialogDemoExample({super.key});

  @override
  State<AlertDialogDemoExample> createState() => _AlertDialogDemoExampleState();
}

class _AlertDialogDemoExampleState extends State<AlertDialogDemoExample> {
  final AstryxDialogController _controller = AstryxDialogController();
  String _outcome = '—';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The barrier does not dismiss, there is no close button, and focus starts
    // on Cancel. All three exist so the question cannot be answered by
    // accident.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete project',
          variant: AstryxButtonVariant.destructive,
          onPressed: _controller.show,
        ),
        AstryxText(
          'Last answer: $_outcome',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        AstryxAlertDialog(
          controller: _controller,
          title: 'Delete Atlas?',
          description:
              'Atlas and its 4,102 saved requests will be removed for everyone '
              'in the workspace. This cannot be undone.',
          confirmLabel: 'Delete project',
          destructive: true,
          onConfirm: () => setState(() => _outcome = 'deleted'),
          onCancel: () => setState(() => _outcome = 'kept'),
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** Use a dialog (references/overlays.md) whenever the user is *doing* something rather than confirming something. An alert dialog spent on ordinary work trains people to dismiss the one that matters.
- **Accessibility:** Focus is trapped while it is open and returns to whatever opened it. `title` is the accessible name, and the confirming button should name the action — "Delete project", not "OK", because that button is read on its own by anyone tabbing to it.

|   | Dialog | Alert dialog |
| --- | --- | --- |
| Barrier press | closes it | **does nothing** |
| Close button | yes | no — the buttons are the way out |
| Escape | closes it | cancels |
| Focus on open | the first control | **cancel** |
| Body | anything | a consequence, then anything |

### AstryxAlertDialog

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxDialogController` | — | The open/closed state. |
| `title` **(required)** | `String` | — | The question, as a statement. Also the accessible name. |
| `description` **(required)** | `String` | — | What confirming will do. |
| `confirmLabel` **(required)** | `String` | — | The label on the confirming button. Name the action. |
| `onConfirm` | `VoidCallback?` | — | Called after the dialog closes on confirm. |
| `cancelLabel` | `String?` | — | The label on the cancelling button. Defaults to the localised "Cancel". |
| `onCancel` | `VoidCallback?` | — | Called on cancel — by the button, by Escape, or by the barrier where it is dismissible. |
| `destructive` | `bool` | `false` | Whether confirming is irreversible, which colours that button with `--color-error`. |
| `width` | `double` | `420` | The dialog’s width. |
| `showCancel` | `bool` | `true` | Whether to offer a cancelling button at all. |
| `barrierDismissible` | `bool` | `false` | Whether a press on the barrier cancels. |
| `escapeDismissible` | `bool` | `true` | Whether Escape cancels. |
| `child` | `Widget?` | — | Extra content below the description. |

---

## AstryxOverlay

`lib/src/components/overlay/overlay_layer.dart` · upstream `Overlay`

The scrim-and-layer primitive the modals are built on.

```dart
class OverlayDemoExample extends StatefulWidget {
  const OverlayDemoExample({super.key});

  @override
  State<OverlayDemoExample> createState() => _OverlayDemoExampleState();
}

class _OverlayDemoExampleState extends State<OverlayDemoExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The modal contract with nothing on top of it: scrim, focus trap, Escape,
    // barrier dismissal. What sits on the layer is entirely yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Open preview', onPressed: _controller.show),
        AstryxOverlay(
          controller: _controller,
          label: 'Preview',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'atlas-scheduler.png',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxSkeleton(height: 120),
                AstryxButton(label: 'Close', onPressed: _controller.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** Turning `showScrim` off leaves focus trapped unless `trapFocus` is off too. A layer that looks non-modal while behaving modally is worse than either one on its own.
- **Accessibility:** `scopesRoute` is what tells a screen reader the rest of the page is inert, and `label` is what names the layer. Set `scopesRoute: false` for something merely floating — announcing a page as unavailable when it is not is worse than saying nothing.

### AstryxOverlay

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxOverlayController` | — | The open/closed state. |
| `child` **(required)** | `Widget` | — | What sits on the layer. |
| `alignment` | `AlignmentGeometry` | `Alignment.center` | Where the child sits in the viewport. |
| `padding` | `EdgeInsetsGeometry?` | `--spacing-4` | The inset from the viewport edge. |
| `showScrim` | `bool` | `true` | Whether to dim the page behind it. |
| `scrimColor` | `AstryxColorToken?` | `AstryxColorToken.overlay` | The scrim’s colour. |
| `barrierDismissible` | `bool` | `true` | Whether a press on the scrim closes it. |
| `escapeDismissible` | `bool` | `true` | Whether Escape closes it. |
| `trapFocus` | `bool` | `true` | Whether focus is trapped inside while open. |
| `restoreFocus` | `bool` | `true` | Whether focus returns to whatever opened it. |
| `transition` | `AstryxOverlayTransition` | `AstryxOverlayTransition.scale` | How it enters and leaves. `slide` has no anchor here and fades. |
| `duration` | `AstryxDurationToken` | `AstryxDurationToken.mediumMax` | How long the entry and exit take. |
| `label` | `String?` | — | The layer’s accessible name. |
| `scopesRoute` | `bool` | `true` | Whether the page behind it is announced as inert. |
| `onDismiss` | `VoidCallback?` | — | Called when the layer dismisses itself. |

---

## AstryxToast

`lib/src/components/overlay/toast.dart` · upstream `Toast / useToast`

A transient message in the corner, with an optional action.

```dart
class ToastDemoExample extends StatelessWidget {
  const ToastDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `AstryxThemeProvider` and `AstryxApp` install the host, so there is
    // nothing to wire: reach for the scope and show one.
    return AstryxButton(
      label: 'Archive project',
      onPressed: () => AstryxToastScope.of(
        context,
      ).show(const AstryxToast(message: 'Project archived')),
    );
  }
}
```

**Rules**

- **Note:** Hover and focus both pause the timeout. A toast that vanishes while the user is reaching for its Undo button has actively made things worse.
- **Accessibility:** A toast is announced when it appears, and can be dismissed from the keyboard. It is still the weakest place to put information: it is gone in five seconds and it is nowhere near what the user was looking at. For anything that must be acted on, use a banner (references/surfaces.md).

### AstryxToast

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `message` **(required)** | `String` | — | What to tell the user. |
| `type` | `AstryxToastType` | `AstryxToastType.neutral` | Which surface to use: `neutral` or `error`. |
| `action` | `Widget?` | — | An optional action — "Undo", "Retry". |
| `duration` | `Duration` | `Duration(seconds: 5)` | How long it stays. `Duration.zero` keeps it until dismissed. |
| `dismissible` | `bool` | `true` | Whether to show a dismiss button. |

### AstryxToastController

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `maxVisible` | `int` | `5` | How many toasts are shown at once. |
| `visible` | `List<AstryxToast>` | — | What is on screen, oldest first. |
| `show(toast)` | `VoidCallback` | — | Queues a toast and returns a handle that dismisses it. |
| `clear()` | `void` | — | Removes everything. |

---

## AstryxCollapsible

`lib/src/components/overlay/collapsible.dart` · upstream `Collapsible / useCollapsible`

A disclosure: a header that shows and hides its own content.

```dart
class CollapsibleDemoExample extends StatelessWidget {
  const CollapsibleDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The whole header is the button, and it carries the expanded state in its
    // semantics — so a screen reader says "collapsed" without seeing a chevron.
    return const SizedBox(
      width: 360,
      child: AstryxCollapsible(
        title: 'Advanced settings',
        description: 'Timeouts, retries and headers',
        child: AstryxText(
          'Requests time out after 30 seconds and are retried twice with an '
          'exponential backoff.',
        ),
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The header is a button that carries `expanded` in its semantics, so a screen reader announces the state rather than the user inferring it from a rotated chevron. Collapsed content is **not in the tree** — no layout, no semantics, and no focus stops behind a closed section.

| Key | Does |
| --- | --- |
| `Tab` | Moves to the header, which takes focus. |
| `Enter` / `Space` | Expands or collapses it. |

### AstryxCollapsible

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `title` **(required)** | `String` | — | The header text, and the header button’s accessible name. |
| `child` **(required)** | `Widget` | — | The content shown while expanded. |
| `controller` | `AstryxCollapsibleController?` | — | Drives the expanded state from outside. Null keeps it internal. |
| `initiallyExpanded` | `bool` | `false` | Whether the content starts visible. Ignored with a `controller`. |
| `description` | `String?` | — | Secondary text below the title. |
| `leading` | `Widget?` | — | A widget before the title. |
| `trailing` | `Widget?` | — | A widget after the title. Not interactive — the header is one button. |
| `enabled` | `bool` | `true` | Whether the header responds. |
| `onExpansionChanged` | `ValueChanged<bool>?` | — | Called with the new state whenever it expands or collapses. |

### AstryxCollapsibleController

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `isExpanded` | `bool` | — | Whether the content is showing. |
| `expand()` | `void` | — | Shows it. |
| `collapse()` | `void` | — | Hides it. |
| `toggle()` | `void` | — | Shows it if hidden, hides it if shown. |

---

## AstryxCollapsibleGroup

`lib/src/components/overlay/collapsible_group.dart` · upstream `CollapsibleGroup`

Several collapsibles as one section, optionally an accordion.

```dart
class CollapsibleGroupDemoExample extends StatelessWidget {
  const CollapsibleGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The default: sections divided into one block, each owning its own state.
    // Two can be open at once, which is what makes them comparable.
    return const SizedBox(
      width: 380,
      child: AstryxCollapsibleGroup(
        children: <AstryxCollapsible>[
          AstryxCollapsible(
            title: 'Billing',
            description: 'Plan, invoices and payment method',
            child: AstryxText('Team plan · renews 4 April · Visa ···· 4242'),
          ),
          AstryxCollapsible(
            title: 'Members',
            description: '12 people, 3 pending invitations',
            child: AstryxText('Owners: Ada, Priya. Everyone else can deploy.'),
          ),
          AstryxCollapsible(
            title: 'Audit log',
            description: 'Everything anyone changed',
            child: AstryxText('Retained for 90 days on this plan.'),
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Careful:** Exclusive is not the default, and should not be your default either. It saves vertical space by removing the one thing a set of sections is good for — comparing two of them. Use it where the panels are long enough that two open at once is worse than switching.

### AstryxCollapsibleGroup

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<AstryxCollapsible>` | — | The sections, in order. |
| `exclusive` | `bool` | `false` | Whether opening one section closes the others. |
| `initialIndex` | `int?` | — | Which section starts open when `exclusive`. Null opens none. |
| `divided` | `bool` | `true` | Whether to draw a rule between sections. |
| `onChanged` | `ValueChanged<int?>?` | — | Called with the index now open. Only fires for an exclusive group. |

---

