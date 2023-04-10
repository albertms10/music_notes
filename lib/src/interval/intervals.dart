part of '../../music_notes.dart';

enum Intervals {
  unison,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh,
  octave,
  ninth,
  tenth,
  eleventh,
  twelfth,
  thirteenth,
  fourteenth;

  // ignore: avoid-missing-enum-constant-in-map
  static const Map<Intervals, int> intervalsQualitiesIndex = {
    Intervals.unison: 0,
    Intervals.second: 1,
    Intervals.third: 3,
    Intervals.fourth: 5,
    Intervals.fifth: 7,
    Intervals.sixth: 8,
    Intervals.seventh: 10,
    Intervals.octave: 12,
  };

  /// [Set] of fundamental perfect [Intervals].
  static const Set<Intervals> _basePerfectIntervals = {
    Intervals.unison,
    Intervals.fifth,
  };

  static final Set<Intervals> perfectIntervals = {
    ..._basePerfectIntervals,
    ..._basePerfectIntervals.map<Intervals>(invert),
  };

  /// Returns an [Intervals] enum item that matches [semitones]
  /// in [intervalsQualitiesIndex], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.fromSemitones(8) == Intervals.sixth
  /// Intervals.fromSemitones(0) == Intervals.unison
  /// Intervals.fromSemitones(4) == null
  /// ```
  static Intervals? fromSemitones(int semitones) =>
      Intervals.values.firstWhereOrNull(
        (interval) =>
            semitones.chromaticModExcludeZero ==
            intervalsQualitiesIndex[interval],
      );

  /// Returns an [Intervals] enum item that matches [ordinal].
  ///
  /// Examples:
  /// ```dart
  /// Intervals.fromOrdinal(1) == Intervals.unison
  /// Intervals.fromOrdinal(5) == Intervals.fifth
  /// Intervals.fromOrdinal(14) == Intervals.fourteenth
  /// ```
  static Intervals fromOrdinal(int ordinal) =>
      Intervals.values[ordinal.nModExcludeZero(Intervals.values.length) - 1];

  /// Returns an inverted [Intervals] enum item from [interval].
  ///
  /// Examples:
  /// ```dart
  /// Intervals.invert(Intervals.second) == Intervals.seventh
  /// Intervals.invert(Intervals.fifth) == Intervals.fourth
  /// Intervals.invert(Intervals.octave) == Intervals.unison
  /// ```
  static Intervals invert(Intervals interval) => interval.inverted;

  /// Returns the number of semitones of this [Intervals] enum item
  /// as in [intervalsQualitiesIndex].
  ///
  /// Examples:
  /// ```dart
  /// Intervals.third.semitones == 3
  /// Intervals.fifth.semitones == 7
  /// Intervals.seventh.semitones == 10
  /// ```
  int get semitones =>
      intervalsQualitiesIndex[this] ??
      chromaticDivisions + intervalsQualitiesIndex[inverted]!;

  /// Returns the ordinal number of this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.second.ordinal == 2
  /// Intervals.sixth.ordinal == 6
  /// Intervals.thirteenth.ordinal == 13
  /// ```
  int get ordinal => Intervals.values.indexOf(this) + 1;

  /// Returns `true` if this [Intervals] enum item is a perfect interval.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.fifth.isPerfect == true
  /// Intervals.sixth.isPerfect == false
  /// Intervals.eleventh.isPerfect == true
  /// ```
  bool get isPerfect =>
      perfectIntervals.any((interval) => {this, inverted}.contains(interval));

  /// Returns whether this [Intervals] enum item is compound.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.fifth.isCompound == false
  /// Intervals.octave.isCompound == false
  /// Intervals.ninth.isCompound == true
  /// Intervals.thirteenth.isCompound == true
  /// ```
  bool get isCompound => ordinal > Intervals.octave.ordinal;

  /// Returns a simplified this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.thirteenth.simplified == Intervals.sixth
  /// Intervals.ninth.simplified == Intervals.second
  /// Intervals.octave.simplified == Intervals.octave
  /// ```
  Intervals get simplified =>
      isCompound ? Intervals.values[ordinal % Intervals.octave.ordinal] : this;

  /// Returns an inverted this [Intervals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.seventh.inverted == Intervals.second
  /// Intervals.fourth.inverted == Intervals.fifth
  /// Intervals.unison.inverted == Intervals.octave
  /// ```
  ///
  /// If an interval is greater than an octave, the simplified
  /// [Interval] inversion is returned instead.
  ///
  /// Examples:
  /// ```dart
  /// Intervals.eleventh.inverted == Intervals.fifth
  /// Intervals.ninth.inverted == Intervals.seventh
  /// ```
  Intervals get inverted {
    final diff = 9 - simplified.ordinal;

    return fromOrdinal(diff > 0 ? diff : diff.abs() + 2);
  }
}
