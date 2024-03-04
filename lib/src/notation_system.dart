/// The abstraction of a notation system.
abstract class NotationSystem<T> {
  /// Creates a new [NotationSystem].
  const NotationSystem();

  /// The regular expression to match against a source.
  RegExp get regExp;

  /// The first match of [regExp] in [source].
  RegExpMatch? match(String source) => regExp.firstMatch(source);

  /// Parse [match] as a [T].
  T parse(RegExpMatch match);
}

/// A notation system List extension.
extension NotationSystemListExtension<T> on List<NotationSystem<T>> {
  /// Tries to parse [source] as a [T] in any [NotationSystem].
  /// Otherwise, throws a [FormatException].
  T parse(String source) {
    for (final system in this) {
      final match = system.match(source);
      if (match != null) return system.parse(match);
    }

    throw FormatException('Invalid ${T.runtimeType}', source);
  }
}
