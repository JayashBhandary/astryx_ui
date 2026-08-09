/// Row and column layout.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Distribution along a stack's main axis.
enum AstryxStackJustify {
  /// Packed at the start.
  start(MainAxisAlignment.start, WrapAlignment.start),

  /// Packed at the centre.
  center(MainAxisAlignment.center, WrapAlignment.center),

  /// Packed at the end.
  end(MainAxisAlignment.end, WrapAlignment.end),

  /// Space distributed between children, none at the edges.
  between(MainAxisAlignment.spaceBetween, WrapAlignment.spaceBetween),

  /// Space distributed around children, half-size at the edges.
  around(MainAxisAlignment.spaceAround, WrapAlignment.spaceAround),

  /// Space distributed evenly, including at the edges.
  evenly(MainAxisAlignment.spaceEvenly, WrapAlignment.spaceEvenly);

  const AstryxStackJustify(this.mainAxisAlignment, this.wrapAlignment);

  /// The equivalent for a [Row] or [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The equivalent for a [Wrap].
  final WrapAlignment wrapAlignment;
}

/// Alignment across a stack's cross axis.
enum AstryxStackAlign {
  /// Aligned to the cross-axis start.
  start(CrossAxisAlignment.start, WrapCrossAlignment.start),

  /// Centred on the cross axis.
  center(CrossAxisAlignment.center, WrapCrossAlignment.center),

  /// Aligned to the cross-axis end.
  end(CrossAxisAlignment.end, WrapCrossAlignment.end),

  /// Stretched to fill the cross axis.
  ///
  /// Has no [Wrap] equivalent — a wrapping stack falls back to [start], since
  /// `Wrap` sizes each run to its tallest child rather than stretching.
  stretch(CrossAxisAlignment.stretch, WrapCrossAlignment.start);

  const AstryxStackAlign(this.crossAxisAlignment, this.wrapCrossAlignment);

  /// The equivalent for a [Row] or [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The nearest equivalent for a [Wrap].
  final WrapCrossAlignment wrapCrossAlignment;
}

/// Lays children out in a row, with a token-valued gap.
///
/// [gap] takes an [AstryxSpacingToken], not a `double` — that is the whole
/// point of having the token. A layout built from tokens stays consistent when
/// the spacing scale changes; one built from numbers does not.
///
/// {@tool snippet}
/// ```dart
/// AstryxHStack(
///   gap: AstryxSpacingToken.spacing2,
///   align: AstryxStackAlign.center,
///   children: <Widget>[icon, label],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxVStack], the vertical equivalent.
class AstryxHStack extends StatelessWidget {
  /// Creates a horizontal stack.
  const AstryxHStack({
    required this.children,
    super.key,
    this.gap,
    this.justify = AstryxStackJustify.start,
    this.align = AstryxStackAlign.center,
    this.wrap = false,
    this.runGap,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// {@template AstryxStack.children}
  /// The widgets to lay out, in order.
  /// {@endtemplate}
  final List<Widget> children;

  /// {@template AstryxStack.gap}
  /// The space between children, as a spacing token.
  /// {@endtemplate}
  final AstryxSpacingToken? gap;

  /// {@template AstryxStack.justify}
  /// Distribution along the main axis.
  /// {@endtemplate}
  final AstryxStackJustify justify;

  /// {@template AstryxStack.align}
  /// Alignment across the cross axis.
  ///
  /// Defaults to [AstryxStackAlign.center] for a row, which is what makes an
  /// icon sit on the text's optical centre rather than its top.
  /// {@endtemplate}
  final AstryxStackAlign align;

  /// {@template AstryxStack.wrap}
  /// Whether children wrap onto further lines when they overflow.
  /// {@endtemplate}
  final bool wrap;

  /// {@template AstryxStack.runGap}
  /// The space between wrapped lines. Defaults to [gap].
  ///
  /// Only meaningful when [wrap] is true.
  /// {@endtemplate}
  final AstryxSpacingToken? runGap;

  /// {@template AstryxStack.mainAxisSize}
  /// Whether the stack takes all available main-axis space or only what it
  /// needs.
  ///
  /// Defaults to [MainAxisSize.min], unlike Flutter's [Row] and [Column]. A
  /// design-system stack is usually a small cluster inside a larger layout, and
  /// defaulting to `max` makes [justify] appear not to work.
  /// {@endtemplate}
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) => _buildStack(
    context: context,
    axis: Axis.horizontal,
    children: children,
    gap: gap,
    runGap: runGap,
    justify: justify,
    align: align,
    wrap: wrap,
    mainAxisSize: mainAxisSize,
  );
}

/// Lays children out in a column, with a token-valued gap.
///
/// {@tool snippet}
/// ```dart
/// AstryxVStack(
///   gap: AstryxSpacingToken.spacing3,
///   align: AstryxStackAlign.stretch,
///   children: <Widget>[title, body],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxHStack], the horizontal equivalent.
class AstryxVStack extends StatelessWidget {
  /// Creates a vertical stack.
  const AstryxVStack({
    required this.children,
    super.key,
    this.gap,
    this.justify = AstryxStackJustify.start,
    this.align = AstryxStackAlign.start,
    this.wrap = false,
    this.runGap,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// {@macro AstryxStack.children}
  final List<Widget> children;

  /// {@macro AstryxStack.gap}
  final AstryxSpacingToken? gap;

  /// {@macro AstryxStack.justify}
  final AstryxStackJustify justify;

  /// {@template AstryxVStack.align}
  /// Alignment across the cross axis.
  ///
  /// Defaults to [AstryxStackAlign.start] for a column — text aligned to the
  /// reading edge, not centred.
  /// {@endtemplate}
  final AstryxStackAlign align;

  /// {@macro AstryxStack.wrap}
  final bool wrap;

  /// {@macro AstryxStack.runGap}
  final AstryxSpacingToken? runGap;

  /// {@macro AstryxStack.mainAxisSize}
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) => _buildStack(
    context: context,
    axis: Axis.vertical,
    children: children,
    gap: gap,
    runGap: runGap,
    justify: justify,
    align: align,
    wrap: wrap,
    mainAxisSize: mainAxisSize,
  );
}

Widget _buildStack({
  required BuildContext context,
  required Axis axis,
  required List<Widget> children,
  required AstryxSpacingToken? gap,
  required AstryxSpacingToken? runGap,
  required AstryxStackJustify justify,
  required AstryxStackAlign align,
  required bool wrap,
  required MainAxisSize mainAxisSize,
}) {
  final theme = AstryxTheme.of(context);
  final spacing = gap == null ? 0.0 : theme.spacing(gap);

  if (wrap) {
    return Wrap(
      direction: axis,
      spacing: spacing,
      runSpacing: runGap == null ? spacing : theme.spacing(runGap),
      alignment: justify.wrapAlignment,
      crossAxisAlignment: align.wrapCrossAlignment,
      children: children,
    );
  }

  return Flex(
    direction: axis,
    spacing: spacing,
    mainAxisAlignment: justify.mainAxisAlignment,
    crossAxisAlignment: align.crossAxisAlignment,
    mainAxisSize: mainAxisSize,
    children: children,
  );
}
