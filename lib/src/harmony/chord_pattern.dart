import 'package:collection/collection.dart'
    show IterableExtension, ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../chordable.dart';
import '../interval/interval.dart';
import '../interval/quality.dart';
import '../interval/size.dart';
import '../notation_system.dart';
import '../note/accidental.dart';
import '../scalable.dart';
import 'chord.dart';

/// A musical chord pattern.
///
/// ---
/// See also:
/// * [Chord].
/// * [Interval].
@immutable
class ChordPattern with Chordable<ChordPattern> {
  final List<Interval> _intervals;

  /// The intervals from the root note.
  List<Interval> get intervals => UnmodifiableListView(_intervals);

  /// Creates a new [ChordPattern] from [_intervals].
  const ChordPattern(this._intervals);

  /// A diminished triad [ChordPattern].
  static const diminishedTriad = ChordPattern([.m3, .d5]);

  /// A minor triad [ChordPattern].
  static const minorTriad = ChordPattern([.m3, .P5]);

  /// A major triad [ChordPattern].
  static const majorTriad = ChordPattern([.M3, .P5]);

  /// An augmented triad [ChordPattern].
  static const augmentedTriad = ChordPattern([.M3, .A5]);

  /// Creates a new [ChordPattern] from [intervalSteps].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.fromIntervalSteps([.m3, .M3]) == .minorTriad
  /// ChordPattern.fromIntervalSteps([.M3, .M3]) == .augmentedTriad
  /// ```
  factory ChordPattern.fromIntervalSteps(Iterable<Interval> intervalSteps) =>
      ChordPattern(
        intervalSteps.skip(1).fold([
          intervalSteps.first,
        ], (steps, interval) => [...steps, interval + steps.last]),
      );

  /// Creates a new [ChordPattern] from the given [quality].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.fromQuality(.augmented) == .augmentedTriad
  /// ChordPattern.fromQuality(.minor) == .minorTriad
  /// ```
  factory ChordPattern.fromQuality(ImperfectQuality quality) =>
      switch (quality) {
        .diminished => diminishedTriad,
        .minor => minorTriad,
        .major => majorTriad,
        .augmented => augmentedTriad,
        _ => majorTriad,
      };

  /// The chain of [Parser]s used to parse a [ChordPattern].
  static const parsers = [ChordPatternNotation()];

  /// Parse [source] as a [ChordPattern] and return its value.
  ///
  /// If the [source] string does not contain a valid [ChordPattern], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.parse('maj7') == .majorTriad.add7(.major)
  /// ChordPattern.parse('z') // throws a FormatException
  /// ```
  factory ChordPattern.parse(
    String source, {
    List<Parser<ChordPattern>> chain = parsers,
  }) => chain.parse(source);

  /// The [Chord] built on top of [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(Note.c) == const Chord<Note>([.c, .e, .g])
  /// ```
  Chord<T> on<T extends Scalable<T>>(T scalable) => Chord(
    _intervals.fold(
      [scalable],
      (chordItems, interval) => [...chordItems, scalable.transposeBy(interval)],
    ),
  );

  /// The [Chord] built under [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.under(Note.c)
  ///   == const Chord<Note>([.f, .a.flat, .c])
  /// ```
  Chord<T> under<T extends Scalable<T>>(T scalable) => Chord(
    _intervals
        .fold(
          [scalable],
          (chordItems, interval) => [
            ...chordItems,
            scalable.transposeBy(-interval),
          ],
        )
        .reversed
        .toList(growable: false),
  );

  /// The root triad of this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().rootTriad == .majorTriad
  /// ```
  ChordPattern get rootTriad => ChordPattern(_intervals.sublist(0, 2));

  /// Whether this [ChordPattern] is [ImperfectQuality.diminished].
  bool get isDiminished => rootTriad == diminishedTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.minor].
  bool get isMinor => rootTriad == minorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.major].
  bool get isMajor => rootTriad == majorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.augmented].
  bool get isAugmented => rootTriad == augmentedTriad;

  /// The modifier [Interval]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().modifiers
  ///   == const <Interval>[.m7, .M9]
  /// ```
  List<Interval> get modifiers => _intervals.sublist(2);

  /// This [ChordPattern] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().diminished
  ///   == const ChordPattern([.m3, .d5, .m7])
  /// ```
  @override
  ChordPattern get diminished =>
      ChordPattern([...diminishedTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.minor] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().minor
  ///   == const ChordPattern([.m3, .P5, .m7])
  /// ```
  @override
  ChordPattern get minor =>
      ChordPattern([...minorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.minorTriad.add7().major
  ///   == const ChordPattern([.M3, .P5, .m7])
  /// ```
  @override
  ChordPattern get major =>
      ChordPattern([...majorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().augmented
  ///   == const ChordPattern([.M3, .A5, .m7])
  /// ```
  @override
  ChordPattern get augmented =>
      ChordPattern([...augmentedTriad._intervals, ...modifiers]);

  /// Returns this [ChordPattern] adding [interval].
  @override
  ChordPattern add(Interval interval, {Set<Size>? replaceSizes}) {
    final sizesToReplace = [interval.size, ...?replaceSizes];
    final filteredIntervals = _intervals.whereNot(
      (chordInterval) => sizesToReplace.contains(chordInterval.size),
    );

    return ChordPattern([...filteredIntervals, interval]..sort());
  }

  /// Returns the [Interval] from [intervals] at the given [size], if any.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.at(.third) == .M3
  /// ChordPattern.diminishedTriad.at(.fifth) == .d5
  /// ChordPattern.minorTriad.add7().at(.seventh) == .m7
  /// ChordPattern.augmentedTriad.at(.ninth) == null
  /// ```
  Interval? at(Size size) =>
      intervals.firstWhereOrNull((interval) => interval.size == size);

  @override
  String toString({
    Formatter<ChordPattern> formatter = const ChordPatternNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(_intervals, other._intervals);

  @override
  int get hashCode => Object.hashAll(_intervals);
}

/// A notation system for [ChordPattern].
final class ChordPatternNotation extends NotationSystem<ChordPattern> {
  /// The [NotationSystem] for [Accidental].
  final Formatter<Accidental> accidentalNotation;

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
}
