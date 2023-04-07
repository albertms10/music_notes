part of '../../music_notes.dart';

@immutable
class RelativeTonalities implements Comparable<RelativeTonalities> {
  final Set<Tonality> tonalities;

  RelativeTonalities(this.tonalities)
      : assert(tonalities.length == 2, 'Provide two relative tonalities'),
        assert(
          tonalities.every(
            (tonality) =>
                tonality.accidentals == _itemsAccidentals(tonalities) &&
                tonality.accidental == _itemsAccidental(tonalities),
          ),
          'Tonalities must have the same key signature.',
        );

  /// Returns the number of accidentals of [tonalities].
  ///
  /// It is mainly used by [accidentals] getter.
  static int _itemsAccidentals(Set<Tonality> tonalities) =>
      tonalities.first.accidentals;

  /// Returns the [Accidental] of [tonalities].
  ///
  /// It is mainly used by [accidental] getter.
  static Accidental _itemsAccidental(Set<Tonality> tonalities) =>
      tonalities.first.accidental;

  /// Returns the number of accidentals of this [RelativeTonalities].
  ///
  /// Example:
  /// ```dart
  /// RelativeTonalities({
  ///   const Tonality(Note(Notes.d), Modes.major),
  ///   const Tonality(Note(Notes.b), Modes.minor),
  /// }).accidentals == 2
  /// ```
  int get accidentals => _itemsAccidentals(tonalities);

  /// Returns the [Accidental] of this [RelativeTonalities].
  ///
  /// Example:
  /// ```dart
  /// RelativeTonalities({
  ///   const Tonality(Note(Notes.e, Accidental.flat), Modes.major),
  ///   const Tonality(Note(Notes.ut), Modes.minor),
  /// }).accidental == Accidental.flat
  /// ```
  Accidental get accidental => _itemsAccidental(tonalities);

  @override
  String toString() => '$tonalities';

  @override
  bool operator ==(Object other) =>
      other is RelativeTonalities &&
      accidentals == other.accidentals &&
      accidental == other.accidental;

  @override
  int get hashCode => hash2(accidentals, accidental);

  @override
  int compareTo(covariant RelativeTonalities other) =>
      accidentals.compareTo(other.accidentals);
}
