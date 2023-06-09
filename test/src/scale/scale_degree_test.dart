import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScaleDegree', () {
    group('.isRaised', () {
      test('should return whether this ScaleDegree is raised', () {
        expect(ScaleDegree.ii.isRaised, isFalse);
        expect(ScaleDegree.neapolitanSixth.isRaised, isFalse);
        expect(const ScaleDegree(3, semitonesDelta: 1).isRaised, isTrue);
      });
    });

    group('.isLowered', () {
      test('should return whether this ScaleDegree is lowered', () {
        expect(ScaleDegree.iv.isLowered, isFalse);
        expect(ScaleDegree.neapolitanSixth.isLowered, isTrue);
        expect(const ScaleDegree(6, semitonesDelta: 1).isLowered, isFalse);
      });
    });

    group('.raised', () {
      test('should return this ScaleDegree raised by 1 semitone', () {
        expect(ScaleDegree.vi.raised, const ScaleDegree(6, semitonesDelta: 1));
        expect(
          ScaleDegree.ii.raised.raised,
          const ScaleDegree(2, semitonesDelta: 2),
        );
        expect(ScaleDegree.ii.raised.lowered, ScaleDegree.ii);
      });
    });

    group('.lowered', () {
      test('should return this ScaleDegree lowered by 1 semitone', () {
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

    group('.major', () {
      test('should return this ScaleDegree as major', () {
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
      test('should return this ScaleDegree as minor', () {
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

    group('.toString()', () {
      test(
        'should return the string representation of this ScaleDegree',
        () {
          expect(ScaleDegree.i.toString(), 'I');
          expect(ScaleDegree.neapolitanSixth.toString(), '♭II6');
          expect(const ScaleDegree(3, inversion: 2).toString(), 'III64');
          expect(
            const ScaleDegree(4, quality: ImperfectQuality.minor).toString(),
            'iv',
          );
          expect(const ScaleDegree(6, semitonesDelta: 1).toString(), '♯VI');
          expect(ScaleDegree.vii.toString(), 'VII');
        },
      );
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal ScaleDegrees', () {
        expect(ScaleDegree.i.hashCode, ScaleDegree.i.hashCode);
        expect(
          ScaleDegree.neapolitanSixth.hashCode,
          ScaleDegree.neapolitanSixth.hashCode,
        );
      });

      test('should return different hashCodes for different ScaleDegrees', () {
        expect(ScaleDegree.i.hashCode, isNot(equals(ScaleDegree.ii.hashCode)));
        expect(
          const ScaleDegree(6, inversion: 1).hashCode,
          isNot(equals(ScaleDegree.vi.hashCode)),
        );
      });

      test('should ignore equal ScaleDegree instances in a Set', () {
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
      test('should correctly sort ScaleDegree items in a collection', () {
        final orderedSet = SplayTreeSet.of(const [
          ScaleDegree(2, inversion: 2, semitonesDelta: -1),
          ScaleDegree.vii,
          ScaleDegree.ii,
          ScaleDegree.neapolitanSixth,
          ScaleDegree.i,
          ScaleDegree(2, quality: ImperfectQuality.major),
          ScaleDegree(2, quality: ImperfectQuality.minor),
          ScaleDegree(2, quality: ImperfectQuality.major, semitonesDelta: 1),
        ]);
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
