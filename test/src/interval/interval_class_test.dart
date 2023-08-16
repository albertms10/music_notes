import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('IntervalClass', () {
    group('constructor', () {
      test('should create a new IntervalClass from semitones', () {
        // ignore: use_named_constants
        expect(const IntervalClass(8), IntervalClass.M3);
        // ignore: use_named_constants
        expect(const IntervalClass(-2), IntervalClass.M2);
      });
    });

    group('.spellings()', () {
      test(
        'should return the correct Interval spellings for this IntervalClass',
        () {
          expect(IntervalClass.P1.spellings(), {Interval.P1});
          expect(
            IntervalClass.P1.spellings(distance: 1),
            {Interval.P1, Interval.d2},
          );

          expect(IntervalClass.m2.spellings(), {Interval.m2});
          expect(IntervalClass.m2.spellings(distance: 1), {
            Interval.A1,
            Interval.m2,
            const Interval.imperfect(3, ImperfectQuality.doublyDiminished),
          });

          expect(IntervalClass.M2.spellings(), {Interval.M2, Interval.d3});
          expect(
            IntervalClass.M2.spellings(distance: 1),
            {Interval.M2, Interval.d3},
          );

          expect(IntervalClass.m3.spellings(), {Interval.m3});
          expect(IntervalClass.m3.spellings(distance: 1), {
            Interval.A2,
            Interval.m3,
            const Interval.perfect(4, PerfectQuality.doublyDiminished),
          });

          expect(IntervalClass.M3.spellings(), {Interval.M3, Interval.d4});
          expect(
            IntervalClass.M3.spellings(distance: 1),
            {Interval.M3, Interval.d4},
          );

          expect(IntervalClass.P4.spellings(), {Interval.P4});
          expect(IntervalClass.P4.spellings(distance: 1), {
            Interval.A3,
            Interval.P4,
            const Interval.perfect(5, PerfectQuality.doublyDiminished),
          });

          expect(
            IntervalClass.tritone.spellings(),
            {Interval.A4, Interval.d5},
          );
          expect(
            IntervalClass.tritone.spellings(distance: 1),
            {Interval.A4, Interval.d5},
          );
        },
      );
    });

    group('operator +()', () {
      test('should add other to this IntervalClass', () {
        expect(IntervalClass.P1 + IntervalClass.M2, IntervalClass.M2);
        expect(IntervalClass.tritone + IntervalClass.m2, IntervalClass.P4);
        expect(IntervalClass.tritone + IntervalClass.tritone, IntervalClass.P1);
        expect(IntervalClass.M3 + IntervalClass.P4, IntervalClass.m3);
      });
    });

    group('operator -()', () {
      test('should subtract other from this IntervalClass', () {
        expect(IntervalClass.P4 - IntervalClass.m3, IntervalClass.M2);
        expect(IntervalClass.tritone - IntervalClass.M2, IntervalClass.M3);
        expect(IntervalClass.M3 - IntervalClass.M3, IntervalClass.P1);
        expect(IntervalClass.m3 - IntervalClass.tritone, IntervalClass.m3);
      });
    });

    group('operator *()', () {
      test('should multiply this IntervalClass with factor', () {
        expect(IntervalClass.P4 * -1, IntervalClass.P4);
        expect(IntervalClass.tritone * -1, IntervalClass.tritone);
        expect(IntervalClass.M3 * 0, IntervalClass.P1);
        expect(IntervalClass.m3 * 2, IntervalClass.tritone);
        expect(IntervalClass.m3 * -2, IntervalClass.tritone);
        expect(IntervalClass.m2 * 3, IntervalClass.m3);
        expect(IntervalClass.m2 * -3, IntervalClass.m3);
      });
    });

    group('.toString()', () {
      test('should return a string representation of this IntervalClass', () {
        expect(IntervalClass.P1.toString(), '{P1}');
        expect(IntervalClass.m2.toString(), '{m2}');
        expect(IntervalClass.M3.toString(), '{M3|d4}');
        expect(IntervalClass.tritone.toString(), '{A4|d5}');
      });
    });

    group('.hashCode', () {
      test('should ignore equal IntervalClass instances in a Set', () {
        final collection = {IntervalClass.P1, IntervalClass.M3};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [IntervalClass.P1, IntervalClass.M3],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort IntervalClass items in a collection', () {
        final orderedSet = SplayTreeSet<IntervalClass>.of(const [
          IntervalClass.m2,
          IntervalClass.M3,
          IntervalClass.P1,
        ]);
        expect(orderedSet.toList(), const [
          IntervalClass.P1,
          IntervalClass.m2,
          IntervalClass.M3,
        ]);
      });
    });
  });
}
