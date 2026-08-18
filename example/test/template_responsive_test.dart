/// Every documented template, at the widths a phone actually has.
///
/// The docs offer a Mobile preview pinned to 390 logical pixels, which is what
/// makes a broken narrow layout something a reader sees rather than something
/// only a device finds. A `RenderFlex` that overflows is not a cosmetic
/// complaint: the widget past the edge is clipped, so a filter, a pager or a
/// Save button can be on the screen and unreachable at the same time.
///
/// The check is deliberately blunt — pump it, and assert nothing was thrown.
/// It cannot say a layout is *good* at 360; it can say nothing has been pushed
/// off the side of it.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/previews.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// The widths worth checking: a small phone, the width the docs' own Mobile
  /// preview pins to, a large phone in landscape, and a tablet.
  const widths = <double>[360, 390, 600, 768];

  for (final width in widths) {
    testWidgets('no template overflows at ${width.toInt()}', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final broken = <String, Set<String>>{};

      for (final entry in docPreviews.entries) {
        if (!entry.key.startsWith('template_')) continue;

        final errors = <String>{};
        // Collected rather than thrown: one overflow would otherwise end the
        // run at the first template, and the list of which ones break is the
        // whole point of the check.
        final previous = FlutterError.onError;
        FlutterError.onError = (details) =>
            errors.add(details.exceptionAsString().split('\n').first);
        try {
          await tester.pumpWidget(
            AstryxApp(
              home: SingleChildScrollView(child: Builder(builder: entry.value)),
            ),
          );
          // Not `pumpAndSettle`: several templates hold a deliberately endless
          // animation — a pulsing status dot on a wall display — and settling
          // waits for an end that never comes.
          await tester.pump(const Duration(milliseconds: 300));
        } on Object catch (error) {
          errors.add(error.toString().split('\n').first);
        } finally {
          FlutterError.onError = previous;
        }

        if (errors.isNotEmpty) broken[entry.key] = errors;
      }

      expect(broken, isEmpty, reason: 'templates broken at ${width.toInt()}px');
    });
  }
}
