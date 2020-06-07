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
  static const accidentalsValues = {
    Accidentals.TripleSostingut: 3,
    Accidentals.DobleSostingut: 2,
    Accidentals.Sostingut: 1,
    Accidentals.Bemoll: -1,
    Accidentals.DobleBemoll: -2,
    Accidentals.TripleBemoll: -3,
  };

  static const accidentalsSymbols = {
    Accidentals.TripleSostingut: '♯𝄪',
    Accidentals.DobleSostingut: '𝄪',
    Accidentals.Sostingut: '♯',
    Accidentals.Bemoll: '♭',
    Accidentals.DobleBemoll: '𝄫',
    Accidentals.TripleBemoll: '♭𝄫',
  };

  /// Returns an [Accidentals] enum item that matches [value]
  /// in [accidentalsValues], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// AccidentalsValues.fromValue(1) == Accidentals.Sostingut
  /// AccidentalsValues.fromValue(-2) == Accidentals.DobleBemoll
  /// AccidentalsValues.fromValue(3) == Accidentals.TripleSostingut
  /// ```
  static Accidentals fromValue(int value) => accidentalsValues.keys.firstWhere(
        (accidental) =>
            Music.modValue(value + 3) - 3 == accidentalsValues[accidental],
        orElse: () => null,
      );

  /// Returns the value of this [AccidentalsValues] enum item in [accidentalsValues].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.value == -1
  /// Accidentals.DobleSostingut.value == 2
  /// ```
  int get value => accidentalsValues[this];

  String get symbol => accidentalsSymbols[this];

  Accidentals get incremented => increment(1);

  Accidentals increment(int n) =>
      fromValue(value.abs() + n * (value > 0 ? 1 : -1));
}
