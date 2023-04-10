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
            const Interval(Intervals.unison, Qualities.perfect),
            const Interval(Intervals.second, Qualities.diminished),
          });
          expect(const EnharmonicInterval(2).items, {
            const Interval(Intervals.second, Qualities.minor),
          });
          expect(const EnharmonicInterval(3).items, {
            const Interval(Intervals.second, Qualities.major),
            const Interval(Intervals.third, Qualities.diminished),
          });
          expect(const EnharmonicInterval(4).items, {
            const Interval(Intervals.third, Qualities.minor),
          });
          expect(const EnharmonicInterval(5).items, {
            const Interval(Intervals.third, Qualities.major),
            const Interval(Intervals.fourth, Qualities.diminished),
          });
          expect(const EnharmonicInterval(6).items, {
            const Interval(Intervals.fourth, Qualities.perfect),
          });
          expect(const EnharmonicInterval(7).items, {
            const Interval(Intervals.fourth, Qualities.augmented),
            const Interval(Intervals.fifth, Qualities.diminished),
          });
          expect(const EnharmonicInterval(8).items, {
            const Interval(Intervals.fifth, Qualities.perfect),
            const Interval(Intervals.sixth, Qualities.diminished),
          });
          expect(const EnharmonicInterval(9).items, {
            const Interval(Intervals.sixth, Qualities.minor),
          });
          expect(const EnharmonicInterval(10).items, {
            const Interval(Intervals.sixth, Qualities.major),
            const Interval(Intervals.seventh, Qualities.diminished),
          });
          expect(const EnharmonicInterval(11).items, {
            const Interval(Intervals.seventh, Qualities.minor),
          });
          expect(const EnharmonicInterval(12).items, {
            const Interval(Intervals.seventh, Qualities.major),
            const Interval(Intervals.octave, Qualities.diminished),
          });
        },
      );
    });

    group('.intervalFromSemitones()', () {
      test('should return the correct Interval from semitones', () {
        expect(
          EnharmonicInterval.intervalFromSemitones(4),
          equals(const Interval(Intervals.third, Qualities.minor)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7),
          equals(const Interval(Intervals.fourth, Qualities.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7, Qualities.diminished),
          equals(const Interval(Intervals.fifth, Qualities.diminished)),
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
