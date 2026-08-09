/// Typography configuration for a theme.
///
/// A port of `TypographyConfig` and `TypographyRole` from upstream's
/// `packages/core/src/theme/types.ts`.
///
/// Font *loading* is the consumer's responsibility. These types only set the
/// font-family tokens, so the font is used once it is available.
library;

import 'package:meta/meta.dart';

/// A named font weight, or a raw CSS weight as an escape hatch.
///
/// `normal`, `medium`, `semibold` and `bold` resolve to the corresponding
/// `var(--font-weight-*)` token. Anything else passes through unchanged, so
/// `'800'` is valid.
extension type const AstryxFontWeight(String value) {
  /// The regular text weight.
  static const AstryxFontWeight normal = AstryxFontWeight('normal');

  /// One step above [normal]. The default weight for labels.
  static const AstryxFontWeight medium = AstryxFontWeight('medium');

  /// The default weight for headings.
  static const AstryxFontWeight semibold = AstryxFontWeight('semibold');

  /// The heaviest named weight.
  static const AstryxFontWeight bold = AstryxFontWeight('bold');

  /// The `var()` reference for a named weight, or the raw value unchanged.
  String get css => switch (value) {
    'normal' => 'var(--font-weight-normal)',
    'medium' => 'var(--font-weight-medium)',
    'semibold' => 'var(--font-weight-semibold)',
    'bold' => 'var(--font-weight-bold)',
    _ => value,
  };
}

/// One typography role — body, heading or code.
@immutable
class AstryxTypographyRole {
  /// Creates a typography role.
  const AstryxTypographyRole({
    this.family,
    this.fallbacks,
    this.weight,
    this.weights,
  });

  /// The primary font name. The consumer is responsible for loading it.
  final String? family;

  /// The CSS fallback stack, appended after [family] in the computed token.
  final String? fallbacks;

  /// The default font weight for this role.
  final AstryxFontWeight? weight;

  /// Per-level weight overrides. Heading only; keys are levels 1–6.
  final Map<int, AstryxFontWeight>? weights;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTypographyRole &&
          other.family == family &&
          other.fallbacks == fallbacks &&
          other.weight == weight &&
          _mapEquals(other.weights, weights);

  @override
  int get hashCode {
    final weightsHash = weights == null
        ? null
        : Object.hashAllUnordered(weights!.entries.map(_pair));
    return Object.hash(family, fallbacks, weight, weightsHash);
  }

  @override
  String toString() =>
      'AstryxTypographyRole(family: $family, fallbacks: $fallbacks, '
      'weight: $weight, weights: $weights)';
}

/// The type scale portion of a typography configuration: base size and ratio.
@immutable
class AstryxTypeScaleSpec {
  /// Creates a type scale specification.
  const AstryxTypeScaleSpec({required this.base, required this.ratio});

  /// The base font size in logical pixels.
  final double base;

  /// The geometric progression ratio.
  final double ratio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTypeScaleSpec &&
          other.base == base &&
          other.ratio == ratio;

  @override
  int get hashCode => Object.hash(base, ratio);

  @override
  String toString() => 'AstryxTypeScaleSpec(base: $base, ratio: $ratio)';
}

/// A theme's typography configuration.
///
/// [scale] drives the geometric size scale; [body], [heading] and [code]
/// declare fonts, fallbacks and weights per role. [heading] inherits its family
/// and fallbacks from [body] when it does not name its own.
///
/// {@tool snippet}
/// ```dart
/// const AstryxTypographyConfig(
///   scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
///   body: AstryxTypographyRole(
///     family: 'Geist',
///     fallbacks: '-apple-system, sans-serif',
///   ),
///   heading: AstryxTypographyRole(weight: AstryxFontWeight.semibold),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxTypographyConfig {
  /// Creates a typography configuration.
  const AstryxTypographyConfig({
    this.scale,
    this.body,
    this.heading,
    this.code,
  });

  /// The type scale. When null, no typography tokens are generated.
  final AstryxTypeScaleSpec? scale;

  /// Body text configuration.
  final AstryxTypographyRole? body;

  /// Heading configuration. Inherits family and fallbacks from [body].
  final AstryxTypographyRole? heading;

  /// Code and monospace configuration.
  final AstryxTypographyRole? code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTypographyConfig &&
          other.scale == scale &&
          other.body == body &&
          other.heading == heading &&
          other.code == code;

  @override
  int get hashCode => Object.hash(scale, body, heading, code);

  @override
  String toString() =>
      'AstryxTypographyConfig(scale: $scale, body: $body, heading: $heading, '
      'code: $code)';
}

Object _pair(MapEntry<int, AstryxFontWeight> e) => Object.hash(e.key, e.value);

bool _mapEquals(
  Map<int, AstryxFontWeight>? a,
  Map<int, AstryxFontWeight>? b,
) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}
