import '../notation_system/notation_system.dart';
import 'mode.dart';

/// The Romance notation system for [TonalMode].
final class RomanceTonalModeNotation extends StringNotationSystem<TonalMode> {
  /// Creates a new [RomanceTonalModeNotation].
  const RomanceTonalModeNotation();

  static const _major = 'maggiore';
  static const _minor = 'minore';

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
