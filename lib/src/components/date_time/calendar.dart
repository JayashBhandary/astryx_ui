/// A month grid for picking a day, or a span of them.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether [day] may be chosen.
///
/// Called for every cell a month shows, so keep it cheap — a set lookup, not a
/// request.
typedef AstryxDayPredicate = bool Function(DateTime day);

/// A month grid for picking a date.
///
/// Six rows of seven, always: a month that needs five rows still reserves six,
/// because a grid that changes height when the user pages through it moves
/// everything below it — and inside a popover, moves the popover.
///
/// **The grid is one tab stop.** Tab moves onto it and off it; the arrow keys
/// move within it. That is the ARIA grid pattern, and it is what stops a date
/// picker from being thirty-one tab stops between a user and the next field.
/// Roving focus is separate from selection, so arrowing around does not pick
/// anything until Enter or Space says so.
///
/// {@tool snippet}
/// ```dart
/// AstryxCalendar(
///   selected: _due,
///   firstDate: DateTime.now(),
///   onChanged: (day) => setState(() => _due = day),
/// )
/// ```
/// {@end-tool}
///
/// [AstryxCalendar.range] picks two days instead of one. For a field that shows
/// the value as text and keeps this behind a button, use `AstryxDateInput` or
/// `AstryxDateRangeInput` — a bare calendar belongs in a page that is *about*
/// dates, such as an availability screen.
class AstryxCalendar extends StatefulWidget {
  /// Creates a calendar that picks one day.
  const AstryxCalendar({
    super.key,
    this.selected,
    this.onChanged,
    this.month,
    this.onMonthChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.firstDayOfWeek = AstryxWeekday.monday,
    this.label,
    this.enabled = true,
    this.today,
    this.focusNode,
    this.autofocus = false,
  }) : range = null,
       onRangeChanged = null,
       _isRange = false;

  /// Creates a calendar that picks a span of days.
  ///
  /// Two presses make a range: the first sets one end, the second the other.
  /// The order does not matter — pressing an earlier day second completes the
  /// range backwards rather than starting over, because a user who has already
  /// pressed twice has said which two days they mean.
  const AstryxCalendar.range({
    super.key,
    this.range,
    this.onRangeChanged,
    this.month,
    this.onMonthChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.firstDayOfWeek = AstryxWeekday.monday,
    this.label,
    this.enabled = true,
    this.today,
    this.focusNode,
    this.autofocus = false,
  }) : selected = null,
       onChanged = null,
       _isRange = true;

  /// The chosen day, or null for none. Only its date part is read.
  final DateTime? selected;

  /// Called with the day that was chosen, at midnight.
  ///
  /// Null makes the calendar a read-only display of [selected] — useful for a
  /// month that is showing availability rather than collecting an answer.
  final ValueChanged<DateTime>? onChanged;

  /// The chosen span, or null for none.
  final AstryxDateRange? range;

  /// Called once both ends of a span have been pressed.
  ///
  /// Not called for the first press: half a range is not a range, and reporting
  /// one would make every caller handle a state the calendar already owns.
  final ValueChanged<AstryxDateRange>? onRangeChanged;

  /// The month on show. Null lets the calendar page itself.
  ///
  /// Pass one to drive the header from outside — two calendars showing
  /// consecutive months, say. Then [onMonthChanged] is where the presses go.
  final DateTime? month;

  /// Called with the first day of the month now on show.
  final ValueChanged<DateTime>? onMonthChanged;

  /// The earliest selectable day. Null for no floor.
  ///
  /// Days outside the bounds are shown and dimmed rather than hidden, so the
  /// grid keeps its shape and a user can see *why* they cannot reach a date.
  final DateTime? firstDate;

  /// The latest selectable day. Null for no ceiling.
  final DateTime? lastDate;

  /// Rules out individual days inside the bounds — weekends, a holiday, a day
  /// already fully booked.
  final AstryxDayPredicate? selectableDayPredicate;

  /// Which day the week starts on. Monday by default, as ISO-8601 has it.
  final AstryxWeekday firstDayOfWeek;

  /// An accessible name for the grid. Defaults to "Calendar".
  final String? label;

  /// Whether the calendar accepts presses.
  final bool enabled;

  /// What counts as today, for the ring and for the announcement.
  ///
  /// Defaults to the system clock. Passing one makes a widget test — and a
  /// screenshot — reproducible, which is the only reason it is here.
  final DateTime? today;

  /// The focus node for the grid, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether the grid takes focus when first built.
  final bool autofocus;

  final bool _isRange;

  @override
  State<AstryxCalendar> createState() => _AstryxCalendarState();
}

class _AstryxCalendarState extends State<AstryxCalendar> {
  /// The month the grid is showing, when the caller is not driving it.
  late DateTime _month;

  /// Where the roving focus sits. Never null: a grid that is tabbed into has to
  /// put focus on a day, and the ARIA pattern says that is the selection, or
  /// today, or the first day in bounds.
  late DateTime _focusedDay;

  /// The first end of a range that is half chosen.
  DateTime? _pendingStart;

  bool _hasFocus = false;
  DateTime? _hoveredDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _initialFocus();
    _month = astryxStartOfMonth(widget.month ?? _focusedDay);
  }

  @override
  void didUpdateWidget(AstryxCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A value that changed underneath us — a form reset, a preset button — is
    // followed by both the focus and the month on show.
    final anchor = widget.selected ?? widget.range?.start;
    final previousAnchor = oldWidget.selected ?? oldWidget.range?.start;
    if (anchor != null && anchor != previousAnchor) {
      _focusedDay = astryxStartOfDay(anchor);
      _pendingStart = null;
      if (widget.month == null) _month = astryxStartOfMonth(_focusedDay);
    }
  }

  DateTime _initialFocus() {
    final anchor = widget.selected ?? widget.range?.start ?? _today;
    return _clampToBounds(astryxStartOfDay(anchor));
  }

  DateTime get _today => astryxStartOfDay(widget.today ?? DateTime.now());

  DateTime? get _firstDate => widget.firstDate == null
      ? null
      : astryxStartOfDay(widget.firstDate!);

  DateTime? get _lastDate =>
      widget.lastDate == null ? null : astryxStartOfDay(widget.lastDate!);

  DateTime get _visibleMonth =>
      astryxStartOfMonth(widget.month ?? _month);

  bool get _interactive =>
      widget.enabled &&
      (widget._isRange
          ? widget.onRangeChanged != null
          : widget.onChanged != null);

  bool _inBounds(DateTime day) {
    final first = _firstDate;
    final last = _lastDate;
    if (first != null && day.isBefore(first)) return false;
    if (last != null && day.isAfter(last)) return false;
    return true;
  }

  bool _isSelectable(DateTime day) =>
      _inBounds(day) && (widget.selectableDayPredicate?.call(day) ?? true);

  DateTime _clampToBounds(DateTime day) {
    final first = _firstDate;
    final last = _lastDate;
    if (first != null && day.isBefore(first)) return first;
    if (last != null && day.isAfter(last)) return last;
    return day;
  }

  /// Shows [month], and tells the caller if they asked to be told.
  void _showMonth(DateTime month) {
    final start = astryxStartOfMonth(month);
    if (widget.month == null) setState(() => _month = start);
    widget.onMonthChanged?.call(start);
  }

  /// Moves the roving focus by [days], following the month it lands in.
  void _moveFocus(int days) {
    final target = _clampToBounds(astryxAddDays(_focusedDay, days));
    setState(() => _focusedDay = target);
    if (!astryxIsSameMonth(target, _visibleMonth)) _showMonth(target);
  }

  void _moveFocusMonths(int months) {
    final target = _clampToBounds(astryxAddMonths(_focusedDay, months));
    setState(() => _focusedDay = target);
    if (!astryxIsSameMonth(target, _visibleMonth)) _showMonth(target);
  }

  /// The offset of [day] within its displayed week, 0 through 6.
  int _weekdayIndex(DateTime day) =>
      (day.weekday - widget.firstDayOfWeek.value + 7) % 7;

  void _pick(DateTime day) {
    if (!_interactive || !_isSelectable(day)) return;
    final picked = astryxStartOfDay(day);

    setState(() => _focusedDay = picked);
    if (!astryxIsSameMonth(picked, _visibleMonth)) _showMonth(picked);

    if (!widget._isRange) {
      widget.onChanged!(picked);
      return;
    }

    final pending = _pendingStart;
    if (pending == null) {
      setState(() => _pendingStart = picked);
      return;
    }

    setState(() => _pendingStart = null);
    widget.onRangeChanged!(
      picked.isBefore(pending)
          ? AstryxDateRange(start: picked, end: pending)
          : AstryxDateRange(start: pending, end: picked),
    );
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    final rtl = Directionality.of(context) == TextDirection.rtl;
    // A year jump on Shift, which is the difference between reaching a birthday
    // and pressing "previous month" ninety times.
    final byYear = HardwareKeyboard.instance.isShiftPressed;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _moveFocus(rtl ? 1 : -1);
      case LogicalKeyboardKey.arrowRight:
        _moveFocus(rtl ? -1 : 1);
      case LogicalKeyboardKey.arrowUp:
        _moveFocus(-7);
      case LogicalKeyboardKey.arrowDown:
        _moveFocus(7);
      case LogicalKeyboardKey.home:
        _moveFocus(-_weekdayIndex(_focusedDay));
      case LogicalKeyboardKey.end:
        _moveFocus(6 - _weekdayIndex(_focusedDay));
      case LogicalKeyboardKey.pageUp:
        _moveFocusMonths(byYear ? -12 : -1);
      case LogicalKeyboardKey.pageDown:
        _moveFocusMonths(byYear ? 12 : 1);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        _pick(_focusedDay);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final density = AstryxTheme.densityOf(context);

    // The cell is a control, so it obeys the tap-target floor on touch the same
    // way a button does.
    final base = theme.size(AstryxSizeToken.elementMd);
    final extent = base < density.minimumTapTarget
        ? density.minimumTapTarget
        : base;

    final month = _visibleMonth;
    final gridStart = astryxAddDays(
      month,
      -_weekdayIndex(month),
    );

    final grid = AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        _buildWeekdayHeader(l10n, extent),
        for (var week = 0; week < 6; week++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var day = 0; day < 7; day++)
                _buildDay(
                  theme,
                  l10n,
                  density,
                  astryxAddDays(gridStart, week * 7 + day),
                  extent,
                ),
            ],
          ),
      ],
    );

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        _buildHeader(l10n, month),
        Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          canRequestFocus: _interactive,
          onKeyEvent: _handleKey,
          onFocusChange: (focused) {
            if (mounted) setState(() => _hasFocus = focused);
          },
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            label: widget.label ?? l10n.calendarLabel,
            child: grid,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AstryxLocalizations l10n, DateTime month) {
    // Paging is refused rather than hidden when the next month holds nothing
    // selectable, so the two buttons never move.
    final previous = astryxAddMonths(month, -1);
    final next = astryxAddMonths(month, 1);
    final first = _firstDate;
    final last = _lastDate;

    return AstryxHStack(
      mainAxisSize: MainAxisSize.max,
      justify: AstryxStackJustify.between,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.chevronLeft,
          label: l10n.calendarPreviousMonth,
          tooltip: l10n.calendarPreviousMonth,
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          enabled:
              widget.enabled &&
              (first == null ||
                  !astryxStartOfMonth(previous).isBefore(
                    astryxStartOfMonth(first),
                  )),
          onPressed: () => _showMonth(previous),
        ),
        AstryxText(
          formatAstryxMonthYear(month, l10n),
          type: AstryxTextType.label,
        ),
        AstryxIconButton(
          icon: AstryxIconName.chevronRight,
          label: l10n.calendarNextMonth,
          tooltip: l10n.calendarNextMonth,
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          enabled:
              widget.enabled &&
              (last == null ||
                  !astryxStartOfMonth(next).isAfter(
                    astryxStartOfMonth(last),
                  )),
          onPressed: () => _showMonth(next),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader(AstryxLocalizations l10n, double extent) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (var i = 0; i < 7; i++)
        SizedBox(
          width: extent,
          // The headings are decorative: each cell already names its own
          // weekday in full, so announcing "Mon" as well says it twice.
          child: ExcludeSemantics(
            child: Center(
              child: AstryxText(
                // Rotated out of the Monday-first list, so a Sunday-first
                // calendar needs no second set of strings.
                _weekdayShortName(l10n, i),
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
          ),
        ),
    ],
  );

  String _weekdayShortName(AstryxLocalizations l10n, int column) {
    final index = (widget.firstDayOfWeek.value - 1 + column) % 7;
    return l10n.weekdayNamesShort[index];
  }

  Widget _buildDay(
    AstryxThemeData theme,
    AstryxLocalizations l10n,
    AstryxDensity density,
    DateTime day,
    double extent,
  ) {
    final range = widget.range;
    final pending = _pendingStart;

    final selectable = _isSelectable(day) && _interactive;
    final outside = !astryxIsSameMonth(day, _visibleMonth);
    final today = astryxIsSameDay(day, _today);

    final isSelected =
        astryxIsSameDay(day, widget.selected) || astryxIsSameDay(day, pending);
    final isRangeStart =
        range != null && astryxIsSameDay(day, range.start) && pending == null;
    final isRangeEnd =
        range != null && astryxIsSameDay(day, range.end) && pending == null;
    final inRange =
        range != null &&
        pending == null &&
        range.contains(day) &&
        !isRangeStart &&
        !isRangeEnd;

    final filled = isSelected || isRangeStart || isRangeEnd;
    final roving = astryxIsSameDay(day, _focusedDay);

    final label = <String>[
      formatAstryxLongDate(day, l10n),
      if (today) l10n.calendarToday,
      if (isRangeStart) l10n.calendarRangeStart,
      if (isRangeEnd) l10n.calendarRangeEnd,
    ].join(', ');

    return Semantics(
      button: true,
      enabled: selectable,
      selected: filled || inRange,
      label: label,
      onTap: selectable ? () => _pick(day) : null,
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: selectable
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hoveredDay = day),
          onExit: (_) => setState(() {
            if (astryxIsSameDay(_hoveredDay, day)) _hoveredDay = null;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: selectable ? () => _pick(day) : null,
            child: AstryxFocusRing(
              // Only the day the roving focus sits on rings, and only while the
              // grid itself has focus — otherwise every month shows a ring.
              focused: roving && _hasFocus,
              borderRadius: BorderRadius.circular(
                theme.radius(AstryxRadiusToken.element),
              ),
              child: _DayCell(
                theme: theme,
                day: day,
                extent: extent,
                filled: filled,
                inRange: inRange,
                rangeStart: isRangeStart && !isRangeEnd,
                rangeEnd: isRangeEnd && !isRangeStart,
                today: today,
                selectable: selectable,
                outside: outside,
                hovered:
                    astryxIsSameDay(_hoveredDay, day) &&
                    selectable &&
                    density.supportsHover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One day, painted.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.theme,
    required this.day,
    required this.extent,
    required this.filled,
    required this.inRange,
    required this.rangeStart,
    required this.rangeEnd,
    required this.today,
    required this.selectable,
    required this.outside,
    required this.hovered,
  });

  final AstryxThemeData theme;
  final DateTime day;
  final double extent;
  final bool filled;
  final bool inRange;
  final bool rangeStart;
  final bool rangeEnd;
  final bool today;
  final bool selectable;
  final bool outside;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final corner = Radius.circular(theme.radius(AstryxRadiusToken.element));

    // The ends of a range keep the corners that face outwards and square the
    // ones that face the days between them, so the span reads as one bar.
    final radius = rangeStart
        ? BorderRadiusDirectional.horizontal(start: corner)
        : rangeEnd
        ? BorderRadiusDirectional.horizontal(end: corner)
        : inRange
        ? BorderRadius.zero
        : BorderRadius.all(corner);

    final background = filled
        ? theme.color(AstryxColorToken.accent)
        : inRange
        ? theme.color(AstryxColorToken.accentMuted)
        : hovered
        ? theme.color(AstryxColorToken.overlayHover)
        : null;

    final textColor = filled
        ? theme.color(AstryxColorToken.onAccent)
        : !selectable
        ? theme.color(AstryxColorToken.textDisabled)
        : outside
        ? theme.color(AstryxColorToken.textSecondary)
        : theme.color(AstryxColorToken.textPrimary);

    return Container(
      width: extent,
      height: extent,
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        // Today is ringed rather than tinted: a tint is one more colour to tell
        // apart from selection, and a ring survives both.
        border: today && !filled
            ? Border.all(
                color: theme.color(AstryxColorToken.accent),
                width: theme.borderWidth(),
              )
            : null,
      ),
      child: Center(
        child: AstryxText(
          '${day.day}',
          color: AstryxTextColor.inherit,
          tabularNumbers: true,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
