import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Perfect intervals definitions are correct', () {
    expect(Intervals.Unison.isPerfect, isTrue);
    expect(Intervals.Segona.isPerfect, isFalse);
    expect(Intervals.Tercera.isPerfect, isFalse);
    expect(Intervals.Quarta.isPerfect, isTrue);
    expect(Intervals.Quinta.isPerfect, isTrue);
    expect(Intervals.Sexta.isPerfect, isFalse);
    expect(Intervals.Septima.isPerfect, isFalse);
    expect(Intervals.Octava.isPerfect, isTrue);
    expect(Intervals.Novena.isPerfect, isFalse);
    expect(Intervals.Onzena.isPerfect, isTrue);
    expect(Intervals.Tretzena.isPerfect, isFalse);
  });

  group('Exact intervals are correct', () {
    test('Uníson', () {
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Do)),
        equals(const Interval(Intervals.Unison, Qualities.Justa)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Do, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Unison, Qualities.Augmentada)),
      );
    });

    test('Segona', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Re, Accidentals.DobleBemoll)),
        equals(const Interval(Intervals.Segona, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Re, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Segona, Qualities.Menor)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Re)),
        equals(const Interval(Intervals.Segona, Qualities.Major)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Re, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Segona, Qualities.Augmentada)),
      );
    });

    test('Tercera', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Mi, Accidentals.DobleBemoll)),
        equals(const Interval(Intervals.Tercera, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Mi, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Tercera, Qualities.Menor)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Mi)),
        equals(const Interval(Intervals.Tercera, Qualities.Major)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Mi, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Tercera, Qualities.Augmentada)),
      );
    });

    test('Quarta', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Fa, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Quarta, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Fa)),
        equals(const Interval(Intervals.Quarta, Qualities.Justa)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Fa, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Quarta, Qualities.Augmentada)),
      );
    });

    test('Quinta', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Sol, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Quinta, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Sol)),
        equals(const Interval(Intervals.Quinta, Qualities.Justa)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Sol, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Quinta, Qualities.Augmentada)),
      );
    });

    test('Sexta', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.La, Accidentals.DobleBemoll)),
        equals(const Interval(Intervals.Sexta, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.La, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Sexta, Qualities.Menor)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.La)),
        equals(const Interval(Intervals.Sexta, Qualities.Major)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.La, Accidentals.Sostingut)),
        equals(const Interval(Intervals.Sexta, Qualities.Augmentada)),
      );
    });

    test('Sèptima', () {
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Si, Accidentals.DobleBemoll)),
        equals(const Interval(Intervals.Septima, Qualities.Disminuida)),
      );
      expect(
        const Note(Notes.Do)
            .exactInterval(const Note(Notes.Si, Accidentals.Bemoll)),
        equals(const Interval(Intervals.Septima, Qualities.Menor)),
      );
      expect(
        const Note(Notes.Do).exactInterval(const Note(Notes.Si)),
        equals(const Interval(Intervals.Septima, Qualities.Major)),
      );
    });
  });
}
