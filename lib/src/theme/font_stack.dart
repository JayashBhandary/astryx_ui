/// Resolving a CSS font stack to a Flutter font family and fallbacks.
///
/// Open item 5 was settled in favour of resolving the system stack per platform
/// and bundling no font, matching upstream — Astryx's three typography tokens
/// are system font stacks, not a bundled typeface.
///
/// CSS gives the browser a comma-separated list and lets it walk down until a
/// family exists. Flutter takes one `fontFamily` plus an ordered
/// `fontFamilyFallback`, and resolves nothing for you: a family that is absent
/// simply renders in the platform default. The translation is therefore about
/// picking the right *primary*.
library;

import 'package:astryx_ui/src/theme/color/light_dark.dart';
import 'package:flutter/foundation.dart';

/// A CSS font stack translated into what Flutter's text layer accepts.
@immutable
class AstryxFontStack {
  /// Creates a resolved font stack.
  const AstryxFontStack({this.family, this.fallbacks = const <String>[]});

  /// The primary family, or null to use the platform's own default.
  ///
  /// Null is the correct answer, not a missing one, whenever the stack leads
  /// with a system alias such as `-apple-system`. Flutter's default *is* the
  /// platform UI font — San Francisco, Roboto, Segoe UI — which is exactly what
  /// the alias asks for.
  final String? family;

  /// Families to try, in order, when [family] is unavailable.
  final List<String> fallbacks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxFontStack &&
          other.family == family &&
          listEquals(other.fallbacks, fallbacks);

  @override
  int get hashCode => Object.hash(family, Object.hashAll(fallbacks));

  @override
  String toString() => 'AstryxFontStack($family, fallbacks: $fallbacks)';
}

/// CSS keywords that name "whatever this platform's UI font is".
///
/// They have no Flutter equivalent because Flutter's default already is that
/// font, so encountering one means "use the default".
const Set<String> _systemAliases = <String>{
  '-apple-system',
  'blinkmacsystemfont',
  'system-ui',
  'ui-sans-serif',
  'ui-serif',
  'ui-rounded',
};

/// CSS generic families, expanded per platform below.
const Set<String> _generics = <String>{
  'sans-serif',
  'serif',
  'monospace',
  'cursive',
  'fantasy',
  'ui-monospace',
};

/// Concrete families to stand in for a CSS generic, per platform.
///
/// These are last-resort fallbacks appended after every named family, so
/// getting one slightly wrong degrades the tail of the stack rather than the
/// text a user actually sees.
List<String> _expandGeneric(String generic, TargetPlatform platform) {
  final isApple =
      platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

  switch (generic) {
    case 'monospace':
    case 'ui-monospace':
      if (isApple) return const <String>['Menlo', 'Courier New'];
      if (platform == TargetPlatform.windows) {
        return const <String>['Consolas', 'Courier New'];
      }
      return const <String>['monospace', 'Roboto Mono', 'Courier New'];
    case 'serif':
      if (isApple) return const <String>['Times New Roman', 'Georgia'];
      return const <String>['serif', 'Times New Roman'];
    case 'sans-serif':
    case 'cursive':
    case 'fantasy':
    default:
      // The platform default is already a sans-serif; naming another family
      // here would override it for no benefit.
      return const <String>[];
  }
}

String _unquote(String value) {
  final trimmed = value.trim();
  if (trimmed.length >= 2) {
    final first = trimmed[0];
    if ((first == '"' || first == "'") && trimmed.endsWith(first)) {
      return trimmed.substring(1, trimmed.length - 1);
    }
  }
  return trimmed;
}

/// Resolves a CSS font stack for [platform].
///
/// The rules, in order:
///
/// 1. Split on top-level commas and strip quotes.
/// 2. **The first entry decides the primary**, because a CSS stack is ordered
///    by preference. A named family becomes [AstryxFontStack.family]; a system
///    alias — `-apple-system`, `system-ui` and friends — leaves it null,
///    meaning the platform's own UI font.
/// 3. Everything after it becomes a fallback, in order.
/// 4. Generic families are expanded to concrete per-platform names and appended
///    last.
///
/// Position is the whole point. Astryx's default stack leads with
/// `-apple-system`, so it resolves to the platform font. A theme's stack leads
/// with its own choice — neutral's is `Figtree, -apple-system, …` — so it
/// resolves to `Figtree`, with the system font behind it exactly as the CSS
/// asks. Treating an alias *anywhere* as decisive would make a theme's chosen
/// font unreachable.
///
/// Flutter falls back to the platform font for an unavailable family anyway, so
/// naming one that is not installed degrades the same way a browser does.
///
/// {@tool snippet}
/// ```dart
/// // '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
/// //   → family: null, fallbacks: ['Segoe UI', 'Roboto']
/// //
/// // 'Figtree, -apple-system, sans-serif'
/// //   → family: 'Figtree', fallbacks: []
/// //
/// // '"SF Mono", Monaco, Consolas, monospace' on macOS
/// //   → family: 'SF Mono', fallbacks: ['Monaco', 'Consolas', 'Menlo', …]
/// resolveFontStack(stack, platform: defaultTargetPlatform);
/// ```
/// {@end-tool}
AstryxFontStack resolveFontStack(
  String stack, {
  TargetPlatform? platform,
}) {
  final target = platform ?? defaultTargetPlatform;

  String? family;
  var primaryDecided = false;
  final fallbacks = <String>[];
  final genericTail = <String>[];

  for (final raw in splitTopLevelCommas(stack)) {
    final entry = _unquote(raw);
    if (entry.isEmpty) continue;
    final lower = entry.toLowerCase();

    if (_generics.contains(lower)) {
      // A generic never claims the primary slot — it names a category, not a
      // face, and Flutter's default already satisfies the common one.
      for (final expansion in _expandGeneric(lower, target)) {
        if (!genericTail.contains(expansion)) genericTail.add(expansion);
      }
      continue;
    }

    if (_systemAliases.contains(lower)) {
      // Null primary means "the platform's own UI font", which is what the
      // alias asks for. Anything after it is unreachable in CSS terms too, so
      // it is dropped rather than promoted to a fallback.
      primaryDecided = true;
      break;
    }

    if (!primaryDecided) {
      family = entry;
      primaryDecided = true;
    } else if (!fallbacks.contains(entry) && entry != family) {
      fallbacks.add(entry);
    }
  }

  return AstryxFontStack(
    family: family,
    fallbacks: <String>[...fallbacks, ...genericTail],
  );
}
