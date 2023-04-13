import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Enharmonic', () {
    group('.toString()', () {
      test('should return a string representation of this Enharmonic', () {
        expect(EnharmonicNote.c.toString(), '1 {C, D𝄫, B♯}');
        expect(EnharmonicNote.g.toString(), '8 {F𝄪, G, A𝄫}');
        expect(EnharmonicNote.dSharp.toString(), '4 {D♯, E♭}');

        expect(EnharmonicInterval.perfectUnison.toString(), '1 {P1, d2}');
        expect(EnharmonicInterval.majorThird.toString(), '5 {M3, d4}');
        expect(EnharmonicInterval.minorSixth.toString(), '9 {A5, m6, dd7}');
      });
    });
  });
}
