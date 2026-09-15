import 'dart:math' as math;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The contrast contract of the `transit` theme.
///
/// The seven generated themes are transcriptions and are pinned to upstream's
/// values, defects included — `stone` sets `--color-on-error` equal to
/// `--color-error`, and a test elsewhere pins that 1.00:1 rather than fixing
/// it. `transit` is hand-authored here, so it is held to the ratio instead:
/// every pair below was solved for a floor, and this is the file that says so.
///
/// The floors are WCAG 2.1 AA: 4.5:1 for text (1.4.3) and 3:1 for the boundary
/// of a control (1.4.11).
void main() {
  double luminance(Color c) {
    double channel(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4) as double;

    return 0.2126 * channel(c.r) +
        0.7152 * channel(c.g) +
        0.0722 * channel(c.b);
  }

  /// The contrast ratio of [fg] over [bg], compositing [fg]'s alpha first.
  ///
  /// A token with alpha — `--color-neutral`, `--color-border` in dark — has no
  /// ratio of its own. It has one once it is painted, and this is what it is
  /// painted on.
  double ratio(Color fg, Color bg) {
    final composited = Color.from(
      alpha: 1,
      red: fg.r * fg.a + bg.r * (1 - fg.a),
      green: fg.g * fg.a + bg.g * (1 - fg.a),
      blue: fg.b * fg.a + bg.b * (1 - fg.a),
    );

    final a = luminance(composited);
    final b = luminance(bg);

    return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
  }

  final modes = <AstryxThemeMode, AstryxThemeData>{
    for (final mode in AstryxThemeMode.values)
      mode: AstryxThemeData.resolve(
        mode: mode,
        theme: transitTheme,
        platform: TargetPlatform.macOS,
      ),
  };

  /// Every surface a component can be painted on, worst included.
  const surfaces = <AstryxColorToken>[
    AstryxColorToken.backgroundBody,
    AstryxColorToken.backgroundSurface,
    AstryxColorToken.backgroundCard,
    AstryxColorToken.backgroundPopover,
    AstryxColorToken.backgroundMuted,
  ];

  void expectRatio(
    AstryxThemeData data,
    AstryxThemeMode mode,
    AstryxColorToken fg,
    AstryxColorToken bg,
    double floor,
  ) {
    final value = ratio(data.color(fg), data.color(bg));

    expect(
      value,
      greaterThanOrEqualTo(floor),
      reason:
          '${mode.name}: ${fg.cssName} on ${bg.cssName} is '
          '${value.toStringAsFixed(2)}:1, below $floor:1',
    );
  }

  group('text clears 4.5:1 on every surface it can land on', () {
    for (final entry in modes.entries) {
      test(entry.key.name, () {
        for (final surface in surfaces) {
          for (final text in <AstryxColorToken>[
            AstryxColorToken.textPrimary,
            AstryxColorToken.textSecondary,
            AstryxColorToken.iconPrimary,
            AstryxColorToken.iconSecondary,
          ]) {
            expectRatio(entry.value, entry.key, text, surface, 4.5);
          }
        }
      });
    }
  });

  group('a control boundary clears 3:1 on every surface', () {
    for (final entry in modes.entries) {
      test(entry.key.name, () {
        for (final surface in surfaces) {
          expectRatio(
            entry.value,
            entry.key,
            AstryxColorToken.borderEmphasized,
            surface,
            3,
          );
        }
      });
    }
  });

  group('a filled control clears 4.5:1 against its own foreground', () {
    // The pairing `stone` gets wrong: a badge, a stepper indicator and a
    // solid button all paint `--color-on-x` on `--color-x`.
    const pairs = <(AstryxColorToken, AstryxColorToken)>[
      (AstryxColorToken.onAccent, AstryxColorToken.accent),
      (AstryxColorToken.onSuccess, AstryxColorToken.success),
      (AstryxColorToken.onError, AstryxColorToken.error),
      (AstryxColorToken.onWarning, AstryxColorToken.warning),
    ];

    for (final entry in modes.entries) {
      test(entry.key.name, () {
        for (final (fg, bg) in pairs) {
          expectRatio(entry.value, entry.key, fg, bg, 4.5);
        }
      });
    }
  });

  group('a status reads as text on the page', () {
    for (final entry in modes.entries) {
      test(entry.key.name, () {
        for (final status in <AstryxColorToken>[
          AstryxColorToken.success,
          AstryxColorToken.error,
          AstryxColorToken.warning,
          AstryxColorToken.textAccent,
        ]) {
          for (final surface in <AstryxColorToken>[
            AstryxColorToken.backgroundBody,
            AstryxColorToken.backgroundCard,
          ]) {
            expectRatio(entry.value, entry.key, status, surface, 4.5);
          }
        }
      });
    }
  });

  group('every categorical family is legible on its own fill', () {
    // The ten palettes are what a route badge is painted from, so each
    // family's text and icon must clear 4.5:1 on that family's background.
    const families = <(AstryxColorToken, AstryxColorToken, AstryxColorToken)>[
      (
        AstryxColorToken.textBlue,
        AstryxColorToken.iconBlue,
        AstryxColorToken.backgroundBlue,
      ),
      (
        AstryxColorToken.textCyan,
        AstryxColorToken.iconCyan,
        AstryxColorToken.backgroundCyan,
      ),
      (
        AstryxColorToken.textGray,
        AstryxColorToken.iconGray,
        AstryxColorToken.backgroundGray,
      ),
      (
        AstryxColorToken.textGreen,
        AstryxColorToken.iconGreen,
        AstryxColorToken.backgroundGreen,
      ),
      (
        AstryxColorToken.textOrange,
        AstryxColorToken.iconOrange,
        AstryxColorToken.backgroundOrange,
      ),
      (
        AstryxColorToken.textPink,
        AstryxColorToken.iconPink,
        AstryxColorToken.backgroundPink,
      ),
      (
        AstryxColorToken.textPurple,
        AstryxColorToken.iconPurple,
        AstryxColorToken.backgroundPurple,
      ),
      (
        AstryxColorToken.textRed,
        AstryxColorToken.iconRed,
        AstryxColorToken.backgroundRed,
      ),
      (
        AstryxColorToken.textTeal,
        AstryxColorToken.iconTeal,
        AstryxColorToken.backgroundTeal,
      ),
      (
        AstryxColorToken.textYellow,
        AstryxColorToken.iconYellow,
        AstryxColorToken.backgroundYellow,
      ),
    ];

    for (final entry in modes.entries) {
      test(entry.key.name, () {
        for (final (text, icon, background) in families) {
          expectRatio(entry.value, entry.key, text, background, 4.5);
          expectRatio(entry.value, entry.key, icon, background, 4.5);
        }
      });
    }
  });
}
