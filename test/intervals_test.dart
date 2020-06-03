import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:test/test.dart';

void main() {
  test('Perfect intervals are correct', () {
    expect(Intervals.Unison.isPerfect, true);
    expect(Intervals.Segona.isPerfect, false);
    expect(Intervals.Tercera.isPerfect, false);
    expect(Intervals.Quarta.isPerfect, true);
    expect(Intervals.Quinta.isPerfect, true);
    expect(Intervals.Sexta.isPerfect, false);
    expect(Intervals.Septima.isPerfect, false);
    expect(Intervals.Octava.isPerfect, true);
    expect(Intervals.Novena.isPerfect, false);
    expect(Intervals.Onzena.isPerfect, true);
    expect(Intervals.Tretzena.isPerfect, false);
  });
}
