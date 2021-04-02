library isoweek;

import 'package:equatable/equatable.dart';

class Week extends Equatable {
  const Week({
    required this.year,
    required this.weekNumber,
  });

  final int year;
  final int weekNumber;

  @override
  List<Object> get props => [year, weekNumber];

  /// Return the ordinal date, the number of days since December 31st the previous year.
  static int _ordinalDate(DateTime date) {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[date.month - 1] +
        date.day +
        (_isLeapYear(date.year) && date.month > 2 ? 1 : 0);
  }

  /// Return true if the given year is a leap year.
  static bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Return the week that contains the given date.
  factory Week.fromDate(DateTime date) {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = ((_ordinalDate(date) - date.weekday + 10) ~/ 7);

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return Week.fromDate(DateTime(date.year - 1, 12, 28));
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(date.year, 1, 1).weekday != DateTime.thursday &&
        DateTime(date.year, 12, 31).weekday != DateTime.thursday) {
      return Week(year: date.year + 1, weekNumber: 1);
    }

    return Week(year: date.year, weekNumber: woy);
  }

  /// Return the current week.
  factory Week.current() => Week.fromDate(DateTime.now());

  /// Return a week initialized from an ISO formatted string like "2020W01" or "2020-W01" (or even "2020-W1" or "2020W1").
  factory Week.fromISOString(String isoString) {
    final parts = isoString.split('W');

    var yearStr = parts[0];
    if (yearStr.length > 4) {
      // If separated with - (e.g. "2020-W01")
      yearStr = yearStr.substring(0, 4);
    }
    final weekNumberStr = parts[1];

    final year = int.parse(yearStr);
    final weekNumber = int.parse(weekNumberStr);

    return Week(year: year, weekNumber: weekNumber);
  }

  /// Return the week that many number of weeks into the future.
  Week addWeeks(int weeks) {
    return Week.fromDate(day(0).addWeeks(weeks));
  }

  /// Return the week that many number of weeks in the past.
  Week subtractWeeks(int weeks) {
    return Week.fromDate(day(0).subtractWeeks(weeks));
  }

  /// Return a day of the week as a DateTime object based on the provided day index. Day 0 is Monday.
  DateTime day(int day) {
    // According to ISO the Jan 4th must be in week 1
    final addDays =
        (weekNumber - 1) * 7 + (-DateTime(year, 1, 4).weekday + day) + 1;
    return DateTime(year, 1, 4).addDays(addDays);
  }

  /// Return the next week.
  Week get next => addWeeks(1);

  /// Return the week before.
  Week get previous => subtractWeeks(1);

  /// Return a list of all days in the week.
  List<DateTime> get days => List.generate(7, (i) => day(0).addDays(i));

  /// Return an ISO formatted string like "2020W01".
  @override
  String toString() => '${year}W${weekNumber.toString().padLeft(2, '0')}';
}

extension _DateTimeUtils on DateTime {
  /// Alternative to add(days: x) because of daylight-saving issues.
  DateTime addDays(int days) => copyWith(day: day + days);

  /// Alternative to add(days: x * 7) because of daylight-saving issues.
  DateTime addWeeks(int weeks) => copyWith(day: day + weeks * 7);

  /// Alternative to subtract(days: 7) because of daylight-saving issues.
  DateTime subtractDays(int days) => copyWith(day: day - days);

  /// Alternative to subtract(days: x * 7) because of daylight-saving issues.
  DateTime subtractWeeks(int weeks) => copyWith(day: day - weeks * 7);

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
