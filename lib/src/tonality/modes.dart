part of '../../music_notes.dart';

enum Modes { major, minor }

extension ModesValues on Modes {
  /// Returns the inverted this [Modes] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Modes.major.inverted == Modes.minor
  /// Modes.minor.inverted == Modes.major
  /// ```
  Modes get opposite => this == Modes.major ? Modes.minor : Modes.major;
}
