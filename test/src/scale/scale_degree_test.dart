import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScaleDegree', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => ScaleDegree(-1), throwsA(isA<AssertionError>()));
        expect(() => ScaleDegree(0), throwsA(isA<AssertionError>()));
        expect(
          () => ScaleDegree(1, inversion: -1),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => ScaleDegree(-2, inversion: -3),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.isRaised', () {
      test('returns whether this ScaleDegree is raised', () {
        expect(ScaleDegree.ii.isRaised, isFalse);
        expect(ScaleDegree.neapolitanSixth.isRaised, isFalse);
        expect(const ScaleDegree(3, semitonesDelta: 1).isRaised, isTrue);
      });
    });

    group('.isLowered', () {
      test('returns whether this ScaleDegree is lowered', () {
        expect(ScaleDegree.iv.isLowered, isFalse);
        expect(ScaleDegree.neapolitanSixth.isLowered, isTrue);
        expect(const ScaleDegree(6, semitonesDelta: 1).isLowered, isFalse);
      });
    });

    group('.raised', () {
      test('returns this ScaleDegree raised by 1 semitone', () {
        expect(ScaleDegree.vi.raised, const ScaleDegree(6, semitonesDelta: 1));
        expect(
          ScaleDegree.ii.raised.raised,
          const ScaleDegree(2, semitonesDelta: 2),
        );
        expect(ScaleDegree.ii.raised.lowered, ScaleDegree.ii);
      });
    });

    group('.lowered', () {
      test('returns this ScaleDegree lowered by 1 semitone', () {
        expect(
          ScaleDegree.ii.lowered,
          const ScaleDegree(2, semitonesDelta: -1),
        );
        expect(
          ScaleDegree.vi.lowered.lowered,
          const ScaleDegree(6, semitonesDelta: -2),
        );
        expect(ScaleDegree.iii.lowered.raised, ScaleDegree.iii);
      });
    });

    group('.inverted', () {
      test('returns this ScaleDegree inverted', () {
        expect(ScaleDegree.ii.inverted, const ScaleDegree(2, inversion: 1));
        expect(
          ScaleDegree.vi.lowered.lowered.inverted.inverted,
          const ScaleDegree(6, semitonesDelta: -2, inversion: 2),
        );
        expect(
          ScaleDegree.iii.inverted.inverted.inverted,
          const ScaleDegree(3, inversion: 3),
        );
      });
    });

    group('.major', () {
      test('returns this ScaleDegree as major', () {
        expect(
          ScaleDegree.ii.major,
          const ScaleDegree(2, quality: ImperfectQuality.major),
        );
        expect(
          ScaleDegree.vi.minor.major,
          const ScaleDegree(6, quality: ImperfectQuality.major),
        );
      });
    });

    group('.minor', () {
      test('returns this ScaleDegree as minor', () {
        expect(
          ScaleDegree.ii.minor,
          const ScaleDegree(2, quality: ImperfectQuality.minor),
        );
        expect(
          ScaleDegree.neapolitanSixth.minor,
          const ScaleDegree(
            2,
            quality: ImperfectQuality.minor,
            inversion: 1,
            semitonesDelta: -1,
          ),
        );
        expect(
          ScaleDegree.iv.major.minor,
          const ScaleDegree(4, quality: ImperfectQuality.minor),
        );
      });
    });

    group('.romanNumeral', () {
      test('returns the roman numeral of this ScaleDegree', () {
        expect(ScaleDegree.i.romanNumeral, 'I');
        expect(ScaleDegree.ii.minor.romanNumeral, 'II');
        expect(ScaleDegree.iii.minor.inverted.romanNumeral, 'III');
        expect(ScaleDegree.iv.major.lowered.romanNumeral, 'IV');
        expect(ScaleDegree.v.minor.raised.romanNumeral, 'V');
        expect(ScaleDegree.vi.romanNumeral, 'VI');
        expect(ScaleDegree.vii.romanNumeral, 'VII');
      });

      test('returns the ordinal number if higher than 7', () {
        expect(const ScaleDegree(8).romanNumeral, '8');
        expect(const ScaleDegree(20).romanNumeral, '20');
      });
    });

    group('.toString()', () {
      test('returns the string representation of this ScaleDegree', () {
        expect(ScaleDegree.i.toString(), 'I');
        expect(ScaleDegree.neapolitanSixth.toString(), '♭II6');
        expect(const ScaleDegree(3, inversion: 2).toString(), 'III64');
        expect(
          const ScaleDegree(4, quality: ImperfectQuality.minor).toString(),
          'iv',
        );
        expect(const ScaleDegree(6, semitonesDelta: 1).toString(), '♯VI');
        expect(ScaleDegree.vii.toString(), 'VII');
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal ScaleDegrees', () {
        // ignore: prefer_const_constructors test
        expect(ScaleDegree(1).hashCode, ScaleDegree(1).hashCode);
        expect(
          // ignore: prefer_const_constructors test
          ScaleDegree(
            2,
            quality: ImperfectQuality.major,
            inversion: 1,
            semitonesDelta: -1,
          ).hashCode,
          // ignore: prefer_const_constructors test
          ScaleDegree(
            2,
            quality: ImperfectQuality.major,
            inversion: 1,
            semitonesDelta: -1,
          ).hashCode,
        );
      });

      test('returns different hashCodes for different ScaleDegrees', () {
        expect(ScaleDegree.i.hashCode, isNot(ScaleDegree.ii.hashCode));
        expect(
          const ScaleDegree(6, inversion: 1).hashCode,
          isNot(ScaleDegree.vi.hashCode),
        );
      });

      test('ignores equal ScaleDegree instances in a Set', () {
        final collection = {
          ScaleDegree.i,
          ScaleDegree.neapolitanSixth,
          ScaleDegree.iii,
          const ScaleDegree(6, inversion: 1, semitonesDelta: -1),
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          ScaleDegree.i,
          ScaleDegree.neapolitanSixth,
          ScaleDegree.iii,
          ScaleDegree(6, inversion: 1, semitonesDelta: -1),
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts ScaleDegrees in a collection', () {
        final orderedSet = SplayTreeSet.of({
          const ScaleDegree(2, inversion: 2, semitonesDelta: -1),
          ScaleDegree.vii,
          ScaleDegree.ii,
          ScaleDegree.neapolitanSixth,
          ScaleDegree.i,
          const ScaleDegree(2, quality: ImperfectQuality.major),
          const ScaleDegree(2, quality: ImperfectQuality.minor),
          const ScaleDegree(
            2,
            quality: ImperfectQuality.major,
            semitonesDelta: 1,
          ),
        });
        expect(orderedSet.toList(), const [
          ScaleDegree.i,
          ScaleDegree.neapolitanSixth,
          ScaleDegree(2, inversion: 2, semitonesDelta: -1),
          ScaleDegree(2, quality: ImperfectQuality.minor),
          ScaleDegree(2, quality: ImperfectQuality.major),
          ScaleDegree.ii,
          ScaleDegree(2, quality: ImperfectQuality.major, semitonesDelta: 1),
          ScaleDegree.vii,
        ]);
      });
    });
  });
}
