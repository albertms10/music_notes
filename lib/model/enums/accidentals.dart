enum Accidentals { DobleSostingut, Sostingut, Bemoll, DobleBemoll }

extension AccidentalsValues on Accidentals {
  int get value => const {
        Accidentals.DobleSostingut: 2,
        Accidentals.Sostingut: 1,
        Accidentals.Bemoll: -1,
        Accidentals.DobleBemoll: -2,
      }[this];
}
