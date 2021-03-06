part of music_notes;

enum Modes { Major, Menor }

extension ModesValues on Modes {
  /// Returns the inverted this [Modes] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Modes.Major.inverted == Modes.Menor
  /// Modes.Menor.inverted == Modes.Major
  /// ```
  Modes get opposite => this == Modes.Major ? Modes.Menor : Modes.Major;
}
