part of '../../music_notes.dart';

/// An [Interval] size.
extension type const Size._(int value) implements int {
  /// Creates a new [Size] from [value].
  const Size(this.value): assert(value != 0, 'Value must be non-zero');

  /// A unison [Size].
  static const unison = Size(1);

  /// A second [Size].
  static const second = Size(2);

  /// A third [Size].
  static const third = Size(3);

  /// A fourth [Size].
  static const fourth = Size(4);

  /// A fifth [Size].
  static const fifth = Size(5);

  /// A sixth [Size].
  static const sixth = Size(6);

  /// A seventh [Size].
  static const seventh = Size(7);

  /// An octave [Size].
  static const octave = Size(8);

  /// A ninth [Size].
  static const ninth = Size(9);

  /// A tenth [Size].
  static const tenth = Size(10);

  /// An eleventh [Size].
  static const eleventh = Size(11);

  /// A twelfth [Size].
  static const twelfth = Size(12);

  /// A thirteenth [Size].
  static const thirteenth = Size(13);

  /// Returns the number of semitones of this [Size] for the corresponding
  /// [ImperfectQuality.minor] or [PerfectQuality.perfect] semitones.
  ///
  /// See [Interval._sizeToSemitones].
  ///
  /// Example:
  /// ```dart
  /// const Size.third.semitones == 3
  /// const Size.fifth.semitones == 7
  /// const Size(-5).semitones == -7
  /// const Size.seventh.semitones == 10
  /// const Size.ninth.semitones == 13
  /// const Size(-9).semitones == -13
  /// ```
  int get semitones {
    final simplifiedAbs = simplified.value.abs();
    final octaveShift = chromaticDivisions * (_sizeAbsShift ~/ 8);
    // We exclude perfect octaves (simplified as 8) from the lookup to consider
    // them 0 (as if they were modulo 8).
    final size = Size(simplifiedAbs == 8 ? 1 : simplifiedAbs);

    return (Interval._sizeToSemitones[size]! + octaveShift) * value.sign;
  }

  /// Returns the absolute [Size] value taking octave shift into account.
  int get _sizeAbsShift {
    final sizeAbs = value.abs();

    return sizeAbs + sizeAbs ~/ 8;
  }

  /// Returns whether this [Size] conforms a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// const Size.fifth.isPerfect == true
  /// const Size.sixth.isPerfect == false
  /// const Size(-11).isPerfect == true
  /// ```
  bool get isPerfect => _sizeAbsShift % 4 < 2;

  /// Returns whether this [Size] is greater than an octave.
  ///
  /// Example:
  /// ```dart
  /// const Size.fifth.isCompound == false
  /// const Size(-6).isCompound == false
  /// const Size.octave.isCompound == false
  /// const Size.ninth.isCompound == true
  /// const Size(-11).isCompound == true
  /// const Size.thirteenth.isCompound == true
  /// ```
  bool get isCompound => value.abs() > 8;

  /// Returns the simplified version of this [Size].
  ///
  /// Example:
  /// ```dart
  /// const Size.thirteenth.simplified == 6
  /// const Size(-9).simplified == -2
  /// const Size.octave.simplified == 8
  /// const Size(-22).simplified == -8
  /// ```
  Size get simplified =>
      isCompound ? Size(_sizeAbsShift.nonZeroMod(8) * value.sign) : this;

  /// Whether this [Size] is numerically smaller than [other].
  bool operator <(num other) => value < other;

  /// Returns the inverted (negative) value of this [Size].
  Size operator -() => Size(-value);

  /// Adds [other] to this [Size].
  Size operator +(Size other) => Size(value + other.value);

  /// Euclidean modulo of this [Size] by [other].
  num operator %(num other) => value % other;

  /// Truncating division operator.
  Size operator ~/(num other) => Size(value ~/ other);

  /// Compares this [Size] to other.
  int compareTo(Size other) => value.compareTo(other.value);
}
