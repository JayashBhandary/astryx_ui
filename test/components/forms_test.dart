import 'dart:ui' show CheckedState, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 8 — forms.
///
/// The emphasis is accessibility and the keyboard, because those are the two
/// things a form gets wrong in ways nobody notices until someone cannot use it.
/// Appearance is covered by `test/goldens/forms_golden_test.dart`.
void main() {
  group('P8-1 — AstryxField', () {
    testWidgets('the label names the control, and is not read twice', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(label: 'Email', description: 'Sign-in address'),
      );

      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.label, 'Email');
      expect(node.hint, contains('Sign-in address'));
      expect(node.flagsCollection.isTextField, isTrue);

      // The visible label is decorative — `ExcludeSemantics` — so the string
      // reaches a screen reader once, from the control, not twice.
      expect(find.text('Email'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('an error marks the field invalid and shows its message', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(
          label: 'Email',
          status: AstryxFieldStatus.error('That address is not valid'),
        ),
      );

      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.validationResult, SemanticsValidationResult.invalid);
      expect(node.hint, contains('That address is not valid'));
      expect(find.text('That address is not valid'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('required and optional markers are mutually exclusive', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxField(
          label: 'Email',
          required: true,
          child: SizedBox.shrink(),
        ),
      );
      expect(find.text('Required'), findsOneWidget);

      await pumpAstryxWidget(
        tester,
        const AstryxField(
          label: 'Email',
          optional: true,
          child: SizedBox.shrink(),
        ),
      );
      expect(find.text('Optional'), findsOneWidget);

      expect(
        () => AstryxField(
          label: 'x',
          required: true,
          optional: true,
          child: const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('a hidden label still names the control', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(label: 'Search', labelHidden: true),
      );

      expect(find.text('Search'), findsNothing);
      expect(tester.getSemantics(find.byType(EditableText)).label, 'Search');
      handle.dispose();
    });
  });

  group('P8-2 — AstryxTextInput', () {
    testWidgets('typing reaches the controller and onChanged', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var changes = 0;

      await pumpAstryxWidget(
        tester,
        AstryxTextInput(
          label: 'Name',
          controller: controller,
          onChanged: (_) => changes++,
        ),
      );

      await tester.enterText(find.byType(EditableText), 'Ada');
      expect(controller.text, 'Ada');
      expect(changes, 1);
    });

    testWidgets('the placeholder hides once there is text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTextInput(
          label: 'Name',
          controller: controller,
          placeholder: 'Your name',
        ),
      );
      expect(find.text('Your name'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'A');
      await tester.pump();
      expect(find.text('Your name'), findsNothing);
    });

    testWidgets('a press on the container focuses the field', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(label: 'Name', width: 320),
      );

      bool hasFocus() => tester
          .widget<EditableText>(find.byType(EditableText))
          .focusNode
          .hasFocus;

      expect(hasFocus(), isFalse);

      // The top-left corner of the container is padding, not text — which is
      // the case `useInputContainer` exists for.
      final box = find.byType(AstryxTextInput);
      await tester.tapAt(tester.getTopLeft(box) + const Offset(6, 40));
      await tester.pump();

      expect(hasFocus(), isTrue);
    });

    testWidgets('the clear button empties the field and then disappears', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'invoice');
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTextInput(
          label: 'Search',
          controller: controller,
          showClear: true,
        ),
      );

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(find.byType(AstryxIconButton), findsNothing);
    });

    testWidgets('obscureText and readOnly reach the editable', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(
          label: 'Password',
          obscureText: true,
          readOnly: true,
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.obscureText, isTrue);
      expect(editable.readOnly, isTrue);
    });

    testWidgets('a disabled field cannot be edited', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(label: 'Name', enabled: false),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );
      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.byType(EditableText))
            .flagsCollection
            .isEnabled,
        Tristate.isFalse,
      );
      handle.dispose();
    });

    testWidgets('maxLength stops further input', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTextInput(
          label: 'PIN',
          controller: controller,
          maxLength: 4,
        ),
      );

      await tester.enterText(find.byType(EditableText), '1234567');
      expect(controller.text, '1234');
    });

    testWidgets('selection controls and a context menu are supplied', (
      tester,
    ) async {
      // Not Material's: the toolbar is Astryx's own, because
      // `AdaptiveTextSelectionToolbar` needs a `MaterialLocalizations`
      // ancestor this package refuses to require.
      await pumpAstryxWidget(tester, const AstryxTextInput(label: 'Name'));

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.selectionControls, isNotNull);
      expect(editable.contextMenuBuilder, isNotNull);
    });
  });

  group('P8-3 — AstryxTextArea', () {
    testWidgets('is multiline and taller than a single-line input', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxTextInput(label: 'One'),
            AstryxTextArea(label: 'Many'),
          ],
        ),
        surfaceSize: const Size(400, 400),
      );

      final single = tester.getSize(find.byType(AstryxTextInput).first).height;
      final multi = tester.getSize(find.byType(AstryxTextArea)).height;
      expect(multi, greaterThan(single));

      expect(
        tester
            .getSemantics(find.byType(EditableText).last)
            .flagsCollection
            .isMultiline,
        isTrue,
      );
      handle.dispose();
    });
  });

  group('P8-4 — AstryxCheckbox', () {
    testWidgets('a press toggles it, from the label as well as the box', (
      tester,
    ) async {
      var value = false;
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxCheckbox(
            label: 'Accept terms',
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      );

      await tester.tap(find.text('Accept terms'));
      await tester.pump();
      expect(value, isTrue, reason: 'the label is part of the target');

      await tester.tap(find.byType(AstryxCheckbox));
      await tester.pump();
      expect(value, isFalse);
    });

    testWidgets('space toggles it and Enter does not', (tester) async {
      var value = false;
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxCheckbox(
            label: 'Accept',
            value: value,
            focusNode: node,
            autofocus: true,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(value, isTrue);

      // Enter belongs to the form, not the checkbox.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(value, isTrue);
    });

    testWidgets('indeterminate is exposed as mixed, and resolves to checked', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      AstryxCheckboxValue? received;

      await pumpAstryxWidget(
        tester,
        AstryxCheckbox.tristate(
          label: 'All scopes',
          value: AstryxCheckboxValue.indeterminate,
          onChanged: (v) => received = v,
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxCheckbox));
      expect(node.flagsCollection.isChecked, CheckedState.mixed);

      await tester.tap(find.byType(AstryxCheckbox));
      expect(received, AstryxCheckboxValue.checked);
      handle.dispose();
    });

    testWidgets('disabled, read-only and loading all refuse the press', (
      tester,
    ) async {
      for (final widget in <AstryxCheckbox>[
        AstryxCheckbox(
          label: 'a',
          value: false,
          enabled: false,
          onChanged: (_) => fail('disabled fired'),
        ),
        AstryxCheckbox(
          label: 'b',
          value: false,
          readOnly: true,
          onChanged: (_) => fail('read-only fired'),
        ),
        AstryxCheckbox(
          label: 'c',
          value: false,
          loading: true,
          onChanged: (_) => fail('loading fired'),
        ),
      ]) {
        await pumpAstryxWidget(tester, widget);
        await tester.tap(find.byType(AstryxCheckbox), warnIfMissed: false);
        await tester.pump();
      }
    });
  });

  group('P8-5 — AstryxRadioList', () {
    Widget buildGroup(void Function(String) onChanged, String value) =>
        AstryxRadioList<String>(
          label: 'Plan',
          value: value,
          onChanged: onChanged,
          autofocus: true,
          options: const <AstryxRadioOption<String>>[
            AstryxRadioOption(value: 'free', label: 'Free'),
            AstryxRadioOption(
              value: 'team',
              label: 'Team',
              enabled: false,
            ),
            AstryxRadioOption(value: 'pro', label: 'Pro'),
          ],
        );

    testWidgets('the arrows move and select, skipping disabled options', (
      tester,
    ) async {
      var value = 'free';
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) =>
              buildGroup((v) => setState(() => value = v), value),
        ),
        surfaceSize: const Size(400, 400),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(value, 'pro', reason: 'Team is disabled, so it is skipped');
    });

    testWidgets('the arrows wrap at both ends', (tester) async {
      var value = 'free';
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) =>
              buildGroup((v) => setState(() => value = v), value),
        ),
        surfaceSize: const Size(400, 400),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(
        value,
        'pro',
        reason: 'up from the first option wraps to the last',
      );
    });

    testWidgets('the inline arrows mirror under RTL', (tester) async {
      var value = 'free';
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) =>
              buildGroup((v) => setState(() => value = v), value),
        ),
        textDirection: TextDirection.rtl,
        surfaceSize: const Size(400, 400),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value, 'pro', reason: 'left is forward under RTL');
    });

    testWidgets('the options form a mutually exclusive group', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        buildGroup((_) {}, 'free'),
        surfaceSize: const Size(400, 400),
      );

      final free = tester.getSemantics(find.text('Free'));
      expect(free.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(free.flagsCollection.isChecked, CheckedState.isTrue);
      // Exactly one option is checked — the whole point of the role.
      expect(
        tester.getSemantics(find.text('Pro')).flagsCollection.isChecked,
        CheckedState.isFalse,
      );
      handle.dispose();
    });

    testWidgets('a disabled option cannot be chosen by pressing it', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        buildGroup((_) => fail('a disabled option fired'), 'free'),
        surfaceSize: const Size(400, 400),
      );

      await tester.tap(find.text('Team'), warnIfMissed: false);
      await tester.pump();
    });
  });

  group('P8-6 — AstryxSwitch', () {
    testWidgets('is exposed as toggled, not checked', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxSwitch(label: 'Notifications', value: true),
      );

      final node = tester.getSemantics(find.byType(AstryxSwitch));
      expect(node.flagsCollection.isToggled, Tristate.isTrue);
      // A switch is toggled, never checked — the two are different roles and
      // a screen reader says different words for them.
      expect(node.flagsCollection.isChecked, CheckedState.none);
      handle.dispose();
    });

    testWidgets('the arrows set a state rather than toggling', (tester) async {
      var value = false;
      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxSwitch(
            label: 'Notifications',
            value: value,
            autofocus: true,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value, isTrue);

      // Right again is a no-op, which is what "set" means.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value, isFalse);
    });

    testWidgets('the thumb travels to the trailing edge in both directions', (
      tester,
    ) async {
      Future<double> thumbCentre(
        TextDirection direction, {
        required bool value,
      }) async {
        await pumpAstryxWidget(
          tester,
          AstryxSwitch(label: 'S', value: value, labelHidden: true),
          textDirection: direction,
        );
        await tester.pumpAndSettle();
        final track = tester.getRect(find.byType(AstryxSwitch));
        // The thumb is the innermost sized box inside the track.
        final thumb = tester.getRect(
          find
              .descendant(
                of: find.byType(AstryxSwitch),
                matching: find.byType(AnimatedContainer),
              )
              .last,
        );
        return thumb.center.dx - track.center.dx;
      }

      final ltrOn = await thumbCentre(TextDirection.ltr, value: true);
      final ltrOff = await thumbCentre(TextDirection.ltr, value: false);
      final rtlOn = await thumbCentre(TextDirection.rtl, value: true);

      expect(ltrOn, greaterThan(ltrOff));
      expect(rtlOn, lessThan(0), reason: 'on travels left under RTL');
    });
  });

  group('P8-7 — AstryxSelector', () {
    List<AstryxSelectorEntry<String>> options() =>
        const <AstryxSelectorEntry<String>>[
          AstryxSelectorSection('People'),
          AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
          AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
          AstryxSelectorDivider<String>(),
          AstryxSelectorOption(value: 'grace', label: 'Grace Hopper'),
          AstryxSelectorOption(
            value: 'kat',
            label: 'Katherine Johnson',
            enabled: false,
          ),
        ];

    Widget build(
      void Function(String?) onChanged,
      String? value, {
      bool showSearch = false,
    }) => AstryxSelector<String>(
      label: 'Owner',
      value: value,
      onChanged: onChanged,
      showSearch: showSearch,
      autofocus: true,
      options: options(),
      width: 320,
    );

    testWidgets('opens on a press and closes on a press outside', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build((_) {}, null),
        surfaceSize: const Size(400, 600),
      );

      expect(find.text('Ada Lovelace'), findsNothing);

      await tester.tap(find.byType(AstryxSelector<String>));
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsOneWidget);

      await tester.tapAt(const Offset(390, 590));
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsNothing);
    });

    testWidgets('the arrows highlight without selecting; Enter commits', (
      tester,
    ) async {
      String? chosen;
      await pumpAstryxWidget(
        tester,
        build((v) => chosen = v, null),
        surfaceSize: const Size(400, 600),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsOneWidget, reason: 'it opened');
      expect(chosen, isNull, reason: 'browsing does not select');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(chosen, isNull);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(chosen, 'alan');
      expect(find.text('Ada Lovelace'), findsNothing, reason: 'it closed');
    });

    testWidgets('Escape closes without selecting', (tester) async {
      await pumpAstryxWidget(
        tester,
        build((_) => fail('Escape selected something'), null),
        surfaceSize: const Size(400, 600),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsNothing);
    });

    testWidgets('type-ahead jumps to the first match', (tester) async {
      String? chosen;
      await pumpAstryxWidget(
        tester,
        build((v) => chosen = v, null),
        surfaceSize: const Size(400, 600),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosen, 'grace');
    });

    testWidgets('Home and End jump to the ends, skipping disabled options', (
      tester,
    ) async {
      String? chosen;
      await pumpAstryxWidget(
        tester,
        build((v) => chosen = v, null),
        surfaceSize: const Size(400, 600),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosen, 'grace', reason: 'Katherine is disabled');
    });

    testWidgets('the search box filters the list', (tester) async {
      await pumpAstryxWidget(
        tester,
        build((_) {}, null, showSearch: true),
        surfaceSize: const Size(400, 600),
      );

      await tester.tap(find.byType(AstryxSelector<String>));
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).last, 'grace');
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsNothing);
      expect(find.text('Grace Hopper'), findsOneWidget);
    });

    testWidgets('the list stays inside the viewport near the bottom', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        // The trigger sits at the bottom of a 400x300 surface, so the list
        // cannot open downward.
        Align(
          alignment: Alignment.bottomCenter,
          child: build((_) {}, null),
        ),
      );

      await tester.tap(find.byType(AstryxSelector<String>));
      await tester.pumpAndSettle();

      // The positioner's whole job: below the trigger there is no room, so
      // the list flips above it rather than being clipped away.
      final list = tester.getRect(find.text('Ada Lovelace'));
      expect(list.top, greaterThanOrEqualTo(0));
      expect(list.bottom, lessThanOrEqualTo(300));
    });

    testWidgets('is exposed as an expandable button carrying its value', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build((_) {}, 'ada'),
        surfaceSize: const Size(400, 600),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Owner'));
      expect(node.label, 'Owner');
      expect(node.value, 'Ada Lovelace');
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isExpanded, Tristate.isFalse);
      handle.dispose();
    });

    testWidgets('a disabled selector does not open', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxSelector<String>(
          label: 'Owner',
          value: null,
          enabled: false,
          options: options(),
          onChanged: (_) {},
        ),
        surfaceSize: const Size(400, 600),
      );

      await tester.tap(
        find.byType(AstryxSelector<String>),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsNothing);
    });
  });

  group('P8-8 — density and tap targets', () {
    testWidgets('every control meets the touch tap-target guideline', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxCheckbox(label: 'Check', value: false, onChanged: (_) {}),
            AstryxSwitch(label: 'Switch', value: false, onChanged: (_) {}),
          ],
        ),
        density: AstryxDensity.touch,
        surfaceSize: const Size(400, 400),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });
  });
}
