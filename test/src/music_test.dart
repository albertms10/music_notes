import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Music', () {
    group('chromaticScale', () {
      test('should return the correct chromatic scale notes', () {
        expect(
          chromaticScale,
          const [
            EnharmonicNote.c,
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
          ],
        );
      });
    });

    group('circleOfFifths', () {
      test('should return the correct circle of fifths notes', () {
        expect(circleOfFifths, [
          EnharmonicNote.f,
          EnharmonicNote.c,
          EnharmonicNote.g,
          EnharmonicNote.d,
          EnharmonicNote.a,
          EnharmonicNote.e,
          EnharmonicNote.b,
          EnharmonicNote.fSharp,
          EnharmonicNote.cSharp,
          EnharmonicNote.gSharp,
          EnharmonicNote.dSharp,
          EnharmonicNote.aSharp,
        ]);
      });
    });
  });
}
