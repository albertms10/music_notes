import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Intervals are correct', () {
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
}
