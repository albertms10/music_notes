import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicInterval', () {
    group('.spellings', () {
      test(
        'should return the correct Interval spellings for this '
        'EnharmonicInterval',
        () {
          expect(EnharmonicInterval.perfectUnison.spellings, {
            Interval.perfectUnison,
            Interval.diminishedSecond,
          });
          // TODO(albertms10): descending P1 interval.
          expect((-EnharmonicInterval.perfectUnison).spellings, {
            Interval.perfectUnison,
            Interval.diminishedSecond,
          });
          expect(EnharmonicInterval.minorSecond.spellings, {
            Interval.augmentedUnison,
            Interval.minorSecond,
            const Interval.imperfect(3, ImperfectQuality.doublyDiminished),
          });
          expect((-EnharmonicInterval.minorSecond).spellings, {
            -Interval.augmentedUnison,
            -Interval.minorSecond,
            -const Interval.imperfect(3, ImperfectQuality.doublyDiminished),
          });
          expect(EnharmonicInterval.majorSecond.spellings, {
            Interval.majorSecond,
            Interval.diminishedThird,
          });
          expect((-EnharmonicInterval.majorSecond).spellings, {
            -Interval.majorSecond,
            -Interval.diminishedThird,
          });
          expect(EnharmonicInterval.minorThird.spellings, {
            Interval.augmentedSecond,
            Interval.minorThird,
            const Interval.perfect(4, PerfectQuality.doublyDiminished),
          });
          expect((-EnharmonicInterval.minorThird).spellings, {
            -Interval.augmentedSecond,
            -Interval.minorThird,
            -const Interval.perfect(4, PerfectQuality.doublyDiminished),
          });
          expect(EnharmonicInterval.majorThird.spellings, {
            Interval.majorThird,
            Interval.diminishedFourth,
          });
          expect((-EnharmonicInterval.majorThird).spellings, {
            -Interval.majorThird,
            -Interval.diminishedFourth,
          });
          expect(EnharmonicInterval.perfectFourth.spellings, {
            Interval.augmentedThird,
            Interval.perfectFourth,
            const Interval.perfect(5, PerfectQuality.doublyDiminished),
          });
          expect((-EnharmonicInterval.perfectFourth).spellings, {
            -Interval.augmentedThird,
            -Interval.perfectFourth,
            -const Interval.perfect(5, PerfectQuality.doublyDiminished),
          });
          expect(EnharmonicInterval.tritone.spellings, {
            Interval.augmentedFourth,
            Interval.diminishedFifth,
          });
          expect((-EnharmonicInterval.tritone).spellings, {
            -Interval.augmentedFourth,
            -Interval.diminishedFifth,
          });
          expect(EnharmonicInterval.perfectFifth.spellings, {
            const Interval.perfect(4, PerfectQuality.doublyAugmented),
            Interval.perfectFifth,
            Interval.diminishedSixth,
          });
          expect((-EnharmonicInterval.perfectFifth).spellings, {
            -const Interval.perfect(4, PerfectQuality.doublyAugmented),
            -Interval.perfectFifth,
            -Interval.diminishedSixth,
          });
          expect(EnharmonicInterval.minorSixth.spellings, {
            Interval.augmentedFifth,
            Interval.minorSixth,
            const Interval.imperfect(7, ImperfectQuality.doublyDiminished),
          });
          expect((-EnharmonicInterval.minorSixth).spellings, {
            -Interval.augmentedFifth,
            -Interval.minorSixth,
            -const Interval.imperfect(7, ImperfectQuality.doublyDiminished),
          });
          expect(EnharmonicInterval.majorSixth.spellings, {
            Interval.majorSixth,
            Interval.diminishedSeventh,
          });
          expect((-EnharmonicInterval.majorSixth).spellings, {
            -Interval.majorSixth,
            -Interval.diminishedSeventh,
          });
          expect(EnharmonicInterval.minorSeventh.spellings, {
            Interval.augmentedSixth,
            Interval.minorSeventh,
            const Interval.perfect(8, PerfectQuality.doublyDiminished),
          });
          expect((-EnharmonicInterval.minorSeventh).spellings, {
            -Interval.augmentedSixth,
            -Interval.minorSeventh,
            -const Interval.perfect(8, PerfectQuality.doublyDiminished),
          });
          expect(EnharmonicInterval.majorSeventh.spellings, {
            Interval.majorSeventh,
            Interval.diminishedOctave,
          });
          expect((-EnharmonicInterval.majorSeventh).spellings, {
            -Interval.majorSeventh,
            -Interval.diminishedOctave,
          });
          expect(EnharmonicInterval.perfectOctave.spellings, {
            Interval.augmentedSeventh,
            Interval.perfectOctave,
            const Interval.imperfect(9, ImperfectQuality.diminished),
          });
          expect((-EnharmonicInterval.perfectOctave).spellings, {
            -Interval.augmentedSeventh,
            -Interval.perfectOctave,
            -const Interval.imperfect(9, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(13).spellings, {
            Interval.augmentedOctave,
            const Interval.imperfect(9, ImperfectQuality.minor),
            const Interval.imperfect(10, ImperfectQuality.doublyDiminished),
          });
          expect(const EnharmonicInterval(-13).spellings, {
            -Interval.augmentedOctave,
            -const Interval.imperfect(9, ImperfectQuality.minor),
            -const Interval.imperfect(10, ImperfectQuality.doublyDiminished),
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
          EnharmonicInterval.minorSecond + -EnharmonicInterval.minorSecond,
          EnharmonicInterval.perfectUnison,
        );
        expect(
          -EnharmonicInterval.majorThird + -EnharmonicInterval.minorThird,
          -EnharmonicInterval.perfectFifth,
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
          -EnharmonicInterval.minorThird - EnharmonicInterval.majorSecond,
          -EnharmonicInterval.perfectFourth,
        );
        expect(
          -EnharmonicInterval.minorThird - -EnharmonicInterval.perfectFourth,
          EnharmonicInterval.majorSecond,
        );
        expect(
          EnharmonicInterval.minorThird - EnharmonicInterval.tritone,
          const EnharmonicInterval(-3),
        );
      });

      test('should return the negation of this EnharmonicInterval', () {
        expect(-EnharmonicInterval.minorThird, const EnharmonicInterval(-3));
        expect(-const EnharmonicInterval(-6), EnharmonicInterval.tritone);
        expect(
          -EnharmonicInterval.perfectUnison,
          EnharmonicInterval.perfectUnison,
        );
      });
    });

    group('operator *()', () {
      test('should multiply this EnharmonicInterval with factor', () {
        expect(
          EnharmonicInterval.perfectFourth * -1,
          -EnharmonicInterval.perfectFourth,
        );
        expect(
          -EnharmonicInterval.perfectFifth * -1,
          EnharmonicInterval.perfectFifth,
        );
        expect(
          EnharmonicInterval.majorThird * 0,
          EnharmonicInterval.perfectUnison,
        );
        expect(EnharmonicInterval.minorThird * 2, EnharmonicInterval.tritone);
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
