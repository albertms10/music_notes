import 'package:collection/collection.dart' show IterableExtension, minBy;
import 'package:meta/meta.dart' show redeclare;
import 'package:music_notes/utils.dart';

import '../formatter.dart';
import '../tuning/equal_temperament.dart';
import 'interval.dart';
import 'quality.dart';

/// An [Interval] size.
extension type const Size._(int size) implements int {
  /// Creates a new [Size] from [size].
  const Size(this.size) : assert(size != 0, 'Value must be non-zero.');

  /// A unison [PerfectSize].
  static const unison = PerfectSize(1);

  /// A second [ImperfectSize].
  static const second = ImperfectSize(2);

  /// A third [ImperfectSize].
  static const third = ImperfectSize(3);

  /// A fourth [PerfectSize].
  static const fourth = PerfectSize(4);

  /// A fifth [PerfectSize].
  static const fifth = PerfectSize(5);

  /// A sixth [ImperfectSize].
  static const sixth = ImperfectSize(6);

  /// A seventh [ImperfectSize].
  static const seventh = ImperfectSize(7);

  /// An octave [PerfectSize].
  static const octave = PerfectSize(8);

  /// A ninth [ImperfectSize].
  static const ninth = ImperfectSize(9);

  /// A tenth [ImperfectSize].
  static const tenth = ImperfectSize(10);

  /// An eleventh [PerfectSize].
  static const eleventh = PerfectSize(11);

  /// A twelfth [PerfectSize].
  static const twelfth = PerfectSize(12);

  /// A thirteenth [ImperfectSize].
  static const thirteenth = ImperfectSize(13);

  /// [Size] to the corresponding [ImperfectQuality.minor] or
  /// [PerfectQuality.perfect] semitones.
  static const _sizeToSemitones = {
    unison: 0, // P
    second: 1, // m
    third: 3, // m
    fourth: 5, // P
    fifth: 7, // P
    sixth: 8, // m
    seventh: 10, // m
    octave: 12, // P
  };

  /// Map a semitones value to a value between 0 and 12.
  static int _normalizeSemitones(int semitones) {
    final absSemitones = semitones.abs();

    return absSemitones == chromaticDivisions
        ? chromaticDivisions
        : absSemitones % chromaticDivisions;
  }

  /// Scale a given normalized [Size] (one of the entries in [_sizeToSemitones])
  /// to the given [semitones].
  factory Size._scaleToSemitones(Size normalizedSize, int semitones) {
    final absSemitones = semitones.abs();
    if (absSemitones == chromaticDivisions) {
      return Size(normalizedSize * semitones.sign);
    }

    final absResult = normalizedSize + (absSemitones ~/ chromaticDivisions) * 7;

    return Size(absResult * semitones.nonZeroSign);
  }

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
    final normalizedSemitones = _normalizeSemitones(semitones);
    final matchingSize = _sizeToSemitones.entries
        .firstWhereOrNull((entry) => entry.value == normalizedSemitones)
        ?.key;
    if (matchingSize == null) return null;

    return Size._scaleToSemitones(matchingSize, semitones);
  }

  /// The [Size] that is nearest, truncating towards zero, to the given
  /// interval in [semitones].
  factory Size.nearestFromSemitones(int semitones) {
    final normalizedSemitones = _normalizeSemitones(semitones);
    final MapEntry<Size, int>(key: closest) = minBy(
      _sizeToSemitones.entries,
      (entry) => (normalizedSemitones - entry.value).abs(),
    )!;

    return Size._scaleToSemitones(closest, semitones);
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
    final absSimple = simple.abs();
    final octaves = (abs() - absSimple) ~/ 7;

    return (_sizeToSemitones[absSimple]! + octaves * 12) * sign;
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

  static int _inversion(Size size) {
    final diff = 9 - size.simple.size.abs();

    return (diff.isNegative ? diff.abs() + 2 : diff) * size.sign;
  }

  /// The inversion of this [Size].
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// Size.third.inversion == Size.sixth
  /// Size.fourth.inversion == Size.fifth
  /// Size.seventh.inversion == Size.second
  /// (-Size.unison).inversion == -Size.octave
  /// ```
  ///
  /// If this [Size] is greater than [Size.octave], the simplified inversion
  /// is returned instead.
  ///
  /// Example:
  /// ```dart
  /// Size.ninth.inversion == Size.seventh
  /// Size.eleventh.inversion == Size.fifth
  /// ```
  Size get inversion => Size(_inversion(this));

  static int _simple(Size size) =>
      size.isCompound ? ((size.abs() - 1).nonZeroMod(7) + 1) * size.sign : size;

  /// The simplified version of this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.thirteenth.simple == Size.sixth
  /// (-Size.ninth).simple == -Size.second
  /// Size.octave.simple == Size.octave
  /// const Size(-22).simple == -Size.octave
  /// ```
  Size get simple => Size(_simple(this));

  /// Whether this [Size] conforms a [PerfectQuality] interval.
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isPerfect == true
  /// Size.sixth.isPerfect == false
  /// (-Size.eleventh).isPerfect == true
  /// ```
  bool get isPerfect =>
      // This operation uses a bitmask implementation, equivalent to the more
      // readable pattern:
      //
      // ```dart
      // (abs() % 7 case Size.unison || Size.fourth || Size.fifth)
      // ```
      //
      // In the bitmask, each bit represents a [Size] within the octave cycle
      // (modulo 7). Perfect intervals occur at positions:
      //
      // - 1 for [Size.unison],
      // - 4 for [Size.fourth], and
      // - 5 for [Size.fifth].
      //
      // The number 50 (which is `0b0110010` in binary) has bits set at these
      // positions:
      //
      // ```
      //  2^ 6 5 4 3 2 1 0
      //     -------------
      //     0 1 1 0 0 1 0
      //       ^ ^     ^
      // ```
      //
      // - `abs() % 7` computes the [Size] modulo 7, mapping it to its position
      //   within the octave cycle.
      // - `1 <<` creates a bitmask with a single bit set at the position
      //   corresponding to the [Size].
      // - Performing a bitwise AND `&` with 50 (`0b0110010`) checks if this bit
      //   corresponds to a perfect interval size.
      // - The expression `!= 0` returns `true` if the result is non-zero
      //   (e.g., the [Size] is perfect) and `false` otherwise.
      //
      ((1 << (abs() % 7)) & 50) != 0;

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
  bool get isCompound => abs() > octave;

  /// Whether this [Size] is dissonant.
  ///
  /// Example:
  /// ```dart
  /// Size.unison.isDissonant == false
  /// Size.fifth.isDissonant == false
  /// Size.seventh.isDissonant == true
  /// (-Size.ninth).isDissonant == true
  /// ```
  bool get isDissonant {
    if (simple.size.abs() case second || seventh) return true;

    return false;
  }

  /// This [Size] formatted as a string.
  String format({SizeFormatter system = const SizeFormatter()}) =>
      system.format(this);

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
        ((1 << ((size < 0 ? -size : size) % 7)) & 50) != 0,
        'Interval must be perfect.',
      );

  /// The [PerfectQuality.perfect] interval from this [PerfectSize].
  ///
  /// Example:
  /// ```dart
  /// Size.unison.perfect == Interval.P1
  /// Size.fourth.perfect == Interval.P4
  /// (-Size.fifth).perfect == -Interval.P5
  /// ```
  Interval get perfect => Interval.perfect(this);

  @redeclare
  PerfectSize get inversion => PerfectSize(Size._inversion(this));

  @redeclare
  PerfectSize get simple => PerfectSize(Size._simple(this));

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
        ((1 << ((size < 0 ? -size : size) % 7)) & 50) == 0,
        'Interval must be imperfect.',
      );

  /// The [ImperfectQuality.major] interval from this [ImperfectSize].
  ///
  /// Example:
  /// ```dart
  /// Size.second.major == Interval.M2
  /// Size.sixth.major == Interval.M6
  /// (-Size.ninth).major == -Interval.M9
  /// ```
  Interval get major => Interval.imperfect(this, ImperfectQuality.major);

  /// The [ImperfectQuality.minor] interval from this [ImperfectSize].
  ///
  /// Example:
  /// ```dart
  /// Size.third.minor == Interval.m3
  /// Size.seventh.minor == Interval.m7
  /// (-Size.sixth).minor == -Interval.m6
  /// ```
  Interval get minor => Interval.imperfect(this, ImperfectQuality.minor);

  @redeclare
  ImperfectSize get inversion => ImperfectSize(Size._inversion(this));

  @redeclare
  ImperfectSize get simple => ImperfectSize(Size._simple(this));

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

/// A [Size] formatter.
class SizeFormatter extends Formatter<Size> {
  /// Creates a new [SizeFormatter].
  const SizeFormatter();

  @override
  String format(Size size) => '$size';

  @override
  Size parse(String source) => Size(int.parse(source));
}
