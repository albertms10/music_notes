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
        const Note(Notes.c).exactInterval(const Note(Notes.c)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.c, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Second', () {
      const baseInterval = Intervals.second;
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.d, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.d)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.d, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Third', () {
      const baseInterval = Intervals.third;
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.e, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.e)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.e, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fourth', () {
      const baseInterval = Intervals.fourth;
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.f, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.f)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.f, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fifth', () {
      const baseInterval = Intervals.fifth;
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.g, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.g)),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.g, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Sixth', () {
      const baseInterval = Intervals.sixth;
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.a, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.a)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.a, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Seventh', () {
      const baseInterval = Intervals.seventh;
      expect(
        const Note(Notes.c)
            .exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.b, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        const Note(Notes.c).exactInterval(const Note(Notes.b)),
        equals(const Interval(baseInterval, Qualities.major)),
      );
    });
  });
}
