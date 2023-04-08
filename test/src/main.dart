import 'interval/enharmonic_interval_test.dart' as enharmonic_interval_test;
import 'interval/intervals_test.dart' as interval_test;
import 'music_test.dart' as music_test;
import 'note/accidental_test.dart' as accidental_test;
import 'note/enharmonic_note_test.dart' as enharmonic_note_test;
import 'note/note_test.dart' as note_test;

void main() {
  enharmonic_interval_test.main();
  interval_test.main();
  music_test.main();
  accidental_test.main();
  enharmonic_note_test.main();
  note_test.main();
}
