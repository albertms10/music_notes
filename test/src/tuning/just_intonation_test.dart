import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generator', () {
      test('returns the number of cents for the generator at Interval.P5 in '
          'this JustIntonation', () {
        const generator = Cent(701.9550008653874);
        expect(const PythagoreanTuning().generator, generator);
        expect(
          PythagoreanTuning(
            fork: Note.a.flat.inOctave(3).at(.reference),
          ).generator,
          generator,
        );
      });
    });
  });

  group('PythagoreanTuning', () {
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
