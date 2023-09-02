import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PythagoreanTuning', () {
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

    group('.generatorCents', () {
      test(
        'should return the number of cents for the generator at Interval.P5 in '
        'this PythagoreanTuning',
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
}
