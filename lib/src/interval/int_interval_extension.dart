part of '../../music_notes.dart';

extension IntIntervalExtension on int {
  static const Map<int, int> _sizeToSemitones = {
    1: 0,
    2: 1,
    3: 3,
    4: 5,
    5: 7,
    6: 8,
    7: 10,
    8: 12,
  };

  /// Returns an [int] interval that matches with [semitones]
  /// in [_sizeToSemitones], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// IntIntervalExtension.fromSemitones(8) == 6
  /// IntIntervalExtension.fromSemitones(0) == 1
  /// IntIntervalExtension.fromSemitones(-12) == -8
  /// IntIntervalExtension.fromSemitones(4) == null
  /// ```
  static int? fromSemitones(int semitones) {
    final absoluteSemitones = semitones.abs();
    final size = _sizeToSemitones.keys.firstWhereOrNull(
      (interval) =>
          (absoluteSemitones == chromaticDivisions
              ? chromaticDivisions
              : absoluteSemitones.chromaticMod) ==
          _sizeToSemitones[interval],
    );
    if (size == null) return null;
    if (absoluteSemitones == 12) return size * semitones.sign;

    final absResult = size + (absoluteSemitones ~/ chromaticDivisions) * 7;

    return absResult * (semitones.isNegative ? -1 : 1);
  }

  /// Returns the number of semitones of this [int] for a perfect interval or a
  /// minor interval, where appropriate.
  ///
  /// Example:
  /// ```dart
  /// 3.semitones == 3
  /// 5.semitones == 7
  /// (-5).semitones == -7
  /// 7.semitones == 10
  /// 9.semitones == 13
  /// (-9).semitones == -13
  /// ```
  int get semitones {
    assert(this != 0, 'Size must be non-zero');

    return (_sizeToSemitones[abs()] ??
            chromaticDivisions + _sizeToSemitones[simplified.abs()]!) *
        sign;
  }

  /// Returns `true` if this [int] interval is a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// 5.isPerfect == true
  /// 6.isPerfect == false
  /// (-11).isPerfect == true
  /// ```
  bool get isPerfect {
    assert(this != 0, 'Size must be non-zero');

    return (abs() + abs() ~/ 8) % 4 < 2;
  }

  /// Returns whether this [int] interval is greater than an octave.
  ///
  /// Example:
  /// ```dart
  /// 5.isCompound == false
  /// (-6).isCompound == false
  /// 8.isCompound == false
  /// 9.isCompound == true
  /// (-11).isCompound == true
  /// 13.isCompound == true
  /// ```
  bool get isCompound {
    assert(this != 0, 'Size must be non-zero');

    return abs() > 8;
  }

  /// Whether this [int] interval is dissonant.
  ///
  /// Example:
  /// ```dart
  /// 1.isDissonant == false
  /// 5.isDissonant == false
  /// 7.isDissonant == true
  /// (-9).isDissonant == true
  /// ```
  bool get isDissonant {
    assert(this != 0, 'Size must be non-zero');

    return const {2, 7}.contains(simplified.abs());
  }

  /// Returns a simplified [int] interval.
  ///
  /// Example:
  /// ```dart
  /// 13.simplified == 6
  /// (-9).simplified == -2
  /// 8.simplified == 8
  /// ```
  int get simplified {
    assert(this != 0, 'Size must be non-zero');

    return isCompound ? (abs().nModExcludeZero(8) + 1) * sign : this;
  }

  /// Returns an inverted this [int] interval.
  ///
  /// Example:
  /// ```dart
  /// 7.inverted == 2
  /// 4.inverted == 5
  /// (-1).inverted == -8
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
    assert(this != 0, 'Size must be non-zero');

    final diff = 9 - simplified.abs();

    return (diff > 0 ? diff : diff.abs() + 2) * sign;
  }
}
