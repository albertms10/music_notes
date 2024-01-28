import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('HearingRange', () {
    group('.toString()', () {
      test('returns the string representation of this HearingRange', () {
        expect(HearingRange.human.toString(), '20 Hz ≤ f ≤ 20000 Hz');
        expect(
          const HearingRange(min: Frequency(28.901), max: Frequency(34500.3))
              .toString(),
          '28.901 Hz ≤ f ≤ 34500.3 Hz',
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal ClosestPitches', () {
        expect(
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(1), max: Frequency(1000)),
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(1), max: Frequency(1000)),
        );
        expect(
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(10.646), max: Frequency(2345.345)),
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(10.646), max: Frequency(2345.345)),
        );
      });

      test('returns different hashCodes for different ClosestPitches', () {
        expect(
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(0), max: Frequency(30000)),
          // ignore: prefer_const_constructors
          isNot(HearingRange(min: Frequency(2), max: Frequency(3))),
        );
        expect(
          // ignore: prefer_const_constructors
          HearingRange(min: Frequency(10.6), max: Frequency(2345.3)),
          // ignore: prefer_const_constructors
          isNot(HearingRange(min: Frequency(10.7), max: Frequency(2345.6))),
        );
      });

      test('ignores equal ClosestPitch instances in a Set', () {
        final collection = {
          HearingRange.human,
          const HearingRange(min: Frequency(0), max: Frequency(1000)),
          const HearingRange(min: Frequency(10), max: Frequency(20000)),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          HearingRange.human,
          const HearingRange(min: Frequency(0), max: Frequency(1000)),
          const HearingRange(min: Frequency(10), max: Frequency(20000)),
        ]);
      });
    });
  });
}
