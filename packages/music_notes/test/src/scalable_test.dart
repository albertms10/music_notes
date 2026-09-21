import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scalable', () {
    group('.toClass()', () {
      test('creates a new PitchClass from semitones', () {
        expect(Note.c.inOctave(4).toClass(), PitchClass.c);
        expect(Note.d.sharp.inOctave(3).toClass(), PitchClass.dSharp);
        expect(Note.e.flat.inOctave(-1).toClass(), PitchClass.dSharp);
        expect(Note.e.sharp.inOctave(6).toClass(), PitchClass.f);
        expect(Note.c.flat.flat.inOctave(5).toClass(), PitchClass.aSharp);
      });
    });
  });

  group('ScalableIterable', () {
    group('.intervalSteps', () {
      test('returns the Interval steps of this ScalableIterable', () {
        expect(<Note>[.c, .d, .e, .f.sharp].intervalSteps, const <Interval>[
          .M2,
          .M2,
          .M2,
        ]);

        expect(<Note>[.b, .a, .g, .f].intervalSteps, const <Interval>[
          .m7,
          .m7,
          .m7,
        ]);
      });
    });

    group('.descendingIntervalSteps', () {
      test('returns the descending Interval steps of this '
          'ScalableIterable', () {
        expect(
          <Note>[.b, .a, .g, .f].descendingIntervalSteps,
          const <Interval>[.M2, .M2, .M2],
        );

        expect(
          <Note>[.c, .d, .e, .f.sharp].descendingIntervalSteps,
          const <Interval>[.m7, .m7, .m7],
        );
      });
    });

    group('.closestSteps', () {
      test('returns the closest Interval steps of this ScalableIterable', () {
        expect(<Note>[.c, .d, .e, .f.sharp].closestSteps, const <Interval>[
          .M2,
          .M2,
          .M2,
        ]);

        expect(<Note>[.b, .a, .g, .f].closestSteps, const <Interval>[
          .M2,
          .M2,
          .M2,
        ]);
      });
    });

    group('.isStepwise', () {
      test('returns whether this Iterable is entirely in stepwise motion', () {
        expect(<Note>[.c, .d, .e, .f.sharp].isStepwise, isTrue);
        expect(<Note>[.g, .a, .g, .f.sharp, .e.flat].isStepwise, isTrue);
        expect(
          [
            Note.c.inOctave(4),
            Note.d.inOctave(4),
            Note.c.inOctave(4),
            Note.b.flat.inOctave(3),
          ].isStepwise,
          isTrue,
        );

        expect(
          [
            Note.c.inOctave(4),
            Note.d.inOctave(4),
            Note.c.inOctave(4),
            Note.b.flat.inOctave(2),
          ].isStepwise,
          isFalse,
        );
        expect(const <Note>[.c, .e, .g, .a].isStepwise, isFalse);
      });
    });

    group('.inversion', () {
      test('returns the inversion of this ScalableIterable', () {
        expect(const <PitchClass>{}.inversion.toList(), const <PitchClass>[]);
        expect({PitchClass.cSharp}.inversion.toList(), const [
          PitchClass.cSharp,
        ]);
        expect(<Note>{.d, .f.sharp, .e, .g}.inversion.toList(), <Note>[
          .d, .b.flat, .c, .a, //
        ]);
        expect(
          {
            Note.c.inOctave(4),
            Note.d.sharp.inOctave(4),
            Note.b.inOctave(3),
            Note.g.inOctave(3),
          }.inversion.toList(),
          [
            Note.c.inOctave(4),
            Note.b.flat.flat.inOctave(3),
            Note.d.flat.inOctave(4),
            Note.f.inOctave(4),
          ],
        );
        expect(
          <PitchClass>{.c, .dSharp, .b, .g}.inversion.toList(),
          <PitchClass>[.c, .a, .cSharp, .f],
        );
      });
    });

    group('.retrograde', () {
      test('returns the retrograde of this ScalableIterable', () {
        expect(const <PitchClass>{}.retrograde.toList(), const <PitchClass>[]);
        expect({PitchClass.fSharp}.retrograde.toList(), const [
          PitchClass.fSharp,
        ]);
        expect(<Note>{.c, .d.sharp, .d, .g}.retrograde.toList(), <Note>[
          .g, .d, .d.sharp, .c, //
        ]);
        expect(
          {
            Note.c.inOctave(4),
            Note.d.sharp.inOctave(4),
            Note.b.inOctave(3),
            Note.g.inOctave(3),
          }.retrograde.toList(),
          [
            Note.g.inOctave(3),
            Note.b.inOctave(3),
            Note.d.sharp.inOctave(4),
            Note.c.inOctave(4),
          ],
        );
        expect(
          <PitchClass>{.c, .dSharp, .d, .g}.retrograde.toList(),
          const <PitchClass>[.g, .d, .dSharp, .c],
        );
      });
    });

    group('.numericRepresentation()', () {
      test('returns the numeric representation of this ScalableIterable', () {
        expect(
          const <PitchClass>{}.numericRepresentation().toList(),
          const <int>[],
        );
        expect({PitchClass.g}.numericRepresentation().toList(), const [0]);
        expect(
          <PitchClass>{
            .b, .aSharp, .g, .d, //
          }.numericRepresentation(reference: .g).toList(),
          const [4, 3, 0, 7],
        );
        expect(
          <PitchClass>{
            .b, .aSharp, .d, .dSharp, .g, .fSharp, //
            .gSharp, .e, .f, .c, .cSharp, .a,
          }.numericRepresentation().toList(),
          const [0, 11, 3, 4, 8, 7, 9, 5, 6, 1, 2, 10],
        );
      });
    });

    group('.deltaNumericRepresentation', () {
      test('returns the delta numeric representation of this '
          'ScalableIterable', () {
        expect(
          const <PitchClass>{}.deltaNumericRepresentation.toList(),
          const <int>[],
        );
        expect({PitchClass.g}.deltaNumericRepresentation.toList(), const [0]);
        expect(
          <PitchClass>{.g, .a}.deltaNumericRepresentation.toList(),
          const [0, 2],
        );
        expect(
          <Note>{
            .b, .b.flat, .d, .d.sharp, .g, .f.sharp, .a.flat, //
            .f.flat, .f, .b.sharp, .d.flat, .b.flat.flat,
          }.deltaNumericRepresentation.toList(),
          const [0, -1, 4, 1, 4, -1, 2, -4, 1, -5, 1, -4],
        );
        expect(
          <PitchClass>{
            .b, .aSharp, .d, .dSharp, .g, .fSharp, //
            .gSharp, .e, .f, .c, .cSharp, .a,
          }.deltaNumericRepresentation.toList(),
          const [0, -1, 4, 1, 4, -1, 2, -4, 1, -5, 1, -4],
        );
      });
    });

    group('.intervalVector', () {
      test('returns a vector of zeros for an empty collection', () {
        expect(const <PitchClass>{}.intervalVector, const [
          0, 0, 0, 0, 0, 0, //
        ]);
      });

      test('returns a vector of zeros for a single element', () {
        expect({PitchClass.d}.intervalVector, const [0, 0, 0, 0, 0, 0]);
      });

      test('ignores unison pairs between identical elements', () {
        expect(<PitchClass>[.c, .c, .c].intervalVector, const [
          0, 0, 0, 0, 0, 0, //
        ]);
      });

      test('returns the interval-class vector of a diatonic scale', () {
        expect(
          ScalePattern.major.on(PitchClass.c).degrees.toSet().intervalVector,
          const [2, 5, 4, 3, 6, 1],
        );
        expect(
          ScalePattern.naturalMinor
              .on(PitchClass.a)
              .degrees
              .toSet()
              .intervalVector,
          const [2, 5, 4, 3, 6, 1],
        );
      });

      test(
        'returns the interval-class vector of a symmetric octatonic scale',
        () {
          expect(
            ScalePattern.octatonic
                .on(PitchClass.c)
                .degrees
                .toSet()
                .intervalVector,
            const [4, 4, 8, 4, 4, 4],
          );
        },
      );

      test('returns the interval-class vector of a whole-tone scale', () {
        expect(
          ScalePattern.wholeTone
              .on(PitchClass.c)
              .degrees
              .toSet()
              .intervalVector,
          const [0, 6, 0, 6, 0, 3],
        );
      });

      test('folds intervals greater than a tritone into their inversion', () {
        // A major-seventh dyad (11 semitones) is interval class 1 (m2),
        // not 11.
        expect(<Note>[.c, .b].intervalVector, const [1, 0, 0, 0, 0, 0]);
        // A minor-seventh dyad (10 semitones) is interval class 2 (M2).
        expect(<Note>[.c, .b.flat].intervalVector, const [0, 1, 0, 0, 0, 0]);
      });

      test('is order-independent (unordered pairs)', () {
        expect(
          <PitchClass>{.c, .e, .g}.intervalVector,
          <PitchClass>{.g, .c, .e}.intervalVector,
        );
      });
    });
  });
}
