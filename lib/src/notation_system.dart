// ignore_for_file: one_member_abstracts - Code reusability

/// An abstract representation of a notation system for parsing
/// and formatting [I].
///
/// The [format] and [parse] methods should be designed to be [inverses](https://en.wikipedia.org/wiki/Inverse_function)
/// of each other:
/// the output of [format] should be a valid argument for [parse], and
/// `parse(format(value))` should return a value equal to the original value.
abstract class NotationSystem<I, O> implements Formatter<I, O>, Parser<O, I> {
  /// Creates a new formatter.
  const NotationSystem();

  /// Formats this [I].
  ///
  /// The output of this method should be accepted by [parse] to reconstruct
  /// the original value.
  @override
  O format(I value);

  /// Parses [source] as [I].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  ///
  /// If the [source] string does not contain a valid [I], a [FormatException]
  /// should be thrown.
  @override
  I parse(O source);
}

/// An abstract representation of a notation system for parsing
/// and formatting [I] from and to a string.
abstract class StringNotationSystem<I>
    implements StringFormatter<I>, StringParser<I> {
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

  /// Parses [source] as [I].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  ///
  /// If the [source] string does not contain a valid [I], a [FormatException]
  /// should be thrown.
  @override
  I parse(String source) => parseMatch(
    regExp?.firstMatch(source) ?? (throw FormatException('Invalid $I', source)),
  );

  @override
  I parseMatch(RegExpMatch match) => throw UnimplementedError(
    'parseMatch is not implemented for $runtimeType.',
  );
}

/// An abstract representation of a formatter for [I].
abstract interface class Formatter<I, O> {
  /// Formats this [I].
  O format(I value);
}

/// An abstract representation of a string formatter for [I].
abstract interface class StringFormatter<I> extends Formatter<I, String> {}

/// An abstract representation of a parser for [O].
abstract interface class Parser<S, O> {
  /// Parses [source] as [O].
  O parse(S source);
}

/// An abstract representation of a parser for [O].
abstract interface class StringParser<O> extends Parser<String, O> {
  /// The regular expression for matching [O].
  RegExp? get regExp;

  /// Whether [source] can be parsed with [parse].
  bool matches(String source);

  /// Parses [source] as [O].
  @override
  O parse(String source);

  /// Parses [match] from [regExp] as [O].
  O parseMatch(RegExpMatch match);
}

/// A [StringParser] chain.
extension StringParserChain<O> on List<StringParser<O>> {
  /// Parses [source] from this chain of [StringParser]s.
  O parse(String source) {
    for (final parser in this) {
      if (parser.matches(source)) return parser.parse(source);
    }
    throw FormatException('End of parser chain: invalid $O', source);
  }
}
