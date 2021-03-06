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
  Catorzena,
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
  /// IntervalsValues.fromSemitones(0) == Intervals.Unison
  /// IntervalsValues.fromSemitones(4) == null
  /// ```
  static Intervals? fromSemitones(int semitones) =>
      Intervals.values.firstWhereOrNull(
        (interval) =>
            Music.modValueExcludeZero(semitones) ==
            intervalsQualitiesIndex[interval],
      );

  /// Returns an [Intervals] enum item that matches [ordinal].
  ///
  /// Examples:
  /// ```dart
  /// IntervalsValues.fromOrdinal(1) == Intervals.Unison
  /// IntervalsValues.fromOrdinal(5) == Intervals.Quinta
  /// IntervalsValues.fromOrdinal(14) == Intervals.Catorzena
  /// ```
  static Intervals fromOrdinal(int ordinal) => Intervals
      .values[Music.nModValueExcludeZero(ordinal, Intervals.values.length) - 1];

  /// Returns an inverted [Intervals] enum item from [interval].
  ///
  /// Examples:
  /// ```dart
  /// IntervalsValues.invert(Intervals.Segona) == Intervals.Septima
  /// IntervalsValues.invert(Intervals.Quinta) == Intervals.Quarta
  /// IntervalsValues.invert(Intervals.Octava) == Intervals.Unison
  /// ```
  static Intervals invert(Intervals interval) => interval.inverted;

  /// Returns the number of semitones of this [Intervals] enum item as in [intervalsQualitiesIndex].
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Tercera.semitones == 3
  /// Intervals.Quinta.semitones == 7
  /// Intervals.Septima.semitones == 10
  /// ```
  int get semitones =>
      intervalsQualitiesIndex[this] ??
      Music.chromaticDivisions + intervalsQualitiesIndex[inverted]!;

  /// Returns the ordinal number of this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Segona.ordinal == 2
  /// Intervals.Sexta.ordinal == 6
  /// Intervals.Tretzena.ordinal == 13
  /// ```
  int get ordinal => Intervals.values.indexOf(this) + 1;

  /// Returns `true` if this [Intervals] enum item is a perfect interval.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Quinta.isPerfect == true
  /// Intervals.Sexta.isPerfect == false
  /// Intervals.Onzena.isPerfect == true
  /// ```
  bool get isPerfect => [...perfectIntervals, ...perfectIntervals.map(invert)]
      .any((interval) => interval == this || interval == inverted);

  /// Returns a simplified this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Tretzena.simplified == Intervals.Sexta
  /// Intervals.Novena.simplified == Intervals.Segona
  /// Intervals.Octava.simplified == Intervals.Octava
  /// ```
  Intervals get simplified => ordinal > Intervals.Octava.ordinal
      ? Intervals.values[ordinal - Intervals.Octava.ordinal]
      : this;

  /// Returns an inverted this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.Septima.inverted == Intervals.Segona
  /// Intervals.Quarta.inverted == Intervals.Quinta
  /// Intervals.Unison.inverted == Intervals.Octava
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
    final diff = 9 - simplified.ordinal;
    return fromOrdinal(diff > 0 ? diff : diff.abs() + 2);
  }
}
