part of music_notes;

@immutable
class RelativeTonalities implements Comparable<RelativeTonalities> {
  final Set<Tonality> tonalities;

  RelativeTonalities(this.tonalities)
      : assert(tonalities.length == 2),
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

  /// Returns an [Accidentals] enum item of [tonalities].
  ///
  /// It is mainly used by [accidental] getter.
  static Accidentals _itemsAccidental(Set<Tonality> tonalities) =>
      tonalities.first.accidental;

  /// Returns the number of accidentals of this [RelativeTonalities].
  ///
  /// Example:
  /// ```dart
  /// RelativeTonalities({
  ///   const Tonality(Note(Notes.re), Modes.major),
  ///   const Tonality(Note(Notes.si), Modes.minor),
  /// }).accidentals == 2
  /// ```
  int get accidentals => _itemsAccidentals(tonalities);

  /// Returns an [Accidentals] enum item of this [RelativeTonalities].
  ///
  /// Example:
  /// ```dart
  /// RelativeTonalities({
  ///   const Tonality(Note(Notes.mi, Accidentals.flat), Modes.major),
  ///   const Tonality(Note(Notes.ut), Modes.minor),
  /// }).accidental == Accidentals.flat
  /// ```
  Accidentals get accidental => _itemsAccidental(tonalities);

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
