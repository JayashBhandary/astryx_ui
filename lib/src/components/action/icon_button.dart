/// The icon-only button.
library;

import 'package:astryx_ui/src/components/action/button_group.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/button_surface.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/foundation/link_delegate.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:flutter/widgets.dart';

/// A square button carrying an icon alone.
///
/// [label] is **required** and becomes the accessible name. An unlabelled icon
/// button is invisible to a screen reader — it announces as "button" with
/// nothing to distinguish it from every other one on the page — and upstream's
/// own best-practice list calls this out.
///
/// {@tool snippet}
/// ```dart
/// AstryxIconButton(
///   icon: AstryxIconName.close,
///   label: 'Close',
///   onPressed: _dismiss,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxButton`, for actions with a visible label.
class AstryxIconButton extends StatelessWidget {
  /// Creates an icon button from a semantic icon name.
  const AstryxIconButton({
    required this.icon,
    required this.label,
    super.key,
    this.onPressed,
    this.variant,
    this.size,
    this.enabled = true,
    this.loading = false,
    this.elevation = AstryxElevation.none,
    this.href,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  }) : child = null;

  /// Creates an icon button from an arbitrary widget.
  ///
  /// For an avatar or a custom glyph. Prefer the default constructor, which
  /// goes through the icon registry and so follows the theme.
  const AstryxIconButton.custom({
    required Widget this.child,
    required this.label,
    super.key,
    this.onPressed,
    this.variant,
    this.size,
    this.enabled = true,
    this.loading = false,
    this.elevation = AstryxElevation.none,
    this.href,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  }) : icon = null;

  /// {@template AstryxIconButton.icon}
  /// The semantic icon name, resolved through the theme's registry.
  /// {@endtemplate}
  final AstryxIconName? icon;

  /// The custom content, for [AstryxIconButton.custom].
  final Widget? child;

  /// {@template AstryxIconButton.label}
  /// The accessible name. Required — see the class documentation.
  /// {@endtemplate}
  final String label;

  /// {@macro AstryxButton.onPressed}
  final VoidCallback? onPressed;

  /// {@macro AstryxButton.variant}
  final AstryxButtonVariant? variant;

  /// {@macro AstryxButton.size}
  final AstryxButtonSize? size;

  /// {@macro AstryxButton.enabled}
  final bool enabled;

  /// {@macro AstryxButton.loading}
  final bool loading;

  /// {@macro AstryxButton.elevation}
  final AstryxElevation elevation;

  /// {@macro AstryxButton.href}
  final Uri? href;

  /// {@template AstryxIconButton.tooltip}
  /// Text shown on hover, for sighted users.
  ///
  /// Not a substitute for [label]: the label is the button's accessible name
  /// and is always required. A tooltip repeats it for a sighted user who
  /// cannot tell what the glyph means.
  ///
  /// Wrapped in an `AstryxTooltip` with `excludeFromSemantics: true`, because
  /// the button already announces [label] and hearing it twice is worse than
  /// not hearing the tooltip at all.
  /// {@endtemplate}
  final String? tooltip;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  /// Visual overrides for this button, merged over [AstryxThemeData.button].
  final AstryxButtonTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final group = AstryxButtonGroupScope.maybeOf(context);
    final resolved = data.button.merge(group?.buttonTheme).merge(theme);

    final effectiveVariant =
        variant ?? group?.variant ?? AstryxButtonVariant.secondary;
    final effectiveSize =
        size ??
        AstryxButtonSize.fromElementSize(
          AstryxSizeScope.resolve(context, group?.size?.elementSize),
        );

    final style = resolveAstryxButtonStyle(
      data: data,
      componentTheme: resolved,
      variant: effectiveVariant,
      size: effectiveSize,
      elevation: elevation,
      iconOnly: true,
    );

    final interactive = enabled && !loading;

    final button = AstryxButtonSurface(
      style: style,
      semanticsLabel: label,
      enabled: interactive,
      squared: true,
      onPressed: onPressed == null && href == null
          ? null
          : () {
              onPressed?.call();
              final destination = href;
              if (destination != null) {
                AstryxLinkDelegate.of(context).followLink(destination);
              }
            },
      focusNode: focusNode,
      autofocus: autofocus,
      // The button owns the accessible name; the glyph must not add its own.
      excludeChildSemantics: true,
      child: Center(
        child: IconTheme.merge(
          data: IconThemeData(color: style.foreground, size: style.iconSize),
          child: child ?? AstryxIcon(icon!, size: _iconSizeFor(effectiveSize)),
        ),
      ),
    );

    final message = tooltip;
    if (message == null) return button;

    return AstryxTooltip(
      message: message,
      enabled: interactive,
      // The button's own `Semantics(label:)` already carries the name.
      excludeFromSemantics: true,
      child: button,
    );
  }

  /// The icon step matching a button size.
  ///
  /// `sm` and `md` both take the 16px step, `lg` the 20px one — upstream's own
  /// figures, which deliberately do not move in lockstep with control height.
  static AstryxIconSize _iconSizeFor(AstryxButtonSize size) =>
      size == AstryxButtonSize.lg ? AstryxIconSize.md : AstryxIconSize.sm;
}
