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

