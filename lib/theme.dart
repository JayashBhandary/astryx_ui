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
// Layer 2 is added in Phase 3. See dev/04-TRACKER.md.
export 'src/theme/color/color.dart';
export 'src/theme/engine/engine.dart';
export 'src/theme/tokens/tokens.dart';
