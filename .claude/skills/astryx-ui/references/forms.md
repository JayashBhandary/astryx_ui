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

## AstryxCheckboxList

`lib/src/components/forms/checkbox_list.dart` · upstream `CheckboxList / CheckboxListItem`

A group of checkboxes sharing one label and one validation state.

```dart
class CheckboxListDemoExample extends StatefulWidget {
  const CheckboxListDemoExample({super.key});

  @override
  State<CheckboxListDemoExample> createState() =>
      _CheckboxListDemoExampleState();
}

class _CheckboxListDemoExampleState extends State<CheckboxListDemoExample> {
  Set<String> _channels = <String>{'email'};

  @override
  Widget build(BuildContext context) {
    // One label, one description and one status for the whole set — which is
    // the reason to reach for this rather than a column of checkboxes.
    return AstryxCheckboxList<String>(
      label: 'Notify me about',
      description: 'Applies to every project you watch.',
      values: _channels,
      onChanged: (values) => setState(() => _channels = values),
      options: const <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(
          value: 'email',
          label: 'Email',
          description: 'Digested once an hour.',
        ),
        AstryxCheckboxOption(value: 'sms', label: 'SMS'),
        AstryxCheckboxOption(
          value: 'push',
          label: 'Push',
          description: 'Needs the mobile app.',
          enabled: false,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Each row is its own tab stop, and Space toggles the row that has focus. That is the ARIA checkbox pattern, and the **opposite** of AstryxRadioList (references/forms.md), where the whole group is one stop and the arrows move within it. A checkbox group keyboarded as a radio group swallows Tab and traps anyone using one; a test pins the difference.

| Set | Gets you |
| --- | --- |
| `enabled: false` | The whole group refuses and dims. For one row, use the option’s own `enabled`. |
| `readOnly: true` | The values are shown at full strength and cannot be changed. Not dimmed — the values are the point. |
| an option’s `loading` | A spinner in place of that row’s control while something settles. Upstream drives this from a pending `changeAction`; here the caller owns it, as everywhere else in this package. |
| an option’s `trailing` | Content after the label — a badge, a count. Upstream’s `endContent`. Not part of the row’s accessible name, so put anything it *says* in the description too. |

### AstryxCheckboxList

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `options` **(required)** | `List<AstryxCheckboxOption<T>>` | — | The rows, in order. |
| `values` **(required)** | `Set<T>` | — | The values currently checked. |
| `onChanged` | `ValueChanged<Set<T>>?` | — | Called with a new set. Null makes the group inert. |
| `density` | `AstryxCheckboxListDensity` | `balanced` | How much room each row gets. |
| `dividers` | `bool` | `false` | Whether to draw a rule between rows. |
| `readOnly` | `bool` | `false` | Whether the selection can be read but not changed. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

### AstryxCheckboxOption

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | What checking the row selects. |
| `label` **(required)** | `String` | — | The visible text, and the row’s accessible name. |
| `description` | `String?` | — | Helper text below the label. |
| `trailing` | `Widget?` | — | Content after the label. |
| `enabled` | `bool` | `true` | Whether the row can be checked. |
| `loading` | `bool` | `false` | Whether the row is waiting on something. |

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

## AstryxNumberInput

`lib/src/components/forms/number_input.dart` · upstream `NumberInput`

A numeric field with steppers, a range and unit text.

```dart
class NumberInputDemoExample extends StatefulWidget {
  const NumberInputDemoExample({super.key});

  @override
  State<NumberInputDemoExample> createState() => _NumberInputDemoExampleState();
}

class _NumberInputDemoExampleState extends State<NumberInputDemoExample> {
  num? _replicas = 3;

  @override
  Widget build(BuildContext context) {
    // The steppers are drawn rather than inherited from a platform widget: a
    // browser's number input has them, and a thumb has no arrow keys.
    return AstryxNumberInput(
      label: 'Replicas',
      description: 'Between 1 and 20.',
      value: _replicas,
      min: 1,
      max: 20,
      integerOnly: true,
      width: 240,
      onChanged: (value) => setState(() => _replicas = value),
    );
  }
}
```

**Rules**

- **Careful:** Out-of-range typing is **rejected, not clamped**. Type 200 into a field whose `max` is 20 and the value does not move: the text reverts on blur and the refusal is announced. That is upstream’s `parseNumberInput`, which returns null rather than the nearest legal number — quietly changing what somebody typed is worse than declining it. Pressing a stepper *does* stop at the boundary, as a browser’s spinner does.
- **Accessibility:** A rejected entry is announced through a live region — see AstryxVisuallyHidden (references/layout.md). Reverting in silence leaves a screen-reader user with no idea their entry was thrown away, which is WCAG 3.3.1, and it is the one thing a hand-built number field almost always misses. The steppers carry names of their own — "Increase Replicas" — and disable themselves at the ends of the range.

### AstryxNumberInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `num?` | — | The committed value, or null for an empty field. |
| `onChanged` | `ValueChanged<num?>?` | — | Called with a newly committed value, or null when cleared. |
| `min` | `num?` | — | The smallest accepted value. |
| `max` | `num?` | — | The largest accepted value. |
| `step` | `num` | `1` | How much a stepper or an arrow key moves the value. |
| `integerOnly` | `bool` | `false` | Whether to refuse anything that is not a whole number. |
| `units` | `String?` | — | A suffix inside the field. |
| `steppers` | `bool` | `true` | Whether to draw the increment and decrement buttons. |
| `showClear` | `bool` | `false` | Whether to show a button that empties the field, committing null. |
| `placeholder` | `String?` | — | Shown while the field is empty. |
| `leading` | `Widget?` | — | Content before the number. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. |
| `size` | `AstryxInputSize?` | — | The control height. |
| `width` | `double?` | — | A fixed width for the whole field. |
| `label` | `String?` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

---

## AstryxFileInput

`lib/src/components/forms/file_input.dart` · upstream `FileInput`

A file field: the chooser, the chosen list, and the limits.

```dart
class FileInputDemoExample extends StatefulWidget {
  const FileInputDemoExample({super.key});

  @override
  State<FileInputDemoExample> createState() => _FileInputDemoExampleState();
}

class _FileInputDemoExampleState extends State<FileInputDemoExample> {
  List<AstryxFile> _files = const <AstryxFile>[];

  @override
  Widget build(BuildContext context) {
    return AstryxFileInput(
      label: 'Incident report',
      description: 'PDF, up to 1 MB.',
      files: _files,
      accept: const <String>['.pdf'],
      maxSize: 1024 * 1024,
      // The seam: the field validates and displays, the application opens the
      // dialog. `fakePickedFiles` stands in for a real picker here.
      onPick: fakePickedFiles,
      onChanged: (files) => setState(() => _files = files),
    );
  }
}
```

**Rules**

- **Careful:** Flutter has **no file picker** in its core libraries, and this package depends on no plugins — a design system that pulled one in would make every consumer inherit its platform setup. So `onPick` is a seam, the same shape as `AstryxLinkDelegate`: the field asks, the application opens. Wire `file_selector`, `image_picker`, a channel of your own, or a fake in a test.
- **Note:** It is a *zone*, not a drop target: dragging a file from the desktop onto it does nothing. External file drag-and-drop needs a channel Flutter does not ship, so it is the same missing capability as the dialog — wrap the field in your own drop handler and call the same code `onPick` would. Upstream’s dropzone accepts drops *and* clicks; this one accepts clicks, taps and the keyboard.

| Set | What the field does |
| --- | --- |
| `accept` | Rejects anything that matches none of the patterns — `.pdf` on the extension, `image/*` on the type family, `text/csv` exactly. A file whose picker reported no MIME type is matched on its extension alone. |
| `maxSize` | Rejects a file that is larger. A file of **unknown** size passes: a reticent picker is not a large file. |
| `maxFiles` | Truncates a longer selection to the limit and complains — upstream’s behaviour, not a refusal of the whole batch. |
| `multiple: false` | Keeps the first file of whatever came back. |

### AstryxFileInput

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `files` **(required)** | `List<AstryxFile>` | — | The files currently chosen. Empty for none. |
| `onChanged` | `ValueChanged<List<AstryxFile>>?` | — | Called with the files that passed validation. |
| `onPick` | `AstryxFilePicker?` | — | Opens the dialog. Null leaves the field inert. |
| `accept` | `List<String>` | `const <String>[]` | Accepted types, in the HTML `accept` vocabulary. |
| `multiple` | `bool` | `false` | Whether more than one file may be chosen. |
| `maxFiles` | `int?` | — | The most files that may be chosen. |
| `maxSize` | `int?` | — | The largest accepted size, in bytes. |
| `mode` | `AstryxFileInputMode` | `AstryxFileInputMode.input` | Whether to present as a field or as a panel. |
| `placeholder` | `String?` | — | The text shown when nothing is chosen. |
| `loading` | `bool` | `false` | Whether an upload is in flight. Shows a spinner and refuses the dialog. |
| `width` | `double?` | — | A fixed width for the whole field. |
| `label` **(required)** | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

### AstryxFile

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `name` **(required)** | `String` | — | The file name, with its extension. |
| `size` | `int?` | — | The size in bytes, if known. Null passes a `maxSize` check. |
| `mimeType` | `String?` | — | The MIME type, if known. |
| `handle` | `Object?` | — | Your own object for this file. Never inspected. |

---

## AstryxSlider

`lib/src/components/forms/slider.dart` · upstream `Slider`

A value, or a range, chosen by dragging along a track.

```dart
class SliderDemoExample extends StatefulWidget {
  const SliderDemoExample({super.key});

  @override
  State<SliderDemoExample> createState() => _SliderDemoExampleState();
}

class _SliderDemoExampleState extends State<SliderDemoExample> {
  num _threshold = 40;

  @override
  Widget build(BuildContext context) {
    return AstryxSlider(
      label: 'Alert threshold',
      description: 'Warn when usage passes this share of the quota.',
      value: _threshold,
      step: 5,
      marks: const <AstryxSliderMark>[
        AstryxSliderMark(0),
        AstryxSliderMark(50),
        AstryxSliderMark(100),
      ],
      formatValue: (value) => '$value%',
      valueDisplay: AstryxSliderValueDisplay.text,
      onChanged: (value) => setState(() => _threshold = value),
    );
  }
}
```

**Rules**

- **Accessibility:** Each thumb is a `slider` to assistive technology, carrying the **formatted** value and increase and decrease actions — so a switch or voice user can move it without a keyboard. The thumb also carries a full tap target, which is why it answers a thumb as well as a mouse.
- **Careful:** Upstream inherits its thumb from a native `input[type=range]`, and the browser supplies a value tooltip on hover. `valueDisplay: tooltip` therefore shows nothing here yet — use `text`, which is visible to everyone rather than only to a pointer, and is what this page uses.

| Set | Gets you |
| --- | --- |
| `marks` | Ticks at the values you name. Decoration only: not snap targets, and not announced. |
| `formatValue` | How a value is written **and** announced — "40%", "150ms". Without it a value is written plainly and an integral one drops its `.0`. |
| `valueDisplay` | `text` puts the value above the track, `none` shows nothing. |
| `orientation` | Vertical runs bottom to top and needs a `length`, having nothing to stretch to. |

| Key | Does |
| --- | --- |
| `Tab` | Moves to the thumb — each thumb of a range in turn. |
| `←` `→` | One step, mirrored under RTL. |
| `↑` `↓` | One step. Never mirrored. |
| `Page Up` `Page Down` | Ten steps. |
| `Home` `End` | The bottom or the top of the scale. |

### AstryxSlider

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `num` | — | The value. Single-thumb constructor. |
| `values` **(required)** | `(num, num)` | — | The two values, low then high. `AstryxSlider.range` only. |
| `onChanged` | `ValueChanged?` | — | Fires throughout a drag. |
| `onChangeEnd` | `ValueChanged?` | — | Fires once a drag settles, and on every keyboard move. |
| `min` | `num` | `0` | The bottom of the scale. |
| `max` | `num` | `100` | The top of the scale. |
| `step` | `num` | `1` | The granularity. |
| `minStepsBetweenThumbs` | `int` | `0` | The fewest steps between the two thumbs of a range. |
| `orientation` | `AstryxSliderOrientation` | `horizontal` | Which way the track runs. |
| `valueDisplay` | `AstryxSliderValueDisplay` | `tooltip` | How the value is shown. |
| `marks` | `List<AstryxSliderMark>` | `const []` | Ticks along the track. |
| `formatValue` | `String Function(num)?` | — | Formats a value for display and for assistive technology. |
| `length` | `double` | `200` | The track extent. Horizontal sliders stretch and ignore it. |
| `label` **(required)** | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

---

## AstryxMultiSelector

`lib/src/components/forms/multi_selector.dart` · upstream `MultiSelector`

A selector that keeps several choices, shown as tokens.

```dart
class MultiSelectorDemoExample extends StatefulWidget {
  const MultiSelectorDemoExample({super.key});

  @override
  State<MultiSelectorDemoExample> createState() =>
      _MultiSelectorDemoExampleState();
}

class _MultiSelectorDemoExampleState extends State<MultiSelectorDemoExample> {
  Set<String> _reviewers = <String>{'ada'};

  @override
  Widget build(BuildContext context) {
    // The list stays open as options are ticked — the difference from a single
    // selector — and the trigger shows a token per choice.
    return AstryxMultiSelector<String>(
      label: 'Reviewers',
      description: 'They are notified when the branch is pushed.',
      values: _reviewers,
      showSearch: true,
      showSelectAll: true,
      maxBadges: 2,
      onChanged: (values) => setState(() => _reviewers = values),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorSection<String>('Maintainers'),
        AstryxSelectorOption<String>(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption<String>(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection<String>('Reviewers'),
        AstryxSelectorOption<String>(
          value: 'grace',
          label: 'Grace Hopper',
          description: 'Away until Friday',
        ),
        AstryxSelectorOption<String>(
          value: 'katherine',
          label: 'Katherine Johnson',
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** The field announces **which** options are chosen, not how many: "Ada Lovelace, Grace Hopper" rather than "2 selected". A count is a summary for the eye; a reader needs the list. The clear button keeps a name of its own so that it can be reached at all.

| Set | Trigger shows |
| --- | --- |
| `badges` (default) | A token per choice up to `maxBadges`, then "+n more". One line: a trigger that grew would move every field below it. |
| `count` | "3 selected". For a field that is usually full, where the tokens would never have fitted. |

### AstryxMultiSelector

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `options` **(required)** | `List<AstryxSelectorEntry<T>>` | — | The options, sections and dividers, in order. |
| `values` **(required)** | `Set<T>` | — | The values currently chosen. |
| `onChanged` | `ValueChanged<Set<T>>?` | — | Called with a new set. Null makes the selector inert. |
| `triggerDisplay` | `AstryxMultiSelectorTriggerDisplay` | `badges` | Tokens or a count. |
| `maxBadges` | `int` | `3` | How many tokens before the rest collapse into "+n". |
| `showSelectAll` | `bool` | `false` | Whether to offer a tick-everything row. |
| `showSearch` | `bool` | `false` | Whether to offer a search field above the list. |
| `emptyLabel` | `String?` | — | What to show when a search matches nothing. |
| `loading` | `bool` | `false` | Whether the options are being fetched. |
| `maxListHeight` | `double` | `320` | The tallest the list may be before it scrolls. |
| `label` **(required)** | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

---

## AstryxComplexSelector

`lib/src/components/forms/complex_selector.dart` · upstream `ComplexSelector`

A selector with a trigger this package draws and a surface you draw.

```dart
class ComplexSelectorDemoExample extends StatefulWidget {
  const ComplexSelectorDemoExample({super.key});

  @override
  State<ComplexSelectorDemoExample> createState() =>
      _ComplexSelectorDemoExampleState();
}

class _ComplexSelectorDemoExampleState
    extends State<ComplexSelectorDemoExample> {
  AstryxPalette? _palette;

  @override
  Widget build(BuildContext context) {
    // A surface a list of options cannot express: a grid of swatches. The
    // package supplies the field, the trigger and the overlay; the contents are
    // entirely the caller's.
    return AstryxComplexSelector<AstryxPalette?>(
      label: 'Label colour',
      value: _palette,
      placeholder: 'No colour',
      triggerLabel: _palette == null
          ? null
          : AstryxBadge(
              _palette!.name,
              variant: AstryxBadgeVariant.palette(_palette!),
            ),
      onChanged: (value) => setState(() => _palette = value),
      surfaceBuilder: (context, state) => Padding(
        padding: const EdgeInsets.all(8),
        child: AstryxGrid(
          minWidth: 96,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final palette in AstryxPalette.values)
              AstryxButton(
                label: palette.name,
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: AstryxBadge(
                  '  ',
                  variant: AstryxBadgeVariant.palette(palette),
                ),
                onPressed: () {
                  state.onChanged(palette);
                  state.close();
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The trigger announces itself as a button, expanded or collapsed, and the overlay traps focus and returns it on Escape. What you build inside is yours to name — nothing else about your surface can be checked from here, which is the price of the freedom.

### AstryxComplexSelector

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `value` **(required)** | `T` | — | The value, handed to the builder unchanged. |
| `surfaceBuilder` **(required)** | `Widget Function(BuildContext, AstryxComplexSelectorState<T>)` | — | Builds the surface inside the overlay. |
| `onChanged` | `ValueChanged<T>?` | — | Called with a new value. Null makes the selector inert. |
| `triggerLabel` | `Widget?` | — | What the trigger shows. Null shows the placeholder. |
| `side` | `AstryxOverlaySide` | `bottom` | Which side of the trigger the surface opens on. |
| `matchTriggerWidth` | `bool` | `true` | Whether the surface takes the trigger width. |
| `surfaceWidth` | `double?` | — | A fixed surface width. Ignored when `matchTriggerWidth`. |
| `loading` | `bool` | `false` | Whether the value is being fetched. |
| `label` **(required)** | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

---

## AstryxInputGroup

`lib/src/components/forms/input_group.dart` · upstream `InputGroup / InputGroupText`

Adjacent inputs and affixes joined into one bordered control.

```dart
class InputGroupDemoExample extends StatelessWidget {
  const InputGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three children, one border. The affixes size to their text; the field in
    // the middle takes what is left.
    return AstryxInputGroup(
      label: 'Project URL',
      description: 'Lower case, no spaces.',
      children: <Widget>[
        const AstryxInputGroupText('https://'),
        Expanded(
          child: AstryxTextInput(
            label: 'Project URL',
            labelHidden: true,
            placeholder: 'my-project',
            onChanged: (_) {},
          ),
        ),
        const AstryxInputGroupText('.example.com'),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** An affix is decoration: no focus, no value, not announced. Anything it *says* — a currency, a unit — belongs in the group’s label or description as well, or a screen-reader user gets the number without knowing what it counts.

### AstryxInputGroup

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The inputs and affixes, in reading order. |
| `size` | `AstryxInputSize?` | — | The size every input inside takes unless it sets its own. |
| `label` **(required)** | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |

---

## AstryxFormLayout

`lib/src/components/forms/form_layout.dart` · upstream `FormLayout`

The column and label geometry a form’s fields share.

```dart
class FormLayoutDirectionsExample extends StatelessWidget {
  const FormLayoutDirectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three arrangements of the same two fields. Nesting works: the horizontal
    // pair below is a row of fields inside a column of them.
    return AstryxFormLayout(
      children: <Widget>[
        AstryxTextInput(label: 'Project name', onChanged: (_) {}),
        AstryxFormLayout(
          direction: AstryxFormLayoutDirection.horizontal,
          children: <Widget>[
            AstryxTextInput(label: 'Region', onChanged: (_) {}),
            AstryxTextInput(label: 'Owner', onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** Switch the preview above to a phone. Below 480 logical pixels — upstream’s own threshold — the labels go back above their controls, because a label column and a usable control do not both fit. It is a change of arrangement rather than a squeeze, so the fields under it stop reserving a column at all.

| Direction | Arranges |
| --- | --- |
| `vertical` | Stacked. The default, and what most forms want. |
| `horizontal` | Equal columns, one per child — `grid-auto-columns: 1fr` upstream. |
| `horizontalLabels` | Stacked, with each label beside its own control. Collapses to a stack below 480 logical pixels. |

### AstryxFormLayout

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The fields, in order. |
| `direction` | `AstryxFormLayoutDirection` | `vertical` | How to arrange them. |
| `gap` | `AstryxSpacingToken?` | `spacing4` | The space between fields. |
| `labelWidth` | `double?` | `160` | The label column, under `horizontalLabels`. |

---

