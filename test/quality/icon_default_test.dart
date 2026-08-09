import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P11-6` — the ambient icon theme.
///
/// `AstryxTheme` installs an `IconTheme`, and `AstryxIcon` inherits from it by
/// default (ADR-044). Both halves are asserted here because the bug they fix
/// was invisible: `IconTheme.of` returns Flutter's *fallback* — 24px, black —
/// when nothing installs one, so `AstryxIcon`'s `md` default was never reached
/// and every unsized icon rendered 4px too large.
void main() {
  testWidgets("an unsized icon takes the md step, not Flutter's 24", (
    tester,
  ) async {
    await pumpAstryxWidget(tester, const AstryxIcon(AstryxIconName.check));

    expect(
      tester.widget<Icon>(find.byType(Icon)).size,
      AstryxIconSize.md.pixels,
    );
  });

  testWidgets('an uncoloured icon takes --color-icon-primary', (tester) async {
    await pumpAstryxWidget(tester, const AstryxIcon(AstryxIconName.check));

    final theme = AstryxTheme.of(tester.element(find.byType(AstryxIcon)));
    expect(
      IconTheme.of(tester.element(find.byType(Icon))).color,
      theme.color(AstryxColorToken.iconPrimary),
    );
  });

  testWidgets('a component can impose a colour on an icon it did not build', (
    tester,
  ) async {
    // The reason the default is `inherit`: a badge tints a caller-supplied
    // icon to its own foreground, which a fixed role colour would ignore.
    await pumpAstryxWidget(
      tester,
      const AstryxBadge(
        'Done',
        icon: AstryxIcon(AstryxIconName.check),
        variant: AstryxBadgeVariant.success,
      ),
    );

    final theme = AstryxTheme.of(tester.element(find.byType(AstryxBadge)));
    expect(
      IconTheme.of(tester.element(find.byType(Icon))).color,
      theme.color(AstryxColorToken.onSuccess),
      reason: "the badge imposed its foreground on the caller's icon",
    );
  });

  testWidgets('an explicit colour still wins', (tester) async {
    await pumpAstryxWidget(
      tester,
      const AstryxIcon(
        AstryxIconName.warning,
        color: AstryxIconColor.warning,
      ),
    );

    final theme = AstryxTheme.of(tester.element(find.byType(AstryxIcon)));
    expect(
      tester.widget<Icon>(find.byType(Icon)).color,
      theme.color(AstryxColorToken.warning),
    );
  });

  testWidgets('the ambient size matches the md token', (tester) async {
    // The theme layer hard-codes 20 because `AstryxIconSize` lives in the
    // component layer. This is the test that stops the two drifting.
    await pumpAstryxWidget(tester, const SizedBox.shrink());
    final size = IconTheme.of(
      tester.element(find.byType(SizedBox).first),
    ).size;
    expect(size, AstryxIconSize.md.pixels);
  });
}
