import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scale', () {
    group('.pattern', () {
      test('should return the ScalePattern of this Scale', () {
        expect(ScalePattern.aeolian.on(Note.c).pattern, ScalePattern.aeolian);
        expect(
          ScalePattern.harmonicMinor.on(Note.f.sharp).pattern,
          ScalePattern.harmonicMinor,
        );
        expect(
          ScalePattern.melodicMinor.on(Note.a.flat).pattern,
          ScalePattern.melodicMinor,
        );
      });
    });

    group('.reversed', () {
      test('should return this Scale reversed', () {
        expect(
          Note.a.major.scale.reversed,
          Scale([
            Note.a,
            Note.g.sharp,
            Note.f.sharp,
            Note.e,
            Note.d,
            Note.c.sharp,
            Note.b,
            Note.a,
          ]),
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

    group('.degrees', () {
      test('should return the Chord for each ScaleDegree of this Scale', () {
        expect(ScalePattern.major.on(Note.c.sharp).degrees, [
          Note.c.sharp.majorTriad,
          Note.d.sharp.minorTriad,
          Note.e.sharp.minorTriad,
          Note.f.sharp.majorTriad,
          Note.g.sharp.majorTriad,
          Note.a.sharp.minorTriad,
          Note.b.sharp.diminishedTriad,
        ]);
        expect(ScalePattern.harmonicMinor.on(Note.f).degrees, [
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
      test('should return the Chord for the ScaleDegree of this Scale', () {
        expect(
          ScalePattern.major.on(Note.c).degree(ScaleDegree.ii),
          Note.d.minorTriad,
        );
        expect(
          ScalePattern.naturalMinor.on(Note.d).degree(ScaleDegree.vii),
          Note.c.majorTriad,
        );
        expect(
          ScalePattern.harmonicMinor.on(Note.f.sharp).degree(ScaleDegree.iii),
          Note.a.augmentedTriad,
        );
        expect(
          ScalePattern.melodicMinor.on(Note.a.flat).degree(ScaleDegree.vi),
          Note.f.diminishedTriad,
        );
      });
    });

    group('.transposeBy()', () {
      test('should return this Scale transposed by Interval', () {
        expect(
          ScalePattern.major.on(Note.c).transposeBy(Interval.majorThird),
          ScalePattern.major.on(Note.e),
        );
        expect(
          ScalePattern.naturalMinor
              .on(Note.d.flat)
              .transposeBy(-Interval.minorThird),
          ScalePattern.naturalMinor.on(Note.b.flat),
        );
        expect(
          ScalePattern.melodicMinor
              .on(Note.g.sharp)
              .transposeBy(Interval.perfectFifth),
          ScalePattern.melodicMinor.on(Note.d.sharp),
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Scale', () {
        expect(
          ScalePattern.major.on(Note.b.flat).toString(),
          'B♭ Major (ionian) (B♭ C D E♭ F G A B♭)',
        );
        expect(
          ScalePattern.naturalMinor.on(Note.c.sharp).toString(),
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
          ScalePattern.minorPentatonic.on(EnharmonicNote.f).toString(),
          '6 {E♯, F, G𝄫} Minor pentatonic (6 {E♯, F, G𝄫} 9 {G♯, A♭} '
          '11 {A♯, B♭} 1 {C, D𝄫, B♯} 4 {D♯, E♭} 6 {E♯, F, G𝄫})',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Scale instances in a Set', () {
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
