import 'package:music_notes/src/note/pitch.dart';

import 'just_intonation.dart';

/// A representation of the five-limit tuning system.
class FiveLimitTuning extends JustIntonation {
  @override
  num ratio(Pitch pitch) => throw UnimplementedError();
}
