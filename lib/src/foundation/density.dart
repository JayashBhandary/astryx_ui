/// The interaction density model.
library;

import 'package:flutter/widgets.dart';

/// How much room interactive elements are given, and whether hover
/// affordances are live.
///
/// Astryx targets internal tools on desktop: 28/32/36px control heights,
/// hover-revealed affordances, keyboard-first navigation. Those numbers sit
/// below every mobile touch-target guideline, and hover does not exist on
/// touch. "All platforms equally" is an architectural commitment, so this is
/// resolved once and inherited rather than re-decided per widget. See ADR-006.
///
/// Colour, radius and typography are identical across densities — only
/// ergonomics change, so a design stays recognisable everywhere.
///
/// Read it with `AstryxTheme.densityOf(context)`, which returns what the
/// enclosing theme resolved.
enum AstryxDensity {
  /// Mouse, trackpad or stylus. Astryx's native density: compact controls, and
  /// hover affordances are active.
  pointer,

  /// Touch. Controls grow to meet the 44px minimum tap target, and hover
  /// affordances are suppressed because there is no hover.
  touch;

  /// Whether hover affordances should be active.
  ///
  /// Gate every hover style on this rather than on the platform: a widget on a
  /// touch device must not offer a state the user cannot reach.
  bool get supportsHover => this == AstryxDensity.pointer;

  /// The minimum tap-target edge, in logical pixels.
  ///
  /// 48, the strictest of the three guidelines that apply — Apple's HIG and
  /// WCAG 2.5.5 both say 44, Material says 48. Meeting the strictest means one
  /// number satisfies every platform, rather than a control that passes on iOS
  /// and fails on Android. ADR-019.
  ///
  /// In [pointer] density there is no minimum beyond the control's own height,
  /// so this is zero.
  double get minimumTapTarget => this == AstryxDensity.touch ? 48 : 0;

  /// Resolves the density for [platform].
  ///
  /// iOS and Android are [touch]; macOS, Windows, Linux and Fuchsia are
  /// [pointer].
  ///
  /// [coarsePointer], when known, overrides the platform answer. This matters
  /// on the web, where the reported platform is the *host OS* rather than the
  /// input device — a Chromebook with a mouse attached reports Android, and a
  /// Windows tablet without one reports Windows.
  static AstryxDensity resolve(
    TargetPlatform platform, {
    bool? coarsePointer,
  }) {
    if (coarsePointer != null) {
      return coarsePointer ? AstryxDensity.touch : AstryxDensity.pointer;
    }
    return switch (platform) {
      TargetPlatform.iOS || TargetPlatform.android => AstryxDensity.touch,
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.fuchsia => AstryxDensity.pointer,
    };
  }
}
