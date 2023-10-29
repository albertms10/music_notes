import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generatorCents', () {
      test(
        'should return the number of cents for the generator at Interval.P5 in '
        'this JustIntonation',
        () {
          const generatorCents = Cent(701.9550008653874);
          expect(const PythagoreanTuning().generatorCents, generatorCents);
          expect(
            PythagoreanTuning(referenceNote: Note.a.flat.inOctave(3))
                .generatorCents,
            generatorCents,
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
          const Ratio(1 / 1),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.c.sharp.inOctave(4)),
          const Ratio(2187 / 2048),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.flat.inOctave(4)),
          const Ratio(1.0534979423868311), // 256 / 243
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.inOctave(4)),
          const Ratio(9 / 8),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.d.sharp.inOctave(4)),
          const Ratio(19683 / 16384),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.e.flat.inOctave(4)),
          const Ratio(32 / 27),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.e.inOctave(4)),
          const Ratio(81 / 64),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.inOctave(4)),
          const Ratio(4 / 3),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.sharp.inOctave(4)),
          const Ratio(729 / 512),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.flat.inOctave(4)),
          const Ratio(1.4046639231824414), // 1024 / 729
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.inOctave(4)),
          const Ratio(3 / 2),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.g.sharp.inOctave(4)),
          const Ratio(6561 / 4096),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.flat.inOctave(4)),
          const Ratio(128 / 81),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.inOctave(4)),
          const Ratio(27 / 16),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.a.sharp.inOctave(4)),
          const Ratio(59049 / 32768),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.b.inOctave(4)),
          const Ratio(243 / 128),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.c.inOctave(5)),
          const Ratio(2 / 1),
        );
        expect(
          const PythagoreanTuning().ratioFromNote(Note.f.inOctave(5)),
          const Ratio(8 / 3),
        );
      });
    });

    group('.centsFromNote()', () {
      test('should return the cents from Note in this PythagoreanTuning', () {
        expect(
          const PythagoreanTuning().centsFromNote(Note.c.inOctave(4)),
          const Cent(0),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.c.sharp.inOctave(4)),
          const Cent(113.68500605771169),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.d.flat.inOctave(4)),
          const Cent(90.22499567306295),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.d.inOctave(4)),
          const Cent(203.91000173077487),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.d.sharp.inOctave(4)),
          const Cent(317.59500778848724),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.e.flat.inOctave(4)),
          const Cent(294.1349974038376),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.e.inOctave(4)),
          const Cent(407.82000346154973),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.f.inOctave(4)),
          const Cent(498.04499913461257),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.f.sharp.inOctave(4)),
          const Cent(611.7300051923248),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.g.flat.inOctave(4)),
          const Cent(588.2699948076752),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.g.inOctave(4)),
          const Cent(701.9550008653874),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.g.sharp.inOctave(4)),
          const Cent(815.6400069230995),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.a.flat.inOctave(4)),
          const Cent(792.1799965384503),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.a.inOctave(4)),
          const Cent(905.8650025961624),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.a.sharp.inOctave(4)),
          const Cent(1019.5500086538741),
        );
        expect(
          const PythagoreanTuning().centsFromNote(Note.b.inOctave(4)),
          const Cent(1109.775004326937),
        );
      });
    });

    group('.pythagoreanComma', () {
      test('should return the ratio and cents of the Pythagorean comma', () {
        const pythagoreanComma = Ratio(1.0136432647705078);
        expect(const PythagoreanTuning().pythagoreanComma, pythagoreanComma);
        expect(
          PythagoreanTuning(referenceNote: Note.f.sharp.inOctave(5))
              .pythagoreanComma,
          pythagoreanComma,
        );
      });
    });
  });
}
