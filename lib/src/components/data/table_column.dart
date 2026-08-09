/// The table's data model: columns, widths, density, sorting and selection.
library;

import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How a column decides its width.
///
/// Sealed so the resolver has to handle every strategy, and so a caller cannot
/// invent a fourth one that the layout does not understand.
sealed class AstryxTableColumnWidth {
  const AstryxTableColumnWidth();

  /// An exact width in logical pixels.
  const factory AstryxTableColumnWidth.fixed(double width) =
      AstryxFixedColumnWidth;

  /// A share of whatever is left after the fixed and intrinsic columns.
  const factory AstryxTableColumnWidth.flex([double factor]) =
      AstryxFlexColumnWidth;

  /// As wide as its widest cell.
  const factory AstryxTableColumnWidth.intrinsic({double min, double max}) =
      AstryxIntrinsicColumnWidth;
}

/// A column of an exact width.
class AstryxFixedColumnWidth extends AstryxTableColumnWidth {
  /// Creates a fixed width.
  const AstryxFixedColumnWidth(this.width);

  /// The width in logical pixels.
  final double width;
}

/// A column that shares the remaining width.
class AstryxFlexColumnWidth extends AstryxTableColumnWidth {
  /// Creates a flexible width.
  const AstryxFlexColumnWidth([this.factor = 1]);

  /// This column's share, relative to the other flexible columns.
  final double factor;
}

/// A column sized to its content.
///
/// **Expensive.** The table cannot know how wide the widest cell is until it
/// has laid the cells out, so a table containing an intrinsic column lays out
/// **twice** on any frame where its rows change: once to measure, once to
/// place. With a hundred rows that is a hundred extra cell layouts.
///
/// Reach for it when a column's content is short and its width genuinely
/// varies — a status column, an ID. For anything else, [AstryxFlexColumnWidth]
/// costs nothing and looks the same.
class AstryxIntrinsicColumnWidth extends AstryxTableColumnWidth {
  /// Creates an intrinsic width.
  const AstryxIntrinsicColumnWidth({this.min = 0, this.max = double.infinity});

  /// A floor, so an empty column does not collapse to nothing.
  final double min;

  /// A ceiling, so one long cell cannot push everything else off-screen.
  final double max;
}

/// One column of an `AstryxTable`.
///
/// `T` is the row type. The cell builder receives the row itself rather than a
/// pre-extracted value, so a cell can render anything — a badge, two lines, a
/// button — without the column type having to describe it.
@immutable
class AstryxTableColumn<T> {
  /// Creates a column.
  const AstryxTableColumn({
    required this.id,
    required this.header,
    required this.cellBuilder,
    this.width = const AstryxTableColumnWidth.flex(),
    this.alignment = AstryxTableAlignment.start,
    this.compare,
    this.headerTooltip,
    this.visible = true,
  });

  /// A stable identifier, used for sorting state and as the column's key.
  final String id;

  /// The header text, and the column's accessible name.
  final String header;

  /// Builds a cell for one row.
  final Widget Function(BuildContext context, T row) cellBuilder;

  /// How this column decides its width.
  final AstryxTableColumnWidth width;

  /// How the cell's content sits within its width.
  final AstryxTableAlignment alignment;

  /// Makes the column sortable.
  ///
  /// Null leaves it unsortable — the header stays plain text rather than
  /// becoming a button, so a keyboard user does not tab through a control that
  /// does nothing.
  final int Function(T a, T b)? compare;

  /// Extra explanation shown on the header.
  final String? headerTooltip;

  /// Whether the column is shown at all.
  final bool visible;

  /// Whether this column can be sorted.
  bool get sortable => compare != null;
}

/// How a cell's content sits within its column.
enum AstryxTableAlignment {
  /// The reading-start edge. The default, and right for text.
  start,

  /// Centred.
  center,

  /// The reading-end edge.
  ///
  /// Right for numbers — a column of figures is comparable at a glance only
  /// when the digits line up.
  end;

  /// The equivalent alignment.
  AlignmentGeometry get alignment => switch (this) {
    AstryxTableAlignment.start => AlignmentDirectional.centerStart,
    AstryxTableAlignment.center => Alignment.center,
    AstryxTableAlignment.end => AlignmentDirectional.centerEnd,
  };

  /// The equivalent text alignment.
  TextAlign get textAlign => switch (this) {
    AstryxTableAlignment.start => TextAlign.start,
    AstryxTableAlignment.center => TextAlign.center,
    AstryxTableAlignment.end => TextAlign.end,
  };
}

/// How much room the rows take.
///
/// Upstream's three, with the same spacing tokens.
enum AstryxTableDensity {
  /// `--spacing-1` / `--spacing-2`. For dense data an operator scans.
  compact(AstryxSpacingToken.spacing1, AstryxSpacingToken.spacing2),

  /// `--spacing-2` / `--spacing-3`. The default.
  balanced(AstryxSpacingToken.spacing2, AstryxSpacingToken.spacing3),

  /// `--spacing-3` / `--spacing-4`. For a short table that should breathe.
  spacious(AstryxSpacingToken.spacing3, AstryxSpacingToken.spacing4);

  const AstryxTableDensity(this.vertical, this.horizontal);

  /// The padding above and below a cell's content.
  final AstryxSpacingToken vertical;

  /// The padding either side of it.
  final AstryxSpacingToken horizontal;
}

/// Which way a column is sorted.
enum AstryxSortDirection {
  /// Smallest first.
  ascending,

  /// Largest first.
  descending;

  /// The opposite direction.
  AstryxSortDirection get opposite => this == AstryxSortDirection.ascending
      ? AstryxSortDirection.descending
      : AstryxSortDirection.ascending;
}

/// The table's current sort.
///
/// A single column for 1.0. Multi-column sort is a real feature with real UI
/// requirements — showing the precedence, letting the user reorder it — and
/// shipping half of it would be worse than not shipping it.
@immutable
class AstryxTableSort {
  /// Creates a sort.
  const AstryxTableSort(this.columnId, this.direction);

  /// The sorted column's [AstryxTableColumn.id].
  final String columnId;

  /// Which way.
  final AstryxSortDirection direction;

  /// Whether this sort is ascending.
  bool get isAscending => direction == AstryxSortDirection.ascending;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTableSort &&
          other.columnId == columnId &&
          other.direction == direction;

  @override
  int get hashCode => Object.hash(columnId, direction);

  @override
  String toString() => 'AstryxTableSort($columnId, ${direction.name})';
}

/// How many rows the user can select.
enum AstryxTableSelectionMode {
  /// No selection. The default.
  none,

  /// One row at a time — a radio, in effect.
  single,

  /// Any number, with a header checkbox that governs the visible rows.
  multiple,
}
