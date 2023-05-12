part of '../../music_notes.dart';

@immutable
final class KeySignature implements Comparable<KeySignature> {
  final int accidentals;
  final Accidental accidental;

  const KeySignature(this.accidentals, [this.accidental = Accidental.natural])
      : assert(accidentals >= 0, 'Provide a positive number or zero'),
        assert(
          identical(accidental, Accidental.flat) ||
              identical(accidental, Accidental.natural) ||
              identical(accidental, Accidental.sharp),
          'Provide a valid accidental for a key signature',
        ),
        assert(
          (accidentals == 0) ^ !identical(accidental, Accidental.natural),
          'Provide an accidental when accidentals is greater than 0',
        );

  KeySignature.fromDistance(int distance)
      : this(
          distance.abs(),
          distance == 0
              ? Accidental.natural
              : distance.isNegative
                  ? Accidental.flat
                  : Accidental.sharp,
        );

  /// Returns the fifths distance of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(0).distance == 0
  /// const KeySignature(3, Accidental.sharp).distance == 3
  /// const KeySignature(4, Accidental.flat).distance == -4
  /// ```
  int get distance => accidentals * (accidental == Accidental.flat ? -1 : 1);

  /// Returns the [Note] that corresponds to the major [Tonality] of this
  /// [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(0).majorNote == Note.c
  /// const KeySignature(2, Accidental.sharp).majorNote == Note.d
  /// ```
  Note get majorNote {
    final fifthInterval = Interval.perfectFifth
        .descending(isDescending: accidental == Accidental.flat);

    return EnharmonicNote(
      (fifthInterval.semitones * accidentals + 1).chromaticModExcludeZero,
    ).resolveClosestSpelling(accidental.increment(accidentals ~/ 9));
  }

  /// Returns the [Tonality] that corresponds to this [KeySignature] from
  /// [mode].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature(0).tonality(TonalMode.major) == Tonality.cMajor
  /// const KeySignature(2, Accidental.flat).tonality(TonalMode.minor)
  ///   == Tonality.gMinor
  /// ```
  Tonality tonality(TonalMode mode) =>
      Tonality.fromAccidentals(accidentals, mode, accidental);

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
  Set<Tonality> get tonalities =>
      {tonality(TonalMode.major), tonality(TonalMode.minor)};

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
  int get hashCode => Object.hash(accidentals, accidental);

  @override
  int compareTo(covariant KeySignature other) => compareMultiple([
        () => accidental.compareTo(other.accidental),
        () =>
            accidentals.compareTo(other.accidentals) *
            (accidental.semitones > 0 ? 1 : -1),
      ]);
}
