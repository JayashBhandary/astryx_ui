---
title: AstryxFileInput
description: 'A file field: the chooser, the chosen list, and the limits.'
component: true
group: Forms
source: lib/src/components/forms/file_input.dart
upstream: FileInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

The field owns what has been chosen, how it reads, and whether it is allowed — the count, the size and the accepted types, with upstream’s own messages. It does not own the dialog.

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


> **Careful**
>
> Flutter has **no file picker** in its core libraries, and this package depends on no plugins — a design system that pulled one in would make every consumer inherit its platform setup. So `onPick` is a seam, the same shape as `AstryxLinkDelegate`: the field asks, the application opens. Wire `file_selector`, `image_picker`, a channel of your own, or a fake in a test.

## Usage

```dart
AstryxFileInput(
  label: 'Incident report',
  files: _files,
  accept: const <String>['.pdf'],
  maxSize: 1024 * 1024,
  onPick: (request) async {
    // Whatever your picker returns, described as AstryxFiles.
    final picked = await openFileSelector(
      accept: request.accept,
      multiple: request.multiple,
    );
    return picked
        .map((f) => AstryxFile(name: f.name, size: f.size, handle: f))
        .toList();
  },
  onChanged: (files) => setState(() => _files = files),
)
```

`AstryxFile` is a description, not a handle: a name, an optional size and MIME type, and a `handle` for your own object. Deliberately not `dart:io`’s `File`, which does not exist on the web — this package builds everywhere Flutter does. The package never looks inside `handle`; it is there so the thing you upload survives the round trip.

## Limits, and what happens at them

| Set | What the field does |
| --- | --- |
| `accept` | Rejects anything that matches none of the patterns — `.pdf` on the extension, `image/*` on the type family, `text/csv` exactly. A file whose picker reported no MIME type is matched on its extension alone. |
| `maxSize` | Rejects a file that is larger. A file of **unknown** size passes: a reticent picker is not a large file. |
| `maxFiles` | Truncates a longer selection to the limit and complains — upstream’s behaviour, not a refusal of the whole batch. |
| `multiple: false` | Keeps the first file of whatever came back. |

Rejected files never reach `onChanged`; the field keeps the ones that passed and shows the first complaint as an error. A `status` of your own **wins**, so a server-side rejection is not overwritten a moment later by a local one.

## Dropzone

The panel presentation, for a form whose subject *is* the upload. It is pressable anywhere and keyboard-reachable like the field version.

```dart
class FileInputDropzoneExample extends StatefulWidget {
  const FileInputDropzoneExample({super.key});

  @override
  State<FileInputDropzoneExample> createState() =>
      _FileInputDropzoneExampleState();
}

class _FileInputDropzoneExampleState extends State<FileInputDropzoneExample> {
  List<AstryxFile> _files = const <AstryxFile>[];

  @override
  Widget build(BuildContext context) {
    // The panel presentation, for a form whose subject is the upload. Press it
    // anywhere; there is no external drag target — see the page.
    return AstryxFileInput(
      label: 'Evidence',
      description: 'Images or PDFs. Two files at most.',
      files: _files,
      mode: AstryxFileInputMode.dropzone,
      accept: const <String>['image/*', '.pdf'],
      multiple: true,
      maxFiles: 2,
      onPick: fakePickedFiles,
      onChanged: (files) => setState(() => _files = files),
    );
  }
}
```


> **Note**
>
> It is a *zone*, not a drop target: dragging a file from the desktop onto it does nothing. External file drag-and-drop needs a channel Flutter does not ship, so it is the same missing capability as the dialog — wrap the field in your own drop handler and call the same code `onPick` would. Upstream’s dropzone accepts drops *and* clicks; this one accepts clicks, taps and the keyboard.

## Accessibility

- The field announces its label and, as its value, what is chosen — "Incident report, incident-report.pdf · 180.0 KB" rather than "Incident report, button".
- The chooser and the remove button keep their own names, so both are reachable rather than folded into one node.
- A rejection arrives as a field error, which is announced, and never as a silently shorter list.

### AstryxFileInput

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `files` *(required)* | `List<AstryxFile>` | — | The files currently chosen. Empty for none. |
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
| `label` *(required)* | `String` | — | The field’s name, shown above the control and used as its accessible name. |
| `description` | `String?` | — | Helper text between the label and the control. |
| `status` | `AstryxFieldStatus?` | — | The validation state, shown below the control. |
| `required` | `bool` | `false` | Whether the field must be filled in. Shows a marker *and* sets the semantics flag. |
| `optional` | `bool` | `false` | Marks the field optional. Mutually exclusive with `required`. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `labelHidden` | `bool` | `false` | Hides the label visually. It still names the control. |


### AstryxFile

A chosen file, as the field understands it.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` *(required)* | `String` | — | The file name, with its extension. |
| `size` | `int?` | — | The size in bytes, if known. Null passes a `maxSize` check. |
| `mimeType` | `String?` | — | The MIME type, if known. |
| `handle` | `Object?` | — | Your own object for this file. Never inspected. |


## Related

- [AstryxField](field.md) — the label, description and status this reuses.
- [AstryxButton](button.md) — the chooser, and the `AstryxLinkDelegate` seam that `onPick` is modelled on.

