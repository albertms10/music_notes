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
