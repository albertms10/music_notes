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
            const Interval(Intervals.unison, PerfectQuality.perfect),
            const Interval(Intervals.second, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSecond.items, {
            const Interval(Intervals.unison, PerfectQuality.augmented),
            const Interval(Intervals.second, ImperfectQuality.minor),
            const Interval(Intervals.third, ImperfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSecond.items, {
            const Interval(Intervals.second, ImperfectQuality.major),
            const Interval(Intervals.third, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorThird.items, {
            const Interval(Intervals.second, ImperfectQuality.augmented),
            const Interval(Intervals.third, ImperfectQuality.minor),
            const Interval(Intervals.fourth, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorThird.items, {
            const Interval(Intervals.third, ImperfectQuality.major),
            const Interval(Intervals.fourth, PerfectQuality.diminished),
          });
          expect(EnharmonicInterval.perfectFourth.items, {
            const Interval(Intervals.third, ImperfectQuality.augmented),
            const Interval(Intervals.fourth, PerfectQuality.perfect),
            const Interval(Intervals.fifth, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.tritone.items, {
            const Interval(Intervals.fourth, PerfectQuality.augmented),
            const Interval(Intervals.fifth, PerfectQuality.diminished),
          });
          expect(EnharmonicInterval.perfectFifth.items, {
            const Interval(Intervals.fourth, PerfectQuality.doubleAugmented),
            const Interval(Intervals.fifth, PerfectQuality.perfect),
            const Interval(Intervals.sixth, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSixth.items, {
            const Interval(Intervals.fifth, PerfectQuality.augmented),
            const Interval(Intervals.sixth, ImperfectQuality.minor),
            const Interval(
              Intervals.seventh,
              ImperfectQuality.doubleDiminished,
            ),
          });
          expect(EnharmonicInterval.majorSixth.items, {
            const Interval(Intervals.sixth, ImperfectQuality.major),
            const Interval(Intervals.seventh, ImperfectQuality.diminished),
          });
          expect(EnharmonicInterval.minorSeventh.items, {
            const Interval(Intervals.sixth, ImperfectQuality.augmented),
            const Interval(Intervals.seventh, ImperfectQuality.minor),
            const Interval(Intervals.octave, PerfectQuality.doubleDiminished),
          });
          expect(EnharmonicInterval.majorSeventh.items, {
            const Interval(Intervals.seventh, ImperfectQuality.major),
            const Interval(Intervals.octave, PerfectQuality.diminished),
          });
        },
      );
    });

    group('.intervalFromSemitones()', () {
      test('should return the correct Interval from semitones', () {
        expect(
          EnharmonicInterval.intervalFromSemitones(4),
          equals(const Interval(Intervals.third, ImperfectQuality.minor)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7),
          equals(const Interval(Intervals.fourth, PerfectQuality.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(
            7,
            PerfectQuality.augmented,
          ),
          equals(const Interval(Intervals.fourth, PerfectQuality.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(
            7,
            PerfectQuality.diminished,
          ),
          equals(const Interval(Intervals.fifth, PerfectQuality.diminished)),
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
