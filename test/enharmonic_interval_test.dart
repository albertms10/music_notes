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

  test('Items are correct', () {
    expect(const EnharmonicInterval(6).items, {
      const Interval(Intervals.fourth, Qualities.augmented),
      const Interval(Intervals.fifth, Qualities.diminished),
    });
    expect(const EnharmonicInterval(4).items, {
      const Interval(Intervals.third, Qualities.major),
      const Interval(Intervals.fourth, Qualities.diminished),
    });
    expect(const EnharmonicInterval(2).items, {
      const Interval(Intervals.second, Qualities.major),
    });
  });
}
