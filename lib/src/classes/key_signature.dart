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

  /// Returns a [Set] of the two tonalities that are defined by this [KeySignature].
  /// 
  /// ```dart
  /// KeySignature(2, Accidentals.Bemolls).tonalities
  ///   == {
  ///     Tonality(Note(Notes.Si, Accidental.Bemoll), Modes.Major),
  ///     Tonality(Note(Notes.Sol), Modes.Menor),
  ///   }
  /// ```
  Set<Tonality> get tonalities => {
        Tonality.fromAccidentals(number, Modes.Major, accidental),
        Tonality.fromAccidentals(number, Modes.Menor, accidental),
      };

  @override
  String toString() =>
      '$number' + (accidental != null ? ' × ${accidental.toText()}' : '');
}
