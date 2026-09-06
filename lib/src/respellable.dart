import 'accidental/accidental.dart';
import 'note_name/note_name.dart';
import 'scalable.dart';

/// A mixin for values that can be renamed without altering their pitch,
/// i.e. rewritten under a different spelling while keeping the same number
/// of semitones (e.g., calling G♯ "A♭" instead).
///
/// See [Enharmonic respelling](https://en.wikipedia.org/wiki/Enharmonic#Enharmonic_equivalents).
/// Where [Enharmonic] only checks whether two spellings coincide,
/// [Respellable] performs the rewrite itself.
mixin Respellable<T> {
  /// This [T] respelled with the next letter name above, keeping the same
  /// number of semitones (e.g. a G♯ becomes an A♭♭).
  T get respelledUpwards;

  /// This [T] respelled with the next letter name below, keeping the same
  /// number of semitones (e.g. a C becomes a B♯).
  T get respelledDownwards;

  /// This [T] rewritten with the fewest accidentals possible, keeping the
  /// same number of semitones (e.g. an E♯ becomes an F).
  T get respelledSimple;
}

/// [Respellable] refined for a [Scalable], where a respelling can target a
/// specific [NoteName], a letter-name distance, or a specific [Accidental]
/// rather than only the three fixed directions [Respellable] exposes.
mixin RespellableScalable<T extends Scalable<T>> on Respellable<T> {
  /// This [T] rewritten under [noteName], keeping the same number of
  /// semitones.
  ///
  /// Throws if no [Accidental] can express this [T] using [noteName]'s
  /// letter (implementers may instead return the closest possible
  /// spelling; see each override's documentation).
  T respellByNoteName(NoteName noteName);

  /// This [T] respelled [distance] letter names away (positive moves
  /// upward through the musical alphabet, negative downward), keeping the
  /// same number of semitones.
  T respellByOrdinalDistance(int distance);

  /// This [T] rewritten with [accidental], keeping the same number of
  /// semitones (e.g. respelling by [Accidental.sharp] turns a B♭ into an
  /// A♯).
  T respellByAccidental(Accidental accidental);

  /// This [T] respelled with the next letter name above, keeping the same
  /// number of semitones.
  @override
  T get respelledUpwards => respellByOrdinalDistance(1);

  /// This [T] respelled with the next letter name below, keeping the same
  /// number of semitones.
  @override
  T get respelledDownwards => respellByOrdinalDistance(-1);

  /// This [T] rewritten with as plain an [Accidental] as its semitones
  /// allow (natural where possible, otherwise a single sharp or flat).
  @override
  T get respelledSimple => respellByAccidental(.natural);
}
