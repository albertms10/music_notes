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
    test('Uníson', () {
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.ut)),
        equals(const Interval(Intervals.unison, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.ut, Accidentals.sharp)),
        equals(const Interval(Intervals.unison, Qualities.augmented)),
      );
    });

    test('Segona', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidentals.doubleFlat)),
        equals(const Interval(Intervals.second, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidentals.flat)),
        equals(const Interval(Intervals.second, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.re)),
        equals(const Interval(Intervals.second, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.re, Accidentals.sharp)),
        equals(const Interval(Intervals.second, Qualities.augmented)),
      );
    });

    test('Tercera', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidentals.doubleFlat)),
        equals(const Interval(Intervals.third, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidentals.flat)),
        equals(const Interval(Intervals.third, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.mi)),
        equals(const Interval(Intervals.third, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.mi, Accidentals.sharp)),
        equals(const Interval(Intervals.third, Qualities.augmented)),
      );
    });

    test('Quarta', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.fa, Accidentals.flat)),
        equals(const Interval(Intervals.fourth, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.fa)),
        equals(const Interval(Intervals.fourth, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.fa, Accidentals.sharp)),
        equals(const Interval(Intervals.fourth, Qualities.augmented)),
      );
    });

    test('Quinta', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.sol, Accidentals.flat)),
        equals(const Interval(Intervals.fifth, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.sol)),
        equals(const Interval(Intervals.fifth, Qualities.perfect)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.sol, Accidentals.sharp)),
        equals(const Interval(Intervals.fifth, Qualities.augmented)),
      );
    });

    test('Sexta', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidentals.doubleFlat)),
        equals(const Interval(Intervals.sixth, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidentals.flat)),
        equals(const Interval(Intervals.sixth, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.la)),
        equals(const Interval(Intervals.sixth, Qualities.major)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.la, Accidentals.sharp)),
        equals(const Interval(Intervals.sixth, Qualities.augmented)),
      );
    });

    test('Sèptima', () {
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.si, Accidentals.doubleFlat)),
        equals(const Interval(Intervals.seventh, Qualities.diminished)),
      );
      expect(
        const Note(Notes.ut)
            .exactInterval(const Note(Notes.si, Accidentals.flat)),
        equals(const Interval(Intervals.seventh, Qualities.minor)),
      );
      expect(
        const Note(Notes.ut).exactInterval(const Note(Notes.si)),
        equals(const Interval(Intervals.seventh, Qualities.major)),
      );
    });
  });
}
