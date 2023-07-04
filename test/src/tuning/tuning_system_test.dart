import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EqualTemperament', () {
    group('.octaveDivisions', () {
      test(
        'should return the equal divisions of the octave for this '
        'TuningSystem',
        () {
          expect(EqualTemperament.edo12.octaveDivisions, 12);
          expect(EqualTemperament.edo19.octaveDivisions, 19);
        },
      );
    });

    group('.ratio()', () {
      test('should return the semitones ratio for this EqualTemperament', () {
        expect(EqualTemperament.edo12.ratio(), closeTo(1.0595, 0.0001));
        expect(EqualTemperament.edo12.ratio(12), 2);

        expect(EqualTemperament.edo19.ratio(), closeTo(1.0372, 0.0001));
        expect(EqualTemperament.edo19.ratio(19), 2);
      });
    });

    group('.cents()', () {
      test(
        'should return the number of cents for semitones in this '
        'EqualTemperament',
        () {
          expect(EqualTemperament.edo12.cents(), closeTo(100, 0.01));
          expect(EqualTemperament.edo12.cents(6), closeTo(600, 0.01));
          expect(EqualTemperament.edo12.cents(12), closeTo(1200, 0.01));

          expect(EqualTemperament.edo19.cents(), closeTo(63.16, 0.01));
          expect(EqualTemperament.edo19.cents(10), closeTo(631.58, 0.01));
          expect(EqualTemperament.edo19.cents(19), closeTo(1200, 0.01));
        },
      );
    });

    group('.generatorCents', () {
      test(
        'should return the number of cents for semitones in this '
        'EqualTemperament',
        () {
          expect(EqualTemperament.edo12.generatorCents, 700);
          expect(EqualTemperament.edo19.generatorCents, closeTo(694.74, 0.01));
        },
      );
    });
  });
}
