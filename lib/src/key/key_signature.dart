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

  static const _firstCanonicalFlatNote = Note(.b, .flat);
  static const _firstCanonicalSharpNote = Note(.f, .sharp);

  /// Creates a new [KeySignature] from fifths [distance].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.fromDistance(0) == .empty
  /// KeySignature.fromDistance(-1) == KeySignature([.b.flat])
  /// KeySignature.fromDistance(2) == KeySignature([.f.sharp, .c.sharp])
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
  /// KeySignature([.f.sharp, .c.sharp]).accidental == .sharp
  /// KeySignature([.b.flat]).accidental == .flat
  /// KeySignature.empty.accidental == .natural
  /// ```
  Accidental get accidental => clean._notes.firstOrNull?.accidental ?? .natural;

  /// This [KeySignature] without cancellation [Accidental.natural]s.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([.f, .b.flat]).clean == KeySignature([.b.flat])
  ///
  /// (KeySignature.fromDistance(-2) + KeySignature.fromDistance(3)).clean
  ///   == KeySignature([.f, .c, .g].sharp)
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
  /// KeySignature([.f.sharp, .c.sharp]).distance == 2
  /// KeySignature.fromDistance(-4).distance == -4
  /// KeySignature([.g.sharp]).distance == null
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
  /// KeySignature([.f.sharp, .c.sharp]).isCanonical == true
  /// KeySignature([.e.flat, .d.flat]).isCanonical == false
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
  /// KeySignature([.g.flat]).keys == {}
  /// ```
  Map<TonalMode, Key> get keys {
    final distance = this.distance;
    if (distance == null) return const {};

    final Note(:major) = Interval.P5
        .descending(distance.isNegative)
        .circleFrom(Note.c)
        .elementAt(distance.abs());

    return UnmodifiableMapView({.major: major, .minor: major.relative});
  }

  /// Returns this [KeySignature] incrementing its fifths [distance].
  ///
  /// Example:
  /// ```dart
  /// KeySignature.empty.incrementBy(1) == KeySignature([.f.sharp])
  ///
  /// KeySignature([.f.sharp, .c.sharp]).incrementBy(3)
  ///   == KeySignature.fromDistance(5)
  ///
  /// KeySignature.fromDistance(-3).incrementBy(-1)
  ///   == KeySignature([.b.flat, .e.flat])
  ///
  /// KeySignature([.e.flat]).incrementBy(1) == null
  /// ```
  KeySignature? incrementBy(int distance) {
    final cachedDistance = this.distance;
    if (cachedDistance == null) return null;

    return .fromDistance(cachedDistance.incrementBy(distance));
  }

  @override
  String toString() =>
      '${isCanonical ? '${keys.values.toSet()} '
                '${distance?.toDeltaString()} fifths' : 'Non-canonical'} '
      '(${_notes.isEmpty ? 'empty' : _notes.map(
              EnglishNoteNotation.showNatural.format,
            ).join(' ')})';

  /// The consecutive union of two [KeySignature]s (as if divided by a barline),
  /// including cancellation [Accidental.natural]s when needed.
  ///
  /// Example:
  /// ```dart
  /// KeySignature([.b.flat]) | KeySignature([.f.sharp, .c.sharp])
  ///   == KeySignature([.b, .f.sharp, .c.sharp])
  ///
  /// KeySignature([.f.sharp, .c.sharp]) | KeySignature([.b.flat, .e.flat])
  ///   == KeySignature([.f, .c, .b.flat, .e.flat])
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
