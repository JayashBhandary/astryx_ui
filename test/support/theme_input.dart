import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/on_media_tokens.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

import 'fixtures.dart';

/// Rebuilds an [AstryxDefineThemeInput] from the JSON form of the object an
/// upstream `defineTheme` call was given.
///
/// The fixtures record the *input* to upstream's `defineTheme`, not just its
/// output. Feeding the same input to the Dart implementation and diffing the
/// results is what turns "the engine is a faithful port" into something a test
/// can fail on.
AstryxDefineThemeInput decodeThemeInput(Map<String, dynamic> json) =>
    AstryxDefineThemeInput(
      name: json['name']! as String,
      color: _color(json['color'] as Map<String, dynamic>?),
      typography: _typography(json['typography'] as Map<String, dynamic>?),
      motion: _motion(json['motion'] as Map<String, dynamic>?),
      radius: _radius(json['radius'] as Map<String, dynamic>?),
      tokens: decodeTokenMap(json['tokens'] as Map<String, dynamic>?),
      components: decodeComponents(json['components'] as Map<String, dynamic>?),
      icons: (json['icons'] as Map<String, dynamic>?)?.cast<String, Object>(),
      syntax: _syntax(json['syntax'] as Map<String, dynamic>?),
      onDark: decodeOnMedia(json['onDark'] as Map<String, dynamic>?),
      onLight: decodeOnMedia(json['onLight'] as Map<String, dynamic>?),
    );

/// Decodes a token map whose values are a string or a `[light, dark]` pair.
Map<String, AstryxTokenValue>? decodeTokenMap(Map<String, dynamic>? json) {
  if (json == null) return null;
  return json.map((key, value) {
    if (value is List) {
      return MapEntry(
        key,
        AstryxTokenValue.lightDark(value[0] as String, value[1] as String),
      );
    }
    return MapEntry(key, AstryxTokenValue(value! as String));
  });
}

/// Decodes a component style map.
///
/// Upstream keeps CSS properties and pseudo-class blocks in one flat record,
/// distinguished by whether the key starts with `:`. [AstryxStyleOverrides]
/// splits them into named fields, so the split happens here.
AstryxComponentStyleMap? decodeComponents(Map<String, dynamic>? json) {
  if (json == null) return null;
  return json.map(
    (component, rules) => MapEntry(component, <String, AstryxStyleOverrides>{
      for (final rule in (rules as Map<String, dynamic>).entries)
        rule.key: decodeStyleOverrides(rule.value as Map<String, dynamic>),
    }),
  );
}

/// Decodes one style rule into properties and pseudo-class blocks.
AstryxStyleOverrides decodeStyleOverrides(Map<String, dynamic> json) {
  final properties = <String, String>{};
  final pseudo = <String, Map<String, String>>{};
  for (final entry in json.entries) {
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      pseudo[entry.key] = value.cast<String, String>();
    } else {
      properties[entry.key] = value! as String;
    }
  }
  return AstryxStyleOverrides(properties: properties, pseudo: pseudo);
}

/// Decodes an on-media override set.
AstryxOnMediaOverrides? decodeOnMedia(Map<String, dynamic>? json) {
  if (json == null) return null;
  return AstryxOnMediaOverrides(
    tokens: decodeTokenMap(json['tokens'] as Map<String, dynamic>?),
    components: decodeComponents(json['components'] as Map<String, dynamic>?),
  );
}

AstryxColorScaleConfig? _color(Map<String, dynamic>? json) {
  if (json == null) return null;
  return AstryxColorScaleConfig(
    accent: json['accent'] as String?,
    neutralStyle: switch (json['neutralStyle'] as String?) {
      'warm' => AstryxNeutralStyle.warm,
      'neutral' => AstryxNeutralStyle.neutral,
      _ => AstryxNeutralStyle.cool,
    },
    contrast: json['contrast'] == 'high'
        ? AstryxContrastLevel.high
        : AstryxContrastLevel.standard,
  );
}

AstryxMotionScaleConfig? _motion(Map<String, dynamic>? json) {
  if (json == null) return null;
  final slow = json['slow'];
  return AstryxMotionScaleConfig(
    fast: asDouble(json['fast']),
    medium: asDouble(json['medium']),
    ratio: asDouble(json['ratio']),
    slow: slow == null ? null : asDouble(slow),
    easing: json['easing'] as String?,
  );
}

AstryxRadiusScaleConfig? _radius(Map<String, dynamic>? json) {
  if (json == null) return null;
  return AstryxRadiusScaleConfig(
    base: asDouble(json['base']),
    multiplier: asDouble(json['multiplier']),
  );
}

AstryxSyntaxTheme? _syntax(Map<String, dynamic>? json) {
  if (json == null) return null;
  return AstryxSyntaxTheme(
    name: json['name']! as String,
    tokens: (json['tokens']! as Map<String, dynamic>).cast<String, String>(),
  );
}

AstryxTypographyConfig? _typography(Map<String, dynamic>? json) {
  if (json == null) return null;
  final scale = json['scale'] as Map<String, dynamic>?;
  return AstryxTypographyConfig(
    scale: scale == null
        ? null
        : AstryxTypeScaleSpec(
            base: asDouble(scale['base']),
            ratio: asDouble(scale['ratio']),
          ),
    body: _role(json['body'] as Map<String, dynamic>?),
    heading: _role(json['heading'] as Map<String, dynamic>?),
    code: _role(json['code'] as Map<String, dynamic>?),
  );
}

AstryxTypographyRole? _role(Map<String, dynamic>? json) {
  if (json == null) return null;
  final weights = json['weights'] as Map<String, dynamic>?;
  return AstryxTypographyRole(
    family: json['family'] as String?,
    fallbacks: json['fallbacks'] as String?,
    weight: json['weight'] == null
        ? null
        : AstryxFontWeight(json['weight']! as String),
    weights: weights?.map(
      (key, value) =>
          MapEntry(int.parse(key), AstryxFontWeight(value! as String)),
    ),
  );
}
