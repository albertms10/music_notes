// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'interval/interval.dart';

/// A interface for items that can be transposed.
// ignore: one_member_abstracts
abstract interface class Transposable<T> {
  /// Transposes this [T] by [interval].
  T transposeBy(Interval interval);
}
