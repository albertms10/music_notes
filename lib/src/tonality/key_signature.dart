part of '../../music_notes.dart';

/// A key signature.
///
/// ---
/// See also:
/// * [Note].
/// * [Tonality].
@immutable
final class KeySignature implements Comparable<KeySignature> {
  /// The set of [Note] accidentals that define this [KeySignature].
  final List<Note> notes;

  /// Creates a new [KeySignature] from [notes].
  const KeySignature(this.notes);

  /// An empty [KeySignature].
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

  /// Returns the main [Accidental] of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f.sharp, Note.c.sharp]).accidental == Accidental.sharp
  /// KeySignature([Note.b.flat]).accidental == Accidental.flat
  /// KeySignature.empty.accidental == Accidental.natural
  /// ```
  Accidental get accidental =>
      notes.firstOrNull?.accidental ?? Accidental.natural;

  /// Returns the fifths distance of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.distance == 0
  /// KeySignature([Note.f.sharp, Note.c.sharp]).distance == 2
  /// KeySignature.fromDistance(-4).distance == -4
  /// ```
  int get distance => notes.length * accidental.semitones.nonZeroSign;

  /// Returns the [Tonality] that corresponds to this [KeySignature] from
  /// [mode].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.tonality(TonalMode.major) == Note.c.major
  /// KeySignature.fromDistance(-2).tonality(TonalMode.minor) == Note.g.minor
  /// ```
  Tonality tonality(TonalMode mode) => switch (mode) {
        TonalMode.major => tonalities.major,
        TonalMode.minor => tonalities.minor,
      };

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
            accidental.semitones.nonZeroSign,
      ]);
}
