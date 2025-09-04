import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../harmony/chord.dart';
import '../interval/quality.dart';
import '../notation_system.dart';
import '../note/accidental.dart';
import 'scale.dart';

/// A scale degree.
///
/// ---
/// See also:
/// * [Scale].
@immutable
class ScaleDegree implements Comparable<ScaleDegree> {
  /// The ordinal that identifies this [ScaleDegree].
  final int ordinal;

  /// The inversion of the [Chord] above this [ScaleDegree].
  final int inversion;

  /// The quality of the [Chord] above this [ScaleDegree].
  final ImperfectQuality? quality;

  /// The semitones raising or lowering this [ScaleDegree]’s root note.
  final int semitonesDelta;

  /// Creates a new [ScaleDegree].
  const ScaleDegree(
    this.ordinal, {
    this.quality,
    this.inversion = 0,
    this.semitonesDelta = 0,
  }) : assert(ordinal > 0, 'Ordinal must be greater than zero.'),
       assert(inversion >= 0, 'Inversion must be greater or equal than zero.');

  /// The I (tonic) [ScaleDegree].
  static const i = ScaleDegree(1);

  /// The II [ScaleDegree].
  static const ii = ScaleDegree(2);

  /// The neapolitan sixth [ScaleDegree].
  static const neapolitanSixth = ScaleDegree(
    2,
    quality: ImperfectQuality.major,
    inversion: 1,
    semitonesDelta: -1,
  );

  /// The III [ScaleDegree].
  static const iii = ScaleDegree(3);

  /// The IV [ScaleDegree].
  static const iv = ScaleDegree(4);

  /// The V [ScaleDegree].
  static const v = ScaleDegree(5);

  /// The VI [ScaleDegree].
  static const vi = ScaleDegree(6);

  /// The VII [ScaleDegree].
  static const vii = ScaleDegree(7);

  /// Parse [source] as a [ScaleDegree] and return its value.
  ///
  /// If the [source] string does not contain a valid [ScaleDegree], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.parse('I') == ScaleDegree.i.major
  /// ScaleDegree.parse('bII6') == ScaleDegree.neapolitanSixth
  /// ScaleDegree.parse('vi') == ScaleDegree.vi.minor
  /// ScaleDegree.parse('z') // throws a FormatException
  /// ```
  factory ScaleDegree.parse(
    String source, {
    List<Parser<ScaleDegree>> chain = const [StandardScaleDegreeNotation()],
  }) => chain.parse(source).match;

  /// Whether this [ScaleDegree] is raised.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.raised.isRaised == true
  /// ScaleDegree.neapolitanSixth.isRaised == false
  /// ```
  bool get isRaised => semitonesDelta > 0;

  /// Whether this [ScaleDegree] is lowered.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.isLowered == false
  /// ScaleDegree.neapolitanSixth.isLowered == true
  /// ```
  bool get isLowered => semitonesDelta.isNegative;

  /// This [ScaleDegree] raised by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.raised == const ScaleDegree(6, semitonesDelta: 1)
  /// ```
  ScaleDegree get raised => copyWith(semitonesDelta: semitonesDelta + 1);

  /// This [ScaleDegree] lowered by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.lowered == const ScaleDegree(2, semitonesDelta: -1)
  /// ```
  ScaleDegree get lowered => copyWith(semitonesDelta: semitonesDelta - 1);

  /// This [ScaleDegree] inverted.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vii.inverted == const ScaleDegree(7, inversion: 1)
  /// ScaleDegree.i.inverted.inverted == const ScaleDegree(1, inversion: 2)
  /// ```
  ScaleDegree get inverted => copyWith(inversion: inversion + 1);

  /// This [ScaleDegree] as [ImperfectQuality.major].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.major
  ///   == const ScaleDegree(2, quality: ImperfectQuality.major)
  /// ```
  ScaleDegree get major => copyWith(quality: ImperfectQuality.major);

  /// This [ScaleDegree] as [ImperfectQuality.minor].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.v.minor
  ///   == const ScaleDegree(5, quality: ImperfectQuality.minor)
  /// ```
  ScaleDegree get minor => copyWith(quality: ImperfectQuality.minor);

  /// Creates a new [ScaleDegree] from this one by updating individual
  /// properties.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.i.copyWith(inversion: 2) == ScaleDegree.i.inverted.inverted
  /// ScaleDegree.vi.copyWith(semitonesDelta: -1) == ScaleDegree.vi.lowered
  /// ```
  ScaleDegree copyWith({
    int? ordinal,
    ImperfectQuality? quality,
    int? inversion,
    int? semitonesDelta,
  }) => ScaleDegree(
    ordinal ?? this.ordinal,
    quality: quality ?? this.quality,
    inversion: inversion ?? this.inversion,
    semitonesDelta: semitonesDelta ?? this.semitonesDelta,
  );

  static const _romanNumerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii'];

  /// The roman numeral of this [ScaleDegree] based on [ordinal].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.i.romanNumeral == 'I'
  /// ScaleDegree.vii.romanNumeral == 'VII'
  /// ScaleDegree.neapolitanSixth.romanNumeral == 'II'
  /// ```
  String get romanNumeral =>
      _romanNumerals.elementAtOrNull(ordinal - 1)?.toUpperCase() ?? '$ordinal';

  /// The string representation of this [ScaleDegree] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.iii.toString() == 'III'
  /// ScaleDegree.vi.minor.lowered.toString() == '♭vi'
  /// ScaleDegree.neapolitanSixth.toString() == '♭II6'
  /// ```
  @override
  String toString({
    Formatter<ScaleDegree> formatter = const StandardScaleDegreeNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is ScaleDegree &&
      ordinal == other.ordinal &&
      inversion == other.inversion &&
      quality == other.quality &&
      semitonesDelta == other.semitonesDelta;

  @override
  int get hashCode => Object.hash(ordinal, inversion, quality, semitonesDelta);

  @override
  int compareTo(ScaleDegree other) => compareMultiple([
    () => ordinal.compareTo(other.ordinal),
    () => semitonesDelta.compareTo(other.semitonesDelta),
    () => inversion.compareTo(other.inversion),
    () {
      if (quality != null && other.quality != null) {
        return quality!.compareTo(other.quality!);
      }
      if (quality != null) return -1;
      if (other.quality != null) return 1;

      return 0;
    },
  ]);
}

/// The standard [ScaleDegree] notation formatter.
final class StandardScaleDegreeNotation extends NotationSystem<ScaleDegree> {
  /// The [NotationSystem] for [Accidental].
  final NotationSystem<Accidental> accidentalNotation;

  /// Creates a new [StandardScaleDegreeNotation].
  const StandardScaleDegreeNotation({
    this.accidentalNotation = const SymbolAccidentalNotation(),
  });

  static const _inversions = ['6', '64'];

  @override
  String format(ScaleDegree scaleDegree) {
    final buffer = StringBuffer()
      ..writeAll([
        if (scaleDegree.semitonesDelta != 0)
          accidentalNotation.format(Accidental(scaleDegree.semitonesDelta)),
        if (scaleDegree.quality case ImperfectQuality(
          :final semitones,
        ) when semitones <= 0)
          scaleDegree.romanNumeral.toLowerCase()
        else
          scaleDegree.romanNumeral,
        if (scaleDegree.inversion != 0)
          _inversions.elementAtOrNull(scaleDegree.inversion - 1) ?? '',
      ]);

    return buffer.toString();
  }

  static final _regExp = RegExp(
    '(?<accidental>[${SymbolAccidentalNotation.symbols.join()}]*)'
    '(?<romanNumeral>${ScaleDegree._romanNumerals.join('|')})'
    '(?<inversion>${_inversions.join('|')})?\$',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  ScaleDegree parseMatch(RegExpMatch match) {
    final accidentalPart = match.namedGroup('accidental')!;
    final accidental = accidentalPart.isNotEmpty
        ? Accidental.parse(accidentalPart, chain: [accidentalNotation])
        : Accidental.natural;
    final numeral = match.namedGroup('romanNumeral')!;

    return ScaleDegree(
      ScaleDegree._romanNumerals.indexOf(numeral.toLowerCase()) + 1,
      inversion: _inversions.indexOf(match.namedGroup('inversion') ?? '') + 1,
      quality: numeral.isUpperCase
          ? ImperfectQuality.major
          : ImperfectQuality.minor,
      semitonesDelta: accidental.semitones,
    );
  }
}
