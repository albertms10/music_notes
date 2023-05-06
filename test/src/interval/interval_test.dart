import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(
          () => Interval.perfect(0, PerfectQuality.perfect),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Interval.imperfect(0, ImperfectQuality.minor),
          throwsA(isA<AssertionError>()),
        );
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

    group('.fromSemitones()', () {
      test('should create a new Interval from semitones', () {
        expect(Interval.fromSemitones(1, -1), Interval.diminishedUnison);
        expect(Interval.fromSemitones(1, 0), Interval.perfectUnison);
        expect(Interval.fromSemitones(1, 1), Interval.augmentedUnison);

        expect(Interval.fromSemitones(2, 0), Interval.diminishedSecond);
        expect(Interval.fromSemitones(2, 1), Interval.minorSecond);
        expect(Interval.fromSemitones(2, 2), Interval.majorSecond);
        expect(Interval.fromSemitones(2, 3), Interval.augmentedSecond);

        expect(Interval.fromSemitones(3, 2), Interval.diminishedThird);
        expect(Interval.fromSemitones(3, 3), Interval.minorThird);
        expect(Interval.fromSemitones(3, 4), Interval.majorThird);
        expect(Interval.fromSemitones(3, 5), Interval.augmentedThird);

        expect(Interval.fromSemitones(4, 4), Interval.diminishedFourth);
        expect(Interval.fromSemitones(4, 5), Interval.perfectFourth);
        expect(Interval.fromSemitones(4, 6), Interval.augmentedFourth);

        expect(Interval.fromSemitones(5, 6), Interval.diminishedFifth);
        expect(Interval.fromSemitones(5, 7), Interval.perfectFifth);
        expect(Interval.fromSemitones(5, 8), Interval.augmentedFifth);

        expect(Interval.fromSemitones(6, 8), Interval.minorSixth);
        expect(Interval.fromSemitones(6, 9), Interval.majorSixth);

        expect(Interval.fromSemitones(7, 10), Interval.minorSeventh);
        expect(Interval.fromSemitones(7, 11), Interval.majorSeventh);

        expect(Interval.fromSemitones(8, 11), Interval.diminishedOctave);
        expect(Interval.fromSemitones(8, 12), Interval.perfectOctave);
        expect(Interval.fromSemitones(8, 13), Interval.augmentedOctave);
      });
    });

    group('.fromSemitonesQuality()', () {
      test('should return the correct Interval from semitones and Quality', () {
        expect(Interval.fromSemitonesQuality(3), Interval.minorThird);
        expect(Interval.fromSemitonesQuality(6), Interval.augmentedFourth);
        expect(
          Interval.fromSemitonesQuality(6, PerfectQuality.augmented),
          Interval.augmentedFourth,
        );
        expect(
          Interval.fromSemitonesQuality(6, PerfectQuality.diminished),
          Interval.diminishedFifth,
        );
      });
    });

    group('.semitones', () {
      test('should return the number of semitones of this Interval', () {
        expect(Interval.diminishedUnison.semitones, -1);
        expect(Interval.perfectUnison.semitones, 0);
        expect((-Interval.perfectUnison).semitones, 0);
        expect(Interval.augmentedUnison.semitones, 1);

        expect(Interval.diminishedSecond.semitones, 0);
        expect(Interval.minorSecond.semitones, 1);
        expect((-Interval.minorSecond).semitones, -1);
        expect(Interval.majorSecond.semitones, 2);
        expect(Interval.augmentedSecond.semitones, 3);

        expect(Interval.diminishedThird.semitones, 2);
        expect(Interval.minorThird.semitones, 3);
        expect(Interval.majorThird.semitones, 4);
        expect(Interval.augmentedThird.semitones, 5);

        expect(Interval.diminishedFourth.semitones, 4);
        expect(Interval.perfectFourth.semitones, 5);
        expect((-Interval.perfectFourth).semitones, -5);
        expect(Interval.augmentedFourth.semitones, 6);

        expect(Interval.diminishedFifth.semitones, 6);
        expect(Interval.perfectFifth.semitones, 7);
        expect(Interval.augmentedFifth.semitones, 8);

        expect((-Interval.diminishedSixth).semitones, -7);
        expect(Interval.diminishedSixth.semitones, 7);
        expect(Interval.minorSixth.semitones, 8);
        expect(Interval.majorSixth.semitones, 9);
        expect(Interval.augmentedSixth.semitones, 10);

        expect(Interval.diminishedSeventh.semitones, 9);
        expect(Interval.minorSeventh.semitones, 10);
        expect(Interval.majorSeventh.semitones, 11);
        expect(Interval.augmentedSeventh.semitones, 12);

        expect(Interval.diminishedOctave.semitones, 11);
        expect(Interval.perfectOctave.semitones, 12);
        expect(Interval.augmentedOctave.semitones, 13);
        expect((-Interval.augmentedOctave).semitones, -13);
      });
    });

    group('.isDescending', () {
      test('should return whether this Interval is descending', () {
        expect(Interval.minorThird.isDescending, isFalse);
        expect((-Interval.perfectFifth).isDescending, isTrue);
        expect(Interval.diminishedUnison.isDescending, isFalse);
        expect(
          const Interval.imperfect(9, ImperfectQuality.major).isDescending,
          isFalse,
        );
        expect(
          const Interval.perfect(-4, PerfectQuality.doubleAugmented)
              .isDescending,
          isTrue,
        );
      });
    });

    group('.inverted', () {
      test('should return the inverted of this Interval', () {
        expect(Interval.augmentedUnison.inverted, Interval.diminishedOctave);
        expect(Interval.perfectUnison.inverted, Interval.perfectOctave);
        expect(Interval.majorSecond.inverted, Interval.minorSeventh);
        expect(Interval.minorThird.inverted, Interval.majorSixth);
        expect(Interval.diminishedFifth.inverted, Interval.augmentedFourth);
        expect(Interval.diminishedFourth.inverted, Interval.augmentedFifth);
      });
    });

    group('operator -()', () {
      test('should return the negation of this Interval', () {
        expect(
          -Interval.majorSecond,
          const Interval.imperfect(-2, ImperfectQuality.major),
        );
        expect(
          -const Interval.imperfect(-6, ImperfectQuality.minor),
          Interval.minorSixth,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Interval', () {
        expect(Interval.majorSecond.toString(), 'M2');
        expect(Interval.perfectFifth.toString(), 'P5');
        expect(Interval.diminishedSeventh.toString(), 'd7');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {
          Interval.majorSecond,
          Interval.diminishedThird,
          Interval.perfectFourth,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          Interval.majorSecond,
          Interval.diminishedThird,
          Interval.perfectFourth,
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of(const [
          Interval.minorSecond,
          Interval.perfectOctave,
          Interval.perfectUnison,
          Interval.augmentedUnison,
        ]);
        expect(orderedSet.toList(), const [
          Interval.perfectUnison,
          Interval.augmentedUnison,
          Interval.minorSecond,
          Interval.perfectOctave,
        ]);
      });
    });
  });
}
