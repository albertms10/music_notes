part of music_notes;

class KeySignature {
  final int number;
  final Accidentals accidental;

  const KeySignature(this.number, this.accidental)
      : assert(number != null),
        assert(accidental != null);


  @override
  String toString() => '$number × ${accidental.toText()}';
}
