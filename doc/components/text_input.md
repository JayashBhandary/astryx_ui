---
title: AstryxTextInput
description: A single-line or multi-line text field, with validation.
component: true
group: Forms
source: lib/src/components/forms/text_input.dart
upstream: TextInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
AstryxTextInput(
  label: 'Workspace name',
  controller: _controller,
  placeholder: 'Acme Internal Tools',
  description: 'Shown to everyone you invite.',
)
```

A `label` wraps the input in an [AstryxField](field.md) for you. Pass null to omit the wrapper entirely — for an input inside something that labels it another way, a table cell or a toolbar.

> **Note**
>
> Bring a `TextEditingController` for anything but a throwaway field. Without one the widget owns an internal controller and disposes it itself, which is convenient and unreadable from outside.

## Sizes

The three control heights. A null `size` inherits from an enclosing `AstryxSizeScope`, the same cascade the buttons use.

```dart
class TextInputSizesExample extends StatelessWidget {
  const TextInputSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final size in AstryxInputSize.values)
            AstryxTextInput(
              label: size.name,
              size: size,
              placeholder: 'Placeholder text',
            ),
        ],
      ),
    );
  }
}
```


## Validation

A status draws an inset ring in its colour, shows its icon in the trailing slot, and prints its message below — announced, not merely coloured.

```dart
class TextInputValidationExample extends StatefulWidget {
  const TextInputValidationExample({super.key});

  @override
  State<TextInputValidationExample> createState() =>
      _TextInputValidationExampleState();
}

class _TextInputValidationExampleState
    extends State<TextInputValidationExample> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  /// Validate on change here so the example reacts as you type. In a real form,
  /// validating on blur or on submit is usually kinder.
  AstryxFieldStatus? get _status {
    final value = _email.text.trim();
    if (value.isEmpty) return null;
    return value.contains('@')
        ? const AstryxFieldStatus.success('That looks right')
        : const AstryxFieldStatus.error('Enter a valid email address');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            status: _status,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const AstryxTextInput(
            label: 'Subdomain',
            optional: true,
            status: AstryxFieldStatus.warning('This name is nearly taken'),
          ),
        ],
      ),
    );
  }
}
```


## Affordances

`leading` and `trailing` take any widget. `showClear` adds a clear button that appears only when there is something to clear, and sits before the status icon.

```dart
class TextInputAffordancesExample extends StatefulWidget {
  const TextInputAffordancesExample({super.key});

  @override
  State<TextInputAffordancesExample> createState() =>
      _TextInputAffordancesExampleState();
}

class _TextInputAffordancesExampleState
    extends State<TextInputAffordancesExample> {
  final TextEditingController _search = TextEditingController(text: 'invoice');

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Search',
            labelHidden: true,
            controller: _search,
            showClear: true,
            placeholder: 'Search invoices',
            leading: const AstryxIcon(
              AstryxIconName.search,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const AstryxTextInput(
            label: 'Password',
            obscureText: true,
            autofillHints: <String>[AutofillHints.password],
          ),
          const AstryxTextInput(
            label: 'Seats',
            trailing: AstryxText(
              'of 24',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
```


## Formatters

The Flutter text-input machinery is exposed rather than wrapped: `inputFormatters`, `keyboardType`, `textInputAction`, `autofillHints` and `maxLength` all behave exactly as they do on `EditableText`.

```dart
class TextInputFormattersExample extends StatelessWidget {
  const TextInputFormattersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxTextInput(
        label: 'Invite code',
        placeholder: 'ABCD-1234',
        maxLength: 9,
        description: 'Letters are upper-cased as you type.',
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
          TextInputFormatter.withFunction(
            (oldValue, newValue) =>
                newValue.copyWith(text: newValue.text.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
```


## States

Read-only is not disabled. A read-only value still means something and is still selectable and copyable — it is simply not yours to change here — so it is not dimmed.

```dart
class TextInputStatesExample extends StatelessWidget {
  const TextInputStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Read-only',
            readOnly: true,
            placeholder: 'acct_0192',
            description: 'The value is meaningful, just not yours to change.',
          ),
          AstryxTextInput(
            label: 'Disabled',
            enabled: false,
            placeholder: 'Managed by your admin',
          ),
        ],
      ),
    );
  }
}
```


## Multi-line

`AstryxTextInput.multiline` grows from `minLines` to `maxLines`, then scrolls. [AstryxTextArea](text_area.md) is the friendlier name for the same control.

```dart
class TextInputMultilineExample extends StatelessWidget {
  const TextInputMultilineExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `AstryxTextInput.multiline` is the same control, grown vertically.
    // `AstryxTextArea` is the friendlier name for the same thing.
    return const SizedBox(
      width: 380,
      child: AstryxTextInput.multiline(
        label: 'What happened?',
        placeholder: 'Steps to reproduce…',
        minLines: 2,
        maxLines: 5,
      ),
    );
  }
}
```


> **Accessibility**
>
> The selection handles and the context menu are themed from the same tokens as everything else, and the toolbar’s labels are localised through `AstryxLocalizations`.

### AstryxTextInput

| Property | Type | Default | Description |
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


