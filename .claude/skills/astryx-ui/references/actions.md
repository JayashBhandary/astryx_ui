# Actions

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxButton

`lib/src/components/action/button.dart` · upstream `Button`

A labelled action, in four levels of prominence.

```dart
class ButtonDemoExample extends StatelessWidget {
  const ButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Save changes',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Cancel', onPressed: () {}),
      ],
    );
  }
}
```

**Rules**

- **Careful:** One `primary` per view. Two primary buttons side by side is a question, not a recommendation.
- **Accessibility:** The focus ring appears for keyboard focus and not for a click, which is CSS's `:focus-visible` rule ported wholesale. A disabled or loading button is announced as disabled rather than silently ignoring presses.

| Variant | For |
| --- | --- |
| `primary` | The single most important action in a view. Filled with the accent. |
| `secondary` | The default. Reads as an action without competing with `primary`. |
| `ghost` | Transparent until interacted with. Low-emphasis or repeated actions — a toolbar, a row action. |
| `destructive` | Irreversible. Filled with the error colour. Pair it with a confirmation, not with regret. |

| Key | Does |
| --- | --- |
| `Tab` | Moves focus to the button. |
| `Enter` | Activates it. |
| `Space` | Activates it. |

### AstryxButton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the accessible name. |
| `onPressed` | `VoidCallback?` | — | Called on activation, by pointer or keyboard. Null makes the button inert. |
| `variant` | `AstryxButtonVariant?` | — | How prominent the button is. Null inherits from an enclosing `AstryxButtonGroup`, then falls back to `secondary`. |
| `size` | `AstryxButtonSize?` | — | The control height. Null inherits from an enclosing `AstryxSizeScope`, then falls back to `md`. |
| `enabled` | `bool` | `true` | Whether the button accepts interaction. |
| `loading` | `bool` | `false` | Whether an action is in flight. Shows a spinner, suppresses activation, and keeps the width. |
| `leading` | `Widget?` | — | Content before the label — usually an `AstryxIcon`. |
| `trailing` | `Widget?` | — | Content after the label — an icon or a badge. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `width` | `double?` | — | A fixed width. Null lets the label decide. |
| `href` | `Uri?` | — | A destination, handed to the `AstryxLinkDelegate`. |
| `focusNode` | `FocusNode?` | — | The focus node, if the caller owns one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides, merged over `AstryxThemeData.button`. |

---

## AstryxIconButton

`lib/src/components/action/icon_button.dart` · upstream `IconButton`

A square button holding a glyph instead of words.

```dart
class IconButtonDemoExample extends StatelessWidget {
  const IconButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.search,
          label: 'Search',
          tooltip: 'Search',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.funnel,
          label: 'Filter',
          tooltip: 'Filter',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.moreHorizontal,
          label: 'More actions',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** `label` is **required**, and it is not the tooltip. A glyph has no accessible name of its own, so without a label the button is announced as "button" and nothing more. `tooltip` is the sighted-user version of the same information, and it is optional.

### AstryxIconButton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `icon` | `AstryxIconName?` | — | The semantic name, resolved through the theme’s registry. Required for the default constructor. |
| `child` | `Widget?` | — | The custom content, for `AstryxIconButton.custom`. |
| `label` **(required)** | `String` | — | The accessible name. Always required. |
| `tooltip` | `String?` | — | Text shown on hover, for sighted users. Not a substitute for `label`. |
| `onPressed` | `VoidCallback?` | — | The action. |
| `variant` | `AstryxButtonVariant?` | — | How prominent it is. |
| `size` | `AstryxButtonSize?` | — | The control height. |
| `enabled` | `bool` | `true` | Whether it accepts interaction. |
| `loading` | `bool` | `false` | Whether an action is in flight. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `href` | `Uri?` | — | A destination for the link delegate. |
| `focusNode` | `FocusNode?` | — | The focus node, if you own one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides for this button. |

---

## AstryxButtonGroup

`lib/src/components/action/button_group.dart` · upstream `ButtonGroup`

Joins related actions into one control, or spaces them as a set.

```dart
class ButtonGroupDemoExample extends StatelessWidget {
  const ButtonGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxButtonGroup(
      children: <Widget>[
        AstryxButton(label: 'Day', onPressed: () {}),
        AstryxButton(label: 'Week', onPressed: () {}),
        AstryxButton(label: 'Month', onPressed: () {}),
      ],
    );
  }
}
```

### AstryxButtonGroup

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The buttons, in order. |
| `variant` | `AstryxButtonVariant?` | — | The variant every child takes unless it sets its own. |
| `size` | `AstryxButtonSize?` | — | The size every child takes unless it sets its own. |
| `axis` | `Axis` | `Axis.horizontal` | Whether the group runs horizontally or vertically. |
| `attached` | `bool` | `true` | Whether the buttons are joined into one visual control. |
| `gap` | `AstryxSpacingToken?` | — | The space between detached buttons. Ignored when `attached`. |

### AstryxButtonGroupScope

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `variant` | `AstryxButtonVariant?` | — | The variant descendants inherit. |
| `size` | `AstryxButtonSize?` | — | The size descendants inherit. |
| `buttonTheme` | `AstryxButtonTheme?` | — | Position-dependent visual overrides — chiefly the corner radii. |

---

## AstryxToggleButton

`lib/src/components/action/toggle_button.dart` · upstream `ToggleButton`

A button that stays pressed — a setting, not an action.

```dart
class ToggleButtonDemoExample extends StatefulWidget {
  const ToggleButtonDemoExample({super.key});

  @override
  State<ToggleButtonDemoExample> createState() =>
      _ToggleButtonDemoExampleState();
}

class _ToggleButtonDemoExampleState extends State<ToggleButtonDemoExample> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // The button owns no state. It reports the state it should move to, and the
    // caller decides — the same contract as every other control here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButton(
          label: 'Only my issues',
          icon: const AstryxIcon(AstryxIconName.funnel),
          pressed: _pressed,
          onChanged: (value) => setState(() => _pressed = value),
        ),
        AstryxText(
          _pressed ? 'Showing 12 of 240 issues.' : 'Showing all 240 issues.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** There is no `variant`. A toggle is always a ghost button, because the pressed fill *is* its visual language — a filled variant would have nothing left to say when it went on.
- **Note:** A pressed toggle does not change under a pointer. Upstream applies the pressed fill unconditionally, which overrides its own hover tint, and that is reproduced here — two overlapping "this one is active" signals read worse than one that holds still. Focus and press feedback are unaffected.
- **Careful:** Windows High Contrast is not covered. Upstream repaints the pressed state with the platform `Highlight` colours under `forced-colors`, and Flutter has no equivalent — `MediaQuery.highContrast` is a preference, not a forced palette. On a forced-colours desktop the pressed fill may be dropped, and the weight shift is what remains.

| Reach for | When |
| --- | --- |
| `AstryxToggleButton` | A toolbar control, a formatting mark, a filter chip that stays down. It lives beside other buttons and looks like one. |
| AstryxSwitch (references/forms.md) | A setting in a form. It is labelled, announced as a switch, and reads as configuration rather than as a control you press. |
| AstryxCheckbox (references/forms.md) | A value being selected, especially in a list or a set of options. |
| AstryxTabList (references/data.md) | Switching what a panel shows. Tabs, not toggles — a tab strip always has exactly one selection. |

### AstryxToggleButton

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the accessible name. |
| `pressed` | `bool` | `false` | Whether the button is on. Ignored inside a group. |
| `onChanged` | `ValueChanged<bool>?` | — | Called with the state to move to. Null makes the button inert; ignored inside a group. |
| `value` | `String?` | — | This button’s identity inside an `AstryxToggleButtonGroup`. Required there, meaningless outside. |
| `icon` | `Widget?` | — | Content before the label. |
| `pressedIcon` | `Widget?` | — | The glyph shown while pressed. Falls back to `icon`. |
| `labelHidden` | `bool` | `false` | Keeps the label as the accessible name without painting it: the button squares off and tooltips itself. |
| `size` | `AstryxButtonSize?` | — | The control height. Null takes the group’s, then the inherited size. |
| `enabled` | `bool` | `true` | Whether the button accepts interaction. **Ignored inside a group**, which decides for its children. |
| `loading` | `bool` | `false` | Whether work is in flight. Suppresses activation and shows a spinner. |
| `tooltip` | `String?` | — | Hover text. Defaults to `label` when `labelHidden`. |
| `focusNode` | `FocusNode?` | — | The focus node, if you own one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides, merged over `AstryxThemeData.button`. |

---

## AstryxToggleButtonGroup

`lib/src/components/action/toggle_button.dart` · upstream `ToggleButtonGroup`

Toggle buttons as one control — single or multiple selection.

```dart
class ToggleButtonGroupSingleExample extends StatefulWidget {
  const ToggleButtonGroupSingleExample({super.key});

  @override
  State<ToggleButtonGroupSingleExample> createState() =>
      _ToggleButtonGroupSingleExampleState();
}

class _ToggleButtonGroupSingleExampleState
    extends State<ToggleButtonGroupSingleExample> {
  String? _view = 'grid';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxToggleButtonGroup.single(
          label: 'View mode',
          value: _view,
          onChanged: (value) => setState(() => _view = value),
          children: const <Widget>[
            AstryxToggleButton(value: 'list', label: 'List'),
            AstryxToggleButton(value: 'grid', label: 'Grid'),
            AstryxToggleButton(value: 'board', label: 'Board'),
          ],
        ),
        // Pressing the one that is already on clears the group, so "none" is
        // always reachable — upstream's behaviour, and the reason the value is
        // nullable.
        AstryxText(
          _view == null ? 'No view chosen.' : 'Showing the $_view view.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** The group’s `label` is required: it is the accessible name of the set, and without it a reader meets three unrelated buttons. Each child keeps its own node and its own selected state.
- **Careful:** Inside a group, a child’s own `enabled` is **ignored** — the group decides. Upstream does the same (`group?.isDisabled ?? isDisabled`), so it is reproduced and pinned by a test rather than quietly improved. Disable the group, not its children. A grouped button without a `value` asserts in debug, because the group would have no way to know which one is on.

### AstryxToggleButtonGroup

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The group’s accessible name — "View mode", "Text formatting". |
| `value` **(required)** | `String?` | — | `.single` only: the value that is on, or null for none. |
| `onChanged` **(required)** | `ValueChanged<String?>` | — | `.single` only: the new value, or null when the group has been cleared. |
| `values` **(required)** | `Set<String>` | — | `.multiple` only: the values that are on. |
| `onChanged` **(required)** | `ValueChanged<Set<String>>` | — | `.multiple` only: a new set, each time. |
| `children` **(required)** | `List<Widget>` | — | The toggle buttons, in order. Each needs a `value`. |
| `axis` | `Axis` | `Axis.horizontal` | Whether the group runs horizontally or vertically. |
| `size` | `AstryxButtonSize?` | — | The size every child takes unless it sets its own. |
| `enabled` | `bool` | `true` | Whether the whole group accepts interaction. The only place to disable a grouped toggle. |
| `gap` | `AstryxSpacingToken?` | `AstryxSpacingToken.spacing1` | The space between the buttons. |

### AstryxToggleButtonGroupScope

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `selectedValues` **(required)** | `Set<String>` | — | The values currently on. |
| `toggle` **(required)** | `void Function(String value)` | — | Reports that a button’s value has been pressed. |
| `size` | `AstryxButtonSize?` | — | The size children inherit. |
| `enabled` | `bool` | `true` | Whether the group accepts interaction. |

---

