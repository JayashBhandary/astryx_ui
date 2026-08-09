/// The astryx_ui theme layer, without any components.
///
/// Import this when you need tokens, `AstryxThemeData`, or the theme engine but
/// not the widget set — build-time theme adapters, chart configuration, canvas
/// or custom painting, and tests.
///
/// ```dart
/// import 'package:astryx_ui/theme.dart';
/// ```
///
/// This mirrors Astryx's `@astryxdesign/core/theme` entry point.
library;

// Layer 0 — colour primitives and design tokens.
// Layer 1 — the theme generation engine.
// Layer 2 — the runtime: resolved tokens as Flutter values, and the themes.
export 'src/theme/astryx_shadow.dart';
export 'src/theme/astryx_theme.dart';
export 'src/theme/astryx_theme_data.dart';
export 'src/theme/color/color.dart';
export 'src/theme/components/components.dart';
export 'src/theme/engine/engine.dart';
export 'src/theme/font_stack.dart';
export 'src/theme/resolved_token_set.dart';
export 'src/theme/themes/themes.dart';
export 'src/theme/token_conversions.dart';
export 'src/theme/tokens/tokens.dart';
export 'src/theme/type_role.dart';
