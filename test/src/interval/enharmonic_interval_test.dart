import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicInterval', () {
    group('.spellings()', () {
      test(
        'should return the correct Interval spellings for this '
        'EnharmonicInterval',
        () {
          expect(EnharmonicInterval.P1.spellings(), {Interval.P1});
          expect(
            EnharmonicInterval.P1.spellings(distance: 1),
            {Interval.P1, Interval.d2},
          );

          // TODO(albertms10): Failing test: descending P1 interval.
          expect((-EnharmonicInterval.P1).spellings(), {Interval.P1});
          expect(
            (-EnharmonicInterval.P1).spellings(distance: 1),
            {Interval.P1, Interval.d2},
          );

          expect(EnharmonicInterval.m2.spellings(), {Interval.m2});
          expect(EnharmonicInterval.m2.spellings(distance: 1), {
            Interval.A1,
            Interval.m2,
            const Interval.imperfect(3, ImperfectQuality.doublyDiminished),
          });

          expect((-EnharmonicInterval.m2).spellings(), {-Interval.m2});
          expect((-EnharmonicInterval.m2).spellings(distance: 1), {
            -Interval.A1,
            -Interval.m2,
            -const Interval.imperfect(3, ImperfectQuality.doublyDiminished),
          });

          expect(EnharmonicInterval.M2.spellings(), {Interval.M2, Interval.d3});
          expect(
            EnharmonicInterval.M2.spellings(distance: 1),
            {Interval.M2, Interval.d3},
          );

          expect(
            (-EnharmonicInterval.M2).spellings(),
            {-Interval.M2, -Interval.d3},
          );
          expect(
            (-EnharmonicInterval.M2).spellings(distance: 1),
            {-Interval.M2, -Interval.d3},
          );

          expect(EnharmonicInterval.m3.spellings(), {Interval.m3});
          expect(EnharmonicInterval.m3.spellings(distance: 1), {
            Interval.A2,
            Interval.m3,
            const Interval.perfect(4, PerfectQuality.doublyDiminished),
          });

          expect((-EnharmonicInterval.m3).spellings(), {-Interval.m3});
          expect((-EnharmonicInterval.m3).spellings(distance: 1), {
            -Interval.A2,
            -Interval.m3,
            -const Interval.perfect(4, PerfectQuality.doublyDiminished),
          });

          expect(EnharmonicInterval.M3.spellings(), {Interval.M3, Interval.d4});
          expect(
            EnharmonicInterval.M3.spellings(distance: 1),
            {Interval.M3, Interval.d4},
          );

          expect(
            (-EnharmonicInterval.M3).spellings(),
            {-Interval.M3, -Interval.d4},
          );
          expect(
            (-EnharmonicInterval.M3).spellings(distance: 1),
            {-Interval.M3, -Interval.d4},
          );

          expect(EnharmonicInterval.P4.spellings(), {Interval.P4});
          expect(EnharmonicInterval.P4.spellings(distance: 1), {
            Interval.A3,
            Interval.P4,
            const Interval.perfect(5, PerfectQuality.doublyDiminished),
          });

          expect((-EnharmonicInterval.P4).spellings(), {-Interval.P4});
          expect((-EnharmonicInterval.P4).spellings(distance: 1), {
            -Interval.A3,
            -Interval.P4,
            -const Interval.perfect(5, PerfectQuality.doublyDiminished),
          });

          expect(
            EnharmonicInterval.tritone.spellings(),
            {Interval.A4, Interval.d5},
          );
          expect(
            EnharmonicInterval.tritone.spellings(distance: 1),
            {Interval.A4, Interval.d5},
          );

          expect(
            (-EnharmonicInterval.tritone).spellings(),
            {-Interval.A4, -Interval.d5},
          );
          expect(
            (-EnharmonicInterval.tritone).spellings(distance: 1),
            {-Interval.A4, -Interval.d5},
          );

          expect(EnharmonicInterval.P5.spellings(), {Interval.P5});
          expect(EnharmonicInterval.P5.spellings(distance: 1), {
            const Interval.perfect(4, PerfectQuality.doublyAugmented),
            Interval.P5,
            Interval.d6,
          });

          expect((-EnharmonicInterval.P5).spellings(), {-Interval.P5});
          expect((-EnharmonicInterval.P5).spellings(distance: 1), {
            -const Interval.perfect(4, PerfectQuality.doublyAugmented),
            -Interval.P5,
            -Interval.d6,
          });

          expect(EnharmonicInterval.m6.spellings(), {Interval.m6});
          expect(EnharmonicInterval.m6.spellings(distance: 1), {
            Interval.A5,
            Interval.m6,
            const Interval.imperfect(7, ImperfectQuality.doublyDiminished),
          });

          expect((-EnharmonicInterval.m6).spellings(), {-Interval.m6});
          expect((-EnharmonicInterval.m6).spellings(distance: 1), {
            -Interval.A5,
            -Interval.m6,
            -const Interval.imperfect(7, ImperfectQuality.doublyDiminished),
          });

          expect(EnharmonicInterval.M6.spellings(), {Interval.M6, Interval.d7});
          expect(
            EnharmonicInterval.M6.spellings(distance: 1),
            {Interval.M6, Interval.d7},
          );

          expect(
            (-EnharmonicInterval.M6).spellings(),
            {-Interval.M6, -Interval.d7},
          );
          expect(
            (-EnharmonicInterval.M6).spellings(distance: 1),
            {-Interval.M6, -Interval.d7},
          );

          expect(EnharmonicInterval.m7.spellings(), {Interval.m7});
          expect(EnharmonicInterval.m7.spellings(distance: 1), {
            Interval.A6,
            Interval.m7,
            const Interval.perfect(8, PerfectQuality.doublyDiminished),
          });

          expect((-EnharmonicInterval.m7).spellings(), {-Interval.m7});
          expect((-EnharmonicInterval.m7).spellings(distance: 1), {
            -Interval.A6,
            -Interval.m7,
            -const Interval.perfect(8, PerfectQuality.doublyDiminished),
          });

          expect(EnharmonicInterval.M7.spellings(), {Interval.M7, Interval.d8});
          expect(
            EnharmonicInterval.M7.spellings(distance: 1),
            {Interval.M7, Interval.d8},
          );

          expect(
            (-EnharmonicInterval.M7).spellings(),
            {-Interval.M7, -Interval.d8},
          );
          expect(
            (-EnharmonicInterval.M7).spellings(distance: 1),
            {-Interval.M7, -Interval.d8},
          );

          expect(EnharmonicInterval.P8.spellings(), {Interval.P8});
          expect(
            EnharmonicInterval.P8.spellings(distance: 1),
            {Interval.A7, Interval.P8, Interval.d9},
          );

          expect((-EnharmonicInterval.P8).spellings(), {-Interval.P8});
          expect(
            (-EnharmonicInterval.P8).spellings(distance: 1),
            {-Interval.A7, -Interval.P8, -Interval.d9},
          );

          expect(const EnharmonicInterval(13).spellings(), {Interval.m9});
          expect(const EnharmonicInterval(13).spellings(distance: 1), {
            Interval.A8,
            Interval.m9,
            const Interval.imperfect(10, ImperfectQuality.doublyDiminished),
          });

          expect(const EnharmonicInterval(-13).spellings(), {-Interval.m9});
          expect(const EnharmonicInterval(-13).spellings(distance: 1), {
            -Interval.A8,
            -Interval.m9,
            -const Interval.imperfect(10, ImperfectQuality.doublyDiminished),
          });
        },
      );
    });

    group('.isDescending', () {
      test('should return whether this EnharmonicInterval is descending', () {
        expect(EnharmonicInterval.m3.isDescending, isFalse);
        expect((-EnharmonicInterval.P5).isDescending, isTrue);
      });
    });

    group('.descending()', () {
      test(
        'should return the descending EnharmonicInterval based on isDescending',
        () {
          expect(EnharmonicInterval.M2.descending(), -EnharmonicInterval.M2);
          expect(
            EnharmonicInterval.m3.descending(isDescending: false),
            EnharmonicInterval.m3,
          );
          expect(
            (-EnharmonicInterval.m6).descending(isDescending: false),
            EnharmonicInterval.m6,
          );
          expect((-EnharmonicInterval.P8).descending(), -EnharmonicInterval.P8);
        },
      );

      test(
        'should return a copy of this EnharmonicInterval based on isDescending',
        () {
          const ascendingInterval = EnharmonicInterval.P4;
          expect(
            identical(ascendingInterval.descending(), ascendingInterval),
            isFalse,
          );

          final descendingInterval = -EnharmonicInterval.m3;
          expect(
            identical(descendingInterval.descending(), descendingInterval),
            isFalse,
          );
        },
      );
    });

    group('operator +()', () {
      test('should add other to this EnharmonicInterval', () {
        expect(
          EnharmonicInterval.P1 + EnharmonicInterval.M2,
          EnharmonicInterval.M2,
        );
        expect(
          EnharmonicInterval.tritone + EnharmonicInterval.m2,
          EnharmonicInterval.P5,
        );
        expect(
          EnharmonicInterval.tritone + EnharmonicInterval.tritone,
          EnharmonicInterval.P8,
        );
        expect(
          EnharmonicInterval.m2 + -EnharmonicInterval.m2,
          EnharmonicInterval.P1,
        );
        expect(
          -EnharmonicInterval.M3 + -EnharmonicInterval.m3,
          -EnharmonicInterval.P5,
        );
        expect(
          EnharmonicInterval.M3 + EnharmonicInterval.m6,
          EnharmonicInterval.P8,
        );
        expect(
          EnharmonicInterval.P5 + EnharmonicInterval.tritone,
          const EnharmonicInterval(13),
        );
      });
    });

    group('operator -()', () {
      test('should subtract other from this EnharmonicInterval', () {
        expect(
          EnharmonicInterval.P4 - EnharmonicInterval.m3,
          EnharmonicInterval.M2,
        );
        expect(
          EnharmonicInterval.P8 - EnharmonicInterval.tritone,
          EnharmonicInterval.tritone,
        );
        expect(
          EnharmonicInterval.M6 - EnharmonicInterval.M6,
          EnharmonicInterval.P1,
        );
        expect(
          -EnharmonicInterval.m3 - EnharmonicInterval.M2,
          -EnharmonicInterval.P4,
        );
        expect(
          -EnharmonicInterval.m3 - -EnharmonicInterval.P4,
          EnharmonicInterval.M2,
        );
        expect(
          EnharmonicInterval.m3 - EnharmonicInterval.tritone,
          const EnharmonicInterval(-3),
        );
      });

      test('should return the negation of this EnharmonicInterval', () {
        expect(-EnharmonicInterval.m3, const EnharmonicInterval(-3));
        expect(-const EnharmonicInterval(-6), EnharmonicInterval.tritone);
        expect(-EnharmonicInterval.P1, EnharmonicInterval.P1);
      });
    });

    group('operator *()', () {
      test('should multiply this EnharmonicInterval with factor', () {
        expect(EnharmonicInterval.P4 * -1, -EnharmonicInterval.P4);
        expect(-EnharmonicInterval.P5 * -1, EnharmonicInterval.P5);
        expect(EnharmonicInterval.M3 * 0, EnharmonicInterval.P1);
        expect(EnharmonicInterval.m3 * 2, EnharmonicInterval.tritone);
      });
    });

    group('.toString()', () {
      test(
        'should return a string representation of this EnharmonicInterval',
        () {
          expect(EnharmonicInterval.P1.toString(), '{P1}');
          expect(EnharmonicInterval.M3.toString(), '{M3, d4}');
          expect(EnharmonicInterval.m6.toString(), '{m6}');
          expect((-EnharmonicInterval.M6).toString(), '{desc d7, desc M6}');
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicInterval instances in a Set', () {
        final collection = {EnharmonicInterval.P1, EnharmonicInterval.M3};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [EnharmonicInterval.P1, EnharmonicInterval.M3],
        );
      });
    });

    group('.compareTo()', () {
      test(
        'should correctly sort EnharmonicInterval items in a collection',
        () {
          final orderedSet = SplayTreeSet<EnharmonicInterval>.of(const [
            EnharmonicInterval.m2,
            EnharmonicInterval.M3,
            EnharmonicInterval.P1,
          ]);
          expect(orderedSet.toList(), const [
            EnharmonicInterval.P1,
            EnharmonicInterval.m2,
            EnharmonicInterval.M3,
          ]);
        },
      );
    });
  });
}
