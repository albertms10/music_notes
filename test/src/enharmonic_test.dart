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
          '1 {perfect (+0) unison, diminished (-2) second}',
        );
        expect(
          const EnharmonicInterval(5).toString(),
          '5 {major (+1) third, diminished (-1) fourth}',
        );
        expect(const EnharmonicInterval(9).toString(), '9 {minor (-1) sixth}');
      });
    });
  });
}
