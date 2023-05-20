part of '../../music_notes.dart';

/// Distance between two notes.
@immutable
final class Interval implements Comparable<Interval> {
  /// Number of lines and spaces (or alphabet letters) spanning the two notes,
  /// including the beginning and end.
  final int size;

  /// The quality of this [Interval].
  ///
  /// Must be an instance of [PerfectQuality] or
  /// [ImperfectQuality], depending on the nature of the interval.
  final Quality quality;

  const Interval._(this.size, this.quality)
      : assert(size != 0, 'Size must be non-zero');

  static const diminishedUnison =
      Interval.perfect(1, PerfectQuality.diminished);
  static const perfectUnison = Interval.perfect(1, PerfectQuality.perfect);
  static const augmentedUnison = Interval.perfect(1, PerfectQuality.augmented);

  static const diminishedSecond =
      Interval.imperfect(2, ImperfectQuality.diminished);
  static const minorSecond = Interval.imperfect(2, ImperfectQuality.minor);
  static const majorSecond = Interval.imperfect(2, ImperfectQuality.major);
  static const augmentedSecond =
      Interval.imperfect(2, ImperfectQuality.augmented);

  static const diminishedThird =
      Interval.imperfect(3, ImperfectQuality.diminished);
  static const minorThird = Interval.imperfect(3, ImperfectQuality.minor);
  static const majorThird = Interval.imperfect(3, ImperfectQuality.major);
  static const augmentedThird =
      Interval.imperfect(3, ImperfectQuality.augmented);

  static const diminishedFourth =
      Interval.perfect(4, PerfectQuality.diminished);
  static const perfectFourth = Interval.perfect(4, PerfectQuality.perfect);
  static const augmentedFourth = Interval.perfect(4, PerfectQuality.augmented);

  static const diminishedFifth = Interval.perfect(5, PerfectQuality.diminished);
  static const perfectFifth = Interval.perfect(5, PerfectQuality.perfect);
  static const augmentedFifth = Interval.perfect(5, PerfectQuality.augmented);

  static const diminishedSixth =
      Interval.imperfect(6, ImperfectQuality.diminished);
  static const minorSixth = Interval.imperfect(6, ImperfectQuality.minor);
  static const majorSixth = Interval.imperfect(6, ImperfectQuality.major);
  static const augmentedSixth =
      Interval.imperfect(6, ImperfectQuality.augmented);

  static const diminishedSeventh =
      Interval.imperfect(7, ImperfectQuality.diminished);
  static const minorSeventh = Interval.imperfect(7, ImperfectQuality.minor);
  static const majorSeventh = Interval.imperfect(7, ImperfectQuality.major);
  static const augmentedSeventh =
      Interval.imperfect(7, ImperfectQuality.augmented);

  static const diminishedOctave =
      Interval.perfect(8, PerfectQuality.diminished);
  static const perfectOctave = Interval.perfect(8, PerfectQuality.perfect);
  static const augmentedOctave = Interval.perfect(8, PerfectQuality.augmented);

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(this.size, PerfectQuality this.quality)
      : assert(size != 0, 'Size must be non-zero'),
        // Copied from [IntervalSizeExtension.isPerfect] to allow const.
        assert(
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 < 2,
          'Interval must be perfect',
        );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
      : assert(size != 0, 'Size must be non-zero'),
        // Copied from [IntervalSizeExtension.isPerfect] to allow const.
        assert(
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 >= 2,
          'Interval must be imperfect',
        );

  /// Creates a new [Interval] from the [Quality] delta.
  Interval.fromDelta(int size, int delta)
      : this._(size, Quality.fromInterval(size, delta));

  /// Creates a new [Interval] from [semitones].
  Interval.fromSemitones(int size, int semitones)
      : this._(
          size,
          Quality.fromInterval(
            size,
            semitones * size.sign - size.semitones.abs(),
          ),
        );

  /// Creates a new [Interval] from [semitones] and a [preferredQuality].
  ///
  /// Example:
  /// ```dart
  /// Interval.fromSemitonesQuality(4) == Interval.minorThird
  /// Interval.fromSemitonesQuality(7) == Interval.augmentedFourth
  /// Interval.fromSemitonesQuality(7, PerfectQuality.diminished)
  ///   == Interval.diminishedFifth
  /// ```
  factory Interval.fromSemitonesQuality(
    int semitones, [
    Quality? preferredQuality,
  ]) {
    final intervals = EnharmonicInterval(semitones).spellings;

    if (preferredQuality != null) {
      final interval = intervals.firstWhereOrNull(
        (interval) => interval.quality == preferredQuality,
      );
      if (interval != null) return interval;
    }

    // Find the Interval with the smaller Quality delta semitones.
    return intervals
        .sorted(
          (a, b) =>
              a.quality.semitones.abs().compareTo(b.quality.semitones.abs()),
        )
        .first;
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.majorSecond.semitones == 2
  /// Interval.diminishedFifth.semitones == 6
  /// Interval.augmentedFourth.semitones == 6
  /// (-Interval.majorThird).semitones == -4
  /// ```
  int get semitones => (size.semitones.abs() + quality.semitones) * size.sign;

  /// Whether this [Interval] is descending.
  ///
  /// Example:
  /// ```dart
  /// Interval.majorSecond.isDescending == false
  /// (-Interval.perfectFourth).isDescending == true
  /// Interval.diminishedUnison.isDescending == false
  /// ```
  bool get isDescending => size.isNegative;

  /// Returns a copy of this [Interval] based on [isDescending].
  ///
  /// Example:
  /// ```dart
  /// Interval.minorSecond.descending() == -Interval.minorSecond
  /// Interval.majorThird.descending(isDescending: false) == Interval.majorThird
  /// (-Interval.perfectFifth).descending() == -Interval.perfectFifth
  /// (-Interval.majorSeventh).descending(isDescending: false)
  ///   == Interval.majorSeventh
  /// ```
  Interval descending({bool isDescending = true}) =>
      this.isDescending != isDescending ? -this : Interval._(size, quality);

  /// Returns the inverted of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.minorThird.inverted == Interval.majorSixth
  /// Interval.augmentedFourth.inverted == Interval.diminishedFifth
  /// Interval.majorSeventh.inverted == Interval.minorSecond
  /// Interval.perfectUnison.inverted == Interval.perfectOctave
  /// ```
  Interval get inverted => Interval._(size.inverted, quality.inverted);

  /// Adds [other] to this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.minorSecond + Interval.minorSecond == Interval.diminishedThird
  /// Interval.minorSecond + Interval.majorSecond == Interval.minorThird
  /// Interval.majorSecond + Interval.perfectFourth == Interval.perfectFifth
  /// ```
  Interval operator +(Interval other) {
    final initialNote = Note.c.inOctave(4);
    final finalNote = initialNote.transposeBy(this).transposeBy(other);

    return initialNote.interval(finalNote);
  }

  /// The negation of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// -Interval.minorThird
  ///   == const Interval.imperfect(-3, ImperfectQuality.minor)
  /// -const Interval.perfect(-5, PerfectQuality.perfect)
  ///   == Interval.perfectFifth
  /// ```
  Interval operator -() => Interval._(-size, quality);

  @override
  String toString() {
    final qualityAbbreviation =
        quality.abbreviation ?? '[${quality.semitones.toDeltaString()}]';
    final naming = '$qualityAbbreviation${size.abs()}';
    final descendingAbbreviation = isDescending ? 'desc ' : '';
    if (size.isCompound) {
      return '$descendingAbbreviation$naming '
          '($qualityAbbreviation${size.simplified.abs()})';
    }

    return '$descendingAbbreviation$naming';
  }

  @override
  bool operator ==(Object other) =>
      other is Interval && size == other.size && quality == other.quality;

  @override
  int get hashCode => Object.hash(size, quality);

  @override
  int compareTo(Interval other) => compareMultiple([
        () => size.compareTo(other.size),
        () => semitones.compareTo(other.semitones),
      ]);
}
