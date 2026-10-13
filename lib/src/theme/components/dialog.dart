/// Visual configuration for AstryxDialog and AstryxAlertDialog.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxDialog` and `AstryxAlertDialog`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Square, flat dialogs over a darker scrim.
/// const AstryxDialogTheme(
///   borderRadius: BorderRadius.zero,
///   shadows: <AstryxShadow>[],
///   scrimColor: Color(0xCC000000),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxDialogTheme {
  /// Creates a dialog theme.
  const AstryxDialogTheme({
    this.backgroundColor,
    this.scrimColor,
    this.borderRadius,
    this.border,
    this.shadows,
    this.padding,
    this.maxWidth,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.titleGap,
    this.actionsGap,
  });

  /// The panel fill. Defaults to `--color-background-surface`.
  final Color? backgroundColor;

  /// The barrier colour behind the dialog. Defaults to `--color-overlay`.
  final Color? scrimColor;

  /// The panel's corner radius. Defaults to `--radius-container`.
  final BorderRadiusGeometry? borderRadius;

  /// The panel's hairline border.
  ///
  /// Defaults to `--color-border` at `--border-width`. [BorderSide.none]
  /// drops it.
  final BorderSide? border;

  /// The panel's elevation. Defaults to `--shadow-high`.
  ///
  /// Inset layers are not drawn.
  final List<AstryxShadow>? shadows;

  /// The inset between the panel's edges and its header, body and footer.
  ///
  /// The header takes every side but the bottom and the footer every side but
  /// the top, so the gaps between the three are not doubled. Defaults to
  /// `--spacing-4` on every side.
  final EdgeInsetsGeometry? padding;

  /// The panel's width when the widget sets none.
  ///
  /// Defaults to 480 for a dialog and 420 for an alert dialog. It never
  /// exceeds the viewport minus its padding.
  final double? maxWidth;

  /// Applied over the title's resolved style.
  final TextStyle? titleTextStyle;

  /// Applied over the description's resolved style — a dialog's supporting
  /// line, or an alert dialog's description.
  final TextStyle? descriptionTextStyle;

  /// The gap between the title and the description. Defaults to `--spacing-1`.
  final double? titleGap;

  /// The gap between an alert dialog's buttons. Defaults to `--spacing-2`.
  final double? actionsGap;

  /// Returns a copy with the given fields replaced.
  AstryxDialogTheme copyWith({
    Color? backgroundColor,
    Color? scrimColor,
    BorderRadiusGeometry? borderRadius,
    BorderSide? border,
    List<AstryxShadow>? shadows,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
    TextStyle? titleTextStyle,
    TextStyle? descriptionTextStyle,
    double? titleGap,
    double? actionsGap,
  }) => AstryxDialogTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    scrimColor: scrimColor ?? this.scrimColor,
    borderRadius: borderRadius ?? this.borderRadius,
    border: border ?? this.border,
    shadows: shadows ?? this.shadows,
    padding: padding ?? this.padding,
    maxWidth: maxWidth ?? this.maxWidth,
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
    titleGap: titleGap ?? this.titleGap,
    actionsGap: actionsGap ?? this.actionsGap,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// Text styles merge rather than replace, so a theme that sets only a
  /// colour keeps the size and weight set further out.
  AstryxDialogTheme merge(AstryxDialogTheme? other) {
    if (other == null) return this;
    return AstryxDialogTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      scrimColor: other.scrimColor ?? scrimColor,
      borderRadius: other.borderRadius ?? borderRadius,
      border: other.border ?? border,
      shadows: other.shadows ?? shadows,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
      titleTextStyle:
          titleTextStyle?.merge(other.titleTextStyle) ?? other.titleTextStyle,
      descriptionTextStyle:
          descriptionTextStyle?.merge(other.descriptionTextStyle) ??
          other.descriptionTextStyle,
      titleGap: other.titleGap ?? titleGap,
      actionsGap: other.actionsGap ?? actionsGap,
    );
  }

  /// Linearly interpolates between two dialog themes.
  static AstryxDialogTheme? lerp(
    AstryxDialogTheme? a,
    AstryxDialogTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxDialogTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      scrimColor: lerpColor(a?.scrimColor, b?.scrimColor, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      border: lerpBorderSide(a?.border, b?.border, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      maxWidth: lerpNullableDouble(a?.maxWidth, b?.maxWidth, t),
      titleTextStyle: lerpTextStyle(a?.titleTextStyle, b?.titleTextStyle, t),
      descriptionTextStyle: lerpTextStyle(
        a?.descriptionTextStyle,
        b?.descriptionTextStyle,
        t,
      ),
      titleGap: lerpNullableDouble(a?.titleGap, b?.titleGap, t),
      actionsGap: lerpNullableDouble(a?.actionsGap, b?.actionsGap, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxDialogTheme &&
          other.backgroundColor == backgroundColor &&
          other.scrimColor == scrimColor &&
          other.borderRadius == borderRadius &&
          other.border == border &&
          deepEquals(other.shadows, shadows) &&
          other.padding == padding &&
          other.maxWidth == maxWidth &&
          other.titleTextStyle == titleTextStyle &&
          other.descriptionTextStyle == descriptionTextStyle &&
          other.titleGap == titleGap &&
          other.actionsGap == actionsGap;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    scrimColor,
    borderRadius,
    border,
    deepHash(shadows),
    padding,
    maxWidth,
    titleTextStyle,
    descriptionTextStyle,
    titleGap,
    actionsGap,
  );
}
