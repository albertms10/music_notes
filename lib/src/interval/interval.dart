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

  /// A diminished unison [Interval].
  static const d1 = Interval.perfect(1, PerfectQuality.diminished);

  /// A perfect unison [Interval].
  static const P1 = Interval.perfect(1, PerfectQuality.perfect);

  /// An augmented unison [Interval].
  static const A1 = Interval.perfect(1, PerfectQuality.augmented);

  /// A diminished second [Interval].
  static const d2 = Interval.imperfect(2, ImperfectQuality.diminished);

  /// A minor second [Interval].
  static const m2 = Interval.imperfect(2, ImperfectQuality.minor);

  /// A major second [Interval].
  static const M2 = Interval.imperfect(2, ImperfectQuality.major);

  /// An augmented second [Interval].
  static const A2 = Interval.imperfect(2, ImperfectQuality.augmented);

  /// A diminished third [Interval].
  static const d3 = Interval.imperfect(3, ImperfectQuality.diminished);

  /// A minor third [Interval].
  static const m3 = Interval.imperfect(3, ImperfectQuality.minor);

  /// A major third [Interval].
  static const M3 = Interval.imperfect(3, ImperfectQuality.major);

  /// An augmented third [Interval].
  static const A3 = Interval.imperfect(3, ImperfectQuality.augmented);

  /// A diminished fourth [Interval].
  static const d4 = Interval.perfect(4, PerfectQuality.diminished);

  /// A perfect fourth [Interval].
  static const P4 = Interval.perfect(4, PerfectQuality.perfect);

  /// An augmented fourth [Interval].
  static const A4 = Interval.perfect(4, PerfectQuality.augmented);

  /// A diminished fifth [Interval].
  static const d5 = Interval.perfect(5, PerfectQuality.diminished);

  /// A perfect fifth [Interval].
  static const P5 = Interval.perfect(5, PerfectQuality.perfect);

  /// An augmented fifth [Interval].
  static const A5 = Interval.perfect(5, PerfectQuality.augmented);

  /// A diminished sixth [Interval].
  static const d6 = Interval.imperfect(6, ImperfectQuality.diminished);

  /// A minor sixth [Interval].
  static const m6 = Interval.imperfect(6, ImperfectQuality.minor);

  /// A major sixth [Interval].
  static const M6 = Interval.imperfect(6, ImperfectQuality.major);

  /// An augmented sixth [Interval].
  static const A6 = Interval.imperfect(6, ImperfectQuality.augmented);

  /// A diminished seventh [Interval].
  static const d7 = Interval.imperfect(7, ImperfectQuality.diminished);

  /// A minor seventh [Interval].
  static const m7 = Interval.imperfect(7, ImperfectQuality.minor);

  /// A major seventh [Interval].
  static const M7 = Interval.imperfect(7, ImperfectQuality.major);

  /// An augmented seventh [Interval].
  static const A7 = Interval.imperfect(7, ImperfectQuality.augmented);

  /// A diminished octave [Interval].
  static const d8 = Interval.perfect(8, PerfectQuality.diminished);

  /// A perfect octave [Interval].
  static const P8 = Interval.perfect(8, PerfectQuality.perfect);

  /// An augmented octave [Interval].
  static const A8 = Interval.perfect(8, PerfectQuality.augmented);

  /// A diminished ninth [Interval].
  static const d9 = Interval.imperfect(9, ImperfectQuality.diminished);

  /// A minor ninth [Interval].
  static const m9 = Interval.imperfect(9, ImperfectQuality.minor);

  /// A major ninth [Interval].
  static const M9 = Interval.imperfect(9, ImperfectQuality.major);

  /// An augmented ninth [Interval].
  static const A9 = Interval.imperfect(9, ImperfectQuality.augmented);

  /// A diminished eleventh [Interval].
  static const d11 = Interval.perfect(11, PerfectQuality.diminished);

  /// A perfect eleventh [Interval].
  static const P11 = Interval.perfect(11, PerfectQuality.perfect);

  /// An augmented eleventh [Interval].
  static const A11 = Interval.perfect(11, PerfectQuality.augmented);

  /// A diminished thirteenth [Interval].
  static const d13 = Interval.imperfect(13, ImperfectQuality.diminished);

  /// A minor thirteenth [Interval].
  static const m13 = Interval.imperfect(13, ImperfectQuality.minor);

  /// A major thirteenth [Interval].
  static const M13 = Interval.imperfect(13, ImperfectQuality.major);

  /// An augmented thirteenth [Interval].
  static const A13 = Interval.imperfect(13, ImperfectQuality.augmented);

  /// [Interval.size] to the corresponding [ImperfectQuality.minor] or
  /// [PerfectQuality.perfect] semitones.
  static const Map<int, int> _sizeToSemitones = {
    1: 0, // P
    2: 1, // m
    3: 3, // m
    4: 5, // P
    5: 7, // P
    6: 8, // m
    7: 10, // m
    8: 12, // P
  };

  static final RegExp _intervalRegExp = RegExp(r'(\w+?)(\d+)');

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(this.size, PerfectQuality this.quality)
      : assert(size != 0, 'Size must be non-zero'),
        // Copied from [_IntervalSize._isPerfect] to allow const.
        assert(
          ((size < 0 ? -size : size) + (size < 0 ? -size : size) ~/ 8) % 4 < 2,
          'Interval must be perfect',
        );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
      : assert(size != 0, 'Size must be non-zero'),
        // Copied from [_IntervalSize._isPerfect] to allow const.
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
            semitones * size.sign - size._semitones.abs(),
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
    final spellings = IntervalClass(semitones).spellings();

    if (preferredQuality != null) {
      final interval = spellings.firstWhereOrNull(
        (interval) => interval.quality == preferredQuality,
      );
      if (interval != null) return interval;
    }

    // Find the Interval with the smaller Quality delta semitones.
    return spellings
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
    final match = _intervalRegExp.firstMatch(source);
    if (match == null) throw FormatException('Invalid Interval', source);

    final size = int.parse(match[2]!);
    final parseFactory =
        size._isPerfect ? PerfectQuality.parse : ImperfectQuality.parse;

    return Interval._(size, parseFactory(match[1]!));
  }

  /// Returns the [Interval.size] that matches with [semitones]
  /// in [_sizeToSemitones], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// Interval.sizeFromSemitones(8) == 6
  /// Interval.sizeFromSemitones(0) == 1
  /// Interval.sizeFromSemitones(-12) == -8
  /// Interval.sizeFromSemitones(4) == null
  /// ```
  static int? sizeFromSemitones(int semitones) {
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
      return matchingSize * semitones.sign;
    }

    final absResult =
        matchingSize + (absoluteSemitones ~/ chromaticDivisions) * 7;

    return absResult * (semitones.isNegative ? -1 : 1);
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
  int get semitones => (size._semitones.abs() + quality.semitones) * size.sign;

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
    final diff = 9 - simplified.size.abs();
    final invertedSize = (diff.isNegative ? diff.abs() + 2 : diff) * size.sign;

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
  Interval get simplified => Interval._(size._simplified, quality);

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
  bool get isCompound => size._isCompound;

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
        ImperfectQuality(:final semitones) => semitones < 0 && semitones > 1,
      } ||
      const {2, 7}.contains(simplified.size.abs());

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
        Quality.fromInterval(size, semitones.abs() - size._semitones.abs()),
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
  int distanceBetween<T extends Scalable<T>>(T scalable1, T scalable2) {
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
          circleItems.last.transposeBy(distance.isNegative ? -this : this),
        ],
      );

  /// Creates a new [IntervalClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.toIntervalClass() == IntervalClass.m2
  /// Interval.d4.toIntervalClass() == IntervalClass.M3
  /// Interval.P8.toIntervalClass() == IntervalClass.P1
  /// ```
  IntervalClass toIntervalClass() => IntervalClass(semitones);

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
    final naming = '${quality.abbreviation}${size.abs()}';
    final descendingAbbreviation = isDescending ? 'desc ' : '';
    if (isCompound) {
      return '$descendingAbbreviation$naming '
          '(${quality.abbreviation}${simplified.size.abs()})';
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

extension _IntervalSize on int {
  /// Returns the number of semitones of this [Interval.size] for the
  /// corresponding [ImperfectQuality.minor] or [PerfectQuality.perfect]
  /// semitones.
  ///
  /// See [Interval._sizeToSemitones].
  ///
  /// Example:
  /// ```dart
  /// 3._semitones == 3
  /// 5._semitones == 7
  /// (-5)._semitones == -7
  /// 7._semitones == 10
  /// 9._semitones == 13
  /// (-9)._semitones == -13
  /// ```
  int get _semitones {
    final simplifiedAbs = _simplified.abs();
    final octaveShift = chromaticDivisions * (_sizeAbsShift ~/ 8);
    // We exclude perfect octaves (simplified as 8) from the lookup to consider
    // them 0 (as if they were modulo 8).
    final size = simplifiedAbs == 8 ? 1 : simplifiedAbs;

    return (Interval._sizeToSemitones[size]! + octaveShift) * sign;
  }

  /// Returns the absolute [Interval.size] value taking octave shift into
  /// account.
  int get _sizeAbsShift {
    final sizeAbs = abs();

    return sizeAbs + sizeAbs ~/ 8;
  }

  /// Returns whether this [Interval.size] conforms a perfect interval.
  ///
  /// Example:
  /// ```dart
  /// 5._isPerfect == true
  /// 6._isPerfect == false
  /// (-11)._isPerfect == true
  /// ```
  bool get _isPerfect => _sizeAbsShift % 4 < 2;

  /// Returns whether this [Interval.size] is greater than an octave.
  ///
  /// Example:
  /// ```dart
  /// 5._isCompound == false
  /// (-6)._isCompound == false
  /// 8._isCompound == false
  /// 9._isCompound == true
  /// (-11)._isCompound == true
  /// 13._isCompound == true
  /// ```
  bool get _isCompound => abs() > 8;

  /// Returns the simplified version of this [Interval.size].
  ///
  /// Example:
  /// ```dart
  /// 13._simplified == 6
  /// (-9)._simplified == -2
  /// 8._simplified == 8
  /// (-22)._simplified == -8
  /// ```
  int get _simplified =>
      _isCompound ? _sizeAbsShift.nonZeroMod(8) * sign : this;
}
