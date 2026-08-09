/// Resolving a theme to concrete token values.
///
/// A faithful port of the resolver half of upstream's
/// `packages/core/src/theme/tokens.ts`.
///
/// Generated themes emit derived tokens as *references* — `--color-text-accent`
/// is literally `var(--color-accent)` — so that a scoped override of the base
/// token re-themes everything that points at it. In a browser the CSS cascade
/// does that resolution. Here there is no cascade, so this module replays it:
/// follow `var()` references through the token map, guarding against cycles,
/// and evaluate the colour functions the generator emits.
///
/// Only `color-mix(in srgb, …)` is evaluated. Upstream refuses other colour
/// spaces rather than approximating them, and preserves the expression with its
/// `var()` references resolved. That refusal is part of the contract, not an
/// omission — see ADR-010.
library;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/light_dark.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';
import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';

/// The colour mode a theme is resolved for.
enum AstryxThemeMode {
  /// Light mode: the first half of every `light-dark()` value.
  light,

  /// Dark mode: the second half.
  dark,
}

/// Resolves a token value for [mode].
///
/// A `light-dark(light, dark)` string is parsed and the matching side returned.
/// Anything else is returned unchanged.
String resolveTokenValueForMode(String value, AstryxThemeMode mode) {
  final parsed = parseLightDark(value);
  if (parsed != null) {
    return mode == AstryxThemeMode.dark ? parsed.dark : parsed.light;
  }
  return value;
}

/// Resolves an [AstryxTokenValue] for [mode].
///
/// A pair yields its matching half directly, without a round trip through
/// `light-dark()` string parsing.
String resolveTokenValueObjectForMode(
  AstryxTokenValue value,
  AstryxThemeMode mode,
) {
  final dark = value.dark;
  if (dark != null) return mode == AstryxThemeMode.dark ? dark : value.light;
  return resolveTokenValueForMode(value.light, mode);
}

// =============================================================================
// Reference resolution
// =============================================================================

/// The index of the `)` matching the `(` at [openIndex], or -1 if unbalanced.
int _findMatchingParen(String input, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < input.length; i++) {
    final char = input[i];
    if (char == '(') {
      depth++;
    } else if (char == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

final RegExp _mixPercentage = RegExp(r'\s+([\d.]+)%$');
final RegExp _mixColorSpace = RegExp(
  r'^in\s+([\w-]+)\s*,\s*(.+)$',
  dotAll: true,
);

/// One side of a `color-mix()`: a colour and an optional percentage.
typedef _MixComponent = ({String color, double? percentage});

/// Splits a `color-mix` component into its colour and optional percentage.
_MixComponent _parseMixComponent(String part) {
  final trimmed = part.trim();
  final match = _mixPercentage.firstMatch(trimmed);
  if (match != null) {
    return (
      color: trimmed.substring(0, match.start).trim(),
      percentage: parseFloatLoose(match.group(1)!),
    );
  }
  return (color: trimmed, percentage: null);
}

/// Evaluates `color-mix(in <space>, c1 [p1], c2 [p2])` to a concrete colour.
///
/// [body] is the text between the parentheses. Supports the `srgb` colour
/// space — the one the theme generator emits — using the CSS Color 5 algorithm:
/// normalise the percentages, interpolate the premultiplied channels, then
/// apply the alpha multiplier when the weights sum to less than 100%.
///
/// Returns null for anything it cannot evaluate, so the caller preserves the
/// original expression rather than guessing at it.
String? evaluateColorMix(String body) {
  final spaceMatch = _mixColorSpace.firstMatch(body);
  if (spaceMatch == null) return null;
  if (spaceMatch.group(1)!.toLowerCase() != 'srgb') return null;

  final split = splitTopLevelComma(spaceMatch.group(2)!);
  if (split == null) return null;

  final first = _parseMixComponent(split.before);
  final second = _parseMixComponent(split.after);

  final c1 = parseColor(first.color);
  final c2 = parseColor(second.color);
  if (c1 == null || c2 == null) return null;

  // Fill in an omitted percentage, then normalise so the two sum to 100%.
  final double p1;
  final double p2;
  final firstPct = first.percentage;
  final secondPct = second.percentage;
  if (firstPct != null && secondPct != null) {
    p1 = firstPct;
    p2 = secondPct;
  } else if (firstPct != null) {
    p1 = firstPct;
    p2 = 100 - p1;
  } else if (secondPct != null) {
    p2 = secondPct;
    p1 = 100 - p2;
  } else {
    p1 = 50;
    p2 = 50;
  }

  final sum = p1 + p2;
  if (sum <= 0) return null;
  final w1 = p1 / sum;
  final w2 = p2 / sum;
  final alphaMultiplier = sum < 100 ? sum / 100 : 1.0;

  // Interpolate in premultiplied sRGB, then un-premultiply.
  final mixedA = w1 * c1.a + w2 * c2.a;
  double premix(double k1, double k2) => w1 * k1 * c1.a + w2 * k2 * c2.a;
  final rp = premix(c1.r, c2.r);
  final gp = premix(c1.g, c2.g);
  final bp = premix(c1.b, c2.b);

  return formatColor(
    AstryxRgba(
      r: mixedA == 0 ? 0 : rp / mixedA,
      g: mixedA == 0 ? 0 : gp / mixedA,
      b: mixedA == 0 ? 0 : bp / mixedA,
      a: mixedA * alphaMultiplier,
    ),
  );
}

/// Evaluates every supported colour function in [expr], innermost first.
///
/// A `color-mix()` that cannot be evaluated is rebuilt around its own resolved
/// body, so its inner `var()` references still come out substituted.
String evaluateColorFunctions(String expr) {
  const marker = 'color-mix(';
  final idx = expr.indexOf(marker);
  if (idx == -1) return expr;

  final openIndex = idx + 'color-mix'.length;
  final closeIndex = _findMatchingParen(expr, openIndex);
  if (closeIndex == -1) return expr;

  final body = evaluateColorFunctions(
    expr.substring(openIndex + 1, closeIndex),
  );
  final replacement = evaluateColorMix(body) ?? 'color-mix($body)';

  return expr.substring(0, idx) +
      replacement +
      evaluateColorFunctions(expr.substring(closeIndex + 1));
}

/// Substitutes `var(--name[, fallback])` references with their resolved values.
///
/// [seen] tracks the reference chain, so a cycle resolves to the literal
/// reference instead of recursing forever.
String _substituteVars(
  String expr,
  Map<String, String> raw,
  Map<String, String> cache,
  Set<String> seen,
) {
  final start = expr.indexOf('var(');
  if (start == -1) return expr;

  final openIndex = start + 'var'.length;
  final closeIndex = _findMatchingParen(expr, openIndex);
  if (closeIndex == -1) return expr;

  final inner = expr.substring(openIndex + 1, closeIndex);
  final commaSplit = splitTopLevelComma(inner);
  final name = (commaSplit?.before ?? inner).trim();
  final fallback = commaSplit?.after;

  final String replacement;
  if (seen.contains(name)) {
    replacement = expr.substring(start, closeIndex + 1);
  } else if (raw.containsKey(name)) {
    seen.add(name);
    replacement = _resolveReference(name, raw, cache, seen);
    seen.remove(name);
  } else if (fallback != null) {
    replacement = _substituteVars(fallback.trim(), raw, cache, seen);
  } else {
    replacement = expr.substring(start, closeIndex + 1);
  }

  final rest = _substituteVars(
    expr.substring(closeIndex + 1),
    raw,
    cache,
    seen,
  );
  return expr.substring(0, start) + replacement + rest;
}

/// Fully resolves one expression: substitute references, then evaluate colours.
String _resolveExpression(
  String expr,
  Map<String, String> raw,
  Map<String, String> cache,
  Set<String> seen,
) {
  if (!expr.contains('var(') && !expr.contains('color-mix(')) return expr;
  return evaluateColorFunctions(_substituteVars(expr, raw, cache, seen));
}

/// Resolves one token by name, memoising into [cache].
String _resolveReference(
  String name,
  Map<String, String> raw,
  Map<String, String> cache,
  Set<String> seen,
) {
  final cached = cache[name];
  if (cached != null) return cached;

  final value = raw[name];
  if (value == null) return '';

  final resolved = _resolveExpression(value, raw, cache, seen);
  cache[name] = resolved;
  return resolved;
}

/// Resolves every reference and colour function in [raw] to concrete values.
Map<String, String> resolveReferences(Map<String, String> raw) {
  final cache = <String, String>{};
  for (final name in raw.keys) {
    _resolveReference(name, raw, cache, <String>{});
  }
  return cache;
}

/// Resolves every Astryx token for [theme] in [mode].
///
/// The result starts from the token defaults, applies the theme's tokens, then
/// reapplies its original input tokens so an explicit light/dark pair keeps its
/// two sides instead of being recovered from a `light-dark()` string. A final
/// pass follows `var()` references and evaluates colour functions, so a derived
/// token such as `--color-text-accent` comes back as a concrete colour rather
/// than `var(--color-accent)`.
///
/// Pass a null [theme] to resolve the defaults alone.
///
/// {@tool snippet}
/// ```dart
/// final tokens = resolveThemeTokens(myTheme, AstryxThemeMode.light);
/// final accent = tokens['--color-accent']; // '#0064E0'
/// ```
/// {@end-tool}
Map<String, String> resolveThemeTokens(
  AstryxDefinedTheme? theme,
  AstryxThemeMode mode,
) {
  final resolved = <String, String>{};

  for (final entry in astryxTokenDefaults.entries) {
    resolved[entry.key] = resolveTokenValueForMode(entry.value, mode);
  }

  if (theme == null) return resolveReferences(resolved);

  for (final entry in theme.tokens.entries) {
    resolved[entry.key] = resolveTokenValueForMode(entry.value, mode);
  }

  final inputTokens = theme.inputTokens;
  if (inputTokens != null) {
    for (final entry in inputTokens.entries) {
      resolved[entry.key] = resolveTokenValueObjectForMode(entry.value, mode);
    }
  }

  return resolveReferences(resolved);
}

/// Resolves one Astryx token for [theme] in [mode].
///
/// Returns [fallback] when [name] is not a known token.
String resolveThemeToken(
  AstryxDefinedTheme? theme,
  String name,
  AstryxThemeMode mode, {
  String fallback = '',
}) => resolveThemeTokens(theme, mode)[name] ?? fallback;
