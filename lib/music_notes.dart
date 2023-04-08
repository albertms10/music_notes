library music_notes;

import 'dart:collection' show SplayTreeSet;
import 'dart:math' as math show min;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'src/utils/iterable.dart';

part 'src/enharmonic.dart';
part 'src/interval/enharmonic_interval.dart';
part 'src/interval/interval.dart';
part 'src/interval/intervals.dart';
part 'src/interval/qualities.dart';
part 'src/music.dart';
part 'src/music_item.dart';
part 'src/note/accidental.dart';
part 'src/note/enharmonic_note.dart';
part 'src/note/note.dart';
part 'src/note/notes.dart';
part 'src/tonality/key_signature.dart';
part 'src/tonality/modes.dart';
part 'src/tonality/relative_tonalities.dart';
part 'src/tonality/tonality.dart';
part 'src/transposable.dart';
