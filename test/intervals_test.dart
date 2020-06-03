import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';
import 'package:music_notes_relations/model/interval.dart';
import 'package:music_notes_relations/model/note.dart';
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
        Note(Notes.Do).exactInterval(Note(Notes.Do)),
        equals(Interval(Intervals.Unison, Qualities.Justa)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Do, Accidentals.Sostingut)),
        equals(Interval(Intervals.Unison, Qualities.Augmentada)),
      );
    });

    test('Segona', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Re, Accidentals.DobleBemoll)),
        equals(Interval(Intervals.Segona, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Re, Accidentals.Bemoll)),
        equals(Interval(Intervals.Segona, Qualities.Menor)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Re)),
        equals(Interval(Intervals.Segona, Qualities.Major)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Re, Accidentals.Sostingut)),
        equals(Interval(Intervals.Segona, Qualities.Augmentada)),
      );
    });

    test('Tercera', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Mi, Accidentals.DobleBemoll)),
        equals(Interval(Intervals.Tercera, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Mi, Accidentals.Bemoll)),
        equals(Interval(Intervals.Tercera, Qualities.Menor)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Mi)),
        equals(Interval(Intervals.Tercera, Qualities.Major)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Mi, Accidentals.Sostingut)),
        equals(Interval(Intervals.Tercera, Qualities.Augmentada)),
      );
    });

    test('Quarta', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Fa, Accidentals.Bemoll)),
        equals(Interval(Intervals.Quarta, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Fa)),
        equals(Interval(Intervals.Quarta, Qualities.Justa)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Fa, Accidentals.Sostingut)),
        equals(Interval(Intervals.Quarta, Qualities.Augmentada)),
      );
    });

    test('Quinta', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Sol, Accidentals.Bemoll)),
        equals(Interval(Intervals.Quinta, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Sol)),
        equals(Interval(Intervals.Quinta, Qualities.Justa)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Sol, Accidentals.Sostingut)),
        equals(Interval(Intervals.Quinta, Qualities.Augmentada)),
      );
    });

    test('Sexta', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.La, Accidentals.DobleBemoll)),
        equals(Interval(Intervals.Sexta, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.La, Accidentals.Bemoll)),
        equals(Interval(Intervals.Sexta, Qualities.Menor)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.La)),
        equals(Interval(Intervals.Sexta, Qualities.Major)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.La, Accidentals.Sostingut)),
        equals(Interval(Intervals.Sexta, Qualities.Augmentada)),
      );
    });

    test('Sèptima', () {
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Si, Accidentals.DobleBemoll)),
        equals(Interval(Intervals.Septima, Qualities.Disminuida)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Si, Accidentals.Bemoll)),
        equals(Interval(Intervals.Septima, Qualities.Menor)),
      );
      expect(
        Note(Notes.Do).exactInterval(Note(Notes.Si)),
        equals(Interval(Intervals.Septima, Qualities.Major)),
      );
    });
  });
}
