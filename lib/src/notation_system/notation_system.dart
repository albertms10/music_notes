// ignore_for_file: one_member_abstracts - Code reusability

import 'package:meta/meta.dart' show immutable;

/// The pairing of a [Parser] and a [Formatter] for the same value type [I],
/// converting between it and some external representation [O] — for
/// [StringNotationSystem], conventionally a written notation such as
/// standard interval symbols (`m3`, `A4`) or scientific pitch spellings
/// (`C4`, `B♭3`).
///
/// [parse] and [format] are meant to be [inverse functions](https://en.wikipedia.org/wiki/Inverse_function)
/// of each other: anything [format] produces should be valid input to
/// [parse], and round-tripping a value through both should return an equal
/// value, i.e. `parse(format(value)) == value`.
@immutable
abstract class NotationSystem<I, O> implements Parser<O, I>, Formatter<I, O> {
  /// Creates a new formatter.
  const NotationSystem();

  /// Parses [source] as [I].
  ///
  /// [source] is typically something [format] produced, so that
  /// `parse(format(value)) == value`.
  ///
  /// Throws a [FormatException] if [source] does not encode a valid [I].
  @override
  I parse(O source);

  /// Renders this [I] in this notation system's external representation.
  ///
  /// The result should be valid input to [parse], reconstructing the
  /// original value.
  @override
  O format(I value);
}

/// A [NotationSystem] whose external representation [O] is [String] — the
/// base every concrete notation in this library (note names, intervals,
/// pitches, key signatures, chord symbols, and so on) extends, typically by
/// supplying a [regExp] and a [parseMatch] built from its named groups.
abstract class StringNotationSystem<V> extends NotationSystem<V, String>
    implements StringFormatter<V>, StringParser<V> {
  /// Creates a new formatter.
  const StringNotationSystem();

  @override
  RegExp? get regExp => null;

  @override
  bool matches(String source) =>
      regExp == null ||
      RegExp(
        '^${regExp?.pattern}\$',
        caseSensitive: regExp?.isCaseSensitive ?? true,
        unicode: regExp?.isUnicode ?? false,
      ).hasMatch(source);

  /// Parses [source] as [V] by matching it against [regExp] and delegating
  /// to [parseMatch].
  ///
  /// [source] is typically something [format] produced, so that
  /// `parse(format(value)) == value`.
  ///
  /// Throws a [FormatException] if [source] does not match [regExp].
  @override
  V parse(String source) => parseMatch(
    regExp?.firstMatch(source) ?? (throw FormatException('Invalid $V', source)),
  );

  @override
  V parseMatch(RegExpMatch match) => throw UnimplementedError(
    'parseMatch is not implemented for $runtimeType.',
  );

  /// Renders this [V] as a string accepted by [parse], reconstructing the
  /// original value.
  @override
  String format(V value);
}

/// A converter from an external representation [I] to a value [V] — the
/// read half of a [NotationSystem].
abstract interface class Parser<I, V> {
  /// Parses [source] as [V].
  V parse(I source);
}

/// A [Parser] that reads [V] out of a [String], typically by matching a
/// [regExp] and handing the resulting [RegExpMatch] to [parseMatch].
abstract interface class StringParser<V> extends Parser<String, V> {
  /// The pattern this parser recognizes as a valid [V], or `null` if this
  /// parser instead overrides [parse] directly without using a regular
  /// expression.
  RegExp? get regExp;

  /// Whether [source], taken as a whole, matches [regExp] (and so can be
  /// handed to [parse] without throwing).
  bool matches(String source);

  /// Parses [source] as [V].
  @override
  V parse(String source);

  /// Builds a [V] out of an already-successful [regExp] match, reading its
  /// named capture groups.
  V parseMatch(RegExpMatch match);
}

/// A prioritized fallback chain of [StringParser]s for the same value
/// type, used wherever a `parse` factory accepts multiple notations at
/// once (e.g. [Note.parse] trying English, German, then Romance spellings
/// in turn).
extension StringParserChain<V> on List<StringParser<V>> {
  /// Parses [source] using the first parser in this chain whose [regExp]
  /// matches it.
  ///
  /// Throws a [FormatException] if no parser in the chain matches [source].
  V parse(String source) =>
      firstMatchingParser(source)?.parse(source) ??
      (throw FormatException('End of parser chain: invalid $V', source));

  /// The first [StringParser] in this chain whose [StringParser.matches]
  /// accepts [source], or `null` if none do.
  StringParser<V>? firstMatchingParser(String source) {
    for (final parser in this) {
      if (parser.matches(source)) return parser;
    }

    return null;
  }
}

/// A converter from a value [V] to an external representation [O] — the
/// write half of a [NotationSystem].
abstract interface class Formatter<V, O> {
  /// Renders this [V] in this formatter's external representation.
  O format(V value);
}

/// A [Formatter] that renders [V] as a [String].
abstract interface class StringFormatter<V> extends Formatter<V, String> {}

/// A value with a canonical, notation-free [String] rendering (typically
/// delegating to a default [StringFormatter]), so it can be printed or
/// interpolated without callers having to pick a notation system
/// explicitly.
abstract class Formattable<V> {
  /// This [V] rendered using its default notation system.
  String format();
}
