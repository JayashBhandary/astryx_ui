/// The shared visual vocabulary of the button family.
///
/// `AstryxButton` and `AstryxIconButton` differ only in shape and in whether a
/// label is required, so variants, sizes, elevation and the resolution of all
/// three live here rather than being written twice.
library;

import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// How prominent a button is, and what it means.
enum AstryxButtonVariant {
  /// The single most important action in a view. Filled with the accent.
  primary,

  /// The default. A neutral fill that reads as an action without competing
  /// with [primary].
  secondary,

  /// Transparent until interacted with. For low-emphasis or repeated actions.
  ghost,

  /// An irreversible or destructive action. Filled with the error colour.
  destructive,
}

/// The control heights, from the `--size-element-*` tokens.
enum AstryxButtonSize {
  /// 28px. Dense toolbars and inline actions.
  sm(AstryxSizeToken.elementSm, AstryxElementSize.sm),

  /// 32px. The default.
  md(AstryxSizeToken.elementMd, AstryxElementSize.md),

  /// 36px. Prominent actions.
  lg(AstryxSizeToken.elementLg, AstryxElementSize.lg);

  const AstryxButtonSize(this.token, this.elementSize);

  /// The size token giving this button's height.
  final AstryxSizeToken token;

  /// The equivalent [AstryxElementSize], for the inherited size cascade.
  final AstryxElementSize elementSize;

  /// The button size matching an inherited [AstryxElementSize].
  static AstryxButtonSize fromElementSize(AstryxElementSize size) =>
      switch (size) {
        AstryxElementSize.sm => AstryxButtonSize.sm,
        AstryxElementSize.md => AstryxButtonSize.md,
        AstryxElementSize.lg => AstryxButtonSize.lg,
      };

  /// The icon size beside a label at this button size.
  ///
  /// 16px for `sm` and `md`, 20px for `lg` — upstream's own figures, which do
  /// not step in lockstep with the control height.
  double get iconSize => this == AstryxButtonSize.lg ? 20 : 16;
}

/// The resting shadow under a button.
enum AstryxElevation {
  /// Flat. The default.
  none(null),

  /// The lowest shadow step.
  low(AstryxShadowToken.low),

  /// The middle shadow step.
  med(AstryxShadowToken.med),

  /// The highest shadow step, for a floating action.
  high(AstryxShadowToken.high);

  const AstryxElevation(this.token);

  /// The shadow token, or null for [none].
  final AstryxShadowToken? token;
}

/// Every value a button needs to paint itself, already resolved.
///
/// Built once per build by [resolveAstryxButtonStyle], so the widget's own
/// `build` stays a composition of widgets rather than a pile of lookups.
@immutable
@internal
class ResolvedButtonStyle {
  /// Creates a resolved style.
  const ResolvedButtonStyle({
    required this.background,
    required this.hoverBackground,
    required this.pressedBackground,
    required this.foreground,
    required this.border,
    required this.borderRadius,
    required this.padding,
    required this.gap,
    required this.textStyle,
    required this.height,
    required this.iconSize,
    required this.shadows,
    required this.disabledOpacity,
    required this.pressedScale,
    required this.mouseCursor,
    required this.disabledMouseCursor,
  });

  /// The resting background.
  final Color background;

  /// The background under a pointer.
  final Color hoverBackground;

  /// The background while pressed.
  final Color pressedBackground;

  /// The label and icon colour.
  final Color foreground;

  /// The border, or null when there is none.
  final BorderSide? border;

  /// The corner radius.
  final BorderRadiusGeometry borderRadius;

  /// The inline padding.
  final EdgeInsetsGeometry padding;

  /// The gap between leading, label and trailing.
  final double gap;

  /// The label's style.
  final TextStyle textStyle;

  /// The control height.
  final double height;

  /// The icon size.
  final double iconSize;

  /// The resting shadow.
  final List<AstryxShadow> shadows;

  /// The opacity when disabled.
  final double disabledOpacity;

  /// The scale while pressed.
  final double pressedScale;

  /// The cursor when enabled.
  final MouseCursor mouseCursor;

  /// The cursor when disabled.
  final MouseCursor disabledMouseCursor;

  /// The background for the current interaction state.
  ///
  /// Precedence is pressed ▸ hovered ▸ resting, matching upstream's CSS
  /// ordering. Disabled is expressed by opacity rather than by a fourth
  /// colour, so it composes with any variant.
  Color backgroundFor({required bool hovered, required bool pressed}) {
    if (pressed) return pressedBackground;
    if (hovered) return hoverBackground;
    return background;
  }
}

/// Composites [overlay] onto [base], which is how upstream's hover and pressed
/// tints work.
///
/// Astryx paints `--color-overlay-hover` *over* the variant's own background
/// rather than naming a second colour, so one overlay token covers every
/// variant — including `ghost`, whose background is transparent.
Color _overlay(Color base, Color overlay) => Color.alphaBlend(overlay, base);

/// Resolves everything a button needs to paint.
@internal
ResolvedButtonStyle resolveAstryxButtonStyle({
  required AstryxThemeData data,
  required AstryxButtonTheme componentTheme,
  required AstryxButtonVariant variant,
  required AstryxButtonSize size,
  required AstryxElevation elevation,
  required bool iconOnly,
}) {
  final background =
      componentTheme.backgroundColor ??
      switch (variant) {
        AstryxButtonVariant.primary => data.color(AstryxColorToken.accent),
        AstryxButtonVariant.secondary => data.color(AstryxColorToken.neutral),
        // Transparent, not the surface colour: a ghost button must not
        // paint over whatever it sits on.
        AstryxButtonVariant.ghost => const Color(0x00000000),
        AstryxButtonVariant.destructive => data.color(AstryxColorToken.error),
      };

  final foreground =
      componentTheme.foregroundColor ??
      switch (variant) {
        AstryxButtonVariant.primary => data.color(AstryxColorToken.onAccent),
        AstryxButtonVariant.secondary => data.color(
          AstryxColorToken.textPrimary,
        ),
        AstryxButtonVariant.ghost => data.color(AstryxColorToken.textPrimary),
        AstryxButtonVariant.destructive => data.color(AstryxColorToken.onError),
      };

  final hoverOverlay = data.color(AstryxColorToken.overlayHover);
  final pressedOverlay = data.color(AstryxColorToken.overlayPressed);

  final horizontal = data.spacing(AstryxSpacingToken.spacing3);

  return ResolvedButtonStyle(
    background: background,
    hoverBackground:
        componentTheme.hoverBackgroundColor ??
        _overlay(background, hoverOverlay),
    pressedBackground:
        componentTheme.pressedBackgroundColor ??
        _overlay(background, pressedOverlay),
    foreground: foreground,
    border: componentTheme.border,
    borderRadius:
        componentTheme.borderRadius ??
        data.borderRadius(AstryxRadiusToken.element),
    padding:
        componentTheme.padding ??
        // An icon-only button is square, so its width comes from its height.
        (iconOnly
            ? EdgeInsets.zero
            : EdgeInsetsDirectional.symmetric(horizontal: horizontal)),
    gap: componentTheme.gap ?? data.spacing(AstryxSpacingToken.spacing2),
    textStyle: data
        .textStyle(AstryxTypeRole.body)
        .copyWith(
          color: foreground,
          fontWeight: data.fontWeight(AstryxFontWeightToken.medium),
        )
        .merge(componentTheme.textStyle),
    height: componentTheme.height ?? data.size(size.token),
    iconSize: componentTheme.iconSize ?? size.iconSize,
    shadows:
        componentTheme.shadows ??
        (elevation.token == null
            ? const <AstryxShadow>[]
            : data.shadow(elevation.token!)),
    disabledOpacity: componentTheme.disabledOpacity ?? 0.5,
    pressedScale: componentTheme.pressedScale ?? 0.98,
    mouseCursor: componentTheme.mouseCursor ?? SystemMouseCursors.click,
    disabledMouseCursor:
        componentTheme.disabledMouseCursor ?? SystemMouseCursors.forbidden,
  );
}
