import 'package:collection/collection.dart'
    show
        IterableEquality,
        IterableExtension,
        ListEquality,
        UnmodifiableListView,
        UnmodifiableMapView;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../note/accidental.dart';
import '../note/base_note.dart';
import '../note/note.dart';
import 'key.dart';
import 'mode.dart';

/// A key signature.
///
/// ---
/// See also:
/// * [Note].
/// * [Key].
@immutable
final class KeySignature implements Comparable<KeySignature> {
  final List<Note> _notes;

  /// The set of [Note] that define this [KeySignature], which may include
  /// cancellation [Accidental.natural]s.
  List<Note> get notes => UnmodifiableListView(_notes);

  /// Creates a new [KeySignature] from [_notes].
  const KeySignature(this._notes);

  /// An empty [KeySignature].
  static const empty = KeySignature([]);

  static const _firstCanonicalFlatNote = Note(BaseNote.b, Accidental.flat);
  static const _firstCanonicalSharpNote = Note(BaseNote.f, Accidental.sharp);

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

    final firstNote = distance.isNegative
        ? _firstCanonicalFlatNote
        : _firstCanonicalSharpNote;

    return KeySignature(
      Interval.P5
          .descending(distance.isNegative)
          .circleFrom(firstNote)
          .take(distance.abs())
          .toList(growable: false),
    );
  }

  /// The main [Accidental] of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f.sharp, Note.c.sharp]).accidental == Accidental.sharp
  /// KeySignature([Note.b.flat]).accidental == Accidental.flat
  /// KeySignature.empty.accidental == Accidental.natural
  /// ```
  Accidental get accidental =>
      clean._notes.firstOrNull?.accidental ?? Accidental.natural;

  /// This [KeySignature] without cancellation [Accidental.natural]s.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f, Note.b.flat]).clean == KeySignature([Note.b.flat])
  ///
  /// (KeySignature.fromDistance(-2) + KeySignature.fromDistance(3)).clean
  ///   == KeySignature([Note.f, Note.c, Note.g].sharp)
  /// ```
  KeySignature get clean => KeySignature(
    _notes
        .whereNot((note) => note.accidental.isNatural)
        .toList(growable: false),
  );

  /// The fifths distance of this [KeySignature].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.distance == 0
  /// KeySignature([Note.f.sharp, Note.c.sharp]).distance == 2
  /// KeySignature.fromDistance(-4).distance == -4
  /// KeySignature([Note.g.sharp]).distance == null
  /// ```
  int? get distance {
    if (accidental.isNatural) return 0;

    final cleanNotes = clean._notes;
    final apparentDistance = cleanNotes.length * accidental.semitones.sign;
    final apparentFirstNote = accidental.isFlat
        ? _firstCanonicalFlatNote
        : _firstCanonicalSharpNote;
    final circle = Interval.P5
        .descending(apparentDistance.isNegative)
        .circleFrom(apparentFirstNote)
        .take(apparentDistance.abs());

    // As `circle` is an Iterable, lazy evaluation takes place
    // for efficient comparison, returning early on mismatches.
    return const IterableEquality<Note>().equals(cleanNotes, circle)
        ? apparentDistance
        : null;
  }

  /// Whether this [KeySignature] is canonical (has an associated [Key]).
  ///
  /// Cancellation [Accidental.natural]s are ignored.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.f.sharp, Note.c.sharp]).isCanonical == true
  /// KeySignature([Note.e.flat, Note.d.flat]).isCanonical == false
  /// ```
  bool get isCanonical => distance != null;

  /// Returns a [Map] with the keys defined by this [KeySignature], or empty
  /// when [KeySignature.isCanonical] returns `false`.
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(-2).keys == {
  ///   TonalMode.major: Note.b.flat.major,
  ///   TonalMode.minor: Note.g.minor,
  /// }
  ///
  /// KeySignature([Note.g.flat]).keys == {}
  /// ```
  Map<TonalMode, Key> get keys {
    final distance = this.distance;
    if (distance == null) return const {};

    final Note(:major) = Interval.P5
        .descending(distance.isNegative)
        .circleFrom(Note.c)
        .elementAt(distance.abs());

    return UnmodifiableMapView({
      TonalMode.major: major,
      TonalMode.minor: major.relative,
    });
  }

  /// Returns this [KeySignature] incrementing its fifths [distance].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.incrementBy(1) == KeySignature([Note.f.sharp])
  ///
  /// KeySignature([Note.f.sharp, Note.c.sharp]).incrementBy(3)
  ///   == KeySignature.fromDistance(5)
  ///
  /// KeySignature.fromDistance(-3).incrementBy(-1)
  ///   == KeySignature([Note.b.flat, Note.e.flat])
  ///
  /// KeySignature([Note.e.flat]).incrementBy(1) == null
  /// ```
  KeySignature? incrementBy(int distance) {
    final cachedDistance = this.distance;
    if (cachedDistance == null) return null;

    return KeySignature.fromDistance(cachedDistance.incrementBy(distance));
  }

  @override
  String toString() =>
      '$distance ('
      '${_notes.map((note) => note.toString(
        formatter: EnglishNoteNotation.showNatural,
      )).join(' ')}'
      ')';

  /// The consecutive union of two [KeySignature]s (as if divided by a barline),
  /// including cancellation [Accidental.natural]s when needed.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([Note.b.flat]) | KeySignature([Note.f.sharp, Note.c.sharp])
  ///   == KeySignature([Note.b, Note.f.sharp, Note.c.sharp])
  ///
  /// KeySignature([Note.f.sharp, Note.c.sharp]) |
  ///   KeySignature([Note.b.flat, Note.e.flat])
  ///   == KeySignature([Note.f, Note.c, Note.b.flat, Note.e.flat])
  /// ```
  KeySignature operator |(KeySignature other) {
    if (this == empty) return other;

    final cancelledNotes = accidental == other.accidental
        ? clean._notes.whereNot(other._notes.contains)
        : clean._notes;

    return KeySignature([
      ...cancelledNotes.map((note) => note.natural).toSet(),
      ...other._notes,
    ]);
  }

  @override
  bool operator ==(Object other) =>
      other is KeySignature &&
      const ListEquality<Note>().equals(_notes, other._notes);

  @override
  int get hashCode => Object.hash(_notes, accidental);

  @override
  int compareTo(KeySignature other) => compareMultiple([
    () => accidental.compareTo(other.accidental),
    () =>
        _notes.length.compareTo(other._notes.length) *
        accidental.semitones.nonZeroSign,
  ]);
}
