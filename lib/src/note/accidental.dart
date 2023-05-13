part of '../../music_notes.dart';

/// An accidental.
@immutable
final class Accidental implements Comparable<Accidental> {
  /// The number of semitones above or below the natural note.
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

  /// The name of this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp.name == 'Sharp'
  /// Accidental.doubleFlat.name == 'Double flat'
  /// Accidental.natural.name == 'Natural'
  /// ```
  String? get name => switch (semitones) {
        3 => 'Triple sharp',
        2 => 'Double sharp',
        1 => 'Sharp',
        0 => 'Natural',
        -1 => 'Flat',
        -2 => 'Double flat',
        -3 => 'Triple flat',
        _ => null,
      };

  /// The symbol of this [Accidental].
  ///
  /// If the [Accidental] represents a natural note (0 semitones), returns the
  /// natural symbol (♮).
  ///
  /// For other accidentals, returns a combination of sharp (♯), flat (♭), or
  /// double sharp/flat symbols (𝄪, 𝄫) depending on the number of semitones
  /// above/below the natural note.
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.symbol == '♭'
  /// Accidental.natural.symbol == '♮'
  /// Accidental.doubleFlat.symbol == '𝄫'
  /// Accidental.tripleSharp.symbol == '♯𝄪'
  /// ```
  String get symbol {
    if (semitones == 0) return _naturalSymbol;

    final accidentalSymbol = semitones.isNegative ? _flatSymbol : _sharpSymbol;
    final doubleAccidentalSymbol =
        semitones.isNegative ? _doubleFlatSymbol : _doubleSharpSymbol;

    final absSemitones = semitones.abs();
    final singleAccidentals = accidentalSymbol * (absSemitones % 2);
    final doubleAccidentals = doubleAccidentalSymbol * (absSemitones ~/ 2);

    return singleAccidentals + doubleAccidentals;
  }

  /// Returns the incremented [Accidental] enum item of this by [n].
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.increment(2) == Accidental.tripleFlat
  /// Accidental.sharp.increment(1) == Accidental.doubleSharp
  /// Accidental.sharp.increment(-1) == Accidental.natural
  /// ```
  Accidental increment(int n) =>
      Accidental((semitones.abs() + n) * (semitones >= 0 ? 1 : -1));

  @override
  String toString() => [
        if (name != null) name,
        symbol,
        '(${semitones.toDeltaString()})',
      ].join(' ');

  @override
  bool operator ==(Object other) =>
      other is Accidental && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Accidental other) => semitones.compareTo(other.semitones);
}
