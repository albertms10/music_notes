import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('.fromDesiredSemitones()', () {
      test('should create a new Interval from desired semitones', () {
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, -1),
          const Interval(Intervals.unison, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, 0),
          const Interval(Intervals.unison, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, 1),
          const Interval(Intervals.unison, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.second, 0),
          const Interval(Intervals.second, ImperfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 1),
          const Interval(Intervals.second, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 2),
          const Interval(Intervals.second, ImperfectQuality.major),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 3),
          const Interval(Intervals.second, ImperfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.third, 2),
          const Interval(Intervals.third, ImperfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 3),
          const Interval(Intervals.third, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 4),
          const Interval(Intervals.third, ImperfectQuality.major),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 5),
          const Interval(Intervals.third, ImperfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 4),
          const Interval(Intervals.fourth, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 5),
          const Interval(Intervals.fourth, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 6),
          const Interval(Intervals.fourth, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 6),
          const Interval(Intervals.fifth, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 7),
          const Interval(Intervals.fifth, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 8),
          const Interval(Intervals.fifth, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.sixth, 8),
          const Interval(Intervals.sixth, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.sixth, 9),
          const Interval(Intervals.sixth, ImperfectQuality.major),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.seventh, 10),
          const Interval(Intervals.seventh, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.seventh, 11),
          const Interval(Intervals.seventh, ImperfectQuality.major),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 11),
          const Interval(Intervals.octave, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 12),
          const Interval(Intervals.octave, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 13),
          const Interval(Intervals.octave, PerfectQuality.augmented),
        );
      });
    });

    group('.qualityFromDelta()', () {
      test('should return the quality from an Interval and delta', () {
        expect(
          Interval.qualityFromDelta(Intervals.unison, -1),
          PerfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.unison, 0),
          PerfectQuality.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.unison, 1),
          PerfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.second, -1),
          ImperfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 0),
          ImperfectQuality.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 1),
          ImperfectQuality.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 2),
          ImperfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.third, -1),
          ImperfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 0),
          ImperfectQuality.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 1),
          ImperfectQuality.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 2),
          ImperfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.fourth, -1),
          PerfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fourth, 0),
          PerfectQuality.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fourth, 1),
          PerfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.fifth, -1),
          PerfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fifth, 0),
          PerfectQuality.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fifth, 1),
          PerfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.sixth, -1),
          ImperfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 0),
          ImperfectQuality.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 1),
          ImperfectQuality.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 2),
          ImperfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.seventh, -1),
          ImperfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 0),
          ImperfectQuality.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 1),
          ImperfectQuality.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 2),
          ImperfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.octave, -1),
          PerfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.octave, 0),
          PerfectQuality.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.octave, 1),
          PerfectQuality.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, -1),
          ImperfectQuality.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 0),
          ImperfectQuality.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 1),
          ImperfectQuality.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 2),
          ImperfectQuality.augmented,
        );
      });
    });

    group('.semitones', () {
      test('should return the number of semitones of this Interval', () {
        expect(
          const Interval(Intervals.unison, PerfectQuality.diminished).semitones,
          -1,
        );
        expect(
          const Interval(Intervals.unison, PerfectQuality.perfect).semitones,
          0,
        );
        expect(
          const Interval(Intervals.unison, PerfectQuality.augmented).semitones,
          1,
        );

        expect(
          const Interval(Intervals.second, ImperfectQuality.diminished)
              .semitones,
          0,
        );
        expect(
          const Interval(Intervals.second, ImperfectQuality.minor).semitones,
          1,
        );
        expect(
          const Interval(Intervals.second, ImperfectQuality.major).semitones,
          2,
        );
        expect(
          const Interval(Intervals.second, ImperfectQuality.augmented)
              .semitones,
          3,
        );

        expect(
          const Interval(Intervals.third, ImperfectQuality.diminished)
              .semitones,
          2,
        );
        expect(
          const Interval(Intervals.third, ImperfectQuality.minor).semitones,
          3,
        );
        expect(
          const Interval(Intervals.third, ImperfectQuality.major).semitones,
          4,
        );
        expect(
          const Interval(Intervals.third, ImperfectQuality.augmented).semitones,
          5,
        );

        expect(
          const Interval(Intervals.fourth, PerfectQuality.diminished).semitones,
          4,
        );
        expect(
          const Interval(Intervals.fourth, PerfectQuality.perfect).semitones,
          5,
        );
        expect(
          const Interval(Intervals.fourth, PerfectQuality.augmented).semitones,
          6,
        );

        expect(
          const Interval(Intervals.fifth, PerfectQuality.diminished).semitones,
          6,
        );
        expect(
          const Interval(Intervals.fifth, PerfectQuality.perfect).semitones,
          7,
        );
        expect(
          const Interval(Intervals.fifth, PerfectQuality.augmented).semitones,
          8,
        );

        expect(
          const Interval(Intervals.sixth, ImperfectQuality.diminished)
              .semitones,
          7,
        );
        expect(
          const Interval(Intervals.sixth, ImperfectQuality.minor).semitones,
          8,
        );
        expect(
          const Interval(Intervals.sixth, ImperfectQuality.major).semitones,
          9,
        );
        expect(
          const Interval(Intervals.sixth, ImperfectQuality.augmented).semitones,
          10,
        );

        expect(
          const Interval(Intervals.seventh, ImperfectQuality.diminished)
              .semitones,
          9,
        );
        expect(
          const Interval(Intervals.seventh, ImperfectQuality.minor).semitones,
          10,
        );
        expect(
          const Interval(Intervals.seventh, ImperfectQuality.major).semitones,
          11,
        );
        expect(
          const Interval(Intervals.seventh, ImperfectQuality.augmented)
              .semitones,
          12,
        );

        expect(
          const Interval(Intervals.octave, PerfectQuality.diminished).semitones,
          11,
        );
        expect(
          const Interval(Intervals.octave, PerfectQuality.perfect).semitones,
          12,
        );
        expect(
          const Interval(Intervals.octave, PerfectQuality.augmented).semitones,
          13,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Interval', () {
        expect(
          const Interval(Intervals.second, ImperfectQuality.major).toString(),
          'major (+1) second',
        );
        expect(
          const Interval(Intervals.fifth, PerfectQuality.perfect).toString(),
          'perfect (+0) fifth',
        );
        expect(
          const Interval(Intervals.seventh, ImperfectQuality.diminished)
              .toString(),
          'diminished (-1) seventh',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {
          const Interval(Intervals.second, ImperfectQuality.major),
          const Interval(Intervals.third, ImperfectQuality.diminished),
          const Interval(Intervals.fourth, PerfectQuality.perfect),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Interval(Intervals.second, ImperfectQuality.major),
          const Interval(Intervals.third, ImperfectQuality.diminished),
          const Interval(Intervals.fourth, PerfectQuality.perfect),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of([
          const Interval(Intervals.second, ImperfectQuality.minor),
          const Interval(Intervals.octave, PerfectQuality.perfect),
          const Interval(Intervals.unison, PerfectQuality.perfect),
          const Interval(Intervals.unison, PerfectQuality.augmented),
        ]);
        expect(orderedSet.toList(), [
          const Interval(Intervals.unison, PerfectQuality.perfect),
          const Interval(Intervals.unison, PerfectQuality.augmented),
          const Interval(Intervals.second, ImperfectQuality.minor),
          const Interval(Intervals.octave, PerfectQuality.perfect),
        ]);
      });
    });
  });
}
