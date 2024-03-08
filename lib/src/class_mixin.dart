import 'package:collection/collection.dart' show IterableEquality;

/// A Class mixin.
mixin ClassMixin<Class> {
  /// The number of semitones that define this [Class].
  int get semitones;

  /// Creates a new [Class] from [semitones].
  Class toClass();

  /// Whether [Class] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.isEnharmonicWith(Note.a.flat) == true
  /// Note.c.isEnharmonicWith(Note.b.sharp) == true
  /// Note.e.isEnharmonicWith(Note.f) == false
  /// ```
  bool isEnharmonicWith(ClassMixin<Class> other) =>
      toClass() == other.toClass();
}

/// A Class iterable.
extension ClassIterable<Class> on Iterable<ClassMixin<Class>> {
  /// The [Class] representation of this [Iterable].
  Iterable<Class> toClass() => map((interval) => interval.toClass());

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
  bool isEnharmonicWith(Iterable<ClassMixin<Class>> other) =>
      IterableEquality<Class>().equals(toClass(), other.toClass());
}
