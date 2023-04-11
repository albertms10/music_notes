import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Enharmonic', () {
    group('.toString()', () {
      test('should return a string representation of this Enharmonic', () {
        expect(EnharmonicNote.c.toString(), '1 {C, D𝄫, B♯}');
        expect(EnharmonicNote.g.toString(), '8 {F𝄪, G, A𝄫}');
        expect(EnharmonicNote.dSharp.toString(), '4 {D♯, E♭}');

        expect(
          const EnharmonicInterval(1).toString(),
          '1 {perfect unison, diminished second}',
        );
        expect(
          const EnharmonicInterval(5).toString(),
          '5 {major third, diminished fourth}',
        );
        expect(
          const EnharmonicInterval(9).toString(),
          '9 {augmented fifth, minor sixth, doubleDiminished seventh}',
        );
      });
    });
  });
}
