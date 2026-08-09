/// A minimal HCT (hue, chroma, tone) colour space.
///
/// A faithful port of upstream's `packages/core/src/theme/hct.ts`, which is
/// itself a reduced port of Google's `material-color-utilities`. It is consumed
/// by the colour scale expander to build tonal palettes.
///
/// HCT combines:
///
///  * hue from CIELab, which is perceptually uniform,
///  * chroma approximated by CIELab C*ab, and
///  * tone from L*, where 0 is black and 100 is white.
///
/// The maths is deliberately self-contained — no colour library, no lookup
/// tables — so that the operation order matches upstream exactly. Reassociating
/// an expression here is how parity drifts.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:meta/meta.dart';

/// A colour expressed as hue, chroma and tone.
@immutable
class AstryxHct {
  /// Creates an HCT colour.
  const AstryxHct({
    required this.hue,
    required this.chroma,
    required this.tone,
  });

  /// Hue in degrees, 0–360.
  final double hue;

  /// Chroma — colourfulness. 0 is achromatic; the sRGB gamut reaches roughly
  /// 120 at its most saturated.
  final double chroma;

  /// Tone — CIE lightness, 0 (black) to 100 (white).
  final double tone;

  /// Returns a copy with the given components replaced.
  AstryxHct copyWith({double? hue, double? chroma, double? tone}) => AstryxHct(
    hue: hue ?? this.hue,
    chroma: chroma ?? this.chroma,
    tone: tone ?? this.tone,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxHct &&
          other.hue == hue &&
          other.chroma == chroma &&
          other.tone == tone;

  @override
  int get hashCode => Object.hash(hue, chroma, tone);

  @override
  String toString() => 'AstryxHct(hue: $hue, chroma: $chroma, tone: $tone)';
}

// =============================================================================
// sRGB <-> linear RGB
// =============================================================================

double _srgbToLinear(double c) {
  final s = c / 255;
  if (s <= 0.04045) return s / 12.92;
  return math.pow((s + 0.055) / 1.055, 2.4) as double;
}

double _linearToSrgb(double c) {
  final s = c <= 0.0031308 ? c * 12.92 : 1.055 * math.pow(c, 1 / 2.4) - 0.055;
  return math.min(255, math.max(0, s * 255)).roundToDouble();
}

// =============================================================================
// Linear RGB <-> XYZ (D65 illuminant)
// =============================================================================

(double, double, double) _linearRgbToXyz(double r, double g, double b) => (
  0.4124564 * r + 0.3575761 * g + 0.1804375 * b,
  0.2126729 * r + 0.7151522 * g + 0.072175 * b,
  0.0193339 * r + 0.119192 * g + 0.9503041 * b,
);

(double, double, double) _xyzToLinearRgb(double x, double y, double z) => (
  3.2404542 * x - 1.5371385 * y - 0.4985314 * z,
  -0.969266 * x + 1.8760108 * y + 0.041556 * z,
  0.0556434 * x - 0.2040259 * y + 1.0572252 * z,
);

// =============================================================================
// XYZ <-> L*a*b*
// =============================================================================

const List<double> _d65White = <double>[0.95047, 1, 1.08883];

/// The cube root of [x], to the precision of JavaScript's `Math.cbrt`.
///
/// Dart has no `cbrt`. `pow(x, 1 / 3)` is close but can be a couple of units in
/// the last place out, which is enough to flip an 8-bit rounding boundary. One
/// Newton–Raphson step on the result recovers the accuracy.
@visibleForTesting
double cbrt(double x) {
  if (x == 0 || !x.isFinite) return x;
  final negative = x < 0;
  final magnitude = negative ? -x : x;
  var r = math.pow(magnitude, 1 / 3) as double;
  r -= (r - magnitude / (r * r)) / 3;
  return negative ? -r : r;
}

double _labF(double t) {
  const delta = 6 / 29;
  return t > delta * delta * delta ? cbrt(t) : t / (3 * delta * delta) + 4 / 29;
}

double _labFInv(double t) {
  const delta = 6 / 29;
  return t > delta ? t * t * t : 3 * delta * delta * (t - 4 / 29);
}

(double, double, double) _xyzToLab(double x, double y, double z) {
  final fx = _labF(x / _d65White[0]);
  final fy = _labF(y / _d65White[1]);
  final fz = _labF(z / _d65White[2]);
  return (116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz));
}

(double, double, double) _labToXyz(double l, double a, double b) {
  final fy = (l + 16) / 116;
  final fx = a / 500 + fy;
  final fz = fy - b / 200;
  return (
    _labFInv(fx) * _d65White[0],
    _labFInv(fy) * _d65White[1],
    _labFInv(fz) * _d65White[2],
  );
}

// =============================================================================
// Tone <-> Y (CIE luminance)
// =============================================================================

double _toneToY(double tone) => _labFInv((tone + 16) / 116);

// =============================================================================
// Core: hex <-> HCT
// =============================================================================

(double, double, double) _hexToRgb(String hex) {
  final parsed = parseHex(hex);
  if (parsed == null) return (0, 0, 0);
  return (parsed.r, parsed.g, parsed.b);
}

/// Converts a hex colour to [AstryxHct].
///
/// Unparseable input is treated as black, matching upstream.
AstryxHct hexToHct(String hex) {
  final (r, g, b) = _hexToRgb(hex);
  final lr = _srgbToLinear(r);
  final lg = _srgbToLinear(g);
  final lb = _srgbToLinear(b);
  final (x, y, z) = _linearRgbToXyz(lr, lg, lb);
  final (l, a, bLab) = _xyzToLab(x, y, z);

  final hueRad = math.atan2(bLab, a);
  var hue = hueRad * 180 / math.pi;
  if (hue < 0) hue += 360;

  final chroma = math.sqrt(a * a + bLab * bLab);

  return AstryxHct(
    hue: hue,
    chroma: chroma,
    tone: math.max(0, math.min(100, l)),
  );
}

/// Converts [hct] to a `#RRGGBB` hex string, gamut-mapping into sRGB.
///
/// Chroma is reduced by binary search until the colour is representable. The
/// search runs a fixed 16 iterations, as upstream does — the iteration count is
/// part of the output, not an implementation detail.
String hctToHex(AstryxHct hct) {
  final hue = hct.hue;
  final chroma = hct.chroma;
  final tone = hct.tone;

  if (tone <= 0) return '#000000';
  if (tone >= 100) return '#FFFFFF';
  if (chroma < 0.5) {
    final gray = _toneToGray(tone);
    return formatHex(gray, gray, gray);
  }

  var lo = 0.0;
  var hi = chroma;
  var bestHex = '#000000';

  for (var i = 0; i < 16; i++) {
    final mid = (lo + hi) / 2;
    final candidate = _hctComponentToHex(hue, mid, tone);
    if (candidate != null) {
      bestHex = candidate;
      lo = mid;
    } else {
      hi = mid;
    }
  }

  return bestHex;
}

double _toneToGray(double tone) => _linearToSrgb(_toneToY(tone));

String? _hctComponentToHex(double hue, double chroma, double tone) {
  final hueRad = hue * math.pi / 180;
  final a = math.cos(hueRad) * chroma;
  final b = math.sin(hueRad) * chroma;

  final (x, y, z) = _labToXyz(tone, a, b);
  final (lr, lg, lb) = _xyzToLinearRgb(x, y, z);

  final r = _linearToSrgb(lr);
  final g = _linearToSrgb(lg);
  final bVal = _linearToSrgb(lb);

  final rLin = _srgbToLinear(r);
  final gLin = _srgbToLinear(g);
  final bLin = _srgbToLinear(bVal);

  const tolerance = 0.02;
  if ((rLin - lr).abs() > tolerance ||
      (gLin - lg).abs() > tolerance ||
      (bLin - lb).abs() > tolerance) {
    return null;
  }

  // Unreachable in practice — `_linearToSrgb` already clamps — but kept
  // because upstream keeps it, and removing it would be a silent divergence.
  if (r < 0 || r > 255 || g < 0 || g > 255 || bVal < 0 || bVal > 255) {
    return null;
  }

  return formatHex(r, g, bVal);
}

// =============================================================================
// Tonal palette
// =============================================================================

/// The tones a tonal palette is sampled at.
const List<int> astryxPaletteTones = <int>[
  0,
  5,
  10,
  20,
  30,
  40,
  50,
  60,
  70,
  80,
  90,
  95,
  99,
  100,
];

/// Builds a tonal palette: one hex colour per tone in [astryxPaletteTones], at
/// the given [hue] and [chroma].
Map<int, String> tonalPalette(double hue, double chroma) {
  final result = <int, String>{};
  for (final tone in astryxPaletteTones) {
    result[tone] = hctToHex(
      AstryxHct(hue: hue, chroma: chroma, tone: tone.toDouble()),
    );
  }
  return result;
}

// =============================================================================
// Utility: hex with alpha
// =============================================================================

/// Appends [alpha] (0–1) to a hex colour as a two-digit uppercase suffix.
String hexWithAlpha(String hex, double alpha) {
  final alphaHex = (alpha * 255)
      .round()
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();
  return '$hex$alphaHex';
}
