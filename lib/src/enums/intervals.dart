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

  /// [Set] of fundamental perfect [Intervals].
  static const perfectIntervals = {Intervals.Unison, Intervals.Quinta};

  /// Returns an [Intervals] enum item that matches [semitones]
  /// in [intervalsQualitiesIndex], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// IntervalsValues.fromSemitones(8) == Intervals.Sexta
  /// IntervalsValues.fromSemitones(1) == Intervals.Unison
  /// IntervalsValues.fromSemitones(4) == null
  /// ```
  static Intervals fromSemitones(int semitones) => Intervals.values.firstWhere(
        (interval) =>
            Music.modValueExcludeZero(semitones) ==
            intervalsQualitiesIndex[interval],
        orElse: () => null,
      );

  static Intervals fromOrdinal(int ordinal) => Intervals
      .values[Music.nModValueExcludeZero(ordinal, Intervals.values.length) - 1];

  /// Returns an inverted [Intervals] enum item from [interval].
  static Intervals invert(Intervals interval) => interval.inverted;

  /// Returns the semitones of this [Intervals] enum item as in [intervalsQualitiesIndex].
  int get semitones => (intervalsQualitiesIndex[this] != null
      ? intervalsQualitiesIndex[this]
      : Music.chromaticDivisions + intervalsQualitiesIndex[this.inverted]);

  /// Returns the ordinal number of this [Intervals] enum item.
  int get ordinal => Intervals.values.indexOf(this) + 1;

  /// Returns `true` if this [Intervals] enum item is a perfect interval.
  bool get isPerfect => [...perfectIntervals, ...perfectIntervals.map(invert)]
      .any((interval) => interval == this || interval == this.inverted);

  /// Returns a simplified this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Tretzena.simplified == Intervals.Sexta
  /// Intervals.Novena.simplified == Intervals.Segona
  /// Intervals.Octava.simplified == Intervals.Octava
  /// ```
  Intervals get simplified => this.ordinal > Intervals.Octava.ordinal
      ? Intervals.values[this.ordinal - Intervals.Octava.ordinal]
      : this;

  /// Returns an inverted this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Septima.inverted == Intervals.Segona
  /// Intervals.Quarta.inverted == Intervals.Quinta
  /// Intervals.Unisso.inverted == Intervals.Octava
  /// ```
  ///
  /// If an interval is greater than an octave, the simplified
  /// [Interval] inversion is returned instead.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Onzena.inverted == Intervals.Quinta
  /// Intervals.Novena.inverted == Intervals.Septima
  /// ```
  Intervals get inverted {
    int diff = 9 - this.simplified.ordinal;
    return fromSemitones(diff > 0 ? diff : diff.abs() + 2);
  }
}
