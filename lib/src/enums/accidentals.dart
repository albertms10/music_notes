part of music_notes;

enum Accidentals {
  TripleSostingut,
  DobleSostingut,
  Sostingut,
  Bemoll,
  DobleBemoll,
  TripleBemoll
}

extension AccidentalsValues on Accidentals {
  static const accidentalValues = {
    Accidentals.TripleSostingut: 3,
    Accidentals.DobleSostingut: 2,
    Accidentals.Sostingut: 1,
    Accidentals.Bemoll: -1,
    Accidentals.DobleBemoll: -2,
    Accidentals.TripleBemoll: -3,
  };

  /// Returns an [Accidentals] enum item that matches [value].
  ///
  /// ```dart
  /// AccidentalsValues.fromValue(1) == Accidentals.Sostingut
  /// AccidentalsValues.fromValue(-2) == Accidentals.DobleBemoll
  /// AccidentalsValues.fromValue(3) == Accidentals.TripleSostingut
  /// ```
  static Accidentals fromValue(int value) => accidentalValues.keys.firstWhere(
        (accidental) =>
            Music.modValue(value + 2) - 2 == accidentalValues[accidental],
        orElse: () => null,
      );

  /// Returns the value of this [Accidentals] enum item.
  /// 
  /// ```dart
  /// Accidentals.Bemoll.value == -1
  /// Accidentals.DobleSostingut.value == 2
  /// ```
  int get value => accidentalValues[this];
}
