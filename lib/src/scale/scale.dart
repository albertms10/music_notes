part of '../../music_notes.dart';

class Scale {
  /// The interval steps that define the scale.
  final List<Interval> intervalSteps;

  /// Creates a new [Scale] from [intervalSteps].
  const Scale(this.intervalSteps);

  static const ionian = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);
  static const dorian = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);
  static const phrygian = Scale([
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);
  static const lydian = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);
  static const mixolydian = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);
  static const aeolian = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);
  static const locrian = Scale([
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  static const major = ionian;
  static const naturalMinor = aeolian;
  static const harmonicMinor = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.augmentedSecond,
    Interval.minorSecond,
  ]);
  static const melodicMinor = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
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
    Interval.minorSecond,
  ]);
  static const tones = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.diminishedThird,
  ]);

  static const pentatonic = Scale([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorThird,
    Interval.majorSecond,
    Interval.minorThird,
  ]);
  static const octatonic = Scale([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);

  /// Returns the scale of notes starting from [note].
  ///
  /// Example:
  /// ```dart
  /// Scale.major.fromNote(Note.c)
  ///   == const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c]
  ///
  /// Scale.naturalMinor.fromNote(Note.a)
  ///   == const [Note.a, Note.b, Note.c, Note.d, Note.e, Note.f, Note.g,
  ///        Note.a]
  ///
  /// Scale.melodicMinor.fromNote(Note.c)
  ///   == const [Note.c, Note.d, Note.eFlat, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c]
  /// ```
  List<Note> fromNote(Note note) => intervalSteps.fold(
        [note],
        (scaleNotes, interval) =>
            [...scaleNotes, scaleNotes.last.transposeBy(interval)],
      );

  /// Returns the mirrored scale version of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Scale.ionian.mirrored == Scale.phrygian
  /// Scale.dorian.mirrored == Scale.dorian
  /// Scale.locrian.mirrored == Scale.lydian
  /// ```
  Scale get mirrored => Scale(intervalSteps.reversed.toList());

  /// Returns the name associated with this [Scale].
  ///
  /// ```dart
  /// Scale.mixolydian.name == 'Mixolydian'
  /// Scale.chromatic.name == 'Chromatic'
  /// Scale.melodicMinor.name == 'Melodic minor'
  /// ```
  String? get name {
    if (this == Scale.ionian) return 'Major (ionian)';
    if (this == Scale.dorian) return 'Dorian';
    if (this == Scale.phrygian) return 'Phrygian';
    if (this == Scale.lydian) return 'Lydian';
    if (this == Scale.mixolydian) return 'Mixolydian';
    if (this == Scale.aeolian) return 'Natural minor (aeolian)';
    if (this == Scale.locrian) return 'Locrian';
    if (this == Scale.harmonicMinor) return 'Harmonic minor';
    if (this == Scale.melodicMinor) return 'Melodic minor';
    if (this == Scale.chromatic) return 'Chromatic';
    if (this == Scale.tones) return 'Tones';
    if (this == Scale.pentatonic) return 'Pentatonic';
    if (this == Scale.octatonic) return 'Octatonic';

    return null;
  }

  @override
  String toString() => '$name (${intervalSteps.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is Scale &&
      const ListEquality<Interval>().equals(intervalSteps, other.intervalSteps);

  @override
  int get hashCode => Object.hashAll(intervalSteps);
}
