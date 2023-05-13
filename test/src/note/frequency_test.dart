import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Frequency', () {
    group('.isHumanAudible', () {
      test('should return whether the frequency is audible by humans', () {
        expect(const Frequency(0).isHumanAudible, isFalse);
        expect(const Frequency(100).isHumanAudible, isTrue);
        expect(const Frequency(400).isHumanAudible, isTrue);
        expect(const Frequency(15000).isHumanAudible, isTrue);
        expect(const Frequency(100000).isHumanAudible, isFalse);
      });
    });
  });
}
