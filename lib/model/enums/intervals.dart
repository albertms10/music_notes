import 'package:music_notes_relations/model/enharmonic_interval.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';
import 'package:music_notes_relations/model/interval.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

enum Intervals {
  Segona,
  Tercera,
  Quarta,
  Quinta,
  Sexta,
  Septima,
  Octava,
  Novena
}

extension IntervalsValues on Intervals {
  static final intervalsValues = {
    EnharmonicInterval([
      Interval(Intervals.Segona, Qualities.Menor),
    ]): 1,
    EnharmonicInterval([
      Interval(Intervals.Segona, Qualities.Major),
    ]): 2,
    EnharmonicInterval([
      Interval(Intervals.Tercera, Qualities.Menor),
    ]): 3,
    EnharmonicInterval([
      Interval(Intervals.Tercera, Qualities.Major),
    ]): 4,
    EnharmonicInterval([
      Interval(Intervals.Quarta, Qualities.Justa),
    ]): 5,
    EnharmonicInterval([
      Interval(Intervals.Quarta, Qualities.Augmentada),
      Interval(Intervals.Quinta, Qualities.Disminuida),
    ]): 6,
    EnharmonicInterval([
      Interval(Intervals.Quinta, Qualities.Justa),
    ]): 7,
    EnharmonicInterval([
      Interval(Intervals.Sexta, Qualities.Menor),
    ]): 8,
    EnharmonicInterval([
      Interval(Intervals.Sexta, Qualities.Major),
    ]): 9,
    EnharmonicInterval([
      Interval(Intervals.Septima, Qualities.Menor),
    ]): 10,
    EnharmonicInterval([
      Interval(Intervals.Septima, Qualities.Major),
    ]): 11,
    EnharmonicInterval([
      Interval(Intervals.Octava, Qualities.Justa),
    ]): 12,
  };

  static EnharmonicInterval interval(int value) => intervalsValues.keys.firstWhere(
      (interval) => Music.modValue(value) == intervalsValues[interval],
      orElse: () => null);

  int get value => intervalsValues[this];
}
