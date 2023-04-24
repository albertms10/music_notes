import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scale', () {
    group('.fromNote()', () {
      test('should return the major scale notes starting from Note', () {
        expect(
          Scale.major.fromNote(Note.aFlat),
          const [
            Note.aFlat,
            Note.bFlat,
            Note.c,
            Note.dFlat,
            Note.eFlat,
            Note.f,
            Note.g,
          ],
        );
        expect(
          Scale.major.fromNote(Note.f),
          const [Note.f, Note.g, Note.a, Note.bFlat, Note.c, Note.d, Note.e],
        );
        expect(
          Scale.major.fromNote(Note.c),
          const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b],
        );
        expect(
          Scale.major.fromNote(Note.d),
          const [
            Note.d,
            Note.e,
            Note.fSharp,
            Note.g,
            Note.a,
            Note.b,
            Note.cSharp,
          ],
        );
      });

      test(
        'should return the natural minor scale notes starting from Note',
        () {
          expect(
            Scale.naturalMinor.fromNote(Note.dSharp),
            const [
              Note.dSharp,
              Note(Notes.e, Accidental.sharp),
              Note.fSharp,
              Note.gSharp,
              Note.aSharp,
              Note.b,
              Note.cSharp,
            ],
          );
          expect(
            Scale.naturalMinor.fromNote(Note.d),
            const [Note.d, Note.e, Note.f, Note.g, Note.a, Note.bFlat, Note.c],
          );
        },
      );

      test(
        'should return the harmonic minor scale notes starting from Note',
        () {
          expect(
            Scale.harmonicMinor.fromNote(Note.bFlat),
            const [
              Note.bFlat,
              Note.c,
              Note.dFlat,
              Note.eFlat,
              Note.f,
              Note.gFlat,
              Note.a,
            ],
          );
          expect(
            Scale.harmonicMinor.fromNote(Note.d),
            const [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.bFlat,
              Note.cSharp,
            ],
          );
        },
      );

      test(
        'should return the melodic minor scale notes starting from Note',
        () {
          expect(
            Scale.melodicMinor.fromNote(Note.d),
            const [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b,
              Note.cSharp,
            ],
          );
          expect(
            Scale.melodicMinor.fromNote(Note.gSharp),
            const [
              Note.gSharp,
              Note.aSharp,
              Note.b,
              Note.cSharp,
              Note.dSharp,
              Note(Notes.e, Accidental.sharp),
              Note(Notes.f, Accidental.doubleSharp),
            ],
          );
        },
      );

      test('should return the tones scale notes starting from Note', () {
        expect(
          Scale.tones.fromNote(Note.c),
          const [Note.c, Note.d, Note.e, Note.fSharp, Note.gSharp, Note.aSharp],
        );
        expect(
          Scale.tones.fromNote(Note.dFlat),
          const [Note.dFlat, Note.eFlat, Note.f, Note.g, Note.a, Note.b],
        );
        expect(
          Scale.tones.fromNote(Note.cSharp),
          const [
            Note.cSharp,
            Note.dSharp,
            Note(Notes.e, Accidental.sharp),
            Note(Notes.f, Accidental.doubleSharp),
            Note(Notes.g, Accidental.doubleSharp),
            Note(Notes.a, Accidental.doubleSharp),
          ],
        );
      });

      test('should return the chromatic scale notes starting from Note', () {
        expect(
          Scale.chromatic.fromNote(Note.c),
          const [
            Note.c,
            Note.cSharp,
            Note.d,
            Note.dSharp,
            Note.e,
            Note.f,
            Note.fSharp,
            Note.g,
            Note.gSharp,
            Note.a,
            Note.aSharp,
            Note.b,
          ],
        );
        expect(
          Scale.chromatic.fromNote(Note.dFlat),
          const [
            Note.dFlat,
            Note.d,
            Note.eFlat,
            Note.e,
            Note.f,
            Note.gFlat,
            Note.g,
            Note.aFlat,
            Note.a,
            Note.bFlat,
            Note.b,
            Note.c,
          ],
        );
      });
    });
  });
}
