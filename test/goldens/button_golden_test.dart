@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for the button family.
void main() {
  testWidgets('the variant x size matrix', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          for (final variant in AstryxButtonVariant.values)
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                for (final size in AstryxButtonSize.values)
                  AstryxButton(
                    label: variant.name,
                    variant: variant,
                    size: size,
                    onPressed: () {},
                  ),
              ],
            ),
        ],
      ),
      name: 'button.matrix',
      // Wide enough for the longest variant name at lg, and tall enough for
      // touch density, where every row grows to the 48px floor.
      surfaceSize: const Size(600, 320),
      // Touch density floors every height, so the matrix is a different shape.
      densities: const <AstryxDensity>{
        AstryxDensity.pointer,
        AstryxDensity.touch,
      },
    );
  });

  testWidgets('states — disabled, loading, with icons', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxButton(label: 'Enabled', onPressed: () {}),
          AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
          AstryxButton(label: 'Loading', loading: true, onPressed: () {}),
          AstryxButton(
            label: 'Icons',
            leading: const AstryxIcon(AstryxIconName.check),
            trailing: const AstryxIcon(AstryxIconName.chevronDown),
            onPressed: () {},
          ),
        ],
      ),
      name: 'button.states',
      surfaceSize: const Size(620, 80),
    );
  });

  testWidgets('icon buttons at every size', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          for (final size in AstryxButtonSize.values)
            AstryxIconButton(
              icon: AstryxIconName.close,
              label: 'Close',
              size: size,
              onPressed: () {},
            ),
          AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Confirm',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      name: 'icon_button',
      surfaceSize: const Size(240, 80),
    );
  });

  testWidgets('a joined group, both directions', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxButtonGroup(
        children: <Widget>[
          AstryxButton(label: 'Day', onPressed: () {}),
          AstryxButton(label: 'Week', onPressed: () {}),
          AstryxButton(label: 'Month', onPressed: () {}),
        ],
      ),
      name: 'button_group',
      surfaceSize: const Size(320, 80),
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
    );
  });
}
