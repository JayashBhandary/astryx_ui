/// Layer 1 — the theme generation engine.
///
/// Pure Dart, with no dependency on Flutter: colour maths, the four scale
/// expanders, `defineTheme`, and the token resolver. Layer 2 turns what this
/// produces into Flutter values.
library;

export 'contrast.dart';
export 'define_theme.dart';
export 'derived_var_registry.dart';
export 'expand_color_scale.dart';
export 'expand_motion_scale.dart';
export 'expand_radius_scale.dart';
export 'expand_type_scale.dart';
export 'hct.dart';
export 'on_media_tokens.dart';
export 'style_overrides.dart';
export 'syntax_theme.dart';
export 'theme_registry.dart';
export 'token_resolver.dart';
export 'token_value.dart';
export 'typography_config.dart';
