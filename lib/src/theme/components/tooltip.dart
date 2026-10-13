/// Visual configuration for AstryxTooltip.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTooltip`.
///
/// The Material equivalent is `TooltipThemeData`, timings included: how long
/// a pointer must rest before a tooltip appears is as much a house style as
/// its colour.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own argument, then its `theme:`, then this
/// theme from the enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Slower, wider tooltips across the app.
/// const AstryxTooltipTheme(
///   waitDuration: Duration(milliseconds: 600),
///   maxWidth: 360,
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxTooltipTheme {
  /// Creates a tooltip theme.
  const AstryxTooltipTheme({
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.shadows,
    this.maxWidth,
    this.gap,
    this.waitDuration,
    this.exitDuration,
    this.showDuration,
  });

  /// The bubble fill, and the arrow's.
  ///
  /// Defaults to `--color-text-primary` — inverted, as upstream is.
  final Color? backgroundColor;

  /// The message style, merged over the body type role.
  ///
  /// The colour defaults to `--color-background-surface`, the other half of
  /// the inversion. Change it together with [backgroundColor].
  final TextStyle? textStyle;

  /// The space around the message.
  ///
  /// Defaults to `--spacing-2` inline and `--spacing-1` block.
  final EdgeInsetsGeometry? padding;

  /// The corner radius. Defaults to `--radius-container`.
  final BorderRadiusGeometry? borderRadius;

  /// The bubble's shadow. Defaults to `--shadow-low`.
  final List<AstryxShadow>? shadows;

  /// The widest the bubble may be before its text wraps. Defaults to 300.
  final double? maxWidth;

  /// The distance between the trigger and the bubble.
  ///
  /// Defaults to `--spacing-1`.
  final double? gap;

  /// How long a pointer must rest before the tooltip appears.
  ///
  /// Defaults to 200ms.
  final Duration? waitDuration;

  /// How long after the pointer leaves before the tooltip hides.
  ///
  /// Defaults to [Duration.zero].
  final Duration? exitDuration;

  /// How long a long-press tooltip stays after the finger lifts.
  ///
  /// Defaults to 1500ms.
  final Duration? showDuration;

  /// Returns a copy with the given fields replaced.
  AstryxTooltipTheme copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    List<AstryxShadow>? shadows,
    double? maxWidth,
    double? gap,
    Duration? waitDuration,
    Duration? exitDuration,
    Duration? showDuration,
  }) => AstryxTooltipTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    textStyle: textStyle ?? this.textStyle,
    padding: padding ?? this.padding,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    maxWidth: maxWidth ?? this.maxWidth,
    gap: gap ?? this.gap,
    waitDuration: waitDuration ?? this.waitDuration,
    exitDuration: exitDuration ?? this.exitDuration,
    showDuration: showDuration ?? this.showDuration,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxTooltipTheme merge(AstryxTooltipTheme? other) {
    if (other == null) return this;
    return AstryxTooltipTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      padding: other.padding ?? padding,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      maxWidth: other.maxWidth ?? maxWidth,
      gap: other.gap ?? gap,
      waitDuration: other.waitDuration ?? waitDuration,
      exitDuration: other.exitDuration ?? exitDuration,
      showDuration: other.showDuration ?? showDuration,
    );
  }

  /// Linearly interpolates between two tooltip themes.
  static AstryxTooltipTheme? lerp(
    AstryxTooltipTheme? a,
    AstryxTooltipTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxTooltipTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      textStyle: lerpTextStyle(a?.textStyle, b?.textStyle, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      maxWidth: lerpNullableDouble(a?.maxWidth, b?.maxWidth, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      waitDuration: lerpDuration(a?.waitDuration, b?.waitDuration, t),
      exitDuration: lerpDuration(a?.exitDuration, b?.exitDuration, t),
      showDuration: lerpDuration(a?.showDuration, b?.showDuration, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTooltipTheme &&
          other.backgroundColor == backgroundColor &&
          other.textStyle == textStyle &&
          other.padding == padding &&
          other.borderRadius == borderRadius &&
          deepEquals(other.shadows, shadows) &&
          other.maxWidth == maxWidth &&
          other.gap == gap &&
          other.waitDuration == waitDuration &&
          other.exitDuration == exitDuration &&
          other.showDuration == showDuration;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    textStyle,
    padding,
    borderRadius,
    deepHash(shadows),
    maxWidth,
    gap,
    waitDuration,
    exitDuration,
    showDuration,
  );
}
