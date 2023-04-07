part of '../../music_notes.dart';

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
      chromaticMod(
        i * const Interval(Intervals.fifth, Qualities.perfect).semitones,
      ),
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
/// exactFifthsDistance(
///   const Note(Notes.la, Accidental.flat),
///   const Note(Notes.ut, Accidental.sharp),
/// ) == 11
///
/// exactFifthsDistance(
///   const Note(Notes.la, Accidental.flat),
///   const Note(Notes.re, Accidental.flat),
/// ) == -1
/// ```
int exactFifthsDistance(Note note1, Note note2) => note1.intervalDistance(
      note2,
      const Interval(Intervals.fifth, Qualities.perfect),
    );

/// Returns the modulus [chromaticDivisions] of [value].
///
/// Examples:
/// ```dart
/// chromaticMod(4) == 4
/// chromaticMod(14) == 2
/// chromaticMod(-5) == 7
/// chromaticMod(0) == 0
/// chromaticMod(12) == 0
/// ```
int chromaticMod(int value) => value % chromaticDivisions;

/// Returns the modulus [chromaticDivisions] of [value]. If the
/// is 0, it returns [chromaticDivisions].
///
/// Examples:
/// ```dart
/// chromaticModExcludeZero(15) == 3
/// chromaticModExcludeZero(12) == 12
/// chromaticModExcludeZero(0) == 12
/// ```
int chromaticModExcludeZero(int value) =>
    nModExcludeZero(value, chromaticDivisions);

/// Returns the modulus [n] of [value]. If the
/// given value is 0, it returns [n].
///
/// Examples:
/// ```dart
/// nModExcludeZero(9, 3) == 3
/// nModExcludeZero(0, 5) == 5
/// nModExcludeZero(7, 7) == 7
/// ```
int nModExcludeZero(int value, int n) {
  final modValue = value % n;

  return modValue == 0 ? n : modValue;
}
