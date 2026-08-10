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

