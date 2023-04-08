part of '../../music_notes.dart';

@immutable
class KeySignature {
  final int number;
  final Accidental accidental;

  const KeySignature(this.number, [this.accidental = Accidental.natural])
      : assert(number >= 0, 'Provide a positive number or zero');

  KeySignature.fromDistance(int distance)
      : this(
          distance.abs(),
          distance == 0
              ? Accidental.natural
              : distance > 0
                  ? Accidental.sharp
                  : Accidental.flat,
        );

  /// Returns [RelativeTonalities] with the two tonalities that are defined
  /// by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(2, Accidental.flat).tonalities
  ///   == RelativeTonalities({
  ///     const Tonality(Note.bFlat, Modes.major),
  ///     const Tonality(Note.g, Modes.minor),
  ///   })
  /// ```
  RelativeTonalities get tonalities => RelativeTonalities({
        Tonality.fromAccidentals(number, Modes.major, accidental),
        Tonality.fromAccidentals(number, Modes.minor, accidental),
      });

  @override
  String toString() {
    if (number == 0) return '$number';

    final list = <String>[];
    final notesValues = Notes.values.length;
    final iterations = (number / notesValues).ceil();

    for (var i = 1; i <= iterations; i++) {
      final n =
          i == iterations ? nModExcludeZero(number, notesValues) : notesValues;

      list.add('$n × ${Accidental(accidental.semitones + i - 1).symbol}');
    }

    return list.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      other is KeySignature &&
      number == other.number &&
      accidental == other.accidental;

  @override
  int get hashCode => hash2(number, accidental);
}
