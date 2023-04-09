import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Tonality', () {
    group('.toString()', () {
      test('should return the string representation of this Tonality', () {
        expect(const Tonality(Note.c, Modes.major).toString(), 'C major');
        expect(const Tonality(Note.d, Modes.minor).toString(), 'D minor');
        expect(const Tonality(Note.aFlat, Modes.major).toString(), 'A♭ major');
        expect(const Tonality(Note.fSharp, Modes.minor).toString(), 'F♯ minor');
        expect(
          const Tonality(Note(Notes.g, Accidental.doubleSharp), Modes.major)
              .toString(),
          'G𝄪 major',
        );
        expect(
          const Tonality(Note(Notes.e, Accidental.doubleFlat), Modes.minor)
              .toString(),
          'E𝄫 minor',
        );
      });
    });
  });
}
