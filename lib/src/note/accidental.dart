part of '../../music_notes.dart';

/// An accidental.
class Accidental {
  /// The value representing this [Accidental]:
  ///
  /// - `> 0` for sharps.
  /// - `== 0` for natural.
  /// - `< 0` for flats.
  final int semitones;

  /// Creates a new [Accidental] from [semitones].
  const Accidental(this.semitones);

  static const Accidental tripleSharp = Accidental(3);
  static const Accidental doubleSharp = Accidental(2);
  static const Accidental sharp = Accidental(1);
  static const Accidental natural = Accidental(0);
  static const Accidental flat = Accidental(-1);
  static const Accidental doubleFlat = Accidental(-2);
  static const Accidental tripleFlat = Accidental(-3);

  static const String _doubleSharpSymbol = '𝄪';
  static const String _sharpSymbol = '♯';
  static const String _naturalSymbol = '♮';
  static const String _flatSymbol = '♭';
  static const String _doubleFlatSymbol = '𝄫';

  /// Returns the symbol of this [Accidental].
  ///
  /// Examples:
  /// ```dart
  /// assert(Accidental.flat.symbol == '♭')
  /// assert(Accidental.doubleSharp.symbol == '𝄪')
  /// ```
  String get symbol {
    if (semitones == 0) return _naturalSymbol;

    return (semitones.isOdd
            ? (semitones.isNegative ? _flatSymbol : _sharpSymbol)
            : '') +
        (semitones.isNegative ? _doubleFlatSymbol : _doubleSharpSymbol) *
            (semitones.abs() ~/ 2);
  }

  @override
  String toString() => '$symbol ($semitones)';

  @override
  bool operator ==(Object other) =>
      other is Accidental && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;
}
