/// `light-dark()` parsing, and the CSS value splitting it is built on.
///
/// Ports the `splitTopLevelComma` and `parseLightDark` helpers from upstream's
/// `packages/core/src/theme/tokens.ts`. They live in Layer 0 because they are
/// pure string work with no theme knowledge; the resolver that follows `var()`
/// references and evaluates `color-mix()` is Phase 2.
///
/// [splitTopLevelCommas] and [splitTopLevelSpaces] have no upstream
/// counterpart. They exist because a compound token value — a shadow list —
/// has to be taken apart the same depth-aware way, and Layer 2 should not
/// reinvent the bracket tracking.
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

/// Splits [input] on *every* top-level comma, not just the first.
///
/// Bracket depth and quoting are tracked exactly as [splitTopLevelComma] does,
/// so `0 1px 2px rgba(0, 0, 0, .1), 0 2px 8px rgba(0, 0, 0, .1)` yields the two
/// shadows rather than six fragments. Parts are trimmed; empty ones are
/// dropped, so a trailing comma is tolerated.
List<String> splitTopLevelCommas(String input) {
  final parts = <String>[];
  var rest = input;

  while (true) {
    final split = splitTopLevelComma(rest);
    if (split == null) break;
    parts.add(split.before.trim());
    rest = split.after;
  }
  parts.add(rest.trim());

  return parts.where((p) => p.isNotEmpty).toList();
}

/// Splits [input] on runs of top-level whitespace.
///
/// Whitespace inside brackets or quotes does not split, so
/// `inset 0px 0px 0px 2px light-dark(rgba(5, 54, 89, 0.15), #FFF)` yields six
/// parts, the last being the whole `light-dark(...)` expression.
List<String> splitTopLevelSpaces(String input) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  String? quote;
  var isEscaped = false;

  void flush() {
    if (buffer.isNotEmpty) {
      parts.add(buffer.toString());
      buffer.clear();
    }
  }

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    if (quote != null) {
      buffer.write(char);
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
      buffer.write(char);
      continue;
    }
    if (char == '(') {
      depth++;
    } else if (char == ')') {
      depth = math.max(0, depth - 1);
    } else if (depth == 0 && char.trim().isEmpty) {
      flush();
      continue;
    }
    buffer.write(char);
  }
  flush();

  return parts;
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
