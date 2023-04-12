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

  /// Whether this [Interval] is descending.
  final bool descending;

  const Interval._(this.size, this.quality, {this.descending = false});

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(
    this.size,
    PerfectQuality this.quality, {
    this.descending = false,
  }) : assert(
          // Copied from [IntIntervalExtension.isPerfect] to allow const.
          (size + size ~/ 8) % 4 == 0 || (size + size ~/ 8) % 4 == 1,
          'Interval must be perfect',
        );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(
    this.size,
    ImperfectQuality this.quality, {
    this.descending = false,
  }) : assert(
          // Copied from [IntIntervalExtension.isPerfect] to allow const.
          (size + size ~/ 8) % 4 != 0 && (size + size ~/ 8) % 4 != 1,
          'Interval must be imperfect',
        );

  /// Creates a new [Interval] from the [Quality] delta.
  Interval.fromDelta(int size, int delta)
      : this._(size, qualityFromDelta(size, delta));

  /// Creates a new [Interval] from [semitones].
  Interval.fromDesiredSemitones(int size, int semitones)
      : this._(
          size,
          qualityFromDelta(size, semitones - size.semitones),
        );

  static const Map<int, Quality Function(int)> _intervalToQuality = {
    1: PerfectQuality.new,
    2: ImperfectQuality.new,
    3: ImperfectQuality.new,
    4: PerfectQuality.new,
  };

  static Quality qualityFromDelta(int interval, int delta) {
    final simplifiedInterval = interval.simplified;
    final baseInterval = simplifiedInterval > 4
        ? simplifiedInterval.inverted
        : simplifiedInterval;
    final qualityConstructor = _intervalToQuality[baseInterval]!;

    return qualityConstructor(delta);
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval.imperfect(2, ImperfectQuality.major).semitones == 2
  ///
  /// const Interval.perfect(5, PerfectQuality.diminished).semitones
  ///   == const Interval.perfect(4, PerfectQuality.augmented).semitones
  ///   == 6
  /// ```
  @override
  int get semitones =>
      (size.semitones + quality.semitones) * (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval.imperfect(3, ImperfectQuality.minor).inverted
  ///   == const Interval.imperfect(6, ImperfectQuality.major)
  ///
  /// const Interval.perfect(1, PerfectQuality.perfect).inverted
  ///   == const Interval.perfect(8, PerfectQuality.perfect)
  /// ```
  Interval get inverted => Interval._(size.inverted, quality.inverted);

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
