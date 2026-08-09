/// `light-dark()` parsing.
///
/// Ports the `splitTopLevelComma` and `parseLightDark` helpers from upstream's
/// `packages/core/src/theme/tokens.ts`. They live in Layer 0 because they are
/// pure string work with no theme knowledge; the resolver that follows `var()`
/// references and evaluates `color-mix()` is Phase 2.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/color_value.dart';

/// Splits the arguments of a CSS function body on the first top-level comma.
///
/// Handles nested functions such as `rgba()`, `color-mix()` and `var()`, and
/// quoted strings — so `light-dark(rgba(0, 0, 0, 0.1), #FFF)` splits after the
/// closing `)` of `rgba`, not at its first inner comma.
///
/// Returns `null` when there is no top-level comma.
({String before, String after})? splitTopLevelComma(String input) {
  var depth = 0;
  String? quote;
  var isEscaped = false;

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    // Backslash escaping applies only inside a quoted string, as upstream has
    // it. At the top level a backslash is an ordinary character.
    if (quote != null) {
      if (isEscaped) {
        isEscaped = false;
      } else if (char == r'\') {
        isEscaped = true;
      } else if (char == quote) {
        quote = null;
      }
      continue;
    }
    if (char == '"' || char == "'") {
      quote = char;
      continue;
    }
    if (char == '(') {
      depth++;
    } else if (char == ')') {
      // Clamped, so a stray closing paren cannot drive the depth negative and
      // swallow every later top-level comma.
      depth = math.max(0, depth - 1);
    } else if (char == ',' && depth == 0) {
      return (before: input.substring(0, i), after: input.substring(i + 1));
    }
  }

  return null;
}

/// Parses a CSS `light-dark(light, dark)` expression into its two sides.
///
/// Returns `null` if [value] is not a `light-dark()` expression or does not
/// contain a top-level comma.
AstryxColorValue? parseLightDark(String value) {
  const prefix = 'light-dark(';
  final trimmed = value.trim();

  if (!trimmed.startsWith(prefix) || !trimmed.endsWith(')')) return null;

  final body = trimmed.substring(prefix.length, trimmed.length - 1);
  final split = splitTopLevelComma(body);
  if (split == null) return null;

  return AstryxColorValue(
    light: split.before.trim(),
    dark: split.after.trim(),
  );
}

/// Whether [value] is a `light-dark()` expression.
bool isLightDark(String value) {
  final trimmed = value.trim();
  return trimmed.startsWith('light-dark(') && trimmed.endsWith(')');
}
