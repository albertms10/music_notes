import '../notation_system/notation_system.dart';
import 'mode.dart';

/// The English notation system for [TonalMode].
final class EnglishTonalModeNotation extends StringNotationSystem<TonalMode> {
  /// Creates a new [EnglishTonalModeNotation].
  const EnglishTonalModeNotation();

  static const _major = 'major';
  static const _minor = 'minor';

  static const _pattern = '(?<mode>$_major|$_minor)';

  @override
  String get pattern => _pattern;

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
