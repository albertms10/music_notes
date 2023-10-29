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
        expect(EqualTemperament.edo12.ratio(), const Ratio(1.0594630943592953));
        expect(EqualTemperament.edo12.ratio(12), const Ratio(2));

        expect(EqualTemperament.edo19.ratio(), const Ratio(1.0371550444461919));
        expect(EqualTemperament.edo19.ratio(19), const Ratio(2));
      });
    });

    group('.generatorCents', () {
      test(
        'should return the number of cents for semitones in this '
        'EqualTemperament',
        () {
          expect(EqualTemperament.edo12.generatorCents, const Cent(700));
          expect(
            EqualTemperament.edo19.generatorCents,
            const Cent(694.7368421052632),
          );
        },
      );
    });
  });
}
