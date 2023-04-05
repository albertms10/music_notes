library music_notes;

import 'dart:collection' show SplayTreeSet;
import 'dart:math' as math show min;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart';
import 'package:music_notes/src/utils/iterable.dart';
import 'package:quiver/core.dart';

part 'src/classes/enharmonic.dart';
part 'src/classes/enharmonic_interval.dart';
part 'src/classes/enharmonic_note.dart';
part 'src/classes/interval.dart';
part 'src/classes/key_signature.dart';
part 'src/classes/note.dart';
part 'src/classes/relative_tonalities.dart';
part 'src/classes/tonality.dart';
part 'src/enums/intervals.dart';
part 'src/enums/modes.dart';
part 'src/enums/notes.dart';
part 'src/enums/qualities.dart';
part 'src/interfaces/music_item.dart';
part 'src/interfaces/transposable.dart';
part 'src/note/accidental.dart';
part 'src/utils/music.dart';
