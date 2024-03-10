import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart' show immutable, redeclare;
import 'package:music_notes/utils.dart';

import '../music.dart';
import 'interval.dart';
import 'quality.dart';

/// An [Interval] size.
@immutable
extension type const Size._(int size) implements int {
  /// Creates a new [Size] from [size].
  const Size(this.size) : assert(size != 0, 'Value must be non-zero.');

  /// A unison [Size].
  static const unison = PerfectSize(1);

  /// A second [Size].
  static const second = ImperfectSize(2);

  /// A third [Size].
  static const third = ImperfectSize(3);

  /// A fourth [Size].
  static const fourth = PerfectSize(4);

  /// A fifth [Size].
  static const fifth = PerfectSize(5);

  /// A sixth [Size].
  static const sixth = ImperfectSize(6);

  /// A seventh [Size].
  static const seventh = ImperfectSize(7);

  /// An octave [Size].
  static const octave = PerfectSize(8);

  /// A ninth [Size].
  static const ninth = ImperfectSize(9);

  /// A tenth [Size].
  static const tenth = ImperfectSize(10);

  /// An eleventh [Size].
  static const eleventh = PerfectSize(11);

  /// A twelfth [Size].
  static const twelfth = PerfectSize(12);

  /// A thirteenth [Size].
  static const thirteenth = ImperfectSize(13);

  /// [Size] to the corresponding [ImperfectQuality.minor] or
  /// [PerfectQuality.perfect] semitones.
  static const _sizeToSemitones = {
    Size.unison: 0, // P
    Size.second: 1, // m
    Size.third: 3, // m
    Size.fourth: 5, // P
    Size.fifth: 7, // P
    Size.sixth: 8, // m
    Size.seventh: 10, // m
    Size.octave: 12, // P
  };

  /// The [Size] that matches with [semitones] in [_sizeToSemitones].
  /// Otherwise, returns `null`.
  ///
  /// Example:
  /// ```dart
  /// Size.fromSemitones(8) == Size.sixth
  /// Size.fromSemitones(0) == Size.unison
  /// Size.fromSemitones(-12) == -Size.octave
  /// Size.fromSemitones(4) == null
  /// ```
  static Size? fromSemitones(int semitones) {
    final absoluteSemitones = semitones.abs();
    final matchingSize = _sizeToSemitones.keys.firstWhereOrNull(
      (size) =>
          (absoluteSemitones == chromaticDivisions
              ? chromaticDivisions
              : absoluteSemitones % chromaticDivisions) ==
          _sizeToSemitones[size],
    );
    if (matchingSize == null) return null;
    if (absoluteSemitones == chromaticDivisions) {
      return Size(matchingSize * semitones.sign);
    }

    final absResult =
        matchingSize + (absoluteSemitones ~/ chromaticDivisions) * 7;

    return Size(absResult * semitones.nonZeroSign);
  }

  /// The number of semitones of this [Size] as in [_sizeToSemitones].
  ///
  /// Example:
  /// ```dart
  /// Size.third.semitones == 3
  /// Size.fifth.semitones == 7
  /// (-Size.fifth).semitones == -7
  /// Size.seventh.semitones == 10
  /// Size.ninth.semitones == 13
  /// (-Size.ninth).semitones == -13
  /// ```
  int get semitones {
    final simpleAbs = simple.abs();
    final octaveShift = chromaticDivisions * (absShift ~/ Size.octave);
    // We exclude perfect octaves (simplified as 8) from the lookup to consider
    // them 0 (as if they were modulo `Size.octave`).
    final size = Size(simpleAbs == Size.octave ? 1 : simpleAbs);

    return (_sizeToSemitones[size]! + octaveShift) * sign;
  }

  /// The absolute [Size] value taking octave shift into account.
  int get absShift {
    final sizeAbs = abs();

    return sizeAbs + sizeAbs ~/ Size.octave;
  }

  /// The [PerfectQuality.diminished] or [ImperfectQuality.diminished] interval
  /// from this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.second.diminished == Interval.d2
  /// Size.fifth.diminished == Interval.d5
  /// (-Size.seventh).diminished == -Interval.d7
  /// ```
  Interval get diminished => isPerfect
      ? Interval.perfect(this, PerfectQuality.diminished)
      : Interval.imperfect(this, ImperfectQuality.diminished);

  /// The [PerfectQuality.augmented] or [ImperfectQuality.augmented] interval
  /// from this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.third.augmented == Interval.A3
  /// Size.fourth.augmented == Interval.A4
  /// (-Size.sixth).augmented == -Interval.A6
  /// ```
  Interval get augmented => isPerfect
      ? Interval.perfect(this, PerfectQuality.augmented)
      : Interval.imperfect(this, ImperfectQuality.augmented);

  /// Whether this [Size] conforms a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isPerfect == true
  /// Size.sixth.isPerfect == false
  /// (-Size.eleventh).isPerfect == true
  /// ```
  bool get isPerfect => absShift % (Size.octave / 2) < 2;

  /// Whether this [Size] is greater than [Size.octave].
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isCompound == false
  /// (-Size.sixth).isCompound == false
  /// Size.octave.isCompound == false
  /// Size.ninth.isCompound == true
  /// (-Size.eleventh).isCompound == true
  /// Size.thirteenth.isCompound == true
  /// ```
  bool get isCompound => abs() > Size.octave;

  /// The simplified version of this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.thirteenth.simple == Size.sixth
  /// (-Size.ninth).simple == -Size.second
  /// Size.octave.simple == Size.octave
  /// const Size(-22).simple == -Size.octave
  /// ```
  Size get simple => Size(
        isCompound ? absShift.nonZeroMod(Size.octave) * sign : size,
      );

  /// This [Size] formatted as a string.
  String format({IntervalNotation system = IntervalNotation.standard}) =>
      system.size(this);

  /// The negation of this [Size].
  ///
  /// Example:
  /// ```dart
  /// -Size.fifth == const Size(-5)
  /// -const Size(-7) == Size.seventh
  /// ```
  @redeclare
  Size operator -() => Size(-size);
}

/// An [Interval.perfect] size.
extension type const PerfectSize._(int size) implements Size {
  /// Creates a new [PerfectSize] from [size].
  const PerfectSize(this.size)
      // Copied from [Size.isPerfect] to allow const.
      : assert(
          ((size < 0 ? 0 - size : size) + (size < 0 ? 0 - size : size) ~/ 8) %
                  4 <
              2,
          'Interval must be perfect.',
        );

  /// The [PerfectQuality.perfect] interval from this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.unison.perfect == Interval.P1
  /// Size.fourth.perfect == Interval.P4
  /// (-Size.fifth).perfect == -Interval.P5
  /// ```
  Interval get perfect => isPerfect
      ? Interval.perfect(this)
      : (throw ArgumentError.value(this, 'size', 'Invalid perfect size'));

  /// The negation of this [PerfectSize].
  ///
  /// Example:
  /// ```dart
  /// -Size.fifth == const Size(-5)
  /// -const Size(-8) == Size.octave
  /// ```
  @redeclare
  PerfectSize operator -() => PerfectSize(-size);
}

/// An [Interval.imperfect] size.
extension type const ImperfectSize._(int size) implements Size {
  /// Creates a new [ImperfectSize] from [size].
  const ImperfectSize(this.size)
      // Copied from [Size.isPerfect] to allow const.
      : assert(
          ((size < 0 ? 0 - size : size) + (size < 0 ? 0 - size : size) ~/ 8) %
                  4 >=
              2,
          'Interval must be imperfect.',
        );

  /// The [ImperfectQuality.major] interval from this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.second.major == Interval.M2
  /// Size.sixth.major == Interval.M6
  /// (-Size.ninth).major == -Interval.M9
  /// ```
  Interval get major => isPerfect
      ? (throw ArgumentError.value(this, 'size', 'Invalid imperfect size'))
      : Interval.imperfect(this, ImperfectQuality.major);

  /// The [ImperfectQuality.minor] interval from this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.third.minor == Interval.m3
  /// Size.seventh.minor == Interval.m7
  /// (-Size.sixth).minor == -Interval.m6
  /// ```
  Interval get minor => isPerfect
      ? (throw ArgumentError.value(this, 'size', 'Invalid imperfect size'))
      : Interval.imperfect(this, ImperfectQuality.minor);

  /// The negation of this [ImperfectSize].
  ///
  /// Example:
  /// ```dart
  /// -Size.third == const Size(-3)
  /// -const Size(-7) == Size.seventh
  /// ```
  @redeclare
  ImperfectSize operator -() => ImperfectSize(-size);
}
