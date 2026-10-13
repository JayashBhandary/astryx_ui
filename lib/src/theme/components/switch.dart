/// Visual configuration for AstryxSwitch.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxSwitch`.
///
/// The Material equivalent is `SwitchThemeData`. Hover tints are derived
/// from the track colours here, so overriding [activeTrackColor] retints the
/// hover state too. Dimensions apply at every `AstryxToggleSize`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // A wider, flatter switch with a dark thumb.
/// const AstryxSwitchTheme(
///   trackWidth: 48,
///   trackHeight: 24,
///   thumbColor: Color(0xFF212121),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxSwitchTheme {
  /// Creates a switch theme.
  const AstryxSwitchTheme({
    this.trackColor,
    this.activeTrackColor,
    this.thumbColor,
    this.trackWidth,
    this.trackHeight,
    this.trackPadding,
    this.thumbSize,
    this.activeThumbSize,
    this.disabledOpacity,
  });

  /// The track when off. Defaults to `--color-background-gray`.
  final Color? trackColor;

  /// The track when on, and the thumb's loading spinner.
  ///
  /// Defaults to `--color-accent`.
  final Color? activeTrackColor;

  /// The thumb. Defaults to `--color-background-surface`.
  final Color? thumbColor;

  /// The track's outer width. Defaults to 32 at `sm` and 40 at `md`.
  final double? trackWidth;

  /// The track's outer height. Defaults to 20 at `sm` and 24 at `md`.
  final double? trackHeight;

  /// The inset between the track's edge and the thumb.
  ///
  /// Defaults to 2 at `sm` and 4 at `md`.
  final double? trackPadding;

  /// The thumb's diameter when off. Defaults to 14 at `sm` and 16 at `md`.
  final double? thumbSize;

  /// The thumb's diameter when on. Defaults to 16 at `sm` and 20 at `md`.
  ///
  /// The growth is what makes the on state legible without relying on the
  /// track colour alone.
  final double? activeThumbSize;

  /// The opacity of a disabled switch. Defaults to 0.5.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  AstryxSwitchTheme copyWith({
    Color? trackColor,
    Color? activeTrackColor,
    Color? thumbColor,
    double? trackWidth,
    double? trackHeight,
    double? trackPadding,
    double? thumbSize,
    double? activeThumbSize,
    double? disabledOpacity,
  }) => AstryxSwitchTheme(
    trackColor: trackColor ?? this.trackColor,
    activeTrackColor: activeTrackColor ?? this.activeTrackColor,
    thumbColor: thumbColor ?? this.thumbColor,
    trackWidth: trackWidth ?? this.trackWidth,
    trackHeight: trackHeight ?? this.trackHeight,
    trackPadding: trackPadding ?? this.trackPadding,
    thumbSize: thumbSize ?? this.thumbSize,
    activeThumbSize: activeThumbSize ?? this.activeThumbSize,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxSwitchTheme merge(AstryxSwitchTheme? other) {
    if (other == null) return this;
    return AstryxSwitchTheme(
      trackColor: other.trackColor ?? trackColor,
      activeTrackColor: other.activeTrackColor ?? activeTrackColor,
      thumbColor: other.thumbColor ?? thumbColor,
      trackWidth: other.trackWidth ?? trackWidth,
      trackHeight: other.trackHeight ?? trackHeight,
      trackPadding: other.trackPadding ?? trackPadding,
      thumbSize: other.thumbSize ?? thumbSize,
      activeThumbSize: other.activeThumbSize ?? activeThumbSize,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
    );
  }

  /// Linearly interpolates between two switch themes.
  static AstryxSwitchTheme? lerp(
    AstryxSwitchTheme? a,
    AstryxSwitchTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxSwitchTheme(
      trackColor: lerpColor(a?.trackColor, b?.trackColor, t),
      activeTrackColor: lerpColor(a?.activeTrackColor, b?.activeTrackColor, t),
      thumbColor: lerpColor(a?.thumbColor, b?.thumbColor, t),
      trackWidth: lerpNullableDouble(a?.trackWidth, b?.trackWidth, t),
      trackHeight: lerpNullableDouble(a?.trackHeight, b?.trackHeight, t),
      trackPadding: lerpNullableDouble(a?.trackPadding, b?.trackPadding, t),
      thumbSize: lerpNullableDouble(a?.thumbSize, b?.thumbSize, t),
      activeThumbSize: lerpNullableDouble(
        a?.activeThumbSize,
        b?.activeThumbSize,
        t,
      ),
      disabledOpacity: lerpNullableDouble(
        a?.disabledOpacity,
        b?.disabledOpacity,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxSwitchTheme &&
          other.trackColor == trackColor &&
          other.activeTrackColor == activeTrackColor &&
          other.thumbColor == thumbColor &&
          other.trackWidth == trackWidth &&
          other.trackHeight == trackHeight &&
          other.trackPadding == trackPadding &&
          other.thumbSize == thumbSize &&
          other.activeThumbSize == activeThumbSize &&
          other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    trackColor,
    activeTrackColor,
    thumbColor,
    trackWidth,
    trackHeight,
    trackPadding,
    thumbSize,
    activeThumbSize,
    disabledOpacity,
  );
}
