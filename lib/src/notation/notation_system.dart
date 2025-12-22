// ignore_for_file: one_member_abstracts - Code reusability

/// An abstract representation of a notation system for parsing
/// and formatting [I].
///
/// The [parse] and [format] methods should be designed to be [inverses](https://en.wikipedia.org/wiki/Inverse_function)
/// of each other:
/// the output of [format] should be a valid argument for [parse], and
/// `parse(format(value))` should return a value equal to the original value.
abstract class NotationSystem<I, O> implements Parser<O, I>, Formatter<I, O> {
  /// Creates a new formatter.
  const NotationSystem();

  /// Parses [source] as [I].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  ///
  /// If the [source] string does not contain a valid [I], a [FormatException]
  /// should be thrown.
  @override
  I parse(O source);

  /// Formats this [I].
  ///
  /// The output of this method should be accepted by [parse] to reconstruct
  /// the original value.
  @override
  O format(I value);
}

/// An abstract representation of a notation system for parsing
/// and formatting [V] from and to a string.
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

  /// Parses [source] as [V].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  ///
  /// If the [source] string does not contain a valid [V], a [FormatException]
  /// should be thrown.
  @override
  V parse(String source) => parseMatch(
    regExp?.firstMatch(source) ?? (throw FormatException('Invalid $V', source)),
  );

  @override
  V parseMatch(RegExpMatch match) => throw UnimplementedError(
    'parseMatch is not implemented for $runtimeType.',
  );

  /// Formats this [V].
  ///
  /// The output of this method should be accepted by [parse] to reconstruct
  /// the original value.
  @override
  String format(V value);
}

/// An abstract representation of a parser for [V].
abstract interface class Parser<I, V> {
  /// Parses [source] as [V].
  V parse(I source);
}

/// An abstract representation of a parser for [V].
abstract interface class StringParser<V> extends Parser<String, V> {
  /// The regular expression for matching [V].
  RegExp? get regExp;

  /// Whether [source] can be parsed with [parse].
  bool matches(String source);

  /// Parses [source] as [V].
  @override
  V parse(String source);

  /// Parses [match] from [regExp] as [V].
  V parseMatch(RegExpMatch match);
}

/// A [StringParser] chain.
extension StringParserChain<V> on List<StringParser<V>> {
  /// Parses [source] from this chain of [StringParser]s.
  V parse(String source) {
    for (final parser in this) {
      if (parser.matches(source)) return parser.parse(source);
    }
    throw FormatException('End of parser chain: invalid $V', source);
  }
}

/// An abstract representation of a formatter for [V].
abstract interface class Formatter<V, O> {
  /// Formats this [V].
  O format(V value);
}

/// An abstract representation of a string formatter for [V].
abstract interface class StringFormatter<V> extends Formatter<V, String> {}
