/// The labelled button.
library;

import 'package:astryx_ui/src/components/action/button_group.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/button_surface.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/foundation/link_delegate.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:flutter/widgets.dart';

/// A labelled button.
///
/// {@tool snippet}
/// ```dart
/// AstryxButton(
///   label: 'Save changes',
///   variant: AstryxButtonVariant.primary,
///   onPressed: _save,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxIconButton`, for actions represented by an icon alone.
///  * [AstryxButtonGroup], for a row of related actions.
class AstryxButton extends StatelessWidget {
  /// Creates a button.
  const AstryxButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant,
    this.size,
    this.enabled = true,
    this.loading = false,
    this.leading,
    this.trailing,
    this.elevation = AstryxElevation.none,
    this.width,
    this.href,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  });

  /// {@template AstryxButton.label}
  /// The visible text describing the action.
  ///
  /// Also the accessible name.
  /// {@endtemplate}
  final String label;

  /// {@template AstryxButton.onPressed}
  /// Called when the button is activated, by pointer or keyboard.
  ///
  /// Null makes the button inert. To show an action in flight, keep the
  /// callback and set [loading].
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// {@template AstryxButton.variant}
  /// How prominent the button is.
  ///
  /// Null inherits from an enclosing [AstryxButtonGroup], falling back to
  /// [AstryxButtonVariant.secondary].
  /// {@endtemplate}
  final AstryxButtonVariant? variant;

  /// {@template AstryxButton.size}
  /// The control height.
  ///
  /// Null inherits from an enclosing [AstryxSizeScope] — so a `sm` group
  /// produces `sm` buttons — falling back to [AstryxButtonSize.md].
  /// {@endtemplate}
  final AstryxButtonSize? size;

  /// {@template AstryxButton.enabled}
  /// Whether the button accepts interaction.
  /// {@endtemplate}
  final bool enabled;

  /// {@template AstryxButton.loading}
  /// Whether an action is in flight.
  ///
  /// Replaces the leading content with a spinner, suppresses activation, and
  /// reports the button as disabled to assistive technology. The button keeps
  /// its width, so the surrounding layout does not jump.
  ///
  /// (Phrased without a `[leading]` link because this template is also used by
  /// `AstryxIconButton`, which has no such parameter.)
  /// {@endtemplate}
  final bool loading;

  /// {@template AstryxButton.leading}
  /// Content before the label — usually an `AstryxIcon`.
  /// {@endtemplate}
  final Widget? leading;

  /// {@template AstryxButton.trailing}
  /// Content after the label — an icon or a badge.
  /// {@endtemplate}
  final Widget? trailing;

  /// {@template AstryxButton.elevation}
  /// The resting shadow. Flat by default.
  /// {@endtemplate}
  final AstryxElevation elevation;

  /// {@template AstryxButton.width}
  /// A fixed width. Null lets the label decide.
  /// {@endtemplate}
  final double? width;

  /// {@template AstryxButton.href}
  /// A destination to follow instead of, or as well as, calling [onPressed].
  ///
  /// Handed to the [AstryxLinkDelegate], which the application supplies.
  /// Navigation is not this package's concern; the seam is.
  /// {@endtemplate}
  final Uri? href;

  /// {@template AstryxButton.focusNode}
  /// The focus node, if the caller owns one.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template AstryxButton.autofocus}
  /// Whether to take focus when first built.
  /// {@endtemplate}
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
      iconOnly: false,
    );

    final interactive = enabled && !loading;
    final l10n = AstryxLocalizations.of(context);

    return AstryxButtonSurface(
      style: style,
      semanticsLabel: loading ? '$label, ${l10n.buttonLoading}' : label,
      enabled: interactive,
      onPressed: onPressed == null && href == null
          ? null
          : () {
              onPressed?.call();
              final destination = href;
              if (destination != null) {
                AstryxLinkDelegate.of(context).followLink(destination);
              }
            },
      width: width,
      focusNode: focusNode,
      autofocus: autofocus,
      // The label is already the button's accessible name; letting the child
      // Text announce it too would have a reader say it twice.
      excludeChildSemantics: true,
      child: _ButtonContent(
        label: label,
        style: style,
        leading: leading,
        trailing: trailing,
        loading: loading,
      ),
    );
  }
}

/// The row of leading, label and trailing content.
class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.style,
    required this.loading,
    this.leading,
    this.trailing,
  });

  final String label;
  final ResolvedButtonStyle style;
  final bool loading;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // The spinner takes the leading slot. Sizing it to the icon size is what
    // keeps the button's width identical loading or not, so the layout around
    // it cannot jump.
    final leadingSlot = loading
        ? SizedBox.square(
            dimension: style.iconSize,
            child: AstryxSpinner(
              size: _spinnerSizeFor(style.iconSize),
              shade: AstryxSpinnerShade.inherit,
              color: style.foreground,
              // The button's own semantics already announce the wait; a second
              // live region here would say it twice.
              label: '',
            ),
          )
        : leading;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: style.gap,
      children: <Widget>[
        if (leadingSlot != null)
          IconTheme.merge(
            data: IconThemeData(
              color: style.foreground,
              size: style.iconSize,
            ),
            child: leadingSlot,
          ),
        Flexible(
          child: Text(
            label,
            style: style.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        if (trailing != null)
          IconTheme.merge(
            data: IconThemeData(
              color: style.foreground,
              size: style.iconSize,
            ),
            child: trailing!,
          ),
      ],
    );
  }

  /// The spinner step that fits an icon slot of [iconSize].
  static AstryxSpinnerSize _spinnerSizeFor(double iconSize) =>
      iconSize >= 20 ? AstryxSpinnerSize.lg : AstryxSpinnerSize.md;
}
