/// Section headings.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/text.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';

/// The display sizes a heading can take instead of its level's own size.
///
/// Upstream's `type` prop. These continue the scale *above* h1, for a page
/// title or a hero. The level — and so the semantics — is unchanged.
enum AstryxHeadingType {
  /// The largest display size.
  display1(AstryxTypeRole.display1),

  /// The middle display size.
  display2(AstryxTypeRole.display2),

  /// The smallest display size, nearest h1.
  display3(AstryxTypeRole.display3);

  const AstryxHeadingType(this.role);

  /// The type-scale role this maps onto.
  final AstryxTypeRole role;
}

/// A section heading, levels 1 through 6.
///
/// The level drives both the visual size and the accessible heading level, so
/// the two cannot drift. Where a design needs a size that does not match the
/// document outline, keep the correct [level] and set [type] to a display size,
/// or override [accessibilityLevel] — never reach for a different level to get
/// a different size.
///
/// **The base anchor is h4, at 14px.** Astryx is a dense internal-tools system,
/// not a marketing site: h1 is three steps up from body copy, not ten. The
/// mapping is `h6 = -2, h5 = -1, h4 = 0, h3 = +1, h2 = +2, h1 = +3`.
///
/// {@tool snippet}
/// ```dart
/// const AstryxHeading('Billing', level: 2);
///
/// // A hero title that is still the page's h1.
/// const AstryxHeading(
///   'Welcome back',
///   level: 1,
///   type: AstryxHeadingType.display1,
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxText], for body copy and labels.
class AstryxHeading extends StatelessWidget {
  /// Creates a heading.
  const AstryxHeading(
    this.data, {
    super.key,
    this.level = 2,
    this.type,
    this.color = AstryxTextColor.primary,
    this.accessibilityLevel,
    this.justify,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.strikethrough = false,
    this.semanticsLabel,
    this.style,
    this.theme,
  }) : assert(level >= 1 && level <= 6, 'level must be 1–6');

  /// {@macro AstryxText.data}
  final String data;

  /// {@template AstryxHeading.level}
  /// The heading level, 1–6. Drives both size and semantics.
  /// {@endtemplate}
  final int level;

  /// {@template AstryxHeading.type}
  /// A display size to use instead of [level]'s own size.
  ///
  /// The semantic level is unaffected.
  /// {@endtemplate}
  final AstryxHeadingType? type;

  /// {@macro AstryxText.color}
  final AstryxTextColor color;

  /// {@template AstryxHeading.accessibilityLevel}
  /// Overrides the level announced to assistive technology.
  ///
  /// For the rare case where the visual hierarchy and the document outline
  /// genuinely differ — a card title that looks like an h3 but is an h2 in the
  /// page's structure. Prefer fixing the design.
  /// {@endtemplate}
  final int? accessibilityLevel;

  /// {@macro AstryxText.justify}
  final AstryxTextJustify? justify;

  /// {@macro AstryxText.maxLines}
  final int? maxLines;

  /// {@macro AstryxText.overflow}
  final TextOverflow? overflow;

  /// {@macro AstryxText.softWrap}
  final bool softWrap;

  /// {@macro AstryxText.strikethrough}
  final bool strikethrough;

  /// {@macro AstryxText.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro AstryxText.style}
  final TextStyle? style;

  /// Visual overrides for this heading, merged over [AstryxThemeData.heading].
  final AstryxTextTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final resolved = data.heading.merge(theme);
    final role = type?.role ?? AstryxTypeRole.heading(level);

    final style = resolveAstryxTextStyle(
      data: data,
      componentTheme: resolved,
      role: role,
      color: color,
      strikethrough: strikethrough,
      style: this.style,
    );

    return Semantics(
      header: true,
      headingLevel: accessibilityLevel ?? level,
      child: Text(
        this.data,
        style: style,
        textAlign: justify?.textAlign ?? resolved.justify,
        maxLines: maxLines,
        overflow:
            overflow ??
            (maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip),
        softWrap: softWrap,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
