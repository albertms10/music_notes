// To allow major (M) and minor (m) static constant names.
// ignore_for_file: constant_identifier_names

import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../enharmonic.dart';
import '../interval_class/interval_class.dart';
import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../quality/quality.dart';
import '../respellable.dart';
import '../scalable.dart';
import '../size/size.dart';
import 'german_interval_notation.dart';
import 'standard_interval_notation.dart';

/// The exact, spelled distance between two notes: a [Size] (how many
/// letter names it spans) refined by a [Quality] (how many semitones,
/// exactly, within that size) — e.g. a major third versus a diminished
/// fourth, which sound identical but are different [Interval]s because
/// they're spelled differently.
///
/// This spelling awareness is what separates [Interval] from the plain
/// semitone count [IntervalClass] reduces to: [Note.interval] returns an
/// [Interval] that reflects how the two notes are actually written, and
/// [Note.transposeBy] uses that same spelling to land on a specific,
/// correctly-spelled note rather than merely the nearest enharmonic
/// pitch. A negative [size] denotes a descending interval.
///
/// ---
/// See also:
/// * [Quality].
/// * [IntervalClass].
@immutable
final class Interval
    with Enharmonic<IntervalClass>, Comparators<Interval>, Respellable<Interval>
    implements Comparable<Interval>, Formattable<Interval> {
  /// The generic, letter-counting span of this [Interval] (see [Size]);
  /// together with [quality] this fully determines its [semitones].
  final Size size;

  /// The precise half-step refinement of [size] — a [PerfectQuality] if
  /// [size] is a [PerfectSize], an [ImperfectQuality] if it's an
  /// [ImperfectSize].
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

  /// A diminished tenth [Interval].
  static const d10 = Interval.imperfect(.tenth, .diminished);

  /// A minor tenth [Interval].
  static const m10 = Interval.imperfect(.tenth, .minor);

  /// A major tenth [Interval].
  static const M10 = Interval.imperfect(.tenth, .major);

  /// An augmented tenth [Interval].
  static const A10 = Interval.imperfect(.tenth, .augmented);

  /// A diminished eleventh [Interval].
  static const d11 = Interval.perfect(.eleventh, .diminished);

  /// A perfect eleventh [Interval].
  static const P11 = Interval.perfect(.eleventh);

  /// An augmented eleventh [Interval].
  static const A11 = Interval.perfect(.eleventh, .augmented);

  /// A diminished twelfth [Interval].
  static const d12 = Interval.perfect(.twelfth, .diminished);

  /// A perfect twelfth [Interval].
  static const P12 = Interval.perfect(.twelfth);

  /// An augmented twelfth [Interval].
  static const A12 = Interval.perfect(.twelfth, .augmented);

  /// A diminished thirteenth [Interval].
  static const d13 = Interval.imperfect(.thirteenth, .diminished);

  /// A minor thirteenth [Interval].
  static const m13 = Interval.imperfect(.thirteenth, .minor);

  /// A major thirteenth [Interval].
  static const M13 = Interval.imperfect(.thirteenth, .major);

  /// An augmented thirteenth [Interval].
  static const A13 = Interval.imperfect(.thirteenth, .augmented);

  /// Creates a new [Interval] from a [PerfectSize] and [quality] (perfect
  /// by default); asserts that [size] actually belongs to the perfect
  /// family (unison, fourth, fifth, octave, or a compound thereof).
  const Interval.perfect(this.size, [PerfectQuality this.quality = .perfect])
    : assert(
        // This operation uses a bitmask implementation, modified to be allowed
        // in a const context:
        //
        // ```dart
        // ((1 << (abs() % 7)) & 50) != 0
        // ```
        //
        // This is equivalent to the more readable pattern in [Size.isPerfect].
        //
        // In the bitmask, each bit represents a [Size] within the octave cycle
        // (modulo 7). Perfect intervals occur at positions:
        //
        // - 1 for [Size.unison],
        // - 4 for [Size.fourth], and
        // - 5 for [Size.fifth].
        //
        // The number 50 (which is `0b0110010` in binary) has bits set at these
        // positions:
        //
        // ```
        //  2^ 6 5 4 3 2 1 0
        //     -------------
        //     0 1 1 0 0 1 0
        //       ^ ^     ^
        // ```
        //
        // - `abs() % 7` computes the [Size] modulo 7, mapping it to its
        //   position within the octave cycle.
        // - `1 <<` creates a bitmask with a single bit set at the position
        //   corresponding to the [Size].
        // - Performing a bitwise AND `&` with 50 (`0b0110010`) checks if this
        //   bit corresponds to a perfect interval size.
        // - The expression `!= 0` returns `true` if the result is non-zero
        //   (e.g., the [Size] is perfect) and `false` otherwise.
        ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) != 0,
        'Interval must be perfect.',
      );

  /// Creates a new [Interval] from an [ImperfectSize] and [quality];
  /// asserts that [size] actually belongs to the imperfect family (second,
  /// third, sixth, seventh, or a compound thereof).
  const Interval.imperfect(this.size, ImperfectQuality this.quality)
    : assert(
        // See [Interval.perfect] for an explanation of this bitmask operation.
        ((1 << ((size < 0 ? 0 - size : size) % 7)) & 50) == 0,
        'Interval must be imperfect.',
      );

  /// Creates a new [Interval] from [size], picking [PerfectQuality] or
  /// [ImperfectQuality] automatically to match, with [semitones] as that
  /// quality's raw deviation value (not an absolute semitone count — see
  /// [Interval.fromSizeAndSemitones] for that).
  factory Interval.fromSizeAndQualitySemitones(Size size, int semitones) =>
      size.isPerfect
      ? .perfect(size, PerfectQuality(semitones))
      : .imperfect(size, ImperfectQuality(semitones));

  /// Creates a new [Interval] spanning [size] with an absolute distance
  /// of [semitones] (i.e. matching what [Interval.semitones] would report
  /// on the result), deriving whichever [Quality] makes that true.
  factory Interval.fromSizeAndSemitones(
    Size size,
    int semitones,
  ) => .fromSizeAndQualitySemitones(
    size,
    // adding 0 to prevent -0 from being treated as negative,
    // which would cause the quality to be inverted
    (semitones + 0) * size.sign - size.semitones.abs(),
  );

  /// Creates a new [Interval] spanning exactly [semitones], inferring
  /// the closest matching [Size] (see [Size.nearestFromSemitones]) rather
  /// than requiring one to be given explicitly.
  factory Interval.fromSemitones(int semitones) =>
      .fromSizeAndSemitones(.nearestFromSemitones(semitones), semitones);

  /// The chain of [StringParser]s tried in turn by [Interval.parse]:
  /// standard letter-symbol notation, then its German equivalent.
  static const parsers = [StandardIntervalNotation(), GermanIntervalNotation()];

  /// Parses [source] as an [Interval] and returns its value.
  ///
  /// If [source] does not contain a valid [Interval], a [FormatException]
  /// is thrown.
  ///
  /// Example:
  /// ```dart
  /// Interval.parse('m3') == .m3
  /// Interval.parse('P-5') == .P5.descending
  /// Interval.parse('z') // throws a FormatException
  /// ```
  factory Interval.parse(
    String source, {
    List<StringParser<Interval>> chain = parsers,
  }) => chain.parse(source);

  /// This [Interval]'s absolute distance in semitones, combining [size]'s
  /// default span with [quality]'s deviation from it, signed to match
  /// [direction].
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

  /// This [Interval]'s direction as `1` (ascending) or `-1` (descending),
  /// mirroring [size]'s sign.
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.direction == 1
  /// (-Interval.P4).direction == -1
  /// ```
  int get direction => size.sign;

  /// This [Interval] with a positive [size], flipping direction only if
  /// it was [isDescending].
  ///
  /// Example:
  /// ```dart
  /// (-Interval.m2).ascending == .m2
  /// Interval.M3.ascending == .M3
  /// ```
  Interval get ascending => isDescending ? ._(-size, quality) : this;

  /// This [Interval] with a negative [size], flipping direction only if
  /// it wasn't already [isDescending].
  ///
  /// Example:
  /// ```dart
  /// Interval.M3.descending == -Interval.M3
  /// (-Interval.m2).descending == -Interval.m2
  /// ```
  Interval get descending => isDescending ? this : ._(-size, quality);

  /// Whether this [Interval] points downward, i.e. [size] is negative.
  ///
  /// Example:
  /// ```dart
  /// Interval.M2.isDescending == false
  /// (-Interval.P4).isDescending == true
  /// Interval.d1.isDescending == false
  /// ```
  bool get isDescending => size.isNegative;

  /// This [Interval] set to [isDescending]'s direction: [descending] if
  /// `true`, [ascending] if `false`.
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.withDescending(true) == -Interval.m2
  /// Interval.M3.withDescending(false) == .M3
  /// (-Interval.P5).withDescending(true) == -Interval.P5
  /// (-Interval.M7).withDescending(false) == .M7
  /// ```
  // ignore: avoid_positional_boolean_parameters for conciseness
  Interval withDescending(bool isDescending) =>
      isDescending ? descending : ascending;

  /// This [Interval] turned upside down, the way moving its lower note
  /// up an octave (or its upper note down one) would: [Size] and
  /// [Quality] both invert together (see [Size.inversion] and
  /// [Quality.inversion]), so a minor third inverts to a major sixth,
  /// direction is preserved either way.
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// Interval.m3.inversion == .M6
  /// Interval.A4.inversion == .d5
  /// Interval.M7.inversion == .m2
  /// (-Interval.P1).inversion == .P8.descending
  /// ```
  ///
  /// A compound [Interval] (greater than an [Size.octave]) is simplified
  /// before inverting, since a ninth and a second invert the same way.
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.inversion == .M7
  /// Interval.P11.inversion == .P5
  /// ```
  Interval get inversion => ._(size.inversion, quality.inversion);

  /// This [Interval] reduced within a single octave (see [Size.simple]),
  /// keeping the same [Quality].
  ///
  /// Example:
  /// ```dart
  /// Interval.m9.simple == .m2
  /// Interval.P11.simple == .P4
  /// Interval.P8.simple == .P8
  /// (-Interval.M3).simple == -Interval.M3
  /// ```
  Interval get simple => ._(size.simple, quality);

  /// Whether this [Interval] spans more than an octave (a ninth or
  /// larger; see [Size.isCompound]).
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

  /// Whether this [Interval] is dissonant: true if either its [Quality]
  /// (any diminished or augmented degree) or its [Size] (any second or
  /// seventh, in any octave) makes it so.
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

  /// This [Interval] rewritten as [size], keeping the same [semitones]
  /// by deriving whatever [Quality] makes up the difference (e.g. an
  /// augmented fourth respelled as a fifth becomes a diminished fifth).
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respellBySize(.fifth) == .d5
  /// Interval.d3.respellBySize(.second) == .M2
  /// ```
  Interval respellBySize(Size size) => .fromSizeAndSemitones(size, semitones);

  /// This [Interval] respelled one [Size] step larger, keeping the same
  /// [semitones] (its [Quality] shrinks to compensate, e.g. augmented
  /// fourth becomes diminished fifth).
  ///
  /// Example:
  /// ```dart
  /// Interval.A4.respelledUpwards == .d5
  /// Interval.M3.respelledUpwards == .d4
  /// ```
  @override
  Interval get respelledUpwards => respellBySize(Size(size.incrementBy(1)));

  /// This [Interval] respelled one [Size] step smaller, keeping the same
  /// [semitones] (its [Quality] grows to compensate, e.g. diminished
  /// fifth becomes augmented fourth).
  ///
  /// Example:
  /// ```dart
  /// Interval.d5.respelledDownwards == .A4
  /// Interval.m3.respelledDownwards == .A2
  /// ```
  @override
  Interval get respelledDownwards => respellBySize(Size(size.incrementBy(-1)));

  /// This [Interval] rewritten with the simplest possible spelling for
  /// its [semitones] (i.e. whichever [Size] needs the least extreme
  /// [Quality] to reach that many semitones), via [Interval.fromSemitones].
  ///
  /// Example:
  /// ```dart
  /// Interval.d2.respelledDownwards == .P1
  /// Interval.A3.respelledDownwards == .P4
  /// ```
  @override
  Interval get respelledSimple => .fromSemitones(semitones);

  /// This [Interval] reduced to its [IntervalClass]: the unsigned,
  /// octave-folded semitone distance it shares with every enharmonic and
  /// direction-flipped equivalent.
  ///
  /// Example:
  /// ```dart
  /// Interval.m2.toClass() == .m2
  /// Interval.d4.toClass() == .M3
  /// Interval.P8.toClass() == .P1
  /// ```
  @override
  IntervalClass toClass() => IntervalClass(semitones);

  /// The string representation of this [Interval], using [formatter]
  /// (standard letter-symbol notation by default, e.g. `M3`).
  ///
  /// Example:
  /// ```dart
  /// Interval.M3.format() == 'M3'
  /// (-Interval.d5).format() == 'd-5'
  /// .twelfth.perfect.format() == 'P12 (P5)'
  /// ```
  @override
  String format([
    StringFormatter<Interval> formatter = const StandardIntervalNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(size: $size, quality: $quality)';

  /// This [Interval] followed immediately by [other], stacked from a
  /// common reference pitch and re-measured as a single [Interval] (e.g.
  /// a minor third plus a major third makes a perfect fifth).
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

  /// This [Interval] with [other] taken back out, the inverse of
  /// [operator +] (e.g. a perfect fifth minus a major third leaves a
  /// minor third).
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

  /// This [Interval] with its direction flipped, keeping the same [size]
  /// magnitude and [quality] (equivalent to [descending] when ascending,
  /// or [ascending] when descending).
  ///
  /// Example:
  /// ```dart
  /// Interval.perfect(-Size.fifth).descending == .P5
  /// Interval.m3.descending == (-Size.third).minor
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

/// Interval-generated cycles over [Scalable] values — walking repeatedly
/// by the same [Interval], the way the circle of fifths is generated by
/// repeatedly stacking [Interval.P5].
extension IntervalCircle on Interval {
  /// How many steps of this [Interval] (in whichever direction is
  /// shorter) it takes to walk from [from] to [to], alongside every
  /// intermediate `notes` visited along that path; negative when the
  /// shorter path is this [Interval]'s [inversion] direction rather than
  /// itself.
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

  /// The infinite sequence of [scalable] repeatedly transposed by this
  /// [Interval] — [scalable] itself, then [scalable] transposed once, then
  /// twice, and so on (bounded internally, so callers should always
  /// [Iterable.take] a finite prefix).
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
}

/// Step-by-step analysis of a sequence of [Interval]s measured from a
/// common origin, as in a chord's intervals-from-the-root list.
extension IntervalIterable on Iterable<Interval> {
  /// The [Interval] from each element to the next, treating the sequence
  /// as if measured cumulatively from a shared [Interval.P1] origin (e.g.
  /// turning a chord's from-the-root interval list into the interval
  /// *between* each consecutive pair of chord tones).
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
