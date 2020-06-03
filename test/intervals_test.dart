import 'package:music_notes_relations/model/enums/intervals.dart';
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
}
