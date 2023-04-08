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
        Note.c.exactInterval(Note.c),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        Note.c.exactInterval(Note.cSharp),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Second', () {
      const baseInterval = Intervals.second;
      expect(
        Note.c.exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.dFlat),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        Note.c.exactInterval(Note.d),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        Note.c.exactInterval(Note.dSharp),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Third', () {
      const baseInterval = Intervals.third;
      expect(
        Note.c.exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.eFlat),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        Note.c.exactInterval(Note.e),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        Note.c.exactInterval(const Note(Notes.e, Accidental.sharp)),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fourth', () {
      const baseInterval = Intervals.fourth;
      expect(
        Note.c.exactInterval(const Note(Notes.f, Accidental.flat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.f),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        Note.c.exactInterval(Note.fSharp),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Fifth', () {
      const baseInterval = Intervals.fifth;
      expect(
        Note.c.exactInterval(Note.gFlat),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.g),
        equals(const Interval(baseInterval, Qualities.perfect)),
      );
      expect(
        Note.c.exactInterval(Note.gSharp),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Sixth', () {
      const baseInterval = Intervals.sixth;
      expect(
        Note.c.exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.aFlat),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        Note.c.exactInterval(Note.a),
        equals(const Interval(baseInterval, Qualities.major)),
      );
      expect(
        Note.c.exactInterval(Note.aSharp),
        equals(const Interval(baseInterval, Qualities.augmented)),
      );
    });

    test('Seventh', () {
      const baseInterval = Intervals.seventh;
      expect(
        Note.c.exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
        equals(const Interval(baseInterval, Qualities.diminished)),
      );
      expect(
        Note.c.exactInterval(Note.bFlat),
        equals(const Interval(baseInterval, Qualities.minor)),
      );
      expect(
        Note.c.exactInterval(Note.b),
        equals(const Interval(baseInterval, Qualities.major)),
      );
    });
  });
}
