/// A single shadow from an Astryx shadow token.
library;

import 'package:flutter/widgets.dart';

/// One shadow layer, as CSS `box-shadow` describes it.
///
/// Flutter's [BoxShadow] cannot express an inset shadow, and five of Astryx's
/// eight shadow tokens are inset — the focus, selection and validation rings on
/// form controls. Dropping the distinction would silently render those as outer
/// shadows, which is why this type exists rather than [BoxShadow] alone.
///
/// [blurRadius] is already in Flutter's units. See
/// [astryxCssBlurToFlutterRadius] for why that is not the CSS number.
@immutable
class AstryxShadow {
  /// Creates a shadow layer.
  const AstryxShadow({
    required this.color,
    this.offset = Offset.zero,
    this.blurRadius = 0,
    this.spreadRadius = 0,
    this.inset = false,
  });

  /// The shadow colour, with the mode already selected.
  final Color color;

  /// The shadow's displacement.
  final Offset offset;

  /// The blur radius **in Flutter's units**, not CSS's.
  final double blurRadius;

  /// How far the shadow expands beyond the box before blurring.
  final double spreadRadius;

  /// Whether the shadow is drawn inside the box rather than outside it.
  ///
  /// Flutter has no built-in inset shadow. A component that receives one must
  /// paint it itself — typically as an inner stroke — and the components that
  /// use these tokens do exactly that.
  final bool inset;

  /// This shadow as a [BoxShadow].
  ///
  /// The [inset] flag is lost, because [BoxShadow] has nowhere to put it. Check
  /// [inset] before calling, or use [toBoxShadowOrNull].
  BoxShadow toBoxShadow() => BoxShadow(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
  );

  /// This shadow as a [BoxShadow], or null when it is [inset].
  BoxShadow? toBoxShadowOrNull() => inset ? null : toBoxShadow();

  /// Linearly interpolates between two shadows.
  ///
  /// Interpolating between an inset and an outer shadow is not meaningful, so
  /// the [inset] flag snaps at the halfway point rather than blending.
  static AstryxShadow? lerp(AstryxShadow? a, AstryxShadow? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) {
      return AstryxShadow(
        color: Color.lerp(b!.color.withAlpha(0), b.color, t)!,
        offset: b.offset * t,
        blurRadius: b.blurRadius * t,
        spreadRadius: b.spreadRadius * t,
        inset: b.inset,
      );
    }
    if (b == null) return lerp(b, a, 1 - t);

    return AstryxShadow(
      color: Color.lerp(a.color, b.color, t)!,
      offset: Offset.lerp(a.offset, b.offset, t)!,
      blurRadius: a.blurRadius + (b.blurRadius - a.blurRadius) * t,
      spreadRadius: a.spreadRadius + (b.spreadRadius - a.spreadRadius) * t,
      inset: t < 0.5 ? a.inset : b.inset,
    );
  }

  /// Linearly interpolates between two shadow lists.
  ///
  /// The shorter list is padded conceptually with nothing, so a list growing
  /// from two layers to three fades the third in.
  static List<AstryxShadow>? lerpList(
    List<AstryxShadow>? a,
    List<AstryxShadow>? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    final from = a ?? const <AstryxShadow>[];
    final to = b ?? const <AstryxShadow>[];
    final length = from.length > to.length ? from.length : to.length;

    return <AstryxShadow>[
      for (var i = 0; i < length; i++)
        AstryxShadow.lerp(
          i < from.length ? from[i] : null,
          i < to.length ? to[i] : null,
          t,
        )!,
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxShadow &&
          other.color == color &&
          other.offset == offset &&
          other.blurRadius == blurRadius &&
          other.spreadRadius == spreadRadius &&
          other.inset == inset;

  @override
  int get hashCode =>
      Object.hash(color, offset, blurRadius, spreadRadius, inset);

  @override
  String toString() =>
      'AstryxShadow(${inset ? 'inset ' : ''}$offset, blur $blurRadius, '
      'spread $spreadRadius, $color)';
}

/// Converts a CSS `box-shadow` blur radius to Flutter's [BoxShadow.blurRadius].
///
/// The two frameworks mean different things by "blur radius", and both define
/// themselves in terms of a Gaussian standard deviation:
///
///  * CSS: a blur radius `B` blurs with a Gaussian of `sigma = B / 2`.
///  * Flutter: `BoxShadow` blurs with
///    `sigma = blurRadius * 0.57735 + 0.5`, via `Shadow.convertRadiusToSigma`.
///
/// Setting the two equal and solving gives
/// `blurRadius = (B / 2 - 0.5) / 0.57735`, which is what this returns, clamped
/// at zero so a small CSS blur cannot produce a negative radius.
///
/// Measured against `Shadow.convertRadiusToSigma` — the function `BoxShadow`
/// itself calls — this reproduces the CSS sigma exactly, where the rough
/// `B / 2` convention noted in the phase plan does not:
///
/// | CSS blur | target sigma | this radius | sigma | `B / 2` sigma |
/// | --- | --- | --- | --- | --- |
/// | 2 | 1.0 | 0.87 | 1.0 | 1.08 |
/// | 4 | 2.0 | 2.60 | 2.0 | 1.65 |
/// | 8 | 4.0 | 6.06 | 4.0 | 2.81 |
/// | 24 | 12.0 | 19.92 | 12.0 | 7.43 |
///
/// `B / 2` is roughly 30% too tight by the time the blur matters, and the error
/// grows with the blur.
///
/// One case cannot be represented: `Shadow.convertRadiusToSigma` returns 0 at a
/// radius of 0 and jumps to 0.5 for anything above it, so a CSS blur of 1 —
/// target sigma 0.5 — has no exact Flutter radius. It converts to 0, giving a
/// crisp edge instead of a half-pixel blur. No Astryx token is affected: the
/// smallest blur in the token set is 1px, on `--shadow-low`'s first layer,
/// where the difference is invisible beneath the second layer's 8px blur.
double astryxCssBlurToFlutterRadius(double cssBlurRadius) {
  if (cssBlurRadius <= 0) return 0;
  final radius = (cssBlurRadius / 2 - 0.5) / 0.57735;
  return radius < 0 ? 0 : radius;
}
