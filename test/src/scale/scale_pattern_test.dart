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
          ScalePattern.fromChordPattern(.augmentedTriad),
          ScalePattern.lydianAugmented,
        );
        expect(ScalePattern.fromChordPattern(.majorTriad), ScalePattern.major);
        expect(
          ScalePattern.fromChordPattern(.minorTriad),
          ScalePattern.naturalMinor,
        );
        expect(
          ScalePattern.fromChordPattern(.diminishedTriad),
          ScalePattern.locrian,
        );
      });
    });

    group('.fromBinary()', () {
      test('creates a new ScalePattern from a binary sequence', () {
        expect(ScalePattern.fromBinary(1010_1011_0101.b), ScalePattern.major);
        expect(
          ScalePattern.fromBinary(0101_1010_1101.b),
          ScalePattern.naturalMinor,
        );
        expect(
          ScalePattern.fromBinary(1010_1010_1101.b, 0101_1010_1101.b),
          ScalePattern.melodicMinor,
        );
        expect(
          ScalePattern.fromBinary(1111_1111_1111.b),
          ScalePattern.chromatic,
        );
        expect(
          ScalePattern.fromBinary(0010_1001_0101.b),
          ScalePattern.majorPentatonic,
        );
      });
    });

    group('.toBinary()', () {
      test('returns the binary representation of this ScalePattern', () {
        expect(ScalePattern.major.toBinary(), (1010_1011_0101.b, null));
        expect(ScalePattern.naturalMinor.toBinary(), (0101_1010_1101.b, null));
        expect(ScalePattern.melodicMinor.toBinary(), (
          1010_1010_1101.b,
          0101_1010_1101.b,
        ));
        expect(ScalePattern.chromatic.toBinary(), (1111_1111_1111.b, null));
        expect(ScalePattern.majorPentatonic.toBinary(), (
          0010_1001_0101.b,
          null,
        ));
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
          Scale<Note>([
            .a.flat,
            .b.flat,
            .c,
            .d.flat,
            .e.flat,
            .f,
            .g,
            .a.flat,
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
          const Scale<Note>([.c, .d, .e, .f, .g, .a, .b, .c]),
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
          Scale<Note>([.d, .e, .f, .g, .a, .b.flat, .c, .d]),
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
          Scale<Note>([.d, .e, .f, .g, .a, .b.flat, .c.sharp, .d]),
        );
      });

      test('returns the melodic minor Scale on Note', () {
        expect(
          ScalePattern.melodicMinor.on(Note.d),
          Scale(
            <Note>[.d, .e, .f, .g, .a, .b, .c.sharp, .d],
            <Note>[.d, .c, .b.flat, .a, .g, .f, .e, .d],
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
          const Scale<PitchClass>([.c, .d, .e, .fSharp, .gSharp, .aSharp, .c]),
        );
        expect(
          ScalePattern.wholeTone.on(Note.d.flat),
          Scale<Note>([.d.flat, .e.flat, .f, .g, .a, .b, .d.flat]),
        );
        expect(
          ScalePattern.wholeTone.on(Note.c.sharp),
          Scale<Note>([
            .c.sharp,
            .d.sharp,
            .e.sharp,
            .f.sharp.sharp,
            .g.sharp.sharp,
            .a.sharp.sharp,
            .c.sharp,
          ]),
        );
      });

      test('returns the chromatic Scale on Note', () {
        expect(
          ScalePattern.chromatic.on(Note.c),
          Scale<Note>([
            .c,
            .c.sharp,
            .d,
            .d.sharp,
            .e,
            .f,
            .f.sharp,
            .g,
            .g.sharp,
            .a,
            .a.sharp,
            .b,
            .c,
          ]),
        );
        expect(
          ScalePattern.chromatic.on(PitchClass.cSharp),
          const Scale<PitchClass>([
            .cSharp,
            .d,
            .dSharp,
            .e,
            .f,
            .fSharp,
            .g,
            .gSharp,
            .a,
            .aSharp,
            .b,
            .c,
            .cSharp,
          ]),
        );
        expect(
          ScalePattern.chromatic.on(Note.d.flat),
          Scale<Note>([
            .d.flat,
            .d,
            .e.flat,
            .e,
            .f,
            .g.flat,
            .g,
            .a.flat,
            .a,
            .b.flat,
            .b,
            .c,
            .d.flat,
          ]),
        );
      });

      test('returns the major pentatonic Scale on Note', () {
        expect(
          ScalePattern.majorPentatonic.on(Note.c),
          const Scale<Note>([.c, .d, .e, .g, .a, .c]),
        );
        expect(
          ScalePattern.majorPentatonic.on(Note.f.sharp),
          Scale<Note>([
            .f.sharp,
            .g.sharp,
            .a.sharp,
            .c.sharp,
            .d.sharp,
            .f.sharp,
          ]),
        );
        expect(
          ScalePattern.majorPentatonic.on(PitchClass.fSharp),
          const Scale<PitchClass>([
            .fSharp,
            .gSharp,
            .aSharp,
            .cSharp,
            .dSharp,
            .fSharp,
          ]),
        );
      });

      test('returns the minor pentatonic Scale on Note', () {
        expect(
          ScalePattern.minorPentatonic.on(Note.a),
          const Scale<Note>([.a, .c, .d, .e, .g, .a]),
        );
        expect(
          ScalePattern.minorPentatonic.on(Note.g),
          Scale<Note>([.g, .b.flat, .c, .d, .f, .g]),
        );
      });

      test('returns the double harmonic major Scale on Note', () {
        expect(
          ScalePattern.doubleHarmonicMajor.on(Note.c),
          Scale<Note>([.c, .d.flat, .e, .f, .g, .a.flat, .b, .c]),
        );
        expect(
          ScalePattern.doubleHarmonicMajor.on(Note.f.sharp),
          Scale<Note>([
            .f.sharp,
            .g,
            .a.sharp,
            .b,
            .c.sharp,
            .d,
            .e.sharp,
            .f.sharp,
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
            [.M2, .M2, .m2, .M2, .M2, .m2, .M2],
            [.M2, .m2, .M2, .M2, .M2, .M2, .m2],
          ),
        );
      });
    });

    group('.degreePatterns', () {
      test(
        'returns the ChordPattern for each scale degree of this ScalePattern',
        () {
          expect(ScalePattern.major.degreePatterns, const <ChordPattern>[
            .majorTriad,
            .minorTriad,
            .minorTriad,
            .majorTriad,
            .majorTriad,
            .minorTriad,
            .diminishedTriad,
          ]);
          expect(ScalePattern.naturalMinor.degreePatterns, const <ChordPattern>[
            .minorTriad,
            .diminishedTriad,
            .majorTriad,
            .minorTriad,
            .minorTriad,
            .majorTriad,
            .majorTriad,
          ]);
          expect(
            ScalePattern.harmonicMinor.degreePatterns,
            const <ChordPattern>[
              .minorTriad,
              .diminishedTriad,
              .augmentedTriad,
              .minorTriad,
              .majorTriad,
              .majorTriad,
              .diminishedTriad,
            ],
          );
          expect(ScalePattern.melodicMinor.degreePatterns, const <ChordPattern>[
            .minorTriad,
            .minorTriad,
            .augmentedTriad,
            .majorTriad,
            .majorTriad,
            .diminishedTriad,
            .diminishedTriad,
          ]);
        },
      );
    });

    group('.degreePattern()', () {
      test(
        'returns the ChordPattern for the ScaleDegree of this ScalePattern',
        () {
          expect(ScalePattern.major.degreePattern(.i), ChordPattern.majorTriad);
          expect(
            ScalePattern.major.degreePattern(.neapolitanSixth),
            ChordPattern.majorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(.iv.minor),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(.vi),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.major.degreePattern(.vii),
            ChordPattern.diminishedTriad,
          );

          expect(
            ScalePattern.naturalMinor.degreePattern(.i),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(.ii),
            ChordPattern.diminishedTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(.v),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(.v.major),
            ChordPattern.majorTriad,
          );
          expect(
            ScalePattern.naturalMinor.degreePattern(.vii),
            ChordPattern.majorTriad,
          );

          expect(
            ScalePattern.harmonicMinor.degreePattern(.ii),
            ChordPattern.diminishedTriad,
          );
          expect(
            ScalePattern.harmonicMinor.degreePattern(.iii),
            ChordPattern.augmentedTriad,
          );
          expect(
            ScalePattern.harmonicMinor.degreePattern(.v),
            ChordPattern.majorTriad,
          );

          expect(
            ScalePattern.melodicMinor.degreePattern(.ii),
            ChordPattern.minorTriad,
          );
          expect(
            ScalePattern.melodicMinor.degreePattern(.iii),
            ChordPattern.augmentedTriad,
          );
          expect(
            ScalePattern.melodicMinor.degreePattern(.v),
            ChordPattern.majorTriad,
          );
        },
      );
    });

    group('.exclude()', () {
      test('returns a new ScalePattern excluding intervals', () {
        expect(ScalePattern.major.exclude({.m2}), ScalePattern.majorPentatonic);
      });
    });

    group('.isEnharmonicWith()', () {
      test('returns whether this ScalePattern is enharmonically equivalent to '
          'other', () {
        expect(
          const ScalePattern([
            .m2,
            .m3,
            .M2,
          ]).isEnharmonicWith(const ScalePattern([.m2, .A2, .d3])),
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
        expect(const ScalePattern([.A4]), const ScalePattern([.d5]));
      });
    });

    group('.hashCode', () {
      test('ignores equal ScalePattern instances in a Set', () {
        final collection = <ScalePattern>{
          const ScalePattern([.A4]),
          const ScalePattern([.d5]),
          .major,
          .aeolian,
          // ignore: equal_elements_in_set test
          .naturalMinor,
          // ignore: equal_elements_in_set test
          .ionian,
          .mixolydian,
          .wholeTone,
          // Melodic minor scale (ascending only)
          const ScalePattern([.M2, .m2, .M2, .M2, .M2, .M2, .m2]),
          .melodicMinor,
        };
        collection.addAll(collection);
        expect(collection.toList(), const <ScalePattern>[
          ScalePattern([.A4]),
          .major,
          .aeolian,
          .mixolydian,
          .wholeTone,
          // Melodic minor scale (ascending only)
          ScalePattern([.M2, .m2, .M2, .M2, .M2, .M2, .m2]),
          .melodicMinor,
        ]);
      });
    });
  });
}
