/// Turning resolved token strings into Flutter values.
///
/// This is the whole of the string → Flutter conversion, gathered in one place
/// so `AstryxThemeData` reads as a lookup table rather than a parser. Every
/// function here takes a *resolved* token value: references followed, colour
/// functions evaluated. What it may still contain is a nested `light-dark()`,
/// because a compound value such as a shadow list is not itself a
/// `light-dark()` expression and so passes through the resolver untouched.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/light_dark.dart';
import 'package:astryx_ui/src/theme/color/oklch.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:flutter/widgets.dart';

/// The CSS root font size every `rem` value is measured against.
///
/// Upstream's `pxToRem` divides by 16, so reversing it here keeps the type
/// scale in the logical pixels the theme author wrote.
const double astryxRootFontSize = 16;

/// Selects the half of a `light-dark()` expression matching [mode].
///
/// A value that is not a `light-dark()` expression is returned unchanged, so
/// this is safe to apply to anything.
String selectMode(String value, AstryxThemeMode mode) {
  final pair = parseLightDark(value);
  if (pair == null) return value;
  return mode == AstryxThemeMode.dark ? pair.dark : pair.light;
}

/// Parses a CSS length to logical pixels.
///
/// Handles `px`, `rem`, a bare `0`, and a bare number. Returns null for
/// anything else — a percentage, a `calc()`, an empty string.
double? parseCssLength(
  String value, {
  double rootFontSize = astryxRootFontSize,
}) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  if (trimmed.endsWith('px')) {
    return double.tryParse(trimmed.substring(0, trimmed.length - 2).trim());
  }
  if (trimmed.endsWith('rem')) {
    final rem = double.tryParse(
      trimmed.substring(0, trimmed.length - 3).trim(),
    );
    return rem == null ? null : rem * rootFontSize;
  }
  if (trimmed.endsWith('em')) {
    // No Astryx token uses `em`, but a consumer override might. Treated as
    // relative to the root, which is correct wherever the parent size is the
    // root size and is the only interpretation available without context.
    final em = double.tryParse(trimmed.substring(0, trimmed.length - 2).trim());
    return em == null ? null : em * rootFontSize;
  }
  return double.tryParse(trimmed);
}

/// Parses a CSS colour to a Flutter [Color].
///
/// Resolves a `light-dark()` wrapper for [mode] first, then accepts hex,
/// `rgb()`/`rgba()`, the three named colours Astryx uses, and `oklch()` —
/// which appears inside shadow values in some themes. Returns null for
/// anything it cannot evaluate.
Color? parseCssColor(String value, AstryxThemeMode mode) {
  final selected = selectMode(value, mode).trim();
  final rgba = parseColor(selected) ?? parseOklch(selected);
  return rgba == null ? null : toFlutterColor(rgba);
}

/// Converts an [AstryxRgba] to a Flutter [Color].
///
/// Channels are 0–255 doubles upstream and stay fractional through
/// `color-mix()`, so they are rounded here rather than truncated.
Color toFlutterColor(AstryxRgba rgba) => Color.fromARGB(
  clampDouble(rgba.a * 255, 0, 255).round(),
  clampDouble(rgba.r, 0, 255).round(),
  clampDouble(rgba.g, 0, 255).round(),
  clampDouble(rgba.b, 0, 255).round(),
);

/// Parses a CSS time to a [Duration].
///
/// Handles `ms` and `s`. Sub-microsecond precision is rounded, since [Duration]
/// has no finer unit. Returns null if the value is not a time.
Duration? parseCssDuration(String value) {
  final trimmed = value.trim();

  if (trimmed.endsWith('ms')) {
    final ms = double.tryParse(trimmed.substring(0, trimmed.length - 2).trim());
    return ms == null ? null : Duration(microseconds: (ms * 1000).round());
  }
  if (trimmed.endsWith('s')) {
    final s = double.tryParse(trimmed.substring(0, trimmed.length - 1).trim());
    return s == null ? null : Duration(microseconds: (s * 1000000).round());
  }
  return null;
}

/// The CSS easing keywords, as their defining cubic-bezier curves.
const Map<String, Cubic> _easingKeywords = <String, Cubic>{
  'ease': Cubic(0.25, 0.1, 0.25, 1),
  'ease-in': Cubic(0.42, 0, 1, 1),
  'ease-out': Cubic(0, 0, 0.58, 1),
  'ease-in-out': Cubic(0.42, 0, 0.58, 1),
};

/// Parses a CSS easing function to a Flutter [Curve].
///
/// Handles `cubic-bezier(a, b, c, d)`, `linear`, and the four `ease*`
/// keywords. Returns null for `steps()` and anything unrecognised — no Astryx
/// token uses them.
Curve? parseCssCurve(String value) {
  final trimmed = value.trim().toLowerCase();
  if (trimmed == 'linear') return Curves.linear;

  final keyword = _easingKeywords[trimmed];
  if (keyword != null) return keyword;

  if (!trimmed.startsWith('cubic-bezier(') || !trimmed.endsWith(')')) {
    return null;
  }
  final body = trimmed.substring('cubic-bezier('.length, trimmed.length - 1);
  final parts = splitTopLevelCommas(body);
  if (parts.length != 4) return null;

  final values = parts.map((p) => double.tryParse(p.trim())).toList();
  if (values.any((v) => v == null)) return null;

  return Cubic(values[0]!, values[1]!, values[2]!, values[3]!);
}

/// Parses a CSS font weight to a Flutter [FontWeight].
///
/// Handles the numeric forms and the `normal` / `bold` keywords. Values are
/// clamped to 100–900 and snapped to the nearest hundred, because [FontWeight]
/// has only those nine steps. Returns null if the value is not a weight.
FontWeight? parseCssFontWeight(String value) {
  final trimmed = value.trim().toLowerCase();
  if (trimmed == 'normal') return FontWeight.w400;
  if (trimmed == 'bold') return FontWeight.w700;

  final numeric = double.tryParse(trimmed);
  if (numeric == null) return null;

  final step = (numeric / 100).round().clamp(1, 9);
  return FontWeight.values[step - 1];
}

/// Parses a CSS `box-shadow` list into shadow layers.
///
/// Each comma-separated layer is
/// `[inset] <x> <y> [blur] [spread] <color>`, in any order for the `inset`
/// keyword and the colour. Blur radii are converted to Flutter's units by
/// [astryxCssBlurToFlutterRadius].
///
/// A layer that cannot be parsed is skipped rather than throwing: a malformed
/// consumer override should cost that one shadow, not the whole theme.
List<AstryxShadow> parseCssShadows(String value, AstryxThemeMode mode) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'none') return const <AstryxShadow>[];

  final shadows = <AstryxShadow>[];
  for (final layer in splitTopLevelCommas(trimmed)) {
    final shadow = _parseShadowLayer(layer, mode);
    if (shadow != null) shadows.add(shadow);
  }
  return shadows;
}

AstryxShadow? _parseShadowLayer(String layer, AstryxThemeMode mode) {
  var inset = false;
  final lengths = <double>[];
  String? colorPart;

  for (final part in splitTopLevelSpaces(layer)) {
    if (part.toLowerCase() == 'inset') {
      inset = true;
      continue;
    }
    // A length only ever precedes the colour, so once the colour is found the
    // remaining parts cannot be lengths.
    if (colorPart == null) {
      final length = parseCssLength(part);
      if (length != null) {
        lengths.add(length);
        continue;
      }
    }
    colorPart ??= part;
  }

  if (lengths.length < 2 || colorPart == null) return null;
  final color = parseCssColor(colorPart, mode);
  if (color == null) return null;

  return AstryxShadow(
    color: color,
    offset: Offset(lengths[0], lengths[1]),
    blurRadius: lengths.length > 2
        ? astryxCssBlurToFlutterRadius(lengths[2])
        : 0,
    spreadRadius: lengths.length > 3 ? lengths[3] : 0,
    inset: inset,
  );
}
