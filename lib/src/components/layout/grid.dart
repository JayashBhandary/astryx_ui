/// Responsive grid layout.
///
/// ## What is ported, and what is not
///
/// Upstream's `Grid` is CSS Grid. This is **not a CSS Grid port** — it covers
/// the two shapes the Tier-1 components actually use, and no more:
///
///  * a fixed column count, and
///  * `repeat(auto-fit|auto-fill, minmax(min, 1fr))` — "as many columns as fit
///    at a minimum width".
///
/// Deliberately absent, because nothing in Tier-1 needs them and each would be
/// a significant piece of layout work: named areas and lines, explicit row
/// templates, per-item `span` and placement, `masonry`, and subgrid. A layout
/// wanting those should use Flutter's own primitives directly rather than have
/// this widget grow a half-CSS dialect.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How a responsive grid fills its track list.
///
/// CSS's `auto-fit` and `auto-fill`, which differ only when there are fewer
/// items than columns.
enum AstryxGridRepeat {
  /// Collapse the empty tracks, so the items stretch to fill the row.
  fit,

  /// Keep the empty tracks, so items stay at the column width they would have
  /// had in a full row.
  fill,
}

/// Lays children out in a grid.
///
/// Either a fixed [columns] count, or a responsive track list from [minWidth].
/// Exactly one of the two must be given.
///
/// {@tool snippet}
/// ```dart
/// // Three equal columns.
/// AstryxGrid(
///   columns: 3,
///   gap: AstryxSpacingToken.spacing3,
///   children: cards,
/// )
///
/// // As many 240px columns as fit.
/// AstryxGrid(
///   minWidth: 240,
///   gap: AstryxSpacingToken.spacing3,
///   children: cards,
/// )
/// ```
/// {@end-tool}
class AstryxGrid extends StatelessWidget {
  /// Creates a grid.
  const AstryxGrid({
    required this.children,
    super.key,
    this.columns,
    this.minWidth,
    this.maxColumns,
    this.repeat = AstryxGridRepeat.fit,
    this.gap,
    this.rowGap,
    this.columnGap,
  }) : assert(
         (columns == null) != (minWidth == null),
         'Give exactly one of columns or minWidth',
       ),
       assert(
         columns == null || columns > 0,
         'columns must be greater than zero',
       );

  /// The widgets to lay out, in order.
  final List<Widget> children;

  /// A fixed number of equal columns.
  final int? columns;

  /// The minimum width of a column, for a responsive track list.
  final double? minWidth;

  /// A ceiling on the responsive column count.
  ///
  /// For a grid that should not spread indefinitely on a wide display.
  final int? maxColumns;

  /// Whether empty tracks collapse. Only meaningful with [minWidth].
  final AstryxGridRepeat repeat;

  /// The space between items on both axes.
  ///
  /// [rowGap] and [columnGap] override it per axis.
  final AstryxSpacingToken? gap;

  /// The space between rows.
  final AstryxSpacingToken? rowGap;

  /// The space between columns.
  final AstryxSpacingToken? columnGap;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    double space(AstryxSpacingToken? token, AstryxSpacingToken? fallback) {
      final resolved = token ?? fallback;
      return resolved == null ? 0 : theme.spacing(resolved);
    }

    final rowSpacing = space(rowGap, gap);
    final columnSpacing = space(columnGap, gap);

    if (children.isEmpty) return const SizedBox.shrink();

    final fixed = columns;
    if (fixed != null) {
      return _GridRows(
        columns: fixed,
        rowSpacing: rowSpacing,
        columnSpacing: columnSpacing,
        stretchLastRow: true,
        children: children,
      );
    }

    // Responsive: the column count depends on the width, which is only known
    // during layout.
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        var count = 1;
        if (available.isFinite) {
          // n columns need n * minWidth + (n - 1) * spacing.
          count = ((available + columnSpacing) / (minWidth! + columnSpacing))
              .floor();
        }
        count = count.clamp(1, maxColumns ?? children.length);
        count = count.clamp(1, children.length);

        return _GridRows(
          columns: count,
          rowSpacing: rowSpacing,
          columnSpacing: columnSpacing,
          // `auto-fill` keeps the empty tracks, so a short final row does not
          // stretch to fill the width.
          stretchLastRow: repeat == AstryxGridRepeat.fit,
          children: children,
        );
      },
    );
  }
}

/// Lays [children] out in rows of [columns] equal-width cells.
///
/// A `Column` of `Row`s rather than a `GridView`: a grid in a design system is
/// almost always a handful of cards inside a scroll view someone else owns, and
/// a nested scrollable there is a bug rather than a feature.
class _GridRows extends StatelessWidget {
  const _GridRows({
    required this.columns,
    required this.rowSpacing,
    required this.columnSpacing,
    required this.stretchLastRow,
    required this.children,
  });

  final int columns;
  final double rowSpacing;
  final double columnSpacing;
  final bool stretchLastRow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var start = 0; start < children.length; start += columns) {
      final end = (start + columns) < children.length
          ? start + columns
          : children.length;
      final slice = children.sublist(start, end);
      final isLast = end == children.length;
      final missing = columns - slice.length;

      rows.add(
        // `IntrinsicHeight` is what makes `stretch` legal here: cross-axis
        // stretch in a Row means "fill the row's height", and inside a
        // min-height Column that height is unbounded — which asserts. It also
        // buys the behaviour CSS Grid gives for free, where every cell in a
        // row matches the tallest. The cost is a second layout pass per row,
        // which is acceptable for the handful of cards this widget is scoped
        // to and is why it is not a general-purpose grid.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: columnSpacing,
            children: <Widget>[
              for (final child in slice) Expanded(child: child),
              // Pad a short final row with empty tracks unless it should
              // stretch — the auto-fill/auto-fit distinction.
              if (!stretchLastRow && isLast && missing > 0)
                for (var i = 0; i < missing; i++)
                  const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: rowSpacing,
      children: rows,
    );
  }
}
