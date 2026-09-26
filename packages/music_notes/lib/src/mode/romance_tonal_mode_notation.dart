import '../notation_system/notation_system.dart';
import 'mode.dart';

/// The Romance notation system for [TonalMode].
final class RomanceTonalModeNotation extends StringNotationSystem<TonalMode> {
  /// Creates a new [RomanceTonalModeNotation].
  const RomanceTonalModeNotation();

  static const _major = 'maggiore';
  static const _minor = 'minore';

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
