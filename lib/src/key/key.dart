// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../note/accidental.dart';
import '../note/note.dart';
import '../scale/scale.dart';
import 'key_signature.dart';
import 'mode.dart';

/// A musical key or tonality.
///
/// See [Key (music)](https://en.wikipedia.org/wiki/Key_(music)).
///
/// ---
/// See also:
/// * [Note].
/// * [Mode].
/// * [KeySignature].
@immutable
final class Key implements Comparable<Key> {
  /// The tonal center representing this [Key].
  final Note note;

  /// The mode representing this [Key].
  final TonalMode mode;

  /// Creates a new [Key] from [note] and [mode].
  const Key(this.note, this.mode);

  /// The [TonalMode.major] or [TonalMode.minor] relative [Key] of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.relative == Note.f.major
  /// Note.b.flat.major.relative == Note.g.minor
  /// ```
  Key get relative => Key(
        note.transposeBy(
          Interval.m3.descending(isDescending: mode == TonalMode.major),
        ),
        mode.parallel,
      );

  /// The [TonalMode.major] or [TonalMode.minor] parallel [Key] of this [Key].
  ///
  /// See [Parallel key](https://en.wikipedia.org/wiki/Parallel_key).
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.parallel == Note.d.major
  /// Note.b.flat.major.parallel == Note.b.flat.minor
  /// ```
  Key get parallel => Key(note, mode.parallel);

  /// The [KeySignature] of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.signature == KeySignature.empty
  /// Note.a.major.signature == KeySignature.fromDistance(3)
  /// Note.g.flat.major.signature == KeySignature.fromDistance(-6)
  /// ```
  KeySignature get signature => KeySignature.fromDistance(
        KeySignature.empty.keys[mode]!.note.fifthsDistanceWith(note),
      );

  /// Whether this [Key] is theoretical, whose [signature] would have
  /// at least one [Accidental.doubleFlat] or [Accidental.doubleSharp].
  ///
  /// See [Theoretical key](https://en.wikipedia.org/wiki/Theoretical_key).
  ///
  /// Example:
  /// ```dart
  /// Note.e.major.isTheoretical == false
  /// Note.g.sharp.major.isTheoretical == true
  /// Note.f.flat.minor.isTheoretical == true
  /// ```
  bool get isTheoretical => signature.distance!.abs() > 7;

  /// The scale notes of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale == const Scale([Note.c, Note.d, Note.e, Note.f, Note.g,
  ///   Note.a, Note.b, Note.c])
  ///
  /// Note.e.minor.scale == Scale([Note.e, Note.f.sharp, Note.g, Note.a, Note.b,
  ///   Note.d, Note.d, Note.e])
  /// ```
  Scale<Note> get scale => mode.scale.on(note);

  /// The string representation of this [Key] based on [system].
  ///
  /// See [NoteNotation] for all system implementations.
  ///
  /// Example:
  /// ```dart
  /// Note.c.minor.toString() == 'C minor'
  /// Note.e.flat.major.toString() == 'E♭ major'
  ///
  /// Note.c.major.toString(system: NoteNotation.romance) == 'Do maggiore'
  /// Note.a.minor.toString(system: NoteNotation.romance) == 'La minore'
  ///
  /// Note.e.flat.major.toString(system: NoteNotation.german) == 'Es-dur'
  /// Note.g.sharp.minor.toString(system: NoteNotation.german) == 'gis-moll'
  /// ```
  @override
  String toString({NoteNotation system = NoteNotation.english}) =>
      system.key(this);

  @override
  bool operator ==(Object other) =>
      other is Key && note == other.note && mode == other.mode;

  @override
  int get hashCode => Object.hash(note, mode);

  @override
  int compareTo(Key other) => compareMultiple([
        () => note.compareTo(other.note),
        () => mode.name.compareTo(other.mode.name),
      ]);
}
