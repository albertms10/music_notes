part of music_notes;

class KeySignature {
  final int number;
  final Accidentals accidental;

  const KeySignature(this.number, [this.accidental])
      : assert(number != null),
        assert(number > 0 ? accidental != null : true);

  KeySignature.fromDistance(int distance)
      : this(
          distance.abs(),
          distance == 0
              ? null
              : distance > 0 ? Accidentals.Sostingut : Accidentals.Bemoll,
        );

  /// Returns [RelativeTonalities] with the two tonalities that are defined by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(2, Accidentals.Bemoll).tonalities
  ///   == RelativeTonalities({
  ///     const Tonality(const Note(Notes.Si, Accidentals.Bemoll), Modes.Major),
  ///     const Tonality(const Note(Notes.Sol), Modes.Menor),
  ///   })
  /// ```
  RelativeTonalities get tonalities => RelativeTonalities({
        Tonality.fromAccidentals(number, Modes.Major, accidental),
        Tonality.fromAccidentals(number, Modes.Menor, accidental),
      });

  @override
  String toString() =>
      '$number' + (accidental != null ? ' × ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is KeySignature &&
      this.number == other.number &&
      this.accidental == other.accidental;
}
