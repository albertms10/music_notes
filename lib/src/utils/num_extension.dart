// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A num extension.
extension NumExtension on num {
  /// The delta string representation of this [num]
  /// (showing always the positive sign).
  ///
  /// Example:
  /// ```dart
  /// 1.1.toDeltaString() == '+1.1'
  /// 0.toDeltaString() == '+0'
  /// (-5).toDeltaString() == '-5'
  /// ```
  String toDeltaString() => isNegative ? '$this' : '+$this';
}
