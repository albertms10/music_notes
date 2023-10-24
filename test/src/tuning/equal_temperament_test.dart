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
      test('should return the semitones ratio for this EqualTemperament', () {
        expect(const EqualTemperament.edo12().ratio(), closeTo(1.0595, 0.0001));
        expect(const EqualTemperament.edo12().ratio(12), 2);

        expect(const EqualTemperament.edo19().ratio(), closeTo(1.0372, 0.0001));
        expect(const EqualTemperament.edo19().ratio(19), 2);
      });
    });

    group('.ratioFromNote()', () {
      test(
        'should return the number of ratio from a PositionedNote in this '
        'EqualTemperament',
        () {
          expect(
            const EqualTemperament.edo12().ratioFromNote(Note.g.inOctave(4)),
            0.8908987181403393,
          );
          expect(
            const EqualTemperament.edo12().ratioFromNote(Note.a.inOctave(4)),
            1,
          );
          expect(
            const EqualTemperament.edo12()
                .ratioFromNote(Note.b.flat.inOctave(4)),
            1.0594630943592953,
          );
          expect(
            const EqualTemperament.edo12().ratioFromNote(Note.a.inOctave(5)),
            2,
          );
          expect(
            const EqualTemperament.edo12().ratioFromNote(Note.a.inOctave(6)),
            4,
          );
        },
      );
    });

    group('.centsFromNote()', () {
      test(
        'should return the number of cents from a PositionedNote in this '
        'EqualTemperament',
        () {
          expect(
            const EqualTemperament.edo12().centsFromNote(Note.g.inOctave(4)),
            closeTo(-200, 0.01),
          );
          expect(
            const EqualTemperament.edo12().centsFromNote(Note.a.inOctave(4)),
            0,
          );
          expect(
            const EqualTemperament.edo12()
                .centsFromNote(Note.b.flat.inOctave(4)),
            closeTo(100, 0.01),
          );
          expect(
            const EqualTemperament.edo12().centsFromNote(Note.a.inOctave(5)),
            closeTo(1200, 0.01),
          );
          expect(
            const EqualTemperament.edo12().centsFromNote(Note.a.inOctave(6)),
            closeTo(2400, 0.01),
          );
        },
      );
    });

    group('.generatorCents', () {
      test(
        'should return the number of cents for the generator at Interval.P5 in '
        'this EqualTemperament',
        () {
          expect(const EqualTemperament.edo12().generatorCents, 700);
          expect(
            const EqualTemperament.edo19().generatorCents,
            closeTo(694.74, 0.01),
          );
        },
      );
    });
  });
}
