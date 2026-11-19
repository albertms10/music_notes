import '../notation_system/notation_system.dart';
import 'mode.dart';

/// The English notation system for [TonalMode].
///
/// ![EnglishTonalModeNotation](https://raw.githubusercontent.com/albertms10/music_notes/v0.29.0/packages/music_notes/doc/diagrams/EnglishTonalModeNotation.svg)
final class EnglishTonalModeNotation extends StringNotationSystem<TonalMode> {
  /// Creates a new [EnglishTonalModeNotation].
  const EnglishTonalModeNotation();

  static const _major = 'major';
  static const _minor = 'minor';

  static final RegExp _regExp = RegExp(
    '(?<mode>$_major|$_minor)',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  TonalMode parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('mode')?.toLowerCase()) {
        _major => .major,
        _ /* _minor */ => .minor,
      };

  @override
  String format(TonalMode tonalMode) => switch (tonalMode) {
    .major => _major,
    .minor => _minor,
  };
}
