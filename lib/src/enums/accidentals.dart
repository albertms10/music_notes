part of '../../music_notes.dart';

enum Accidentals {
  tripleSharp,
  doubleSharp,
  sharp,
  natural,
  flat,
  doubleFlat,
  tripleFlat,
}

extension AccidentalsValues on Accidentals {
  static const accidentalsValues = {
    Accidentals.tripleSharp: 3,
    Accidentals.doubleSharp: 2,
    Accidentals.sharp: 1,
    Accidentals.natural: 0,
    Accidentals.flat: -1,
    Accidentals.doubleFlat: -2,
    Accidentals.tripleFlat: -3,
  };

  static const accidentalsSymbols = {
    Accidentals.tripleSharp: '♯𝄪',
    Accidentals.doubleSharp: '𝄪',
    Accidentals.sharp: '♯',
    Accidentals.natural: '♮',
    Accidentals.flat: '♭',
    Accidentals.doubleFlat: '𝄫',
    Accidentals.tripleFlat: '♭𝄫',
  };

  /// Returns an [Accidentals] enum item that matches [value]
  /// in [accidentalsValues], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// AccidentalsValues.fromValue(1) == Accidentals.sharp
  /// AccidentalsValues.fromValue(-2) == Accidentals.doubleFlat
  /// AccidentalsValues.fromValue(3) == Accidentals.tripleSharp
  /// ```
  static Accidentals? fromValue(int value) =>
      accidentalsValues.keys.firstWhereOrNull(
        (accidental) =>
            chromaticMod(value + 3) - 3 == accidentalsValues[accidental],
      );

  /// Returns the value of this [Accidentals] enum item in [accidentalsValues].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.flat.value == -1
  /// Accidentals.doubleSharp.value == 2
  /// ```
  int get value => accidentalsValues[this]!;

  /// Returns the symbol of this [Accidentals] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.flat.symbol == '♭'
  /// Accidentals.doubleSharp.symbol == '𝄪'
  /// ```
  String get symbol => accidentalsSymbols[this]!;

  /// Returns the incremented [Accidentals] enum item of this.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.doubleFlat.incremented == Accidentals.tripleFlat
  /// Accidentals.sharp.incremented == Accidentals.doubleSharp
  /// ```
  Accidentals get incremented => increment(1)!;

  /// Returns the decremented [Accidentals] enum item of this.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.doubleFlat.decremented == Accidentals.flat
  /// Accidentals.sharp.decremented == Accidentals.natural
  /// ```
  Accidentals get decremented => decrement(1)!;

  /// Returns the incremented [Accidentals] enum item of this by [n].
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.flat.increment(2) == Accidentals.tripleFlat
  /// Accidentals.sharp.increment(1) == Accidentals.doubleSharp
  /// ```
  Accidentals? increment(int n) =>
      fromValue((value.abs() + n) * (value > 0 ? 1 : -1));

  /// Returns the decremented [Accidentals] enum item of this by [n].
  ///
  /// It is an alias for `increment(-n)`.
  ///
  /// Examples:
  /// ```dart
  /// Accidentals.flat.decrement(2) == Accidentals.sharp
  /// Accidentals.sharp.decrement(1) == Accidentals.natural
  /// Accidentals.doubleFlat.decrement(4) == Accidentals.doubleSharp
  /// ```
  Accidentals? decrement(int n) => increment(-n);
}
