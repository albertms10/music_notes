// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A string extension.
extension StringExtension on String {
  /// Whether this [String] is upper-cased.
  ///
  /// Example:
  /// ```dart
  /// 'ABC'.isUpperCase == true
  /// 'xyz'.isUpperCase == false
  /// 'John'.isUpperCase == false
  /// ```
  bool get isUpperCase => toUpperCase() == this;

  /// Whether this [String] is lower-cased.
  ///
  /// Example:
  /// ```dart
  /// 'xyz'.isLowerCase == true
  /// 'ABC'.isLowerCase == false
  /// 'John'.isLowerCase == false
  /// ```
  bool get isLowerCase => toLowerCase() == this;
}
