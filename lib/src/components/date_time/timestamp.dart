/// An instant, written the way a reader wants it.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/date_time/date_time_format.dart';
import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// How an [AstryxTimestamp] writes its instant.
enum AstryxTimestampFormat {
  /// "3 minutes ago", falling back to a date once it is old enough.
  relative,

  /// The date alone — "04/08/2026".
  date,

  /// The time of day alone — "14:30".
  time,

  /// Both — "04/08/2026 14:30".
  dateTime,
}

/// An instant, rendered relative and kept current.
///
/// "3 minutes ago" is the right answer for something that just happened and the
/// wrong one for something from March, so a relative timestamp falls back to a
/// date once it is older than [threshold]. It also **re-renders as it ages**:
/// a row that said "just now" when the page loaded says "5 minutes ago" five
/// minutes later, without the caller rebuilding anything.
///
/// {@tool snippet}
/// ```dart
/// AstryxTimestamp(deployedAt)
/// ```
/// {@end-tool}
///
/// The exact instant is always reachable: it is this widget's accessible name,
/// so a screen reader says "4 August 2026 at 14:30" rather than a relative
/// phrase whose anchor it cannot see, and it is in the tooltip for everybody
/// else. The relative text stays visible either way — a tooltip is never the
/// only source of a fact.
class AstryxTimestamp extends StatefulWidget {
  /// Creates a timestamp.
  const AstryxTimestamp(
    this.value, {
    super.key,
    this.format = AstryxTimestampFormat.relative,
    this.dateFormat = AstryxDateFormat.dayMonthYear,
    this.timeFormat = AstryxTimeFormat.h24,
    this.threshold = const Duration(days: 7),
    this.tooltip = true,
    this.live = true,
    this.type = AstryxTextType.body,
    this.color = AstryxTextColor.primary,
    this.now,
  });

  /// The instant being written.
  final DateTime value;

  /// How to write it.
  final AstryxTimestampFormat format;

  /// The order the parts of a date are written in.
  final AstryxDateFormat dateFormat;

  /// Whether a time is written on a twelve- or twenty-four-hour clock.
  final AstryxTimeFormat timeFormat;

  /// How old a [AstryxTimestampFormat.relative] instant may get before it is
  /// written as a date instead.
  ///
  /// A week by default. "43 days ago" is arithmetic nobody asked for.
  final Duration threshold;

  /// Whether to show the exact instant on hover, focus or long-press.
  final bool tooltip;

  /// Whether to re-render as the instant ages.
  ///
  /// Set false for a timestamp in a long list that is rebuilt often anyway, or
  /// where a hundred timers is a hundred timers too many.
  final bool live;

  /// {@macro AstryxText.type}
  final AstryxTextType type;

  /// {@macro AstryxText.color}
  final AstryxTextColor color;

  /// What counts as now. Defaults to the system clock.
  ///
  /// Passing one also stops the ticking, which is what makes a widget test of a
  /// relative timestamp deterministic.
  final DateTime? now;

  @override
  State<AstryxTimestamp> createState() => _AstryxTimestampState();
}

class _AstryxTimestampState extends State<AstryxTimestamp> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(AstryxTimestamp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        widget.live != oldWidget.live ||
        widget.format != oldWidget.format) {
      _schedule();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Books the next re-render, at a distance matching how fast the text can
  /// change.
  ///
  /// A single-shot timer that re-books itself, rather than one ticking every
  /// second: a stamp from last March cannot change this minute, and a list of
  /// two hundred rows should not wake the framework two hundred times a second
  /// to prove it.
  void _schedule() {
    _timer?.cancel();
    _timer = null;

    if (!widget.live ||
        widget.now != null ||
        widget.format != AstryxTimestampFormat.relative) {
      return;
    }

    final age = DateTime.now().difference(widget.value).abs();
    if (age > widget.threshold) return;

    final interval = age.inMinutes < 60
        ? const Duration(seconds: 30)
        : age.inHours < 24
        ? const Duration(minutes: 5)
        : const Duration(hours: 1);

    _timer = Timer(interval, () {
      if (!mounted) return;
      setState(() {});
      _schedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final now = widget.now ?? DateTime.now();

    final exact = formatAstryxDateTime(
      widget.value,
      widget.dateFormat,
      widget.timeFormat,
      l10n,
    );

    final text = switch (widget.format) {
      AstryxTimestampFormat.relative => _relative(l10n, now),
      AstryxTimestampFormat.date => formatAstryxDate(
        widget.value,
        widget.dateFormat,
      ),
      AstryxTimestampFormat.time => formatAstryxTime(
        AstryxTime.fromDateTime(widget.value),
        widget.timeFormat,
        l10n,
      ),
      AstryxTimestampFormat.dateTime => exact,
    };

    final spoken = formatAstryxTime(
      AstryxTime.fromDateTime(widget.value),
      widget.timeFormat,
      l10n,
    );

    final rendered = AstryxText(
      text,
      type: widget.type,
      color: widget.color,
      // The long form is the accessible name, so a relative phrase is never the
      // only thing a screen-reader user is given.
      semanticsLabel:
          '${formatAstryxLongDate(widget.value, l10n)}, $spoken',
    );

    if (!widget.tooltip) return rendered;

    return AstryxTooltip(
      message: exact,
      // The name above already carries the instant; a tooltip that repeats it
      // makes a screen reader say the date twice.
      excludeFromSemantics: true,
      child: rendered,
    );
  }

  /// The relative phrase, or a date once the instant is older than the
  /// threshold.
  String _relative(AstryxLocalizations l10n, DateTime now) {
    final difference = now.difference(widget.value);
    final age = difference.abs();

    if (age > widget.threshold) {
      return astryxIsSameDay(widget.value, now)
          ? formatAstryxTime(
              AstryxTime.fromDateTime(widget.value),
              widget.timeFormat,
              l10n,
            )
          : formatAstryxDate(widget.value, widget.dateFormat);
    }

    // Under three quarters of a minute is "just now" in both directions: the
    // difference between 12 and 31 seconds is not worth a re-render, and a
    // clock a second or two out of step must not read "in 1 minute".
    if (age.inSeconds < 45) return l10n.timestampJustNow;

    final future = difference.isNegative;

    if (age.inMinutes < 60) {
      return future
          ? l10n.timestampInMinutes(age.inMinutes)
          : l10n.timestampMinutesAgo(age.inMinutes);
    }
    if (age.inHours < 24) {
      return future
          ? l10n.timestampInHours(age.inHours)
          : l10n.timestampHoursAgo(age.inHours);
    }
    return future
        ? l10n.timestampInDays(age.inDays)
        : l10n.timestampDaysAgo(age.inDays);
  }
}
