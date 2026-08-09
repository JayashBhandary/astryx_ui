@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for the form controls.
///
/// Every axis captured here has to be byte-different from its siblings, or the
/// golden is proving nothing — the lesson `P7-3` taught, where a progress bar
/// that painted no fill at all still passed every property assertion and
/// produced identical LTR and RTL images.
void main() {
  testWidgets('text input sizes and states', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final size in AstryxInputSize.values)
            AstryxTextInput(
              label: size.name,
              size: size,
              placeholder: 'Placeholder',
            ),
          const AstryxTextInput(
            label: 'Disabled',
            enabled: false,
            placeholder: 'Placeholder',
          ),
        ],
      ),
      name: 'text_input.sizes',
      surfaceSize: const Size(360, 340),
      // The label sits above the control and the leading edge flips, so RTL
      // is a genuinely different image.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the three validation states', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Error',
            status: AstryxFieldStatus.error('That address is not valid'),
          ),
          AstryxTextInput(
            label: 'Warning',
            status: AstryxFieldStatus.warning('This name is nearly taken'),
          ),
          AstryxTextInput(
            label: 'Success',
            status: AstryxFieldStatus.success('That looks right'),
          ),
        ],
      ),
      name: 'text_input.status',
      surfaceSize: const Size(360, 300),
      disableAnimations: true,
    );
  });

  testWidgets('the text area', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxTextArea(
        label: 'Notes',
        optional: true,
        placeholder: 'What happened?',
        description: 'Markdown is not interpreted.',
      ),
      name: 'text_area',
      surfaceSize: const Size(360, 220),
      disableAnimations: true,
    );
  });

  testWidgets('the checkbox states', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          for (final size in AstryxToggleSize.values) ...<Widget>[
            AstryxCheckbox(
              label: 'Unchecked (${size.name})',
              size: size,
              value: false,
              onChanged: (_) {},
            ),
            AstryxCheckbox(
              label: 'Checked (${size.name})',
              size: size,
              value: true,
              onChanged: (_) {},
            ),
            AstryxCheckbox.tristate(
              label: 'Indeterminate (${size.name})',
              size: size,
              value: AstryxCheckboxValue.indeterminate,
              onChanged: (_) {},
            ),
          ],
          AstryxCheckbox(label: 'Disabled', value: true, enabled: false),
        ],
      ),
      name: 'checkbox.states',
      // Tall enough for seven rows at touch density, where each one grows to
      // the 48px floor.
      surfaceSize: const Size(360, 400),
      // Touch density floors every row, so the whole column is a different
      // height — the one axis where this control actually changes shape.
      densities: const <AstryxDensity>{
        AstryxDensity.pointer,
        AstryxDensity.touch,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the radio group', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxRadioList<String>(
        label: 'Plan',
        value: 'pro',
        onChanged: (_) {},
        options: const <AstryxRadioOption<String>>[
          AstryxRadioOption(
            value: 'free',
            label: 'Free',
            description: 'One project.',
          ),
          AstryxRadioOption(value: 'pro', label: 'Pro'),
          AstryxRadioOption(
            value: 'ent',
            label: 'Enterprise',
            enabled: false,
          ),
        ],
      ),
      name: 'radio_list',
      surfaceSize: const Size(360, 240),
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the switch, on and off, in both directions', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final value in <bool>[false, true])
            for (final size in AstryxToggleSize.values)
              AstryxSwitch(
                label: '${size.name} ${value ? 'on' : 'off'}',
                size: size,
                value: value,
                labelPosition: AstryxToggleLabelPosition.start,
                labelSpacing: AstryxToggleLabelSpacing.spread,
                onChanged: (_) {},
              ),
          const AstryxSwitch(label: 'Disabled', value: true, enabled: false),
        ],
      ),
      name: 'switch.states',
      surfaceSize: const Size(320, 260),
      // The thumb travels toward the reading-end edge, so RTL mirrors it —
      // the assertion the widget test makes numerically, made visually here.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });

  testWidgets('the selector, closed', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSelector<String>(
            label: 'Owner',
            value: 'ada',
            onChanged: (_) {},
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
            ],
          ),
          AstryxSelector<String>(
            label: 'Empty',
            value: null,
            onChanged: (_) {},
            options: const <AstryxSelectorEntry<String>>[],
          ),
          const AstryxSelector<String>(
            label: 'Disabled',
            value: null,
            enabled: false,
            options: <AstryxSelectorEntry<String>>[],
          ),
        ],
      ),
      name: 'selector.closed',
      surfaceSize: const Size(360, 260),
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      disableAnimations: true,
    );
  });
}
