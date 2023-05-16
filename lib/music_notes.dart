library music_notes;

import 'dart:collection' show SplayTreeSet;
import 'dart:math' as math show min, pow;

import 'package:collection/collection.dart'
    show IterableExtension, ListEquality;
import 'package:meta/meta.dart' show immutable;

import 'utils/int_mod_extension.dart';
import 'utils/iterable.dart';
import 'utils/num_extension.dart';

part 'src/enharmonic.dart';
part 'src/interval/enharmonic_interval.dart';
part 'src/interval/interval.dart';
part 'src/interval/interval_size_extension.dart';
part 'src/interval/quality.dart';
part 'src/music.dart';
part 'src/note/accidental.dart';
part 'src/note/base_note.dart';
part 'src/note/enharmonic_note.dart';
part 'src/note/frequency.dart';
part 'src/note/note.dart';
part 'src/note/positioned_note.dart';
part 'src/scale/scale_pattern.dart';
part 'src/tonality/key_signature.dart';
part 'src/tonality/mode.dart';
part 'src/tonality/tonality.dart';
part 'src/transposable.dart';
