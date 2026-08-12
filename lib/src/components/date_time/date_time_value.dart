/// The value types the date and time widgets exchange.
///
/// Flutter's `TimeOfDay` and `DateTimeRange` live in `package:flutter/material`
/// — the one library this package is built to do without (ADR-002). So the two
/// values a date picker and a range picker have to report are declared here
/// instead, and a caller keeps using plain [DateTime] for everything else.
library;

import 'package:meta/meta.dart';

/// A day of the week, in ISO order.
///
/// Names the day a calendar's week starts on, so a caller writes
/// `AstryxWeekday.sunday` rather than the `7` that [DateTime.weekday] uses.
enum AstryxWeekday {
  /// Monday. The ISO-8601 first day, and this package's default.
  monday(DateTime.monday),

  /// Tuesday.
  tuesday(DateTime.tuesday),

  /// Wednesday.
  wednesday(DateTime.wednesday),

  /// Thursday.
  thursday(DateTime.thursday),

  /// Friday.
  friday(DateTime.friday),

  /// Saturday.
  saturday(DateTime.saturday),

  /// Sunday. Where a United States calendar starts its week.
  sunday(DateTime.sunday);

  const AstryxWeekday(this.value);

  /// The matching [DateTime.weekday] constant, 1 for Monday through 7 for
  /// Sunday.
  final int value;

  /// The weekday of [date].
  static AstryxWeekday of(DateTime date) =>
      AstryxWeekday.values[date.weekday - 1];
}

/// A time of day, to the minute.
///
/// The counterpart to a date-only [DateTime]: an hour and a minute with no day
/// attached, which is what a shift start, an office closing time or a reminder
/// actually is. Combine it with a date through [onDate] when a real instant is
/// needed.
///
/// {@tool snippet}
/// ```dart
/// const opening = AstryxTime(hour: 9, minute: 30);
/// final openedToday = opening.onDate(DateTime.now());
/// ```
/// {@end-tool}
@immutable
class AstryxTime implements Comparable<AstryxTime> {
  /// Creates a time of day.
  const AstryxTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24, 'hour must be in 0..23'),
      assert(minute >= 0 && minute < 60, 'minute must be in 0..59');

  /// The time of day [dateTime] falls at, dropping its date.
  AstryxTime.fromDateTime(DateTime dateTime)
    : hour = dateTime.hour,
      minute = dateTime.minute;

  /// Midnight.
  static const AstryxTime midnight = AstryxTime(hour: 0, minute: 0);

  /// Noon.
  static const AstryxTime noon = AstryxTime(hour: 12, minute: 0);

  /// The hour on a 24-hour clock, 0 through 23.
  final int hour;

  /// The minute, 0 through 59.
  final int minute;

  /// How far into the day this is, in minutes.
  int get minutesSinceMidnight => hour * 60 + minute;

  /// Whether this is before noon — the `am` half of a 12-hour clock.
  bool get isBeforeNoon => hour < 12;

  /// The hour on a 12-hour clock, 1 through 12.
  ///
  /// Midnight and noon are both 12, which is the convention every clock face
  /// uses and the one nobody expects to have to think about.
  int get hour12 => hour % 12 == 0 ? 12 : hour % 12;

  /// This time moved by [minutes], wrapping at midnight in either direction.
  ///
  /// Wrapping rather than clamping, because a field stepped down from 00:15 is
  /// being walked round the clock, not pushed against a floor that does not
  /// exist.
  AstryxTime plusMinutes(int minutes) {
    final total = (minutesSinceMidnight + minutes) % (24 * 60);
    final wrapped = total < 0 ? total + 24 * 60 : total;
    return AstryxTime(hour: wrapped ~/ 60, minute: wrapped % 60);
  }

  /// This time on [date], as an instant.
  ///
  /// [date]'s own time-of-day is discarded, so passing `DateTime.now()` is
  /// safe.
  DateTime onDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);

  @override
  int compareTo(AstryxTime other) =>
      minutesSinceMidnight.compareTo(other.minutesSinceMidnight);

  /// Whether this is earlier in the day than [other].
  bool isBefore(AstryxTime other) =>
      minutesSinceMidnight < other.minutesSinceMidnight;

  /// Whether this is later in the day than [other].
  bool isAfter(AstryxTime other) =>
      minutesSinceMidnight > other.minutesSinceMidnight;

  @override
  bool operator ==(Object other) =>
      other is AstryxTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() =>
      'AstryxTime(${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')})';
}

/// A span of days, inclusive at both ends.
///
/// Both ends are days rather than instants: [start] and [end] are normalised to
/// midnight, so a range picked from a calendar compares equal however the
/// caller's clock happened to be set. "The 4th to the 6th" is three days, not
/// two-and-a-bit.
@immutable
class AstryxDateRange {
  /// Creates a range, normalising both ends to midnight.
  AstryxDateRange({required DateTime start, required DateTime end})
    : start = astryxStartOfDay(start),
      end = astryxStartOfDay(end) {
    assert(
      !this.start.isAfter(this.end),
      'start must not be after end — swap them before constructing a range',
    );
  }

  /// A range covering the single day [day].
  AstryxDateRange.day(DateTime day)
    : start = astryxStartOfDay(day),
      end = astryxStartOfDay(day);

  /// The first day in the range, at midnight.
  final DateTime start;

  /// The last day in the range, at midnight. Inclusive.
  final DateTime end;

  /// How many days the range covers, counting both ends.
  int get days => end.difference(start).inDays + 1;

  /// Whether the range covers exactly one day.
  bool get isSingleDay => days == 1;

  /// Whether [day] falls inside the range, ends included.
  bool contains(DateTime day) {
    final at = astryxStartOfDay(day);
    return !at.isBefore(start) && !at.isAfter(end);
  }

  @override
  bool operator ==(Object other) =>
      other is AstryxDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'AstryxDateRange($start – $end)';
}

/// [date] with its time of day removed.
///
/// The whole date layer compares days, not instants, and `DateTime` equality is
/// to the microsecond — so every day that arrives from a caller goes through
/// here first.
DateTime astryxStartOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Whether [a] and [b] fall on the same day.
bool astryxIsSameDay(DateTime? a, DateTime? b) =>
    a != null &&
    b != null &&
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day;

/// Whether [a] and [b] fall in the same calendar month.
bool astryxIsSameMonth(DateTime? a, DateTime? b) =>
    a != null && b != null && a.year == b.year && a.month == b.month;

/// [date] moved by [days], across month and year boundaries.
///
/// Built with the `DateTime` constructor rather than by adding a [Duration]:
/// a duration of 24 hours is not a day on the two days a year a daylight-saving
/// change makes it 23 or 25.
DateTime astryxAddDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// [date] moved by [months], clamping the day to the target month's length.
///
/// The 31st of January stepped forward one month is the 28th of February, not
/// the 3rd of March — which is what the plain `DateTime` constructor would
/// roll it over to.
DateTime astryxAddMonths(DateTime date, int months) {
  final target = DateTime(date.year, date.month + months);
  final lastDay = DateTime(target.year, target.month + 1, 0).day;
  return DateTime(
    target.year,
    target.month,
    date.day < lastDay ? date.day : lastDay,
  );
}

/// The first day of the month [date] falls in, at midnight.
DateTime astryxStartOfMonth(DateTime date) => DateTime(date.year, date.month);
