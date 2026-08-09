/// Typography token generation from a base size and a scaling ratio.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/expandTypeScale.ts`.
///
/// Sizes follow a geometric progression, `size = base × ratio^step`, in two
/// layers:
///
///  * **Layer 1** — the raw size tokens, `--font-size-4xs` through
///    `--font-size-5xl`, in `rem`.
///  * **Layer 2** — the semantic tokens, `--text-heading-N-*` and
///    `--text-TYPE-*`. Sizes are `var()` references into Layer 1, weights are
///    `var()` references to the font-weight tokens, and line heights are
///    computed ratios baked in as literals.
///
/// The named leading tokens, `--leading-tight` through `--leading-relaxed`, are
/// *not* touched by the type scale. They stay intent-based ratios for
/// components to use.
///
/// ## Line heights
///
/// The target ratio is tiered by font size — 1.5 below 20px, 1.4 from 20 to
/// 31px, 1.25 at 32px and above — then snapped so the computed pixel value
/// lands on a 4px grid, with a floor of `fontSize + 4`. The snapping is why the
/// emitted ratios look irrational: 1.4286, 1.4118.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/utils/js_number.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Per-level and per-type font weight overrides for a type scale.
@immutable
class AstryxTypeScaleWeights {
  /// Creates a set of weight overrides.
  const AstryxTypeScaleWeights({this.heading, this.text});

  /// Overrides keyed by heading level, 1–6. Unset levels use the defaults.
  ///
  /// Values are CSS font-weight strings, typically a `var()` reference such as
  /// `var(--font-weight-bold)`.
  final Map<int, String>? heading;

  /// Overrides keyed by text type — `body`, `large`, `label`, `code`,
  /// `supporting`, `display-1`, `display-2`, `display-3`. Unset types use the
  /// defaults.
  ///
  /// A key that is not one of those eight is merged but never emitted, because
  /// only those types have a step in the scale. This matches upstream.
  final Map<String, String>? text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTypeScaleWeights &&
          const DeepCollectionEquality().equals(other.heading, heading) &&
          const DeepCollectionEquality().equals(other.text, text);

  @override
  int get hashCode => Object.hash(
    const DeepCollectionEquality().hash(heading),
    const DeepCollectionEquality().hash(text),
  );

  @override
  String toString() => 'AstryxTypeScaleWeights(heading: $heading, text: $text)';
}

/// Configuration for the type scale.
///
/// {@tool snippet}
/// ```dart
/// // The default Astryx type scale.
/// const AstryxTypeScaleConfig(base: 14, ratio: 1.2);
///
/// // Upstream's suggested starting points:
/// //   dense or functional  base 12, ratio 1.125
/// //   default              base 14, ratio 1.2
/// //   airy or editorial    base 16, ratio 1.25
/// ```
/// {@end-tool}
@immutable
class AstryxTypeScaleConfig {
  /// Creates a type scale configuration.
  const AstryxTypeScaleConfig({
    required this.base,
    required this.ratio,
    this.weights,
  });

  /// The base font size in logical pixels, anchored to h4 and body text.
  final double base;

  /// The scaling ratio of the geometric progression.
  final double ratio;

  /// Optional weight overrides for headings and text types.
  final AstryxTypeScaleWeights? weights;

  /// Returns a copy with the given fields replaced.
  AstryxTypeScaleConfig copyWith({
    double? base,
    double? ratio,
    AstryxTypeScaleWeights? weights,
  }) => AstryxTypeScaleConfig(
    base: base ?? this.base,
    ratio: ratio ?? this.ratio,
    weights: weights ?? this.weights,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTypeScaleConfig &&
          other.base == base &&
          other.ratio == ratio &&
          other.weights == weights;

  @override
  int get hashCode => Object.hash(base, ratio, weights);

  @override
  String toString() =>
      'AstryxTypeScaleConfig(base: $base, ratio: $ratio, weights: $weights)';
}

/// Step offset to raw size token name.
///
/// Step 0 is the anchor, `--font-size-base`. Negative steps run down into the
/// sub-scale; positive steps up through the display sizes.
const Map<int, String> astryxStepToSizeToken = <int, String>{
  -5: '--font-size-4xs',
  -4: '--font-size-3xs',
  -3: '--font-size-2xs',
  -2: '--font-size-xs',
  -1: '--font-size-sm',
  0: '--font-size-base',
  1: '--font-size-lg',
  2: '--font-size-xl',
  3: '--font-size-2xl',
  4: '--font-size-3xl',
  5: '--font-size-4xl',
  6: '--font-size-5xl',
};

/// Heading level to step offset from the base. h4 sits at the anchor.
const Map<int, int> astryxHeadingSteps = <int, int>{
  1: 3,
  2: 2,
  3: 1,
  4: 0,
  5: -1,
  6: -2,
};

/// Text type to step offset from the base.
///
/// `body`, `label` and `code` sit at the anchor; `large` is one step up and
/// `supporting` one step down. The display types continue the progression
/// above h1.
const Map<String, int> astryxTextSteps = <String, int>{
  'body': 0,
  'large': 1,
  'label': 0,
  'code': 0,
  'supporting': -1,
  'display-1': 6,
  'display-2': 5,
  'display-3': 4,
};

const Map<int, String> _defaultHeadingWeights = <int, String>{
  1: 'var(--font-weight-semibold)',
  2: 'var(--font-weight-semibold)',
  3: 'var(--font-weight-semibold)',
  4: 'var(--font-weight-semibold)',
  5: 'var(--font-weight-semibold)',
  6: 'var(--font-weight-semibold)',
};

const Map<String, String> _defaultTextWeights = <String, String>{
  'body': 'var(--font-weight-normal)',
  'large': 'var(--font-weight-semibold)',
  'label': 'var(--font-weight-medium)',
  'code': 'var(--font-weight-normal)',
  'supporting': 'var(--font-weight-normal)',
  'display-1': 'var(--font-weight-normal)',
  'display-2': 'var(--font-weight-normal)',
  'display-3': 'var(--font-weight-normal)',
};

const Map<String, String> _textFontFamilies = <String, String>{
  'body': 'var(--font-family-body)',
  'large': 'var(--font-family-body)',
  'label': 'var(--font-family-body)',
  'code': 'var(--font-family-code)',
  'supporting': 'var(--font-family-body)',
  'display-1': 'var(--font-family-heading)',
  'display-2': 'var(--font-family-heading)',
  'display-3': 'var(--font-family-heading)',
};

/// A font size from the geometric progression, rounded to whole pixels.
double _computeSize(double base, double ratio, int step) =>
    jsRound(base * math.pow(ratio, step).toDouble());

/// Converts pixels to `rem`, against the standard 16px root font size.
String _pxToRem(double px) {
  final rem = jsRound(px / 16 * 10000) / 10000;
  return '${formatNumber(rem)}rem';
}

/// The tiered target line-height ratio for a font size.
double _targetLeadingRatio(double fontSize) {
  if (fontSize < 20) return 1.5;
  if (fontSize < 32) return 1.4;
  return 1.25;
}

/// A unitless line-height ratio, snapped so the computed pixel value lands on
/// a 4px grid, with a minimum gap of `fontSize + 4`.
double _computeLeading(double fontSize) {
  final target = _targetLeadingRatio(fontSize);
  final rawLh = fontSize * target;
  final snappedLh = math.max(
    jsRound(rawLh / 4) * 4,
    ((fontSize + 4) / 4).ceilToDouble() * 4,
  );
  return jsRound(snappedLh / fontSize * 10000) / 10000;
}

/// Expands [config] into typography token overrides, keyed by CSS custom
/// property name.
///
/// {@tool snippet}
/// ```dart
/// final tokens = expandTypeScale(
///   const AstryxTypeScaleConfig(base: 14, ratio: 1.2),
/// );
/// // tokens['--font-size-base'] == '0.875rem'
/// // tokens['--text-heading-1-size'] == 'var(--font-size-2xl)'
/// // tokens['--text-body-leading'] == '1.4286'
/// ```
/// {@end-tool}
Map<String, String> expandTypeScale(AstryxTypeScaleConfig config) {
  final base = config.base;
  final ratio = config.ratio;
  final tokens = <String, String>{};

  final headingWeights = <int, String>{
    ..._defaultHeadingWeights,
    ...?config.weights?.heading,
  };
  final textWeights = <String, String>{
    ..._defaultTextWeights,
    ...?config.weights?.text,
  };

  // Layer 1 — the raw size tokens, in rem.
  for (var step = -5; step <= 6; step++) {
    tokens[astryxStepToSizeToken[step]!] = _pxToRem(
      _computeSize(base, ratio, step),
    );
  }

  // Layer 2 — the semantic tokens. Sizes reference Layer 1, line heights are
  // baked in, weights reference the font-weight tokens.
  for (final entry in astryxHeadingSteps.entries) {
    final level = entry.key;
    final step = entry.value;
    final leading = _computeLeading(_computeSize(base, ratio, step));

    tokens['--text-heading-$level-size'] =
        'var(${astryxStepToSizeToken[step]})';
    tokens['--text-heading-$level-weight'] = headingWeights[level]!;
    tokens['--text-heading-$level-leading'] = formatNumber(leading);
  }

  for (final entry in astryxTextSteps.entries) {
    final type = entry.key;
    final step = entry.value;
    final leading = _computeLeading(_computeSize(base, ratio, step));

    tokens['--text-$type-size'] = 'var(${astryxStepToSizeToken[step]})';
    tokens['--text-$type-weight'] = textWeights[type]!;
    tokens['--text-$type-leading'] = formatNumber(leading);
  }

  return tokens;
}

/// Builds the component style overrides that pair with a type scale.
///
/// The result is keyed component name to selector to CSS property map, matching
/// the shape `defineTheme` merges into its component styles. The type scale
/// configuration does not affect the output — the rules are all `var()`
/// references, so they hold for any scale — but it is taken as a parameter to
/// mirror upstream's signature and leave room for scale-dependent rules.
Map<String, Map<String, Map<String, String>>> generateTypeScaleComponents(
  AstryxTypeScaleConfig config,
) {
  final headingRules = <String, Map<String, String>>{};
  for (final level in const <int>[1, 2, 3, 4, 5, 6]) {
    headingRules['level:$level'] = <String, String>{
      'fontFamily': 'var(--font-family-heading)',
      'fontSize': 'var(--text-heading-$level-size)',
      'fontWeight': 'var(--text-heading-$level-weight)',
      'lineHeight': 'var(--text-heading-$level-leading)',
    };
  }

  final textRules = <String, Map<String, String>>{};
  for (final type in astryxTextSteps.keys) {
    textRules['type:$type'] = <String, String>{
      'fontFamily': _textFontFamilies[type]!,
      'fontSize': 'var(--text-$type-size)',
      'lineHeight': 'var(--text-$type-leading)',
    };
  }

  return <String, Map<String, Map<String, String>>>{
    'heading': headingRules,
    'text': textRules,
  };
}
