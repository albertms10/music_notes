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

  /// Returns an [Accidentals] enum item that matches [value]
  /// in [accidentalValues], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// AccidentalsValues.fromValue(1) == Accidentals.Sostingut
  /// AccidentalsValues.fromValue(-2) == Accidentals.DobleBemoll
  /// AccidentalsValues.fromValue(3) == Accidentals.TripleSostingut
  /// ```
  static Accidentals fromValue(int value) => accidentalValues.keys.firstWhere(
        (accidental) =>
            Music.modValue(value + 3) - 3 == accidentalValues[accidental],
        orElse: () => null,
      );

  /// Returns the value of this [AccidentalsValues] enum item in [accidentalValues].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.value == -1
  /// Accidentals.DobleSostingut.value == 2
  /// ```
  int get value => accidentalValues[this];

  Accidentals get incremented => increment(1);

  Accidentals increment(int n) =>
      fromValue(value.abs() + n * (value > 0 ? 1 : -1));
}
