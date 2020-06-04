part of music_notes;

enum Modes { Major, Menor }

extension ModesValues on Modes {
  /// Returns the inverted this [Modes] enum item.
  /// 
  /// ```dart
  /// Modes.Major.inverted == Modes.Menor
  /// Modes.Menor.inverted == Modes.Major
  /// ```
  Modes get inverted => this == Modes.Major ? Modes.Menor : Modes.Major;
}
