/// Rules and separators.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/divider.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How prominent a divider is.
enum AstryxDividerVariant {
  /// A hairline, from `--color-border`.
  ///
  /// Deliberately low-contrast — roughly 1.1:1 — and therefore decorative. Do
  /// not use it as a control's only visible boundary.
  subtle,

  /// A stronger rule, from `--color-border-emphasized`.
  strong,
}

/// A horizontal or vertical rule, optionally with a label.
///
/// A plain divider is decorative and is hidden from assistive technology: a
/// screen reader announcing "separator" between every row is noise. A divider
/// *with a label* is a section boundary and carries the label, because that is
/// information the visual reader gets and the non-visual one otherwise would
/// not.
///
/// {@tool snippet}
/// ```dart
/// const AstryxDivider();
///
/// const AstryxDivider(label: 'Advanced');
///
/// const AstryxDivider(axis: Axis.vertical);
/// ```
/// {@end-tool}
class AstryxDivider extends StatelessWidget {
  /// Creates a divider.
  const AstryxDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.variant = AstryxDividerVariant.subtle,
    this.label,
    this.theme,
  });

  /// {@template AstryxDivider.axis}
  /// Whether the rule runs horizontally or vertically.
  ///
  /// A vertical divider needs a bounded height from its parent — inside an
  /// `AstryxHStack` with `align: stretch`, or an [IntrinsicHeight].
  /// {@endtemplate}
  final Axis axis;

  /// {@template AstryxDivider.variant}
  /// How prominent the rule is.
  /// {@endtemplate}
  final AstryxDividerVariant variant;

  /// {@template AstryxDivider.label}
  /// Text shown in the middle of the rule.
  ///
  /// Horizontal dividers only. A labelled divider is announced; an unlabelled
  /// one is not.
  /// {@endtemplate}
  final String? label;

  /// Visual overrides for this divider, merged over [AstryxThemeData.divider].
  final AstryxDividerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final resolved = data.divider.merge(theme);

    final thickness = resolved.thickness ?? data.borderWidth();
    final color = switch (variant) {
      AstryxDividerVariant.subtle =>
        resolved.color ?? data.color(AstryxColorToken.border),
      AstryxDividerVariant.strong =>
        resolved.emphasizedColor ??
            data.color(AstryxColorToken.borderEmphasized),
    };

    final line = ColoredBox(
      color: color,
      child: SizedBox(
        width: axis == Axis.horizontal ? double.infinity : thickness,
        height: axis == Axis.horizontal ? thickness : double.infinity,
      ),
    );

    if (label == null || axis == Axis.vertical) {
      // Decorative: excluded from the semantics tree entirely, so a reader
      // does not announce a separator between every row of a list.
      return ExcludeSemantics(child: line);
    }

    final gap = resolved.labelGap ?? data.spacing(AstryxSpacingToken.spacing2);

    return Semantics(
      // A labelled divider names the section that follows, so it is a heading
      // in everything but markup.
      header: true,
      label: label,
      child: ExcludeSemantics(
        child: Row(
          children: <Widget>[
            Expanded(child: line),
            Padding(
              padding: EdgeInsetsDirectional.only(start: gap, end: gap),
              child: AstryxText(
                label!,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
            Expanded(child: line),
          ],
        ),
      ),
    );
  }
}
