import 'package:meta/meta.dart';

/// A token value that differs between light and dark mode.
///
/// Astryx expresses these as CSS `light-dark(light, dark)` and lets the cascade
/// pick a side. Flutter has no cascade, so the pair is carried explicitly and
/// resolved once, when `AstryxThemeData` is built.
///
/// Values are kept as raw strings rather than parsed colours because not every
/// `light-dark()` holds a colour — shadows and other compound values use it
/// too.
@immutable
class AstryxColorValue {
  /// Creates a light/dark pair.
  const AstryxColorValue({required this.light, required this.dark});

  /// Creates a pair whose two sides are the same value.
  const AstryxColorValue.same(String value) : light = value, dark = value;

  /// The value used in light mode.
  final String light;

  /// The value used in dark mode.
  final String dark;

  /// Whether both sides are identical.
  bool get isUniform => light == dark;

  /// The value for [brightnessIsDark].
  String resolve({required bool brightnessIsDark}) =>
      brightnessIsDark ? dark : light;

  /// Returns a copy with the given sides replaced.
  AstryxColorValue copyWith({String? light, String? dark}) =>
      AstryxColorValue(light: light ?? this.light, dark: dark ?? this.dark);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxColorValue && other.light == light && other.dark == dark;

  @override
  int get hashCode => Object.hash(light, dark);

  @override
  String toString() => isUniform
      ? 'AstryxColorValue.same($light)'
      : 'AstryxColorValue(light: $light, dark: $dark)';
}
