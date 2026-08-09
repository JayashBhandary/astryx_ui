/// CSS colour parsing and formatting.
///
/// A faithful port of upstream's `packages/core/src/utils/color.ts`, including
/// what it deliberately refuses. [parseColor] handles hex, `rgb()`/`rgba()` and
/// three named colours, and returns `null` for `var()`, `oklch()`,
/// `light-dark()`, `color-mix()` and unknown names — so callers can preserve
/// the original expression rather than guess at it.
///
/// The functions it refuses are resolved a layer up, by the theme resolver.
library;

import 'package:astryx_ui/src/theme/color/rgba.dart';

/// The named colours the design system relies on in token expressions.
///
/// Upstream carries exactly these three, not a full CSS colour table.
const Map<String, AstryxRgba> astryxNamedColors = <String, AstryxRgba>{
  'transparent': AstryxRgba.transparent,
  'black': AstryxRgba.black,
  'white': AstryxRgba.white,
};

/// Parses a leading decimal number the way JavaScript's `parseFloat` does.
///
/// Returns [double.nan] when no number is found. This matters for parity:
/// upstream calls `parseFloat('50%')` and expects `50`, whereas Dart's
/// `double.tryParse` requires the entire string to be numeric and would return
/// `null`.
double parseFloatLoose(String input) {
  final match = RegExp(
    r'^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?',
  ).firstMatch(input.trimLeft());
  if (match == null) return double.nan;
  return double.tryParse(match.group(0)!) ?? double.nan;
}

/// Expands a shorthand hex body (`rgb`/`rgba`) to its full form.
String _expandShorthand(String body) =>
    body.split('').map((c) => '$c$c').join();

final RegExp _hexBody = RegExp(r'^[0-9a-fA-F]+$');
final RegExp _rgbPrefix = RegExp(r'^rgba?\(', caseSensitive: false);
final RegExp _channelSeparator = RegExp(r'[\s,]+');

/// Parses a hex colour.
///
/// Accepts `#rgb`, `#rgba`, `#rrggbb` and `#rrggbbaa`, with or without the
/// leading `#`. Returns `null` for anything else.
AstryxRgba? parseHex(String hex) {
  final body = hex.trim().replaceFirst(RegExp('^#'), '');
  final normalized = body.length == 3 || body.length == 4
      ? _expandShorthand(body)
      : body;

  if (normalized.length != 6 && normalized.length != 8) return null;
  if (!_hexBody.hasMatch(normalized)) return null;

  return AstryxRgba(
    r: int.parse(normalized.substring(0, 2), radix: 16).toDouble(),
    g: int.parse(normalized.substring(2, 4), radix: 16).toDouble(),
    b: int.parse(normalized.substring(4, 6), radix: 16).toDouble(),
    a: normalized.length == 8
        ? int.parse(normalized.substring(6, 8), radix: 16) / 255
        : 1,
  );
}

/// Parses an `rgb()` / `rgba()` colour.
///
/// Accepts comma- or space-separated channels, an optional `/ alpha`, and
/// percentage channels. Returns `null` for anything else.
AstryxRgba? parseRgb(String value) {
  final open = value.indexOf('(');
  if (open == -1 || !value.trim().endsWith(')')) return null;

  final body = value
      .substring(open + 1, value.lastIndexOf(')'))
      .replaceAll('/', ' ');
  final parts = body
      .split(_channelSeparator)
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.length < 3) return null;

  double channel(String p) {
    final n = p.endsWith('%')
        ? (parseFloatLoose(p) / 100) * 255
        : parseFloatLoose(p);
    return clampDouble(n, 0, 255);
  }

  final r = channel(parts[0]);
  final g = channel(parts[1]);
  final b = channel(parts[2]);
  if (r.isNaN || g.isNaN || b.isNaN) return null;

  var a = 1.0;
  if (parts.length >= 4) {
    final raw = parts[3];
    a = raw.endsWith('%') ? parseFloatLoose(raw) / 100 : parseFloatLoose(raw);
    if (a.isNaN) return null;
    a = clampDouble(a, 0, 1);
  }

  return AstryxRgba(r: r, g: g, b: b, a: a);
}

/// Parses a concrete CSS colour string.
///
/// Supports hex, `rgb()`/`rgba()`, and the three named colours in
/// [astryxNamedColors]. Returns `null` for anything it cannot evaluate —
/// `var()`, `oklch()`, `light-dark()`, `color-mix()`, unknown names — so
/// callers can preserve the original expression rather than guessing.
AstryxRgba? parseColor(String value) {
  final trimmed = value.trim();

  final named = astryxNamedColors[trimmed.toLowerCase()];
  if (named != null) return named;

  if (trimmed.startsWith('#')) return parseHex(trimmed);
  if (_rgbPrefix.hasMatch(trimmed)) return parseRgb(trimmed);
  return null;
}

/// Formats RGB channels (0–255) as an uppercase `#RRGGBB` string.
String formatHex(double r, double g, double b) {
  String channel(double c) => clampDouble(
    c.roundToDouble(),
    0,
    255,
  ).toInt().toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${channel(r)}${channel(g)}${channel(b)}';
}

/// Serialises a colour to a compact, CSS-usable string.
///
/// `#RRGGBB` when fully opaque, otherwise `rgba(r, g, b, a)`.
String formatColor(AstryxRgba color) {
  if (color.a >= 1) return formatHex(color.r, color.g, color.b);

  int round(double n) => clampDouble(n.roundToDouble(), 0, 255).toInt();
  final alpha = double.parse(color.a.toStringAsFixed(4));

  return 'rgba(${round(color.r)}, ${round(color.g)}, ${round(color.b)}, '
      '${formatNumber(alpha)})';
}

/// Formats [value] the way JavaScript stringifies a number.
///
/// Dart renders `0.0` and `1.0` with a trailing `.0`; JavaScript renders `0`
/// and `1`. Upstream's `formatColor` output is compared verbatim in the parity
/// tests, so the difference is not cosmetic.
String formatNumber(double value) {
  if (value.isFinite && value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
