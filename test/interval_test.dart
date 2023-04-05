import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Perfect intervals definitions are correct', () {
    expect(Intervals.unison.isPerfect, isTrue);
    expect(Intervals.second.isPerfect, isFalse);
    expect(Intervals.third.isPerfect, isFalse);
    expect(Intervals.fourth.isPerfect, isTrue);
    expect(Intervals.fifth.isPerfect, isTrue);
    expect(Intervals.sixth.isPerfect, isFalse);
    expect(Intervals.seventh.isPerfect, isFalse);
    expect(Intervals.octave.isPerfect, isTrue);
    expect(Intervals.ninth.isPerfect, isFalse);
    expect(Intervals.eleventh.isPerfect, isTrue);
    expect(Intervals.thirteenth.isPerfect, isFalse);
  });

  group('Exact intervals are correct', () {
    test('Unison', () {
      const baseInterval = Intervals.unison;
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.ut)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.ut, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Second', () {
      const baseInterval = Intervals.second;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.re)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Third', () {
      const baseInterval = Intervals.third;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.mi)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fourth', () {
      const baseInterval = Intervals.fourth;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.fa, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.fa)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.fa, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fifth', () {
      const baseInterval = Intervals.fifth;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.sol, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.sol)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.sol, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Sixth', () {
      const baseInterval = Intervals.sixth;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.la)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Seventh', () {
      const baseInterval = Intervals.seventh;
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.si, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.si, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.si)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
    });
  });
}
