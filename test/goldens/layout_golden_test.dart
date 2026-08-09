@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for the Phase 5 primitives.
///
/// Behaviour lives in `test/components/layout_test.dart`; these only compare
/// pixels. Text renders with the test environment's fallback font, so these are
/// stable for a pinned Flutter version — see the harness's own documentation.
void main() {
  testWidgets('the type scale renders at every role', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxHeading('Heading 1', level: 1),
          AstryxHeading('Heading 3', level: 3),
          AstryxText('Body copy at the base size'),
          AstryxText('Supporting text', type: AstryxTextType.supporting),
          AstryxText('A label', type: AstryxTextType.label),
          AstryxText('code_sample()', type: AstryxTextType.code),
        ],
      ),
      name: 'typography',
      surfaceSize: const Size(360, 240),
    );
  });

  testWidgets('text colours render across the semantic set', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing1,
        children: <Widget>[
          AstryxText('Primary'),
          AstryxText('Secondary', color: AstryxTextColor.secondary),
          AstryxText('Disabled', color: AstryxTextColor.disabled),
          AstryxText('Accent', color: AstryxTextColor.accent),
        ],
      ),
      name: 'text.colors',
      surfaceSize: const Size(240, 160),
    );
  });

  testWidgets('dividers render plain and labelled', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxDivider(),
          AstryxDivider(variant: AstryxDividerVariant.strong),
          AstryxDivider(label: 'Advanced'),
        ],
      ),
      name: 'divider',
      surfaceSize: const Size(280, 140),
    );
  });

  testWidgets('icons render at every size, and mirror under RTL', (
    tester,
  ) async {
    await expectAstryxGolden(
      tester,
      const AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          AstryxIcon(AstryxIconName.check, size: AstryxIconSize.xsm),
          AstryxIcon(AstryxIconName.warning, color: AstryxIconColor.warning),
          AstryxIcon(AstryxIconName.chevronRight, size: AstryxIconSize.lg),
        ],
      ),
      name: 'icon',
      surfaceSize: const Size(200, 80),
      // The chevron must point the other way in RTL.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
    );
  });

  testWidgets('the grid lays out responsively', (tester) async {
    await expectAstryxGolden(
      tester,
      AstryxGrid(
        minWidth: 80,
        gap: AstryxSpacingToken.spacing2,
        children: List<Widget>.generate(
          5,
          (i) => const AstryxCenter(
            minHeight: 40,
            child: AstryxText('Cell'),
          ),
        ),
      ),
      name: 'grid',
      surfaceSize: const Size(300, 160),
    );
  });
}
