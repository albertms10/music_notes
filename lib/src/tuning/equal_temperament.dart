part of '../../music_notes.dart';

/// A representation of an equal temperament tuning system.
@immutable
class EqualTemperament extends TuningSystem {
  /// The equal divisions of the octave between each [BaseNote] and the next
  /// one.
  final Map<BaseNote, int> divisions;

  /// See [12 equal temperament](https://en.wikipedia.org/wiki/12_equal_temperament).
  const EqualTemperament.edo12({
    super.referenceNote = const PositionedNote(Note.a, octave: 4),
  }) : divisions = const {
          BaseNote.c: 2,
          BaseNote.d: 2,
          BaseNote.e: 1,
          BaseNote.f: 2,
          BaseNote.g: 2,
          BaseNote.a: 2,
          BaseNote.b: 1,
        };

  /// See [19 equal temperament](https://en.wikipedia.org/wiki/19_equal_temperament).
  const EqualTemperament.edo19({
    super.referenceNote = const PositionedNote(Note.a, octave: 4),
  }) : divisions = const {
          BaseNote.c: 3,
          BaseNote.d: 3,
          BaseNote.e: 2,
          BaseNote.f: 3,
          BaseNote.g: 3,
          BaseNote.a: 3,
          BaseNote.b: 2,
        };

  /// Returns the equal divisions of the octave of this [EqualTemperament].
  ///
  /// See [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament).
  int get octaveDivisions =>
      divisions.values.reduce((value, element) => value + element);

  /// Returns the [semitones] ratio for this [EqualTemperament].
  ///
  /// See [Twelfth root of two](https://en.wikipedia.org/wiki/Twelfth_root_of_two).
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().ratio() == 1.059463
  /// const EqualTemperament.edo19().ratio() == 1.037155
  /// ```
  Ratio ratio([int semitones = 1]) =>
      Ratio(math.pow(2, semitones / octaveDivisions));

  @override
  Ratio ratioFromNote(PositionedNote note) =>
      ratio(referenceNote.difference(note));



  @override
  Cent get generatorCents {
    var semitonesUpToP5 = 0;
    for (final divisionEntry in divisions.entries) {
      if (divisionEntry.key == BaseNote.g) break;
      semitonesUpToP5 += divisionEntry.value;
    }

    return ratio(semitonesUpToP5).cents;
  }
}
