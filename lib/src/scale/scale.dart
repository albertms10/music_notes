part of '../../music_notes.dart';

class Scale {
  /// The interval steps that define the scale.
  final List<Interval> intervalSteps;

  /// Creates a new [Scale] from [intervalSteps].
  const Scale(this.intervalSteps);

  static const major = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);
  static const naturalMinor = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);
  static const harmonicMinor = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.augmentedSecond,
  ]);
  static const melodicMinor = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  static const chromatic = Scale([
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
  ]);
  static const tones = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  static const pentatonic = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorThird,
    Interval.majorSecond,
  ]);
  static const octatonic = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);

  /// Returns the scale of notes starting from [note].
  ///
  /// Example:
  /// ```dart
  /// Scale.major.fromNote(Note.c)
  ///   == const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b]
  ///
  /// Scale.naturalMinor.fromNote(Note.a)
  ///   == const [Note.a, Note.b, Note.c, Note.d, Note.e, Note.f, Note.g]
  ///
  /// Scale.melodicMinor.fromNote(Note.c)
  ///   == const [Note.c, Note.d, Note.eFlat, Note.f, Note.g, Note.a, Note.b]
  /// ```
  List<Note> fromNote(Note note) =>
      intervalSteps.fold([note], (scaleNotes, interval) {
        final lastNote = scaleNotes.lastOrNull ?? note;

        return [...scaleNotes, lastNote.transposeBy(interval)];
      });
}
