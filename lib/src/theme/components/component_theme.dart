/// The shared shape of a per-widget theme, and the helpers it is built from.
///
/// Every widget gets one immutable `AstryxXTheme` carrying only that widget's
/// overridable visual properties, every field nullable — null meaning "fall
/// through to the token default". Resolution is always
/// `widget property ▸ inherited component theme ▸ token default`.
///
/// The classes are hand-written from a fixed template rather than generated
/// (ADR-004). This library is what makes that cheap: the template is small
/// because the fiddly parts — null-aware merging, list and map interpolation,
/// deep equality — live here and are written once.
///
/// See `02-CONVENTIONS.md` §6 for the template itself.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

// There is deliberately no `AstryxComponentTheme` supertype. `merge`,
// `copyWith` and `lerp` are all covariant in the implementing type, so a
// supertype could only declare them as accepting and returning the base type —
// losing exactly the type safety the per-widget classes exist for. The shared
// shape is enforced by the template in `02-CONVENTIONS.md` §6 and by review,
// and the helpers below are what make following it cheap.

/// Returns [a] when [t] is below the halfway point, otherwise [b].
///
/// The honest interpolation for a value that cannot be blended — an enum, a
/// bool, a callback, a shape. Snapping at the midpoint is what Flutter's own
/// theme classes do for the same case.
T? lerpDiscrete<T>(T? a, T? b, double t) => t < 0.5 ? a : b;

/// Interpolates two nullable doubles.
///
/// Unlike `lerpDouble`, a null on one side is treated as *absent* rather than
/// as zero: interpolating an unset padding towards 8 should not start from 0
/// and grow, it should snap once the destination is more than half arrived.
double? lerpNullableDouble(double? a, double? b, double t) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return a + (b - a) * t;
}

/// Interpolates two nullable [EdgeInsetsGeometry] values.
EdgeInsetsGeometry? lerpInsets(
  EdgeInsetsGeometry? a,
  EdgeInsetsGeometry? b,
  double t,
) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return EdgeInsetsGeometry.lerp(a, b, t);
}

/// Interpolates two nullable [BorderRadiusGeometry] values.
BorderRadiusGeometry? lerpRadius(
  BorderRadiusGeometry? a,
  BorderRadiusGeometry? b,
  double t,
) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return BorderRadiusGeometry.lerp(a, b, t);
}

/// Interpolates two nullable [Color] values.
///
/// A null side is treated as absent, not as transparent: fading an unset
/// colour through transparency would show a ghost of the wrong colour.
Color? lerpColor(Color? a, Color? b, double t) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return Color.lerp(a, b, t);
}

/// Interpolates two nullable [TextStyle] values.
TextStyle? lerpTextStyle(TextStyle? a, TextStyle? b, double t) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return TextStyle.lerp(a, b, t);
}

/// Interpolates two nullable [BorderSide] values.
BorderSide? lerpBorderSide(BorderSide? a, BorderSide? b, double t) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return BorderSide.lerp(a, b, t);
}

/// Interpolates two nullable shadow lists.
List<AstryxShadow>? lerpShadows(
  List<AstryxShadow>? a,
  List<AstryxShadow>? b,
  double t,
) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return AstryxShadow.lerpList(a, b, t);
}

/// Interpolates two nullable [Duration] values.
Duration? lerpDuration(Duration? a, Duration? b, double t) {
  if (a == null || b == null) return lerpDiscrete(a, b, t);
  return Duration(
    microseconds: (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t)
        .round(),
  );
}

/// Whether two nullable collections are deeply equal.
///
/// Use for any collection field in a theme's `==`; `List` and `Map` compare by
/// identity otherwise, which would make two equal themes unequal and defeat
/// `updateShouldNotify`.
bool deepEquals(Object? a, Object? b) =>
    const DeepCollectionEquality().equals(a, b);

/// A deep hash for a nullable collection, pairing with [deepEquals].
int deepHash(Object? value) => const DeepCollectionEquality().hash(value);

/// Merges two nullable maps, with [other]'s entries winning.
///
/// Returns null only when both sides are null, so an all-null theme stays
/// all-null and keeps falling through to the token defaults.
Map<K, V>? mergeMaps<K, V>(Map<K, V>? base, Map<K, V>? other) {
  if (base == null) return other;
  if (other == null) return base;
  return <K, V>{...base, ...other};
}
