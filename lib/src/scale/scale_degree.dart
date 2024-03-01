import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../harmony/chord.dart';
import '../interval/quality.dart';
import '../note/accidental.dart';
import 'scale.dart';

/// A scale degree.
///
/// ---
/// See also:
/// * [Scale].
@immutable
class ScaleDegree implements Comparable<ScaleDegree> {
  /// The ordinal that identifies this [ScaleDegree].
  final int ordinal;

  /// The inversion of the [Chord] above this [ScaleDegree].
  final int inversion;

  /// The quality of the [Chord] above this [ScaleDegree].
  final ImperfectQuality? quality;

  /// The semitones raising or lowering this [ScaleDegree]’s root note.
  final int semitonesDelta;

  /// Creates a new [ScaleDegree].
  const ScaleDegree(
    this.ordinal, {
    this.quality,
    this.inversion = 0,
    this.semitonesDelta = 0,
  })  : assert(ordinal > 0, 'Ordinal must be greater than zero.'),
        assert(inversion >= 0, 'Inversion must be greater or equal than zero.');

  /// The I (tonic) [ScaleDegree].
  static const i = ScaleDegree(1);

  /// The II [ScaleDegree].
  static const ii = ScaleDegree(2);

  /// The neapolitan sixth [ScaleDegree].
  static const neapolitanSixth = ScaleDegree(
    2,
    quality: ImperfectQuality.major,
    inversion: 1,
    semitonesDelta: -1,
  );

  /// The III [ScaleDegree].
  static const iii = ScaleDegree(3);

  /// The IV [ScaleDegree].
  static const iv = ScaleDegree(4);

  /// The V [ScaleDegree].
  static const v = ScaleDegree(5);

  /// The VI [ScaleDegree].
  static const vi = ScaleDegree(6);

  /// The VII [ScaleDegree].
  static const vii = ScaleDegree(7);

  /// Whether this [ScaleDegree] is raised.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.raised.isRaised == true
  /// ScaleDegree.neapolitanSixth.isRaised == false
  /// ```
  bool get isRaised => semitonesDelta > 0;

  /// Whether this [ScaleDegree] is lowered.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.isLowered == false
  /// ScaleDegree.neapolitanSixth.isLowered == true
  /// ```
  bool get isLowered => semitonesDelta.isNegative;

  /// This [ScaleDegree] raised by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.raised == const ScaleDegree(6, semitonesDelta: 1)
  /// ```
  ScaleDegree get raised => ScaleDegree(
        ordinal,
        quality: quality,
        inversion: inversion,
        semitonesDelta: semitonesDelta + 1,
      );

  /// This [ScaleDegree] lowered by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.lowered == const ScaleDegree(2, semitonesDelta: -1)
  /// ```
  ScaleDegree get lowered => ScaleDegree(
        ordinal,
        quality: quality,
        inversion: inversion,
        semitonesDelta: semitonesDelta - 1,
      );

  /// This [ScaleDegree] as [ImperfectQuality.major].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.major
  ///   == const ScaleDegree(2, quality: ImperfectQuality.major)
  /// ```
  ScaleDegree get major => ScaleDegree(
        ordinal,
        quality: ImperfectQuality.major,
        inversion: inversion,
        semitonesDelta: semitonesDelta,
      );

  /// This [ScaleDegree] as [ImperfectQuality.minor].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.v.minor
  ///   == const ScaleDegree(5, quality: ImperfectQuality.minor)
  /// ```
  ScaleDegree get minor => ScaleDegree(
        ordinal,
        quality: ImperfectQuality.minor,
        inversion: inversion,
        semitonesDelta: semitonesDelta,
      );

  @override
  String toString({
    ScaleDegreeNotation system = ScaleDegreeNotation.standard,
  }) =>
      system.scaleDegree(this);

  @override
  bool operator ==(Object other) =>
      other is ScaleDegree &&
      ordinal == other.ordinal &&
      inversion == other.inversion &&
      quality == other.quality &&
      semitonesDelta == other.semitonesDelta;

  @override
  int get hashCode => Object.hash(ordinal, inversion, quality, semitonesDelta);

  @override
  int compareTo(ScaleDegree other) => compareMultiple([
        () => ordinal.compareTo(other.ordinal),
        () => semitonesDelta.compareTo(other.semitonesDelta),
        () => inversion.compareTo(other.inversion),
        () {
          if (quality != null && other.quality != null) {
            return quality!.compareTo(other.quality!);
          }
          if (quality != null) return -1;
          if (other.quality != null) return 1;

          return 0;
        },
      ]);
}

/// The abstraction for [ScaleDegree] notation systems.
@immutable
abstract class ScaleDegreeNotation {
  /// Creates a new [ScaleDegreeNotation].
  const ScaleDegreeNotation();

  /// The standard [ScaleDegreeNotation] system.
  static const standard = StandardScaleDegreeNotation();

  /// The movable Do [ScaleDegreeNotation] system.
  static const movableDo = MovableDoScaleDegreeNotation();

  /// The string notation for [scaleDegree].
  String scaleDegree(ScaleDegree scaleDegree);
}

/// The standard [ScaleDegree] notation system.
final class StandardScaleDegreeNotation extends ScaleDegreeNotation {
  /// Creates a new [StandardScaleDegreeNotation].
  const StandardScaleDegreeNotation();

  @override
  String scaleDegree(ScaleDegree scaleDegree) {
    final buffer = StringBuffer();
    if (scaleDegree.semitonesDelta != 0) {
      buffer.write(Accidental(scaleDegree.semitonesDelta).symbol);
    }
    final romanNumeral = switch (scaleDegree.ordinal) {
      1 => 'I',
      2 => 'II',
      3 => 'III',
      4 => 'IV',
      5 => 'V',
      6 => 'VI',
      7 => 'VII',
      _ => '',
    };

    if (scaleDegree.quality != null && scaleDegree.quality!.semitones <= 0) {
      buffer.write(romanNumeral.toLowerCase());
    } else {
      buffer.write(romanNumeral);
    }

    switch (scaleDegree.inversion) {
      case 1:
        buffer.write('6');
      case 2:
        buffer.write('64');
    }

    return buffer.toString();
  }
}

/// The movable Do [ScaleDegree] notation system.
///
/// See [Movable Do solfège](https://en.wikipedia.org/wiki/Solf%C3%A8ge#Movable_do_solf%C3%A8ge).
final class MovableDoScaleDegreeNotation extends ScaleDegreeNotation {
  /// Creates a new [MovableDoScaleDegreeNotation].
  const MovableDoScaleDegreeNotation();

  @override
  String scaleDegree(ScaleDegree scaleDegree) => switch (scaleDegree) {
        ScaleDegree(ordinal: 1) => switch (scaleDegree) {
            _ when scaleDegree.isRaised => 'Di',
            _ => 'Do',
          },
        ScaleDegree(ordinal: 2) => switch (scaleDegree) {
            _ when scaleDegree.isLowered => 'Ra',
            _ when scaleDegree.isRaised => 'Ri',
            _ => 'Re',
          },
        ScaleDegree(ordinal: 3) => switch (scaleDegree) {
            _ when scaleDegree.isLowered => 'Me',
            _ => 'Mi',
          },
        ScaleDegree(ordinal: 4) => switch (scaleDegree) {
            _ when scaleDegree.isRaised => 'Fi',
            _ => 'Fa',
          },
        ScaleDegree(ordinal: 5) => switch (scaleDegree) {
            _ when scaleDegree.isLowered => 'Se',
            _ when scaleDegree.isRaised => 'Si',
            _ => 'Sol',
          },
        ScaleDegree(ordinal: 6) => switch (scaleDegree) {
            _ when scaleDegree.isLowered => 'Le',
            _ when scaleDegree.isRaised => 'Li',
            _ => 'La',
          },
        ScaleDegree(ordinal: 7) => switch (scaleDegree) {
            _ when scaleDegree.isLowered => 'Te',
            _ => 'Ti',
          },
        _ =>
          throw FormatException('Unsupported ScaleDegree', scaleDegree.ordinal),
      };
}
