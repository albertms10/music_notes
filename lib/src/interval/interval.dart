// To allow major (M) and minor (m) static constant names.
// ignore_for_file: constant_identifier_names

import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../enharmonic.dart';
import '../notation_system.dart';
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
  static const d1 = Interval.perfect(.unison, .diminished);

  /// A perfect unison [Interval].
  static const P1 = Interval.perfect(.unison);

  /// An augmented unison [Interval].
  static const A1 = Interval.perfect(.unison, .augmented);

  /// A diminished second [Interval].
  static const d2 = Interval.imperfect(.second, .diminished);

  /// A minor second [Interval].
  static const m2 = Interval.imperfect(.second, .minor);

  /// A major second [Interval].
  static const M2 = Interval.imperfect(.second, .major);

  /// An augmented second [Interval].
  static const A2 = Interval.imperfect(.second, .augmented);

  /// A diminished third [Interval].
  static const d3 = Interval.imperfect(.third, .diminished);

  /// A minor third [Interval].
  static const m3 = Interval.imperfect(.third, .minor);

  /// A major third [Interval].
  static const M3 = Interval.imperfect(.third, .major);

  /// An augmented third [Interval].
  static const A3 = Interval.imperfect(.third, .augmented);

  /// A diminished fourth [Interval].
  static const d4 = Interval.perfect(.fourth, .diminished);

  /// A perfect fourth [Interval].
  static const P4 = Interval.perfect(.fourth);

  /// An augmented fourth [Interval].
  static const A4 = Interval.perfect(.fourth, .augmented);

  /// A diminished fifth [Interval].
  static const d5 = Interval.perfect(.fifth, .diminished);

  /// A perfect fifth [Interval].
  static const P5 = Interval.perfect(.fifth);

  /// An augmented fifth [Interval].
  static const A5 = Interval.perfect(.fifth, .augmented);

  /// A diminished sixth [Interval].
  static const d6 = Interval.imperfect(.sixth, .diminished);

  /// A minor sixth [Interval].
  static const m6 = Interval.imperfect(.sixth, .minor);

  /// A major sixth [Interval].
  static const M6 = Interval.imperfect(.sixth, .major);

  /// An augmented sixth [Interval].
  static const A6 = Interval.imperfect(.sixth, .augmented);

  /// A diminished seventh [Interval].
  static const d7 = Interval.imperfect(.seventh, .diminished);

  /// A minor seventh [Interval].
  static const m7 = Interval.imperfect(.seventh, .minor);

  /// A major seventh [Interval].
  static const M7 = Interval.imperfect(.seventh, .major);

  /// An augmented seventh [Interval].
  static const A7 = Interval.imperfect(.seventh, .augmented);

  /// A diminished octave [Interval].
  static const d8 = Interval.perfect(.octave, .diminished);

  /// A perfect octave [Interval].
  static const P8 = Interval.perfect(.octave);

  /// An augmented octave [Interval].
  static const A8 = Interval.perfect(.octave, .augmented);

  /// A diminished ninth [Interval].
  static const d9 = Interval.imperfect(.ninth, .diminished);

  /// A minor ninth [Interval].
  static const m9 = Interval.imperfect(.ninth, .minor);

  /// A major ninth [Interval].
  static const M9 = Interval.imperfect(.ninth, .major);

  /// An augmented ninth [Interval].
  static const A9 = Interval.imperfect(.ninth, .augmented);

  /// A diminished eleventh [Interval].
  static const d11 = Interval.perfect(.eleventh, .diminished);

  /// A perfect eleventh [Interval].
  static const P11 = Interval.perfect(.eleventh);

  /// An augmented eleventh [Interval].
  static const A11 = Interval.perfect(.eleventh, .augmented);

  /// A diminished thirteenth [Interval].
  static const d13 = Interval.imperfect(.thirteenth, .diminished);

  /// A minor thirteenth [Interval].
  static const m13 = Interval.imperfect(.thirteenth, .minor);

  /// A major thirteenth [Interval].
  static const M13 = Interval.imperfect(.thirteenth, .major);

  /// An augmented thirteenth [Interval].
  static const A13 = Interval.imperfect(.thirteenth, .augmented);

  /// Creates a new [Interval] allowing only perfect quality [size]s.
  const Interval.perfect(this.size, [PerfectQuality this.quality = .perfect])
    // Copied from [.isPerfect] to allow const.
    : assert(
        ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) != 0,
        'Interval must be perfect.',
      );

  /// Creates a new [Interval] allowing only imperfect quality [size]s.
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
    // Copied from [.isPerfect] to allow const.
    : assert(
        ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) == 0,
        'Interval must be imperfect.',
      );

  /// Creates a new [Interval] from [size] and [Quality.semitones].
  factory Interval.fromSizeAndQualitySemitones(Size size, int semitones) {
    final qualityConstructor = size.isPerfect
        ? PerfectQuality.new
        : ImperfectQuality.new;

    return ._(size, qualityConstructor(semitones));
  }

  /// Creates a new [Interval] from [size] and [Interval.semitones].
  factory Interval.fromSizeAndSemitones(Size size, int semitones) =>
      .fromSizeAndQualitySemitones(
        size,
        semitones * size.sign - size.semitones.abs(),
      );

  /// Creates a new [Interval] from the given distance in [semitones].
  /// The size is inferred.
  factory Interval.fromSemitones(int semitones) =>
      .fromSizeAndSemitones(.nearestFromSemitones(semitones), semitones);

  /// The chain of [StringParser]s used to parse an [Interval].
  static const parsers = [IntervalNotation()];

  /// Parse [source] as an [Interval] and return its value.
  ///
  /// If the [source] string does not contain a valid [Interval], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Interval.parse('m3') == .m3
  /// Interval.parse('P-5') == -Interval.P5
  /// Interval.parse('z') // throws a FormatException
  /// ```
  factory Interval.parse(
    String source, {
    List<StringParser<Interval>> chain = parsers,
  }) => chain.parse(source);

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
  /// Interval.M3.descending(false) == .M3
  /// (-Interval.P5).descending() == -Interval.P5
  /// (-Interval.M7).descending(false) == .M7
  /// ```
  // ignore: avoid_positional_boolean_parameters
  Interval descending([bool isDescending = true]) =>
      ._(Size(size * (this.isDescending == isDescending ? 1 : -1)), quality);

  /// The inversion of this [Interval], regardless of its direction (ascending
  /// or descending).
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// Interval.m3.inversion == .M6
  /// Interval.A4.inversion == .d5
  /// Interval.M7.inversion == .m2
  /// (-Interval.P1).inversion == -Interval.P8
  /// ```
  ///
  /// If this [Interval.size] is greater than [.octave], the simplified
  /// inversion is returned instead.
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.inversion == .M7
  /// Interval.P11.inversion == .P5
  /// ```
  Interval get inversion => ._(size.inversion, quality.inversion);

  /// The simplified version of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.simple == .m2
  /// Interval.P11.simple == .P4
  /// Interval.P8.simple == .P8
  /// (-Interval.M3).simple == -Interval.M3
  /// ```
  Interval get simple => ._(size.simple, quality);

  /// Whether this [Interval] is greater than [.octave].
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
  /// Interval.A4.respellBySize(.fifth) == .d5
  /// Interval.d3.respellBySize(.second) == .M2
  /// ```
  Interval respellBySize(Size size) => .fromSizeAndSemitones(size, semitones);

  /// This [Interval] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respelledUpwards == .d5
  /// Interval.M3.respelledUpwards == .d4
  /// ```
  @override
  Interval get respelledUpwards => respellBySize(Size(size.incrementBy(1)));

  /// This [Interval] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.d5.respelledDownwards == .A4
  /// Interval.m3.respelledDownwards == .A2
  /// ```
  @override
  Interval get respelledDownwards => respellBySize(Size(size.incrementBy(-1)));

  /// This [Interval] with the simplest spelling while keeping the same number
  /// of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.d2.respelledDownwards == .P1
  /// Interval.A3.respelledDownwards == .P4
  /// ```
  @override
  Interval get respelledSimple => .fromSemitones(semitones);

  /// The circle distance between [from] and [to] in this [Interval],
  /// including all visited `notes`.
  ///
  /// Example:
  /// ```dart
  /// Interval.P5.circleDistance<Note>(from: .c, to: .d)
  ///   == const (2, notes: <Note>[.c, .g, .d])
  /// Interval.P5.circleDistance<Note>(from: .a, to: .g)
  ///   == const (-2, notes: <Note>[.a, .d, .g])
  /// (-Interval.P5).circleDistance<Note>(from: .b.flat, to: .d)
  ///   == (-4, notes: <Note>[.b.flat, .f, .d, .g, .d])
  /// Interval.P4.circleDistance<Note>(from: .f, to: .a.flat)
  ///   == (3, notes: <Note>[.f, .b.flat, .e.flat, .a.flat])
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
  ///   == <Note>[.c, .g, .d, .a, .e, .b, .f.sharp]
  ///
  /// Interval.P4.circleFrom(Note.c).take(6).toList()
  ///   == <Note>[.c, .f, .b.flat, .e.flat, .a.flat, .d.flat]
  ///
  /// (-Interval.P4).circleFrom(Note.c) == Interval.P5.circleFrom(Note.c)
  /// ```
  Iterable<T> circleFrom<T extends Scalable<T>>(T scalable) sync* {
    T last;
    yield last = scalable;
    const maxCircleLoop = 48;
    for (var i = 0; i < maxCircleLoop; i++) {
      yield last = last.transposeBy(this);
    }
  }

  /// Creates a new [IntervalClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.toClass() == .m2
  /// Interval.d4.toClass() == .M3
  /// Interval.P8.toClass() == .P1
  /// ```
  @override
  IntervalClass toClass() => IntervalClass(semitones);

  /// The string representation of this [Interval] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Interval.M3.toString() == 'M3'
  /// (-Interval.d5).toString() == 'd-5'
  /// .twelfth.perfect.toString() == 'P12 (P5)'
  /// ```
  @override
  String toString({
    StringFormatter<Interval> formatter = const IntervalNotation(),
  }) => formatter.format(this);

  /// Adds [other] to this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.m2 + Interval.m2 == .d3
  /// Interval.m2 + Interval.M2 == .m3
  /// Interval.M2 + Interval.P4 == .P5
  /// ```
  Interval operator +(Interval other) {
    final initialPitch = Note.c.inOctave(4);
    final finalPitch = initialPitch.transposeBy(this).transposeBy(other);

    return initialPitch.interval(finalPitch);
  }

  /// Subtracts [other] from this [Interval].
  ///
  /// Example:
  /// ```dart
  /// Interval.M3 - Interval.m2 == .A2
  /// Interval.M2 - Interval.A1 == .m2
  /// Interval.P5 - Interval.P4 == .M2
  /// ```
  Interval operator -(Interval other) {
    final initialPitch = Note.c.inOctave(4);
    final finalPitch = initialPitch.transposeBy(this).transposeBy(-other);

    return initialPitch.interval(finalPitch);
  }

  /// The negation of this [Interval].
  ///
  /// Example:
  /// ```dart
  /// -Interval.perfect(-Size.fifth) == .P5
  /// -Interval.m3 == (-Size.third).minor
  /// ```
  Interval operator -() => ._(-size, quality);

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

/// An [Interval] iterable extension.
extension IntervalIterable on Iterable<Interval> {
  /// The [Interval] steps between consecutive intervals.
  ///
  /// Example:
  /// ```dart
  /// const <Interval>[.m2, .M3, .P4].intervalSteps.toList()
  ///   == const <Interval>[.m2, .A2, .m2]
  /// ```
  Iterable<Interval> get intervalSteps sync* {
    var previous = Interval.P1;
    for (final interval in this) {
      yield interval - previous;
      previous = interval;
    }
  }
}

/// A notation system for [Interval].
final class IntervalNotation extends StringNotationSystem<Interval> {
  /// The [SizeNotation].
  final SizeNotation sizeNotation;

  /// The [PerfectQualityNotation].
  final PerfectQualityNotation perfectQualityNotation;

  /// The [ImperfectQualityNotation].
  final ImperfectQualityNotation imperfectQualityNotation;

  /// Creates a new [IntervalNotation].
  const IntervalNotation({
    this.sizeNotation = const SizeNotation(),
    this.perfectQualityNotation = const PerfectQualityNotation(),
    this.imperfectQualityNotation = const ImperfectQualityNotation(),
  });

  @override
  String format(Interval interval) {
    final quality = switch (interval.quality) {
      final PerfectQuality quality => perfectQualityNotation.format(quality),
      final ImperfectQuality quality => imperfectQualityNotation.format(
        quality,
      ),
    };
    final naming = '$quality${sizeNotation.format(interval.size)}';
    if (!interval.isCompound) return naming;

    return '$naming ($quality${sizeNotation.format(interval.simple.size)})';
  }

  @override
  RegExp get regExp =>
      // TODO(albertms10): use `qualityNotation.regExp.pattern` when duplicated
      //  named capture groups are supported.
      //  See https://github.com/dart-lang/sdk/issues/61337.
      RegExp('(?<quality>\\w+?)\\s*${sizeNotation.regExp.pattern}');

  @override
  Interval parseMatch(RegExpMatch match) {
    final size = sizeNotation.parseMatch(match);
    // ignore: omit_local_variable_types False positive (?)
    final StringParser<Quality> parser = size.isPerfect
        ? perfectQualityNotation
        : imperfectQualityNotation;

    final quality = match.namedGroup('quality')!;
    if (!parser.matches(quality)) {
      throw FormatException('Invalid Quality', quality, 0);
    }

    return Interval._(size, parser.parseMatch(match));
  }
}
