part of '../../music_notes.dart';

/// A tuning system representation.
@immutable
sealed class TuningSystem {
  /// Creates a new [TuningSystem].
  const TuningSystem();
}

/// A representation of an equal temperament tuning system.
@immutable
class EqualTemperament extends TuningSystem {
  /// The equal divisions of the octave between each [BaseNote] and the next
  /// one.
  final Map<BaseNote, int> divisions;

  /// Creates a new [EqualTemperament] from [divisions].
  const EqualTemperament(this.divisions);

  /// See [12 equal temperament](https://en.wikipedia.org/wiki/12_equal_temperament).
  static const edo12 = EqualTemperament({
    BaseNote.c: 2,
    BaseNote.d: 2,
    BaseNote.e: 1,
    BaseNote.f: 2,
    BaseNote.g: 2,
    BaseNote.a: 2,
    BaseNote.b: 1,
  });

  /// See [19 equal temperament](https://en.wikipedia.org/wiki/19_equal_temperament).
  static const edo19 = EqualTemperament({
    BaseNote.c: 3,
    BaseNote.d: 3,
    BaseNote.e: 2,
    BaseNote.f: 3,
    BaseNote.g: 3,
    BaseNote.a: 3,
    BaseNote.b: 2,
  });

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
  /// EqualTemperament.edo12.ratio() == 1.059463
  /// EqualTemperament.edo19.ratio() == 1.037155
  /// ```
  double ratio([int semitones = 1]) =>
      math.pow(2, semitones / octaveDivisions).toDouble();

  /// Returns the number of cents for [ratio] in this [EqualTemperament].
  ///
  /// See [Cent](https://en.wikipedia.org/wiki/Cent_(music)).
  ///
  /// Example:
  /// ```dart
  /// var ratio = EqualTemperament.edo12.ratio;
  /// EqualTemperament.edo12.cents(ratio()) == 100
  /// EqualTemperament.edo12.cents(ratio(7)) == 700
  ///
  /// ratio = EqualTemperament.edo19.ratio;
  /// EqualTemperament.edo19.cents(ratio()) == 63.16
  /// ```
  double cents(double ratio) =>
      math.log(ratio) /
      math.log(2) *
      100 *
      EqualTemperament.edo12.octaveDivisions;

  /// Returns the number of cents for the generator at [Interval.P5] in this
  /// [EqualTemperament].
  ///
  /// Example:
  /// ```dart
  /// EqualTemperament.edo12.generatorCents == 700
  /// EqualTemperament.edo19.generatorCents == 694.737
  /// ```
  ///
  /// ![Temperaments](https://upload.wikimedia.org/wikipedia/commons/4/4c/Rank-2_temperaments_with_the_generator_close_to_a_fifth_and_period_an_octave.jpg)
  double get generatorCents {
    var semitonesUpToP5 = 0;
    for (final divisionEntry in divisions.entries) {
      if (divisionEntry.key == BaseNote.g) break;
      semitonesUpToP5 += divisionEntry.value;
    }

    return cents(ratio(semitonesUpToP5));
  }
}
