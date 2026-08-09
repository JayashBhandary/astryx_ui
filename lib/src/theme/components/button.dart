/// Visual configuration for buttons.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxButton` and `AstryxIconButton`.
///
/// States are **discrete named fields** — `backgroundColor`,
/// `hoverBackgroundColor`, `pressedBackgroundColor` — rather than a single
/// `WidgetStateProperty`. A consumer overriding one state should not have to
/// restate the others, and a resolver-valued field forces exactly that.
/// `flutter_shadcn_ui` reached the same conclusion.
///
/// Every field is nullable; null means "fall through to the token default".
///
/// {@tool snippet}
/// ```dart
/// // Square off every button, leaving its colours alone.
/// const AstryxButtonTheme(borderRadius: BorderRadius.zero);
/// ```
/// {@end-tool}
@immutable
class AstryxButtonTheme {
  /// Creates a button theme.
  const AstryxButtonTheme({
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.gap,
    this.textStyle,
    this.height,
    this.iconSize,
    this.shadows,
    this.disabledOpacity,
    this.pressedScale,
    this.mouseCursor,
    this.disabledMouseCursor,
  });

  /// The resting background.
  final Color? backgroundColor;

  /// The background while a pointer is over the button.
  ///
  /// Never applied in touch density — see `AstryxDensity.supportsHover`.
  final Color? hoverBackgroundColor;

  /// The background while the button is pressed.
  final Color? pressedBackgroundColor;

  /// The label and icon colour.
  final Color? foregroundColor;

  /// The border.
  final BorderSide? border;

  /// The corner radius. Defaults to `--radius-element`.
  final BorderRadiusGeometry? borderRadius;

  /// The inline padding either side of the label.
  final EdgeInsetsGeometry? padding;

  /// The gap between the leading icon, label and trailing content.
  final double? gap;

  /// The label's text style.
  final TextStyle? textStyle;

  /// The control height, overriding the size's own.
  final double? height;

  /// The leading and trailing icon size.
  final double? iconSize;

  /// The resting shadow.
  final List<AstryxShadow>? shadows;

  /// The opacity applied when disabled. Upstream uses 0.5.
  final double? disabledOpacity;

  /// The scale applied while pressed. Upstream uses 0.98.
  final double? pressedScale;

  /// The cursor over an enabled button.
  final MouseCursor? mouseCursor;

  /// The cursor over a disabled button.
  ///
  /// Upstream uses `not-allowed`, which is [SystemMouseCursors.forbidden].
  final MouseCursor? disabledMouseCursor;

  /// Returns a copy with the given fields replaced.
  AstryxButtonTheme copyWith({
    Color? backgroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? foregroundColor,
    BorderSide? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    double? gap,
    TextStyle? textStyle,
    double? height,
    double? iconSize,
    List<AstryxShadow>? shadows,
    double? disabledOpacity,
    double? pressedScale,
    MouseCursor? mouseCursor,
    MouseCursor? disabledMouseCursor,
  }) => AstryxButtonTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
    pressedBackgroundColor:
        pressedBackgroundColor ?? this.pressedBackgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    textStyle: textStyle ?? this.textStyle,
    height: height ?? this.height,
    iconSize: iconSize ?? this.iconSize,
    shadows: shadows ?? this.shadows,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    pressedScale: pressedScale ?? this.pressedScale,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    disabledMouseCursor: disabledMouseCursor ?? this.disabledMouseCursor,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxButtonTheme merge(AstryxButtonTheme? other) {
    if (other == null) return this;
    return AstryxButtonTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      hoverBackgroundColor: other.hoverBackgroundColor ?? hoverBackgroundColor,
      pressedBackgroundColor:
          other.pressedBackgroundColor ?? pressedBackgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      gap: other.gap ?? gap,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      height: other.height ?? height,
      iconSize: other.iconSize ?? iconSize,
      shadows: other.shadows ?? shadows,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
      pressedScale: other.pressedScale ?? pressedScale,
      mouseCursor: other.mouseCursor ?? mouseCursor,
      disabledMouseCursor: other.disabledMouseCursor ?? disabledMouseCursor,
    );
  }

  /// Linearly interpolates between two button themes.
  static AstryxButtonTheme? lerp(
    AstryxButtonTheme? a,
    AstryxButtonTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxButtonTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      hoverBackgroundColor: lerpColor(
        a?.hoverBackgroundColor,
        b?.hoverBackgroundColor,
        t,
      ),
      pressedBackgroundColor: lerpColor(
        a?.pressedBackgroundColor,
        b?.pressedBackgroundColor,
        t,
      ),
      foregroundColor: lerpColor(a?.foregroundColor, b?.foregroundColor, t),
      border: lerpBorderSide(a?.border, b?.border, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      textStyle: lerpTextStyle(a?.textStyle, b?.textStyle, t),
      height: lerpNullableDouble(a?.height, b?.height, t),
      iconSize: lerpNullableDouble(a?.iconSize, b?.iconSize, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      disabledOpacity: lerpNullableDouble(
        a?.disabledOpacity,
        b?.disabledOpacity,
        t,
      ),
      pressedScale: lerpNullableDouble(a?.pressedScale, b?.pressedScale, t),
      mouseCursor: lerpDiscrete(a?.mouseCursor, b?.mouseCursor, t),
      disabledMouseCursor: lerpDiscrete(
        a?.disabledMouseCursor,
        b?.disabledMouseCursor,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxButtonTheme &&
          other.backgroundColor == backgroundColor &&
          other.hoverBackgroundColor == hoverBackgroundColor &&
          other.pressedBackgroundColor == pressedBackgroundColor &&
          other.foregroundColor == foregroundColor &&
          other.border == border &&
          other.borderRadius == borderRadius &&
          other.padding == padding &&
          other.gap == gap &&
          other.textStyle == textStyle &&
          other.height == height &&
          other.iconSize == iconSize &&
          deepEquals(other.shadows, shadows) &&
          other.disabledOpacity == disabledOpacity &&
          other.pressedScale == pressedScale &&
          other.mouseCursor == mouseCursor &&
          other.disabledMouseCursor == disabledMouseCursor;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    backgroundColor,
    hoverBackgroundColor,
    pressedBackgroundColor,
    foregroundColor,
    border,
    borderRadius,
    padding,
    gap,
    textStyle,
    height,
    iconSize,
    deepHash(shadows),
    disabledOpacity,
    pressedScale,
    mouseCursor,
    disabledMouseCursor,
  ]);
}
