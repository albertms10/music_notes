import 'package:music_notes/music_notes.dart';

extension IntModExtension on int {
  /// Returns the modulus [chromaticDivisions] of this [int].
  ///
  /// Examples:
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
  /// Examples:
  /// ```dart
  /// 15.chromaticModExcludeZero == 3
  /// 12.chromaticModExcludeZero == 12
  /// 0.chromaticModExcludeZero == 12
  /// ```
  int get chromaticModExcludeZero => nModExcludeZero(chromaticDivisions);

  /// Returns the modulus [n] of this [int]. If this is 0, it returns [n].
  ///
  /// Examples:
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
