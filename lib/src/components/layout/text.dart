/// Body and label text.
library;

import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/text.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The semantic role a run of text plays.
///
/// Upstream's `type` prop. Choosing a role rather than a size is what keeps
/// typography consistent: the role decides size, weight, line height and family
/// together, and they stay in step when a theme changes the scale.
enum AstryxTextType {
  /// Default body copy.
  body(AstryxTypeRole.body),

  /// Body copy one step up, for emphasis.
  large(AstryxTypeRole.large),

  /// Form and control labels.
  label(AstryxTypeRole.label),

  /// Secondary copy — hints, captions, helper text.
  supporting(AstryxTypeRole.supporting),

  /// Inline and block code.
  code(AstryxTypeRole.code),

  /// The largest display size.
  display1(AstryxTypeRole.display1),

  /// The middle display size.
  display2(AstryxTypeRole.display2),

  /// The smallest display size.
  display3(AstryxTypeRole.display3);

  const AstryxTextType(this.role);

  /// The type-scale role this maps onto.
  final AstryxTypeRole role;
}

/// The semantic colour of a run of text.
///
/// Not a raw [Color]: a design system's job is to make the right colour the
/// easy one, and an arbitrary colour is almost always a mistake in body copy.
/// Use [AstryxText.style] to override deliberately.
enum AstryxTextColor {
  /// Default reading colour.
  primary(AstryxColorToken.textPrimary),

  /// De-emphasised text.
  secondary(AstryxColorToken.textSecondary),

  /// Text in a disabled control.
  disabled(AstryxColorToken.textDisabled),

  /// Placeholder text in an empty field.
  ///
  /// Upstream maps this to the same token as [secondary]; it stays a distinct
  /// name so a theme can separate them without a breaking change.
  placeholder(AstryxColorToken.textSecondary),

  /// Accent-coloured text, for links and emphasis.
  accent(AstryxColorToken.textAccent),

  /// Inherit from the enclosing [DefaultTextStyle].
  ///
  /// For text inside a control that has already chosen a colour — a button
  /// label, an inverted banner.
  inherit(null);

  const AstryxTextColor(this.token);

  /// The colour token, or null for [inherit].
  final AstryxColorToken? token;
}

/// The weight of a run of text, overriding the role's own.
enum AstryxTextWeight {
  /// Regular.
  normal(AstryxFontWeightToken.normal),

  /// One step up.
  medium(AstryxFontWeightToken.medium),

  /// The default for headings.
  semibold(AstryxFontWeightToken.semibold),

  /// The heaviest.
  bold(AstryxFontWeightToken.bold);

  const AstryxTextWeight(this.token);

  /// The font-weight token this maps onto.
  final AstryxFontWeightToken token;
}

/// How text is aligned within its box.
///
/// Logical, not physical: [start] is the left edge in LTR and the right edge in
/// RTL, so text reads correctly in either direction.
enum AstryxTextJustify {
  /// Aligned to the reading start.
  start(TextAlign.start),

  /// Centred.
  center(TextAlign.center),

  /// Aligned to the reading end.
  end(TextAlign.end);

  const AstryxTextJustify(this.textAlign);

  /// The Flutter alignment.
  final TextAlign textAlign;
}

/// Renders a run of text in the design system's typography.
///
/// The [type] — not a [TextStyle] — is the primary API. A role carries size,
/// weight, line height and family as a set, so text stays consistent and a
/// theme change moves all of it together.
///
/// {@tool snippet}
/// ```dart
/// const AstryxText('Changes saved');
///
/// const AstryxText(
///   'This field is required',
///   type: AstryxTextType.supporting,
///   color: AstryxTextColor.accent,
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxHeading`, for headings, which carry a semantic level.
///  * [AstryxTextTheme], for theming every instance at once.
class AstryxText extends StatelessWidget {
  /// Creates a run of text.
  const AstryxText(
    this.data, {
    super.key,
    this.type = AstryxTextType.body,
    this.color = AstryxTextColor.primary,
    this.weight,
    this.size,
    this.justify,
    this.maxLines,
    this.overflow,
    this.truncateTooltip = false,
    this.softWrap = true,
    this.strikethrough = false,
    this.tabularNumbers = false,
    this.semanticsLabel,
    this.style,
    this.theme,
  });

  /// {@template AstryxText.data}
  /// The text to display.
  /// {@endtemplate}
  final String data;

  /// {@template AstryxText.type}
  /// The semantic role, which selects the type-scale row.
  /// {@endtemplate}
  final AstryxTextType type;

  /// {@template AstryxText.color}
  /// The semantic colour.
  /// {@endtemplate}
  final AstryxTextColor color;

  /// {@template AstryxText.weight}
  /// Overrides the weight the [type] would give.
  /// {@endtemplate}
  final AstryxTextWeight? weight;

  /// {@template AstryxText.size}
  /// Overrides the size the [type] would give, from the raw size ramp.
  ///
  /// The line height stays the role's, so overriding size alone changes the
  /// leading ratio — which is usually not what you want. Prefer a different
  /// [type].
  /// {@endtemplate}
  final AstryxTextSizeToken? size;

  /// {@template AstryxText.justify}
  /// How the text aligns within its box. Logical, so it flips under RTL.
  /// {@endtemplate}
  final AstryxTextJustify? justify;

  /// {@template AstryxText.maxLines}
  /// The maximum number of lines before the text is truncated.
  /// {@endtemplate}
  final int? maxLines;

  /// {@template AstryxText.overflow}
  /// How text that exceeds [maxLines] is handled.
  ///
  /// Defaults to [TextOverflow.ellipsis] when [maxLines] is set, and to
  /// [TextOverflow.clip] otherwise.
  /// {@endtemplate}
  final TextOverflow? overflow;

  /// Whether to show the full text in a tooltip when it is cut off.
  ///
  /// Only when it *is* cut off — the text is measured against the space it was
  /// given, so a tooltip never repeats something already legible. Costs one
  /// `TextPainter` layout per build, so leave it off for text that cannot
  /// truncate.
  ///
  /// A screen reader always gets the full string regardless: truncation is a
  /// painting concern and never reaches the semantics tree.
  final bool truncateTooltip;

  /// {@template AstryxText.softWrap}
  /// Whether the text wraps at soft line breaks.
  /// {@endtemplate}
  final bool softWrap;

  /// {@template AstryxText.strikethrough}
  /// Whether to strike the text through.
  /// {@endtemplate}
  final bool strikethrough;

  /// {@template AstryxText.tabularNumbers}
  /// Whether digits use fixed-width figures.
  ///
  /// For numbers in a column, where proportional digits make a table look
  /// ragged. Requires a font with the `tnum` feature; fonts without it render
  /// unchanged.
  /// {@endtemplate}
  final bool tabularNumbers;

  /// {@template AstryxText.semanticsLabel}
  /// An alternative string for a screen reader to read instead of [data].
  ///
  /// For text a reader would mispronounce — `$1.2M`, an abbreviation, a glyph.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template AstryxText.style}
  /// Applied over the resolved style.
  ///
  /// The deliberate escape hatch. Everything else about this widget exists to
  /// make reaching for it rare.
  /// {@endtemplate}
  final TextStyle? style;

  /// Visual overrides for this text, merged over [AstryxThemeData.text].
  final AstryxTextTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final resolved = data.text.merge(theme);
    final style = resolveAstryxTextStyle(
      data: data,
      componentTheme: resolved,
      role: type.role,
      color: color,
      weight: weight,
      size: size,
      strikethrough: strikethrough,
      tabularNumbers: tabularNumbers,
      style: this.style,
    );

    final effectiveOverflow =
        overflow ??
        (maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip);

    final text = Text(
      this.data,
      style: style,
      textAlign: justify?.textAlign ?? resolved.justify,
      maxLines: maxLines,
      overflow: effectiveOverflow,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );

    if (!truncateTooltip) return text;

    return _TruncationTooltip(
      data: this.data,
      style: style,
      maxLines: maxLines,
      textAlign: justify?.textAlign ?? resolved.justify ?? TextAlign.start,
      child: text,
    );
  }
}

/// Shows a tooltip only when its text is actually cut off.
///
/// The port of upstream's `hasTruncateTooltip`. Measuring is the whole job:
/// a tooltip that always appears repeats what the user can already read, and
/// one that never appears leaves the ellipsis unexplained.
class _TruncationTooltip extends StatelessWidget {
  const _TruncationTooltip({
    required this.data,
    required this.style,
    required this.maxLines,
    required this.textAlign,
    required this.child,
  });

  final String data;
  final TextStyle style;
  final int? maxLines;
  final TextAlign textAlign;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final painter = TextPainter(
        text: TextSpan(text: data, style: style),
        maxLines: maxLines,
        textAlign: textAlign,
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout(maxWidth: constraints.maxWidth);

      final truncated =
          painter.didExceedMaxLines ||
          painter.width > constraints.maxWidth + 0.5;
      painter.dispose();

      if (!truncated) return child;
      // `excludeFromSemantics`: a screen reader gets the full string from the
      // `Text` itself, which is never truncated in the semantics tree.
      return AstryxTooltip(
        message: data,
        excludeFromSemantics: true,
        child: child,
      );
    },
  );
}

/// Resolves a text style from the theme, the component theme and the
/// per-instance overrides.
///
/// Shared by [AstryxText] and `AstryxHeading` so the two cannot drift.
@internal
TextStyle resolveAstryxTextStyle({
  required AstryxThemeData data,
  required AstryxTextTheme componentTheme,
  required AstryxTypeRole role,
  AstryxTextColor color = AstryxTextColor.primary,
  AstryxTextWeight? weight,
  AstryxTextSizeToken? size,
  bool strikethrough = false,
  bool tabularNumbers = false,
  TextStyle? style,
}) {
  var resolved = data.textStyle(role);

  // `inherit` is the absence of a colour, not a colour: the type-scale style
  // carries none, and `Text` merges an unset colour with the enclosing
  // `DefaultTextStyle`. Note that `copyWith(color: null)` would *not* clear a
  // colour — null there means "keep" — so this has to be a skip, not a reset.
  final token = color.token;
  if (token != null) {
    resolved = resolved.copyWith(color: data.color(token));
  }

  if (weight != null) {
    resolved = resolved.copyWith(fontWeight: data.fontWeight(weight.token));
  }
  if (size != null) {
    resolved = resolved.copyWith(fontSize: data.textSize(size));
  }
  if (strikethrough) {
    resolved = resolved.copyWith(decoration: TextDecoration.lineThrough);
  }
  if (tabularNumbers) {
    resolved = resolved.copyWith(
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
  }

  return resolved.merge(componentTheme.style).merge(style);
}
