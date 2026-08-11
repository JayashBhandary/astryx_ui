import 'dart:ui' show CheckedState, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxCheckboxList`, `AstryxNumberInput` and `AstryxFileInput`.
///
/// The contracts pinned here are upstream's, checked against
/// `packages/core/src/{CheckboxList,NumberInput,FileInput}`: a checkbox group
/// that is *not* keyboarded like a radio group, a number field that rejects
/// out-of-range input rather than clamping it, and a file field whose
/// validation matches `validateFiles` message for message.
void main() {
  group('AstryxCheckboxList', () {
    Widget list({
      required Set<String> values,
      required ValueChanged<Set<String>>? onChanged,
      bool enabled = true,
      bool readOnly = false,
      bool dividers = false,
    }) => AstryxCheckboxList<String>(
      label: 'Notifications',
      values: values,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      dividers: dividers,
      options: const <AstryxCheckboxOption<String>>[
        AstryxCheckboxOption(value: 'email', label: 'Email'),
        AstryxCheckboxOption(value: 'sms', label: 'SMS'),
        AstryxCheckboxOption(
          value: 'push',
          label: 'Push',
          enabled: false,
        ),
      ],
    );

    testWidgets('renders the label and every row', (tester) async {
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{}, onChanged: (_) {}),
      );

      expect(find.text('Notifications'), findsOneWidget);
      for (final label in <String>['Email', 'SMS', 'Push']) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('adds a value without disturbing the others', (tester) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{'email'}, onChanged: reported.add),
      );

      await tester.tap(find.text('SMS'));
      await tester.pump();
      expect(reported, <Set<String>>[
        <String>{'email', 'sms'},
      ]);
    });

    testWidgets('removes a value that is already checked', (tester) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{'email', 'sms'}, onChanged: reported.add),
      );

      await tester.tap(find.text('Email'));
      await tester.pump();
      expect(reported, <Set<String>>[
        <String>{'sms'},
      ]);
    });

    testWidgets('never edits the set it was given', (tester) async {
      final original = <String>{'email'};
      Set<String>? next;
      await pumpAstryxWidget(
        tester,
        list(values: original, onChanged: (value) => next = value),
      );

      await tester.tap(find.text('SMS'));
      await tester.pump();
      expect(original, <String>{'email'}, reason: 'the caller owns its set');
      expect(next, <String>{'email', 'sms'});
    });

    testWidgets('a disabled row refuses, an enabled one still works', (
      tester,
    ) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{}, onChanged: reported.add),
      );

      await tester.tap(find.text('Push'), warnIfMissed: false);
      await tester.pump();
      expect(reported, isEmpty);

      await tester.tap(find.text('Email'));
      await tester.pump();
      expect(reported, hasLength(1));
    });

    testWidgets('read-only shows the values and refuses the toggle', (
      tester,
    ) async {
      final reported = <Set<String>>[];
      await pumpAstryxWidget(
        tester,
        list(
          values: const <String>{'email'},
          onChanged: reported.add,
          readOnly: true,
        ),
      );

      await tester.tap(find.text('Email'), warnIfMissed: false);
      await tester.pump();
      expect(reported, isEmpty);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('every row is a tab stop, unlike a radio group', (
      tester,
    ) async {
      // The distinction from `AstryxRadioList`, and the reason this is not
      // built on it: a checkbox group is *n* stops with Space toggling each,
      // and a radio group is one stop with the arrows moving inside it. A
      // checkbox list keyboarded as a radio group swallows Tab.
      int traversableStops() =>
          FocusManager.instance.rootScope.traversalDescendants.length;

      await pumpAstryxWidget(
        tester,
        list(values: const <String>{}, onChanged: (_) {}),
      );
      // Two of the three rows are enabled.
      final checkboxStops = traversableStops();

      await pumpAstryxWidget(
        tester,
        AstryxRadioList<String>(
          label: 'Notifications',
          value: null,
          onChanged: (_) {},
          options: const <AstryxRadioOption<String>>[
            AstryxRadioOption(value: 'email', label: 'Email'),
            AstryxRadioOption(value: 'sms', label: 'SMS'),
          ],
        ),
      );
      final radioStops = traversableStops();

      // Absolute counts include whatever the harness itself contributes, so
      // the comparison is what carries the meaning: two enabled rows are two
      // stops, and a two-option radio group is one however many options it has.
      expect(
        checkboxStops - radioStops,
        1,
        reason: "two checkbox stops against the radio group's one",
      );
    });

    testWidgets('checked rows report a checked state', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{'email'}, onChanged: (_) {}),
      );

      expect(
        tester.getSemantics(find.text('Email')).flagsCollection.isChecked,
        CheckedState.isTrue,
      );
      handle.dispose();
    });

    testWidgets('dividers appear between rows only', (tester) async {
      await pumpAstryxWidget(
        tester,
        list(values: const <String>{}, onChanged: (_) {}, dividers: true),
      );

      // Three rows, two rules.
      expect(find.byType(AstryxDivider), findsNWidgets(2));
    });

    testWidgets('an empty group renders nothing but its label', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxCheckboxList<String>(
          label: 'Notifications',
          values: const <String>{},
          onChanged: (_) {},
          options: const <AstryxCheckboxOption<String>>[],
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AstryxNumberInput', () {
    testWidgets('shows the value and steps it with the buttons', (
      tester,
    ) async {
      final reported = <num?>[];
      num? value = 3;
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxNumberInput(
            label: 'Replicas',
            value: value,
            onChanged: (next) {
              reported.add(next);
              setState(() => value = next);
            },
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Increase Replicas'));
      await tester.pump();
      expect(reported, <num?>[4]);

      await tester.tap(find.bySemanticsLabel('Decrease Replicas'));
      await tester.pump();
      expect(reported, <num?>[4, 3]);
    });

    testWidgets('the arrow keys step it', (tester) async {
      final reported = <num?>[];
      num? value = 3;
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxNumberInput(
            label: 'Replicas',
            value: value,
            step: 5,
            autofocus: true,
            onChanged: (next) {
              reported.add(next);
              setState(() => value = next);
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(reported, <num?>[8]);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(reported, <num?>[8, 3]);
    });

    testWidgets('a step stops at the boundary rather than doing nothing', (
      tester,
    ) async {
      final reported = <num?>[];
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 19,
          step: 5,
          max: 20,
          onChanged: reported.add,
        ),
      );

      await tester.tap(find.bySemanticsLabel('Increase Replicas'));
      await tester.pump();
      expect(reported, <num?>[20], reason: 'clamped, as a spinner is');
    });

    testWidgets('the steppers stop at the ends', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 20,
          max: 20,
          min: 1,
          onChanged: (_) {},
        ),
      );

      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Increase Replicas'))
            .flagsCollection
            .isEnabled,
        Tristate.isFalse,
      );
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Decrease Replicas'))
            .flagsCollection
            .isEnabled,
        Tristate.isTrue,
      );
      handle.dispose();
    });

    testWidgets('typing commits on blur', (tester) async {
      final reported = <num?>[];
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 3,
          onChanged: reported.add,
        ),
      );

      await tester.enterText(find.byType(EditableText), '7');
      await tester.pump();
      // Not yet: half a number is not a number.
      expect(reported, isEmpty);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(reported, <num?>[7]);
    });

    testWidgets('out-of-range input is rejected, not clamped', (tester) async {
      final reported = <num?>[];
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 3,
          min: 1,
          max: 20,
          onChanged: reported.add,
        ),
      );

      await tester.enterText(find.byType(EditableText), '200');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      // Upstream's `parseNumberInput` returns null for out of range, so the
      // value is left alone and the text reverts.
      expect(reported, isEmpty);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('a rejection is announced, not swallowed', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 3,
          max: 20,
          onChanged: (_) {},
        ),
      );

      await tester.enterText(find.byType(EditableText), '200');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      // WCAG 3.3.1: reverting in silence tells a screen-reader user nothing.
      expect(find.byType(AstryxVisuallyHidden), findsOneWidget);
      expect(find.text('200 is not accepted here'), findsOneWidget);
    });

    testWidgets('integerOnly refuses a fraction', (tester) async {
      final reported = <num?>[];
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 3,
          integerOnly: true,
          onChanged: reported.add,
        ),
      );

      await tester.enterText(find.byType(EditableText), '2');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(reported, <num?>[2]);
    });

    testWidgets('an emptied field commits null only when clearable', (
      tester,
    ) async {
      final reported = <num?>[];
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Replicas',
          value: 3,
          showClear: true,
          onChanged: reported.add,
        ),
      );

      await tester.enterText(find.byType(EditableText), '');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(reported, <num?>[null]);
    });

    testWidgets('units are shown beside the number', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxNumberInput(label: 'Timeout', value: 30, units: 'ms'),
      );

      expect(find.text('ms'), findsOneWidget);
    });

    testWidgets('steppers can be turned off', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxNumberInput(
          label: 'Year',
          value: 1999,
          steppers: false,
          onChanged: (_) {},
        ),
      );

      expect(find.bySemanticsLabel('Increase Year'), findsNothing);
    });

    testWidgets('a null onChanged makes it inert', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxNumberInput(label: 'Replicas', value: 3),
      );

      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Increase Replicas'))
            .flagsCollection
            .isEnabled,
        Tristate.isFalse,
      );
      handle.dispose();
    });
  });

  group('AstryxFileInput', () {
    const one = AstryxFile(
      name: 'report.pdf',
      size: 2048,
      mimeType: 'application/pdf',
    );
    const big = AstryxFile(name: 'huge.pdf', size: 10 * 1024 * 1024);
    const image = AstryxFile(
      name: 'shot.png',
      size: 512,
      mimeType: 'image/png',
    );

    Widget input({
      required List<AstryxFile> files,
      required ValueChanged<List<AstryxFile>>? onChanged,
      AstryxFilePicker? onPick,
      List<String> accept = const <String>[],
      bool multiple = false,
      int? maxFiles,
      int? maxSize,
      AstryxFileInputMode mode = AstryxFileInputMode.input,
      bool enabled = true,
      bool loading = false,
    }) => AstryxFileInput(
      label: 'Attachments',
      files: files,
      onChanged: onChanged,
      onPick: onPick,
      accept: accept,
      multiple: multiple,
      maxFiles: maxFiles,
      maxSize: maxSize,
      mode: mode,
      enabled: enabled,
      loading: loading,
    );

    testWidgets('prompts when empty and names what was chosen', (tester) async {
      await pumpAstryxWidget(
        tester,
        input(files: const <AstryxFile>[], onChanged: (_) {}),
      );
      expect(find.text('Choose file'), findsWidgets);

      await pumpAstryxWidget(
        tester,
        input(files: const <AstryxFile>[one], onChanged: (_) {}),
      );
      expect(find.textContaining('report.pdf'), findsOneWidget);
      // Upstream's `formatFileSize`.
      expect(find.textContaining('2.0 KB'), findsOneWidget);
    });

    testWidgets('picking hands back what the picker returned', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          onPick: (_) async => <AstryxFile>[one],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(reported, hasLength(1));
      expect(reported.single.single.name, 'report.pdf');
    });

    testWidgets('the request carries accept and multiple', (tester) async {
      AstryxFilePickRequest? seen;
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: (_) {},
          multiple: true,
          accept: const <String>['.pdf'],
          onPick: (request) async {
            seen = request;
            return <AstryxFile>[];
          },
        ),
      );

      await tester.tap(find.text('Choose files').last);
      await tester.pumpAndSettle();
      expect(seen?.multiple, isTrue);
      expect(seen?.accept, <String>['.pdf']);
    });

    testWidgets('a cancelled dialog changes nothing', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[one],
          onChanged: reported.add,
          onPick: (_) async => <AstryxFile>[],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(reported, isEmpty);
    });

    testWidgets('the wrong type is rejected with upstream’s message', (
      tester,
    ) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          accept: const <String>['.pdf'],
          onPick: (_) async => <AstryxFile>[image],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(reported.single, isEmpty);
      expect(
        find.text('"shot.png" is not an accepted file type'),
        findsOneWidget,
      );
    });

    testWidgets('a family pattern matches on the MIME type', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          accept: const <String>['image/*'],
          onPick: (_) async => <AstryxFile>[image, one],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(reported.single.map((f) => f.name), <String>['shot.png']);
    });

    testWidgets('too large is rejected, and unknown sizes pass', (
      tester,
    ) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          maxSize: 1024 * 1024,
          onPick: (_) async => <AstryxFile>[
            big,
            const AstryxFile(name: 'mystery.bin'),
          ],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      // The unmeasured file survives: a reticent picker is not a large file.
      expect(reported.single.map((f) => f.name), <String>['mystery.bin']);
      expect(find.textContaining('exceeds the 1.0 MB limit'), findsOneWidget);
    });

    testWidgets('too many is truncated, with a complaint', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          multiple: true,
          maxFiles: 2,
          onPick: (_) async => <AstryxFile>[one, image, big],
        ),
      );

      await tester.tap(find.text('Choose files').last);
      await tester.pumpAndSettle();
      expect(reported.single, hasLength(2));
      expect(find.text('Maximum 2 files allowed'), findsOneWidget);
    });

    testWidgets('a single-file field keeps only the first', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          onPick: (_) async => <AstryxFile>[one, image],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(reported.single.map((f) => f.name), <String>['report.pdf']);
    });

    testWidgets('a caller’s status beats the field’s own', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxFileInput(
          label: 'Attachments',
          files: const <AstryxFile>[],
          accept: const <String>['.pdf'],
          status: const AstryxFieldStatus.error('The server said no'),
          onChanged: (_) {},
          onPick: (_) async => <AstryxFile>[image],
        ),
      );

      await tester.tap(find.text('Choose file').last);
      await tester.pumpAndSettle();
      expect(find.text('The server said no'), findsOneWidget);
      expect(
        find.text('"shot.png" is not an accepted file type'),
        findsNothing,
      );
    });

    testWidgets('clearing empties the selection', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[one],
          onChanged: reported.add,
          onPick: (_) async => <AstryxFile>[],
        ),
      );

      await tester.tap(
        find.bySemanticsLabel('Remove the files chosen for Attachments'),
      );
      await tester.pump();
      expect(reported.single, isEmpty);
    });

    testWidgets('loading refuses the dialog and shows a spinner', (
      tester,
    ) async {
      var opened = 0;
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: (_) {},
          loading: true,
          onPick: (_) async {
            opened++;
            return <AstryxFile>[];
          },
        ),
      );

      expect(find.byType(AstryxSpinner), findsOneWidget);
      await tester.tap(find.text('Choose file').last, warnIfMissed: false);
      // Not `pumpAndSettle`: the spinner is a looping animation and never
      // settles.
      await tester.pump(const Duration(milliseconds: 300));
      expect(opened, 0);
    });

    testWidgets('a missing picker leaves the field inert', (tester) async {
      await pumpAstryxWidget(
        tester,
        input(files: const <AstryxFile>[], onChanged: (_) {}),
      );

      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.bySemanticsLabel(RegExp('Attachments')))
            .flagsCollection
            .isEnabled,
        Tristate.isFalse,
        reason: 'no dialog to open means nothing to press',
      );
      handle.dispose();
    });

    testWidgets('dropzone mode presses the same way', (tester) async {
      final reported = <List<AstryxFile>>[];
      await pumpAstryxWidget(
        tester,
        input(
          files: const <AstryxFile>[],
          onChanged: reported.add,
          mode: AstryxFileInputMode.dropzone,
          onPick: (_) async => <AstryxFile>[one],
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.text('Choose file'));
      await tester.pumpAndSettle();
      expect(reported.single.single.name, 'report.pdf');
    });

    testWidgets('the extension parse handles the awkward names', (
      tester,
    ) async {
      expect(const AstryxFile(name: 'a.PDF').extension, '.pdf');
      expect(const AstryxFile(name: 'noext').extension, isNull);
      expect(const AstryxFile(name: '.hidden').extension, isNull);
      expect(const AstryxFile(name: 'trailing.').extension, isNull);
      expect(const AstryxFile(name: 'a.tar.gz').extension, '.gz');
    });

    test('sizes are formatted as upstream formats them', () {
      expect(AstryxFileInput.formatSize(512), '512 B');
      expect(AstryxFileInput.formatSize(2048), '2.0 KB');
      expect(AstryxFileInput.formatSize(5 * 1024 * 1024), '5.0 MB');
    });
  });
}
