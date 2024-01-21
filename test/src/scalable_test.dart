import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScalableIterable', () {
    group('.inverse', () {
      test('returns the inverse of this ScalableIterable', () {
        expect(const <PitchClass>{}.inverse.toList(), const <PitchClass>[]);
        expect({PitchClass.cSharp}.inverse.toList(), const [PitchClass.cSharp]);
        expect(
          {Note.d, Note.f.sharp, Note.e, Note.g}.inverse.toList(),
          [Note.d, Note.b.flat, Note.c, Note.a],
        );
        expect(
          {
            Note.c.inOctave(4),
            Note.d.sharp.inOctave(4),
            Note.b.inOctave(3),
            Note.g.inOctave(3),
          }.inverse.toList(),
          [
            Note.c.inOctave(4),
            Note.b.flat.flat.inOctave(3),
            Note.d.flat.inOctave(4),
            Note.f.inOctave(4),
          ],
        );
        expect(
          {PitchClass.c, PitchClass.dSharp, PitchClass.b, PitchClass.g}
              .inverse
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

    group('.numericRepresentation', () {
      test('returns the numeric representation of this ScalableIterable', () {
        expect(<PitchClass>{}.numericRepresentation.toList(), const <int>[]);
        expect({PitchClass.g}.numericRepresentation.toList(), const [0]);
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
          }.numericRepresentation.toList(),
          const [0, 11, 3, 4, 8, 7, 9, 5, 6, 1, 2, 10],
        );
      });
    });

    group('.deltaNumericRepresentation', () {
      test(
        'returns the delta numeric representation of this ScalableIterable',
        () {
          expect(
            <PitchClass>{}.deltaNumericRepresentation.toList(),
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
