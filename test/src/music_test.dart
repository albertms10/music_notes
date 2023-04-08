import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Chromatic scale is correct', () {
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
}
