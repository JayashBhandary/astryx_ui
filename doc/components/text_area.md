---
title: AstryxTextArea
description: A multi-line text field that grows with its content.
component: true
group: Forms
source: lib/src/components/forms/text_input.dart
upstream: TextArea
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
const AstryxTextArea(
  label: 'Notes',
  optional: true,
  placeholder: 'What happened?',
)
```

The same control as `AstryxTextInput.multiline`, under the name people look for. It carries a narrower surface: no `obscureText`, no `showClear`, no keyboard action — none of which mean anything for a paragraph.

## Lines

```dart
class TextAreaLinesExample extends StatelessWidget {
  const TextAreaLinesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The field grows from `minLines` and stops at `maxLines`, then scrolls.
    return const SizedBox(
      width: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextArea(
            label: 'Two to four lines',
            minLines: 2,
            maxLines: 4,
            placeholder: 'Type until it stops growing…',
          ),
          AstryxTextArea(
            label: 'Fixed at four',
            minLines: 4,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
```


## Counting characters

`maxLength` stops the input; the count and the warning are yours to render, because where they belong depends on the form.

```dart
class TextAreaCountedExample extends StatefulWidget {
  const TextAreaCountedExample({super.key});

  @override
  State<TextAreaCountedExample> createState() => _TextAreaCountedExampleState();
}

class _TextAreaCountedExampleState extends State<TextAreaCountedExample> {
  static const int _limit = 140;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _limit - _controller.text.length;

    return SizedBox(
      width: 380,
      child: AstryxTextArea(
        label: 'Status message',
        controller: _controller,
        maxLength: _limit,
        minLines: 2,
        maxLines: 4,
        description: '$remaining characters left',
        status: remaining <= 20
            ? const AstryxFieldStatus.warning('Nearly at the limit')
            : null,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
```


### AstryxTextArea

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
| `placeholder` | `String?` | — | Text shown when empty. |
| `size` | `AstryxInputSize?` | — | The control height step. |
| `readOnly` | `bool` | `false` | Whether the value can be read but not changed. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `maxLength` | `int?` | — | The maximum number of characters. |
| `width` | `double?` | — | A fixed width. |
| `minLines` | `int` | `3` | The minimum number of visible lines. |
| `maxLines` | `int` | `6` | The maximum number of visible lines before scrolling. |


