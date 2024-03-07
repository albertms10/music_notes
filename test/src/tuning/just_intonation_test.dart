import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generator', () {
      test(
        'returns the number of cents for the generator at Interval.P5 in '
        'this JustIntonation',
        () {
          const generator = Cent(701.9550008653874);
          expect(const PythagoreanTuning().generator, generator);
          expect(
            PythagoreanTuning(referencePitch: Note.a.flat.inOctave(3))
                .generator,
            generator,
          );
        },
      );
    });
  });

  group('PythagoreanTuning', () {
    group('.ratio()', () {
      test('returns the Ratio from Note in this PythagoreanTuning', () {
        expect(
          const PythagoreanTuning().ratio(Note.c.inOctave(4)),
          const Ratio(1 / 1),
        );
        expect(
          const PythagoreanTuning().ratio(Note.c.sharp.inOctave(4)),
          const Ratio(2187 / 2048),
        );
        expect(
          const PythagoreanTuning().ratio(Note.d.flat.inOctave(4)),
          closeTo(const Ratio(256 / 243), 1e-15),
        );
        expect(
          const PythagoreanTuning().ratio(Note.d.inOctave(4)),
          const Ratio(9 / 8),
        );
        expect(
          const PythagoreanTuning().ratio(Note.d.sharp.inOctave(4)),
          const Ratio(19683 / 16384),
        );
        expect(
          const PythagoreanTuning().ratio(Note.e.flat.inOctave(4)),
          const Ratio(32 / 27),
        );
        expect(
          const PythagoreanTuning().ratio(Note.e.inOctave(4)),
          const Ratio(81 / 64),
        );
        expect(
          const PythagoreanTuning().ratio(Note.f.inOctave(4)),
          const Ratio(4 / 3),
        );
        expect(
          const PythagoreanTuning().ratio(Note.f.sharp.inOctave(4)),
          const Ratio(729 / 512),
        );
        expect(
          const PythagoreanTuning().ratio(Note.g.flat.inOctave(4)),
          closeTo(const Ratio(1024 / 729), 1e-15),
        );
        expect(
          const PythagoreanTuning().ratio(Note.g.inOctave(4)),
          const Ratio(3 / 2),
        );
        expect(
          const PythagoreanTuning().ratio(Note.g.sharp.inOctave(4)),
          const Ratio(6561 / 4096),
        );
        expect(
          const PythagoreanTuning().ratio(Note.a.flat.inOctave(4)),
          const Ratio(128 / 81),
        );
        expect(
          const PythagoreanTuning().ratio(Note.a.inOctave(4)),
          const Ratio(27 / 16),
        );
        expect(
          const PythagoreanTuning().ratio(Note.a.sharp.inOctave(4)),
          const Ratio(59049 / 32768),
        );
        expect(
          const PythagoreanTuning().ratio(Note.b.inOctave(4)),
          const Ratio(243 / 128),
        );
        expect(
          const PythagoreanTuning().ratio(Note.c.inOctave(5)),
          const Ratio(2 / 1),
        );
        expect(
          const PythagoreanTuning().ratio(Note.f.inOctave(5)),
          const Ratio(8 / 3),
        );
      });
    });

    group('.pythagoreanComma', () {
      test('returns the Ratio of the Pythagorean comma', () {
        const pythagoreanComma = Ratio(1.0136432647705078);
        expect(const PythagoreanTuning().pythagoreanComma, pythagoreanComma);
        expect(
          PythagoreanTuning(referencePitch: Note.f.sharp.inOctave(5))
              .pythagoreanComma,
          pythagoreanComma,
        );
      });
    });
  });
}
