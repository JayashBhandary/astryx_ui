/// WCAG 2.x relative luminance and contrast ratios.
///
/// A faithful port of upstream's `packages/core/src/theme/contrast.ts`. It
/// backs the contrast guarantees the colour scale expander makes for generated
/// tokens — WCAG 1.4.3 text contrast at 4.5:1, WCAG 1.4.11 non-text contrast at
/// 3:1.
///
/// Semi-transparent foregrounds are composited over their backdrop in
/// gamma-encoded sRGB, matching CSS alpha compositing, before the ratio is
/// measured. A translucent token has no contrast of its own — only against what
/// it renders on.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';

/// The WCAG 2.x relative luminance of an sRGB colour, ignoring alpha.
///
/// 0 is black, 1 is white. See
/// <https://www.w3.org/WAI/WCAG22/Techniques/general/G18>.
double relativeLuminance(AstryxRgba color) {
  double channel(double c) {
    final s = c / 255;
    if (s <= 0.04045) return s / 12.92;
    return math.pow((s + 0.055) / 1.055, 2.4) as double;
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// Composites a possibly translucent [foreground] over an opaque [backdrop].
///
/// Standard source-over blending in gamma-encoded sRGB, matching how CSS paints
/// translucent tokens. The result is always opaque.
AstryxRgba compositeOver(AstryxRgba foreground, AstryxRgba backdrop) {
  final a = foreground.a;
  return AstryxRgba(
    r: foreground.r * a + backdrop.r * (1 - a),
    g: foreground.g * a + backdrop.g * (1 - a),
    b: foreground.b * a + backdrop.b * (1 - a),
  );
}

AstryxRgba _resolve(Object value, String label) {
  if (value is AstryxRgba) return value;
  final parsed = parseColor(value as String);
  if (parsed == null) {
    throw ArgumentError('contrastRatio: could not parse $label "$value"');
  }
  return parsed;
}

/// The WCAG 2.x contrast ratio between a foreground and an opaque background,
/// in the range 1–21.
///
/// [foreground] and [background] are each an [AstryxRgba] or a CSS colour
/// string that [parseColor] understands.
///
/// A translucent foreground is composited over the background first. A
/// translucent background is rejected — composite it over its own backdrop
/// before calling, because its rendered colour is unknowable here.
///
/// Throws an [ArgumentError] if either colour cannot be parsed, or if the
/// background is translucent. Upstream throws a `TypeError`; Dart's `TypeError`
/// carries no message, so the nearest idiomatic equivalent is used and the
/// message text is preserved verbatim.
///
/// {@tool snippet}
/// ```dart
/// contrastRatio('#000000', '#FFFFFF'); // 21
/// ```
/// {@end-tool}
double contrastRatio(Object foreground, Object background) {
  final bg = _resolve(background, 'background');
  if (bg.a < 1) {
    throw ArgumentError(
      'contrastRatio: background must be opaque — composite it over its '
      'backdrop first',
    );
  }
  var fg = _resolve(foreground, 'foreground');
  if (fg.a < 1) {
    fg = compositeOver(fg, bg);
  }
  final lumA = relativeLuminance(fg);
  final lumB = relativeLuminance(bg);
  final lighter = math.max(lumA, lumB);
  final darker = math.min(lumA, lumB);
  return (lighter + 0.05) / (darker + 0.05);
}
