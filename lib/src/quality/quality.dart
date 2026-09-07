import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import 'quality_notation.dart';

/// The half-step refinement that, combined with a [Size], fully specifies
/// an [Interval] — distinguishing, say, a major third from a minor or
/// augmented one, all of which share [Size.third].
///
/// Which subtype applies is dictated entirely by [Size]:
/// [PerfectSize]s (unison, fourth, fifth, octave, ...) take
/// [PerfectQuality], where diminished/perfect/augmented sit at
/// `-1/0/+1` semitones; [ImperfectSize]s (second, third, sixth, seventh,
/// ...) take [ImperfectQuality], where diminished/minor/major/augmented
/// sit at `-1/0/1/2` semitones. [semitones] in both cases is a *delta*
/// from that quality family's own zero point, not a semitone count on
/// its own — [Interval.semitones] is what combines it with [Size] into
/// an absolute distance.
///
/// ---
/// See also:
/// * [Interval].
/// * [PerfectQuality].
/// * [ImperfectQuality].
@immutable
sealed class Quality implements Comparable<Quality> {
  /// This quality's deviation, in semitones, from its family's zero point
  /// (perfect for [PerfectQuality], minor for [ImperfectQuality]).
  final int semitones;

  /// Creates a new [Quality] deviating by [semitones] from its family's
  /// zero point.
  const Quality(this.semitones);

  /// This [Quality] with its diminished/augmented direction reversed,
  /// mirroring how a size inverts (a major interval's inversion is
  /// minor, and vice versa; a perfect interval's inversion stays
  /// perfect).
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  Quality get inversion;

  /// Whether an interval built with this [Quality] is dissonant on its
  /// own terms — perfect and major/minor qualities are consonant,
  /// diminished and augmented qualities are dissonant regardless of size
  /// (see [Interval.isDissonant] for the size-dependent full rule).
  bool get isDissonant;

  @override
  bool operator ==(Object other) =>
      other is Quality && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Quality other) => compareMultiple([
    () => semitones.compareTo(other.semitones),
    () {
      if (this is PerfectQuality && other is ImperfectQuality) {
        return 1;
      }
      if (this is ImperfectQuality && other is PerfectQuality) {
        return -1;
      }
      return 0;
    },
  ]);
}

/// The quality of a [PerfectSize] interval (unison, fourth, fifth,
/// octave, and their compounds): diminished, perfect, or augmented, with
/// no major/minor distinction — perfect intervals only shrink or grow
/// symmetrically around their exact, most-consonant span.
final class PerfectQuality extends Quality
    implements Formattable<PerfectQuality> {
  /// This quality's deviation in semitones from perfect (0), positive for
  /// augmented, negative for diminished.
  @override
  int get semitones;

  /// Creates a new [PerfectQuality] deviating by [semitones] from
  /// perfect.
  const PerfectQuality(super.semitones);

  /// Diminished by 3 semitones from perfect.
  static const triplyDiminished = PerfectQuality(-3);

  /// Diminished by 2 semitones from perfect.
  static const doublyDiminished = PerfectQuality(-2);

  /// Diminished by 1 semitone from perfect (e.g. a diminished fifth).
  static const diminished = PerfectQuality(-1);

  /// Exactly the interval's default span, neither widened nor narrowed
  /// (e.g. a perfect fifth).
  static const perfect = PerfectQuality(0);

  /// Widened by 1 semitone from perfect (e.g. an augmented fourth).
  static const augmented = PerfectQuality(1);

  /// Widened by 2 semitones from perfect.
  static const doublyAugmented = PerfectQuality(2);

  /// Widened by 3 semitones from perfect.
  static const triplyAugmented = PerfectQuality(3);

  /// The chain of [StringParser]s used to parse a [PerfectQuality]: its
  /// standard `d`/`P`/`A` letter symbol, repeated for multiple diminished
  /// or augmented degrees.
  static const parsers = [PerfectQualityNotation()];

  /// Parses [source] as a [PerfectQuality] and returns its value.
  ///
  /// If [source] does not contain a valid [PerfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.parse('P') == .perfect
  /// PerfectQuality.parse('dd') == .doublyDiminished
  /// PerfectQuality.parse('z') // throws a FormatException
  /// ```
  factory PerfectQuality.parse(
    String source, {
    List<StringParser<PerfectQuality>> chain = parsers,
  }) => chain.parse(source);

  /// This [PerfectQuality] mirrored around perfect: augmented becomes
  /// diminished and vice versa, by the same number of semitones; perfect
  /// itself is its own inversion.
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.inversion == .perfect
  /// PerfectQuality.augmented.inversion == .diminished
  /// ```
  @override
  PerfectQuality get inversion => PerfectQuality(-semitones);

  /// Whether this [PerfectQuality] deviates at all from [perfect] — any
  /// diminished or augmented degree is dissonant, [perfect] alone is not.
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.isDissonant == false
  /// PerfectQuality.diminished.isDissonant == true
  /// PerfectQuality.augmented.isDissonant == true
  /// ```
  @override
  bool get isDissonant => semitones != 0;

  /// The string representation of this [PerfectQuality], using
  /// [formatter] (the standard `d`/`P`/`A` letter symbol by default).
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.format() == 'P'
  /// PerfectQuality.diminished.format() == 'd'
  /// PerfectQuality.doublyAugmented.format() == 'AA'
  /// ```
  @override
  String format([
    StringFormatter<PerfectQuality> formatter = const PerfectQualityNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(semitones: $semitones)';

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is PerfectQuality;
}

/// The quality of an [ImperfectSize] interval (second, third, sixth,
/// seventh, and their compounds): diminished, minor, major, or
/// augmented — the family that distinguishes, e.g., a minor third from
/// a major one, unlike the symmetric perfect/diminished/augmented-only
/// [PerfectQuality].
final class ImperfectQuality extends Quality
    implements Formattable<ImperfectQuality> {
  /// This quality's deviation in semitones from minor (0): major sits at
  /// 1, with diminished below and augmented above.
  @override
  int get semitones;

  /// Creates a new [ImperfectQuality] deviating by [semitones] from
  /// minor.
  const ImperfectQuality(super.semitones);

  /// Diminished by 3 semitones from minor.
  static const triplyDiminished = ImperfectQuality(-3);

  /// Diminished by 2 semitones from minor.
  static const doublyDiminished = ImperfectQuality(-2);

  /// Diminished by 1 semitone from minor (e.g. a diminished seventh).
  static const diminished = ImperfectQuality(-1);

  /// The smaller of the two "plain" qualities, one semitone narrower than
  /// major (e.g. a minor third).
  static const minor = ImperfectQuality(0);

  /// The larger of the two "plain" qualities, one semitone wider than
  /// minor (e.g. a major third).
  static const major = ImperfectQuality(1);

  /// Widened by 1 semitone from major (e.g. an augmented sixth).
  static const augmented = ImperfectQuality(2);

  /// Widened by 2 semitones from major.
  static const doublyAugmented = ImperfectQuality(3);

  /// Widened by 3 semitones from major.
  static const triplyAugmented = ImperfectQuality(4);

  /// The chain of [StringParser]s used to parse an [ImperfectQuality]: its
  /// standard `d`/`m`/`M`/`A` letter symbol, repeated for multiple
  /// diminished or augmented degrees.
  static const parsers = [ImperfectQualityNotation()];

  /// Parses [source] as an [ImperfectQuality] and returns its value.
  ///
  /// If [source] does not contain a valid [ImperfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.parse('m') == .minor
  /// ImperfectQuality.parse('A') == .augmented
  /// ImperfectQuality.parse('z') // throws a FormatException
  /// ```
  factory ImperfectQuality.parse(
    String source, {
    List<StringParser<ImperfectQuality>> chain = parsers,
  }) => chain.parse(source);

  /// This [ImperfectQuality] mirrored around the minor/major midpoint:
  /// minor becomes major, diminished becomes augmented, and so on —
  /// mirroring how inverting a minor interval always yields a major one
  /// (and vice versa).
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.inversion == .major
  /// ImperfectQuality.augmented.inversion == .diminished
  /// ```
  @override
  ImperfectQuality get inversion => ImperfectQuality(1 - semitones);

  /// Whether this [ImperfectQuality] falls outside [major]/[minor] — any
  /// diminished or augmented degree is dissonant, the two "plain"
  /// qualities are not.
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.major.isDissonant == false
  /// ImperfectQuality.minor.isDissonant == false
  /// ImperfectQuality.diminished.isDissonant == true
  /// ImperfectQuality.augmented.isDissonant == true
  /// ```
  @override
  bool get isDissonant {
    if (this case major || minor) return false;

    return true;
  }

  /// The string representation of this [ImperfectQuality], using
  /// [formatter] (the standard `d`/`m`/`M`/`A` letter symbol by default).
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.format() == 'm'
  /// ImperfectQuality.major.format() == 'M'
  /// ImperfectQuality.triplyDiminished.format() == 'ddd'
  /// ```
  @override
  String format([
    StringFormatter<ImperfectQuality> formatter =
        const ImperfectQualityNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(semitones: $semitones)';

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}
