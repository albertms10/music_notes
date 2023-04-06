import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Chromatic scale is correct', () {
    expect(
      chromaticScale,
      equals(const [
        EnharmonicNote(1),
        EnharmonicNote(2),
        EnharmonicNote(3),
        EnharmonicNote(4),
        EnharmonicNote(5),
        EnharmonicNote(6),
        EnharmonicNote(7),
        EnharmonicNote(8),
        EnharmonicNote(9),
        EnharmonicNote(10),
        EnharmonicNote(11),
        EnharmonicNote(12),
      ]),
    );
  });
}
