import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../quality/quality.dart';
import '../size/size.dart';
import 'chord_pattern.dart';

/// A notation system for [ChordPattern].
final class ChordPatternNotation extends StringNotationSystem<ChordPattern> {
  /// The [StringFormatter] for [Accidental].
  final StringFormatter<Accidental> accidentalNotation;

  /// Creates a new [ChordPatternNotation].
  const ChordPatternNotation({
    this.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
    ),
  });

  static const _augmentedTriad = '+';
  static const _majorTriad = '';
  static const _minorTriad = '-';
  static const _diminishedTriad = 'dim';

  static const _majorSeventh = 'maj';
  static const _diminishedSeventh = 'º';
  static const _halfDiminished = 'ø';

  static const _sus = 'sus';

  @override
  ChordPattern parse(String source) {
    var s = source.replaceAll(' ', '').toLowerCase();

    if (s == _halfDiminished) return .diminishedTriad.add7();

    ChordPattern triad;
    if (s.startsWith(_diminishedTriad)) {
      triad = .diminishedTriad;
      s = s.substring(3);
    } else if (s.startsWith(_augmentedTriad)) {
      triad = .augmentedTriad;
      s = s.substring(1);
    } else if (s.startsWith(_minorTriad)) {
      triad = .minorTriad;
      s = s.substring(1);
    } else {
      triad = .majorTriad;
    }

    if (s.startsWith('$_majorSeventh${Size.seventh}')) {
      return triad.add7(.major);
    } else if (s.startsWith('${Size.seventh}')) {
      return triad.add7();
    }

    if (s.contains('$_sus${Size.second}')) {
      triad = const ChordPattern([.M2, .P5]);
      s = s.replaceAll('$_sus${Size.second}', '');
    } else if (s.contains('$_sus${Size.fourth}')) {
      triad = const ChordPattern([.P4, .P5]);
      s = s.replaceAll('$_sus${Size.fourth}', '');
    }

    return triad;
  }

  @override
  String format(ChordPattern chordPattern) {
    final buffer = StringBuffer();

    if (chordPattern.isAugmented) {
      buffer.write(_augmentedTriad);
    } else if (chordPattern.isMajor) {
      buffer.write(_majorTriad);
    } else if (chordPattern.isMinor) {
      buffer.write(_minorTriad);
    }

    if (chordPattern.isDiminished) {
      final seventh = chordPattern.at(Size.seventh);
      if (seventh != null) {
        buffer.write(switch (seventh.quality) {
          ImperfectQuality.diminished => _diminishedSeventh,
          ImperfectQuality.minor => _halfDiminished,
          _ => '',
        });
      } else {
        buffer.write(_diminishedTriad);
      }
    }

    if (chordPattern.intervals.first.size
        case (.second || .fourth) && final size) {
      buffer.write('$_sus$size');
    }

    final intervals = chordPattern.modifiers.map((interval) {
      final part = switch (interval) {
        Interval(size: .seventh, quality: ImperfectQuality.major) =>
          _majorSeventh,
        Interval(size: .ninth || .thirteenth, :final quality) =>
          accidentalNotation.format(Accidental(quality.semitones - 1)),
        Interval(size: .eleventh, :final quality) => accidentalNotation.format(
          Accidental(quality.semitones),
        ),
        _ => '',
      };
      return '$part${chordPattern.isDiminished ? '' : interval.size}';
    });

    buffer.writeAll(intervals, ' ');

    return buffer.toString();
  }
}
