import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicInterval', () {
    group('.intervalFromSemitones()', () {
      test('should return the correct Interval from semitones', () {
        expect(
          EnharmonicInterval.intervalFromSemitones(4),
          equals(const Interval(Intervals.third, Qualities.minor)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7),
          equals(const Interval(Intervals.fourth, Qualities.augmented)),
        );
        expect(
          EnharmonicInterval.intervalFromSemitones(7, Qualities.diminished),
          equals(const Interval(Intervals.fifth, Qualities.diminished)),
        );
      });
    });
  });
}
