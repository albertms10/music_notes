import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('HearingRange', () {
    group('.format()', () {
      test('formats this HearingRange as a string', () {
        expect(HearingRange.human.format(), '20 Hz ≤ f ≤ 20000 Hz');
        expect(
          (
            from: const Frequency(28.901),
            to: const Frequency(34500.3),
          ).format(),
          '28.901 Hz ≤ f ≤ 34500.3 Hz',
        );
      });
    });
  });
}
