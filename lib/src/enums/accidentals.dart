part of music_notes;

enum Accidentals {
  TripleSostingut,
  DobleSostingut,
  Sostingut,
  Becaire,
  Bemoll,
  DobleBemoll,
  TripleBemoll
}

extension AccidentalsValues on Accidentals {
  static const accidentalsValues = {
    Accidentals.TripleSostingut: 3,
    Accidentals.DobleSostingut: 2,
    Accidentals.Sostingut: 1,
    Accidentals.Becaire: 0,
    Accidentals.Bemoll: -1,
    Accidentals.DobleBemoll: -2,
    Accidentals.TripleBemoll: -3,
  };

  static const accidentalsSymbols = {
    Accidentals.TripleSostingut: '♯𝄪',
    Accidentals.DobleSostingut: '𝄪',
    Accidentals.Sostingut: '♯',
    Accidentals.Becaire: '♮',
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
  static Accidentals? fromValue(int value) =>
      accidentalsValues.keys.firstWhereOrNull(
        (accidental) =>
            Music.modValue(value + 3) - 3 == accidentalsValues[accidental],
      );

  /// Returns the value of this [Accidentals] enum item in [accidentalsValues].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.value == -1
  /// Accidentals.DobleSostingut.value == 2
  /// ```
  int get value => accidentalsValues[this]!;

  /// Returns the symbol of this [Accidentals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.symbol == '♭'
  /// Accidentals.DobleSostingut.symbol == '𝄪'
  /// ```
  String get symbol => accidentalsSymbols[this]!;

  /// Returns the incremented [Accidentals] enum item of this.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.DobleBemoll.incremented == Accidentals.TripleBemoll
  /// Accidentals.Sostingut.incremented == Accidentals.DobleSostingut
  /// ```
  Accidentals get incremented => increment(1)!;

  /// Returns the decremented [Accidentals] enum item of this.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.DobleBemoll.decremented == Accidentals.Bemoll
  /// Accidentals.Sostingut.decremented == Accidentals.Becaire
  /// ```
  Accidentals get decremented => decrement(1)!;

  /// Returns the incremented [Accidentals] enum item of this by [n].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.increment(2) == Accidentals.TripleBemoll
  /// Accidentals.Sostingut.increment(1) == Accidentals.DobleSostingut
  /// ```
  Accidentals? increment(int n) =>
      fromValue((value.abs() + n) * (value > 0 ? 1 : -1));

  /// Returns the decremented [Accidentals] enum item of this by [n].
  ///
  /// It is an alias for `increment(-n)`.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.Bemoll.decrement(2) == Accidentals.Sostingut
  /// Accidentals.Sostingut.decrement(1) == Accidentals.Becaire
  /// Accidentals.DobleBemoll.decrement(4) == Accidentals.DobleSostingut
  /// ```
  Accidentals? decrement(int n) => increment(-n);
}
