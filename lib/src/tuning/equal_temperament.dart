import 'dart:math' as math;

import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../note/note_name.dart';
import '../note/pitch.dart';
import 'cent.dart';
import 'tuning_system.dart';

/// Number of chromatic octave divisions in [EqualTemperament.edo12].
const int chromaticDivisions = 12;

/// A representation of an equal temperament tuning formatter.
///
/// See [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
class EqualTemperament extends TuningSystem {
  final List<int> _steps;

  /// The equal divisions between each [NoteName] and the next one.
  List<int> get steps => UnmodifiableListView(_steps);

  /// Creates a new [EqualTemperament] from [_steps] and [fork].
  const EqualTemperament(this._steps, {super.fork = .a440});

  /// See [12 equal temperament](https://en.wikipedia.org/wiki/12_equal_temperament).
  const EqualTemperament.edo12({super.fork = .a440})
    : _steps = const [2, 2, 1, 2, 2, 2, 1];

  /// See [19 equal temperament](https://en.wikipedia.org/wiki/19_equal_temperament).
  const EqualTemperament.edo19({super.fork = .a440})
    : _steps = const [3, 3, 2, 3, 3, 3, 2];

  /// The equal divisions of the octave of this [EqualTemperament].
  ///
  /// See [EDO](https://en.xen.wiki/w/EDO).
  int get edo => _steps.reduce((value, element) => value + element);

  /// The cents for each division step in this [EqualTemperament].
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().cents.toList()
  ///   == const [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100]
  ///       as List<Cent>
  /// ```
  Iterable<Cent> get cents sync* {
    yield const Cent(0);
    final edo = this.edo;
    for (var i = 1; i < edo; i++) {
      yield Cent.fromRatio(ratioFromSemitones(i));
    }
  }

  /// The ratio from [semitones] for this [EqualTemperament].
  ///
  /// See [Twelfth root of two](https://en.wikipedia.org/wiki/Twelfth_root_of_two).
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().ratioFromSemitones(1) == 1.059463
  /// const EqualTemperament.edo19().ratioFromSemitones(1) == 1.037155
  /// ```
  num ratioFromSemitones(int semitones) => math.pow(2, semitones / edo);

  @override
  num ratio(Pitch pitch) => ratioFromSemitones(fork.pitch.difference(pitch));

  /// The reference generator cents.
  static const referenceGeneratorCents = Cent(700);

  @override
  Cent get generator => cents.closestTo(referenceGeneratorCents);

  @override
  String toString() => 'EDO $edo (${_steps.join(' ')}) at $fork';

  @override
  bool operator ==(Object other) =>
      other is EqualTemperament &&
      const ListEquality<int>().equals(_steps, other._steps) &&
      fork == other.fork;

  @override
  int get hashCode => Object.hash(Object.hashAll(_steps), fork);
}
