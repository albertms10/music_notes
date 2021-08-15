part of music_notes;

@immutable
class KeySignature {
  final int number;
  final Accidentals? accidental;

  const KeySignature(this.number, [this.accidental])
      : assert(number >= 0),
        assert(number == 0 || accidental != null);

  KeySignature.fromDistance(int distance)
      : this(
          distance.abs(),
          distance == 0
              ? null
              : distance > 0
                  ? Accidentals.sharp
                  : Accidentals.flat,
        );

  /// Returns [RelativeTonalities] with the two tonalities that are defined
  /// by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(2, Accidentals.flat).tonalities
  ///   == RelativeTonalities({
  ///     const Tonality(Note(Notes.si, Accidentals.flat), Modes.major),
  ///     const Tonality(Note(Notes.sol), Modes.minor),
  ///   })
  /// ```
  RelativeTonalities get tonalities => RelativeTonalities({
        Tonality.fromAccidentals(number, Modes.major, accidental),
        Tonality.fromAccidentals(number, Modes.minor, accidental),
      });

  @override
  String toString() {
    if (number == 0 || accidental == null) return '$number';

    final list = <String>[];
    final notesValues = Notes.values.length;
    final iterations = (number / notesValues).ceil();

    for (var i = 1; i <= iterations; i++) {
      final n = i == iterations
          ? Music.nModValueExcludeZero(number, notesValues)
          : notesValues;

      list.add('$n × ${accidental!.increment(i - 1)!.toText()}');
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
