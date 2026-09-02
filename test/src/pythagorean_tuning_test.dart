import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PythagoreanTuning', () {
    group('.fifthRatio, .fourthRatio', () {
      test('defaults to the pure ascending fifth and fourth ratios', () {
        expect(
          const PythagoreanTuning().fifthRatio,
          JustIntonation.ascendingFifthRatio,
        );
        expect(
          const PythagoreanTuning().fourthRatio,
          JustIntonation.ascendingFourthRatio,
        );
      });

      test('.fourthRatio is always the octave complement of .fifthRatio', () {
        const pt = PythagoreanTuning();
        expect(pt.fourthRatio * pt.fifthRatio, 2);
      });
    });

    group('.ratio()', () {
      test('returns the Ratio from Note in this PythagoreanTuning', () {
        expect(const PythagoreanTuning().ratio(Note.c.inOctave(4)), 1);
        expect(
          const PythagoreanTuning().ratio(Note.c.sharp.inOctave(4)),
          2187 / 2048,
        );
        expect(
          const PythagoreanTuning().ratio(Note.d.flat.inOctave(4)),
          closeTo(256 / 243, 1e-15),
        );
        expect(const PythagoreanTuning().ratio(Note.d.inOctave(4)), 9 / 8);
        expect(
          const PythagoreanTuning().ratio(Note.d.sharp.inOctave(4)),
          19683 / 16384,
        );
        expect(
          const PythagoreanTuning().ratio(Note.e.flat.inOctave(4)),
          32 / 27,
        );
        expect(const PythagoreanTuning().ratio(Note.e.inOctave(4)), 81 / 64);
        expect(const PythagoreanTuning().ratio(Note.f.inOctave(4)), 4 / 3);
        expect(
          const PythagoreanTuning().ratio(Note.f.sharp.inOctave(4)),
          729 / 512,
        );
        expect(
          const PythagoreanTuning().ratio(Note.g.flat.inOctave(4)),
          closeTo(1024 / 729, 1e-15),
        );
        expect(const PythagoreanTuning().ratio(Note.g.inOctave(4)), 3 / 2);
        expect(
          const PythagoreanTuning().ratio(Note.g.sharp.inOctave(4)),
          6561 / 4096,
        );
        expect(
          const PythagoreanTuning().ratio(Note.a.flat.inOctave(4)),
          128 / 81,
        );
        expect(const PythagoreanTuning().ratio(Note.a.inOctave(4)), 27 / 16);
        expect(
          const PythagoreanTuning().ratio(Note.a.sharp.inOctave(4)),
          59049 / 32768,
        );
        expect(const PythagoreanTuning().ratio(Note.b.inOctave(4)), 243 / 128);
        expect(const PythagoreanTuning().ratio(Note.c.inOctave(5)), 2);
        expect(const PythagoreanTuning().ratio(Note.f.inOctave(5)), 8 / 3);
      });

      test('returns the ratio for pitches below the fork’s octave', () {
        expect(const PythagoreanTuning().ratio(Note.c.inOctave(3)), 0.5);
        expect(
          const PythagoreanTuning().ratio(Note.f.inOctave(3)),
          closeTo(2 / 3, 1e-12),
        );
        expect(
          const PythagoreanTuning().ratio(Note.g.inOctave(3)),
          closeTo(3 / 4, 1e-12),
        );
        expect(
          const PythagoreanTuning().ratio(Note.b.flat.inOctave(2)),
          closeTo(4 / 9, 1e-12),
        );
      });
    });

    group('.pythagoreanComma', () {
      test('returns the ratio of the Pythagorean comma', () {
        const pythagoreanComma = 1.0136432647705078;
        expect(const PythagoreanTuning().pythagoreanComma, pythagoreanComma);
        expect(
          PythagoreanTuning(
            fork: Note.f.sharp.inOctave(5).at(.reference),
          ).pythagoreanComma,
          pythagoreanComma,
        );
      });
    });
  });
}
