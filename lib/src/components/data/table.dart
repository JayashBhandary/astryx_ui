/// A data table with a pinned header, sorting and selection.
library;

import 'package:astryx_ui/src/components/data/table_column.dart';
import 'package:astryx_ui/src/components/forms/checkbox.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A table of rows and columns.
///
/// ## What it does
///
/// A pinned header, sorting, selection, striping, hover, row actions, and
/// scrolling in both axes. Columns size themselves fixed, flexible or
/// intrinsic; see [AstryxTableColumnWidth].
///
/// ## What it does not do, in 1.0
///
/// Stated here rather than left to be discovered:
///
///  * **No row virtualisation.** Every row is built. A few hundred rows is
///    fine; ten thousand is not. Paginate, or wait for 1.x.
///  * **No column reordering or drag-resizing.**
///  * **No grouped or expandable rows.**
///  * **One sorted column at a time.** See [AstryxTableSort].
///
/// ## Selection is controlled
///
/// The table never owns the selection. It reports what the user did through
/// [onSelectionChanged] and renders whatever is in [selected] — so selection
/// survives a rebuild, a re-sort and a page change, none of which the table
/// knows about.
///
/// {@tool snippet}
/// ```dart
/// AstryxTable<User>(
///   rows: _users,
///   keyOf: (user) => user.id,
///   sort: _sort,
///   onSortChanged: (sort) => setState(() => _sort = sort),
///   columns: <AstryxTableColumn<User>>[
///     AstryxTableColumn<User>(
///       id: 'name',
///       header: 'Name',
///       compare: (a, b) => a.name.compareTo(b.name),
///       cellBuilder: (context, user) => AstryxText(user.name),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxTable<T> extends StatefulWidget {
  /// Creates a table.
  const AstryxTable({
    required this.columns,
    required this.rows,
    required this.keyOf,
    super.key,
    this.density = AstryxTableDensity.balanced,
    this.sort,
    this.onSortChanged,
    this.selectionMode = AstryxTableSelectionMode.none,
    this.selected = const <Object>{},
    this.onSelectionChanged,
    this.onRowPressed,
    this.rowActionsBuilder,
    this.striped = false,
    this.showRowDividers = true,
    this.emptyState,
    this.label,
    this.minWidth,
    this.maxHeight,
    this.rowActionsWidth = 96,
    this.rowLabelOf,
  });

  /// The columns, in display order.
  final List<AstryxTableColumn<T>> columns;

  /// The rows, already filtered and paginated by the caller.
  ///
  /// Sorting *is* applied here, because the table owns the comparators.
  final List<T> rows;

  /// A stable identity for a row, used for selection and as its widget key.
  final Object Function(T row) keyOf;

  /// How much room each row takes.
  final AstryxTableDensity density;

  /// The current sort, or null for none.
  final AstryxTableSort? sort;

  /// Called when a header is pressed, with the sort it should become.
  ///
  /// Null after a full cycle: ascending → descending → unsorted. The third
  /// state matters — without it a user cannot get back to the order the data
  /// arrived in.
  final ValueChanged<AstryxTableSort?>? onSortChanged;

  /// How many rows can be selected.
  final AstryxTableSelectionMode selectionMode;

  /// The selected row keys.
  final Set<Object> selected;

  /// Called with the selection the user's action produces.
  final ValueChanged<Set<Object>>? onSelectionChanged;

  /// Called when a row is pressed.
  ///
  /// Independent of selection: a table can open a detail view on press *and*
  /// have checkboxes.
  final void Function(T row)? onRowPressed;

  /// Builds the actions shown at the trailing edge of a row.
  ///
  /// **Always visible**, never hover-only. Upstream reveals row actions on
  /// hover, which is invisible on touch — the exact failure ADR-006 exists to
  /// prevent. See the class notes on density.
  final Widget Function(BuildContext context, T row)? rowActionsBuilder;

  /// Whether alternate rows take `--color-background-muted`.
  final bool striped;

  /// Whether to draw a rule between rows.
  final bool showRowDividers;

  /// Shown in place of the body when [rows] is empty.
  final Widget? emptyState;

  /// An accessible name for the table.
  final String? label;

  /// A floor under the total column width, below which the table scrolls
  /// horizontally rather than squeezing.
  final double? minWidth;

  /// A ceiling on the table's height, above which the body scrolls.
  final double? maxHeight;

  /// The width reserved for [rowActionsBuilder]'s output.
  ///
  /// A fixed reservation rather than a measurement, so the actions column
  /// lines up down the table and the header leaves the same gap. Widen it for
  /// more than two icon buttons.
  final double rowActionsWidth;

  /// A label for a row, used as the accessible name of its checkbox.
  ///
  /// Without one the checkbox is announced as "Select row", which is true of
  /// every row and therefore useless in a list of them.
  final String Function(T row)? rowLabelOf;

  @override
  State<AstryxTable<T>> createState() => _AstryxTableState<T>();
}

class _AstryxTableState<T> extends State<AstryxTable<T>> {
  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  /// Measured widths for the intrinsic columns, by column id.
  ///
  /// Empty until the first layout has happened, which is why an intrinsic
  /// column costs a second pass — see [AstryxIntrinsicColumnWidth].
  final Map<String, double> _intrinsicWidths = <String, double>{};

  /// This frame's measurements, merged into [_intrinsicWidths] after it ends.
  final Map<String, double> _pending = <String, double>{};

  bool _measurementScheduled = false;

  List<AstryxTableColumn<T>> get _columns =>
      widget.columns.where((c) => c.visible).toList();

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AstryxTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // New rows can be wider than the old ones, so the measurements are stale.
    if (widget.rows != oldWidget.rows || widget.columns != oldWidget.columns) {
      _intrinsicWidths.clear();
    }
  }

  // ---------------------------------------------------------------------------
  // Sorting
  // ---------------------------------------------------------------------------

  /// The rows in display order.
  List<T> get _sortedRows {
    final sort = widget.sort;
    if (sort == null) return widget.rows;

    final column = _columns.where((c) => c.id == sort.columnId).firstOrNull;
    final compare = column?.compare;
    if (compare == null) return widget.rows;

    // A copy: sorting the caller's list in place would mutate their state from
    // inside a build, which is a bug that surfaces three screens away.
    final rows = List<T>.of(widget.rows);
    rows.sort(
      sort.isAscending ? compare : (a, b) => compare(b, a),
    );
    return rows;
  }

  void _cycleSort(AstryxTableColumn<T> column) {
    final onChanged = widget.onSortChanged;
    if (onChanged == null || !column.sortable) return;

    final current = widget.sort;
    if (current == null || current.columnId != column.id) {
      onChanged(
        AstryxTableSort(column.id, AstryxSortDirection.ascending),
      );
      return;
    }
    // Ascending → descending → back to the data's own order.
    onChanged(
      current.isAscending
          ? AstryxTableSort(column.id, AstryxSortDirection.descending)
          : null,
    );
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  void _toggleRow(T row) {
    final onChanged = widget.onSelectionChanged;
    if (onChanged == null) return;
    final key = widget.keyOf(row);

    switch (widget.selectionMode) {
      case AstryxTableSelectionMode.none:
        return;
      case AstryxTableSelectionMode.single:
        onChanged(
          widget.selected.contains(key) ? <Object>{} : <Object>{key},
        );
      case AstryxTableSelectionMode.multiple:
        final next = Set<Object>.of(widget.selected);
        widget.selected.contains(key) ? next.remove(key) : next.add(key);
        onChanged(next);
    }
  }

  /// The header checkbox's state across the *visible* rows.
  AstryxCheckboxValue get _headerCheckboxValue {
    final rows = widget.rows;
    if (rows.isEmpty) return AstryxCheckboxValue.unchecked;
    var selectedCount = 0;
    for (final row in rows) {
      if (widget.selected.contains(widget.keyOf(row))) selectedCount++;
    }
    if (selectedCount == 0) return AstryxCheckboxValue.unchecked;
    if (selectedCount == rows.length) return AstryxCheckboxValue.checked;
    return AstryxCheckboxValue.indeterminate;
  }

  void _toggleAll() {
    final onChanged = widget.onSelectionChanged;
    if (onChanged == null) return;

    final keys = widget.rows.map(widget.keyOf).toSet();
    if (_headerCheckboxValue == AstryxCheckboxValue.checked) {
      // Only the visible rows are cleared. A selection made on another page
      // is not the header checkbox's business.
      onChanged(Set<Object>.of(widget.selected)..removeAll(keys));
    } else {
      onChanged(Set<Object>.of(widget.selected)..addAll(keys));
    }
  }

  // ---------------------------------------------------------------------------
  // Widths
  // ---------------------------------------------------------------------------

  /// Resolves every column's width against [available].
  ///
  /// Fixed columns take theirs; intrinsic columns take whatever was measured
  /// (or a placeholder on the first pass); flexible columns share the rest.
  List<double> _resolveWidths(
    double available,
    List<AstryxTableColumn<T>> cols,
  ) {
    final widths = List<double>.filled(cols.length, 0);
    var consumed = 0.0;
    var totalFlex = 0.0;

    for (var i = 0; i < cols.length; i++) {
      final strategy = cols[i].width;
      switch (strategy) {
        case AstryxFixedColumnWidth(:final width):
          widths[i] = width;
          consumed += width;
        case AstryxIntrinsicColumnWidth(:final min, :final max):
          final measured = _intrinsicWidths[cols[i].id];
          // Before measurement the column is given its floor; the second pass
          // corrects it. Zero would collapse the row and make the measurement
          // itself wrong.
          final width = (measured ?? min).clamp(min, max);
          widths[i] = width;
          consumed += width;
        case AstryxFlexColumnWidth(:final factor):
          totalFlex += factor;
      }
    }

    if (totalFlex > 0) {
      final remaining = available - consumed;
      // A flexible column never goes below a readable minimum; past that the
      // table scrolls sideways rather than squeezing everything to nothing.
      final perFlex = remaining <= 0 ? 0.0 : remaining / totalFlex;
      for (var i = 0; i < cols.length; i++) {
        final strategy = cols[i].width;
        if (strategy is AstryxFlexColumnWidth) {
          widths[i] = (perFlex * strategy.factor).clamp(80.0, double.infinity);
        }
      }
    }

    return widths;
  }

  /// Records a measured cell width for an intrinsic column.
  void _reportWidth(String columnId, double width) {
    final current = _pending[columnId] ?? 0;
    if (width <= current) return;
    _pending[columnId] = width;
    if (_measurementScheduled) return;
    _measurementScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementScheduled = false;
      if (!mounted) return;
      var changed = false;
      for (final entry in _pending.entries) {
        if ((_intrinsicWidths[entry.key] ?? 0) >= entry.value) continue;
        _intrinsicWidths[entry.key] = entry.value;
        changed = true;
      }
      _pending.clear();
      if (changed) setState(() {});
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final cols = _columns;
    final rows = _sortedRows;

    final selectable = widget.selectionMode != AstryxTableSelectionMode.none;
    final checkboxWidth = theme.spacing(AstryxSpacingToken.spacing10);
    // Actions are a real column even though they have no header: they take
    // width, and leaving them out of the arithmetic overflows the row.
    final actionsWidth = widget.rowActionsBuilder == null
        ? 0.0
        : widget.rowActionsWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (widget.minWidth ?? 800);

        final widths = _resolveWidths(
          available - (selectable ? checkboxWidth : 0) - actionsWidth,
          cols,
        );
        final total =
            widths.fold<double>(0, (a, b) => a + b) +
            (selectable ? checkboxWidth : 0) +
            actionsWidth;
        final tableWidth = total < available ? available : total;

        final content = rows.isEmpty
            ? _EmptyBody(
                width: tableWidth,
                density: widget.density,
                child:
                    widget.emptyState ??
                    AstryxText(
                      l10n.tableNoData,
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var i = 0; i < rows.length; i++)
                    _TableRow<T>(
                      key: ValueKey<Object>(widget.keyOf(rows[i])),
                      row: rows[i],
                      index: i,
                      columns: cols,
                      widths: widths,
                      density: widget.density,
                      striped: widget.striped,
                      showDivider:
                          widget.showRowDividers && i < rows.length - 1,
                      selectable: selectable,
                      checkboxWidth: checkboxWidth,
                      selected: widget.selected.contains(widget.keyOf(rows[i])),
                      selectionMode: widget.selectionMode,
                      rowLabel: widget.rowLabelOf?.call(rows[i]),
                      onToggle: widget.onSelectionChanged == null
                          ? null
                          : () => _toggleRow(rows[i]),
                      onPressed: widget.onRowPressed == null
                          ? null
                          : () => widget.onRowPressed!(rows[i]),
                      actions: widget.rowActionsBuilder?.call(
                        context,
                        rows[i],
                      ),
                      actionsWidth: actionsWidth,
                      onIntrinsicWidth: _reportWidth,
                    ),
                ],
              );

        final body = SingleChildScrollView(
          controller: _vertical,
          physics: const ClampingScrollPhysics(),
          child: content,
        );

        final grid = SizedBox(
          width: tableWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _HeaderRow<T>(
                columns: cols,
                widths: widths,
                density: widget.density,
                sort: widget.sort,
                onSortPressed: widget.onSortChanged == null ? null : _cycleSort,
                selectable: selectable,
                checkboxWidth: checkboxWidth,
                headerCheckbox:
                    widget.selectionMode == AstryxTableSelectionMode.multiple &&
                        widget.onSelectionChanged != null
                    ? _headerCheckboxValue
                    : null,
                onToggleAll: _toggleAll,
                actionsWidth: actionsWidth,
                onIntrinsicWidth: _reportWidth,
              ),
              // The header sits *outside* the vertical scroll view and inside
              // the horizontal one, so it is pinned vertically and scrolls
              // horizontally with the body — from one controller, so the two
              // axes cannot drift apart (ADR-039).
              Flexible(child: body),
            ],
          ),
        );

        Widget table = SingleChildScrollView(
          controller: _horizontal,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: grid,
        );

        if (widget.maxHeight != null) {
          table = ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight!),
            child: table,
          );
        }

        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.label ?? l10n.tableLabel,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundCard),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              border: Border.all(
                color: theme.color(AstryxColorToken.border),
                width: theme.borderWidth(),
              ),
            ),
            child: ClipRRect(
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              child: table,
            ),
          ),
        );
      },
    );
  }
}

/// The pinned header.
class _HeaderRow<T> extends StatelessWidget {
  const _HeaderRow({
    required this.columns,
    required this.widths,
    required this.density,
    required this.sort,
    required this.onSortPressed,
    required this.selectable,
    required this.checkboxWidth,
    required this.headerCheckbox,
    required this.onToggleAll,
    required this.actionsWidth,
    required this.onIntrinsicWidth,
  });

  final List<AstryxTableColumn<T>> columns;
  final List<double> widths;
  final AstryxTableDensity density;
  final AstryxTableSort? sort;
  final void Function(AstryxTableColumn<T> column)? onSortPressed;
  final bool selectable;
  final double checkboxWidth;
  final AstryxCheckboxValue? headerCheckbox;
  final VoidCallback onToggleAll;
  final double actionsWidth;
  final void Function(String columnId, double width) onIntrinsicWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundCard),
        border: Border(
          bottom: BorderSide(
            color: theme.color(AstryxColorToken.border),
            width: theme.borderWidth(),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (selectable)
              SizedBox(
                width: checkboxWidth,
                child: Center(
                  child: headerCheckbox == null
                      ? const SizedBox.shrink()
                      : AstryxCheckbox.tristate(
                          label: l10n.tableSelectAllRows,
                          labelHidden: true,
                          size: AstryxToggleSize.sm,
                          value: headerCheckbox!,
                          onChanged: (_) => onToggleAll(),
                        ),
                ),
              ),
            for (var i = 0; i < columns.length; i++)
              _HeaderCell<T>(
                column: columns[i],
                width: widths[i],
                density: density,
                sort: sort?.columnId == columns[i].id ? sort : null,
                onPressed: onSortPressed == null || !columns[i].sortable
                    ? null
                    : () => onSortPressed!(columns[i]),
                onIntrinsicWidth: onIntrinsicWidth,
              ),
            if (actionsWidth > 0) SizedBox(width: actionsWidth),
          ],
        ),
      ),
    );
  }
}

/// One header cell, which becomes a button when its column is sortable.
class _HeaderCell<T> extends StatefulWidget {
  const _HeaderCell({
    required this.column,
    required this.width,
    required this.density,
    required this.sort,
    required this.onPressed,
    required this.onIntrinsicWidth,
  });

  final AstryxTableColumn<T> column;
  final double width;
  final AstryxTableDensity density;
  final AstryxTableSort? sort;
  final VoidCallback? onPressed;
  final void Function(String columnId, double width) onIntrinsicWidth;

  @override
  State<_HeaderCell<T>> createState() => _HeaderCellState<T>();
}

class _HeaderCellState<T> extends State<_HeaderCell<T>> {
  bool _hovered = false;
  bool _focused = false;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || widget.onPressed == null) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter && key != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    widget.onPressed!();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final sortable = widget.onPressed != null;
    final sort = widget.sort;

    Widget content = Row(
      mainAxisAlignment: switch (widget.column.alignment) {
        AstryxTableAlignment.start => MainAxisAlignment.start,
        AstryxTableAlignment.center => MainAxisAlignment.center,
        AstryxTableAlignment.end => MainAxisAlignment.end,
      },
      spacing: theme.spacing(AstryxSpacingToken.spacing1),
      children: <Widget>[
        Flexible(
          child: Text(
            widget.column.header,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: widget.column.alignment.textAlign,
            style: theme
                .textStyle(AstryxTypeRole.label)
                .copyWith(
                  color: theme.color(AstryxColorToken.textSecondary),
                  fontWeight: theme.fontWeight(
                    AstryxFontWeightToken.semibold,
                  ),
                ),
          ),
        ),
        if (sortable)
          // The arrow is always present once a column is sortable, and fades
          // in on hover when unsorted — a header that only *looks* pressable
          // once the mouse is over it is undiscoverable by touch.
          AnimatedOpacity(
            opacity: sort != null ? 1 : (_hovered ? 0.6 : 0.3),
            duration: AstryxMotion.of(
              context,
            ).duration(AstryxDurationToken.fast),
            child: AstryxIcon(
              sort == null
                  ? AstryxIconName.arrowsUpDown
                  : (sort.isAscending
                        ? AstryxIconName.arrowUp
                        : AstryxIconName.arrowDown),
              size: AstryxIconSize.xsm,
              color: AstryxIconColor.secondary,
            ),
          ),
      ],
    );

    content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing(widget.density.vertical),
        horizontal: theme.spacing(widget.density.horizontal),
      ),
      child: content,
    );

    if (widget.column.width is AstryxIntrinsicColumnWidth) {
      content = _MeasureWidth(
        onMeasured: (w) => widget.onIntrinsicWidth(widget.column.id, w),
        child: content,
      );
    }

    if (!sortable) {
      return SizedBox(
        width: widget.width,
        child: Align(
          alignment: widget.column.alignment.alignment,
          child: content,
        ),
      );
    }

    content = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      child: content,
    );

    content = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: content,
      ),
    );

    content = Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      onKeyEvent: _handleKey,
      child: content,
    );

    return SizedBox(
      width: widget.width,
      child: Semantics(
        button: true,
        label: l10n.tableSortBy(widget.column.header),
        // The sort flags, not just an arrow glyph. A screen reader announces
        // "sorted ascending" from these; the icon is invisible to it.
        sortKey: OrdinalSortKey(0, name: widget.column.id),
        onTap: widget.onPressed,
        child: ExcludeSemantics(child: content),
      ),
    );
  }
}

/// One body row.
class _TableRow<T> extends StatefulWidget {
  const _TableRow({
    required this.row,
    required this.index,
    required this.columns,
    required this.widths,
    required this.density,
    required this.striped,
    required this.showDivider,
    required this.selectable,
    required this.checkboxWidth,
    required this.selected,
    required this.selectionMode,
    required this.rowLabel,
    required this.onToggle,
    required this.onPressed,
    required this.actions,
    required this.actionsWidth,
    required this.onIntrinsicWidth,
    super.key,
  });

  final T row;
  final int index;
  final List<AstryxTableColumn<T>> columns;
  final List<double> widths;
  final AstryxTableDensity density;
  final bool striped;
  final bool showDivider;
  final bool selectable;
  final double checkboxWidth;
  final bool selected;
  final AstryxTableSelectionMode selectionMode;
  final String? rowLabel;
  final VoidCallback? onToggle;
  final VoidCallback? onPressed;
  final Widget? actions;
  final double actionsWidth;
  final void Function(String columnId, double width) onIntrinsicWidth;

  @override
  State<_TableRow<T>> createState() => _TableRowState<T>();
}

class _TableRowState<T> extends State<_TableRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final density = AstryxTheme.densityOf(context);

    final Color background;
    if (widget.selected) {
      background = theme.color(AstryxColorToken.accentMuted);
    } else if (_hovered && density.supportsHover) {
      background = theme.color(AstryxColorToken.overlayHover);
    } else if (widget.striped && widget.index.isOdd) {
      background = theme.color(AstryxColorToken.backgroundMuted);
    } else {
      background = const Color(0x00000000);
    }

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.selectable)
          SizedBox(
            width: widget.checkboxWidth,
            child: Center(
              child: AstryxCheckbox(
                label: widget.rowLabel == null
                    ? l10n.tableSelectRow
                    : l10n.tableSelectRowNamed(widget.rowLabel!),
                labelHidden: true,
                size: AstryxToggleSize.sm,
                value: widget.selected,
                onChanged: widget.onToggle == null
                    ? null
                    : (_) => widget.onToggle!(),
              ),
            ),
          ),
        for (var i = 0; i < widget.columns.length; i++)
          _BodyCell<T>(
            column: widget.columns[i],
            row: widget.row,
            width: widget.widths[i],
            density: widget.density,
            onIntrinsicWidth: widget.onIntrinsicWidth,
          ),
        if (widget.actions != null)
          SizedBox(
            width: widget.actionsWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(widget.density.horizontal),
              ),
              child: Center(child: widget.actions),
            ),
          ),
      ],
    );

    row = IntrinsicHeight(child: row);

    row = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: widget.showDivider
            ? Border(
                bottom: BorderSide(
                  color: theme.color(AstryxColorToken.border),
                  width: theme.borderWidth(),
                ),
              )
            : null,
      ),
      child: row,
    );

    if (widget.onPressed != null || widget.onToggle != null) {
      row = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: widget.onPressed != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: row,
        ),
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      selected: widget.selectable ? widget.selected : null,
      child: row,
    );
  }
}

/// One body cell.
class _BodyCell<T> extends StatelessWidget {
  const _BodyCell({
    required this.column,
    required this.row,
    required this.width,
    required this.density,
    required this.onIntrinsicWidth,
  });

  final AstryxTableColumn<T> column;
  final T row;
  final double width;
  final AstryxTableDensity density;
  final void Function(String columnId, double width) onIntrinsicWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing(density.vertical),
        horizontal: theme.spacing(density.horizontal),
      ),
      child: DefaultTextStyle.merge(
        style: theme.textStyle(AstryxTypeRole.body),
        textAlign: column.alignment.textAlign,
        child: column.cellBuilder(context, row),
      ),
    );

    if (column.width is AstryxIntrinsicColumnWidth) {
      content = _MeasureWidth(
        onMeasured: (w) => onIntrinsicWidth(column.id, w),
        child: content,
      );
    }

    return SizedBox(
      width: width,
      child: Align(alignment: column.alignment.alignment, child: content),
    );
  }
}

/// The "no data" body.
class _EmptyBody extends StatelessWidget {
  const _EmptyBody({
    required this.width,
    required this.density,
    required this.child,
  });

  final double width;
  final AstryxTableDensity density;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: theme.spacing(AstryxSpacingToken.spacing8),
          horizontal: theme.spacing(density.horizontal),
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Reports its child's unconstrained width.
///
/// The measuring half of an intrinsic column: the child lays out naturally,
/// this records how wide it wanted to be, and the table uses the maximum on
/// the next frame. See [AstryxIntrinsicColumnWidth] for the cost.
class _MeasureWidth extends SingleChildRenderObjectWidget {
  const _MeasureWidth({required this.onMeasured, required super.child});

  final ValueChanged<double> onMeasured;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureWidth(onMeasured);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureWidth renderObject,
  ) => renderObject.onMeasured = onMeasured;
}

class _RenderMeasureWidth extends RenderProxyBox {
  _RenderMeasureWidth(this.onMeasured);

  ValueChanged<double> onMeasured;

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    // The *intrinsic* width, not the laid-out one: the cell is already inside
    // a `SizedBox` of the current guess, so its actual size would just report
    // that guess back and the column would never grow.
    final intrinsic = child.getMaxIntrinsicWidth(double.infinity);
    child.layout(constraints, parentUsesSize: true);
    size = child.size;
    if (intrinsic.isFinite) onMeasured(intrinsic);
  }
}
