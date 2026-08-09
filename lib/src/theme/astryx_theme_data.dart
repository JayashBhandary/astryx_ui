/// The resolved theme, in Flutter values.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/components/divider.dart';
import 'package:astryx_ui/src/theme/components/icon.dart';
import 'package:astryx_ui/src/theme/components/text.dart';
import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/font_stack.dart';
import 'package:astryx_ui/src/theme/resolved_token_set.dart';
import 'package:astryx_ui/src/theme/token_conversions.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Every Astryx token for one colour mode, as a Flutter value.
///
/// This is the only place in the package where a token string becomes a
/// [Color], a [double], a [TextStyle], a [Duration] or a [Curve]. Nothing above
/// Layer 2 parses CSS.
///
/// Conversion is eager: an instance is built once per theme and mode, and every
/// lookup afterwards is a map read. A theme changes far less often than it is
/// read, and doing the work up front means a malformed token surfaces when the
/// theme is built rather than the first time some rare widget paints.
///
/// {@tool snippet}
/// ```dart
/// final theme = AstryxThemeData.resolve(
///   theme: myTheme,
///   mode: AstryxThemeMode.light,
/// );
///
/// theme.color(AstryxColorToken.accent);        // Color(0xFF0064E0)
/// theme.spacing(AstryxSpacingToken.spacing4);  // 16.0
/// theme.textStyle(AstryxTypeRole.body);        // TextStyle(fontSize: 14, …)
/// ```
/// {@end-tool}
@immutable
class AstryxThemeData {
  /// Builds theme data from an already-resolved token set.
  factory AstryxThemeData({
    required AstryxResolvedTokenSet tokens,
    required AstryxThemeMode mode,
    TargetPlatform? platform,
    AstryxTextTheme text = const AstryxTextTheme(),
    AstryxTextTheme heading = const AstryxTextTheme(),
    AstryxDividerTheme divider = const AstryxDividerTheme(),
    AstryxIconTheme icon = const AstryxIconTheme(),
    AstryxButtonTheme button = const AstryxButtonTheme(),
  }) {
    final target = platform ?? defaultTargetPlatform;
    final values = tokens.forMode(mode);

    String? raw(String name) => values[name];

    final colors = <String, Color>{};
    final lengths = <String, double>{};
    final shadows = <String, List<AstryxShadow>>{};
    final durations = <String, Duration>{};
    final curves = <String, Curve>{};
    final weights = <String, FontWeight>{};
    final families = <String, AstryxFontStack>{};

    // Conversion is driven by the token enums rather than by name prefixes.
    // Prefixes look tidier and are wrong: `--text-heading-1-weight` is a font
    // weight but does not start with `--font-weight-`, and would land in the
    // lengths map as the number 600.
    void convert<T>(
      Iterable<AstryxToken> group,
      Map<String, T> into,
      T? Function(String value) parse,
    ) {
      for (final token in group) {
        final value = raw(token.cssName);
        if (value == null) continue;
        final converted = parse(value);
        if (converted != null) into[token.cssName] = converted;
      }
    }

    convert(AstryxColorToken.values, colors, (v) => parseCssColor(v, mode));
    convert(AstryxSpacingToken.values, lengths, parseCssLength);
    convert(AstryxSizeToken.values, lengths, parseCssLength);
    convert(AstryxRadiusToken.values, lengths, parseCssLength);
    convert(AstryxBorderToken.values, lengths, parseCssLength);
    convert(AstryxTextSizeToken.values, lengths, parseCssLength);
    convert(AstryxShadowToken.values, shadows, (v) => parseCssShadows(v, mode));
    convert(AstryxDurationToken.values, durations, parseCssDuration);
    convert(AstryxEaseToken.values, curves, parseCssCurve);
    convert(AstryxFontWeightToken.values, weights, parseCssFontWeight);
    convert(
      AstryxTypographyToken.values,
      families,
      (v) => resolveFontStack(v, platform: target),
    );

    // The 42 type-scale tokens are fourteen roles × {size, weight, leading}.
    // Sizes and weights are converted with the rest; the leading is a bare
    // ratio and only means anything as part of a style.
    final textStyles = <AstryxTypeRole, TextStyle>{};
    for (final role in AstryxTypeRole.values) {
      final stack = families[role.familyToken.cssName];
      final size = parseCssLength(raw(role.sizeName) ?? '');
      final weight = parseCssFontWeight(raw(role.weightName) ?? '');
      final leading = double.tryParse(raw(role.leadingName)?.trim() ?? '');

      if (size != null) lengths[role.sizeName] = size;
      if (weight != null) weights[role.weightName] = weight;

      textStyles[role] = TextStyle(
        fontFamily: stack?.family,
        fontFamilyFallback: stack?.fallbacks,
        fontSize: size,
        fontWeight: weight,
        height: leading,
        // CSS centres the extra line height above and below the text; Flutter
        // puts it all above unless told otherwise, which sits everything a
        // fraction high.
        leadingDistribution: TextLeadingDistribution.even,
      );
    }

    return AstryxThemeData._(
      tokens: tokens,
      mode: mode,
      platform: target,
      text: text,
      heading: heading,
      divider: divider,
      icon: icon,
      button: button,
      colors: colors,
      lengths: lengths,
      shadows: shadows,
      durations: durations,
      curves: curves,
      weights: weights,
      families: families,
      textStyles: textStyles,
    );
  }

  const AstryxThemeData._({
    required this.tokens,
    required this.mode,
    required this.platform,
    required this.text,
    required this.heading,
    required this.divider,
    required this.icon,
    required this.button,
    required Map<String, Color> colors,
    required Map<String, double> lengths,
    required Map<String, List<AstryxShadow>> shadows,
    required Map<String, Duration> durations,
    required Map<String, Curve> curves,
    required Map<String, FontWeight> weights,
    required Map<String, AstryxFontStack> families,
    required Map<AstryxTypeRole, TextStyle> textStyles,
  }) : _colors = colors,
       _lengths = lengths,
       _shadows = shadows,
       _durations = durations,
       _curves = curves,
       _weights = weights,
       _families = families,
       _textStyles = textStyles;

  /// Runs the engine over [theme] and resolves it for [mode].
  ///
  /// A null [theme] gives the Astryx defaults.
  factory AstryxThemeData.resolve({
    required AstryxThemeMode mode,
    AstryxDefinedTheme? theme,
    TargetPlatform? platform,
    AstryxTextTheme text = const AstryxTextTheme(),
    AstryxTextTheme heading = const AstryxTextTheme(),
    AstryxDividerTheme divider = const AstryxDividerTheme(),
    AstryxIconTheme icon = const AstryxIconTheme(),
    AstryxButtonTheme button = const AstryxButtonTheme(),
  }) => AstryxThemeData(
    tokens: theme == null
        ? AstryxResolvedTokenSet.defaults
        : AstryxResolvedTokenSet.resolve(theme),
    mode: mode,
    platform: platform,
    text: text,
    heading: heading,
    divider: divider,
    icon: icon,
    button: button,
  );

  /// The resolved token strings this data was built from.
  ///
  /// Kept so a consumer can reach a token that has no typed accessor — a
  /// theme's syntax palette, or its own namespaced tokens.
  final AstryxResolvedTokenSet tokens;

  /// The colour mode these values were resolved for.
  final AstryxThemeMode mode;

  /// The platform the font stacks were resolved for.
  final TargetPlatform platform;

  /// Visual overrides for `AstryxText`.
  final AstryxTextTheme text;

  /// Visual overrides for `AstryxHeading`.
  ///
  /// Separate from [text] so a theme can weight or track headings without
  /// touching body copy.
  final AstryxTextTheme heading;

  /// Visual overrides for `AstryxDivider`.
  final AstryxDividerTheme divider;

  /// Visual overrides for `AstryxIcon`.
  final AstryxIconTheme icon;

  /// Visual overrides for `AstryxButton` and `AstryxIconButton`.
  final AstryxButtonTheme button;

  final Map<String, Color> _colors;
  final Map<String, double> _lengths;
  final Map<String, List<AstryxShadow>> _shadows;
  final Map<String, Duration> _durations;
  final Map<String, Curve> _curves;
  final Map<String, FontWeight> _weights;
  final Map<String, AstryxFontStack> _families;
  final Map<AstryxTypeRole, TextStyle> _textStyles;

  /// The [Brightness] matching [mode].
  Brightness get brightness =>
      mode == AstryxThemeMode.dark ? Brightness.dark : Brightness.light;

  /// The colour for [token].
  Color color(AstryxColorToken token) =>
      _require(_colors[token.cssName], token);

  /// The spacing step for [token], in logical pixels.
  double spacing(AstryxSpacingToken token) =>
      _require(_lengths[token.cssName], token);

  /// The control size for [token], in logical pixels.
  double size(AstryxSizeToken token) =>
      _require(_lengths[token.cssName], token);

  /// The corner radius for [token], in logical pixels.
  double radius(AstryxRadiusToken token) =>
      _require(_lengths[token.cssName], token);

  /// The corner radius for [token] as a [BorderRadius].
  BorderRadius borderRadius(AstryxRadiusToken token) =>
      BorderRadius.circular(radius(token));

  /// The border width for [token], in logical pixels.
  double borderWidth([
    AstryxBorderToken token = AstryxBorderToken.width,
  ]) => _require(_lengths[token.cssName], token);

  /// The raw font size for [token], in logical pixels.
  ///
  /// These are the unstyled steps of the size ramp. For text, prefer
  /// [textStyle], which also carries weight, line height and family.
  double textSize(AstryxTextSizeToken token) =>
      _require(_lengths[token.cssName], token);

  /// The shadow layers for [token].
  ///
  /// Some Astryx shadow tokens are inset; see [AstryxShadow.inset]. Use
  /// [boxShadows] where only outer shadows make sense.
  List<AstryxShadow> shadow(AstryxShadowToken token) =>
      _require(_shadows[token.cssName], token);

  /// The outer shadow layers for [token], as Flutter [BoxShadow]s.
  ///
  /// Inset layers are dropped, because [BoxShadow] cannot express them.
  List<BoxShadow> boxShadows(AstryxShadowToken token) => <BoxShadow>[
    for (final layer in shadow(token))
      if (!layer.inset) layer.toBoxShadow(),
  ];

  /// The duration for [token].
  Duration duration(AstryxDurationToken token) =>
      _require(_durations[token.cssName], token);

  /// The easing curve for [token].
  Curve ease([AstryxEaseToken token = AstryxEaseToken.standard]) =>
      _require(_curves[token.cssName], token);

  /// The font weight for [token].
  FontWeight fontWeight(AstryxFontWeightToken token) =>
      _require(_weights[token.cssName], token);

  /// The resolved font stack for [token].
  AstryxFontStack fontStack(AstryxTypographyToken token) =>
      _require(_families[token.cssName], token);

  /// The complete text style for [role] — family, size, weight and line height.
  TextStyle textStyle(AstryxTypeRole role) => _textStyles[role]!;

  /// The text style for heading [level], 1 through 6.
  TextStyle headingStyle(int level) => textStyle(AstryxTypeRole.heading(level));

  /// Returns a copy resolved for a different mode, platform or token set.
  ///
  /// Every value is reconverted, because all three inputs feed the conversion.
  AstryxThemeData copyWith({
    AstryxResolvedTokenSet? tokens,
    AstryxThemeMode? mode,
    TargetPlatform? platform,
    AstryxTextTheme? text,
    AstryxTextTheme? heading,
    AstryxDividerTheme? divider,
    AstryxIconTheme? icon,
    AstryxButtonTheme? button,
  }) => AstryxThemeData(
    tokens: tokens ?? this.tokens,
    mode: mode ?? this.mode,
    platform: platform ?? this.platform,
    text: text ?? this.text,
    heading: heading ?? this.heading,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
    button: button ?? this.button,
  );

  static T _require<T>(T? value, AstryxToken token) {
    if (value == null) {
      throw StateError(
        'The theme has no usable value for ${token.cssName}. Its resolved '
        'token is missing or could not be parsed.',
      );
    }
    return value;
  }

  // Equality is over the inputs, not the converted maps: conversion is
  // deterministic, so equal inputs cannot produce different values, and this
  // keeps `updateShouldNotify` cheap.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxThemeData &&
          other.mode == mode &&
          other.platform == platform &&
          other.tokens == tokens &&
          other.text == text &&
          other.heading == heading &&
          other.divider == divider &&
          other.icon == icon &&
          other.button == button;

  @override
  int get hashCode => Object.hash(
    tokens,
    mode,
    platform,
    text,
    heading,
    divider,
    icon,
    button,
  );

  @override
  String toString() => 'AstryxThemeData(${mode.name}, $platform)';
}
