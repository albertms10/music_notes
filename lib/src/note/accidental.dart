part of '../../music_notes.dart';

/// An accidental.
class Accidental {
  /// The value representing this [Accidental]:
  ///
  /// - `> 0` for sharps.
  /// - `== 0` for natural.
  /// - `< 0` for flats.
  final int value;

  /// Creates a new [Accidental] from a [value].
  const Accidental(this.value);

  static const Accidental tripleSharp = Accidental(3);
  static const Accidental doubleSharp = Accidental(2);
  static const Accidental sharp = Accidental(1);
  static const Accidental natural = Accidental(0);
  static const Accidental flat = Accidental(-1);
  static const Accidental doubleFlat = Accidental(-2);
  static const Accidental tripleFlat = Accidental(-3);

  static const String doubleSharpSymbol = '𝄪';
  static const String sharpSymbol = '♯';
  static const String naturalSymbol = '♮';
  static const String flatSymbol = '♭';
  static const String doubleFlatSymbol = '𝄫';

  /// Returns the symbol of this [Accidental].
  ///
  /// Examples:
  /// ```dart
  /// assert(Accidental.flat.symbol == '♭')
  /// assert(Accidental.doubleSharp.symbol == '𝄪')
  /// ```
  String get symbol {
    if (value == 0) return naturalSymbol;

    return (value.isOdd ? (value.isNegative ? flatSymbol : sharpSymbol) : '') +
        (value.isNegative ? doubleFlatSymbol : doubleSharpSymbol) *
            (value.abs() ~/ 2);
  }

  @override
  bool operator ==(Object other) => other is Accidental && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
