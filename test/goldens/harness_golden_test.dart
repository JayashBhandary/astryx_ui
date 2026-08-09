@Tags(<String>['golden'])
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Exercises the golden harness itself.
///
/// Deliberately uses no `astryx_ui` code — if this fails, the harness broke,
/// not a component. The subject is asymmetric and uses directional padding so
/// the RTL axis produces a genuinely different image; a harness that silently
/// ignored [TextDirection] would still pass an LTR-only smoke test.
void main() {
  testWidgets('harness renders the brightness x direction matrix', (
    tester,
  ) async {
    await expectAstryxGolden(
      tester,
      const _HarnessSubject(),
      name: 'harness',
      surfaceSize: const Size(200, 120),
      directions: {TextDirection.ltr, TextDirection.rtl},
    );
  });
}

class _HarnessSubject extends StatelessWidget {
  const _HarnessSubject();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 48, height: 48, color: const Color(0xFF0064E0)),
          const SizedBox(width: 8),
          Container(width: 24, height: 48, color: const Color(0xFFE3193B)),
        ],
      ),
    );
  }
}
