part of '../music_notes.dart';

/// Number of chromatic divisions in an octave.
const int chromaticDivisions = 12;

/// [Set] of [EnharmonicNote]s that form the chromatic scale.
final Set<EnharmonicNote> chromaticScale = SplayTreeSet<EnharmonicNote>.of({
  for (var i = 1; i <= chromaticDivisions; i++) EnharmonicNote(i),
});

/// Returns a [Set] of [EnharmonicNote]s that conforms the circle of fifths.
final List<EnharmonicNote> circleOfFifths = [
  for (var i = -1; i < chromaticDivisions - 1; i++)
    chromaticScale.elementAt(
      (i * const Interval(Intervals.fifth, Qualities.perfect).semitones)
          .chromaticMod,
    ),
];
