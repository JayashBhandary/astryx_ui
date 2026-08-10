/// WCAG contrast for the colour pairs the docs chrome actually puts on screen.
///
/// The package has its own contrast tests, but they check the *engine* — that
/// the maths matches upstream. This checks the *choices*: every foreground the
/// docs site paints over every background it paints it on, in all eight themes
/// and both brightnesses. Sixteen combinations per pair is more than anyone
/// checks by looking, which is how a legible badge in light mode ships as an
/// illegible one in dark.
///
/// Thresholds are WCAG 2.1 AA: 4.5:1 for body text, 3:1 for large text and for
/// the non-text parts of a control.
library;

import 'dart:math' as math;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The relative luminance of [color], per WCAG 2.1.
double _luminance(Color color) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// The WCAG contrast ratio between [a] and [b], 1..21.
double _ratio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// One foreground-over-background pair, and where the site paints it.
class _Pair {
  const _Pair(
    this.name,
    this.foreground,
    this.background,
    this.minimum,
    this.where,
  );

  /// The pair, as tokens — the key this is tracked by.
  final String name;

  final AstryxColorToken foreground;
  final AstryxColorToken background;

  /// The AA threshold this pair has to clear.
  final double minimum;

  /// What is drawn with it, for the failure message.
  final String where;
}

/// Each distinct pair once. Three sidebar elements share
/// `textSecondary` over `backgroundBody`; measuring it three times would report
/// one theme's shortfall as three failures.
const List<_Pair> _pairs = <_Pair>[
  _Pair(
    'textPrimary/backgroundBody',
    AstryxColorToken.textPrimary,
    AstryxColorToken.backgroundBody,
    4.5,
    'body text, group headings',
  ),
  _Pair(
    'textSecondary/backgroundBody',
    AstryxColorToken.textSecondary,
    AstryxColorToken.backgroundBody,
    4.5,
    'nav item labels, group counts, supporting text',
  ),
  _Pair(
    'textPrimary/backgroundMuted',
    AstryxColorToken.textPrimary,
    AstryxColorToken.backgroundMuted,
    4.5,
    'the selected nav item',
  ),
  _Pair(
    'textPrimary/neutral',
    AstryxColorToken.textPrimary,
    AstryxColorToken.neutral,
    4.5,
    'the placeholder badge — Soon, Empty, N/A',
  ),
  _Pair(
    'iconSecondary/backgroundBody',
    AstryxColorToken.iconSecondary,
    AstryxColorToken.backgroundBody,
    3,
    'the group chevron, the filter icon',
  ),
  _Pair(
    'textPrimary/backgroundCard',
    AstryxColorToken.textPrimary,
    AstryxColorToken.backgroundCard,
    4.5,
    'text inside an example frame',
  ),
  _Pair(
    'textAccent/backgroundBody',
    AstryxColorToken.textAccent,
    AstryxColorToken.backgroundBody,
    4.5,
    'links in prose',
  ),
];

/// Pairs that already fell short of AA before this site was built, with the
/// ratio measured on 2026-08-10.
///
/// `textSecondary` is the design system's own supporting-text token, ported
/// from upstream and verified against upstream's fixtures. Raising it here
/// would break that parity, so the shortfall is recorded rather than hidden —
/// and pinned, so a theme that gets *worse* still fails.
///
/// Every one is light mode. In dark mode all eight themes clear AA on every
/// pair.
const Map<String, double> _knownShortfalls = <String, double>{
  'matcha/light/textSecondary/backgroundBody': 3.83,
  'stone/light/textSecondary/backgroundBody': 3.40,
  'chocolate/light/textSecondary/backgroundBody': 3.06,
  'y2k/light/textSecondary/backgroundBody': 4.25,
};

void main() {
  /// Every pair's ratio for [theme] at [mode].
  Future<Map<String, double>> measure(
    WidgetTester tester,
    DocsTheme theme,
    AstryxColorMode mode,
  ) async {
    final ratios = <String, double>{};

    await tester.pumpWidget(
      AstryxApp(
        theme: theme.theme,
        mode: mode,
        home: Builder(
          builder: (context) {
            final resolved = AstryxTheme.of(context);
            final page = resolved.color(AstryxColorToken.backgroundBody);

            for (final pair in _pairs) {
              // Several tokens are translucent overlays — `neutral` is a tint,
              // not a fill. Measuring their raw channels reports 1.00:1 for a
              // badge that is plainly legible on screen, because the alpha is
              // where the colour comes from. Composite in the order the
              // painter does: surface over page, then text over surface.
              final background = Color.alphaBlend(
                resolved.color(pair.background),
                page,
              );
              final foreground = Color.alphaBlend(
                resolved.color(pair.foreground),
                background,
              );
              ratios[pair.name] = _ratio(foreground, background);
            }
            return const SizedBox();
          },
        ),
      ),
    );

    return ratios;
  }

  testWidgets('no docs colour pair falls short of AA unexpectedly', (
    tester,
  ) async {
    final failures = <String>[];
    final regressions = <String>[];

    for (final mode in <AstryxColorMode>[
      AstryxColorMode.light,
      AstryxColorMode.dark,
    ]) {
      for (final theme in DocsTheme.values) {
        final ratios = await measure(tester, theme, mode);

        for (final pair in _pairs) {
          final ratio = ratios[pair.name]!;
          final key = '${theme.name}/${mode.name}/${pair.name}';
          final known = _knownShortfalls[key];

          if (known != null) {
            // Pinned: allowed to be below AA, not allowed to get worse.
            if (ratio < known - 0.01) {
              regressions.add(
                '$key — ${ratio.toStringAsFixed(2)}:1, was $known:1',
              );
            }
            continue;
          }

          if (ratio < pair.minimum) {
            failures.add(
              '$key — ${ratio.toStringAsFixed(2)}:1, '
              'needs ${pair.minimum}:1 (${pair.where})',
            );
          }
        }
      }
    }

    expect(
      failures,
      isEmpty,
      reason:
          '\nNew contrast failures:\n${failures.join('\n')}\n\n'
          'Either pick a different token, or — if this is an inherited theme '
          'value that cannot change — pin it in `_knownShortfalls` with a '
          'reason.',
    );
    expect(
      regressions,
      isEmpty,
      reason: '\nPinned pairs that got worse:\n${regressions.join('\n')}',
    );
  });

  testWidgets('a pinned shortfall is still a real one', (tester) async {
    // Stops `_knownShortfalls` rotting: an entry that now passes should be
    // deleted, not left implying a problem that is fixed.
    final stale = <String>[];

    for (final mode in <AstryxColorMode>[
      AstryxColorMode.light,
      AstryxColorMode.dark,
    ]) {
      for (final theme in DocsTheme.values) {
        final ratios = await measure(tester, theme, mode);
        for (final pair in _pairs) {
          final key = '${theme.name}/${mode.name}/${pair.name}';
          if (!_knownShortfalls.containsKey(key)) continue;
          if (ratios[pair.name]! >= pair.minimum) stale.add(key);
        }
      }
    }

    expect(
      stale,
      isEmpty,
      reason:
          '\nThese now clear AA — remove them from `_knownShortfalls`:\n'
          '${stale.join('\n')}',
    );
  });
}
