# Forms

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxField

`lib/src/components/forms/field.dart` · upstream `Field / FieldLabel / FieldStatus`

Gives any control a label, a description, a required marker and a validation message.

```dart
class FieldDemoExample extends StatefulWidget {
  const FieldDemoExample({super.key});

  @override
  State<FieldDemoExample> createState() => _FieldDemoExampleState();
}

class _FieldDemoExampleState extends State<FieldDemoExample> {
  double _budget = 40;

  @override
  Widget build(BuildContext context) {
    // `AstryxField` gives a label, description, required marker and status
    // message to a control that has none of its own — here a plain Flutter
    // slider. The field publishes all of that to its child through
    // `AstryxFieldScope`, so the control does not have to take the props.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Monthly budget',
        description: 'Alerts fire at 80% of this.',
        required: true,
        status: _budget > 80
            ? const AstryxFieldStatus.warning('Above your usual spend')
            : null,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: _Slider(
                value: _budget,
                onChanged: (value) => setState(() => _budget = value),
              ),
            ),
            AstryxText(
              '\$${_budget.round()}',
              tabularNumbers: true,
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The description *and* the status message both become the control’s hint, joined rather than one winning: both matter to a screen-reader user, and neither is reachable any other way.

| Constructor | Type | Announced |
| --- | --- | --- |
| `AstryxFieldStatus.error(message)` | error | **assertively** — it blocks the user |
| `AstryxFieldStatus.warning(message)` | warning | politely |
| `AstryxFieldStatus.success(message)` | success | politely |

### AstryxField

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The field’s name. |
| `child` **(required)** | `Widget` | — | The control this field describes. |
| `description` | `String?` | — | Helper text. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `required` | `bool` | `false` | Whether the field must be filled in. |
| `optional` | `bool` | `false` | Marks the field optional. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `width` | `double?` | — | A fixed width. Null fills the available space. |

---

## AstryxTextInput

`lib/src/components/forms/text_input.dart` · upstream `TextInput`

A single-line or multi-line text field, with validation.

```dart
class TextInputDemoExample extends StatelessWidget {
  const TextInputDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxTextInput(
        label: 'Workspace name',
        placeholder: 'Acme Internal Tools',
        description: 'Shown to everyone you invite.',
      ),
    );
  }
}
```

**Rules**

- **Note:** Bring a `TextEditingController` for anything but a throwaway field. Without one the widget owns an internal controller and disposes it itself, which is convenient and unreadable from outside.
- **Accessibility:** The selection handles and the context menu are themed from the same tokens as everything else, and the toolbar’s labels are localised through `AstryxLocalizations`.

### AstryxTextInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `controller` | `TextEditingController?` | — | The text being edited. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `onChanged` | `ValueChanged<String>?` | — | Called whenever the text changes. |
| `onSubmitted` | `ValueChanged<String>?` | — | Called when the user submits from the keyboard. |
| `placeholder` | `String?` | — | Text shown when the field is empty. |
| `size` | `AstryxInputSize?` | — | The control height. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. |
| `obscureText` | `bool` | `false` | Whether to hide the value, as for a password. |
| `showClear` | `bool` | `false` | Whether to show a button that clears the value. |
| `leading` | `Widget?` | — | Content before the text. |
| `trailing` | `Widget?` | — | Content after the text, before the clear and status icons. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `keyboardType` | `TextInputType?` | — | The keyboard to request. |
| `textInputAction` | `TextInputAction?` | — | What the keyboard’s action key does. |
| `inputFormatters` | `List<TextInputFormatter>?` | — | Formatters applied as the user types. |
| `autofillHints` | `Iterable<String>?` | — | Autofill hints, so the platform can offer to fill the field. |
| `maxLength` | `int?` | — | The maximum number of characters. |
| `width` | `double?` | — | A fixed width. |
| `minLines` | `int` | `3` | The minimum visible lines. `.multiline` only. |
| `maxLines` | `int` | `6` | The maximum visible lines before scrolling. `.multiline` only. |

---

## AstryxTextArea

`lib/src/components/forms/text_input.dart` · upstream `TextArea`

A multi-line text field that grows with its content.

```dart
class TextAreaDemoExample extends StatelessWidget {
  const TextAreaDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 380,
      child: AstryxTextArea(
        label: 'Notes',
        optional: true,
        placeholder: 'What happened?',
        description: 'Markdown is not interpreted.',
      ),
    );
  }
}
```

### AstryxTextArea

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `controller` | `TextEditingController?` | — | The text being edited. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `onChanged` | `ValueChanged<String>?` | — | Called whenever the text changes. |
| `placeholder` | `String?` | — | Text shown when empty. |
| `size` | `AstryxInputSize?` | — | The control height step. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `maxLength` | `int?` | — | The maximum number of characters. |
| `width` | `double?` | — | A fixed width. |
| `minLines` | `int` | `3` | The minimum number of visible lines. |
| `maxLines` | `int` | `6` | The maximum number of visible lines before scrolling. |

---

## AstryxCheckbox

`lib/src/components/forms/checkbox.dart` · upstream `CheckboxInput`

A two-state or three-state checkbox with a required label.

```dart
class CheckboxDemoExample extends StatefulWidget {
  const CheckboxDemoExample({super.key});

  @override
  State<CheckboxDemoExample> createState() => _CheckboxDemoExampleState();
}

class _CheckboxDemoExampleState extends State<CheckboxDemoExample> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AstryxCheckbox(
      label: 'Accept the terms of service',
      description: 'You can withdraw consent at any time.',
      value: _accepted,
      onChanged: (value) => setState(() => _accepted = value),
    );
  }
}
```

**Rules**

- **Accessibility:** `label` is required — unlike on most controls, and for the same reason upstream requires it: an unlabelled checkbox is unusable with a screen reader. Use `labelHidden` when the label would be redundant to a sighted user; the name survives.

| Value | Box | Pressing it gives |
| --- | --- | --- |
| `unchecked` | empty | `checked` |
| `checked` | filled, tick | `unchecked` |
| `indeterminate` | filled, dash | `checked` |

| Key | Does |
| --- | --- |
| `Tab` | Moves focus to the checkbox. |
| `Space` | Toggles it, as on the native control. |
| `Enter` | Deliberately nothing — in a form, Enter submits, and a checkbox that swallows it breaks that. |

### AstryxCheckbox

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the accessible name. Required. |
| `value` **(required)** | `bool / AstryxCheckboxValue` | — | The current state. A bool on the default constructor, an `AstryxCheckboxValue` on `.tristate`. |
| `onChanged` | `ValueChanged<bool>? / ValueChanged<AstryxCheckboxValue>?` | — | Called with the state a press would produce. Null is non-interactive but not dimmed. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size: `sm` is 20px, `md` 24px. |
| `enabled` | `bool` | `true` | Whether the control accepts interaction. |
| `readOnly` | `bool` | `false` | Shown but not changeable. Does not dim. |
| `loading` | `bool` | `false` | Whether a change is in flight, which shows a spinner in the box. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

---

## AstryxRadioList

`lib/src/components/forms/radio_list.dart` · upstream `RadioList / RadioListItem`

One choice out of several, as an ARIA radio group.

```dart
class RadioListDemoExample extends StatefulWidget {
  const RadioListDemoExample({super.key});

  @override
  State<RadioListDemoExample> createState() => _RadioListDemoExampleState();
}

class _RadioListDemoExampleState extends State<RadioListDemoExample> {
  Plan _plan = Plan.pro;

  @override
  Widget build(BuildContext context) {
    return AstryxRadioList<Plan>(
      label: 'Plan',
      value: _plan,
      onChanged: (value) => setState(() => _plan = value),
      options: const <AstryxRadioOption<Plan>>[
        AstryxRadioOption(
          value: Plan.free,
          label: 'Free',
          description: 'One project, community support.',
        ),
        AstryxRadioOption(
          value: Plan.pro,
          label: 'Pro',
          description: 'Unlimited projects, email support.',
        ),
        AstryxRadioOption(
          value: Plan.enterprise,
          label: 'Enterprise',
          description: 'Contact sales.',
          enabled: false,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** An empty group still has to put focus somewhere when it is tabbed into. It goes to the first enabled option, which is what the ARIA pattern says — not to the first option regardless.

| Key | Does |
| --- | --- |
| `Tab` | Enters the group, or leaves it — one stop, not one per option. |
| `↓` / `→` | Selects the next enabled option, wrapping. |
| `↑` / `←` | Selects the previous one, wrapping. Mirrored under RTL. |
| `Space` | Selects the focused option. |

### AstryxRadioList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `options` **(required)** | `List<AstryxRadioOption<T>>` | — | The options, in the order they are shown and traversed. |
| `value` **(required)** | `T?` | — | The selected value, or null for no selection. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly selected value. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size. |
| `orientation` | `AstryxRadioListOrientation` | `AstryxRadioListOrientation.vertical` | Which way the options run. |
| `focusNode` | `FocusNode?` | — | The focus node for the group. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxRadioOption

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What selecting this option produces. |
| `label` **(required)** | `String` | — | The visible text, and this option’s accessible name. |
| `description` | `String?` | — | Helper text below the label. |
| `enabled` | `bool` | `true` | Whether this option can be chosen. |

---

## AstryxSwitch

`lib/src/components/forms/switch.dart` · upstream `Switch`

A setting that takes effect the moment it is flipped.

```dart
class SwitchDemoExample extends StatefulWidget {
  const SwitchDemoExample({super.key});

  @override
  State<SwitchDemoExample> createState() => _SwitchDemoExampleState();
}

class _SwitchDemoExampleState extends State<SwitchDemoExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return AstryxSwitch(
      label: 'Email notifications',
      description: 'Applies immediately.',
      value: _enabled,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
```

**Rules**

- **Note:** A switch means **applies now**. A checkbox means *will apply when you submit*. Putting a switch in a form with a Save button asks the user to guess which one you meant.

| Key | Does |
| --- | --- |
| `Space` | Toggles it. |
| `→` | Turns it on. Mirrored under RTL. |
| `←` | Turns it off. Mirrored under RTL. |

### AstryxSwitch

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The visible text, and the accessible name. |
| `value` **(required)** | `bool` | — | Whether the switch is on. |
| `onChanged` | `ValueChanged<bool>?` | — | Called with the state a press would produce. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size. |
| `enabled` | `bool` | `true` | Whether the control accepts input. |
| `readOnly` | `bool` | `false` | Shown but not changeable. Does not dim. |
| `loading` | `bool` | `false` | Whether a change is in flight, which shows a spinner in the thumb. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `labelPosition` | `AstryxToggleLabelPosition` | `AstryxToggleLabelPosition.end` | Which side the label sits on. |
| `labelSpacing` | `AstryxToggleLabelSpacing` | `AstryxToggleLabelSpacing.hug` | Whether the row hugs its contents or spreads them. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

---

## AstryxSelector

`lib/src/components/forms/selector.dart` · upstream `Selector / SelectorOption`

A dropdown that picks one value, with optional search.

```dart
class SelectorDemoExample extends StatefulWidget {
  const SelectorDemoExample({super.key});

  @override
  State<SelectorDemoExample> createState() => _SelectorDemoExampleState();
}

class _SelectorDemoExampleState extends State<SelectorDemoExample> {
  String? _owner = 'ada';

  @override
  Widget build(BuildContext context) {
    return AstryxSelector<String>(
      label: 'Owner',
      value: _owner,
      width: 320,
      onChanged: (value) => setState(() => _owner = value),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
      ],
    );
  }
}
```

**Rules**

- **Note:** The list is at most `maxListHeight` tall, and the positioner may shrink it further to fit the viewport. It flips above the trigger when there is no room below.

| Key | Does |
| --- | --- |
| `Enter` / `Space` / `↓` | Opens the list. |
| `↑` / `↓` | Moves the highlight without choosing anything, wrapping. |
| `Home` / `End` | Jumps to the first or last option. |
| a letter | Jumps to the first option starting with what you typed. The buffer resets after a second of silence. |
| `Enter` | Chooses the highlighted option and closes. |
| `Escape` | Closes the list — and only the list. |

### AstryxSelector

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `options` **(required)** | `List<AstryxSelectorEntry<T>>` | — | The entries to show, in order. |
| `value` **(required)** | `T?` | — | The selected value, or null for none. |
| `onChanged` | `ValueChanged<T?>?` | — | Called with the newly chosen value, or null when it is cleared. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |
| `placeholder` | `String?` | — | Text shown when nothing is selected. |
| `size` | `AstryxInputSize?` | — | The trigger height. |
| `showClear` | `bool` | `false` | Whether to offer a button that clears the selection. |
| `showSearch` | `bool` | `false` | Whether the list has a search box at the top. |
| `searchPlaceholder` | `String?` | — | Placeholder for the search box. |
| `emptyLabel` | `String?` | — | Text shown when the search matches nothing. |
| `leading` | `Widget?` | — | Content before the value in the trigger. |
| `maxListHeight` | `double` | `320` | The tallest the list may be before it scrolls. |
| `width` | `double?` | — | A fixed width. |
| `focusNode` | `FocusNode?` | — | The trigger’s focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxSelectorOption

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What choosing this option produces. |
| `label` **(required)** | `String` | — | The visible text, and this option’s accessible name. |
| `description` | `String?` | — | Secondary text below the label. |
| `icon` | `Widget?` | — | An icon before the label. |
| `enabled` | `bool` | `true` | Whether the option can be chosen. |

---

