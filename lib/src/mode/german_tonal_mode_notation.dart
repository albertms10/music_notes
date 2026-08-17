import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import 'mode.dart';

/// The German notation system for [TonalMode].
final class GermanTonalModeNotation extends StringNotationSystem<TonalMode> {
  /// Creates a new [GermanTonalModeNotation].
  const GermanTonalModeNotation();

  static const _major = 'dur';
  static const _minor = 'moll';

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
  }.toUpperFirst();
}
