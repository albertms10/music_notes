part of '../../music_notes.dart';

/// A representation of an equal temperament tuning system.
///
/// See [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
class EqualTemperament extends TuningSystem {
  /// The equal divisions between each [BaseNote] and the next one.
  final List<int> steps;

  /// Creates a new [EqualTemperament] from [referencePitch] and [steps].
  const EqualTemperament({
    required this.steps,
    super.referencePitch = _defaultReferencePitch,
  });

  /// See [12 equal temperament](https://en.wikipedia.org/wiki/12_equal_temperament).
  const EqualTemperament.edo12({super.referencePitch = _defaultReferencePitch})
      : steps = const [2, 2, 1, 2, 2, 2, 1];

  /// See [19 equal temperament](https://en.wikipedia.org/wiki/19_equal_temperament).
  const EqualTemperament.edo19({super.referencePitch = _defaultReferencePitch})
      : steps = const [3, 3, 2, 3, 3, 3, 2];

  static const _defaultReferencePitch = Pitch(Note.a, octave: 4);

  /// Returns the equal divisions of the octave of this [EqualTemperament].
  ///
  /// See [EDO](https://en.xen.wiki/w/EDO).
  int get edo => steps.reduce((value, element) => value + element);

  /// The cents for each division step in this [EqualTemperament].
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().cents
  ///   == const [Cent(0), Cent(100), Cent(200) Cent(300),
  ///   Cent(400), Cent(500), Cent(600), Cent(700),
  ///   Cent(800), Cent(900), Cent(1000), Cent(1100)]
  /// ```
  Iterable<Cent> get cents sync* {
    yield const Cent(0);
    final edo = this.edo;
    for (var i = 1; i < edo; i++) {
      yield ratioFromSemitones(i).cents;
    }
  }

  /// Returns the [Ratio] from [semitones] for this [EqualTemperament].
  ///
  /// See [Twelfth root of two](https://en.wikipedia.org/wiki/Twelfth_root_of_two).
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().ratioFromSemitones() == Ratio(1.059463)
  /// const EqualTemperament.edo19().ratioFromSemitones() == Ratio(1.037155)
  /// ```
  Ratio ratioFromSemitones([int semitones = 1]) =>
      Ratio(math.pow(2, semitones / edo));

  @override
  Ratio ratio(Pitch note) =>
      ratioFromSemitones(referencePitch.difference(note));

  @override
  Cent get generator => Cent(cents.closestTo(const Cent(700)));

  @override
  String toString() => 'EDO $edo (${steps.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is EqualTemperament &&
      const ListEquality<int>().equals(steps, other.steps) &&
      referencePitch == other.referencePitch;

  @override
  int get hashCode => Object.hash(Object.hashAll(steps), referencePitch);
}
