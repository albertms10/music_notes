import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Chord', () {
    group('.pattern', () {
      test('should return the ChordPattern for this Chord', () {
        expect(
          ChordPattern.majorTriad.from(Note.c).pattern,
          ChordPattern.majorTriad,
        );
        expect(
          const Chord([Note.a, Note.c, Note.e, Note.g]).pattern,
          ChordPattern.minorTriad.add7(),
        );
        expect(
          Chord([
            Note.a.flat.inOctave(4),
            Note.c.inOctave(5),
            Note.e.inOctave(5),
            Note.g.inOctave(5),
          ]).pattern,
          ChordPattern.augmentedTriad.add7(ImperfectQuality.major),
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Chord', () {
        expect(
          ChordPattern.majorTriad.from(Note.d).toString(),
          'D maj. (D F♯ A)',
        );
        expect(
          Chord([Note.g.sharp, Note.b, Note.d.sharp]).toString(),
          'G♯ min. (G♯ B D♯)',
        );
        expect(
          ChordPattern.augmentedTriad
              .add7()
              .from(Note.c.inOctave(3))
              .toString(),
          'C3 aug. (C3 E3 G♯3 B♭3)',
        );
      });
    });
  });
}
