/// OKLCH parsing and conversion to sRGB.
///
/// Astryx's colour *resolver* never sees `oklch()` — upstream's `parseColor`
/// returns `null` for it and `contrastRatio` throws on it. It appears only
/// inside compound shadow values, in the achromatic forms `oklch(0 0 0 / N%)`
/// and `oklch(1 0 0 / N%)`, which Phase 3 has to parse to build `BoxShadow`s.
///
/// The general conversion is implemented anyway: it is not much more work than
/// the achromatic special case, and a partial implementation would be a trap
/// the first time a theme uses a chromatic OKLCH value.
///
/// Pipeline: OKLCH → OKLab → linear sRGB → gamma-encoded sRGB, per the CSS
/// Color 4 specification. Out-of-gamut results are clipped per channel, which
/// is what browsers do for the simple case and is exact for the achromatic
/// values actually in use.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';

final RegExp _oklchPrefix = RegExp(r'^oklch\(', caseSensitive: false);

/// Parses an `oklch()` colour into [AstryxRgba].
///
/// Accepts `oklch(L C H)` and `oklch(L C H / A)`. Lightness may be a number in
/// 0–1 or a percentage; chroma a number or a percentage of `0.4`; hue a number
/// in degrees; alpha a number in 0–1 or a percentage.
///
/// Returns `null` if the value is not an `oklch()` expression or has too few
/// components.
AstryxRgba? parseOklch(String value) {
  final trimmed = value.trim();
  if (!_oklchPrefix.hasMatch(trimmed) || !trimmed.endsWith(')')) return null;

  final body = trimmed
      .substring(trimmed.indexOf('(') + 1, trimmed.lastIndexOf(')'))
      .replaceAll('/', ' ');
  final parts = body
      .split(RegExp(r'[\s,]+'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.length < 3) return null;

  final l = parts[0].endsWith('%')
      ? parseFloatLoose(parts[0]) / 100
      : parseFloatLoose(parts[0]);
  // A percentage chroma is relative to 0.4, per CSS Color 4.
  final c = parts[1].endsWith('%')
      ? (parseFloatLoose(parts[1]) / 100) * 0.4
      : parseFloatLoose(parts[1]);
  final h = parseFloatLoose(parts[2]);
  if (l.isNaN || c.isNaN || h.isNaN) return null;

  var a = 1.0;
  if (parts.length >= 4) {
    a = parts[3].endsWith('%')
        ? parseFloatLoose(parts[3]) / 100
        : parseFloatLoose(parts[3]);
    if (a.isNaN) return null;
    a = clampDouble(a, 0, 1);
  }

  return oklchToRgba(l: l, c: c, h: h, a: a);
}

/// Converts OKLCH to sRGB.
///
/// [l] is lightness in 0–1, [c] chroma, [h] hue in degrees, [a] alpha in 0–1.
/// Channels are clipped to 0–255; out-of-gamut colours are clamped rather than
/// gamut-mapped.
AstryxRgba oklchToRgba({
  required double l,
  required double c,
  required double h,
  double a = 1,
}) {
  final hRad = h * math.pi / 180;
  return oklabToRgba(
    l: l,
    aLab: c * math.cos(hRad),
    bLab: c * math.sin(hRad),
    alpha: a,
  );
}

/// Converts OKLab to sRGB.
AstryxRgba oklabToRgba({
  required double l,
  required double aLab,
  required double bLab,
  double alpha = 1,
}) {
  // OKLab -> LMS (cube roots)
  final lCbrt = l + 0.3963377774 * aLab + 0.2158037573 * bLab;
  final mCbrt = l - 0.1055613458 * aLab - 0.0638541728 * bLab;
  final sCbrt = l - 0.0894841775 * aLab - 1.2914855480 * bLab;

  final lms = lCbrt * lCbrt * lCbrt;
  final mms = mCbrt * mCbrt * mCbrt;
  final sms = sCbrt * sCbrt * sCbrt;

  // LMS -> linear sRGB
  final rLinear = 4.0767416621 * lms - 3.3077115913 * mms + 0.2309699292 * sms;
  final gLinear = -1.2684380046 * lms + 2.6097574011 * mms - 0.3413193965 * sms;
  final bLinear = -0.0041960863 * lms - 0.7034186147 * mms + 1.7076147010 * sms;

  return AstryxRgba(
    r: clampDouble(_gammaEncode(rLinear) * 255, 0, 255),
    g: clampDouble(_gammaEncode(gLinear) * 255, 0, 255),
    b: clampDouble(_gammaEncode(bLinear) * 255, 0, 255),
    a: alpha,
  );
}

/// Linear sRGB to gamma-encoded sRGB, per the sRGB transfer function.
double _gammaEncode(double channel) {
  final sign = channel < 0 ? -1.0 : 1.0;
  final abs = channel.abs();
  if (abs <= 0.0031308) return sign * abs * 12.92;
  return sign * (1.055 * math.pow(abs, 1 / 2.4) - 0.055);
}
