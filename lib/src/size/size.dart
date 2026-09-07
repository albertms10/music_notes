import 'package:collection/collection.dart' show IterableExtension, minBy;
import 'package:meta/meta.dart' show redeclare;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../quality/quality.dart';
import '../tuning_system/equal_temperament.dart';
import 'size_notation.dart';

/// The generic, letter-counting size of an [Interval] — "a third",
/// "a fifth", "a ninth" — counted inclusively across the staff
/// (line-space-line-space...) independently of how many semitones it
/// actually spans.
///
/// [Size] alone cannot distinguish a major third from a minor one (both
/// are "a third"); that refinement is [Quality]'s job, and the two
/// combine to make a full [Interval]. What [Size] does fix is whether a
/// [Quality.perfect] or [Quality] imperfect (major/minor) family applies
/// — unisons, fourths, fifths, and octaves are perfect-family
/// ([PerfectSize]); seconds, thirds, sixths, and sevenths are
/// imperfect-family ([ImperfectSize]) — which is why [Size] itself has
/// no `major`/`minor`/`perfect` shorthands of its own: use the matching
/// subtype's getters, or [Size.diminished]/[Size.augmented] which work
/// either way.
///
/// A negative [Size] denotes a descending interval; sizes beyond the
/// octave (ninths, elevenths, thirteenths, ...) are compound and can
/// always be reduced with [simple].
extension type const Size._(int size) implements int {
  /// Creates a new [Size] counting [size] letter-steps (positive
  /// ascending, negative descending; never zero).
  const Size(this.size) : assert(size != 0, 'Value must be non-zero.');

  /// A unison: the same letter twice, spanning no distance at all.
  static const unison = PerfectSize(1);

  /// A second, spanning two adjacent letters (e.g. C to D).
  static const second = ImperfectSize(2);

  /// A third, spanning three letters (e.g. C to E) — the interval that
  /// defines a triad's quality.
  static const third = ImperfectSize(3);

  /// A fourth, spanning four letters (e.g. C to F).
  static const fourth = PerfectSize(4);

  /// A fifth, spanning five letters (e.g. C to G) — the interval that
  /// generates the circle of fifths.
  static const fifth = PerfectSize(5);

  /// A sixth, spanning six letters (e.g. C to A).
  static const sixth = ImperfectSize(6);

  /// A seventh, spanning seven letters (e.g. C to B).
  static const seventh = ImperfectSize(7);

  /// An octave: the same letter one register up, spanning eight letters
  /// (e.g. C4 to C5) and closing the cycle back to a unison-like [Quality].
  static const octave = PerfectSize(8);

  /// A ninth (an octave plus a second), the smallest compound size.
  static const ninth = ImperfectSize(9);

  /// A tenth (an octave plus a third).
  static const tenth = ImperfectSize(10);

  /// An eleventh (an octave plus a fourth).
  static const eleventh = PerfectSize(11);

  /// A twelfth (an octave plus a fifth).
  static const twelfth = PerfectSize(12);

  /// A thirteenth (an octave plus a sixth), the largest size this
  /// library names directly in [ChordPattern.add13] and similar helpers.
  static const thirteenth = ImperfectSize(13);

  /// The three [Size]s of a triad: third and fifth above the root (the
  /// root itself is implicit).
  static const triad = <Size>{.third, .fifth};

  /// The four [Size]s of a tetrad (seventh chord): [triad] plus a
  /// seventh.
  static const tetrad = <Size>{...triad, .seventh};

  /// The semitone span of each simple [Size] under its "default" quality
  /// — [PerfectQuality.perfect] for the perfect-family sizes, or
  /// [ImperfectQuality.minor] for the imperfect-family ones — used as the
  /// baseline [semitones] measures deviation from.
  static const _sizeToSemitones = {
    unison: 0, // P
    second: 1, // m
    third: 3, // m
    fourth: 5, // P
    fifth: 7, // P
    sixth: 8, // m
    seventh: 10, // m
    octave: 12, // P
  };

  /// The chain of [StringParser]s used to parse a [Size]: its bare,
  /// signed integer count.
  static const parsers = [SizeNotation()];

  /// Parses [source] as a [Size] (a signed integer such as `3` or `-5`).
  factory Size.parse(
    String source, {
    List<StringParser<Size>> chain = parsers,
  }) => chain.parse(source);

  /// Reduces [semitones] to the `[0, chromaticDivisions]` range that
  /// [_sizeToSemitones]'s values live in, treating an exact octave
  /// specially so it maps to [chromaticDivisions] rather than wrapping to
  /// `0`.
  static int _normalizeSemitones(int semitones) {
    final absSemitones = semitones.abs();

    return absSemitones == chromaticDivisions
        ? chromaticDivisions
        : absSemitones % chromaticDivisions;
  }

  /// Extends a within-the-octave [normalizedSize] out to whichever
  /// compound (or negative) [Size] actually spans [semitones], adding an
  /// octave's worth of letter-steps (7) for every full octave [semitones]
  /// covers.
  factory Size._scaleToSemitones(Size normalizedSize, int semitones) {
    final absSemitones = semitones.abs();
    if (absSemitones == chromaticDivisions) {
      return Size(normalizedSize * semitones.sign);
    }

    final absResult = normalizedSize + (absSemitones ~/ chromaticDivisions) * 7;

    return Size(absResult * semitones.nonZeroSign);
  }

  /// The [Size] whose default quality spans exactly [semitones], or
  /// `null` if no simple interval measures that many semitones (e.g. 2
  /// semitones has no matching [Size], since that would be either an
  /// augmented unison or a minor second — ambiguous without a [Quality]).
  ///
  /// Example:
  /// ```dart
  /// Size.fromSemitones(8) == .sixth
  /// Size.fromSemitones(0) == .unison
  /// Size.fromSemitones(-12) == -Size.octave
  /// Size.fromSemitones(4) == null
  /// ```
  static Size? fromSemitones(int semitones) {
    final normalizedSemitones = _normalizeSemitones(semitones);
    final matchingSize = _sizeToSemitones.entries
        .firstWhereOrNull((entry) => entry.value == normalizedSemitones)
        ?.key;
    if (matchingSize == null) return null;

    return ._scaleToSemitones(matchingSize, semitones);
  }

  /// The [Size] whose default quality comes closest to spanning
  /// [semitones], breaking ties toward the smaller distance from zero
  /// (used by [Interval.fromSemitones] to guess a sensible spelling when
  /// none is exact).
  factory Size.nearestFromSemitones(int semitones) {
    final normalizedSemitones = _normalizeSemitones(semitones);
    final MapEntry<Size, int>(key: closest) = minBy(
      _sizeToSemitones.entries,
      (entry) => (normalizedSemitones - entry.value).abs(),
    )!;

    return ._scaleToSemitones(closest, semitones);
  }

  /// This [Size]'s default semitone span — [PerfectQuality.perfect] for
  /// perfect-family sizes, [ImperfectQuality.minor] for imperfect-family
  /// ones — the baseline an [Interval]'s [Quality.semitones] measures its
  /// deviation from.
  ///
  /// Example:
  /// ```dart
  /// Size.third.semitones == 3
  /// Size.fifth.semitones == 7
  /// (-Size.fifth).semitones == -7
  /// Size.seventh.semitones == 10
  /// Size.ninth.semitones == 13
  /// (-Size.ninth).semitones == -13
  /// ```
  int get semitones {
    final absSimple = simple.abs();
    final octaves = (abs() - absSimple) ~/ 7;

    return (_sizeToSemitones[absSimple]! + octaves * chromaticDivisions) * sign;
  }

  /// The most-diminished [Interval] one step narrower than this [Size]'s
  /// default quality — [PerfectQuality.diminished] for a perfect-family
  /// size, [ImperfectQuality.diminished] for an imperfect-family one.
  ///
  /// Example:
  /// ```dart
  /// Size.second.diminished == .d2
  /// Size.fifth.diminished == .d5
  /// (-Size.seventh).diminished == .d7.descending
  /// ```
  Interval get diminished =>
      isPerfect ? .perfect(this, .diminished) : .imperfect(this, .diminished);

  /// The [Interval] one step wider than this [Size]'s default quality —
  /// [PerfectQuality.augmented] for a perfect-family size,
  /// [ImperfectQuality.augmented] for an imperfect-family one.
  ///
  /// Example:
  /// ```dart
  /// Size.third.augmented == .A3
  /// Size.fourth.augmented == .A4
  /// (-Size.sixth).augmented == .A6.descending
  /// ```
  Interval get augmented =>
      isPerfect ? .perfect(this, .augmented) : .imperfect(this, .augmented);

  static int _inversion(Size size) {
    final diff = 9 - size.simple.size.abs();

    return (diff.isNegative ? diff.abs() + 2 : diff) * size.sign;
  }

  /// This [Size] flipped upside down, the way stacking a low note an
  /// octave higher turns a third into a sixth: perfect-family sizes stay
  /// perfect-family, imperfect-family sizes stay imperfect-family, and
  /// simple size + inverted size always add up to 9.
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// Size.third.inversion == .sixth
  /// Size.fourth.inversion == .fifth
  /// Size.seventh.inversion == .second
  /// (-Size.unison).inversion == -Size.octave
  /// ```
  ///
  /// If this [Size] is greater than [Size.octave], the simplified inversion
  /// is returned instead.
  ///
  /// Example:
  /// ```dart
  /// Size.ninth.inversion == .seventh
  /// Size.eleventh.inversion == .fifth
  /// ```
  Size get inversion => Size(_inversion(this));

  static int _simple(Size size) =>
      size.isCompound ? ((size.abs() - 1).nonZeroMod(7) + 1) * size.sign : size;

  /// This [Size] reduced within a single octave, folding away any whole
  /// octaves it spans (e.g. a thirteenth simplifies to a sixth).
  ///
  /// Example:
  /// ```dart
  /// Size.thirteenth.simple == .sixth
  /// (-Size.ninth).simple == -Size.second
  /// Size.octave.simple == .octave
  /// const Size(-22).simple == -Size.octave
  /// ```
  Size get simple => Size(_simple(this));

  /// Whether this [Size] belongs to the perfect family (unison, fourth,
  /// fifth, octave, or any of their compounds), which takes
  /// [PerfectQuality] rather than [ImperfectQuality].
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isPerfect == true
  /// Size.sixth.isPerfect == false
  /// (-Size.eleventh).isPerfect == true
  /// ```
  bool get isPerfect {
    if (abs() % 7 case Size.unison || Size.fourth || Size.fifth) return true;

    return false;
  }

  /// Whether this [Size] spans more than an octave (a ninth or larger).
  ///
  /// Example:
  /// ```dart
  /// Size.fifth.isCompound == false
  /// (-Size.sixth).isCompound == false
  /// Size.octave.isCompound == false
  /// Size.ninth.isCompound == true
  /// (-Size.eleventh).isCompound == true
  /// Size.thirteenth.isCompound == true
  /// ```
  bool get isCompound => abs() > octave;

  /// Whether this [Size], on its own generic shape alone, is dissonant:
  /// true for every second and seventh (in any octave), regardless of
  /// [Quality] — see [Interval.isDissonant] for the full dissonance rule
  /// that also accounts for quality.
  ///
  /// Example:
  /// ```dart
  /// Size.unison.isDissonant == false
  /// Size.fifth.isDissonant == false
  /// Size.seventh.isDissonant == true
  /// (-Size.ninth).isDissonant == true
  /// ```
  bool get isDissonant {
    if (simple.size.abs() case second || seventh) return true;

    return false;
  }

  /// The string representation of this [Size], using [formatter] (its
  /// bare signed integer by default).
  String format([StringFormatter<Size> formatter = const SizeNotation()]) =>
      formatter.format(this);

  /// This [Size] with its direction flipped: ascending becomes descending
  /// and vice versa, without changing which letter-count it represents.
  ///
  /// Example:
  /// ```dart
  /// -Size.fifth == const Size(-5)
  /// -const Size(-7) == .seventh
  /// ```
  @redeclare
  Size operator -() => Size(-size);
}

/// A [Size] from the perfect-family: unison, fourth, fifth, octave, or
/// any of their compounds (eleventh, twelfth, ...) — the sizes that take
/// [PerfectQuality] rather than major/minor [ImperfectQuality].
extension type const PerfectSize._(int size) implements Size {
  /// Creates a new [PerfectSize], asserting [size] actually belongs to
  /// the perfect family.
  const PerfectSize(this.size)
    // Copied from [Size.isPerfect] to allow const.
    : assert(
        ((1 << ((size < 0 ? -size : size) % 7)) & 50) != 0,
        'Interval must be perfect.',
      );

  /// The perfect [Interval] of this [PerfectSize] (e.g. [Size.fifth]
  /// gives [Interval.P5]).
  ///
  /// Example:
  /// ```dart
  /// Size.unison.perfect == .P1
  /// Size.fourth.perfect == .P4
  /// (-Size.fifth).perfect == .P5.descending
  /// ```
  Interval get perfect => .perfect(this);

  @redeclare
  PerfectSize get inversion => PerfectSize(Size._inversion(this));

  @redeclare
  PerfectSize get simple => PerfectSize(Size._simple(this));

  /// The negation of this [PerfectSize].
  ///
  /// Example:
  /// ```dart
  /// -Size.fifth == const Size(-5)
  /// -const Size(-8) == .octave
  /// ```
  @redeclare
  PerfectSize operator -() => PerfectSize(-size);
}

/// A [Size] from the imperfect family: second, third, sixth, seventh, or
/// any of their compounds (ninth, tenth, ...) — the sizes that take
/// major/minor [ImperfectQuality] rather than [PerfectQuality].
extension type const ImperfectSize._(int size) implements Size {
  /// Creates a new [ImperfectSize], asserting [size] actually belongs to
  /// the imperfect family.
  const ImperfectSize(this.size)
    // Copied from [Size.isPerfect] to allow const.
    : assert(
        ((1 << ((size < 0 ? -size : size) % 7)) & 50) == 0,
        'Interval must be imperfect.',
      );

  /// The major [Interval] of this [ImperfectSize] (e.g. [Size.third]
  /// gives [Interval.M3]).
  ///
  /// Example:
  /// ```dart
  /// Size.second.major == .M2
  /// Size.sixth.major == .M6
  /// (-Size.ninth).major == .M9.descending
  /// ```
  Interval get major => .imperfect(this, .major);

  /// The minor [Interval] of this [ImperfectSize] (e.g. [Size.third]
  /// gives [Interval.m3]).
  ///
  /// Example:
  /// ```dart
  /// Size.third.minor == .m3
  /// Size.seventh.minor == .m7
  /// (-Size.sixth).minor == .m6.descending
  /// ```
  Interval get minor => .imperfect(this, .minor);

  @redeclare
  ImperfectSize get inversion => ImperfectSize(Size._inversion(this));

  @redeclare
  ImperfectSize get simple => ImperfectSize(Size._simple(this));

  /// The negation of this [ImperfectSize].
  ///
  /// Example:
  /// ```dart
  /// -Size.third == const Size(-3)
  /// -const Size(-7) == .seventh
  /// ```
  @redeclare
  ImperfectSize operator -() => ImperfectSize(-size);
}
