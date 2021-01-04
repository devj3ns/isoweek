library isoweek;

class Week {
  final int year;
  final int weekNumber;

  Week({
    required this.year,
    required this.weekNumber,
  });

  /// return the ordinal date, the number of days since December 31st the previous year.
  static int _ordinalDate(DateTime date) {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[date.month - 1] +
        date.day +
        (_isLeapYear(date.year) && date.month > 2 ? 1 : 0);
  }

  /// return true if the given year is a leap year
  static bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// return the week that contains the given date
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

  /// return the current week
  factory Week.current() {
    return Week.fromDate(DateTime.now());
  }

  /// return a week initialized from an ISO formatted string like "2020W01" or "2020-W01" (or even "2020-W1" or "2020W1")
  factory Week.fromIsoString(String isoString) {
    final List<String> parts = isoString.split("W");

    String yearStr = parts[0];
    if (yearStr.length > 4) {
      //if W separated with - (e.g. "2020-W01")
      yearStr = yearStr.substring(0, 4);
    }
    final String weekNumberStr = parts[1];

    final int year = int.parse(yearStr);
    final int weekNumber = int.parse(weekNumberStr);

    return Week(year: year, weekNumber: weekNumber);
  }

  /// return the week that many number of weeks into the future
  Week addWeeks(int weeks) {
    return Week.fromDate(this.day(0).add(Duration(days: 7 * weeks)));
  }

  /// return the week that many number of weeks in the past
  Week subtractWeeks(int weeks) {
    return Week.fromDate(this.day(0).subtract(Duration(days: 7 * weeks)));
  }

  /// return the given day of week as a DateTime object. Day 0 is Monday.
  DateTime day(int day) {
    final d = DateTime(
        this.year, 1, 4); // The Jan 4th must be in week 1 according to ISO
    return d.add(
        Duration(days: (this.weekNumber - 1) * 7 + (-d.weekday + day) + 1));
  }

  /// return the week after the given week
  Week get next {
    return this.addWeeks(1);
  }

  /// return the week before the given week
  Week get previous {
    return this.subtractWeeks(1);
  }

  /// return a list of all days in the given week
  List<DateTime> get days {
    final DateTime monday = this.day(0);
    final List<DateTime> days = [];
    for (var i in [0, 1, 2, 3, 4, 5, 6]) {
      days.add(monday.add(Duration(days: i)));
    }
    return days;
  }

  /// return an ISO formatted string like "2020W01"
  String get isoFormat {
    return year.toString() + "W" + weekNumber.toString().padLeft(2, '0');
  }

  /// return an ISO formatted string like "2020W01"
  @override
  String toString() {
    return isoFormat;
  }
}
