import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScalableIterable', () {
    group('.inverse', () {
      test('should return the inverse of this ScalableIterable', () {
        expect(const <PitchClass>{}.inverse.toList(), const <PitchClass>[]);
        expect({PitchClass.cSharp}.inverse.toList(), const [PitchClass.cSharp]);
        expect(
          {Note.d, Note.f.sharp, Note.e, Note.g}.inverse.toList(),
          [Note.d, Note.b.flat, Note.c, Note.a],
        );
        expect(
          {
            Note.a.inOctave(4),
            Note.g.sharp.inOctave(4),
            Note.b.inOctave(4),
            Note.c.inOctave(5),
            Note.g.inOctave(5),
          }.inverse.toList(),
          [
            Note.a.inOctave(4),
            Note.b.flat.inOctave(4),
            Note.g.inOctave(4),
            Note.f.sharp.inOctave(4),
            Note.b.inOctave(3),
          ],
        );
        expect(
          {PitchClass.c, PitchClass.dSharp, PitchClass.d, PitchClass.g}
              .inverse
              .toList(),
          const [PitchClass.c, PitchClass.a, PitchClass.aSharp, PitchClass.f],
        );
      });
    });

    group('.retrograde', () {
      test('should return the retrograde of this ScalableIterable', () {
        expect(const <PitchClass>{}.retrograde.toList(), const <PitchClass>[]);
        expect(
          {PitchClass.fSharp}.retrograde.toList(),
          const [PitchClass.fSharp],
        );
        expect(
          {PitchClass.c, PitchClass.dSharp, PitchClass.d, PitchClass.g}
              .retrograde
              .toList(),
          const [PitchClass.g, PitchClass.d, PitchClass.dSharp, PitchClass.c],
        );
      });
    });
  });
}
