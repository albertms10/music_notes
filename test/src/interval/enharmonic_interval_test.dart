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
        },
      );
    });

    group('.intervalFromSemitones()', () {
      test('should return the correct Interval from semitones', () {
        expect(
          EnharmonicInterval.intervalFromSemitones(4),
          equals(const Interval.imperfect(3, ImperfectQuality.minor)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7),
          equals(const Interval.perfect(4, PerfectQuality.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(
            7,
            PerfectQuality.augmented,
          ),
          equals(const Interval.perfect(4, PerfectQuality.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(
            7,
            PerfectQuality.diminished,
          ),
          equals(const Interval.perfect(5, PerfectQuality.diminished)),
        );
      });
    });

    group('.transposeBy()', () {
      test(
        'should return the transposed EnharmonicInterval by semitones',
        () {
          expect(
            EnharmonicInterval.perfectUnison.transposeBy(2),
            EnharmonicInterval.majorSecond,
          );
          expect(
            EnharmonicInterval.perfectFourth.transposeBy(-3),
            EnharmonicInterval.majorSecond,
          );
          expect(
            EnharmonicInterval.perfectFifth.transposeBy(6),
            EnharmonicInterval.minorSecond,
          );
          expect(
            EnharmonicInterval.minorThird.transposeBy(-6),
            EnharmonicInterval.majorSixth,
          );
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicInterval instances in a Set', () {
        final collection = {
          EnharmonicInterval.perfectUnison,
          EnharmonicInterval.majorThird,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          EnharmonicInterval.perfectUnison,
          EnharmonicInterval.majorThird,
        ]);
      });
    });

    group('.compareTo()', () {
      test(
        'should correctly sort EnharmonicInterval items in a collection',
        () {
          final orderedSet = SplayTreeSet<EnharmonicInterval>.of([
            EnharmonicInterval.minorSecond,
            EnharmonicInterval.majorThird,
            EnharmonicInterval.perfectUnison,
          ]);
          expect(orderedSet.toList(), [
            EnharmonicInterval.perfectUnison,
            EnharmonicInterval.minorSecond,
            EnharmonicInterval.majorThird,
          ]);
        },
      );
    });
  });
}
