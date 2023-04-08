import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Music', () {
    group('chromaticScale', () {
      test('should return the correct chromatic scale notes', () {
        expect(
          chromaticScale,
          equals(const [
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
          ]),
        );
      });
    });
  });
}
