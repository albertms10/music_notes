import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicInterval', () {
    group('.items', () {
      test(
        'should return the correct Intervals for this EnharmonicInterval',
        () {
          expect(const EnharmonicInterval(1).items, {
            const Interval(Intervals.unison, PerfectQuality.perfect),
            const Interval(Intervals.second, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(2).items, {
            const Interval(Intervals.unison, PerfectQuality.augmented),
            const Interval(Intervals.second, ImperfectQuality.minor),
            const Interval(Intervals.third, ImperfectQuality.doubleDiminished),
          });
          expect(const EnharmonicInterval(3).items, {
            const Interval(Intervals.second, ImperfectQuality.major),
            const Interval(Intervals.third, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(4).items, {
            const Interval(Intervals.second, ImperfectQuality.augmented),
            const Interval(Intervals.third, ImperfectQuality.minor),
            const Interval(Intervals.fourth, PerfectQuality.doubleDiminished),
          });
          expect(const EnharmonicInterval(5).items, {
            const Interval(Intervals.third, ImperfectQuality.major),
            const Interval(Intervals.fourth, PerfectQuality.diminished),
          });
          expect(const EnharmonicInterval(6).items, {
            const Interval(Intervals.third, ImperfectQuality.augmented),
            const Interval(Intervals.fourth, PerfectQuality.perfect),
            const Interval(Intervals.fifth, PerfectQuality.doubleDiminished),
          });
          expect(const EnharmonicInterval(7).items, {
            const Interval(Intervals.fourth, PerfectQuality.augmented),
            const Interval(Intervals.fifth, PerfectQuality.diminished),
          });
          expect(const EnharmonicInterval(8).items, {
            const Interval(Intervals.fourth, PerfectQuality.doubleAugmented),
            const Interval(Intervals.fifth, PerfectQuality.perfect),
            const Interval(Intervals.sixth, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(9).items, {
            const Interval(Intervals.fifth, PerfectQuality.augmented),
            const Interval(Intervals.sixth, ImperfectQuality.minor),
            const Interval(
              Intervals.seventh,
              ImperfectQuality.doubleDiminished,
            ),
          });
          expect(const EnharmonicInterval(10).items, {
            const Interval(Intervals.sixth, ImperfectQuality.major),
            const Interval(Intervals.seventh, ImperfectQuality.diminished),
          });
          expect(const EnharmonicInterval(11).items, {
            const Interval(Intervals.sixth, ImperfectQuality.augmented),
            const Interval(Intervals.seventh, ImperfectQuality.minor),
            const Interval(Intervals.octave, PerfectQuality.doubleDiminished),
          });
          expect(const EnharmonicInterval(12).items, {
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
            const EnharmonicInterval(1).transposeBy(2),
            const EnharmonicInterval(3),
          );
          expect(
            const EnharmonicInterval(6).transposeBy(-3),
            const EnharmonicInterval(3),
          );
          expect(
            const EnharmonicInterval(8).transposeBy(6),
            const EnharmonicInterval(2),
          );
          expect(
            const EnharmonicInterval(4).transposeBy(-6),
            const EnharmonicInterval(10),
          );
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicInterval instances in a Set', () {
        final collection = {
          const EnharmonicInterval(1),
          const EnharmonicInterval(5),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const EnharmonicInterval(1),
          const EnharmonicInterval(5),
        ]);
      });
    });

    group('.compareTo()', () {
      test(
        'should correctly sort EnharmonicInterval items in a collection',
        () {
          final orderedSet = SplayTreeSet<EnharmonicInterval>.of([
            const EnharmonicInterval(2),
            const EnharmonicInterval(5),
            const EnharmonicInterval(1),
          ]);
          expect(orderedSet.toList(), [
            const EnharmonicInterval(1),
            const EnharmonicInterval(2),
            const EnharmonicInterval(5),
          ]);
        },
      );
    });
  });
}
