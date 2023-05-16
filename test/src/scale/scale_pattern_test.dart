import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScalePattern', () {
    group('.fromNote()', () {
      test('should return the major scale notes starting from Note', () {
        expect(
          ScalePattern.major.fromNote(Note.a.flat),
          [
            Note.a.flat,
            Note.b.flat,
            Note.c,
            Note.d.flat,
            Note.e.flat,
            Note.f,
            Note.g,
            Note.a.flat,
          ],
        );
        expect(
          ScalePattern.major.fromNote(Note.f.inOctave(4)),
          [
            Note.f.inOctave(4),
            Note.g.inOctave(4),
            Note.a.inOctave(4),
            Note.b.flat.inOctave(4),
            Note.c.inOctave(5),
            Note.d.inOctave(5),
            Note.e.inOctave(5),
            Note.f.inOctave(5),
          ],
        );
        expect(
          ScalePattern.major.fromNote(Note.c),
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
          ScalePattern.major.fromNote(Note.d.inOctave(2)),
          [
            Note.d.inOctave(2),
            Note.e.inOctave(2),
            Note.f.sharp.inOctave(2),
            Note.g.inOctave(2),
            Note.a.inOctave(2),
            Note.b.inOctave(2),
            Note.c.sharp.inOctave(3),
            Note.d.inOctave(3),
          ],
        );
        expect(
          ScalePattern.major.fromNote(Note.c.sharp, isDescending: true),
          [
            Note.c.sharp,
            Note.b.sharp,
            Note.a.sharp,
            Note.g.sharp,
            Note.f.sharp,
            Note.e.sharp,
            Note.d.sharp,
            Note.c.sharp,
          ],
        );
      });

      test(
        'should return the natural minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.naturalMinor.fromNote(Note.d.sharp.inOctave(5)),
            [
              Note.d.sharp.inOctave(5),
              Note.e.sharp.inOctave(5),
              Note.f.sharp.inOctave(5),
              Note.g.sharp.inOctave(5),
              Note.a.sharp.inOctave(5),
              Note.b.inOctave(5),
              Note.c.sharp.inOctave(6),
              Note.d.sharp.inOctave(6),
            ],
          );
          expect(
            ScalePattern.naturalMinor.fromNote(Note.d),
            [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b.flat,
              Note.c,
              Note.d,
            ],
          );
          expect(
            ScalePattern.naturalMinor.fromNote(Note.a.flat, isDescending: true),
            [
              Note.a.flat,
              Note.g.flat,
              Note.f.flat,
              Note.e.flat,
              Note.d.flat,
              Note.c.flat,
              Note.b.flat,
              Note.a.flat,
            ],
          );
        },
      );

      test(
        'should return the harmonic minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.harmonicMinor.fromNote(Note.b.flat.inOctave(4)),
            [
              Note.b.flat.inOctave(4),
              Note.c.inOctave(5),
              Note.d.flat.inOctave(5),
              Note.e.flat.inOctave(5),
              Note.f.inOctave(5),
              Note.g.flat.inOctave(5),
              Note.a.inOctave(5),
              Note.b.flat.inOctave(5),
            ],
          );
          expect(
            ScalePattern.harmonicMinor.fromNote(Note.d),
            [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b.flat,
              Note.c.sharp,
              Note.d,
            ],
          );
          expect(
            ScalePattern.harmonicMinor
                .fromNote(Note.e.inOctave(3), isDescending: true),
            [
              Note.e.inOctave(3),
              Note.d.sharp.inOctave(3),
              Note.c.inOctave(3),
              Note.b.inOctave(2),
              Note.a.inOctave(2),
              Note.g.inOctave(2),
              Note.f.sharp.inOctave(2),
              Note.e.inOctave(2),
            ],
          );
        },
      );

      test(
        'should return the melodic minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.melodicMinor.fromNote(Note.d),
            [
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b,
              Note.c.sharp,
              Note.d,
            ],
          );
          expect(
            ScalePattern.melodicMinor.fromNote(Note.g.sharp.inOctave(1)),
            [
              Note.g.sharp.inOctave(1),
              Note.a.sharp.inOctave(1),
              Note.b.inOctave(1),
              Note.c.sharp.inOctave(2),
              Note.d.sharp.inOctave(2),
              Note.e.sharp.inOctave(2),
              Note.f.sharp.sharp.inOctave(2),
              Note.g.sharp.inOctave(2),
            ],
          );
          expect(
            ScalePattern.melodicMinor.fromNote(Note.f, isDescending: true),
            ScalePattern.naturalMinor.fromNote(Note.f).reversed,
          );
        },
      );

      test('should return the whole-tone scale notes starting from Note', () {
        expect(
          ScalePattern.wholeTone.fromNote(EnharmonicNote.c),
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
          ScalePattern.wholeTone.fromNote(Note.d.flat),
          [
            Note.d.flat,
            Note.e.flat,
            Note.f,
            Note.g,
            Note.a,
            Note.b,
            Note.d.flat,
          ],
        );
        expect(
          ScalePattern.wholeTone.fromNote(Note.c.sharp),
          [
            Note.c.sharp,
            Note.d.sharp,
            Note.e.sharp,
            Note.f.sharp.sharp,
            Note.g.sharp.sharp,
            Note.a.sharp.sharp,
            Note.c.sharp,
          ],
        );
      });

      test('should return the chromatic scale notes starting from Note', () {
        expect(
          ScalePattern.chromatic.fromNote(Note.c),
          [
            Note.c,
            Note.c.sharp,
            Note.d,
            Note.d.sharp,
            Note.e,
            Note.f,
            Note.f.sharp,
            Note.g,
            Note.g.sharp,
            Note.a,
            Note.a.sharp,
            Note.b,
            Note.c,
          ],
        );
        expect(
          ScalePattern.chromatic.fromNote(EnharmonicNote.cSharp),
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
          ScalePattern.chromatic.fromNote(Note.d.flat),
          [
            Note.d.flat,
            Note.d,
            Note.e.flat,
            Note.e,
            Note.f,
            Note.g.flat,
            Note.g,
            Note.a.flat,
            Note.a,
            Note.b.flat,
            Note.b,
            Note.c,
            Note.d.flat,
          ],
        );
      });

      test(
        'should return the major pentatonic scale notes starting from Note',
        () {
          expect(
            ScalePattern.majorPentatonic.fromNote(Note.c),
            const [Note.c, Note.d, Note.e, Note.g, Note.a, Note.c],
          );
          expect(
            ScalePattern.majorPentatonic.fromNote(Note.f.sharp),
            [
              Note.f.sharp,
              Note.g.sharp,
              Note.a.sharp,
              Note.c.sharp,
              Note.d.sharp,
              Note.f.sharp,
            ],
          );
          expect(
            ScalePattern.majorPentatonic.fromNote(EnharmonicNote.fSharp),
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
            ScalePattern.minorPentatonic.fromNote(Note.a),
            const [Note.a, Note.c, Note.d, Note.e, Note.g, Note.a],
          );
          expect(
            ScalePattern.minorPentatonic.fromNote(Note.g),
            [Note.g, Note.b.flat, Note.c, Note.d, Note.f, Note.g],
          );
        },
      );
    });

    group('.mirrored', () {
      test('should return the mirrored version of this ScalePattern', () {
        expect(ScalePattern.lydian.mirrored, ScalePattern.locrian);
        expect(ScalePattern.ionian.mirrored, ScalePattern.phrygian);
        expect(ScalePattern.mixolydian.mirrored, ScalePattern.aeolian);
        expect(ScalePattern.dorian.mirrored, ScalePattern.dorian);
        expect(ScalePattern.aeolian.mirrored, ScalePattern.mixolydian);
        expect(ScalePattern.phrygian.mirrored, ScalePattern.ionian);
        expect(ScalePattern.locrian.mirrored, ScalePattern.lydian);
      });
    });

    group('.name', () {
      test('should return the name of this ScalePattern', () {
        expect(ScalePattern.ionian.name, 'Major (ionian)');
        expect(ScalePattern.dorian.name, 'Dorian');
        expect(ScalePattern.phrygian.name, 'Phrygian');
        expect(ScalePattern.lydian.name, 'Lydian');
        expect(ScalePattern.mixolydian.name, 'Mixolydian');
        expect(ScalePattern.aeolian.name, 'Natural minor (aeolian)');
        expect(ScalePattern.locrian.name, 'Locrian');
        expect(ScalePattern.major.name, 'Major (ionian)');
        expect(ScalePattern.naturalMinor.name, 'Natural minor (aeolian)');
        expect(ScalePattern.harmonicMinor.name, 'Harmonic minor');
        expect(ScalePattern.melodicMinor.name, 'Melodic minor');
        expect(ScalePattern.chromatic.name, 'Chromatic');
        expect(ScalePattern.wholeTone.name, 'Whole-tone');
        expect(ScalePattern.majorPentatonic.name, 'Major pentatonic');
        expect(ScalePattern.minorPentatonic.name, 'Minor pentatonic');
        expect(ScalePattern.octatonic.name, 'Octatonic');
      });
    });

    group('.toString()', () {
      test('should return the string representation of this ScalePattern', () {
        expect(
          ScalePattern.ionian.toString(),
          'Major (ionian) (M2 M2 m2 M2 M2 M2 m2)',
        );
        expect(
          ScalePattern.major.toString(),
          'Major (ionian) (M2 M2 m2 M2 M2 M2 m2)',
        );
        expect(
          ScalePattern.aeolian.toString(),
          'Natural minor (aeolian) (M2 m2 M2 M2 m2 M2 M2)',
        );
        expect(
          ScalePattern.naturalMinor.toString(),
          'Natural minor (aeolian) (M2 m2 M2 M2 m2 M2 M2)',
        );
        expect(
          ScalePattern.melodicMinor.toString(),
          'Melodic minor (M2 m2 M2 M2 M2 M2 m2)',
        );
        expect(
          ScalePattern.wholeTone.toString(),
          'Whole-tone (M2 M2 M2 M2 M2 d3)',
        );
        expect(
          ScalePattern.octatonic.toString(),
          'Octatonic (M2 m2 M2 m2 M2 m2 M2 m2)',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal ScalePattern instances in a Set', () {
        final collection = {
          ScalePattern.major,
          ScalePattern.aeolian,
          // ignore: equal_elements_in_set
          ScalePattern.naturalMinor,
          // ignore: equal_elements_in_set
          ScalePattern.ionian,
          ScalePattern.mixolydian,
          ScalePattern.wholeTone,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          ScalePattern.major,
          ScalePattern.aeolian,
          ScalePattern.mixolydian,
          ScalePattern.wholeTone,
        ]);
      });
    });
  });
}