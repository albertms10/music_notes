part of '../../music_notes.dart';

/// A key signature.
///
/// ---
/// See also:
/// * [Note].
/// * [Tonality].
@immutable
final class KeySignature implements Comparable<KeySignature> {
  /// The set of [Note] that define this [KeySignature], which may include
  /// cancellation [Accidental.natural]s.
  final List<Note> notes;

  /// Creates a new [KeySignature] from [notes].
  const KeySignature(this.notes);

  /// An empty [KeySignature].
  static const empty = KeySignature([]);

  /// Creates a new [KeySignature] from fifths [distance].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0) == KeySignature.empty
  /// KeySignature.fromDistance(-1) == KeySignature([Note.b.flat])
  /// KeySignature.fromDistance(2) == KeySignature([Note.f.sharp, Note.c.sharp])
  /// ```
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
      clean.notes.firstOrNull?.accidental ?? Accidental.natural;

  /// Returns a new [KeySignature] without cancellation [Accidental.natural]s.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f, Note.b.flat]).clean == KeySignature([Note.b.flat])
  ///
  /// (KeySignature.fromDistance(-2) + KeySignature.fromDistance(3)).clean
  ///   == KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp])
  /// ```
  KeySignature get clean =>
      KeySignature(notes.where((note) => !note.accidental.isNatural).toList());

  /// Returns the fifths distance of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.distance == 0
  /// KeySignature([Note.f.sharp, Note.c.sharp]).distance == 2
  /// KeySignature.fromDistance(-4).distance == -4
  /// ```
  int get distance => clean.notes.length * accidental.semitones.nonZeroSign;

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
      minor: rootNote.transposeBy(-Interval.m3).minor,
    );
  }

  static const _noteNotation = EnglishNoteNotation(showNatural: true);

  @override
  String toString() => '$distance (${notes.map(
        (note) => note.toString(system: _noteNotation),
      ).join(' ')})';

  /// Adds two [KeySignature]s, including cancellation [Accidental.natural]s
  /// if needed.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.b.flat]) + KeySignature([Note.f.sharp, Note.c.sharp])
  ///   == KeySignature([Note.b, Note.f.sharp, Note.c.sharp])
  ///
  /// KeySignature([Note.f.sharp, Note.c.sharp])
  ///   + KeySignature([Note.b.flat, Note.e.flat])
  ///   == KeySignature([Note.f, Note.c, Note.b.flat, Note.e.flat])
  /// ```
  KeySignature operator +(KeySignature other) {
    if (this == empty) return other;
    if (accidental == other.accidental) {
      return KeySignature({...notes, ...other.notes}.toList());
    }

    return KeySignature([...notes.map((note) => note.natural), ...other.notes]);
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
            accidental.semitones.nonZeroSign,
      ]);
}
