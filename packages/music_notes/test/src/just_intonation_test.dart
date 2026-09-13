import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generator', () {
      test('returns the number of cents for the generator at Interval.P5 in '
          'this JustIntonation', () {
        const generator = Cent(701.9550008653874);
        expect(const PythagoreanTuning().generator, generator);
        expect(
          PythagoreanTuning(
            fork: Note.a.flat.inOctave(3).at(.reference),
          ).generator,
          generator,
        );
      });
    });
  });
}
