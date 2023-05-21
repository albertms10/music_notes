import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScalePattern', () {
    group('.from()', () {
      test('should return the major scale notes starting from Note', () {
        expect(
          ScalePattern.major.from(Note.a.flat),
          Scale([
            Note.a.flat,
            Note.b.flat,
            Note.c,
            Note.d.flat,
            Note.e.flat,
            Note.f,
            Note.g,
            Note.a.flat,
          ]),
        );
        expect(
          ScalePattern.major.from(Note.f.inOctave(4)),
          Scale([
            Note.f.inOctave(4),
            Note.g.inOctave(4),
            Note.a.inOctave(4),
            Note.b.flat.inOctave(4),
            Note.c.inOctave(5),
            Note.d.inOctave(5),
            Note.e.inOctave(5),
            Note.f.inOctave(5),
          ]),
        );
        expect(
          ScalePattern.major.from(Note.c),
          const Scale([
            Note.c,
            Note.d,
            Note.e,
            Note.f,
            Note.g,
            Note.a,
            Note.b,
            Note.c,
          ]),
        );
        expect(
          ScalePattern.major.from(Note.d.inOctave(2)),
          Scale([
            Note.d.inOctave(2),
            Note.e.inOctave(2),
            Note.f.sharp.inOctave(2),
            Note.g.inOctave(2),
            Note.a.inOctave(2),
            Note.b.inOctave(2),
            Note.c.sharp.inOctave(3),
            Note.d.inOctave(3),
          ]),
        );
      });

      test(
        'should return the natural minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.naturalMinor.from(Note.d.sharp.inOctave(5)),
            Scale([
              Note.d.sharp.inOctave(5),
              Note.e.sharp.inOctave(5),
              Note.f.sharp.inOctave(5),
              Note.g.sharp.inOctave(5),
              Note.a.sharp.inOctave(5),
              Note.b.inOctave(5),
              Note.c.sharp.inOctave(6),
              Note.d.sharp.inOctave(6),
            ]),
          );
          expect(
            ScalePattern.naturalMinor.from(Note.d),
            Scale([
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b.flat,
              Note.c,
              Note.d,
            ]),
          );
        },
      );

      test(
        'should return the harmonic minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.harmonicMinor.from(Note.b.flat.inOctave(4)),
            Scale([
              Note.b.flat.inOctave(4),
              Note.c.inOctave(5),
              Note.d.flat.inOctave(5),
              Note.e.flat.inOctave(5),
              Note.f.inOctave(5),
              Note.g.flat.inOctave(5),
              Note.a.inOctave(5),
              Note.b.flat.inOctave(5),
            ]),
          );
          expect(
            ScalePattern.harmonicMinor.from(Note.d),
            Scale([
              Note.d,
              Note.e,
              Note.f,
              Note.g,
              Note.a,
              Note.b.flat,
              Note.c.sharp,
              Note.d,
            ]),
          );
        },
      );

      test(
        'should return the melodic minor scale notes starting from Note',
        () {
          expect(
            ScalePattern.melodicMinor.from(Note.d),
            Scale(
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
              [
                Note.d,
                Note.c,
                Note.b.flat,
                Note.a,
                Note.g,
                Note.f,
                Note.e,
                Note.d,
              ],
            ),
          );
          expect(
            ScalePattern.melodicMinor.from(Note.g.sharp.inOctave(1)),
            Scale(
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
              [
                Note.g.sharp.inOctave(2),
                Note.f.sharp.inOctave(2),
                Note.e.inOctave(2),
                Note.d.sharp.inOctave(2),
                Note.c.sharp.inOctave(2),
                Note.b.inOctave(1),
                Note.a.sharp.inOctave(1),
                Note.g.sharp.inOctave(1),
              ],
            ),
          );
        },
      );

      test('should return the whole-tone scale notes starting from Note', () {
        expect(
          ScalePattern.wholeTone.from(EnharmonicNote.c),
          const Scale([
            EnharmonicNote.c,
            EnharmonicNote.d,
            EnharmonicNote.e,
            EnharmonicNote.fSharp,
            EnharmonicNote.gSharp,
            EnharmonicNote.aSharp,
            EnharmonicNote.c,
          ]),
        );
        expect(
          ScalePattern.wholeTone.from(Note.d.flat),
          Scale([
            Note.d.flat,
            Note.e.flat,
            Note.f,
            Note.g,
            Note.a,
            Note.b,
            Note.d.flat,
          ]),
        );
        expect(
          ScalePattern.wholeTone.from(Note.c.sharp),
          Scale([
            Note.c.sharp,
            Note.d.sharp,
            Note.e.sharp,
            Note.f.sharp.sharp,
            Note.g.sharp.sharp,
            Note.a.sharp.sharp,
            Note.c.sharp,
          ]),
        );
      });

      test('should return the chromatic scale notes starting from Note', () {
        expect(
          ScalePattern.chromatic.from(Note.c),
          Scale([
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
          ]),
        );
        expect(
          ScalePattern.chromatic.from(EnharmonicNote.cSharp),
          const Scale([
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
          ]),
        );
        expect(
          ScalePattern.chromatic.from(Note.d.flat),
          Scale([
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
          ]),
        );
      });

      test(
        'should return the major pentatonic scale notes starting from Note',
        () {
          expect(
            ScalePattern.majorPentatonic.from(Note.c),
            const Scale([Note.c, Note.d, Note.e, Note.g, Note.a, Note.c]),
          );
          expect(
            ScalePattern.majorPentatonic.from(Note.f.sharp),
            Scale([
              Note.f.sharp,
              Note.g.sharp,
              Note.a.sharp,
              Note.c.sharp,
              Note.d.sharp,
              Note.f.sharp,
            ]),
          );
          expect(
            ScalePattern.majorPentatonic.from(EnharmonicNote.fSharp),
            const Scale([
              EnharmonicNote.fSharp,
              EnharmonicNote.gSharp,
              EnharmonicNote.aSharp,
              EnharmonicNote.cSharp,
              EnharmonicNote.dSharp,
              EnharmonicNote.fSharp,
            ]),
          );
        },
      );

      test(
        'should return the minor pentatonic scale notes starting from Note',
        () {
          expect(
            ScalePattern.minorPentatonic.from(Note.a),
            const Scale([Note.a, Note.c, Note.d, Note.e, Note.g, Note.a]),
          );
          expect(
            ScalePattern.minorPentatonic.from(Note.g),
            Scale([Note.g, Note.b.flat, Note.c, Note.d, Note.f, Note.g]),
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

        expect(
          ScalePattern.melodicMinor.mirrored,
          const ScalePattern(
            [
              Interval.majorSecond,
              Interval.majorSecond,
              Interval.minorSecond,
              Interval.majorSecond,
              Interval.majorSecond,
              Interval.minorSecond,
              Interval.majorSecond,
            ],
            [
              Interval.majorSecond,
              Interval.minorSecond,
              Interval.majorSecond,
              Interval.majorSecond,
              Interval.majorSecond,
              Interval.majorSecond,
              Interval.minorSecond,
            ],
          ),
        );
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
          'Melodic minor (M2 m2 M2 M2 M2 M2 m2, M2 M2 m2 M2 M2 m2 M2)',
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
          // Melodic minor scale (ascending only)
          const ScalePattern([
            Interval.majorSecond,
            Interval.minorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.minorSecond,
          ]),
          ScalePattern.melodicMinor,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          ScalePattern.major,
          ScalePattern.aeolian,
          ScalePattern.mixolydian,
          ScalePattern.wholeTone,
          // Melodic minor scale (ascending only)
          ScalePattern([
            Interval.majorSecond,
            Interval.minorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.majorSecond,
            Interval.minorSecond,
          ]),
          ScalePattern.melodicMinor,
        ]);
      });
    });
  });
}
