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

  static const _firstFlatNote = Note(BaseNote.b, Accidental.flat);
  static const _firstSharpNote = Note(BaseNote.f, Accidental.sharp);

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

    final firstNote = distance.isNegative ? _firstFlatNote : _firstSharpNote;

    return KeySignature(
      Interval.P5
          .circleFrom(firstNote, distance: distance.incrementBy(-1))
          .toList(),
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
  int? get distance {
    if (accidental.isNatural) return 0;

    final cleanNotes = clean.notes;
    final apparentDistance = cleanNotes.length * accidental.semitones.sign;
    final apparentFirstNote =
        accidental.isFlat ? _firstFlatNote : _firstSharpNote;
    final circle = Interval.P5.circleFrom(
      apparentFirstNote,
      distance: apparentDistance.incrementBy(-1),
    );

    // As `circle` is an Iterable, lazy evaluation takes place
    // for efficient comparison, returning early on mismatches.
    return const IterableEquality<Note>().equals(cleanNotes, circle)
        ? apparentDistance
        : null;
  }

  /// Whether this [KeySignature] is canonical (has an associated [Tonality]).
  ///
  /// Cancellation [Accidental.natural]s are ignored.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f.sharp, Note.c.sharp]).isCanonical == true
  /// KeySignature([Note.e.flat, Note.d.flat]).isCanonical == false
  /// ```
  bool get isCanonical => distance != null;

  /// Returns the [Tonality] that corresponds to this [KeySignature] from
  /// [mode].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.tonality(TonalMode.major) == Note.c.major
  /// KeySignature.fromDistance(-2).tonality(TonalMode.minor) == Note.g.minor
  /// ```
  Tonality? tonality(TonalMode mode) => switch (mode) {
        TonalMode.major => tonalities?.major,
        TonalMode.minor => tonalities?.minor,
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
  ({Tonality major, Tonality minor})? get tonalities {
    final distance = this.distance;
    if (distance == null) return null;

    final rootNote = Interval.P5.circleFrom(Note.c, distance: distance).last;
    final major = rootNote.major;

    return (major: major, minor: major.relative);
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

    final cancelledNotes = accidental == other.accidental
        ? clean.notes.whereNot(other.notes.contains)
        : clean.notes;

    return KeySignature([
      ...cancelledNotes.map((note) => note.natural).toSet(),
      ...other.notes,
    ]);
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
