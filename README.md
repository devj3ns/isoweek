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
  print(currentWeek);
  //OUTPUT: 2021W13

  Week nextWeek = currentWeek.next;
  print('Days of next week: ${nextWeek.days}');
  //OUTPUT: Days of next week: [2021-04-05 01:00:00.000, 2021-04-06 01:00:00.000, ...]

  Week previousWeek = currentWeek.previous;
  print('Days of previous week: ${previousWeek.days}');
  //OUTPUT: Days of previous week: [2021-03-22 00:00:00.000, 2021-03-23 00:00:00.000, ...]

  Week futureWeek = currentWeek.addWeeks(5);
  print('5 weeks ahead: $futureWeek');
  //OUTPUT: 5 weeks ahead: 2021W18

  DateTime myBirthday = DateTime.utc(2020, 11, 16);
  Week birthdayWeek = Week.fromDate(myBirthday);
  print(
      'The week number of my birthday in 2020 was ${birthdayWeek.weekNumber}');
  //OUTPUT: The week number of my birthday in 2020 was 47

  String isoWeek = '2021W25';
  Week weekFromIso = Week.fromIsoString(isoWeek);
  print('Week from ISO: $weekFromIso');
  //OUTPUT: Week from ISO: 2021W25

  DateTime firstDay = weekFromIso.day(0);
  print('The Week $weekFromIso starts with $firstDay');
  //OUTPUT: The Week 2021W25 starts with 2021-06-21 01:00:00.000
}
```
