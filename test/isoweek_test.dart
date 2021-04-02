import 'package:isoweek/isoweek.dart';
import 'package:test/test.dart';

void main() {
  group('Test conversion from ISO String to week.', () {
    test(
      '2021W07',
      () {
        final weekFromIso = Week.fromISOString('2021W07');

        expect(weekFromIso, equals(const Week(year: 2021, weekNumber: 7)));
      },
    );
    test(
      '2021W7',
      () {
        final weekFromIso = Week.fromISOString('2021W7');

        expect(weekFromIso, equals(const Week(year: 2021, weekNumber: 7)));
      },
    );
    test(
      '2021-W01',
      () {
        final weekFromIso = Week.fromISOString('2021-W01');

        expect(weekFromIso, equals(const Week(year: 2021, weekNumber: 1)));
      },
    );
    test(
      '2021-W1',
      () {
        final weekFromIso = Week.fromISOString('2021-W1');

        expect(weekFromIso, equals(const Week(year: 2021, weekNumber: 1)));
      },
    );
  });

  test(
    'Test getting week from DateTime.',
    () {
      final week = Week.fromDate(DateTime.utc(2020, 11, 16));

      expect(week, equals(const Week(year: 2020, weekNumber: 47)));
    },
  );

  test(
    'Test getting DateTime from week and then getting the DateTime again from the week.',
    () {
      final monday = Week.current().day(0);
      final monday2 = Week.fromDate(monday).day(0);

      expect(monday, equals(monday2));
    },
  );

  test(
    'Test if all DateTimes in the days getter have a time of 00:00:00.',
    () {
      final daysWithTimeEqualToZero = Week.current().days.where(
          (date) => date.hour == 0 && date.minute == 0 && date.second == 0);

      expect(daysWithTimeEqualToZero.length, equals(7));
    },
  );
}
