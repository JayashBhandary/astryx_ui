import 'dart:math' as math;

import 'package:meta/meta.dart';

/// A colour decomposed into 0–255 RGB channels and a 0–1 alpha.
///
/// Port of upstream's `RGBA` interface
/// (`packages/core/src/utils/color.ts`). Channels are [double] rather than
/// [int] because `rgb()` percentage channels and `color-mix()` both produce
/// fractional values, and rounding them early loses enough precision to fail
/// the parity tests.
@immutable
class AstryxRgba {
  /// Creates a colour from 0–255 channels and a 0–1 alpha.
  const AstryxRgba({
    required this.r,
    required this.g,
    required this.b,
    this.a = 1,
  });

  /// Fully transparent black — CSS `transparent`.
  static const AstryxRgba transparent = AstryxRgba(r: 0, g: 0, b: 0, a: 0);

  /// Opaque black — CSS `black`.
  static const AstryxRgba black = AstryxRgba(r: 0, g: 0, b: 0);

  /// Opaque white — CSS `white`.
  static const AstryxRgba white = AstryxRgba(r: 255, g: 255, b: 255);

  /// Red channel, 0–255.
  final double r;

  /// Green channel, 0–255.
  final double g;

  /// Blue channel, 0–255.
  final double b;

  /// Alpha, 0–1.
  final double a;

  /// Returns a copy with the given channels replaced.
  AstryxRgba copyWith({double? r, double? g, double? b, double? a}) =>
      AstryxRgba(
        r: r ?? this.r,
        g: g ?? this.g,
        b: b ?? this.b,
        a: a ?? this.a,
      );

  /// Whether every channel of [other] is within [epsilon] of this colour's.
  ///
  /// Comparing parsed colours exactly is brittle — `color-mix` and OKLCH both
  /// arrive through floating-point arithmetic. Tests should use this.
  bool isCloseTo(AstryxRgba other, {double epsilon = 1e-6}) =>
      (r - other.r).abs() <= epsilon &&
      (g - other.g).abs() <= epsilon &&
      (b - other.b).abs() <= epsilon &&
      (a - other.a).abs() <= epsilon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxRgba &&
          other.r == r &&
          other.g == g &&
          other.b == b &&
          other.a == a;

  @override
  int get hashCode => Object.hash(r, g, b, a);

  @override
  String toString() => 'AstryxRgba(r: $r, g: $g, b: $b, a: $a)';
}

/// Clamps [value] to the inclusive range [min]–[max].
///
/// Matches upstream's `clamp` helper, including its behaviour on `NaN`:
/// `math.max` propagates `NaN`, so an unparseable channel stays detectable
/// rather than silently becoming a bound.
double clampDouble(double value, double min, double max) =>
    math.max(min, math.min(max, value));
