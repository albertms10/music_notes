import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart' show immutable, redeclare;
import 'package:music_notes/utils.dart';

import '../music.dart';
import 'interval.dart';
import 'quality.dart';

/// An [Interval] size.
@immutable
extension type const Size._(int value) implements int {
  /// Creates a new [Size] from [value].
  const Size(this.value) : assert(value != 0, 'Value must be non-zero');

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
        isCompound ? absShift.nonZeroMod(Size.octave) * sign : value,
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
  Size operator -() => Size(-value);
}
