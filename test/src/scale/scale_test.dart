import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scale', () {
    group('.pattern', () {
      test('should return the ScalePattern of this Scale', () {
        expect(ScalePattern.aeolian.from(Note.c).pattern, ScalePattern.aeolian);
        expect(
          ScalePattern.harmonicMinor.from(Note.f.sharp).pattern,
          ScalePattern.harmonicMinor,
        );
        expect(
          ScalePattern.melodicMinor.from(Note.a.flat).pattern,
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
          ScalePattern.naturalMinor.from(Note.g.inOctave(5)).reversed,
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

    group('.transposeBy()', () {
      test('should return this Scale transposed by Interval', () {
        expect(
          ScalePattern.major.from(Note.c).transposeBy(Interval.majorThird),
          ScalePattern.major.from(Note.e),
        );
        expect(
          ScalePattern.naturalMinor
              .from(Note.d.flat)
              .transposeBy(-Interval.minorThird),
          ScalePattern.naturalMinor.from(Note.b.flat),
        );
        expect(
          ScalePattern.melodicMinor
              .from(Note.g.sharp)
              .transposeBy(Interval.perfectFifth),
          ScalePattern.melodicMinor.from(Note.d.sharp),
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Scale', () {
        expect(
          ScalePattern.major.from(Note.b.flat).toString(),
          'B♭ Major (ionian) (B♭ C D E♭ F G A B♭)',
        );
        expect(
          ScalePattern.naturalMinor.from(Note.c.sharp).toString(),
          'C♯ Natural minor (aeolian) (C♯ D♯ E F♯ G♯ A B C♯)',
        );
        expect(
          ScalePattern.melodicMinor.from(Note.c).toString(),
          'C Melodic minor (C D E♭ F G A B C, C B♭ A♭ G F E♭ D C)',
        );
        // TODO(albertms10): Failing test: descending scale start from octave 5.
        //  See 140.
        expect(
          ScalePattern.melodicMinor.from(Note.a.inOctave(4)).toString(),
          'A4 Melodic minor '
          '(A4 B4 C5 D5 E5 F♯5 G♯5 A5, A4 G4 F4 E4 D4 C4 B3 A3)',
        );
        expect(
          ScalePattern.majorPentatonic.from(Note.d.inOctave(3)).toString(),
          'D3 Major pentatonic (D3 E3 F♯3 A3 B3 D4)',
        );
        expect(
          ScalePattern.minorPentatonic.from(EnharmonicNote.f).toString(),
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
