import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ChordPattern', () {
    group('.isMajor', () {
      test('should return whether this ChordPattern is major', () {
        expect(ChordPattern.augmentedTriad.isMajor, isFalse);
        expect(ChordPattern.majorTriad.isMajor, isTrue);
        expect(ChordPattern.minorTriad.isMajor, isFalse);
        expect(ChordPattern.diminishedTriad.isMajor, isFalse);
      });
    });

    group('.isMinor', () {
      test('should return whether this ChordPattern is minor', () {
        expect(ChordPattern.augmentedTriad.isMinor, isFalse);
        expect(ChordPattern.majorTriad.isMinor, isFalse);
        expect(ChordPattern.minorTriad.isMinor, isTrue);
        expect(ChordPattern.diminishedTriad.isMinor, isFalse);
      });
    });

    group('.sus2()', () {
      test('should add a 2nd interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.sus2(),
          const ChordPattern([
            Interval.majorSecond,
            Interval.majorThird,
            Interval.perfectFifth,
          ]),
        );
        expect(
          ChordPattern.minorTriad.sus2(),
          const ChordPattern([
            Interval.majorSecond,
            Interval.minorThird,
            Interval.perfectFifth,
          ]),
        );
        expect(
          ChordPattern.majorTriad.sus2(ImperfectQuality.minor),
          const ChordPattern([
            Interval.minorSecond,
            Interval.majorThird,
            Interval.perfectFifth,
          ]),
        );
        expect(
          ChordPattern.minorTriad.sus2(ImperfectQuality.minor),
          const ChordPattern([
            Interval.minorSecond,
            Interval.minorThird,
            Interval.perfectFifth,
          ]),
        );
      });
    });

    group('.add7()', () {
      test('should add a 7th interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add7(),
          const ChordPattern([
            Interval.majorThird,
            Interval.perfectFifth,
            Interval.minorSeventh,
          ]),
        );
        expect(
          ChordPattern.minorTriad.add7(),
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.minorSeventh,
          ]),
        );
        expect(
          ChordPattern.majorTriad.add7(ImperfectQuality.major),
          const ChordPattern([
            Interval.majorThird,
            Interval.perfectFifth,
            Interval.majorSeventh,
          ]),
        );
        expect(
          ChordPattern.minorTriad.add7(ImperfectQuality.major),
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.majorSeventh,
          ]),
        );
      });

      test('should ignore any previous interval size in this ChordPattern', () {
        expect(
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.majorSeventh,
          ]).add(Interval.majorSeventh),
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.majorSeventh,
          ]),
        );
        expect(
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.majorSeventh,
          ]).add(Interval.minorSeventh),
          const ChordPattern([
            Interval.minorThird,
            Interval.perfectFifth,
            Interval.minorSeventh,
          ]),
        );
      });
    });
  });
}
