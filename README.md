# isoweek

A lightweight Dart package which provides the class Week (based on the ISO 8601 format). Instances represent specific weeks spanning Monday to Sunday. 
An ISO week-numbering year has 52 or 53 full weeks. Week 1 is defined to be the first week with 4 or more days in January.

See also: https://en.wikipedia.org/wiki/ISO_week_date

(This package is inspired by the isoweek Python package: https://pypi.org/project/isoweek/)

### Example

```dart
import 'package:isoweek/isoweek.dart';

void main() {
  Week currentWeek = Week.current();

  Week nextWeek = currentWeek.next;
  print("Days of next week: ${nextWeek.days}");
  //OUTPUT: Days of next week: [2020-09-21 01:00:00.000, 2020-09-22 01:00:00.000 ...]

  Week previousWeek = currentWeek.previous;
  print("Days of previous week: ${previousWeek.days}");
  //OUTPUT: Days of previous week: [2020-09-07 01:00:00.000, 2020-09-08 01:00:00.000 ...]

  Week futureWeek = currentWeek.addWeeks(5);
  print("5 weeks ahead: $futureWeek");
  //OUTPUT: 5 weeks ahead: 2020W43

  DateTime myBirthday = DateTime.utc(2020, 11, 16);
  Week birthdayWeek = Week.fromDate(myBirthday);
  print("My birthday week in 2020:  ${birthdayWeek.weekNumber}");
  //OUTPUT: My birthday week in 2020:  47

  String isoWeek = "2020W38";
  Week weekFromIso = Week.fromIsoString(isoWeek);
  print("Week from Iso: $weekFromIso");
  //OUTPUT: "Week from Iso: 2020W38

  Week w = Week(year: 2020, weekNumber: 38);
  DateTime monday = w.day(0);
  print("The Week $w starts with $monday");
  //OUTPUT: The Week 2020W38 starts with 2020-09-14 01:00:00.000
}
```
