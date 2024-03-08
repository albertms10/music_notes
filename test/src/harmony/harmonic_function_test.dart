import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('HarmonicFunction', () {
    group('.scaleDegrees', () {
      test('returns an unmodifiable collection', () {
        expect(
          HarmonicFunction.i.scaleDegrees,
          isA<UnmodifiableListView<ScaleDegree>>(),
        );
      });
    });

    group('operator /()', () {
      test('returns the HarmonicFunction relating this to other', () {
        expect(
          HarmonicFunction.dominantV / HarmonicFunction.dominantV,
          HarmonicFunction([ScaleDegree.v.major, ScaleDegree.v.major]),
        );
        expect(
          HarmonicFunction.ii / HarmonicFunction.ii,
          const HarmonicFunction([ScaleDegree.ii, ScaleDegree.ii]),
        );
        expect(
          HarmonicFunction.vi / HarmonicFunction.iv,
          const HarmonicFunction([ScaleDegree.vi, ScaleDegree.iv]),
        );
        expect(
          HarmonicFunction.i / HarmonicFunction.ii / HarmonicFunction.iii,
          const HarmonicFunction(
            [ScaleDegree.i, ScaleDegree.ii, ScaleDegree.iii],
          ),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this HarmonicFunction', () {
        expect(HarmonicFunction.i.toString(), 'I');
        expect(HarmonicFunction.vii.toString(), 'VII');
        expect(
          (HarmonicFunction.dominantV / HarmonicFunction.dominantV).toString(),
          'V/V',
        );
        expect(
          (HarmonicFunction([ScaleDegree.iv.minor]) /
                  HarmonicFunction.neapolitanSixth /
                  HarmonicFunction.dominantV)
              .toString(),
          'iv/♭II6/V',
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal HarmonicFunctions', () {
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.i]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.i]).hashCode,
        );
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([
            // ignore: prefer_const_constructors
            ScaleDegree(
              2,
              quality: ImperfectQuality.major,
              inversion: 1,
              semitonesDelta: -1,
            ),
          ]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([
            // ignore: prefer_const_constructors
            ScaleDegree(
              2,
              quality: ImperfectQuality.major,
              inversion: 1,
              semitonesDelta: -1,
            ),
          ]).hashCode,
        );
      });

      test('returns different hashCodes for different HarmonicFunctions', () {
        expect(
          HarmonicFunction.i.hashCode,
          isNot(HarmonicFunction.ii.hashCode),
        );
        expect(
          const HarmonicFunction([ScaleDegree.vi, ScaleDegree.i]).hashCode,
          isNot(HarmonicFunction.vi.hashCode),
        );
      });

      test('ignores equal HarmonicFunction instances in a Set', () {
        final collection = {
          HarmonicFunction.i,
          HarmonicFunction.neapolitanSixth,
          HarmonicFunction.iii,
          HarmonicFunction.iv / HarmonicFunction.iv,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          HarmonicFunction.i,
          HarmonicFunction.neapolitanSixth,
          HarmonicFunction.iii,
          HarmonicFunction.iv / HarmonicFunction.iv,
        ]);
      });
    });
  });
}
