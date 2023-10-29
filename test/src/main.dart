import 'harmony/chord_pattern_test.dart' as chord_pattern_test;
import 'harmony/chord_test.dart' as chord_test;
import 'harmony/harmonic_function_test.dart' as harmonic_function_test;
import 'interval/interval_class_test.dart' as interval_class_test;
import 'interval/interval_test.dart' as interval_test;
import 'interval/quality_test.dart' as quality_test;
import 'note/accidental_test.dart' as accidental_test;
import 'note/base_note_test.dart' as base_note_test;
import 'note/frequency_test.dart' as frequency_test;
import 'note/note_test.dart' as note_test;
import 'note/pitch_class_test.dart' as pitch_class_test;
import 'note/positioned_note_test.dart' as positioned_note_test;
import 'scale/scale_degree_test.dart' as scale_degree_test;
import 'scale/scale_pattern_test.dart' as scale_pattern_test;
import 'scale/scale_test.dart' as scale_test;
import 'tonality/key_signature_test.dart' as key_signature_test;
import 'tonality/mode_test.dart' as mode_test;
import 'tonality/tonality_test.dart' as tonality_test;
import 'tuning/cent_test.dart' as cent_test;
import 'tuning/ratio_test.dart' as ratio_test;
import 'tuning/tuning_system_test.dart' as tuning_system_test;

void main() {
  chord_pattern_test.main();
  chord_test.main();
  harmonic_function_test.main();
  interval_class_test.main();
  interval_test.main();
  quality_test.main();
  accidental_test.main();
  base_note_test.main();
  frequency_test.main();
  note_test.main();
  pitch_class_test.main();
  positioned_note_test.main();
  scale_degree_test.main();
  scale_pattern_test.main();
  scale_test.main();
  key_signature_test.main();
  mode_test.main();
  tonality_test.main();
  cent_test.main();
  ratio_test.main();
  tuning_system_test.main();
}
