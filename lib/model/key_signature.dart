import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/tonality.dart';

abstract class KeySignature {
  final int number;
  final Accidentals accidental;

  KeySignature(this.number, this.accidental)
      : assert(number != null),
        assert(accidental != null);

  List<Tonality> tonalities;
}
