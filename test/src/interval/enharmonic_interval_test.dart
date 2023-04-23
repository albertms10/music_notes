import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicInterval', () {
    group('.items', () {
      test(
        'should return the correct Interval items for this EnharmonicInterval',
        () {
          expect(EnharmonicInterval.perfectUnison.items, {
            const Interval.perfect(1, PerfectQuality.perfect),
            const Interval.imperfect(2, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSecond.items, {
            const Interval.perfect(1, PerfectQuality.augmented),
            const Interval.imperfect(2, ImperfectQuality.minor),
            const Interval.imperfect(3, ImperfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSecond.items, {
            const Interval.imperfect(2, ImperfectQuality.major),
            const Interval.imperfect(3, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorThird.items, {
            const Interval.imperfect(2, ImperfectQuality.augmented),
            const Interval.imperfect(3, ImperfectQuality.minor),
            const Interval.perfect(4, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorThird.items, {
            const Interval.imperfect(3, ImperfectQuality.major),
            const Interval.perfect(4, PerfectQuality.diminished),
          });
          expect(EnharmonicInterval.perfectFourth.items, {
            const Interval.imperfect(3, ImperfectQuality.augmented),
            const Interval.perfect(4, PerfectQuality.perfect),
            const Interval.perfect(5, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.tritone.items, {
            const Interval.perfect(4, PerfectQuality.augmented),
            const Interval.perfect(5, PerfectQuality.diminished),
          });
          expect(EnharmonicInterval.perfectFifth.items, {
            const Interval.perfect(4, PerfectQuality.doubleAugmented),
            const Interval.perfect(5, PerfectQuality.perfect),
            const Interval.imperfect(6, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSixth.items, {
            const Interval.perfect(5, PerfectQuality.augmented),
            const Interval.imperfect(6, ImperfectQuality.minor),
            const Interval.imperfect(
              7,
              ImperfectQuality.doubleDiminished,
            ),
          });
          expect(EnharmonicInterval.majorSixth.items, {
            const Interval.imperfect(6, ImperfectQuality.major),
            const Interval.imperfect(7, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSeventh.items, {
            const Interval.imperfect(6, ImperfectQuality.augmented),
            const Interval.imperfect(7, ImperfectQuality.minor),
            const Interval.perfect(8, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSeventh.items, {
            const Interval.imperfect(7, ImperfectQuality.major),
            const Interval.perfect(8, PerfectQuality.diminished),
          });
          expect(EnharmonicInterval.perfectOctave.items, {
            const Interval.imperfect(7, ImperfectQuality.augmented),
            const Interval.perfect(8, PerfectQuality.perfect),
            const Interval.imperfect(9, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(13).items, {
            const Interval.perfect(8, PerfectQuality.augmented),
            const Interval.imperfect(9, ImperfectQuality.minor),
            const Interval.imperfect(10, ImperfectQuality.doubleDiminished),
          });
        },
      );
    });

    group('operator +()', () {
      test('should add other to this EnharmonicInterval', () {
        expect(
          EnharmonicInterval.perfectUnison + EnharmonicInterval.majorSecond,
          EnharmonicInterval.majorSecond,
        );
        expect(
          EnharmonicInterval.tritone + EnharmonicInterval.minorSecond,
          EnharmonicInterval.perfectFifth,
        );
        expect(
          EnharmonicInterval.majorThird + EnharmonicInterval.minorSixth,
          EnharmonicInterval.perfectOctave,
        );
        expect(
          EnharmonicInterval.perfectFifth + EnharmonicInterval.tritone,
          const EnharmonicInterval(13),
        );
      });
    });

    group('operator -()', () {
      test('should subtract other from this EnharmonicInterval', () {
        expect(
          EnharmonicInterval.perfectFourth - EnharmonicInterval.minorThird,
          EnharmonicInterval.majorSecond,
        );
        expect(
          EnharmonicInterval.minorThird - EnharmonicInterval.tritone,
          EnharmonicInterval.majorSixth,
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicInterval instances in a Set', () {
        final collection = {
          EnharmonicInterval.perfectUnison,
          EnharmonicInterval.majorThird,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          EnharmonicInterval.perfectUnison,
          EnharmonicInterval.majorThird,
        ]);
      });
    });

    group('.compareTo()', () {
      test(
        'should correctly sort EnharmonicInterval items in a collection',
        () {
          final orderedSet = SplayTreeSet<EnharmonicInterval>.of(const [
            EnharmonicInterval.minorSecond,
            EnharmonicInterval.majorThird,
            EnharmonicInterval.perfectUnison,
          ]);
          expect(orderedSet.toList(), const [
            EnharmonicInterval.perfectUnison,
            EnharmonicInterval.minorSecond,
            EnharmonicInterval.majorThird,
          ]);
        },
      );
    });
  });
}
