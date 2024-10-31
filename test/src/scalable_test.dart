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
    group('.isStepwise', () {
      test('returns whether this Iterable is entirely in stepwise motion', () {
        expect([Note.c, Note.d, Note.e, Note.f.sharp].isStepwise, isTrue);
        expect(
          skip: 'Should descending Note intervals be accounted '
              'as, e.g., Interval.M2 instead of Interval.m7?',
          () => [Note.g, Note.a, Note.g, Note.f.sharp, Note.e.flat].isStepwise,
          isTrue,
        );
        expect(
          skip: 'Descending Pitch intervals are still unsupported.',
          () => [
            Note.c.inOctave(4),
            Note.d.inOctave(4),
            Note.c.inOctave(4),
            Note.b.flat.inOctave(3),
          ].isStepwise,
          isTrue,
        );

        expect(const [Note.c, Note.e, Note.g, Note.a].isStepwise, isFalse);
      });
    });

    group('.inversion', () {
      test('returns the inversion of this ScalableIterable', () {
        expect(const <PitchClass>{}.inversion.toList(), const <PitchClass>[]);
        expect(
          {PitchClass.cSharp}.inversion.toList(),
          const [PitchClass.cSharp],
        );
        expect(
          {Note.d, Note.f.sharp, Note.e, Note.g}.inversion.toList(),
          [Note.d, Note.b.flat, Note.c, Note.a],
        );
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
          {PitchClass.c, PitchClass.dSharp, PitchClass.b, PitchClass.g}
              .inversion
              .toList(),
          [PitchClass.c, PitchClass.a, PitchClass.cSharp, PitchClass.f],
        );
      });
    });

    group('.retrograde', () {
      test('returns the retrograde of this ScalableIterable', () {
        expect(const <PitchClass>{}.retrograde.toList(), const <PitchClass>[]);
        expect(
          {PitchClass.fSharp}.retrograde.toList(),
          const [PitchClass.fSharp],
        );
        expect(
          {Note.c, Note.d.sharp, Note.d, Note.g}.retrograde.toList(),
          [Note.g, Note.d, Note.d.sharp, Note.c],
        );
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
          {PitchClass.c, PitchClass.dSharp, PitchClass.d, PitchClass.g}
              .retrograde
              .toList(),
          const [PitchClass.g, PitchClass.d, PitchClass.dSharp, PitchClass.c],
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
          {PitchClass.b, PitchClass.aSharp, PitchClass.g, PitchClass.d}
              .numericRepresentation(reference: PitchClass.g)
              .toList(),
          const [4, 3, 0, 7],
        );
        expect(
          {
            PitchClass.b,
            PitchClass.aSharp,
            PitchClass.d,
            PitchClass.dSharp,
            PitchClass.g,
            PitchClass.fSharp,
            PitchClass.gSharp,
            PitchClass.e,
            PitchClass.f,
            PitchClass.c,
            PitchClass.cSharp,
            PitchClass.a,
          }.numericRepresentation().toList(),
          const [0, 11, 3, 4, 8, 7, 9, 5, 6, 1, 2, 10],
        );
      });
    });

    group('.deltaNumericRepresentation', () {
      test(
        'returns the delta numeric representation of this ScalableIterable',
        () {
          expect(
            const <PitchClass>{}.deltaNumericRepresentation.toList(),
            const <int>[],
          );
          expect({PitchClass.g}.deltaNumericRepresentation.toList(), const [0]);
          expect(
            {PitchClass.g, PitchClass.a}.deltaNumericRepresentation.toList(),
            const [0, 2],
          );
          expect(
            {
              Note.b,
              Note.b.flat,
              Note.d,
              Note.d.sharp,
              Note.g,
              Note.f.sharp,
              Note.a.flat,
              Note.f.flat,
              Note.f,
              Note.b.sharp,
              Note.d.flat,
              Note.b.flat.flat,
            }.deltaNumericRepresentation.toList(),
            const [0, -1, 4, 1, 4, -1, 2, -4, 1, -5, 1, -4],
          );
          expect(
            {
              PitchClass.b,
              PitchClass.aSharp,
              PitchClass.d,
              PitchClass.dSharp,
              PitchClass.g,
              PitchClass.fSharp,
              PitchClass.gSharp,
              PitchClass.e,
              PitchClass.f,
              PitchClass.c,
              PitchClass.cSharp,
              PitchClass.a,
            }.deltaNumericRepresentation.toList(),
            const [0, -1, 4, 1, 4, -1, 2, -4, 1, -5, 1, -4],
          );
        },
      );
    });
  });
}
