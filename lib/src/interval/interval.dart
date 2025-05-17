// To allow major (M) and minor (m) static constant names.
// ignore_for_file: constant_identifier_names

import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../enharmonic.dart';
import '../note/note.dart';
import '../respellable.dart';
import '../scalable.dart';
import 'interval_class.dart';
import 'quality.dart';
import 'size.dart';

/// Distance between two notes.
///
/// ---
/// See also:
/// * [Quality].
/// * [IntervalClass].
@immutable
final class Interval
    with Enharmonic<IntervalClass>, Comparators<Interval>, Respellable<Interval>
    implements Comparable<Interval> {
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
  static const P1 = Interval.perfect(Size.unison);

  /// An augmented unison [Interval].
  static const A1 = Interval.perfect(Size.unison, PerfectQuality.augmented);

  /// A diminished second [Interval].
  static const d2 = Interval.imperfect(
    Size.second,
    ImperfectQuality.diminished,
  );

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
  static const P4 = Interval.perfect(Size.fourth);

  /// An augmented fourth [Interval].
  static const A4 = Interval.perfect(Size.fourth, PerfectQuality.augmented);

  /// A diminished fifth [Interval].
  static const d5 = Interval.perfect(Size.fifth, PerfectQuality.diminished);

  /// A perfect fifth [Interval].
  static const P5 = Interval.perfect(Size.fifth);

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
  static const d7 = Interval.imperfect(
    Size.seventh,
    ImperfectQuality.diminished,
  );

  /// A minor seventh [Interval].
  static const m7 = Interval.imperfect(Size.seventh, ImperfectQuality.minor);

  /// A major seventh [Interval].
  static const M7 = Interval.imperfect(Size.seventh, ImperfectQuality.major);

  /// An augmented seventh [Interval].
  static const A7 = Interval.imperfect(
    Size.seventh,
    ImperfectQuality.augmented,
  );

  /// A diminished octave [Interval].
  static const d8 = Interval.perfect(Size.octave, PerfectQuality.diminished);

  /// A perfect octave [Interval].
  static const P8 = Interval.perfect(Size.octave);

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
  static const P11 = Interval.perfect(Size.eleventh);

  /// An augmented eleventh [Interval].
  static const A11 = Interval.perfect(Size.eleventh, PerfectQuality.augmented);

  /// A diminished thirteenth [Interval].
  static const d13 = Interval.imperfect(
    Size.thirteenth,
    ImperfectQuality.diminished,
  );

  /// A minor thirteenth [Interval].
  static const m13 = Interval.imperfect(
    Size.thirteenth,
    ImperfectQuality.minor,
  );

  /// A major thirteenth [Interval].
  static const M13 = Interval.imperfect(
    Size.thirteenth,
    ImperfectQuality.major,
  );

  /// An augmented thirteenth [Interval].
  static const A13 = Interval.imperfect(
    Size.thirteenth,
    ImperfectQuality.augmented,
  );

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(
    this.size, [
    PerfectQuality this.quality = PerfectQuality.perfect,
  ])
    // Copied from [Size.isPerfect] to allow const.
    : assert(
         ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) != 0,
         'Interval must be perfect.',
       );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
    // Copied from [Size.isPerfect] to allow const.
    : assert(
        ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) == 0,
        'Interval must be imperfect.',
      );

  /// Creates a new [Interval] from [size] and [Quality.semitones].
  factory Interval.fromSizeAndQualitySemitones(Size size, int semitones) {
    final qualityConstructor =
        size.isPerfect ? PerfectQuality.new : ImperfectQuality.new;

    return Interval._(size, qualityConstructor(semitones));
  }

  /// Creates a new [Interval] from [size] and [Interval.semitones].
  factory Interval.fromSizeAndSemitones(Size size, int semitones) =>
      Interval.fromSizeAndQualitySemitones(
        size,
        semitones * size.sign - size.semitones.abs(),
      );

  /// Creates a new [Interval] from the given distance in [semitones].
  /// The size is inferred.
  factory Interval.fromSemitones(int semitones) =>
      Interval.fromSizeAndSemitones(
        Size.nearestFromSemitones(semitones),
        semitones,
      );

  /// Parse [source] as an [Interval] and return its value.
  ///
  /// If the [source] string does not contain a valid [Interval], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Interval.parse('m3') == Interval.m3
  /// Interval.parse('P-5') == -Interval.P5
  /// Interval.parse('z') // throws a FormatException
  /// ```
  factory Interval.parse(
    String source, {
    IntervalNotation system = IntervalNotation.standard,
  }) => system.parseInterval(source);

  /// The number of semitones of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.semitones == 2
  /// Interval.d5.semitones == 6
  /// Interval.A4.semitones == 6
  /// (-Interval.M3).semitones == -4
  /// ```
  @override
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
  /// Interval.M3.descending(false) == Interval.M3
  /// (-Interval.P5).descending() == -Interval.P5
  /// (-Interval.M7).descending(false) == Interval.M7
  /// ```
  // ignore: avoid_positional_boolean_parameters
  Interval descending([bool isDescending = true]) => Interval._(
    Size(size * (this.isDescending == isDescending ? 1 : -1)),
    quality,
  );

  /// The inversion of this [Interval], regardless of its direction (ascending
  /// or descending).
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// Interval.m3.inversion == Interval.M6
  /// Interval.A4.inversion == Interval.d5
  /// Interval.M7.inversion == Interval.m2
  /// (-Interval.P1).inversion == -Interval.P8
  /// ```
  ///
  /// If this [Interval.size] is greater than [Size.octave], the simplified
  /// inversion is returned instead.
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.inversion == Interval.M7
  /// Interval.P11.inversion == Interval.P5
  /// ```
  Interval get inversion => Interval._(size.inversion, quality.inversion);

  /// The simplified version of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.simple == Interval.m2
  /// Interval.P11.simple == Interval.P4
  /// Interval.P8.simple == Interval.P8
  /// (-Interval.M3).simple == -Interval.M3
  /// ```
  Interval get simple => Interval._(size.simple, quality);

  /// Whether this [Interval] is greater than [Size.octave].
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
  bool get isDissonant => quality.isDissonant || size.isDissonant;

  /// This [Interval] respelled by [size] while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respellBySize(Size.fifth) == Interval.d5
  /// Interval.d3.respellBySize(Size.second) == Interval.M2
  /// ```
  Interval respellBySize(Size size) =>
      Interval.fromSizeAndSemitones(size, semitones);

  /// This [Interval] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respelledUpwards == Interval.d5
  /// Interval.M3.respelledUpwards == Interval.d4
  /// ```
  @override
  Interval get respelledUpwards => respellBySize(Size(size.incrementBy(1)));

  /// This [Interval] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.d5.respelledDownwards == Interval.A4
  /// Interval.m3.respelledDownwards == Interval.A2
  /// ```
  @override
  Interval get respelledDownwards => respellBySize(Size(size.incrementBy(-1)));

  /// This [Interval] with the simplest spelling while keeping the same number
  /// of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.d2.respelledDownwards == Interval.P1
  /// Interval.A3.respelledDownwards == Interval.P4
  /// ```
  @override
  Interval get respelledSimple => Interval.fromSemitones(semitones);

  /// The circle distance between [from] and [to] in this [Interval],
  /// including all visited `notes`.
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.distance(from: Note.c, to: Note.d)
  ///   == const (2, notes: [Note.c, Note.g, Note.d])
  /// Interval.P5.distance(from: Note.a, to: Note.g)
  ///   == const (-2, notes: [Note.a, Note.d, Note.g])
  /// (-Interval.P5).distance(from: Note.b.flat, to: Note.d)
  ///   == (-4, notes: [Note.b.flat, Note.f, Note.d, Note.g, Note.d])
  /// Interval.P4.distance(from: Note.f, to: Note.a.flat)
  ///   == (3, notes: [Note.f, Note.b.flat, Note.e.flat, Note.a.flat])
  /// ```
  (int distance, {List<T> notes}) circleDistance<T extends Scalable<T>>({
    required T from,
    required T to,
  }) {
    var distance = 0;
    final ascendingNotes = [from];
    final descendingNotes = [from];
    while (true) {
      if (ascendingNotes.last == to) {
        return (distance, notes: ascendingNotes);
      }
      if (descendingNotes.last == to) {
        return (-distance, notes: descendingNotes);
      }
      distance++;
      ascendingNotes.add(ascendingNotes.last.transposeBy(this));
      descendingNotes.add(descendingNotes.last.transposeBy(inversion));
    }
  }

  /// The circle of this [Interval] from [scalable].
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.circleFrom(Note.c).take(7).toList()
  ///   == [Note.c, Note.g, Note.d, Note.a, Note.e, Note.b, Note.f.sharp]
  ///
  /// Interval.P4.circleFrom(Note.c).take(6).toList()
  ///   == [Note.c, Note.f, Note.b.flat, Note.e.flat, Note.a.flat, Note.d.flat]
  ///
  /// (-Interval.P4).circleFrom(Note.c) == Interval.P5.circleFrom(Note.c)
  /// ```
  Iterable<T> circleFrom<T extends Scalable<T>>(T scalable) sync* {
    yield scalable;
    var last = scalable;
    const maxCircleLoop = 48;
    for (var i = 0; i < maxCircleLoop; i++) {
      yield last = last.transposeBy(this);
    }
  }

  /// Creates a new [IntervalClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.toClass() == IntervalClass.m2
  /// Interval.d4.toClass() == IntervalClass.M3
  /// Interval.P8.toClass() == IntervalClass.P1
  /// ```
  @override
  IntervalClass toClass() => IntervalClass(semitones);

  /// The string representation of this [Interval] based on [system].
  ///
  /// See [IntervalNotation] for all system implementations.
  ///
  /// Example:
  /// ```dart
  /// Interval.M3.toString() == 'M3'
  /// (-Interval.d5).toString() == 'd-5'
  /// Size.twelfth.perfect.toString() == 'P12 (P5)'
  /// ```
  @override
  String toString({IntervalNotation system = IntervalNotation.standard}) =>
      system.interval(this);

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
  /// -Interval.perfect(-Size.fifth) == Interval.P5
  /// -Interval.m3 == (-Size.third).minor
  /// ```
  Interval operator -() => Interval._(-size, quality);

  @override
  bool operator ==(Object other) =>
      other is Interval && size == other.size && quality == other.quality;

  @override
  int get hashCode => Object.hash(size, quality);

  @override
  int compareTo(Interval other) => compareMultiple([
    () => size.compareTo(other.size),
    () => quality.compareTo(other.quality),
  ]);
}

/// The abstraction for [Interval] notation systems.
@immutable
abstract class IntervalNotation {
  /// Creates a new [IntervalNotation].
  const IntervalNotation();

  /// The standard [IntervalNotation] system.
  static const standard = StandardIntervalNotation();

  /// The string notation for [interval].
  String interval(Interval interval);

  /// Parse [source] as an [Interval].
  Interval parseInterval(String source);

  /// The string notation for [size].
  String size(Size size);

  /// Parse [source] as a [Size].
  Size parseSize(String source);

  /// The string notation for [quality].
  String quality(Quality quality);

  /// Parse [source] as a [PerfectQuality].
  PerfectQuality parsePerfectQuality(String source);

  /// Parse [source] as an [ImperfectQuality].
  ImperfectQuality parseImperfectQuality(String source);
}

/// The standard [Interval] notation system.
final class StandardIntervalNotation extends IntervalNotation {
  /// Creates a new [StandardIntervalNotation].
  const StandardIntervalNotation();

  static final _intervalRegExp = RegExp(r'(\w+?)(-?\d+)');

  /// The symbol for a diminished [Quality].
  static const _diminishedSymbol = 'd';

  /// The symbol for a [PerfectQuality].
  static const _perfectSymbol = 'P';

  /// The symbol for an augmented [Quality].
  static const _augmentedSymbol = 'A';

  /// The symbol for a minor [ImperfectQuality].
  static const _minorSymbol = 'm';

  /// The symbol for a major [ImperfectQuality].
  static const _majorSymbol = 'M';

  static final _perfectQualityRegExp = RegExp(
    '^($_diminishedSymbol+|$_perfectSymbol|$_augmentedSymbol+)\$',
  );

  static final _imperfectQualityRegExp = RegExp(
    '^($_diminishedSymbol+|$_minorSymbol|$_majorSymbol|$_augmentedSymbol+)\$',
  );

  @override
  String interval(Interval interval) {
    final quality = interval.quality.toString(system: this);
    final naming = '$quality${interval.size.format(system: this)}';
    if (!interval.isCompound) return naming;

    return '$naming ($quality${interval.simple.size.format(system: this)})';
  }

  @override
  Interval parseInterval(String source) {
    final match = _intervalRegExp.firstMatch(source);
    if (match == null) throw FormatException('Invalid Interval', source);

    final size = parseSize(match[2]!);
    final parseFactory =
        size.isPerfect ? parsePerfectQuality : parseImperfectQuality;

    return Interval._(size, parseFactory(match[1]!));
  }

  @override
  String size(Size size) => '$size';

  @override
  Size parseSize(String source) => Size(int.parse(source));

  @override
  String quality(Quality quality) => switch (quality) {
    PerfectQuality() => switch (quality.semitones) {
      < 0 => _diminishedSymbol * quality.semitones.abs(),
      0 => _perfectSymbol,
      _ => _augmentedSymbol * quality.semitones,
    },
    ImperfectQuality() => switch (quality.semitones) {
      < 0 => _diminishedSymbol * quality.semitones.abs(),
      0 => _minorSymbol,
      1 => _majorSymbol,
      _ => _augmentedSymbol * (quality.semitones - 1),
    },
  };

  @override
  PerfectQuality parsePerfectQuality(String source) {
    if (!_perfectQualityRegExp.hasMatch(source)) {
      throw FormatException('Invalid PerfectQuality', source);
    }

    return switch (source[0]) {
      _diminishedSymbol => PerfectQuality(-source.length),
      _perfectSymbol => PerfectQuality.perfect,
      _ /* _augmentedSymbol */ => PerfectQuality(source.length),
    };
  }

  @override
  ImperfectQuality parseImperfectQuality(String source) {
    if (!_imperfectQualityRegExp.hasMatch(source)) {
      throw FormatException('Invalid ImperfectQuality', source);
    }

    return switch (source[0]) {
      _diminishedSymbol => ImperfectQuality(-source.length),
      _minorSymbol => ImperfectQuality.minor,
      _majorSymbol => ImperfectQuality.major,
      _ /* _augmentedSymbol */ => ImperfectQuality(source.length + 1),
    };
  }
}
