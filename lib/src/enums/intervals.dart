part of music_notes;

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
  Desena,
  Onzena,
  Dotzena,
  Tretzena,
}

extension IntervalsValues on Intervals {
  static const intervalsQualitiesIndex = {
    Intervals.Unison: 0,
    Intervals.Segona: 1,
    Intervals.Tercera: 3,
    Intervals.Quarta: 5,
    Intervals.Quinta: 7,
    Intervals.Sexta: 8,
    Intervals.Septima: 10,
    Intervals.Octava: 12,
  };

  static const perfectIntervals = {Intervals.Unison, Intervals.Quinta};

  static Intervals fromSemitones(int semitones) => Intervals.values.firstWhere(
        (interval) =>
            Music.modValueExcludeZero(semitones) ==
            Intervals.values.indexOf(interval) + 1,
        orElse: () => null,
      );

  static Intervals invert(Intervals interval) => interval.inverted;

  int get semitones => (intervalsQualitiesIndex[this] != null
      ? intervalsQualitiesIndex[this]
      : Music.chromaticDivisions + intervalsQualitiesIndex[this.inverted]);

  int get ordinal => Intervals.values.indexOf(this) + 1;

  bool get isPerfect => [...perfectIntervals, ...perfectIntervals.map(invert)]
      .any((interval) => interval == this || interval == this.inverted);

  Intervals get simplified => this.ordinal > Intervals.Octava.ordinal
      ? Intervals.values[this.ordinal - Intervals.Octava.ordinal]
      : this;

  Intervals get inverted {
    int diff = 9 - this.simplified.ordinal;
    return fromSemitones(diff > 0 ? diff : diff.abs() + 2);
  }

  Intervals invert(Intervals interval) => interval.inverted;
}
