import 'package:music_notes_relations/model/mixins/music.dart';

enum Intervals {
  Unison,
  Segona,
  Tercera,
  Quarta,
  Quinta,
  Sexta,
  Septima,
  Octava,
  Novena,
  Onzena,
  Tretzena,
}

extension IntervalsValues on Intervals {
  static final intervalsValues = const {
    Intervals.Unison: 1,
    Intervals.Segona: 2,
    Intervals.Tercera: 3,
    Intervals.Quarta: 4,
    Intervals.Quinta: 5,
    Intervals.Sexta: 6,
    Intervals.Septima: 7,
    Intervals.Octava: 8,
    Intervals.Novena: 9,
    Intervals.Onzena: 11,
    Intervals.Tretzena: 13,
  };

  static final perfectIntervals = const [Intervals.Unison, Intervals.Quinta];

  static Intervals interval(int value) => intervalsValues.keys.firstWhere(
      (interval) => Music.modValue(value) == intervalsValues[interval],
      orElse: () => null);

  int get value => intervalsValues[this];

  bool get isPerfect => [...perfectIntervals, ...perfectIntervals.map(invert)]
      .any((interval) => interval == this || interval == this.inverted);

  Intervals get inverted {
    int diff = 9 - this.value;
    return interval(diff > 0 ? diff : diff.abs() + 2);
  }

  Intervals invert(Intervals interval) => interval.inverted;
}
