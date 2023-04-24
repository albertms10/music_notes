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
            Interval.perfectUnison,
            Interval.diminishedSecond,
          });
          expect(EnharmonicInterval.minorSecond.items, {
            Interval.augmentedUnison,
            Interval.minorSecond,
            const Interval.imperfect(3, ImperfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSecond.items, {
            Interval.majorSecond,
            Interval.diminishedThird,
          });
          expect(EnharmonicInterval.minorThird.items, {
            Interval.augmentedSecond,
            Interval.minorThird,
            const Interval.perfect(4, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorThird.items, {
            Interval.majorThird,
            Interval.diminishedFourth,
          });
          expect(EnharmonicInterval.perfectFourth.items, {
            Interval.augmentedThird,
            Interval.perfectFourth,
            const Interval.perfect(5, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.tritone.items, {
            Interval.augmentedFourth,
            Interval.diminishedFifth,
          });
          expect(EnharmonicInterval.perfectFifth.items, {
            const Interval.perfect(4, PerfectQuality.doubleAugmented),
            Interval.perfectFifth,
            Interval.diminishedSixth,
          });
          expect(EnharmonicInterval.minorSixth.items, {
            Interval.augmentedFifth,
            Interval.minorSixth,
            const Interval.imperfect(7, ImperfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSixth.items, {
            Interval.majorSixth,
            Interval.diminishedSeventh,
          });
          expect(EnharmonicInterval.minorSeventh.items, {
            Interval.augmentedSixth,
            Interval.minorSeventh,
            const Interval.perfect(8, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSeventh.items, {
            Interval.majorSeventh,
            Interval.diminishedOctave,
          });
          expect(EnharmonicInterval.perfectOctave.items, {
            Interval.augmentedSeventh,
            Interval.perfectOctave,
            const Interval.imperfect(9, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(13).items, {
            Interval.augmentedOctave,
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
          EnharmonicInterval.tritone + EnharmonicInterval.tritone,
          EnharmonicInterval.perfectOctave,
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
          EnharmonicInterval.perfectOctave - EnharmonicInterval.tritone,
          EnharmonicInterval.tritone,
        );
        expect(
          EnharmonicInterval.majorSixth - EnharmonicInterval.majorSixth,
          EnharmonicInterval.perfectUnison,
        );
        expect(
          EnharmonicInterval.minorThird - EnharmonicInterval.tritone,
          const EnharmonicInterval(-3),
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
