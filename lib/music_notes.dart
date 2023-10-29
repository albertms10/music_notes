/// A simple Dart library that provides a comprehensive set of utilities for
/// working with music theory concepts.
library music_notes;

import 'dart:collection' show SplayTreeSet;
import 'dart:math' as math show log, pow;

import 'package:collection/collection.dart'
    show IterableExtension, ListEquality;
import 'package:meta/meta.dart' show immutable;

import 'utils/int_extension.dart';
import 'utils/iterable.dart';
import 'utils/num_extension.dart';
import 'utils/string_extension.dart';

part 'src/chordable.dart';
part 'src/harmony/chord.dart';
part 'src/harmony/chord_pattern.dart';
part 'src/harmony/harmonic_function.dart';
part 'src/interval/interval.dart';
part 'src/interval/interval_class.dart';
part 'src/interval/quality.dart';
part 'src/music.dart';
part 'src/note/accidental.dart';
part 'src/note/base_note.dart';
part 'src/note/frequency.dart';
part 'src/note/note.dart';
part 'src/note/pitch_class.dart';
part 'src/note/positioned_note.dart';
part 'src/scalable.dart';
part 'src/scale/scale.dart';
part 'src/scale/scale_degree.dart';
part 'src/scale/scale_pattern.dart';
part 'src/tonality/key_signature.dart';
part 'src/tonality/mode.dart';
part 'src/tonality/tonality.dart';
part 'src/transposable.dart';
part 'src/tuning/cent.dart';
part 'src/tuning/ratio.dart';
part 'src/tuning/tuning_system.dart';
