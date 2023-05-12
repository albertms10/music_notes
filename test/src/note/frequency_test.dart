import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('.isHumanAudible', () {
    test('should return whether the frequency is audible by humans', () {
      expect(Frequency(0).isHumanAudible, isFalse);
      expect(Frequency(100).isHumanAudible, isTrue);
      expect(Frequency(400).isHumanAudible, isTrue);
      expect(Frequency(15000).isHumanAudible, isTrue);
      expect(Frequency(100000).isHumanAudible, isFalse);
    });
  });
}
