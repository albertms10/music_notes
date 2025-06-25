import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScalePattern', () {
    group('.intervalSteps', () {
      test('returns an unmodifiable collection', () {
        expect(
          ScalePattern.aeolian.intervalSteps,
          isA<UnmodifiableListView<Interval>>(),
        );
        expect(
          ScalePattern.chromatic.descendingIntervalSteps,
          isA<UnmodifiableListView<Interval>>(),
        );
      });
    });

    group('.fromChordPattern()', () {
      test('creates a new ScalePattern from the given ChordPattern', () {
        expect(
          ScalePattern.fromChordPattern(ChordPattern.augmentedTriad),
          ScalePattern.lydianAugmented,
        );
        expect(
          ScalePattern.fromChordPattern(ChordPattern.majorTriad),
          ScalePattern.major,
        );
        expect(
          ScalePattern.fromChordPattern(ChordPattern.minorTriad),
          ScalePattern.naturalMinor,
        );
        expect(
          ScalePattern.fromChordPattern(ChordPattern.diminishedTriad),
          ScalePattern.locrian,
        );
      });
    });

    group('.fromBinary()', () {
      test('creates a new ScalePattern from a binary sequence', () {
        expect(ScalePattern.fromBinary(101010110101.b), ScalePattern.major);
        expect(
          ScalePattern.fromBinary(10110101101.b),
          ScalePattern.naturalMinor,
        );
        expect(
          ScalePattern.fromBinary(101010101101.b, 10110101101.b),
          ScalePattern.melodicMinor,
        );
        expect(ScalePattern.fromBinary(111111111111.b), ScalePattern.chromatic);
        expect(
          ScalePattern.fromBinary(1010010101.b),
          ScalePattern.majorPentatonic,
        );
      });
    });

    group('.toBinary()', () {
      test('returns the binary representation of this ScalePattern', () {
        expect(ScalePattern.major.toBinary(), (101010110101.b, null));
        expect(ScalePattern.naturalMinor.toBinary(), (10110101101.b, null));
        expect(ScalePattern.melodicMinor.toBinary(), (
          101010101101.b,
          10110101101.b,
        ));
        expect(ScalePattern.chromatic.toBinary(), (111111111111.b, null));
        expect(ScalePattern.majorPentatonic.toBinary(), (1010010101.b, null));
      });
    });

    group('.length', () {
      test('returns the length of this ScalePattern', () {
        expect(ScalePattern.minorPentatonic.length, 5);
        expect(ScalePattern.major.length, 7);
        expect(ScalePattern.octatonic.length, 8);
        expect(ScalePattern.chromatic.length, 12);
      });
    });

    group('.on()', () {
      test('returns the major Scale on Note', () {
        expect(
          ScalePattern.major.on(Note.a.flat),
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
          ScalePattern.major.on(Note.f.inOctave(4)),
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
          ScalePattern.major.on(Note.c),
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
          ScalePattern.major.on(Note.d.inOctave(2)),
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

      test('returns the natural minor Scale on Note', () {
        expect(
          ScalePattern.naturalMinor.on(Note.d.sharp.inOctave(5)),
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
          ScalePattern.naturalMinor.on(Note.d),
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
      });

      test('returns the harmonic minor Scale on Note', () {
        expect(
          ScalePattern.harmonicMinor.on(Note.b.flat.inOctave(4)),
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
          ScalePattern.harmonicMinor.on(Note.d),
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
      });

      test('returns the melodic minor Scale on Note', () {
        expect(
          ScalePattern.melodicMinor.on(Note.d),
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
          ScalePattern.melodicMinor.on(Note.g.sharp.inOctave(1)),
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
      });

      test('returns the whole-tone Scale on Note', () {
        expect(
          ScalePattern.wholeTone.on(PitchClass.c),
          const Scale([
            PitchClass.c,
            PitchClass.d,
            PitchClass.e,
            PitchClass.fSharp,
            PitchClass.gSharp,
            PitchClass.aSharp,
            PitchClass.c,
          ]),
        );
        expect(
          ScalePattern.wholeTone.on(Note.d.flat),
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
          ScalePattern.wholeTone.on(Note.c.sharp),
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

      test('returns the chromatic Scale on Note', () {
        expect(
          ScalePattern.chromatic.on(Note.c),
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
          ScalePattern.chromatic.on(PitchClass.cSharp),
          const Scale([
            PitchClass.cSharp,
            PitchClass.d,
            PitchClass.dSharp,
            PitchClass.e,
            PitchClass.f,
            PitchClass.fSharp,
            PitchClass.g,
            PitchClass.gSharp,
            PitchClass.a,
            PitchClass.aSharp,
            PitchClass.b,
            PitchClass.c,
            PitchClass.cSharp,
          ]),
        );
        expect(
          ScalePattern.chromatic.on(Note.d.flat),
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

      test('returns the major pentatonic Scale on Note', () {
        expect(
          ScalePattern.majorPentatonic.on(Note.c),
          const Scale([Note.c, Note.d, Note.e, Note.g, Note.a, Note.c]),
        );
        expect(
          ScalePattern.majorPentatonic.on(Note.f.sharp),
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
          ScalePattern.majorPentatonic.on(PitchClass.fSharp),
          const Scale([
            PitchClass.fSharp,
            PitchClass.gSharp,
            PitchClass.aSharp,
            PitchClass.cSharp,
            PitchClass.dSharp,
            PitchClass.fSharp,
          ]),
        );
      });

      test('returns the minor pentatonic Scale on Note', () {
        expect(
          ScalePattern.minorPentatonic.on(Note.a),
          const Scale([Note.a, Note.c, Note.d, Note.e, Note.g, Note.a]),
        );
        expect(
          ScalePattern.minorPentatonic.on(Note.g),
          Scale([Note.g, Note.b.flat, Note.c, Note.d, Note.f, Note.g]),
        );
      });

      test('returns the double harmonic major Scale on Note', () {
        expect(
          ScalePattern.doubleHarmonicMajor.on(Note.c),
          Scale([
            Note.c,
            Note.d.flat,
            Note.e,
            Note.f,
            Note.g,
            Note.a.flat,
            Note.b,
            Note.c,
          ]),
        );
        expect(
          ScalePattern.doubleHarmonicMajor.on(Note.f.sharp),
          Scale([
            Note.f.sharp,
            Note.g,
            Note.a.sharp,
            Note.b,
            Note.c.sharp,
            Note.d,
            Note.e.sharp,
            Note.f.sharp,
          ]),
        );
      });
    });

    group('.mirrored', () {
      test('returns the mirrored version of this ScalePattern', () {
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
              Interval.M2,
              Interval.M2,
              Interval.m2,
              Interval.M2,
              Interval.M2,
              Interval.m2,
              Interval.M2,
            ],
            [
              Interval.M2,
              Interval.m2,
              Interval.M2,
              Interval.M2,
              Interval.M2,
              Interval.M2,
              Interval.m2,
            ],
          ),
        );
      });
    });

    group('.degreePatterns', () {
      test(
        'returns the ChordPattern for each scale degree of this ScalePattern',
        () {
          expect(ScalePattern.major.degreePatterns, const [
            ChordPattern.majorTriad,
            ChordPattern.minorTriad,
            ChordPattern.minorTriad,
            ChordPattern.majorTriad,
            ChordPattern.majorTriad,
            ChordPattern.minorTriad,
            ChordPattern.diminishedTriad,
          ]);
          expect(ScalePattern.naturalMinor.degreePatterns, const [
            ChordPattern.minorTriad,
            ChordPattern.diminishedTriad,
            ChordPattern.majorTriad,
            ChordPattern.minorTriad,
            ChordPattern.minorTriad,
            ChordPattern.majorTriad,
            ChordPattern.majorTriad,
          ]);
          expect(ScalePattern.harmonicMinor.degreePatterns, const [
            ChordPattern.minorTriad,
            ChordPattern.diminishedTriad,
            ChordPattern.augmentedTriad,
            ChordPattern.minorTriad,
            ChordPattern.majorTriad,
            ChordPattern.majorTriad,
            ChordPattern.diminishedTriad,
          ]);
          expect(ScalePattern.melodicMinor.degreePatterns, const [
            ChordPattern.minorTriad,
            ChordPattern.minorTriad,
            ChordPattern.augmentedTriad,
            ChordPattern.majorTriad,
            ChordPattern.majorTriad,
            ChordPattern.diminishedTriad,
            ChordPattern.diminishedTriad,
          ]);
        },
      );
    });

    group('.degreePattern()', () {
      test(
        'returns the ChordPattern for the ScaleDegree of this ScalePattern',
        () {
          expect(
            ScalePattern.major.degreePattern(ScaleDegree.i),
            ChordPattern.majorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(ScaleDegree.neapolitanSixth),
            ChordPattern.majorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(ScaleDegree.iv.minor),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(ScaleDegree.vi),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(ScaleDegree.vii),
            ChordPattern.diminishedTriad,
          );

          expect(
            ScalePattern.naturalMinor.degreePattern(ScaleDegree.i),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(ScaleDegree.ii),
            ChordPattern.diminishedTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(ScaleDegree.v),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(ScaleDegree.v.major),
            ChordPattern.majorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(ScaleDegree.vii),
            ChordPattern.majorTriad,
          );

          expect(
            ScalePattern.harmonicMinor.degreePattern(ScaleDegree.ii),
            ChordPattern.diminishedTriad,
          );
          expect(
            ScalePattern.harmonicMinor.degreePattern(ScaleDegree.iii),
            ChordPattern.augmentedTriad,
          );
          expect(
            ScalePattern.harmonicMinor.degreePattern(ScaleDegree.v),
            ChordPattern.majorTriad,
          );

          expect(
            ScalePattern.melodicMinor.degreePattern(ScaleDegree.ii),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.melodicMinor.degreePattern(ScaleDegree.iii),
            ChordPattern.augmentedTriad,
          );
          expect(
            ScalePattern.melodicMinor.degreePattern(ScaleDegree.v),
            ChordPattern.majorTriad,
          );
        },
      );
    });

    group('.exclude()', () {
      test('returns a new ScalePattern excluding intervals', () {
        expect(
          ScalePattern.major.exclude({Interval.m2}),
          ScalePattern.majorPentatonic,
        );
      });
    });

    group('.isEnharmonicWith()', () {
      test('returns whether this ScalePattern is enharmonically equivalent to '
          'other', () {
        expect(
          const ScalePattern([
            Interval.m2,
            Interval.m3,
            Interval.M2,
          ]).isEnharmonicWith(
            const ScalePattern([Interval.m2, Interval.A2, Interval.d3]),
          ),
          isTrue,
        );
      });
    });

    group('.name', () {
      test('returns the name of this ScalePattern', () {
        expect(ScalePattern.ionian.name, 'Major (ionian)');
        expect(ScalePattern.dorian.name, 'Dorian');
        expect(ScalePattern.phrygian.name, 'Phrygian');
        expect(ScalePattern.lydian.name, 'Lydian');
        expect(ScalePattern.lydianAugmented.name, 'Lydian augmented');
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
        expect(ScalePattern.doubleHarmonicMajor.name, 'Double harmonic major');
      });
    });

    group('.toString()', () {
      test('returns the string representation of this ScalePattern', () {
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
        expect(
          ScalePattern.doubleHarmonicMajor.toString(),
          'Double harmonic major (m2 A2 m2 M2 m2 A2 m2)',
        );
      });
    });

    group('operator ==()', () {
      test('returns true when other is enharmonic', () {
        expect(
          const ScalePattern([Interval.A4]),
          const ScalePattern([Interval.d5]),
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal ScalePattern instances in a Set', () {
        final collection = {
          const ScalePattern([Interval.A4]),
          const ScalePattern([Interval.d5]),
          ScalePattern.major,
          ScalePattern.aeolian,
          // ignore: equal_elements_in_set test
          ScalePattern.naturalMinor,
          // ignore: equal_elements_in_set test
          ScalePattern.ionian,
          ScalePattern.mixolydian,
          ScalePattern.wholeTone,
          // Melodic minor scale (ascending only)
          const ScalePattern([
            Interval.M2,
            Interval.m2,
            Interval.M2,
            Interval.M2,
            Interval.M2,
            Interval.M2,
            Interval.m2,
          ]),
          ScalePattern.melodicMinor,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          ScalePattern([Interval.A4]),
          ScalePattern.major,
          ScalePattern.aeolian,
          ScalePattern.mixolydian,
          ScalePattern.wholeTone,
          // Melodic minor scale (ascending only)
          ScalePattern([
            Interval.M2,
            Interval.m2,
            Interval.M2,
            Interval.M2,
            Interval.M2,
            Interval.M2,
            Interval.m2,
          ]),
          ScalePattern.melodicMinor,
        ]);
      });
    });
  });
}
