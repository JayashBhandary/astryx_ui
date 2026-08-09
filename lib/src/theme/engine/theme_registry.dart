/// A registry of defined themes, keyed by name.
///
/// A port of upstream's `packages/core/src/theme/themeRegistry.ts`, minus its
/// server-rendering rationale — upstream needs name-based lookup because a
/// theme has to be resolvable during SSR without React context. Here it earns
/// its place more simply: a theme picker, like the one in the example gallery,
/// wants to enumerate what has been defined.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:meta/meta.dart';

final Map<String, AstryxDefinedTheme> _registry =
    <String, AstryxDefinedTheme>{};

/// Registers [theme] under its own name.
///
/// Idempotent: registering a theme replaces any earlier one with the same
/// name. [defineTheme] calls this, so a theme is registered the moment it is
/// defined.
void registerTheme(AstryxDefinedTheme theme) {
  _registry[theme.name] = theme;
}

/// Returns the theme registered under [name], or null if there is none.
///
/// A null or empty [name] returns null rather than throwing.
AstryxDefinedTheme? getRegisteredTheme(String? name) {
  if (name == null || name.isEmpty) return null;
  return _registry[name];
}

/// Returns every registered theme, keyed by name.
///
/// The result is a snapshot; mutating it does not affect the registry.
Map<String, AstryxDefinedTheme> getRegisteredThemes() =>
    Map<String, AstryxDefinedTheme>.of(_registry);

/// Empties the registry.
@visibleForTesting
void resetThemes() {
  _registry.clear();
}
