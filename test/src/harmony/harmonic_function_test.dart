import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('HarmonicFunction', () {
    group('operator /', () {
      test('should return the HarmonicFunction relating this to other', () {
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
      test(
        'should return the string representation of this HarmonicFunction',
        () {
          expect(HarmonicFunction.i.toString(), 'I');
          expect(HarmonicFunction.vii.toString(), 'VII');
          expect(
            (HarmonicFunction.dominantV / HarmonicFunction.dominantV)
                .toString(),
            'V/V',
          );
          expect(
            (HarmonicFunction([ScaleDegree.iv.minor]) /
                    HarmonicFunction.neapolitanSixth /
                    HarmonicFunction.dominantV)
                .toString(),
            'iv/♭II6/V',
          );
        },
      );
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal HarmonicFunctions', () {
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.i]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.i]).hashCode,
        );
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.neapolitanSixth]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          HarmonicFunction([ScaleDegree.neapolitanSixth]).hashCode,
        );
      });

      test(
        'should return different hashCodes for different HarmonicFunctions',
        () {
          expect(
            HarmonicFunction.i.hashCode,
            isNot(equals(HarmonicFunction.ii.hashCode)),
          );
          expect(
            const HarmonicFunction([ScaleDegree.vi, ScaleDegree.i]).hashCode,
            isNot(equals(HarmonicFunction.vi.hashCode)),
          );
        },
      );
    });
  });
}
