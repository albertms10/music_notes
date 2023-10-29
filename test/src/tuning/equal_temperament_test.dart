import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EqualTemperament', () {
    group('.octaveDivisions', () {
      test(
        'should return the equal divisions of the octave for this '
        'TuningSystem',
        () {
          expect(const EqualTemperament.edo12().octaveDivisions, 12);
          expect(const EqualTemperament.edo19().octaveDivisions, 19);
        },
      );
    });

    group('.ratio()', () {
      test('should return the ratio from semitones for this EqualTemperament',
          () {
        expect(
          const EqualTemperament.edo12().ratio(),
          const Ratio(1.0594630943592953),
        );
        expect(const EqualTemperament.edo12().ratio(12), const Ratio(2));

        expect(
          const EqualTemperament.edo19().ratio(),
          const Ratio(1.0371550444461919),
        );
        expect(const EqualTemperament.edo19().ratio(19), const Ratio(2));
      });
    });

    group('.ratioFromNote()', () {
      test(
        'should return the ratio from a PositionedNote in this '
        'EqualTemperament',
        () {
          const edo12 = EqualTemperament.edo12();
          expect(
            edo12.ratioFromNote(Note.g.inOctave(4)).value,
            0.8908987181403393,
          );
          expect(edo12.ratioFromNote(Note.a.inOctave(4)).value, 1);
          expect(
            edo12.ratioFromNote(Note.b.flat.inOctave(4)).value,
            1.0594630943592953,
          );
          expect(edo12.ratioFromNote(Note.a.inOctave(5)).value, 2);
          expect(edo12.ratioFromNote(Note.a.inOctave(6)).value, 4);
        },
      );
    });

    group('.generatorCents', () {
      test(
        'should return the number of cents for the generator at Interval.P5 in '
        'this EqualTemperament',
        () {
          expect(
            const EqualTemperament.edo12().generatorCents,
            const Cent(700),
          );
          expect(
            const EqualTemperament.edo19().generatorCents,
            const Cent(694.7368421052632),
          );
        },
      );
    });
  });
}
