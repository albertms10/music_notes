part of music_notes;

enum Accidentals {
  TripleSostingut,
  DobleSostingut,
  Sostingut,
  Bemoll,
  DobleBemoll,
  TripleBemoll
}

extension AccidentalsValues on Accidentals {
  static const accidentalValues = {
    Accidentals.TripleSostingut: 3,
    Accidentals.DobleSostingut: 2,
    Accidentals.Sostingut: 1,
    Accidentals.Bemoll: -1,
    Accidentals.DobleBemoll: -2,
    Accidentals.TripleBemoll: -3,
  };

  static Accidentals fromValue(int value) => accidentalValues.keys.firstWhere(
        (accidental) =>
            Music.modValue(value + 2) - 2 == accidentalValues[accidental],
        orElse: () => null,
      );

  int get value => accidentalValues[this];
}
