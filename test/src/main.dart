import 'enharmonic_test.dart' as enharmonic_test;
import 'interval/enharmonic_interval_test.dart' as enharmonic_interval_test;
import 'interval/int_interval_extension_test.dart'
    as int_interval_extension_test;
import 'interval/interval_test.dart' as interval_test;
import 'interval/quality_test.dart' as quality_test;
import 'music_test.dart' as music_test;
import 'note/accidental_test.dart' as accidental_test;
import 'note/enharmonic_note_test.dart' as enharmonic_note_test;
import 'note/note_test.dart' as note_test;
import 'note/notes_test.dart' as notes_test;
import 'note/positioned_note_test.dart' as positioned_note_test;
import 'scale/scale_test.dart' as scale_test;
import 'tonality/key_signature_test.dart' as key_signature_test;
import 'tonality/modes_test.dart' as modes_test;
import 'tonality/tonality_test.dart' as tonality_test;

void main() {
  enharmonic_test.main();
  enharmonic_interval_test.main();
  int_interval_extension_test.main();
  interval_test.main();
  quality_test.main();
  music_test.main();
  accidental_test.main();
  enharmonic_note_test.main();
  note_test.main();
  notes_test.main();
  positioned_note_test.main();
  scale_test.main();
  key_signature_test.main();
  modes_test.main();
  tonality_test.main();
}
