part of '../../music_notes.dart';

/// Distance between two notes.
@immutable
class Interval implements MusicItem {
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
          Quality.fromInterval(size, semitones - size.semitones),
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
    final intervals = EnharmonicInterval(semitones).items;

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
  /// -Interval.majorThird.semitones == -4
  /// ```
  @override
  int get semitones => (size.semitones.abs() + quality.semitones) * size.sign;

  /// Returns the inverted of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.minorThird.inverted == Interval.majorSixth
  /// Interval.perfectUnison.inverted == Interval.perfectOctave
  /// ```
  Interval get inverted => Interval._(size.inverted, quality.inverted);

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
  String toString() => '${quality.abbreviation}$size';

  @override
  bool operator ==(Object other) =>
      other is Interval && size == other.size && quality == other.quality;

  @override
  int get hashCode => hash2(size, quality);

  @override
  int compareTo(covariant Interval other) => compareMultiple([
        () => size.compareTo(other.size),
        () => semitones.compareTo(other.semitones),
      ]);
}
