// ignore_for_file: one_member_abstracts - Code reusability

/// An abstract representation of a notation system for parsing
/// and formatting [T].
///
/// The [format] and [parse] methods should be designed to be [inverses](https://en.wikipedia.org/wiki/Inverse_function)
/// of each other:
/// the output of [format] should be a valid argument for [parse], and
/// `parse(format(value))` should return a value equal to the original value.
abstract class NotationSystem<T> implements Formatter<T>, Parser<T> {
  /// Creates a new formatter.
  const NotationSystem();

  /// Formats this [T].
  ///
  /// The output of this method should be accepted by [parse] to reconstruct
  /// the original value.
  @override
  String format(T value);

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

  /// Parses [source] as [T].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  ///
  /// If the [source] string does not contain a valid [T], a [FormatException]
  /// should be thrown.
  @override
  T parse(String source) => parseMatch(
    regExp?.firstMatch(source) ?? (throw FormatException('Invalid $T', source)),
  );

  @override
  T parseMatch(RegExpMatch match) => throw UnimplementedError(
    'parseMatch is not implemented for $runtimeType.',
  );
}

/// An abstract representation of a formatter for [T].
abstract interface class Formatter<T> {
  /// Formats this [T].
  String format(T value);
}

/// An abstract representation of a parser for [T].
abstract interface class Parser<T> {
  /// The regular expression for matching [T].
  RegExp? get regExp;

  /// Whether [source] can be parsed with [parse].
  bool matches(String source);

  /// Parses [source] as [T].
  T parse(String source);

  /// Parses [match] from [regExp] as [T].
  T parseMatch(RegExpMatch match);
}

/// A [Parser] chain.
extension ParserChain<T> on List<Parser<T>> {
  /// Parses [source] from this chain of [Parser]s.
  T parse(String source) {
    for (final parser in this) {
      if (parser.matches(source)) return parser.parse(source);
    }
    throw FormatException('End of parser chain: invalid $T', source);
  }
}
