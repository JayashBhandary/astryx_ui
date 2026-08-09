/// Iconography.
library;

import 'package:astryx_ui/src/foundation/rtl.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/icon.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The size steps an icon can take.
///
/// Expressed in `rem` upstream so icons scale with the root font size; the
/// figures below are that computation at the 16px root, which is what
/// `AstryxThemeData` resolves against.
enum AstryxIconSize {
  /// 12px. Beside `supporting` text.
  xsm(0.75),

  /// 16px. Beside `body` text.
  sm(1),

  /// 20px. The default — beside `large` text or alone in a control.
  md(1.25),

  /// 24px. Prominent, or alone in a large control.
  lg(1.5);

  const AstryxIconSize(this.rem);

  /// The size in `rem`, against the 16px root.
  final double rem;

  /// The size in logical pixels.
  double get pixels => rem * 16;
}

/// The semantic colour of an icon.
enum AstryxIconColor {
  /// Default icon colour.
  primary(AstryxColorToken.iconPrimary),

  /// De-emphasised.
  secondary(AstryxColorToken.iconSecondary),

  /// Further de-emphasised.
  ///
  /// Upstream maps this to the same token as [secondary]; it stays distinct so
  /// a theme can separate them without a breaking change.
  tertiary(AstryxColorToken.iconSecondary),

  /// In a disabled control.
  disabled(AstryxColorToken.iconDisabled),

  /// Accent-coloured.
  accent(AstryxColorToken.accent),

  /// A successful outcome.
  success(AstryxColorToken.success),

  /// A failed outcome.
  error(AstryxColorToken.error),

  /// A caution.
  warning(AstryxColorToken.warning),

  /// Inherit from the enclosing [DefaultTextStyle].
  ///
  /// For an icon inside a control that has already chosen a colour — a button
  /// label, an inverted banner.
  inherit(null);

  const AstryxIconColor(this.token);

  /// The colour token, or null for [inherit].
  final AstryxColorToken? token;
}

/// Renders a semantic icon from the theme's registry.
///
/// A component asks for a *purpose* — [AstryxIconName.close] — and the theme
/// decides what that looks like. Nothing above this layer names a glyph.
///
/// Directional icons mirror automatically under RTL; see [astryxMirroredIcons]
/// for which do and, just as importantly, which do not.
///
/// An icon is decorative by default and hidden from assistive technology,
/// because it almost always sits beside text that already says the same thing.
/// Give [label] only when the icon is the *sole* carrier of meaning — and then
/// prefer putting the label on the enclosing control instead.
///
/// {@tool snippet}
/// ```dart
/// const AstryxIcon(AstryxIconName.check);
///
/// const AstryxIcon(
///   AstryxIconName.warning,
///   color: AstryxIconColor.warning,
///   size: AstryxIconSize.sm,
/// );
/// ```
/// {@end-tool}
class AstryxIcon extends StatelessWidget {
  /// Creates an icon.
  const AstryxIcon(
    this.name, {
    super.key,
    this.size,
    this.color = AstryxIconColor.inherit,
    this.label,
    this.mirrorForRtl,
    this.theme,
  });

  /// {@template AstryxIcon.name}
  /// The semantic name, resolved through the theme's icon registry.
  /// {@endtemplate}
  final AstryxIconName name;

  /// {@template AstryxIcon.size}
  /// The size step.
  ///
  /// Null inherits from the enclosing [IconTheme], falling back to
  /// [AstryxIconSize.md]. That inheritance is what lets a control size the
  /// icons inside it — a button sets its icon size once and a plain
  /// `AstryxIcon` in its leading slot matches, so a loading spinner of the
  /// same size cannot shift the layout.
  /// {@endtemplate}
  final AstryxIconSize? size;

  /// {@template AstryxIcon.color}
  /// The semantic colour.
  /// {@endtemplate}
  final AstryxIconColor color;

  /// {@template AstryxIcon.label}
  /// An accessible name, for an icon that carries meaning alone.
  ///
  /// Leave null — the default — for a decorative icon, which is then hidden
  /// from assistive technology rather than announced as an unnamed image.
  /// {@endtemplate}
  final String? label;

  /// {@template AstryxIcon.mirrorForRtl}
  /// Overrides whether the glyph mirrors under RTL.
  ///
  /// Defaults to what [astryxShouldMirrorIcon] says for [name], which is
  /// almost always right. Override only for a custom registry whose glyph for
  /// a name points a different way.
  /// {@endtemplate}
  final bool? mirrorForRtl;

  /// Visual overrides for this icon, merged over [AstryxThemeData.icon].
  final AstryxIconTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final resolved = data.icon.merge(theme);
    final registry = AstryxTheme.iconsOf(context);

    final token = color.token;
    final resolvedColor =
        resolved.color ?? (token == null ? null : data.color(token));
    // Explicit size ▸ component theme ▸ ambient IconTheme ▸ the md default.
    final inherited = IconTheme.of(context).size;
    final baseSize =
        size?.pixels ?? resolved.size ?? inherited ?? AstryxIconSize.md.pixels;
    final resolvedSize = baseSize + (resolved.opticalSizeAdjustment ?? 0);

    // No `semanticLabel` here: the Semantics below owns the announcement, and
    // setting both would name the icon twice.
    Widget icon = Icon(
      registry.icon(name),
      size: resolvedSize,
      color: resolvedColor,
    );

    icon = AstryxMirrorForRtl(
      enabled: mirrorForRtl ?? astryxShouldMirrorIcon(name),
      child: icon,
    );

    if (label == null) return ExcludeSemantics(child: icon);
    return Semantics(label: label, image: true, child: icon);
  }
}
