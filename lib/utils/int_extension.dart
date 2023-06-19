import 'package:music_notes/music_notes.dart';

extension IntExtension on int {
  /// Returns this [int] incremented by [step].
  ///
  /// Example:
  /// ```dart
  /// 1.incrementBy(1) == 2
  /// (-1).incrementBy(1) == -2
  /// 10.incrementBy(-2) == 8
  /// (-10).incrementBy(-2) == -8
  /// ```
  int incrementBy(int step) => (abs() + step) * (isNegative ? -1 : 1);

  /// Returns the modulus [chromaticDivisions] of this [int].
  ///
  /// Example:
  /// ```dart
  /// 4.chromaticMod == 4
  /// 14.chromaticMod == 2
  /// (-5).chromaticMod == 7
  /// 0.chromaticMod == 0
  /// 12.chromaticMod == 0
  /// ```
  int get chromaticMod => this % chromaticDivisions;

  /// Returns the modulus [chromaticDivisions] of this [int]. If this
  /// is 0, it returns [chromaticDivisions].
  ///
  /// Example:
  /// ```dart
  /// 15.chromaticModExcludeZero == 3
  /// 12.chromaticModExcludeZero == 12
  /// 0.chromaticModExcludeZero == 12
  /// ```
  int get chromaticModExcludeZero => nModExcludeZero(chromaticDivisions);

  /// Returns the modulus [n] of this [int]. If this is 0, it returns [n].
  ///
  /// Example:
  /// ```dart
  /// 9.nModExcludeZero(3) == 3
  /// 0.nModExcludeZero(5) == 5
  /// 7.nModExcludeZero(7) == 7
  /// ```
  int nModExcludeZero(int n) {
    final modValue = this % n;

    return modValue == 0 ? n : modValue;
  }
}
