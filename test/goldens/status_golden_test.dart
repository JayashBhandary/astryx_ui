@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for the status indicators.
///
/// **The convention for animated goldens**, which Phases 9 and 10 reuse: pump
/// to a *named fraction* of the animation's own cycle rather than to a wall
/// clock. A fraction stays correct if a duration token changes; a hard-coded
/// millisecond count silently starts capturing a different frame.
void main() {
  /// Two thirds through the cycle.
  ///
  /// Chosen deliberately, and neither an end nor the middle. The
  /// indeterminate fill overshoots the track at both ends, so near 0 or 1 it
  /// is clipped out of sight; and at exactly 0.5 it sits on the axis of
  /// symmetry, where
  /// `AlignmentDirectional(0)` resolves the same in both directions. Either
  /// would make the LTR and RTL goldens byte-identical and the direction axis
  /// prove nothing.
  const capturedAt = 0.65;

  testWidgets('spinners at every size', (tester) async {
    await expectAstryxGolden(
      tester,
      const AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        children: <Widget>[
          AstryxSpinner(size: AstryxSpinnerSize.sm),
          AstryxSpinner(),
          AstryxSpinner(size: AstryxSpinnerSize.lg),
          AstryxSpinner(shade: AstryxSpinnerShade.subtle),
        ],
      ),
      name: 'spinner',
      surfaceSize: const Size(200, 60),
      // Frozen: an indeterminate spinner has no stable frame otherwise.
      disableAnimations: true,
    );
  });

  testWidgets('a skeleton block group', (tester) async {
    await expectAstryxGolden(
      tester,
      const SizedBox(
        width: 240,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.start,
          children: <Widget>[
            AstryxSkeleton.circle(size: 40),
            Expanded(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxSkeleton.text(),
                  AstryxSkeleton.text(widthFactor: 0.6),
                ],
              ),
            ),
          ],
        ),
      ),
      name: 'skeleton',
      surfaceSize: const Size(280, 100),
      disableAnimations: true,
    );
  });

  testWidgets('progress bars, determinate and by variant', (tester) async {
    await expectAstryxGolden(
      tester,
      const SizedBox(
        width: 260,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxProgressBar(
              label: 'Uploading',
              value: 0.4,
              showValueLabel: true,
            ),
            AstryxProgressBar(
              label: 'Complete',
              value: 1,
              variant: AstryxProgressVariant.success,
            ),
            AstryxProgressBar(
              label: 'Failed',
              value: 0.7,
              variant: AstryxProgressVariant.error,
            ),
            AstryxProgressBar(label: 'Disabled', value: 0.3, enabled: false),
          ],
        ),
      ),
      name: 'progress_bar',
      surfaceSize: const Size(300, 200),
      settle: true,
    );
  });

  testWidgets('an indeterminate bar mid-cycle, both directions', (
    tester,
  ) async {
    await expectAstryxGolden(
      tester,
      const SizedBox(
        width: 260,
        child: AstryxProgressBar(label: 'Loading', showLabel: false),
      ),
      name: 'progress_bar.indeterminate',
      surfaceSize: const Size(300, 60),
      // The fill travels along the reading direction, so RTL is a real case.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      animationFraction: capturedAt,
      animationCycle: const Duration(milliseconds: 1500),
    );
  });
}
