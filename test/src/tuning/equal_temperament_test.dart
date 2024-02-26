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

    group('.edo', () {
      test('returns the EDO for this EqualTemperament', () {
        expect(const EqualTemperament.edo12().edo, 12);
        expect(const EqualTemperament.edo19().edo, 19);
      });
    });

    group('.ratioFromSemitones()', () {
      test('returns the Ratio from semitones for this EqualTemperament', () {
        expect(
          const EqualTemperament.edo12().ratioFromSemitones(1),
          const Ratio(1.0594630943592953),
        );
        expect(
          const EqualTemperament.edo12().ratioFromSemitones(12),
          const Ratio(2),
        );

        expect(
          const EqualTemperament.edo19().ratioFromSemitones(1),
          const Ratio(1.0371550444461919),
        );
        expect(
          const EqualTemperament.edo19().ratioFromSemitones(19),
          const Ratio(2),
        );
      });
    });

    group('.ratio()', () {
      test('returns the Ratio from a Pitch in this EqualTemperament', () {
        const edo12 = EqualTemperament.edo12();
        expect(
          edo12.ratio(Note.g.inOctave(4)),
          const Ratio(0.8908987181403393),
        );
        expect(edo12.ratio(Note.a.inOctave(4)), const Ratio(1));
        expect(
          edo12.ratio(Note.b.flat.inOctave(4)),
          const Ratio(1.0594630943592953),
        );
        expect(edo12.ratio(Note.a.inOctave(5)), const Ratio(2));
        expect(edo12.ratio(Note.a.inOctave(6)), const Ratio(4));
      });
    });

    group('.generator', () {
      test(
        'returns the number of cents for the generator at Interval.P5 in '
        'this EqualTemperament',
        () {
          expect(const EqualTemperament.edo12().generator, const Cent(700));
          expect(
            const EqualTemperament.edo19().generator,
            const Cent(694.7368421052632),
          );
        },
      );
    });

    group('operator ==()', () {
      test('compares this EqualTemperament to other', () {
        // ignore: prefer_const_constructors
        expect(EqualTemperament.edo12(), EqualTemperament.edo12());
        expect(
          const EqualTemperament.edo12(),
          isNot(const EqualTemperament.edo19()),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this EqualTemperament', () {
        expect(
          const EqualTemperament.edo12().toString(),
          'EDO 12 (A:2 B:1 C:2 D:2 E:1 F:2 G:2)',
        );
        expect(
          const EqualTemperament.edo19().toString(),
          'EDO 19 (A:3 B:2 C:3 D:3 E:2 F:3 G:3)',
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal EqualTemperaments', () {
        expect(
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(steps: {BaseNote.c: 1, BaseNote.d: 2}).hashCode,
          // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
          EqualTemperament(steps: {BaseNote.c: 1, BaseNote.d: 2}).hashCode,
        );
      });

      test('returns different hashCodes for different EqualTemperaments', () {
        expect(
          const EqualTemperament.edo12().hashCode,
          isNot(const EqualTemperament.edo19().hashCode),
        );
        expect(
          const EqualTemperament(steps: {BaseNote.c: 1, BaseNote.d: 2})
              .hashCode,
          isNot(
            const EqualTemperament(steps: {BaseNote.c: 2, BaseNote.d: 1})
                .hashCode,
          ),
        );
      });
    });
  });
}
