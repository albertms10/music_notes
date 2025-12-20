import 'note/accidental.dart';
import 'note/note_name.dart';
import 'scalable.dart';

/// A mixin for anything that can be respelled.
mixin Respellable<T> {
  /// This [T] respelled upwards while keeping the same number of semitones.
  T get respelledUpwards;

  /// This [T] respelled downwards while keeping the same number of semitones.
  T get respelledDownwards;

  /// This [T] with the simplest spelling while keeping the same number of
  /// semitones.
  T get respelledSimple;
}

/// A mixin for a [Scalable] that can be respelled.
mixin RespellableScalable<T extends Scalable<T>> on Respellable<T> {
  /// This [T] respelled by [noteName] while keeping the same number of
  /// semitones.
  T respellByNoteName(NoteName noteName);

  /// This [T] respelled by [NoteName.ordinal] distance while keeping
  /// the same number of semitones.
  T respellByOrdinalDistance(int distance);

  /// This [T] respelled by [accidental] while keeping the same number of
  /// semitones.
  T respellByAccidental(Accidental accidental);

  /// This [T] respelled upwards while keeping the same number of semitones.
  @override
  T get respelledUpwards => respellByOrdinalDistance(1);

  /// This [T] respelled downwards while keeping the same number of semitones.
  @override
  T get respelledDownwards => respellByOrdinalDistance(-1);

  /// This [T] with the simplest [Accidental] spelling while keeping
  /// the same number of semitones.
  @override
  T get respelledSimple => respellByAccidental(.natural);
}
