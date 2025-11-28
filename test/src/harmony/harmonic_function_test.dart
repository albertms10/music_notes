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
          HarmonicFunction.dominantV / .dominantV,
          HarmonicFunction([.v.major, .v.major]),
        );
        expect(HarmonicFunction.ii / .ii, const HarmonicFunction([.ii, .ii]));
        expect(
          HarmonicFunction.vi / .iv,
          const HarmonicFunction([.vi, .iv]),
        );
        expect(
          HarmonicFunction.i / .ii / .iii,
          const HarmonicFunction([.i, .ii, .iii]),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this HarmonicFunction', () {
        expect(HarmonicFunction.i.toString(), 'I');
        expect(HarmonicFunction.vii.toString(), 'VII');
        expect(
          (HarmonicFunction.dominantV / .dominantV).toString(),
          'V/V',
        );
        expect(
          (HarmonicFunction([.iv.minor]) / .neapolitanSixth / .dominantV)
              .toString(),
          'iv/♭II6/V',
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal HarmonicFunctions', () {
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables test
          HarmonicFunction([.i]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables test
          HarmonicFunction([.i]).hashCode,
        );
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables test
          HarmonicFunction([
            // ignore: prefer_const_constructors test
            ScaleDegree(2, quality: .major, inversion: 1, semitonesDelta: -1),
          ]).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables test
          HarmonicFunction([
            // ignore: prefer_const_constructors test
            ScaleDegree(2, quality: .major, inversion: 1, semitonesDelta: -1),
          ]).hashCode,
        );
      });

      test('returns different hashCodes for different HarmonicFunctions', () {
        expect(
          HarmonicFunction.i.hashCode,
          isNot(HarmonicFunction.ii.hashCode),
        );
        expect(
          const HarmonicFunction([.vi, .i]).hashCode,
          isNot(HarmonicFunction.vi.hashCode),
        );
      });

      test('ignores equal HarmonicFunction instances in a Set', () {
        final collection = <HarmonicFunction>{
          .i,
          .neapolitanSixth,
          .iii,
          HarmonicFunction.iv / .iv,
        };
        collection.addAll(collection);
        expect(collection.toList(), <HarmonicFunction>[
          .i,
          .neapolitanSixth,
          .iii,
          HarmonicFunction.iv / .iv,
        ]);
      });
    });
  });
}
