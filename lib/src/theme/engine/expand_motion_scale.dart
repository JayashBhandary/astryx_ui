/// Duration and easing token generation from a three-value motion budget.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/expandMotionScale.ts`.
///
/// Theme authors give `fast`, `medium` and a `ratio`; each band expands into a
/// min/base/max triple where `min = base × ratio` and `max = base ÷ ratio`. A
/// snappy theme lowers the bases, a cinematic one raises them, and the
/// proportions between variants survive either change.
library;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/utils/js_number.dart';
import 'package:meta/meta.dart';

/// Configuration for the motion scale.
///
/// {@tool snippet}
/// ```dart
/// // The default Astryx motion scale.
/// const AstryxMotionScaleConfig(
///   fast: 175,
///   medium: 410,
///   slow: 975,
///   ratio: 0.75,
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxMotionScaleConfig {
  /// Creates a motion scale configuration.
  const AstryxMotionScaleConfig({
    required this.fast,
    required this.medium,
    required this.ratio,
    this.slow,
    this.easing,
  });

  /// Base duration for micro-interactions, in milliseconds — hover, toggle,
  /// checkbox.
  final double fast;

  /// Base duration for entrance and exit animations, in milliseconds — dialog,
  /// drawer, panel.
  final double medium;

  /// Scaling ratio for the min and max variants of each band.
  ///
  /// `min = base × ratio`, `max = base ÷ ratio`. Upstream's typical range is
  /// 0.65–0.85 and its default is 0.75.
  final double ratio;

  /// Base duration for slow, continuous animations, in milliseconds — spinner,
  /// progress.
  ///
  /// The slow band is emitted only when this is non-null.
  final double? slow;

  /// An optional easing curve overriding `--ease-standard`.
  ///
  /// An empty string is ignored, matching upstream's truthiness check.
  final String? easing;

  /// Returns a copy with the given fields replaced.
  ///
  /// Passing `null` for [slow] or [easing] keeps the current value; construct a
  /// new configuration to clear them.
  AstryxMotionScaleConfig copyWith({
    double? fast,
    double? medium,
    double? ratio,
    double? slow,
    String? easing,
  }) => AstryxMotionScaleConfig(
    fast: fast ?? this.fast,
    medium: medium ?? this.medium,
    ratio: ratio ?? this.ratio,
    slow: slow ?? this.slow,
    easing: easing ?? this.easing,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxMotionScaleConfig &&
          other.fast == fast &&
          other.medium == medium &&
          other.ratio == ratio &&
          other.slow == slow &&
          other.easing == easing;

  @override
  int get hashCode => Object.hash(fast, medium, ratio, slow, easing);

  @override
  String toString() =>
      'AstryxMotionScaleConfig(fast: $fast, medium: $medium, ratio: $ratio, '
      'slow: $slow, easing: $easing)';
}

/// Rounds a duration in milliseconds to the nearest 5 ms, for clean token
/// values.
double _roundMs(double ms) => jsRound(ms / 5) * 5;

/// Expands [config] into duration and easing token overrides, keyed by CSS
/// custom property name.
///
/// The slow band is present only when [AstryxMotionScaleConfig.slow] is set,
/// and `--ease-standard` only when [AstryxMotionScaleConfig.easing] is a
/// non-empty string. Both omissions fall through to the token defaults.
Map<String, String> expandMotionScale(AstryxMotionScaleConfig config) {
  final fast = config.fast;
  final medium = config.medium;
  final slow = config.slow;
  final ratio = config.ratio;
  final easing = config.easing;

  String ms(double value) => '${formatNumber(_roundMs(value))}ms';

  final tokens = <String, String>{
    '--duration-fast-min': ms(fast * ratio),
    '--duration-fast': ms(fast),
    '--duration-fast-max': ms(fast / ratio),
    '--duration-medium-min': ms(medium * ratio),
    '--duration-medium': ms(medium),
    '--duration-medium-max': ms(medium / ratio),
  };

  if (slow != null) {
    tokens['--duration-slow-min'] = ms(slow * ratio);
    tokens['--duration-slow'] = ms(slow);
    tokens['--duration-slow-max'] = ms(slow / ratio);
  }

  if (easing != null && easing.isNotEmpty) {
    tokens['--ease-standard'] = easing;
  }

  return tokens;
}
