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
          Scale.major.fromNote(Note.f.inOctave(4)),
          [
            Note.f.inOctave(4),
            Note.g.inOctave(4),
            Note.a.inOctave(4),
            Note.bFlat.inOctave(4),
            Note.c.inOctave(5),
            Note.d.inOctave(5),
            Note.e.inOctave(5),
            Note.f.inOctave(5),
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
          Scale.major.fromNote(Note.d.inOctave(2)),
          [
            Note.d.inOctave(2),
            Note.e.inOctave(2),
            Note.fSharp.inOctave(2),
            Note.g.inOctave(2),
            Note.a.inOctave(2),
            Note.b.inOctave(2),
            Note.cSharp.inOctave(3),
            Note.d.inOctave(3),
          ],
        );
      });

      test(
        'should return the natural minor scale notes starting from Note',
        () {
          expect(
            Scale.naturalMinor.fromNote(Note.dSharp.inOctave(5)),
            [
              Note.dSharp.inOctave(5),
              const Note(Notes.e, Accidental.sharp).inOctave(5),
              Note.fSharp.inOctave(5),
              Note.gSharp.inOctave(5),
              Note.aSharp.inOctave(5),
              Note.b.inOctave(5),
              Note.cSharp.inOctave(6),
              Note.dSharp.inOctave(6),
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
            Scale.harmonicMinor.fromNote(Note.bFlat.inOctave(4)),
            [
              Note.bFlat.inOctave(4),
              Note.c.inOctave(5),
              Note.dFlat.inOctave(5),
              Note.eFlat.inOctave(5),
              Note.f.inOctave(5),
              Note.gFlat.inOctave(5),
              Note.a.inOctave(5),
              Note.bFlat.inOctave(5),
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
            Scale.melodicMinor.fromNote(Note.gSharp.inOctave(1)),
            [
              Note.gSharp.inOctave(1),
              Note.aSharp.inOctave(1),
              Note.b.inOctave(1),
              Note.cSharp.inOctave(2),
              Note.dSharp.inOctave(2),
              const Note(Notes.e, Accidental.sharp).inOctave(2),
              const Note(Notes.f, Accidental.doubleSharp).inOctave(2),
              Note.gSharp.inOctave(2),
            ],
          );
        },
      );

      test('should return the whole-tone scale notes starting from Note', () {
        expect(
          Scale.wholeTone.fromNote(EnharmonicNote.c),
          const [
            EnharmonicNote.c,
            EnharmonicNote.d,
            EnharmonicNote.e,
            EnharmonicNote.fSharp,
            EnharmonicNote.gSharp,
            EnharmonicNote.aSharp,
            EnharmonicNote.c,
          ],
        );
        expect(
          Scale.wholeTone.fromNote(Note.dFlat),
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
          Scale.wholeTone.fromNote(Note.cSharp),
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
          Scale.chromatic.fromNote(EnharmonicNote.cSharp),
          const [
            EnharmonicNote.cSharp,
            EnharmonicNote.d,
            EnharmonicNote.dSharp,
            EnharmonicNote.e,
            EnharmonicNote.f,
            EnharmonicNote.fSharp,
            EnharmonicNote.g,
            EnharmonicNote.gSharp,
            EnharmonicNote.a,
            EnharmonicNote.aSharp,
            EnharmonicNote.b,
            EnharmonicNote.c,
            EnharmonicNote.cSharp,
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

      test(
        'should return the major pentatonic scale notes starting from Note',
        () {
          expect(
            Scale.majorPentatonic.fromNote(Note.c),
            const [Note.c, Note.d, Note.e, Note.g, Note.a, Note.c],
          );
          expect(
            Scale.majorPentatonic.fromNote(Note.fSharp),
            const [
              Note.fSharp,
              Note.gSharp,
              Note.aSharp,
              Note.cSharp,
              Note.dSharp,
              Note.fSharp,
            ],
          );
          expect(
            Scale.majorPentatonic.fromNote(EnharmonicNote.fSharp),
            const [
              EnharmonicNote.fSharp,
              EnharmonicNote.gSharp,
              EnharmonicNote.aSharp,
              EnharmonicNote.cSharp,
              EnharmonicNote.dSharp,
              EnharmonicNote.fSharp,
            ],
          );
        },
      );

      test(
        'should return the minor pentatonic scale notes starting from Note',
        () {
          expect(
            Scale.minorPentatonic.fromNote(Note.a),
            const [Note.a, Note.c, Note.d, Note.e, Note.g, Note.a],
          );
          expect(
            Scale.minorPentatonic.fromNote(Note.g),
            const [Note.g, Note.bFlat, Note.c, Note.d, Note.f, Note.g],
          );
        },
      );
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
        expect(Scale.wholeTone.name, 'Whole-tone');
        expect(Scale.majorPentatonic.name, 'Major pentatonic');
        expect(Scale.minorPentatonic.name, 'Minor pentatonic');
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
        expect(Scale.wholeTone.toString(), 'Whole-tone (M2 M2 M2 M2 M2 d3)');
        expect(
          Scale.octatonic.toString(),
          'Octatonic (M2 m2 M2 m2 M2 m2 M2 m2)',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Scale instances in a Set', () {
        final collection = {
          Scale.major,
          Scale.aeolian,
          // ignore: equal_elements_in_set
          Scale.naturalMinor,
          // ignore: equal_elements_in_set
          Scale.ionian,
          Scale.mixolydian,
          Scale.wholeTone,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          Scale.major,
          Scale.aeolian,
          Scale.mixolydian,
          Scale.wholeTone,
        ]);
      });
    });
  });
}
