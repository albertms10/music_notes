import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('HarmonicFunction', () {
    group('.copyWith()', () {
      test(
        'creates a new HarmonicFunction by updating individual properties',
        () {
          expect(HarmonicFunction.iv.copyWith(), HarmonicFunction.iv);
          expect(
            HarmonicFunction.i.copyWith(scaleDegree: .iii),
            HarmonicFunction.iii,
          );
          expect(
            HarmonicFunction.ii.copyWith(tonicization: .iii),
            HarmonicFunction.ii / .iii,
          );
          expect(
            HarmonicFunction.dominantV.on(.vi).copyWith(scaleDegree: .ii),
            HarmonicFunction.ii / .vi,
          );
        },
      );
    });

    group('operator /()', () {
      test('returns the HarmonicFunction relating this to other', () {
        expect(
          HarmonicFunction.dominantV / .dominantV,
          const HarmonicFunction(
            .v,
            pattern: .majorTriad,
            tonicization: .dominantV,
          ),
        );
        expect(
          HarmonicFunction.ii / .ii,
          const HarmonicFunction(.ii, tonicization: .ii),
        );
        expect(
          HarmonicFunction.vi / .iv,
          const HarmonicFunction(.vi, tonicization: .iv),
        );
        expect(
          HarmonicFunction.i / .ii / .iii,
          const HarmonicFunction(
            .i,
            tonicization: HarmonicFunction(.ii, tonicization: .iii),
          ),
        );
      });
    });

    group('.format()', () {
      test('returns the string representation of this HarmonicFunction', () {
        expect(HarmonicFunction.i.format(), 'I');
        expect(HarmonicFunction.vii.format(), 'VII');
        expect((HarmonicFunction.dominantV / .dominantV).format(), 'V/V');
        expect(
          (const HarmonicFunction(.iv, pattern: .minorTriad) /
                  .neapolitanSixth /
                  .dominantV)
              .format(),
          'iv/♭II6/V',
        );
      });
    });

    group('.toString()', () {
      test(
        'returns the verbose string representation of this HarmonicFunction',
        () {
          expect(
            HarmonicFunction.neapolitanSixth.toString(),
            '''
HarmonicFunction(scaleDegree: ScaleDegree(ordinal: 2, accidental: Accidental(semitones: -1)), pattern: ChordPattern(intervals: [
\tInterval(size: 3, quality: ImperfectQuality(semitones: 0)),
\tInterval(size: 6, quality: ImperfectQuality(semitones: 0))
]), tonicization: null)''',
          );
          expect(
            (HarmonicFunction.dominantV / .dominantV).toString(),
            '''
HarmonicFunction(scaleDegree: ScaleDegree(ordinal: 5, accidental: Accidental(semitones: 0)), pattern: ChordPattern(intervals: [
\tInterval(size: 3, quality: ImperfectQuality(semitones: 1)),
\tInterval(size: 5, quality: PerfectQuality(semitones: 0))
]), tonicization: HarmonicFunction(scaleDegree: ScaleDegree(ordinal: 5, accidental: Accidental(semitones: 0)), pattern: ChordPattern(intervals: [
\tInterval(size: 3, quality: ImperfectQuality(semitones: 1)),
\tInterval(size: 5, quality: PerfectQuality(semitones: 0))
]), tonicization: null))''',
          );
        },
      );
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal HarmonicFunctions', () {
        expect(
          // ignore: prefer_const_constructors test
          HarmonicFunction(.i).hashCode,
          // ignore: prefer_const_constructors test
          HarmonicFunction(.i).hashCode,
        );
        expect(
          // ignore: prefer_const_constructors test
          HarmonicFunction(ScaleDegree(2), pattern: .minorTriad).hashCode,
          // ignore: prefer_const_constructors test
          HarmonicFunction(ScaleDegree(2), pattern: .minorTriad).hashCode,
        );
      });

      test('returns different hashCodes for different HarmonicFunctions', () {
        expect(
          HarmonicFunction.i.hashCode,
          isNot(HarmonicFunction.ii.hashCode),
        );
        expect(
          const HarmonicFunction(.vi, tonicization: .i).hashCode,
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
