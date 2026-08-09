/// Border-radius token generation from a base unit and a multiplier.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/expandRadiusScale.ts`, consumed by
/// [defineTheme](../engine/define_theme.dart).
///
/// `--radius-none` and `--radius-full` are fixed anchors and never scale.
/// Everything from `--radius-inner` to `--radius-page` is
/// `base × step × multiplier`, rounded to whole pixels:
///
/// | Token | Step |
/// | --- | --- |
/// | `--radius-inner` | 1 — internal corners |
/// | `--radius-element` | 2 — buttons, inputs |
/// | `--radius-container` | 3 — cards, panels |
/// | `--radius-page` | 7 — page-level containers |
/// | `--radius-chat` | 7 — chat surfaces; tracks page |
library;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/utils/js_number.dart';
import 'package:meta/meta.dart';

/// Configuration for the radius scale.
///
/// {@tool snippet}
/// ```dart
/// // The default Astryx radius scale.
/// const AstryxRadiusScaleConfig(base: 4, multiplier: 1);
///
/// // Sharp and brutalist — every scalable radius becomes 0.
/// const AstryxRadiusScaleConfig(base: 4, multiplier: 0);
/// ```
/// {@end-tool}
@immutable
class AstryxRadiusScaleConfig {
  /// Creates a radius scale configuration.
  const AstryxRadiusScaleConfig({required this.base, required this.multiplier});

  /// The base radius unit, in logical pixels. Upstream's default is 4.
  final double base;

  /// The multiplier applied to the scalable tokens, `--radius-inner` through
  /// `--radius-page`.
  ///
  /// Upstream's default is 1 and its documented range is 0–2. A multiplier of
  /// 0 is supported and means fully square corners.
  final double multiplier;

  /// Returns a copy with the given fields replaced.
  AstryxRadiusScaleConfig copyWith({double? base, double? multiplier}) =>
      AstryxRadiusScaleConfig(
        base: base ?? this.base,
        multiplier: multiplier ?? this.multiplier,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxRadiusScaleConfig &&
          other.base == base &&
          other.multiplier == multiplier;

  @override
  int get hashCode => Object.hash(base, multiplier);

  @override
  String toString() =>
      'AstryxRadiusScaleConfig(base: $base, multiplier: $multiplier)';
}

/// Expands [config] into radius token overrides, keyed by CSS custom property
/// name.
///
/// {@tool snippet}
/// ```dart
/// final tokens = expandRadiusScale(
///   const AstryxRadiusScaleConfig(base: 4, multiplier: 1),
/// );
/// // tokens['--radius-element'] == '8px'
/// // tokens['--radius-full'] == '9999px'
/// ```
/// {@end-tool}
Map<String, String> expandRadiusScale(AstryxRadiusScaleConfig config) {
  final base = config.base;
  final multiplier = config.multiplier;

  String px(double step) =>
      '${formatNumber(jsRound(base * step * multiplier))}px';

  return <String, String>{
    '--radius-none': '0px',
    '--radius-inner': px(1),
    '--radius-element': px(2),
    '--radius-container': px(3),
    '--radius-page': px(7),
    // Chat surfaces track the page step so they scale with the theme
    // multiplier, but stay a distinct token for independent theming.
    '--radius-chat': px(7),
    '--radius-full': '9999px',
  };
}
