part of '../../music_notes.dart';

@immutable
final class KeySignature implements Comparable<KeySignature> {
  final List<Note> notes;

  /// Creates a new [KeySignature] from [notes].
  const KeySignature(this.notes);

  /// Creates a new [KeySignature] from fifths [distance].
  factory KeySignature.fromDistance(int distance) {
    if (distance == 0) return const KeySignature([]);

    final interval = distance.isNegative ? Interval.P4 : Interval.P5;
    final startingNote = distance.isNegative ? Note.b.flat : Note.f.sharp;

    return KeySignature(
      List.filled(distance.abs() - 1, null).fold(
        [startingNote],
        (notes, _) => [...notes, notes.last.transposeBy(interval)],
      ),
    );
  }

  /// Returns the main Accidental of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// const KeySignature([Note.f.sharp, Note.c.sharp]).accidental
  ///   == Accidental.sharp
  /// const KeySignature([Note.b.flat]).accidental == Accidental.flat
  /// ```
  Accidental get accidental =>
      notes.firstOrNull?.accidental ?? Accidental.natural;

  /// Returns the fifths distance of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0).distance == 0
  /// KeySignature.fromDistance(3).distance == 3
  /// KeySignature.fromDistance(-4).distance == -4
  /// ```
  int get distance => notes.length * (accidental == Accidental.flat ? -1 : 1);

  /// Returns the [Note] that corresponds to the major [Tonality] of this
  /// [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0).majorNote == Note.c
  /// KeySignature.fromDistance(2).majorNote == Note.d
  /// ```
  Note get majorNote {
    final fifthInterval =
        Interval.P5.descending(isDescending: accidental == Accidental.flat);

    return EnharmonicNote(
      (fifthInterval.semitones * notes.length + 1).chromaticModExcludeZero,
    ).resolveClosestSpelling(accidental.increment(notes.length ~/ 9));
  }

  /// Returns the [Tonality] that corresponds to this [KeySignature] from
  /// [mode].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0).tonality(TonalMode.major) == Note.c.major
  /// KeySignature.fromDistance(-2).tonality(TonalMode.minor) == Note.g.minor
  /// ```
  Tonality tonality(TonalMode mode) => Tonality.fromDistance(distance, mode);

  /// Returns a [Set] with the two tonalities that are defined
  /// by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(-2).tonalities == {
  ///   Note.b.flat.major,
  ///   Note.g.minor,
  /// }
  /// ```
  Set<Tonality> get tonalities =>
      {tonality(TonalMode.major), tonality(TonalMode.minor)};

  @override
  String toString() {
    if (notes.isEmpty) {
      return '${notes.length} ${accidental.symbol}';
    }

    final list = <String>[];
    final notesLength = BaseNote.values.length;
    final iterations = (notes.length / notesLength).ceil();

    for (var i = 1; i <= iterations; i++) {
      final n = i == iterations
          ? notes.length.nModExcludeZero(notesLength)
          : notesLength;

      list.add('$n ${accidental.increment(i - 1).symbol}');
    }

    return list.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      other is KeySignature &&
      const ListEquality<Note>().equals(notes, other.notes);

  @override
  int get hashCode => Object.hash(notes, accidental);

  @override
  int compareTo(KeySignature other) => compareMultiple([
        () => accidental.compareTo(other.accidental),
        () =>
            notes.length.compareTo(other.notes.length) *
            (accidental.semitones.isNegative ? -1 : 1),
      ]);
}
