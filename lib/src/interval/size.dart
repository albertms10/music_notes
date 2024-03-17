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
    final octaveShift = chromaticDivisions * (absShift ~/ octave);
    // We exclude perfect octaves (simplified as 8) from the lookup to consider
    // them 0 (as if they were modulo `Size.octave`).
    final size = Size(simpleAbs == octave ? 1 : simpleAbs);

    return (_sizeToSemitones[size]! + octaveShift) * sign;
  }

  /// The absolute [Size] value taking octave shift into account.
  int get absShift {
    final sizeAbs = abs();

    return sizeAbs + sizeAbs ~/ octave;
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

  static int _inverted(Size size) {
    final diff = 9 - size.simple.size.abs();

    return (diff.isNegative ? diff.abs() + 2 : diff) * size.sign;
  }

  /// The inverted of this [Size].
  ///
  /// Example:
  /// ```dart
  /// Size.third.inverted == Size.sixth
  /// Size.fourth.inverted == Size.fifth
  /// Size.seventh.inverted == Size.second
  /// (-Size.unison).inverted == -Size.octave
  /// ```
  ///
  /// If this [Size] is greater than [Size.octave], the simplified inversion
  /// is returned instead.
  ///
  /// Example:
  /// ```dart
  /// Size.ninth.inverted == Size.seventh
  /// Size.eleventh.inverted == Size.fifth
  /// ```
  Size get inverted => Size(_inverted(this));

  static int _simple(Size size) =>
      size.isCompound ? size.absShift.nonZeroMod(octave) * size.sign : size;

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

  /// Whether this [Size] conforms a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isPerfect == true
  /// Size.sixth.isPerfect == false
  /// (-Size.eleventh).isPerfect == true
  /// ```
  bool get isPerfect => absShift % (octave / 2) < 2;

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
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 < 2,
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
  PerfectSize get inverted => PerfectSize(Size._inverted(this));

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
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 >= 2,
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
  ImperfectSize get inverted => ImperfectSize(Size._inverted(this));

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
