part of music_notes;

enum Modes { Major, Menor }

extension ModesValues on Modes {
  get inverted => this == Modes.Major ? Modes.Menor : Modes.Major;
}
