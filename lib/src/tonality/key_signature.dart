part of '../../music_notes.dart';

@immutable
final class KeySignature implements Comparable<KeySignature> {
  final List<Note> notes;

  /// Creates a new [KeySignature] from [notes].
  const KeySignature(this.notes);

  static const empty = KeySignature([]);

  /// Creates a new [KeySignature] from fifths [distance].
  factory KeySignature.fromDistance(int distance) {
    if (distance == 0) return empty;

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

  /// Returns the [Tonality] that corresponds to this [KeySignature] from
  /// [mode].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0).tonality(TonalMode.major) == Note.c.major
  /// KeySignature.fromDistance(-2).tonality(TonalMode.minor) == Note.g.minor
  /// ```
  Tonality tonality(TonalMode mode) {
    final cachedTonalities = tonalities;

    return switch (mode) {
      TonalMode.major => cachedTonalities.major,
      TonalMode.minor => cachedTonalities.minor,
    };
  }

  /// Returns a [Set] with the two tonalities that are defined
  /// by this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(-2).tonalities == (
  ///   major: Note.b.flat.major,
  ///   minor: Note.g.minor,
  /// )
  /// ```
  ({Tonality major, Tonality minor}) get tonalities {
    final interval = distance.isNegative ? Interval.P4 : Interval.P5;
    final rootNote = List.filled(distance.abs(), null)
        .fold(Note.c, (note, _) => note.transposeBy(interval));

    return (
      major: rootNote.major,
      minor: rootNote.transposeBy(-Interval.m3).minor
    );
  }

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
