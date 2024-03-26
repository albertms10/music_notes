// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart' show IterableEquality;

/// An enharmonic mixin.
mixin Enharmonic<C> {
  /// The number of semitones that define this [C].
  int get semitones;

  /// Creates a new [C] from [semitones].
  C toClass();

  /// Whether [C] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.isEnharmonicWith(Note.a.flat) == true
  /// Note.c.isEnharmonicWith(Note.b.sharp) == true
  /// Note.e.isEnharmonicWith(Note.f) == false
  /// ```
  bool isEnharmonicWith(Enharmonic<C> other) => toClass() == other.toClass();
}

/// An enharmonic iterable.
extension EnharmonicIterable<C> on Iterable<Enharmonic<C>> {
  /// The [C] representation of this [Iterable].
  Iterable<C> toClass() => map((interval) => interval.toClass());

  /// Whether this [Iterable] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// [Note.c.sharp, Note.f, Note.a.flat]
  ///   .isEnharmonicWith([Note.d.flat, Note.e.sharp, Note.g.sharp])
  ///     == true
  ///
  /// [Note.d.sharp].isEnharmonicWith([Note.a.flat]) == false
  ///
  /// const [Interval.m2, Interval.m3, Interval.M2]
  ///   .isEnharmonicWith(const [Interval.m2, Interval.A2, Interval.d3])
  ///     == true
  ///
  /// const [Interval.m2].isEnharmonicWith(const [Interval.P4]) == false
  /// ```
  bool isEnharmonicWith(Iterable<Enharmonic<C>> other) =>
      IterableEquality<C>().equals(toClass(), other.toClass());
}
