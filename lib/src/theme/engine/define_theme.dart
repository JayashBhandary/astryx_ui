/// Theme definition — the orchestrator that turns a configuration into a token
/// map.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/defineTheme.ts`, minus its CSS emission.
///
/// ## Precedence
///
/// Later wins:
///
/// 1. the base theme's tokens, when [AstryxDefineThemeInput.extendsTheme] is
///    given,
/// 2. colour-scale-generated tokens,
/// 3. type-scale-generated tokens,
/// 4. radius-generated tokens,
/// 5. motion-generated tokens,
/// 6. typography font-family tokens,
/// 7. syntax tokens,
/// 8. explicit [AstryxDefineThemeInput.tokens] overrides.
///
/// Anything a theme does not set is not in the map at all; the token defaults
/// fill the gaps at resolve time.
library;

import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_type_scale.dart';
import 'package:astryx_ui/src/theme/engine/on_media_tokens.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// The input to [defineTheme].
///
/// {@tool snippet}
/// ```dart
/// final myTheme = defineTheme(
///   const AstryxDefineThemeInput(
///     name: 'my-brand',
///     color: AstryxColorScaleConfig(accent: '#0064E0'),
///     typography: AstryxTypographyConfig(
///       scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
///     ),
///     tokens: <String, AstryxTokenValue>{
///       '--radius-element': AstryxTokenValue('6px'),
///     },
///   ),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxDefineThemeInput {
  /// Creates a theme definition input.
  const AstryxDefineThemeInput({
    required this.name,
    this.extendsTheme,
    this.typography,
    this.motion,
    this.radius,
    this.color,
    this.tokens,
    this.components,
    this.icons,
    this.syntax,
    this.onDark,
    this.onLight,
  });

  /// The theme name, used to identify and register the theme.
  final String name;

  /// A base theme to extend.
  ///
  /// The new theme starts from the base theme's tokens, components and icons,
  /// then applies this input on top. The base has the lowest precedence.
  ///
  /// Named `extendsTheme` because `extends` is a Dart keyword.
  final AstryxDefinedTheme? extendsTheme;

  /// Typography: the type scale, plus fonts and weights per role.
  final AstryxTypographyConfig? typography;

  /// Motion: base durations and a scaling ratio.
  final AstryxMotionScaleConfig? motion;

  /// Radius: a base unit and a multiplier.
  final AstryxRadiusScaleConfig? radius;

  /// Colour: a seed accent, neutral warmth and contrast level.
  final AstryxColorScaleConfig? color;

  /// Explicit token overrides, keyed by CSS custom property name.
  ///
  /// These beat every generated value. Include only what should differ from
  /// the defaults.
  final Map<String, AstryxTokenValue>? tokens;

  /// Component style overrides, keyed by lowercase component name.
  final AstryxComponentStyleMap? components;

  /// The icon registry, keyed by semantic icon name.
  ///
  /// Opaque to the theme engine, which must not depend on Flutter and so
  /// cannot name an icon type. `defineTheme` only merges this map over the
  /// base theme's; Layer 2 gives it a type.
  final Map<String, Object>? icons;

  /// The default syntax highlighting theme for code components.
  final AstryxSyntaxTheme? syntax;

  /// Overrides for content on a dark surface — an inverted toast, a dark
  /// tooltip. The defaults apply when this is omitted.
  final AstryxOnMediaOverrides? onDark;

  /// Overrides for content on a light surface, such as a light popover on a
  /// dark page.
  final AstryxOnMediaOverrides? onLight;
}

/// A defined theme, ready to hand to the theme runtime.
@immutable
class AstryxDefinedTheme {
  /// Creates a defined theme.
  ///
  /// Prefer [defineTheme]; this constructor exists for the theme-build path,
  /// where a theme has already been resolved.
  const AstryxDefinedTheme({
    required this.name,
    required this.tokens,
    this.components,
    this.icons,
    this.inputTokens,
    this.onDark,
    this.onLight,
  });

  /// The theme name.
  final String name;

  /// The token overrides this theme sets, as CSS strings. Only the tokens the
  /// theme actually specified are present.
  final Map<String, String> tokens;

  /// Component style overrides.
  final AstryxComponentStyleMap? components;

  /// The icon registry. See [AstryxDefineThemeInput.icons].
  final Map<String, Object>? icons;

  /// The explicit token overrides exactly as they were written.
  ///
  /// Light/dark pairs survive here unflattened, so a consumer that needs both
  /// halves — chart configuration, canvas painting — reads them without taking
  /// a `light-dark()` string back apart.
  final Map<String, AstryxTokenValue>? inputTokens;

  /// Resolved overrides for dark surfaces.
  final AstryxResolvedOnMedia? onDark;

  /// Resolved overrides for light surfaces.
  final AstryxResolvedOnMedia? onLight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxDefinedTheme &&
          other.name == name &&
          const DeepCollectionEquality().equals(other.tokens, tokens) &&
          const DeepCollectionEquality().equals(other.components, components) &&
          const DeepCollectionEquality().equals(other.icons, icons) &&
          const DeepCollectionEquality().equals(
            other.inputTokens,
            inputTokens,
          ) &&
          other.onDark == onDark &&
          other.onLight == onLight;

  @override
  int get hashCode => Object.hash(
    name,
    const DeepCollectionEquality().hash(tokens),
    const DeepCollectionEquality().hash(components),
    const DeepCollectionEquality().hash(icons),
    const DeepCollectionEquality().hash(inputTokens),
    onDark,
    onLight,
  );

  @override
  String toString() =>
      'AstryxDefinedTheme($name, ${tokens.length} token overrides)';
}

/// Builds the full CSS font-family value from a family and its fallbacks.
///
/// A family containing a space is quoted, as CSS requires.
String? _buildFontFamily(String? family, String? fallbacks) {
  if (family == null || family.isEmpty) return null;
  final quoted = family.contains(' ') ? '"$family"' : family;
  return fallbacks == null || fallbacks.isEmpty
      ? quoted
      : '$quoted, $fallbacks';
}

/// Derives the type scale configuration from a typography configuration.
///
/// Returns null when no scale is given, which is what makes the whole
/// typography token layer opt-in.
AstryxTypeScaleConfig? _typeScaleFrom(AstryxTypographyConfig? typography) {
  final scale = typography?.scale;
  if (typography == null || scale == null) return null;

  final headingWeights = <int, String>{};
  final headingRole = typography.heading;
  final perLevel = headingRole?.weights;
  if (perLevel != null) {
    for (final entry in perLevel.entries) {
      headingWeights[entry.key] = entry.value.css;
    }
  }
  // A role-level default fills every level the per-level map left alone.
  final defaultHeadingWeight = headingRole?.weight?.css;
  if (defaultHeadingWeight != null) {
    for (var level = 1; level <= 6; level++) {
      headingWeights.putIfAbsent(level, () => defaultHeadingWeight);
    }
  }

  final textWeights = <String, String>{};
  final bodyWeight = typography.body?.weight?.css;
  if (bodyWeight != null) textWeights['body'] = bodyWeight;
  final codeWeight = typography.code?.weight?.css;
  if (codeWeight != null) textWeights['code'] = codeWeight;

  return AstryxTypeScaleConfig(
    base: scale.base,
    ratio: scale.ratio,
    weights: AstryxTypeScaleWeights(
      heading: headingWeights.isEmpty ? null : headingWeights,
      text: textWeights.isEmpty ? null : textWeights,
    ),
  );
}

/// Creates an Astryx theme.
///
/// Only the tokens [input] specifies end up in the result; everything else
/// inherits from the defaults at resolve time. See the library documentation
/// for the precedence order.
///
/// The theme is registered under its name as a side effect, matching upstream,
/// so [getRegisteredTheme] can find it.
AstryxDefinedTheme defineTheme(AstryxDefineThemeInput input) {
  final tokens = <String, String>{};

  // 0. Seed from the base theme, the lowest precedence of all.
  final base = input.extendsTheme;
  if (base != null) {
    tokens.addAll(base.tokens);
  }

  final typography = input.typography;
  final typeScaleConfig = _typeScaleFrom(typography);

  // 1. Colour-generated tokens.
  final color = input.color;
  if (color != null) {
    tokens.addAll(expandColorScale(color));
  }

  // 1a. Type-scale-generated tokens.
  if (typeScaleConfig != null) {
    tokens.addAll(expandTypeScale(typeScaleConfig));
  }

  // 1b. Radius-generated tokens.
  final radius = input.radius;
  if (radius != null) {
    tokens.addAll(expandRadiusScale(radius));
  }

  // 1c. Motion-generated tokens.
  final motion = input.motion;
  if (motion != null) {
    tokens.addAll(expandMotionScale(motion));
  }

  // 1d. Typography font-family tokens. Heading inherits from body.
  if (typography != null) {
    final bodyFamily = _buildFontFamily(
      typography.body?.family,
      typography.body?.fallbacks,
    );
    final headingFamily =
        _buildFontFamily(
          typography.heading?.family,
          typography.heading?.fallbacks,
        ) ??
        bodyFamily;
    final codeFamily = _buildFontFamily(
      typography.code?.family,
      typography.code?.fallbacks,
    );

    if (bodyFamily != null) tokens['--font-family-body'] = bodyFamily;
    if (headingFamily != null) tokens['--font-family-heading'] = headingFamily;
    if (codeFamily != null) tokens['--font-family-code'] = codeFamily;
  }

  // 1e. Syntax theme tokens, still below the explicit overrides.
  final syntax = input.syntax;
  if (syntax != null) {
    for (final entry in syntax.tokens.entries) {
      tokens['$astryxSyntaxTokenPrefix${entry.key}'] = entry.value;
    }
  }

  // 2. Explicit token overrides — the highest precedence.
  final explicit = input.tokens;
  if (explicit != null) {
    for (final entry in explicit.entries) {
      tokens[entry.key] = entry.value.css;
    }
  }

  // 3. Component overrides: base, then type scale, then explicit.
  var components = input.components;
  if (typeScaleConfig != null) {
    components = deepMergeComponents(
      _asStyleMap(generateTypeScaleComponents(typeScaleConfig)),
      input.components,
    );
  }
  if (base?.components != null) {
    components = deepMergeComponents(base!.components, components);
  }

  // 4. On-media overrides: defaults, plus anything the theme supplied.
  final onDark = resolveOnMedia(AstryxSurface.dark, input.onDark);
  final onLight = resolveOnMedia(AstryxSurface.light, input.onLight);

  // 5. Icons: the input's entries win over the base theme's.
  final baseIcons = base?.icons;
  final inputIcons = input.icons;
  final icons = inputIcons != null && baseIcons != null
      ? <String, Object>{...baseIcons, ...inputIcons}
      : inputIcons ?? baseIcons;

  final theme = AstryxDefinedTheme(
    name: input.name,
    tokens: tokens,
    components: components,
    icons: icons,
    inputTokens: input.tokens,
    onDark: onDark,
    onLight: onLight,
  );

  registerTheme(theme);
  return theme;
}

/// Wraps the flat property maps [generateTypeScaleComponents] returns in
/// [AstryxStyleOverrides]. The generated rules carry no pseudo-class blocks.
AstryxComponentStyleMap _asStyleMap(
  Map<String, Map<String, Map<String, String>>> generated,
) => generated.map(
  (component, rules) => MapEntry(
    component,
    rules.map(
      (key, properties) =>
          MapEntry(key, AstryxStyleOverrides(properties: properties)),
    ),
  ),
);
