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
            Note.aFlat,
          ],
        );
        expect(
          Scale.major.fromNote(Note.f),
          const [
            Note.f,
            Note.g,
            Note.a,
            Note.bFlat,
            Note.c,
            Note.d,
            Note.e,
            Note.f,
          ],
        );
        expect(
          Scale.major.fromNote(Note.c),
          const [
            Note.c,
            Note.d,
            Note.e,
            Note.f,
            Note.g,
            Note.a,
            Note.b,
            Note.c,
          ],
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
            Note.d,
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
              Note.dSharp,
            ],
          );
          expect(
            Scale.naturalMinor.fromNote(Note.d),
            const [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.bFlat,
              Note.c,
              Note.d,
            ],
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
              Note.bFlat,
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
              Note.d,
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
              Note.d,
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
              Note.gSharp,
            ],
          );
        },
      );

      test('should return the tones scale notes starting from Note', () {
        expect(
          Scale.tones.fromNote(Note.c),
          const [
            Note.c,
            Note.d,
            Note.e,
            Note.fSharp,
            Note.gSharp,
            Note.aSharp,
            Note.c,
          ],
        );
        expect(
          Scale.tones.fromNote(Note.dFlat),
          const [
            Note.dFlat,
            Note.eFlat,
            Note.f,
            Note.g,
            Note.a,
            Note.b,
            Note.dFlat,
          ],
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
            Note.cSharp,
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
            Note.c,
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
            Note.dFlat,
          ],
        );
      });
    });

    group('.mirrored', () {
      test('should return the mirrored version of this Scale', () {
        expect(Scale.lydian.mirrored, Scale.locrian);
        expect(Scale.ionian.mirrored, Scale.phrygian);
        expect(Scale.mixolydian.mirrored, Scale.aeolian);
        expect(Scale.dorian.mirrored, Scale.dorian);
        expect(Scale.aeolian.mirrored, Scale.mixolydian);
        expect(Scale.phrygian.mirrored, Scale.ionian);
        expect(Scale.locrian.mirrored, Scale.lydian);
      });
    });

    group('.name', () {
      test('should return the name of this Scale', () {
        expect(Scale.ionian.name, 'Major (ionian)');
        expect(Scale.dorian.name, 'Dorian');
        expect(Scale.phrygian.name, 'Phrygian');
        expect(Scale.lydian.name, 'Lydian');
        expect(Scale.mixolydian.name, 'Mixolydian');
        expect(Scale.aeolian.name, 'Natural minor (aeolian)');
        expect(Scale.locrian.name, 'Locrian');
        expect(Scale.major.name, 'Major (ionian)');
        expect(Scale.naturalMinor.name, 'Natural minor (aeolian)');
        expect(Scale.harmonicMinor.name, 'Harmonic minor');
        expect(Scale.melodicMinor.name, 'Melodic minor');
        expect(Scale.chromatic.name, 'Chromatic');
        expect(Scale.tones.name, 'Tones');
        expect(Scale.pentatonic.name, 'Pentatonic');
        expect(Scale.octatonic.name, 'Octatonic');
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Scale', () {
        expect(
          Scale.ionian.toString(),
          'Major (ionian) (M2 M2 m2 M2 M2 M2 m2)',
        );
        expect(
          Scale.major.toString(),
          'Major (ionian) (M2 M2 m2 M2 M2 M2 m2)',
        );
        expect(
          Scale.aeolian.toString(),
          'Natural minor (aeolian) (M2 m2 M2 M2 m2 M2 M2)',
        );
        expect(
          Scale.naturalMinor.toString(),
          'Natural minor (aeolian) (M2 m2 M2 M2 m2 M2 M2)',
        );
        expect(
          Scale.melodicMinor.toString(),
          'Melodic minor (M2 m2 M2 M2 M2 M2 m2)',
        );
        expect(Scale.tones.toString(), 'Tones (M2 M2 M2 M2 M2 d3)');
        expect(
          Scale.octatonic.toString(),
          'Octatonic (M2 m2 M2 m2 M2 m2 M2 m2)',
        );
      });
    });
  });
}
