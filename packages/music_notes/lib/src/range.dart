/// A representation of a range between `from` and `to`.
///
/// Both `from` and `to` are part of the range.
///
/// Example:
/// ```dart
/// <Range<int>>(from: 1, to: 5); // represents 1..5, including both 1 and 5.
/// ```
///
/// This type only describes the boundaries; whether the range is otherwise
/// continuous or discrete depends on the type of [E].
typedef Range<E> = ({E from, E to});
