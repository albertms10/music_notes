import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('.fromDesiredSemitones()', () {
      test('should create a new Interval from desired semitones', () {
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, 0),
          const Interval(Intervals.unison, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, 1),
          const Interval(Intervals.unison, Qualities.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.unison, 2),
          const Interval(Intervals.unison, Qualities.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.second, 1),
          const Interval(Intervals.second, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 2),
          const Interval(Intervals.second, Qualities.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 3),
          const Interval(Intervals.second, Qualities.major),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.second, 4),
          const Interval(Intervals.second, Qualities.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.third, 3),
          const Interval(Intervals.third, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 4),
          const Interval(Intervals.third, Qualities.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 5),
          const Interval(Intervals.third, Qualities.major),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.third, 6),
          const Interval(Intervals.third, Qualities.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 5),
          const Interval(Intervals.fourth, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 6),
          const Interval(Intervals.fourth, Qualities.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fourth, 7),
          const Interval(Intervals.fourth, Qualities.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 7),
          const Interval(Intervals.fifth, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 8),
          const Interval(Intervals.fifth, Qualities.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.fifth, 9),
          const Interval(Intervals.fifth, Qualities.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.sixth, 9),
          const Interval(Intervals.sixth, Qualities.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.sixth, 10),
          const Interval(Intervals.sixth, Qualities.major),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.seventh, 11),
          const Interval(Intervals.seventh, Qualities.minor),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.seventh, 12),
          const Interval(Intervals.seventh, Qualities.major),
        );

        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 12),
          const Interval(Intervals.octave, Qualities.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 13),
          const Interval(Intervals.octave, Qualities.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(Intervals.octave, 14),
          const Interval(Intervals.octave, Qualities.augmented),
        );
      });
    });

    group('.qualityFromDelta()', () {
      test('should return the quality from an Interval and delta', () {
        expect(
          Interval.qualityFromDelta(Intervals.unison, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.unison, 1),
          Qualities.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.unison, 2),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.second, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 1),
          Qualities.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 2),
          Qualities.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.second, 3),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.third, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 1),
          Qualities.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 2),
          Qualities.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.third, 3),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.fourth, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fourth, 1),
          Qualities.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fourth, 2),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.fifth, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fifth, 1),
          Qualities.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.fifth, 2),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.sixth, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 1),
          Qualities.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 2),
          Qualities.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.sixth, 3),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.seventh, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 1),
          Qualities.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 2),
          Qualities.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.seventh, 3),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.octave, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.octave, 1),
          Qualities.perfect,
        );
        expect(
          Interval.qualityFromDelta(Intervals.octave, 2),
          Qualities.augmented,
        );

        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 0),
          Qualities.diminished,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 1),
          Qualities.minor,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 2),
          Qualities.major,
        );
        expect(
          Interval.qualityFromDelta(Intervals.thirteenth, 3),
          Qualities.augmented,
        );
      });
    });

    group('.semitones', () {
      test('should return the number of semitones of this Interval', () {
        expect(
          const Interval(Intervals.unison, Qualities.diminished).semitones,
          -1,
        );
        expect(
          const Interval(Intervals.unison, Qualities.perfect).semitones,
          0,
        );
        expect(
          const Interval(Intervals.unison, Qualities.augmented).semitones,
          1,
        );

        expect(
          const Interval(Intervals.second, Qualities.diminished).semitones,
          0,
        );
        expect(
          const Interval(Intervals.second, Qualities.minor).semitones,
          1,
        );
        expect(
          const Interval(Intervals.second, Qualities.major).semitones,
          2,
        );
        expect(
          const Interval(Intervals.second, Qualities.augmented).semitones,
          3,
        );

        expect(
          const Interval(Intervals.third, Qualities.diminished).semitones,
          2,
        );
        expect(
          const Interval(Intervals.third, Qualities.minor).semitones,
          3,
        );
        expect(
          const Interval(Intervals.third, Qualities.major).semitones,
          4,
        );
        expect(
          const Interval(Intervals.third, Qualities.augmented).semitones,
          5,
        );

        expect(
          const Interval(Intervals.fourth, Qualities.diminished).semitones,
          4,
        );
        expect(
          const Interval(Intervals.fourth, Qualities.perfect).semitones,
          5,
        );
        expect(
          const Interval(Intervals.fourth, Qualities.augmented).semitones,
          6,
        );

        expect(
          const Interval(Intervals.fifth, Qualities.diminished).semitones,
          6,
        );
        expect(
          const Interval(Intervals.fifth, Qualities.perfect).semitones,
          7,
        );
        expect(
          const Interval(Intervals.fifth, Qualities.augmented).semitones,
          8,
        );

        expect(
          const Interval(Intervals.sixth, Qualities.diminished).semitones,
          7,
        );
        expect(
          const Interval(Intervals.sixth, Qualities.minor).semitones,
          8,
        );
        expect(
          const Interval(Intervals.sixth, Qualities.major).semitones,
          9,
        );
        expect(
          const Interval(Intervals.sixth, Qualities.augmented).semitones,
          10,
        );

        expect(
          const Interval(Intervals.seventh, Qualities.diminished).semitones,
          9,
        );
        expect(
          const Interval(Intervals.seventh, Qualities.minor).semitones,
          10,
        );
        expect(
          const Interval(Intervals.seventh, Qualities.major).semitones,
          11,
        );
        expect(
          const Interval(Intervals.seventh, Qualities.augmented).semitones,
          12,
        );

        expect(
          const Interval(Intervals.octave, Qualities.diminished).semitones,
          11,
        );
        expect(
          const Interval(Intervals.octave, Qualities.perfect).semitones,
          12,
        );
        expect(
          const Interval(Intervals.octave, Qualities.augmented).semitones,
          13,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Interval', () {
        expect(
          const Interval(Intervals.second, Qualities.major).toString(),
          'major second',
        );
        expect(
          const Interval(Intervals.fifth, Qualities.perfect).toString(),
          'perfect fifth',
        );
        expect(
          const Interval(Intervals.seventh, Qualities.diminished).toString(),
          'diminished seventh',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {
          const Interval(Intervals.second, Qualities.major),
          const Interval(Intervals.third, Qualities.diminished),
          const Interval(Intervals.fourth, Qualities.perfect),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Interval(Intervals.second, Qualities.major),
          const Interval(Intervals.third, Qualities.diminished),
          const Interval(Intervals.fourth, Qualities.perfect),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of([
          const Interval(Intervals.second, Qualities.minor),
          const Interval(Intervals.octave, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.augmented),
        ]);
        expect(orderedSet.toList(), [
          const Interval(Intervals.unison, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.augmented),
          const Interval(Intervals.second, Qualities.minor),
          const Interval(Intervals.octave, Qualities.perfect),
        ]);
      });
    });
  });
}
