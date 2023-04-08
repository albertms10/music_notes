part of '../music_notes.dart';

/// Number of chromatic divisions in an octave.
const int chromaticDivisions = 12;

/// [Set] of [EnharmonicNote]s that form the chromatic scale.
final Set<EnharmonicNote> chromaticScale = SplayTreeSet<EnharmonicNote>.from({
  for (var i = 1; i <= chromaticDivisions; i++) EnharmonicNote(i),
});

/// Returns a [Set] of [EnharmonicNote]s that conforms the circle of fifths.
final Set<EnharmonicNote> circleOfFifths = SplayTreeSet<EnharmonicNote>.from({
  for (var i = 0; i < chromaticDivisions; i++)
    chromaticScale.elementAt(
      (i * const Interval(Intervals.fifth, Qualities.perfect).semitones)
          .chromaticMod,
    ),
});

/// Returns the shortest iteration distance between two [EnharmonicNote]s
/// in fifth intervals.
///
/// Examples:
/// ```dart
/// shortestFifthsDistance(
///   EnharmonicNote.fSharp,
///   EnharmonicNote.a,
/// ) == -3
///
/// shortestFifthsDistance(
///   EnharmonicNote.dSharp,
///   EnharmonicNote.g,
/// ) == 4
/// ```
int shortestFifthsDistance(
  EnharmonicNote enharmonicNote1,
  EnharmonicNote enharmonicNote2,
) {
  final distanceAbove = enharmonicNote1.enharmonicIntervalDistance(
    enharmonicNote2,
    const Interval(Intervals.fifth, Qualities.perfect),
  );
  final distanceBelow = enharmonicNote1.enharmonicIntervalDistance(
    enharmonicNote2,
    const Interval(Intervals.fifth, Qualities.perfect, descending: true),
  );

  final minDistance = math.min(distanceAbove, distanceBelow);

  return minDistance * (minDistance == distanceAbove ? 1 : -1);
}

/// Returns the exact iteration distance between two [Note]s
/// in fifth intervals.
///
/// Examples:
/// ```dart
/// exactFifthsDistance(Note.aFlat, Note.cSharp) == 11
/// exactFifthsDistance(Note.aFlat, Note.dFlat) == -1
/// ```
int exactFifthsDistance(Note note1, Note note2) => note1.intervalDistance(
      note2,
      const Interval(Intervals.fifth, Qualities.perfect),
    );
