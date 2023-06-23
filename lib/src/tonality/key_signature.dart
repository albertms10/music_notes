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

    final firstAccidentalNote =
        distance.isNegative ? Note.b.flat : Note.f.sharp;

    return KeySignature(
      Interval.P5
          .circleFrom(firstAccidentalNote, distance: distance.incrementBy(-1)),
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
    final rootNote = Interval.P5.circleFrom(Note.c, distance: distance).last;

    return (
      major: rootNote.major,
      minor: rootNote.transposeBy(-Interval.m3).minor
    );
  }

  @override
  String toString() => '$distance (${notes.join(' ')})';

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
