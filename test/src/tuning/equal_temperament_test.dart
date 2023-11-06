import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EqualTemperament', () {
    group('constructor', () {
      test('should create a new EqualTemperament from octave divisions', () {
        expect(EqualTemperament.edo(12), const EqualTemperament.edo12());
        expect(EqualTemperament.edo(19), const EqualTemperament.edo19());
      });
    });

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

    group('.ratioFromSemitones()', () {
      test('should return the ratio from semitones for this EqualTemperament',
          () {
        expect(
          const EqualTemperament.edo12().ratioFromSemitones(),
          const Ratio(1.0594630943592953),
        );
        expect(
          const EqualTemperament.edo12().ratioFromSemitones(12),
          const Ratio(2),
        );

        expect(
          const EqualTemperament.edo19().ratioFromSemitones(),
          const Ratio(1.0371550444461919),
        );
        expect(
          const EqualTemperament.edo19().ratioFromSemitones(19),
          const Ratio(2),
        );
      });
    });

    group('.ratio()', () {
      test(
        'should return the ratio from a PositionedNote in this '
        'EqualTemperament',
        () {
          const edo12 = EqualTemperament.edo12();
          expect(
            edo12.ratio(Note.g.inOctave(4)).value,
            0.8908987181403393,
          );
          expect(edo12.ratio(Note.a.inOctave(4)).value, 1);
          expect(
            edo12.ratio(Note.b.flat.inOctave(4)).value,
            1.0594630943592953,
          );
          expect(edo12.ratio(Note.a.inOctave(5)).value, 2);
          expect(edo12.ratio(Note.a.inOctave(6)).value, 4);
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
            const EqualTemperament(
              divisions: {
                // different order
                BaseNote.a: 2,
                BaseNote.e: 1,
                BaseNote.c: 2,
                BaseNote.g: 2,
                BaseNote.b: 1,
                BaseNote.d: 2,
                BaseNote.f: 2,
              },
            ).generatorCents,
            const Cent(700),
          );
          expect(
            const EqualTemperament.edo19().generatorCents,
            const Cent(694.7368421052632),
          );
        },
      );
    });

    group('operator ==', () {
      test('should compare this EqualTemperament to other', () {
        // ignore: prefer_const_constructors
        expect(EqualTemperament.edo12(), EqualTemperament.edo12());
        expect(
          // ignore: prefer_const_constructors
          EqualTemperament.edo12(),
          // ignore: prefer_const_constructors
          EqualTemperament(
            // ignore: prefer_const_literals_to_create_immutables
            divisions: {
              // different order
              BaseNote.a: 2,
              BaseNote.e: 1,
              BaseNote.c: 2,
              BaseNote.g: 2,
              BaseNote.b: 1,
              BaseNote.d: 2,
              BaseNote.f: 2,
            },
          ),
        );
        expect(
          const EqualTemperament.edo12(),
          isNot(const EqualTemperament.edo19()),
        );
      });
    });

    group('.toString()', () {
      test(
        'should return the string representation of this EqualTemperament',
        () {
          expect(
            const EqualTemperament.edo12().toString(),
            'EDO 12 (2 2 1 2 2 2 1)',
          );
          expect(
            const EqualTemperament.edo19().toString(),
            'EDO 19 (3 3 2 3 3 3 2)',
          );
        },
      );
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal EqualTemperaments', () {
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(divisions: {BaseNote.c: 1, BaseNote.d: 2}).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(divisions: {BaseNote.c: 1, BaseNote.d: 2}).hashCode,
        );
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(divisions: {BaseNote.d: 2, BaseNote.c: 1}).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(divisions: {BaseNote.c: 1, BaseNote.d: 2}).hashCode,
        );
      });

      test(
        'should return different hashCodes for different EqualTemperaments',
        () {
          expect(
            const EqualTemperament.edo12().hashCode,
            isNot(const EqualTemperament.edo19().hashCode),
          );
          expect(
            const EqualTemperament(divisions: {BaseNote.c: 1}).hashCode,
            isNot(const EqualTemperament(divisions: {BaseNote.c: 2}).hashCode),
          );
        },
      );
    });
  });
}
