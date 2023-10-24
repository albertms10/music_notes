import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generatorCents', () {
      test(
        'should return the number of cents for the generator at Interval.P5 in '
        'this JustIntonation',
        () {
          expect(const PythagoreanTuning().generatorCents, 701.9550008653874);
          expect(
            PythagoreanTuning(referenceNote: Note.a.flat.inOctave(3))
                .generatorCents,
            701.9550008653874,
          );
        },
      );
    });
  });

  group('PythagoreanTuning', () {
    group('.ratioFromNote()', () {
      test('should return the ratio from Note in this PythagoreanTuning', () {
        expect(
          const PythagoreanTuning().ratioFromNote(Note.c.inOctave(4)),
          1 / 1,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.c.sharp.inOctave(4)),
          2187 / 2048,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.flat.inOctave(4)),
          1.0534979423868311, // 256 / 243
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.inOctave(4)),
          9 / 8,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.sharp.inOctave(4)),
          19683 / 16384,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.e.flat.inOctave(4)),
          32 / 27,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.e.inOctave(4)),
          81 / 64,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.inOctave(4)),
          4 / 3,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.sharp.inOctave(4)),
          729 / 512,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.flat.inOctave(4)),
          1.4046639231824414, // 1024 / 729
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.inOctave(4)),
          3 / 2,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.sharp.inOctave(4)),
          6561 / 4096,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.flat.inOctave(4)),
          128 / 81,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.inOctave(4)),
          27 / 16,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.sharp.inOctave(4)),
          59049 / 32768,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.b.inOctave(4)),
          243 / 128,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.c.inOctave(5)),
          2 / 1,
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.inOctave(5)),
          8 / 3,
        );
      });
    });

    group('.centsFromNote()', () {
      test('should return the cents from Note in this PythagoreanTuning', () {
        expect(
          const PythagoreanTuning().centsFromNote(Note.d.inOctave(4)),
          203.91000173077487,
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.f.inOctave(4)),
          498.04499913461257,
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.f.inOctave(3)),
          498.04499913461257,
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.f.inOctave(5)),
          498.04499913461257,
        );
      });
    });

    group('.pythagoreanComma', () {
      test('should return the ratio and cents of the Pythagorean comma', () {
        expect(
          const PythagoreanTuning().pythagoreanComma,
          (ratio: 1.0136432647705078, cents: 23.46001038464965),
        );
        expect(
          PythagoreanTuning(referenceNote: Note.f.sharp.inOctave(5))
              .pythagoreanComma,
          (ratio: 1.0136432647705078, cents: 23.46001038464965),
        );
      });
    });
  });
}
