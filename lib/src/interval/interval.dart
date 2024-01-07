// ignore_for_file: constant_identifier_names

part of '../../music_notes.dart';

/// Distance between two notes.
///
/// ---
/// See also:
/// * [Quality].
/// * [IntervalClass].
@immutable
final class Interval implements Comparable<Interval> {
  /// Number of lines and spaces (or alphabet letters) spanning the two notes,
  /// including the beginning and end.
  final Size size;

  /// The quality of this [Interval].
  ///
  /// Must be an instance of [PerfectQuality] or [ImperfectQuality],
  /// depending on the nature of this [Interval].
  final Quality quality;

  const Interval._(this.size, this.quality);

  /// A diminished unison [Interval].
  static const d1 = Interval.perfect(Size.unison, PerfectQuality.diminished);

  /// A perfect unison [Interval].
  static const P1 = Interval.perfect(Size.unison, PerfectQuality.perfect);

  /// An augmented unison [Interval].
  static const A1 = Interval.perfect(Size.unison, PerfectQuality.augmented);

  /// A diminished second [Interval].
  static const d2 =
      Interval.imperfect(Size.second, ImperfectQuality.diminished);

  /// A minor second [Interval].
  static const m2 = Interval.imperfect(Size.second, ImperfectQuality.minor);

  /// A major second [Interval].
  static const M2 = Interval.imperfect(Size.second, ImperfectQuality.major);

  /// An augmented second [Interval].
  static const A2 = Interval.imperfect(Size.second, ImperfectQuality.augmented);

  /// A diminished third [Interval].
  static const d3 = Interval.imperfect(Size.third, ImperfectQuality.diminished);

  /// A minor third [Interval].
  static const m3 = Interval.imperfect(Size.third, ImperfectQuality.minor);

  /// A major third [Interval].
  static const M3 = Interval.imperfect(Size.third, ImperfectQuality.major);

  /// An augmented third [Interval].
  static const A3 = Interval.imperfect(Size.third, ImperfectQuality.augmented);

  /// A diminished fourth [Interval].
  static const d4 = Interval.perfect(Size.fourth, PerfectQuality.diminished);

  /// A perfect fourth [Interval].
  static const P4 = Interval.perfect(Size.fourth, PerfectQuality.perfect);

  /// An augmented fourth [Interval].
  static const A4 = Interval.perfect(Size.fourth, PerfectQuality.augmented);

  /// A diminished fifth [Interval].
  static const d5 = Interval.perfect(Size.fifth, PerfectQuality.diminished);

  /// A perfect fifth [Interval].
  static const P5 = Interval.perfect(Size.fifth, PerfectQuality.perfect);

  /// An augmented fifth [Interval].
  static const A5 = Interval.perfect(Size.fifth, PerfectQuality.augmented);

  /// A diminished sixth [Interval].
  static const d6 = Interval.imperfect(Size.sixth, ImperfectQuality.diminished);

  /// A minor sixth [Interval].
  static const m6 = Interval.imperfect(Size.sixth, ImperfectQuality.minor);

  /// A major sixth [Interval].
  static const M6 = Interval.imperfect(Size.sixth, ImperfectQuality.major);

  /// An augmented sixth [Interval].
  static const A6 = Interval.imperfect(Size.sixth, ImperfectQuality.augmented);

  /// A diminished seventh [Interval].
  static const d7 =
      Interval.imperfect(Size.seventh, ImperfectQuality.diminished);

  /// A minor seventh [Interval].
  static const m7 = Interval.imperfect(Size.seventh, ImperfectQuality.minor);

  /// A major seventh [Interval].
  static const M7 = Interval.imperfect(Size.seventh, ImperfectQuality.major);

  /// An augmented seventh [Interval].
  static const A7 =
      Interval.imperfect(Size.seventh, ImperfectQuality.augmented);

  /// A diminished octave [Interval].
  static const d8 = Interval.perfect(Size.octave, PerfectQuality.diminished);

  /// A perfect octave [Interval].
  static const P8 = Interval.perfect(Size.octave, PerfectQuality.perfect);

  /// An augmented octave [Interval].
  static const A8 = Interval.perfect(Size.octave, PerfectQuality.augmented);

  /// A diminished ninth [Interval].
  static const d9 = Interval.imperfect(Size.ninth, ImperfectQuality.diminished);

  /// A minor ninth [Interval].
  static const m9 = Interval.imperfect(Size.ninth, ImperfectQuality.minor);

  /// A major ninth [Interval].
  static const M9 = Interval.imperfect(Size.ninth, ImperfectQuality.major);

  /// An augmented ninth [Interval].
  static const A9 = Interval.imperfect(Size.ninth, ImperfectQuality.augmented);

  /// A diminished eleventh [Interval].
  static const d11 = Interval.perfect(Size.eleventh, PerfectQuality.diminished);

  /// A perfect eleventh [Interval].
  static const P11 = Interval.perfect(Size.eleventh, PerfectQuality.perfect);

  /// An augmented eleventh [Interval].
  static const A11 = Interval.perfect(Size.eleventh, PerfectQuality.augmented);

  /// A diminished thirteenth [Interval].
  static const d13 =
      Interval.imperfect(Size.thirteenth, ImperfectQuality.diminished);

  /// A minor thirteenth [Interval].
  static const m13 =
      Interval.imperfect(Size.thirteenth, ImperfectQuality.minor);

  /// A major thirteenth [Interval].
  static const M13 =
      Interval.imperfect(Size.thirteenth, ImperfectQuality.major);

  /// An augmented thirteenth [Interval].
  static const A13 =
      Interval.imperfect(Size.thirteenth, ImperfectQuality.augmented);

  /// [Size] to the corresponding [ImperfectQuality.minor] or
  /// [PerfectQuality.perfect] semitones.
  static const Map<Size, int> _sizeToSemitones = {
    Size.unison: 0, // P
    Size.second: 1, // m
    Size.third: 3, // m
    Size.fourth: 5, // P
    Size.fifth: 7, // P
    Size.sixth: 8, // m
    Size.seventh: 10, // m
    Size.octave: 12, // P
  };

  static final RegExp _intervalRegExp = RegExp(r'(\w+?)(\d+)');

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(this.size, PerfectQuality this.quality)
      // Copied from [_IntervalSize._isPerfect] to allow const.
      : assert(
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 < 2,
          'Interval must be perfect',
        );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
      // Copied from [_IntervalSize._isPerfect] to allow const.
      : assert(
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 >= 2,
          'Interval must be imperfect',
        );

  /// Creates a new [Interval] from [Quality.semitones].
  factory Interval.fromQualityDelta(Size size, int delta) {
    final qualityConstructor =
        size.isPerfect ? PerfectQuality.new : ImperfectQuality.new;

    return Interval._(size, qualityConstructor(delta));
  }

  /// Creates a new [Interval] from [semitones].
  factory Interval.fromSemitones(Size size, int semitones) =>
      Interval.fromQualityDelta(
        size,
        semitones * size.value.sign - size.semitones.abs(),
      );

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
    final match = _intervalRegExp.firstMatch(source);
    if (match == null) throw FormatException('Invalid Interval', source);

    final size = Size(int.parse(match[2]!));
    final parseFactory =
        size.isPerfect ? PerfectQuality.parse : ImperfectQuality.parse;

    return Interval._(size, parseFactory(match[1]!));
  }

  /// Returns the [Size] that matches with [semitones] in [_sizeToSemitones],
  /// otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// Interval.sizeFromSemitones(8) == Size.sixth
  /// Interval.sizeFromSemitones(0) == Size.unison
  /// Interval.sizeFromSemitones(-12) == -Size.octave
  /// Interval.sizeFromSemitones(4) == null
  /// ```
  static Size? sizeFromSemitones(int semitones) {
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
      return Size(matchingSize.value * semitones.sign);
    }

    final absResult =
        matchingSize.value + (absoluteSemitones ~/ chromaticDivisions) * 7;

    return Size(absResult * semitones.nonZeroSign);
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
  int get semitones =>
      (size.semitones.abs() + quality.semitones) * size.value.sign;

  /// Whether this [Interval] is descending.
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.isDescending == false
  /// (-Interval.P4).isDescending == true
  /// Interval.d1.isDescending == false
  /// ```
  bool get isDescending => size.value.isNegative;

  /// Returns a copy of this [Interval] based on [isDescending].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.descending() == -Interval.m2
  /// Interval.M3.descending(isDescending: false) == Interval.M3
  /// (-Interval.P5).descending() == -Interval.P5
  /// (-Interval.M7).descending(isDescending: false) == Interval.M7
  /// ```
  Interval descending({bool isDescending = true}) =>
      Interval._(size * (this.isDescending == isDescending ? 1 : -1), quality);

  /// Returns the inverted of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m3.inverted == Interval.M6
  /// Interval.A4.inverted == Interval.d5
  /// Interval.M7.inverted == Interval.m2
  /// (-Interval.P1).inverted == -Interval.P8
  /// ```
  ///
  /// If this [Interval] is greater than an octave, the simplified inversion is
  /// returned instead.
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.inverted == Interval.M7
  /// Interval.P11.inverted == Interval.P5
  /// ```
  Interval get inverted {
    final diff = 9 - simplified.size.value.abs();
    final invertedSize =
        Size((diff.isNegative ? diff.abs() + 2 : diff) * size.value.sign);

    return Interval._(invertedSize, quality.inverted);
  }

  /// Returns the simplified of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.simplified == Interval.m2
  /// Interval.P11.simplified == Interval.P4
  /// Interval.P8.simplified == Interval.P8
  /// (-Interval.M3).simplified == -Interval.M3
  /// ```
  Interval get simplified => Interval._(size.simplified, quality);

  /// Returns whether this [Interval] is greater than an octave.
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.isCompound == false
  /// (-Interval.m6).isCompound == false
  /// Interval.P8.isCompound == false
  /// Interval.M9.isCompound == true
  /// (-Interval.P11).isCompound == true
  /// Interval.m13.isCompound == true
  /// ```
  bool get isCompound => size.isCompound;

  /// Whether this [Interval] is dissonant.
  ///
  /// Example:
  /// ```dart
  /// Interval.P1.isDissonant == false
  /// Interval.P5.isDissonant == false
  /// Interval.d5.isDissonant == true
  /// Interval.M7.isDissonant == true
  /// (-Interval.m9).isDissonant == true
  /// ```
  bool get isDissonant =>
      switch (quality) {
        PerfectQuality(:final semitones) => semitones != 0,
        ImperfectQuality(:final semitones) =>
          semitones.isNegative && semitones > 1,
      } ||
      const {2, 7}.contains(simplified.size.value.abs());

  /// Returns this [Interval] respelled by [size] while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respellBySize(const Size.fifth) == Interval.d5
  /// Interval.d3.respellBySize(const Size.second) == Interval.M2
  /// ```
  Interval respellBySize(Size size) => Interval.fromSemitones(size, semitones);

  /// Returns the iteration distance of this [Interval] between [scalable1] and
  /// [scalable2], including all visited `notes`.
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.distanceBetween(Note.c, Note.d)
  ///   == (2, notes: const [Note.c, Note.g, Note.d])
  /// Interval.P5.distanceBetween(Note.a, Note.g)
  ///   == (-2, notes: const [Note.a, Note.d, Note.g])
  /// (-Interval.P5).distanceBetween(Note.b.flat, Note.d)
  ///   == (-4, notes: [Note.b.flat, Note.f, Note.d, Note.g, Note.d])
  /// Interval.P4.distanceBetween(Note.f, Note.a.flat)
  ///   == (3, notes: [Note.f, Note.b.flat, Note.e.flat, Note.a.flat])
  /// ```
  (int distance, {List<Scalable<T>> notes})
      distanceBetween<T extends Scalable<T>>(T scalable1, T scalable2) {
    var distance = 0;
    final ascendingNotes = [scalable1];
    final descendingNotes = [scalable1];
    while (true) {
      if (ascendingNotes.last == scalable2) {
        return (distance, notes: ascendingNotes);
      }
      if (descendingNotes.last == scalable2) {
        return (-distance, notes: descendingNotes);
      }
      distance++;
      ascendingNotes.add(ascendingNotes.last.transposeBy(this));
      descendingNotes.add(descendingNotes.last.transposeBy(inverted));
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
  ///
  /// Interval.P4.circleFrom(Note.c, distance: -3)
  ///   == Interval.P5.circleFrom(Note.c, distance: 3)
  /// ```
  List<T> circleFrom<T extends Scalable<T>>(
    T scalable, {
    required int distance,
  }) =>
      List.filled(distance.abs(), null).fold(
        [scalable],
        (circleItems, _) => [
          ...circleItems,
          circleItems.last
              .transposeBy(descending(isDescending: distance.isNegative)),
        ],
      );

  /// Creates a new [IntervalClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.toClass() == IntervalClass.m2
  /// Interval.d4.toClass() == IntervalClass.M3
  /// Interval.P8.toClass() == IntervalClass.P1
  /// ```
  IntervalClass toClass() => IntervalClass(semitones);

  /// Adds [other] to this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2 + Interval.m2 == Interval.d3
  /// Interval.m2 + Interval.M2 == Interval.m3
  /// Interval.M2 + Interval.P4 == Interval.P5
  /// ```
  Interval operator +(Interval other) {
    final initialPitch = Note.c.inOctave(4);
    final finalPitch = initialPitch.transposeBy(this).transposeBy(other);

    return initialPitch.interval(finalPitch);
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
    final naming = '${quality.abbreviation}${size.value.abs()}';
    final descendingAbbreviation = isDescending ? 'desc ' : '';
    if (isCompound) {
      return '$descendingAbbreviation$naming '
          '(${quality.abbreviation}${simplified.size.value.abs()})';
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
