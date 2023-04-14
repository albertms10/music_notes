import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(
          () => Interval.perfect(2, PerfectQuality.diminished),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Interval.imperfect(5, ImperfectQuality.augmented),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.fromDesiredSemitones()', () {
      test('should create a new Interval from desired semitones', () {
        expect(
          Interval.fromDesiredSemitones(1, -1),
          const Interval.perfect(1, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(1, 0),
          const Interval.perfect(1, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(1, 1),
          const Interval.perfect(1, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(2, 0),
          const Interval.imperfect(2, ImperfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(2, 1),
          const Interval.imperfect(2, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(2, 2),
          const Interval.imperfect(2, ImperfectQuality.major),
        );
        expect(
          Interval.fromDesiredSemitones(2, 3),
          const Interval.imperfect(2, ImperfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(3, 2),
          const Interval.imperfect(3, ImperfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(3, 3),
          const Interval.imperfect(3, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(3, 4),
          const Interval.imperfect(3, ImperfectQuality.major),
        );
        expect(
          Interval.fromDesiredSemitones(3, 5),
          const Interval.imperfect(3, ImperfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(4, 4),
          const Interval.perfect(4, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(4, 5),
          const Interval.perfect(4, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(4, 6),
          const Interval.perfect(4, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(5, 6),
          const Interval.perfect(5, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(5, 7),
          const Interval.perfect(5, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(5, 8),
          const Interval.perfect(5, PerfectQuality.augmented),
        );

        expect(
          Interval.fromDesiredSemitones(6, 8),
          const Interval.imperfect(6, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(6, 9),
          const Interval.imperfect(6, ImperfectQuality.major),
        );

        expect(
          Interval.fromDesiredSemitones(7, 10),
          const Interval.imperfect(7, ImperfectQuality.minor),
        );
        expect(
          Interval.fromDesiredSemitones(7, 11),
          const Interval.imperfect(7, ImperfectQuality.major),
        );

        expect(
          Interval.fromDesiredSemitones(8, 11),
          const Interval.perfect(8, PerfectQuality.diminished),
        );
        expect(
          Interval.fromDesiredSemitones(8, 12),
          const Interval.perfect(8, PerfectQuality.perfect),
        );
        expect(
          Interval.fromDesiredSemitones(8, 13),
          const Interval.perfect(8, PerfectQuality.augmented),
        );
      });
    });

    group('.semitones', () {
      test('should return the number of semitones of this Interval', () {
        expect(
          const Interval.perfect(1, PerfectQuality.diminished).semitones,
          -1,
        );
        expect(
          const Interval.perfect(1, PerfectQuality.perfect).semitones,
          0,
        );
        expect(
          const Interval.perfect(1, PerfectQuality.augmented).semitones,
          1,
        );

        expect(
          const Interval.imperfect(2, ImperfectQuality.diminished).semitones,
          0,
        );
        expect(
          const Interval.imperfect(2, ImperfectQuality.minor).semitones,
          1,
        );
        expect(
          const Interval.imperfect(2, ImperfectQuality.major).semitones,
          2,
        );
        expect(
          const Interval.imperfect(2, ImperfectQuality.augmented).semitones,
          3,
        );

        expect(
          const Interval.imperfect(3, ImperfectQuality.diminished).semitones,
          2,
        );
        expect(
          const Interval.imperfect(3, ImperfectQuality.minor).semitones,
          3,
        );
        expect(
          const Interval.imperfect(3, ImperfectQuality.major).semitones,
          4,
        );
        expect(
          const Interval.imperfect(3, ImperfectQuality.augmented).semitones,
          5,
        );

        expect(
          const Interval.perfect(4, PerfectQuality.diminished).semitones,
          4,
        );
        expect(
          const Interval.perfect(4, PerfectQuality.perfect).semitones,
          5,
        );
        expect(
          const Interval.perfect(4, PerfectQuality.augmented).semitones,
          6,
        );

        expect(
          const Interval.perfect(5, PerfectQuality.diminished).semitones,
          6,
        );
        expect(
          const Interval.perfect(5, PerfectQuality.perfect).semitones,
          7,
        );
        expect(
          const Interval.perfect(5, PerfectQuality.augmented).semitones,
          8,
        );

        expect(
          const Interval.imperfect(6, ImperfectQuality.diminished).semitones,
          7,
        );
        expect(
          const Interval.imperfect(6, ImperfectQuality.minor).semitones,
          8,
        );
        expect(
          const Interval.imperfect(6, ImperfectQuality.major).semitones,
          9,
        );
        expect(
          const Interval.imperfect(6, ImperfectQuality.augmented).semitones,
          10,
        );

        expect(
          const Interval.imperfect(7, ImperfectQuality.diminished).semitones,
          9,
        );
        expect(
          const Interval.imperfect(7, ImperfectQuality.minor).semitones,
          10,
        );
        expect(
          const Interval.imperfect(7, ImperfectQuality.major).semitones,
          11,
        );
        expect(
          const Interval.imperfect(7, ImperfectQuality.augmented).semitones,
          12,
        );

        expect(
          const Interval.perfect(8, PerfectQuality.diminished).semitones,
          11,
        );
        expect(
          const Interval.perfect(8, PerfectQuality.perfect).semitones,
          12,
        );
        expect(
          const Interval.perfect(8, PerfectQuality.augmented).semitones,
          13,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Interval', () {
        expect(
          const Interval.imperfect(2, ImperfectQuality.major).toString(),
          'M2',
        );
        expect(
          const Interval.perfect(5, PerfectQuality.perfect).toString(),
          'P5',
        );
        expect(
          const Interval.imperfect(7, ImperfectQuality.diminished).toString(),
          'd7',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {
          const Interval.imperfect(2, ImperfectQuality.major),
          const Interval.imperfect(3, ImperfectQuality.diminished),
          const Interval.perfect(4, PerfectQuality.perfect),
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          Interval.imperfect(2, ImperfectQuality.major),
          Interval.imperfect(3, ImperfectQuality.diminished),
          Interval.perfect(4, PerfectQuality.perfect),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of(const [
          Interval.imperfect(2, ImperfectQuality.minor),
          Interval.perfect(8, PerfectQuality.perfect),
          Interval.perfect(1, PerfectQuality.perfect),
          Interval.perfect(1, PerfectQuality.augmented),
        ]);
        expect(orderedSet.toList(), const [
          Interval.perfect(1, PerfectQuality.perfect),
          Interval.perfect(1, PerfectQuality.augmented),
          Interval.imperfect(2, ImperfectQuality.minor),
          Interval.perfect(8, PerfectQuality.perfect),
        ]);
      });
    });
  });
}
