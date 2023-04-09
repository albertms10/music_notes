import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Modes', () {
    group('.opposite', () {
      test('should return the correct opposite mode', () {
        expect(Modes.major.opposite, Modes.minor);
        expect(Modes.minor.opposite, Modes.major);
      });
    });
  });
}
