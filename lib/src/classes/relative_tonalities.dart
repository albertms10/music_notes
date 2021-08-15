part of music_notes;

class RelativeTonalities {
  final Set<Tonality> tonalities;

  RelativeTonalities(this.tonalities)
      : assert(tonalities.length == 2),
        assert(
          tonalities.every(
            (tonality) =>
                tonality.accidentals == _itemsAccidentals(tonalities) &&
                tonality.accidental == _itemsAccidental(tonalities),
          ),
          'Tonalities have different key signatures.',
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
  ///   const Tonality(Note(Notes.Re), Modes.Major),
  ///   const Tonality(Note(Notes.Si), Modes.Menor),
  /// }).accidentals == 2
  /// ```
  int get accidentals => _itemsAccidentals(tonalities);

  /// Returns an [Accidentals] enum item of this [RelativeTonalities].
  ///
  /// Example:
  /// ```dart
  /// RelativeTonalities({
  ///   const Tonality(Note(Notes.Mi, Accidentals.Bemoll), Modes.Major),
  ///   const Tonality(Note(Notes.Do), Modes.Menor),
  /// }).accidental == Accidentals.Bemoll
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
}
