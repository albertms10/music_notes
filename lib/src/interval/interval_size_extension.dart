part of '../../music_notes.dart';

extension IntervalSizeExtension on int {
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

  /// Returns the [Interval.size] that matches with [semitones]
  /// in [_sizeToSemitones], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// IntervalSizeExtension.fromSemitones(8) == 6
  /// IntervalSizeExtension.fromSemitones(0) == 1
  /// IntervalSizeExtension.fromSemitones(-12) == -8
  /// IntervalSizeExtension.fromSemitones(4) == null
  /// ```
  static int? fromSemitones(int semitones) {
    final absoluteSemitones = semitones.abs();
    final matchingSize = _sizeToSemitones.keys.firstWhereOrNull(
      (size) =>
          (absoluteSemitones == chromaticDivisions
              ? chromaticDivisions
              : absoluteSemitones.chromaticMod) ==
          _sizeToSemitones[size],
    );
    if (matchingSize == null) return null;
    if (absoluteSemitones == 12) return matchingSize * semitones.sign;

    final absResult =
        matchingSize + (absoluteSemitones ~/ chromaticDivisions) * 7;

    return absResult * (semitones.isNegative ? -1 : 1);
  }

  /// Returns the number of semitones of this [Interval.size] for the
  /// corresponding perfect or minor interval, where appropriate.
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

    // ignore: deprecated_member_use_from_same_package
    final simplifiedAbs = simplified.abs();
    final octaveShift = chromaticDivisions * (_sizeAbsShift ~/ 8);

    // We exclude perfect octaves (simplified as 8) from the lookup because we
    // want to consider them as 0 (as they were modulo 8).
    return (_sizeToSemitones[simplifiedAbs == 8 ? 1 : simplifiedAbs]! +
            octaveShift) *
        sign;
  }

  /// Returns the absolute [Interval.size] value taking octave shift into
  /// account.
  int get _sizeAbsShift {
    final sizeAbs = abs();

    return sizeAbs + sizeAbs ~/ 8;
  }

  /// Returns `true` if this [Interval.size] conforms a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// 5.isPerfect == true
  /// 6.isPerfect == false
  /// (-11).isPerfect == true
  /// ```
  bool get isPerfect {
    assert(this != 0, 'Size must be non-zero');

    return _sizeAbsShift % 4 < 2;
  }

  /// Returns whether this [Interval.size] is greater than an octave.
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
  @Deprecated('Use [Interval.isCompound] instead.')
  bool get isCompound {
    assert(this != 0, 'Size must be non-zero');

    return abs() > 8;
  }

  /// Returns the simplified version of this [Interval.size].
  ///
  /// Example:
  /// ```dart
  /// 13.simplified == 6
  /// (-9).simplified == -2
  /// 8.simplified == 8
  /// (-22).simplified == -8
  /// ```
  @Deprecated('Use [Interval.simplified] instead.')
  int get simplified {
    assert(this != 0, 'Size must be non-zero');
    if (!isCompound) return this;

    return _sizeAbsShift.nModExcludeZero(8) * sign;
  }
}
