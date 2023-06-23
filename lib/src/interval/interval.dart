// ignore_for_file: constant_identifier_names

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

  static const d1 = Interval.perfect(1, PerfectQuality.diminished);
  static const P1 = Interval.perfect(1, PerfectQuality.perfect);
  static const A1 = Interval.perfect(1, PerfectQuality.augmented);

  static const d2 = Interval.imperfect(2, ImperfectQuality.diminished);
  static const m2 = Interval.imperfect(2, ImperfectQuality.minor);
  static const M2 = Interval.imperfect(2, ImperfectQuality.major);
  static const A2 = Interval.imperfect(2, ImperfectQuality.augmented);

  static const d3 = Interval.imperfect(3, ImperfectQuality.diminished);
  static const m3 = Interval.imperfect(3, ImperfectQuality.minor);
  static const M3 = Interval.imperfect(3, ImperfectQuality.major);
  static const A3 = Interval.imperfect(3, ImperfectQuality.augmented);

  static const d4 = Interval.perfect(4, PerfectQuality.diminished);
  static const P4 = Interval.perfect(4, PerfectQuality.perfect);
  static const A4 = Interval.perfect(4, PerfectQuality.augmented);

  static const d5 = Interval.perfect(5, PerfectQuality.diminished);
  static const P5 = Interval.perfect(5, PerfectQuality.perfect);
  static const A5 = Interval.perfect(5, PerfectQuality.augmented);

  static const d6 = Interval.imperfect(6, ImperfectQuality.diminished);
  static const m6 = Interval.imperfect(6, ImperfectQuality.minor);
  static const M6 = Interval.imperfect(6, ImperfectQuality.major);
  static const A6 = Interval.imperfect(6, ImperfectQuality.augmented);

  static const d7 = Interval.imperfect(7, ImperfectQuality.diminished);
  static const m7 = Interval.imperfect(7, ImperfectQuality.minor);
  static const M7 = Interval.imperfect(7, ImperfectQuality.major);
  static const A7 = Interval.imperfect(7, ImperfectQuality.augmented);

  static const d8 = Interval.perfect(8, PerfectQuality.diminished);
  static const P8 = Interval.perfect(8, PerfectQuality.perfect);
  static const A8 = Interval.perfect(8, PerfectQuality.augmented);

  static const d9 = Interval.imperfect(9, ImperfectQuality.diminished);
  static const m9 = Interval.imperfect(9, ImperfectQuality.minor);
  static const M9 = Interval.imperfect(9, ImperfectQuality.major);
  static const A9 = Interval.imperfect(9, ImperfectQuality.augmented);

  static const d11 = Interval.perfect(11, PerfectQuality.diminished);
  static const P11 = Interval.perfect(11, PerfectQuality.perfect);
  static const A11 = Interval.perfect(11, PerfectQuality.augmented);

  static const d13 = Interval.imperfect(13, ImperfectQuality.diminished);
  static const m13 = Interval.imperfect(13, ImperfectQuality.minor);
  static const M13 = Interval.imperfect(13, ImperfectQuality.major);
  static const A13 = Interval.imperfect(13, ImperfectQuality.augmented);

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
  /// Interval.fromSemitonesQuality(4) == Interval.m3
  /// Interval.fromSemitonesQuality(7) == Interval.A4
  /// Interval.fromSemitonesQuality(7, PerfectQuality.diminished)
  ///   == Interval.d5
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

  /// Parse [source] as an [Interval] and return its value.
  ///
  /// If the [source] string does not contain a valid [Interval], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Interval.parse('m3') == Interval.m3
  /// Interval.parse('P5') == Interval.perfectFifth
  /// Interval.parse('z') // throws a FormatException
  /// ```
  factory Interval.parse(String source) {
    final match = RegExp(r'(\w+?)(\d+)').firstMatch(source);
    if (match == null) throw FormatException('Invalid Interval', source);

    final size = int.parse(match[2]!);
    final parseFactory =
        size.isPerfect ? PerfectQuality.parse : ImperfectQuality.parse;

    return Interval._(size, parseFactory(match[1]!));
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.semitones == 2
  /// Interval.d5.semitones == 6
  /// Interval.A4.semitones == 6
  /// (-Interval.M3).semitones == -4
  /// ```
  int get semitones => (size.semitones.abs() + quality.semitones) * size.sign;

  /// Whether this [Interval] is descending.
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.isDescending == false
  /// (-Interval.P4).isDescending == true
  /// Interval.d1.isDescending == false
  /// ```
  bool get isDescending => size.isNegative;

  /// Returns a copy of this [Interval] based on [isDescending].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.descending() == -Interval.m2
  /// Interval.M3.descending(isDescending: false) == Interval.M3
  /// (-Interval.P5).descending() == -Interval.P5
  /// (-Interval.M7).descending(isDescending: false)
  ///   == Interval.M7
  /// ```
  Interval descending({bool isDescending = true}) =>
      this.isDescending != isDescending ? -this : Interval._(size, quality);

  /// Returns the inverted of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m3.inverted == Interval.M6
  /// Interval.A4.inverted == Interval.d5
  /// Interval.M7.inverted == Interval.m2
  /// Interval.P1.inverted == Interval.P8
  /// ```
  Interval get inverted => Interval._(size.inverted, quality.inverted);

  /// Returns the simplified of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.simplified == Interval.m2
  /// Interval.P11.simplified == Interval.P4
  /// Interval.M3.simplified == Interval.M3
  /// ```
  Interval get simplified => Interval._(size.simplified, quality);

  /// Returns this [Interval] respelled by [size] while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respellBySize(5) == Interval.d5
  /// Interval.d3.respellBySize(2) == Interval.M2
  /// ```
  Interval respellBySize(int size) => Interval._(
        size,
        Quality.fromInterval(size, semitones.abs() - size.semitones.abs()),
      );

  /// Returns the iteration distance of this [Interval] between [scalable1] and
  /// [scalable2].
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.distanceBetween(Note.c, Note.d) == 2
  /// Interval.P5.distanceBetween(Note.a, Note.g) == -2
  /// (-Interval.P5).distanceBetween(Note.b.flat, Note.d) == -4
  /// Interval.P4.distanceBetween(Note.f, Note.a.flat) == 3
  /// ```
  int distanceBetween<T extends Scalable<T>>(
    Scalable<T> scalable1,
    Scalable<T> scalable2,
  ) {
    var distance = 0;
    var ascendingNote = scalable1;
    var descendingNote = scalable1;
    while (true) {
      if (ascendingNote == scalable2) return distance;
      if (descendingNote == scalable2) return -distance;
      distance++;
      ascendingNote = ascendingNote.transposeBy(this);
      descendingNote = descendingNote.transposeBy(inverted);
    }
  }

  /// Returns the circle of this [Interval] from [scalable] up to [distance].
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.circleFrom(Note.c, distance: 6)
  ///   == [Note.c, Note.g, Note.d, Note.a, Note.e, Note.b, Note.f.sharp]
  ///
  /// Interval.P4.circleFrom(Note.c, distance: 5)
  ///   == [Note.c, Note.f, Note.b.flat, Note.e.flat, Note.a.flat, Note.d.flat]
  /// ```
  List<T> circleFrom<T extends Scalable<T>>(
    T scalable, {
    required int distance,
  }) =>
      distance == 0
          ? [scalable]
          : List.filled(distance.abs(), null).fold(
              [scalable],
              (circleItems, _) =>
                  [...circleItems, circleItems.last.transposeBy(this)],
            );

  /// Adds [other] to this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2 + Interval.m2 == Interval.d3
  /// Interval.m2 + Interval.M2 == Interval.m3
  /// Interval.M2 + Interval.P4 == Interval.P5
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
  /// -Interval.m3 == const Interval.imperfect(-3, ImperfectQuality.minor)
  /// -const Interval.perfect(-5, PerfectQuality.perfect) == Interval.P5
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
