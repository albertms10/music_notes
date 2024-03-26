// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:meta/meta.dart' show immutable, redeclare;

import '../interval/interval.dart';
import '../music.dart';
import 'ratio.dart';
import 'tuning_system.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
///
/// ---
/// See also:
/// * [TuningSystem].
/// * [Ratio].
@immutable
extension type const Cent(num value) implements num {
  /// The unit symbol for [Cent].
  static const unitSymbol = '¢';

  /// The number of cents in an [Interval.P8].
  static const octaveCents = Cent(chromaticDivisions * 100);

  /// The [Ratio] for this [Cent].
  Ratio get ratio => Ratio(math.pow(2, value / octaveCents));

  /// This [Cent] formatted as a string.
  ///
  /// Example:
  /// ```dart
  /// const Cent(700).format() == '700 ¢'
  /// const Cent(701.95).format() == '701.95 ¢'
  /// ```
  String format() => '$value $unitSymbol';

  /// The negation of this [Cent].
  ///
  /// Example:
  /// ```dart
  /// -const Cent(24) == const Cent(-24)
  /// -const Cent(-18.32) == const Cent(18.32)
  /// ```
  @redeclare
  Cent operator -() => Cent(-value);
}
