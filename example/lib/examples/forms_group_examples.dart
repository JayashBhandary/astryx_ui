/// The examples for `AstryxCheckboxList`, `AstryxNumberInput` and
/// `AstryxFileInput`.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A stand-in for the platform dialog the application supplies.
///
/// `AstryxFileInput` never opens a dialog itself — Flutter has none to open —
/// so it asks for one. A real application returns whatever its picker
/// (`file_selector`, `image_picker`, a channel of its own) handed back; this
/// site returns two fixed files so the page can be read without a file system.
Future<List<AstryxFile>> fakePickedFiles(AstryxFilePickRequest request) async {
  const files = <AstryxFile>[
    AstryxFile(
      name: 'incident-report.pdf',
      size: 184320,
      mimeType: 'application/pdf',
    ),
    AstryxFile(name: 'timeline.png', size: 43008, mimeType: 'image/png'),
  ];
  return request.multiple ? files : files.take(1).toList();
}

// #example checkbox_list_demo -> CheckboxListDemoExample
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
// #end

// #example checkbox_list_density -> CheckboxListDensityExample
class CheckboxListDensityExample extends StatefulWidget {
  const CheckboxListDensityExample({super.key});

  @override
  State<CheckboxListDensityExample> createState() =>
      _CheckboxListDensityExampleState();
}

class _CheckboxListDensityExampleState
    extends State<CheckboxListDensityExample> {
  Set<String> _scopes = <String>{'read'};

  @override
  Widget build(BuildContext context) {
    // Compact takes the small control and tightens the rows; dividers turn a
    // set of options into a list of them.
    return AstryxCheckboxList<String>(
      label: 'Token scopes',
      values: _scopes,
      density: AstryxCheckboxListDensity.compact,
      dividers: true,
      onChanged: (values) => setState(() => _scopes = values),
      options: const <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(
          value: 'read',
          label: 'read',
          trailing: AstryxBadge('safe', variant: AstryxBadgeVariant.success),
        ),
        AstryxCheckboxOption(value: 'write', label: 'write'),
        AstryxCheckboxOption(
          value: 'admin',
          label: 'admin',
          trailing: AstryxBadge('broad', variant: AstryxBadgeVariant.warning),
        ),
      ],
    );
  }
}
// #end

// #example checkbox_list_status -> CheckboxListStatusExample
class CheckboxListStatusExample extends StatelessWidget {
  const CheckboxListStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The status belongs to the group: "pick at least one" is not a complaint
    // about any single row, and repeating it on each would be three times the
    // noise for a screen reader.
    return const AstryxCheckboxList<String>(
      label: 'Regions',
      values: <String>{},
      required: true,
      status: AstryxFieldStatus.error('Choose at least one region.'),
      options: <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(value: 'us', label: 'us-east-1'),
        AstryxCheckboxOption(value: 'eu', label: 'eu-west-2'),
      ],
    );
  }
}
// #end

// #example number_input_demo -> NumberInputDemoExample
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
// #end

// #example number_input_range -> NumberInputRangeExample
class NumberInputRangeExample extends StatefulWidget {
  const NumberInputRangeExample({super.key});

  @override
  State<NumberInputRangeExample> createState() =>
      _NumberInputRangeExampleState();
}

class _NumberInputRangeExampleState extends State<NumberInputRangeExample> {
  num? _timeout = 2.5;
  num? _year = 1999;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // A fractional step and a unit. Typing 99 here is refused rather than
        // pulled down to 10 — the value stays what it was, and the rejection is
        // announced.
        AstryxNumberInput(
          label: 'Timeout',
          value: _timeout,
          min: 0.5,
          max: 10,
          step: 0.5,
          units: 'seconds',
          width: 260,
          onChanged: (value) => setState(() => _timeout = value),
        ),
        // No steppers: nobody increments a year one at a time.
        AstryxNumberInput(
          label: 'Year',
          value: _year,
          min: 1900,
          max: 2100,
          integerOnly: true,
          steppers: false,
          showClear: true,
          width: 260,
          onChanged: (value) => setState(() => _year = value),
        ),
      ],
    );
  }
}
// #end

// #example file_input_demo -> FileInputDemoExample
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
// #end

// #example file_input_dropzone -> FileInputDropzoneExample
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

// #end
