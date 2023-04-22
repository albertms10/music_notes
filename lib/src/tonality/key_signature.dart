part of '../../music_notes.dart';

@immutable
class KeySignature implements Comparable<KeySignature> {
  final int accidentals;
  final Accidental accidental;

  const KeySignature(this.accidentals, [this.accidental = Accidental.natural])
      : assert(accidentals >= 0, 'Provide a positive number or zero'),
        assert(
          accidentals == 0 || !identical(accidental, Accidental.natural),
          'Provide an accidental when accidentals is greater than 0',
        );

  KeySignature.fromDistance(int distance)
      : this(
          distance.abs(),
          distance == 0
              ? Accidental.natural
              : distance > 0
                  ? Accidental.sharp
                  : Accidental.flat,
        );

  /// Returns a [Set] with the two tonalities that are defined
  /// by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(2, Accidental.flat).tonalities == {
  ///   Tonality.bFlatMajor,
  ///   Tonality.gMinor,
  /// }
  /// ```
  Set<Tonality> get tonalities => {
        Tonality.fromAccidentals(accidentals, Modes.major, accidental),
        // TODO(albertms10): use `Tonality.relative`
        Tonality.fromAccidentals(accidentals, Modes.minor, accidental),
      };

  @override
  String toString() {
    if (accidentals == 0) return '$accidentals ${accidental.symbol}';

    final list = <String>[];
    final notesLength = Notes.values.length;
    final iterations = (accidentals / notesLength).ceil();

    for (var i = 1; i <= iterations; i++) {
      final n = i == iterations
          ? accidentals.nModExcludeZero(notesLength)
          : notesLength;

      list.add('$n ${accidental.increment(i - 1).symbol}');
    }

    return list.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      other is KeySignature &&
      accidentals == other.accidentals &&
      accidental == other.accidental;

  @override
  int get hashCode => hash2(accidentals, accidental);

  @override
  int compareTo(covariant KeySignature other) => compareMultiple([
        () => accidental.compareTo(other.accidental),
        () =>
            accidentals.compareTo(other.accidentals) *
            (accidental.semitones > 0 ? 1 : -1),
      ]);
}
