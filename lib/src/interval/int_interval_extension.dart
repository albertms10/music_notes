part of '../../music_notes.dart';

extension IntIntervalExtension on int {
  static const Map<int, int> _intervalsToSemitonesDelta = {
    1: 0,
    2: 1,
    3: 3,
    4: 5,
    5: 7,
    6: 8,
    7: 10,
    8: 12,
  };

  /// Returns an [int] interval that matches [semitones]
  /// in [_intervalsToSemitonesDelta], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// IntIntervalExtension.fromSemitones(8) == 6
  /// IntIntervalExtension.fromSemitones(0) == 1
  /// IntIntervalExtension.fromSemitones(12) == 8
  /// IntIntervalExtension.fromSemitones(4) == null
  /// ```
  static int? fromSemitones(int semitones) =>
      _intervalsToSemitonesDelta.keys.firstWhereOrNull(
        (interval) =>
            (semitones == chromaticDivisions
                ? chromaticDivisions
                : semitones.chromaticMod) ==
            _intervalsToSemitonesDelta[interval],
      );

  /// Returns the number of semitones of this [int] for a perfect interval or a
  /// minor interval, where appropriate.
  ///
  /// Example:
  /// ```dart
  /// 3.semitones == 3
  /// 5.semitones == 7
  /// 7.semitones == 10
  /// 9.semitones == 13
  /// ```
  int get semitones =>
      _intervalsToSemitonesDelta[this] ??
      chromaticDivisions + _intervalsToSemitonesDelta[simplified]!;

  /// Returns `true` if this [int] interval is a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// 5.isPerfect == true
  /// 6.isPerfect == false
  /// 11.isPerfect == true
  /// ```
  bool get isPerfect =>
      (this + this ~/ 8) % 4 == 0 || (this + this ~/ 8) % 4 == 1;

  /// Returns whether this [int] interval is greater than an octave.
  ///
  /// Example:
  /// ```dart
  /// 5.isCompound == false
  /// 8.isCompound == false
  /// 9.isCompound == true
  /// 13.isCompound == true
  /// ```
  bool get isCompound => this > 8;

  /// Whether this [int] interval is dissonant.
  ///
  /// Example:
  /// ```dart
  /// 1.isDissonant == false
  /// 5.isDissonant == false
  /// 7.isDissonant == true
  /// 9.isDissonant == true
  /// ```
  bool get isDissonant => const {2, 7}.contains(simplified);

  /// Returns a simplified [int] interval.
  ///
  /// Example:
  /// ```dart
  /// 13.simplified == 6
  /// 9.simplified == 2
  /// 8.simplified == 8
  /// ```
  int get simplified => isCompound ? nModExcludeZero(8) + 1 : this;

  /// Returns an inverted this [int] interval.
  ///
  /// Example:
  /// ```dart
  /// 7.inverted == 2
  /// 4.inverted == 5
  /// 1.inverted == 8
  /// ```
  ///
  /// If an interval is greater than an octave, the simplified
  /// [int] interval inversion is returned instead.
  ///
  /// Example:
  /// ```dart
  /// 11.inverted == 5
  /// 9.inverted == 7
  /// ```
  int get inverted {
    final diff = 9 - simplified;

    return diff > 0 ? diff : diff.abs() + 2;
  }
}
