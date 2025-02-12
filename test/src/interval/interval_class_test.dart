import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('IntervalClass', () {
    group('constructor', () {
      test('creates a new IntervalClass from semitones', () {
        // ignore: use_named_constants test
        expect(const IntervalClass(8), IntervalClass.M3);
        // ignore: use_named_constants test
        expect(const IntervalClass(-2), IntervalClass.M2);
      });
    });

    group('.spellings()', () {
      test('returns the correct Interval spellings for this IntervalClass', () {
        expect(IntervalClass.P1.spellings(), {Interval.P1});
        expect(IntervalClass.P1.spellings(distance: 1), {
          Interval.P1,
          Interval.d2,
        });

        expect(IntervalClass.m2.spellings(), {Interval.m2});
        expect(IntervalClass.m2.spellings(distance: 1), {
          Interval.A1,
          Interval.m2,
          const Interval.imperfect(
            Size.third,
            ImperfectQuality.doublyDiminished,
          ),
        });

        expect(IntervalClass.M2.spellings(), {Interval.M2, Interval.d3});
        expect(IntervalClass.M2.spellings(distance: 1), {
          Interval.M2,
          Interval.d3,
        });

        expect(IntervalClass.m3.spellings(), {Interval.m3});
        expect(IntervalClass.m3.spellings(distance: 1), {
          Interval.A2,
          Interval.m3,
          const Interval.perfect(Size.fourth, PerfectQuality.doublyDiminished),
        });

        expect(IntervalClass.M3.spellings(), {Interval.M3, Interval.d4});
        expect(IntervalClass.M3.spellings(distance: 1), {
          Interval.M3,
          Interval.d4,
        });

        expect(IntervalClass.P4.spellings(), {Interval.P4});
        expect(IntervalClass.P4.spellings(distance: 1), {
          Interval.A3,
          Interval.P4,
          const Interval.perfect(Size.fifth, PerfectQuality.doublyDiminished),
        });

        expect(IntervalClass.tritone.spellings(), {Interval.A4, Interval.d5});
        expect(IntervalClass.tritone.spellings(distance: 1), {
          Interval.A4,
          Interval.d5,
        });
      });
    });

    group('.resolveClosestSpelling()', () {
      test('returns the Note that matches with the preferred Quality', () {
        expect(IntervalClass.P1.resolveClosestSpelling(), Interval.P1);
        expect(
          IntervalClass.P1.resolveClosestSpelling(ImperfectQuality.diminished),
          Interval.d2,
        );
        expect(IntervalClass.m3.resolveClosestSpelling(), Interval.m3);
        expect(IntervalClass.tritone.resolveClosestSpelling(), Interval.A4);
        expect(
          IntervalClass.tritone.resolveClosestSpelling(
            PerfectQuality.augmented,
          ),
          Interval.A4,
        );
        expect(
          IntervalClass.tritone.resolveClosestSpelling(
            PerfectQuality.diminished,
          ),
          Interval.d5,
        );
      });
    });

    group('operator +()', () {
      test('adds other to this IntervalClass', () {
        expect(IntervalClass.P1 + IntervalClass.M2, IntervalClass.M2);
        expect(IntervalClass.tritone + IntervalClass.m2, IntervalClass.P4);
        expect(IntervalClass.tritone + IntervalClass.tritone, IntervalClass.P1);
        expect(IntervalClass.M3 + IntervalClass.P4, IntervalClass.m3);
      });
    });

    group('operator -()', () {
      test('subtracts other from this IntervalClass', () {
        expect(IntervalClass.P4 - IntervalClass.m3, IntervalClass.M2);
        expect(IntervalClass.tritone - IntervalClass.M2, IntervalClass.M3);
        expect(IntervalClass.M3 - IntervalClass.M3, IntervalClass.P1);
        expect(IntervalClass.m3 - IntervalClass.tritone, IntervalClass.m3);
      });
    });

    group('operator *()', () {
      test('multiplies this IntervalClass with factor', () {
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
      test('returns a string representation of this IntervalClass', () {
        expect(IntervalClass.P1.toString(), '{P1}');
        expect(IntervalClass.m2.toString(), '{m2}');
        expect(IntervalClass.M3.toString(), '{M3|d4}');
        expect(IntervalClass.tritone.toString(), '{A4|d5}');
      });
    });

    group('.hashCode', () {
      test('ignores equal IntervalClass instances in a Set', () {
        final collection = {IntervalClass.P1, IntervalClass.M3};
        collection.addAll(collection);
        expect(collection.toList(), const [IntervalClass.P1, IntervalClass.M3]);
      });
    });

    group('.compareTo()', () {
      test('sorts IntervalClasses in a collection', () {
        final orderedSet = SplayTreeSet<IntervalClass>.of({
          IntervalClass.m2,
          IntervalClass.M3,
          IntervalClass.P1,
        });
        expect(orderedSet.toList(), const [
          IntervalClass.P1,
          IntervalClass.m2,
          IntervalClass.M3,
        ]);
      });
    });
  });
}
