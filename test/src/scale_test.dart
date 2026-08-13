import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scale', () {
    group('.degrees', () {
      test('returns an unmodifiable collection', () {
        expect(
          ScalePattern.aeolian.on(Note.c).degrees,
          isA<UnmodifiableListView<Note>>(),
        );
        expect(
          ScalePattern.melodicMinor.on(Note.c).descendingDegrees,
          isA<UnmodifiableListView<Note>>(),
        );
      });
    });

    group('.length', () {
      test('returns the length of this Scale', () {
        expect(ScalePattern.minorPentatonic.on(Note.f).length, 5);
        expect(ScalePattern.major.on(Note.e).length, 7);
        expect(ScalePattern.octatonic.on(Note.d.flat).length, 8);
        expect(ScalePattern.chromatic.on(Note.c).length, 12);
      });
    });

    group('.pattern', () {
      test('returns the ScalePattern of this Scale', () {
        expect(ScalePattern.aeolian.on(Note.c).pattern, ScalePattern.aeolian);
        expect(
          ScalePattern.harmonicMinor.on(Note.f.sharp).pattern,
          ScalePattern.harmonicMinor,
        );
        expect(
          ScalePattern.melodicMinor.on(Note.a.flat).pattern,
          ScalePattern.melodicMinor,
        );
        expect(ScalePattern.major.on(PitchClass.d).pattern, ScalePattern.major);
        expect(
          ScalePattern.minorPentatonic.on(PitchClass.gSharp).pattern,
          ScalePattern.minorPentatonic,
        );
      });
    });

    group('.reversed', () {
      test('returns this Scale reversed', () {
        expect(
          Note.a.major.scale.reversed,
          Scale<Note>([.a, .g.sharp, .f.sharp, .e, .d, .c.sharp, .b, .a]),
        );
        expect(
          ScalePattern.naturalMinor.on(Note.g.inOctave(5)).reversed,
          Scale([
            Note.g.inOctave(6),
            Note.f.inOctave(6),
            Note.e.flat.inOctave(6),
            Note.d.inOctave(6),
            Note.c.inOctave(6),
            Note.b.flat.inOctave(5),
            Note.a.inOctave(5),
            Note.g.inOctave(5),
          ]),
        );
      });
    });

    group('.degreeChords', () {
      test('returns the Chord for each ScaleDegree of this Scale', () {
        expect(Note.c.sharp.major.scale.degreeChords, [
          Note.c.sharp.majorTriad,
          Note.d.sharp.minorTriad,
          Note.e.sharp.minorTriad,
          Note.f.sharp.majorTriad,
          Note.g.sharp.majorTriad,
          Note.a.sharp.minorTriad,
          Note.b.sharp.diminishedTriad,
        ]);
        expect(ScalePattern.harmonicMinor.on(Note.f).degreeChords, [
          Note.f.minorTriad,
          Note.g.diminishedTriad,
          Note.a.flat.augmentedTriad,
          Note.b.flat.minorTriad,
          Note.c.majorTriad,
          Note.d.flat.majorTriad,
          Note.e.diminishedTriad,
        ]);
      });
    });

    group('.degree()', () {
      test('returns the Scalable for the ScaleDegree of this Scale', () {
        expect(Note.c.major.scale.degree(.ii), Note.d);
        expect(Note.d.minor.scale.degree(.vii), Note.c);
        expect(
          ScalePattern.harmonicMinor.on(Note.f.sharp).degree(.iii),
          Note.a,
        );
        expect(ScalePattern.melodicMinor.on(Note.a.flat).degree(.vi), Note.f);

        expect(Note.c.major.scale.degree(.neapolitanSixth), Note.d.flat);
      });
    });

    group('.degreeChord()', () {
      test('returns the Chord for the ScaleDegree of this Scale', () {
        expect(Note.c.major.scale.degreeChord(.ii), Note.d.minorTriad);
        expect(Note.d.minor.scale.degreeChord(.vii), Note.c.majorTriad);
        expect(
          ScalePattern.harmonicMinor.on(Note.f.sharp).degreeChord(.iii),
          Note.a.augmentedTriad,
        );
        expect(
          ScalePattern.melodicMinor.on(Note.a.flat).degreeChord(.vi),
          Note.f.diminishedTriad,
        );

        expect(
          Note.c.major.scale.degreeChord(.neapolitanSixth),
          // TODO(albertms10): take the inversion into account.
          Note.d.flat.majorTriad,
        );
      });
    });

    group('.functionChord()', () {
      test('returns the Chord for the HarmonicFunction of this Scale', () {
        expect(Note.c.major.scale.functionChord(.i), Note.c.majorTriad);
        expect(
          Note.d.major.scale.functionChord(.vii),
          Note.c.sharp.diminishedTriad,
        );

        expect(
          Note.g.major.scale.functionChord(
            HarmonicFunction.dominantV / .dominantV,
          ),
          Note.a.majorTriad,
        );
        expect(
          Note.f.major.scale.functionChord(HarmonicFunction.iv / .vi),
          Note.g.minorTriad,
        );
        expect(
          Note.b.flat.major.scale.functionChord(HarmonicFunction.vi / .iv),
          Note.c.minorTriad,
        );
        expect(
          Note.c.sharp.minor.scale.functionChord(
            HarmonicFunction.ii / .dominantV,
          ),
          Note.a.sharp.minorTriad,
        );

        expect(
          Note.d.flat.major.scale.functionChord(
            HarmonicFunction.ii / .vi / .dominantV,
          ),
          Note.g.diminishedTriad,
        );
        expect(
          Note.b.major.scale.functionChord(HarmonicFunction.iv / .iv / .iv),
          Note.d.majorTriad,
        );
        expect(
          Note.a.major.scale.functionChord(
            HarmonicFunction.dominantV / .dominantV / .dominantV,
          ),
          Note.f.sharp.majorTriad,
        );
        expect(
          Note.e.flat.major.scale.functionChord(
            HarmonicFunction.dominantV / .dominantV / .dominantV / .dominantV,
          ),
          Note.g.majorTriad,
        );
      });
    });

    group('.isEnharmonicWith()', () {
      test(
        'returns whether this Scale is enharmonically equivalent to other',
        () {
          expect(
            const Scale<Note>([
              .c,
              .d,
              .f,
              .g,
            ]).isEnharmonicWith(Scale<Note>([.b.sharp, .d, .e.sharp, .g])),
            isTrue,
          );
          expect(
            ScalePattern.chromatic
                .on(Note.d.flat)
                .isEnharmonicWith(
                  ScalePattern.chromatic.on(Note.b.sharp.sharp),
                ),
            isTrue,
          );
        },
      );
    });

    group('.transposeBy()', () {
      test('transposes this Scale by Interval', () {
        expect(Note.c.major.scale.transposeBy(.M3), Note.e.major.scale);
        expect(
          Note.d.flat.minor.scale.transposeBy(-Interval.m3),
          Note.b.flat.minor.scale,
        );
        expect(
          ScalePattern.melodicMinor.on(Note.g.sharp).transposeBy(.P5),
          ScalePattern.melodicMinor.on(Note.d.sharp),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Scale', () {
        expect(
          Note.b.flat.major.scale.toString(),
          'B♭ Major (ionian) (B♭ C D E♭ F G A B♭)',
        );
        expect(
          Note.c.sharp.minor.scale.toString(),
          'C♯ Natural minor (aeolian) (C♯ D♯ E F♯ G♯ A B C♯)',
        );
        expect(
          ScalePattern.melodicMinor.on(Note.c).toString(),
          'C Melodic minor (C D E♭ F G A B C, C B♭ A♭ G F E♭ D C)',
        );
        expect(
          ScalePattern.melodicMinor.on(Note.a.inOctave(4)).toString(),
          'A4 Melodic minor '
          '(A4 B4 C5 D5 E5 F♯5 G♯5 A5, A5 G5 F5 E5 D5 C5 B4 A4)',
        );
        expect(
          ScalePattern.majorPentatonic.on(Note.d.inOctave(3)).toString(),
          'D3 Major pentatonic (D3 E3 F♯3 A3 B3 D4)',
        );
        expect(
          ScalePattern.minorPentatonic.on(PitchClass.f).toString(),
          '{F} Minor pentatonic ({F} {G♯|A♭} {A♯|B♭} {C} {D♯|E♭} {F})',
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Scale instances in a Set', () {
        final collection = {
          Note.a.major.scale,
          Note.c.sharp.minor.scale,
          Note.d.flat.major.scale,
          Note.g.minor.scale,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.a.major.scale,
          Note.c.sharp.minor.scale,
          Note.d.flat.major.scale,
          Note.g.minor.scale,
        ]);
      });
    });
  });
}
