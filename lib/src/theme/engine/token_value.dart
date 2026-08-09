/// The value a theme author writes for a token.
///
/// A port of upstream's `TokenValue` union,
/// `string | [light: string, dark: string]`.
library;

import 'package:meta/meta.dart';

/// A token value: either one CSS string, or a light/dark pair.
///
/// A pair becomes `light-dark(light, dark)` when the theme is created. The
/// original pair is kept on the defined theme so consumers that need the two
/// halves — chart configuration, canvas painting — get them without parsing a
/// `light-dark()` string back apart.
///
/// {@tool snippet}
/// ```dart
/// const AstryxTokenValue('#0064E0');
/// const AstryxTokenValue.lightDark('#0064E0', '#2694FE');
/// ```
/// {@end-tool}
@immutable
class AstryxTokenValue {
  /// Creates a token value that is the same in both modes.
  const AstryxTokenValue(this.light) : dark = null;

  /// Creates a token value with distinct light and dark halves.
  const AstryxTokenValue.lightDark(this.light, String this.dark);

  /// The value, or the light half of a pair.
  final String light;

  /// The dark half of a pair, or null when the value is mode-independent.
  final String? dark;

  /// Whether this value carries distinct light and dark halves.
  bool get isPair => dark != null;

  /// The CSS string form: the value itself, or `light-dark(light, dark)`.
  String get css => dark == null ? light : 'light-dark($light, $dark)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTokenValue && other.light == light && other.dark == dark;

  @override
  int get hashCode => Object.hash(light, dark);

  @override
  String toString() => 'AstryxTokenValue($css)';
}
