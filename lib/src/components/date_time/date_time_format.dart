/// Writing and reading dates and times, without `intl`.
///
/// The package has no `intl` dependency, and adding one to render "04/08/2026"
/// would be a heavy way to buy a `padLeft`. What a real localisation needs —
/// month and weekday names, and whether a clock has twelve hours or
/// twenty-four — comes from `AstryxLocalizations`, which is already the seam a
/// caller overrides. The part order is a field's own decision, because the
/// place a form is used is not always the place its data came from.
library;

import 'package:astryx_ui/src/components/date_time/date_time_value.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';

/// The order the parts of a numeric date are written in.
enum AstryxDateFormat {
  /// `04/08/2026` — day, month, year. Most of the world.
  dayMonthYear('DD/MM/YYYY', '/'),

  /// `08/04/2026` — month, day, year. The United States.
  monthDayYear('MM/DD/YYYY', '/'),

  /// `2026-08-04` — ISO-8601. Sorts as text, and is never ambiguous.
  yearMonthDay('YYYY-MM-DD', '-');

  const AstryxDateFormat(this.hint, this.separator);

  /// The pattern, for a field's placeholder.
  ///
  /// A date field shows this when it is empty: "DD/MM/YYYY" tells a user which
  /// of the two ambiguous orders this field wants, and nothing else does.
  final String hint;

  /// The character between the parts.
  final String separator;
}

/// Whether a time is written on a twelve- or twenty-four-hour clock.
enum AstryxTimeFormat {
  /// `2:30 pm`.
  h12('HH:MM am'),

  /// `14:30`.
  h24('HH:MM');

  const AstryxTimeFormat(this.hint);

  /// The pattern, for a field's placeholder.
  final String hint;
}

/// [date] as digits, in [format]'s order.
String formatAstryxDate(DateTime date, AstryxDateFormat format) {
  final day = _pad(date.day);
  final month = _pad(date.month);
  final year = date.year.toString().padLeft(4, '0');
  final separator = format.separator;

  return switch (format) {
    AstryxDateFormat.dayMonthYear => '$day$separator$month$separator$year',
    AstryxDateFormat.monthDayYear => '$month$separator$day$separator$year',
    AstryxDateFormat.yearMonthDay => '$year$separator$month$separator$day',
  };
}

/// [input] read as a date in [format]'s order, or null if it is not one.
///
/// Deliberately forgiving about *shape* and strict about *meaning*. Any run of
/// non-digits separates the parts, so `4-8-26`, `04/08/2026` and `4 8 2026` all
/// land on the same day; a two-digit year is read as this century. But
/// `31/02/2026` returns null rather than the 3rd of March, because a field that
/// silently moves a date the user typed is worse than one that refuses it.
DateTime? parseAstryxDate(String input, AstryxDateFormat format) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;

  final parts = trimmed
      .split(RegExp('[^0-9]+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.length != 3) return null;

  final numbers = <int>[];
  for (final part in parts) {
    final value = int.tryParse(part);
    if (value == null) return null;
    numbers.add(value);
  }

  final (year, month, day) = switch (format) {
    AstryxDateFormat.dayMonthYear => (numbers[2], numbers[1], numbers[0]),
    AstryxDateFormat.monthDayYear => (numbers[2], numbers[0], numbers[1]),
    AstryxDateFormat.yearMonthDay => (numbers[0], numbers[1], numbers[2]),
  };

  final fullYear = year < 100 ? 2000 + year : year;
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;

  final parsed = DateTime(fullYear, month, day);
  // The round-trip is the validation: `DateTime(2026, 2, 31)` is a real object
  // pointing at the 3rd of March, and only comparing the parts back catches it.
  if (parsed.year != fullYear || parsed.month != month || parsed.day != day) {
    return null;
  }
  return parsed;
}

/// [time] on [format]'s clock.
String formatAstryxTime(
  AstryxTime time,
  AstryxTimeFormat format,
  AstryxLocalizations l10n,
) => switch (format) {
  AstryxTimeFormat.h24 => '${_pad(time.hour)}:${_pad(time.minute)}',
  AstryxTimeFormat.h12 =>
    '${time.hour12}:${_pad(time.minute)} '
        '${time.isBeforeNoon ? l10n.timeAnteMeridiem : l10n.timePostMeridiem}',
};

/// [input] read as a time of day, or null if it is not one.
///
/// Accepts `9`, `930`, `9:30`, `9.30`, `09:30` and any of those with an `am` or
/// `pm` suffix, on either clock — somebody typing into a 24-hour field who
/// writes "2pm" means 14:00, and refusing that would be pedantry. Out-of-range
/// values return null rather than wrapping.
AstryxTime? parseAstryxTime(String input, AstryxLocalizations l10n) {
  var text = input.trim().toLowerCase();
  if (text.isEmpty) return null;

  final am = l10n.timeAnteMeridiem.toLowerCase();
  final pm = l10n.timePostMeridiem.toLowerCase();

  bool? afternoon;
  for (final (suffix, isAfternoon) in <(String, bool)>[
    (pm, true),
    (am, false),
    ('p', true),
    ('a', false),
  ]) {
    if (suffix.isNotEmpty && text.endsWith(suffix)) {
      afternoon = isAfternoon;
      text = text.substring(0, text.length - suffix.length).trim();
      break;
    }
  }

  final digits = text.split(RegExp('[^0-9]+')).where((p) => p.isNotEmpty);
  final int hour;
  final int minute;

  if (digits.length >= 2) {
    hour = int.tryParse(digits.first) ?? -1;
    minute = int.tryParse(digits.elementAt(1)) ?? -1;
  } else if (digits.length == 1) {
    final compact = digits.first;
    // "930" is half past nine, "9" is nine o'clock: a bare run of digits is
    // read from the right, because the minutes are always the last two.
    if (compact.length <= 2) {
      hour = int.tryParse(compact) ?? -1;
      minute = 0;
    } else if (compact.length <= 4) {
      hour = int.tryParse(compact.substring(0, compact.length - 2)) ?? -1;
      minute = int.tryParse(compact.substring(compact.length - 2)) ?? -1;
    } else {
      return null;
    }
  } else {
    return null;
  }

  if (minute < 0 || minute > 59) return null;

  var resolved = hour;
  if (afternoon != null) {
    if (hour < 1 || hour > 12) return null;
    // `12 pm` is noon and `12 am` is midnight; every other hour is itself, plus
    // twelve in the afternoon.
    resolved = afternoon
        ? (hour == 12 ? 12 : hour + 12)
        : (hour == 12 ? 0 : hour);
  }
  if (resolved < 0 || resolved > 23) return null;

  return AstryxTime(hour: resolved, minute: minute);
}

/// [date] written in full — its day in [dateFormat], its time in [timeFormat].
String formatAstryxDateTime(
  DateTime date,
  AstryxDateFormat dateFormat,
  AstryxTimeFormat timeFormat,
  AstryxLocalizations l10n,
) =>
    '${formatAstryxDate(date, dateFormat)} '
    '${formatAstryxTime(AstryxTime.fromDateTime(date), timeFormat, l10n)}';

/// The month and year of [month], spelled out — "August 2026".
///
/// A calendar's heading, and the one place a month is named rather than
/// numbered: "08/2026" is a heading nobody reads aloud.
String formatAstryxMonthYear(DateTime month, AstryxLocalizations l10n) =>
    '${l10n.monthNames[month.month - 1]} ${month.year}';

/// [date] spelled out — "Tuesday, 4 August 2026".
///
/// What a day cell announces. A grid of numbers is unusable through a screen
/// reader unless each cell says which day it is, and the weekday is the part a
/// user is usually counting.
String formatAstryxLongDate(DateTime date, AstryxLocalizations l10n) =>
    '${l10n.weekdayNames[date.weekday - 1]}, ${date.day} '
    '${l10n.monthNames[date.month - 1]} ${date.year}';

String _pad(int value) => value.toString().padLeft(2, '0');
