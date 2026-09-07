/// A closed interval between two ordered values, from [Range.from] to
/// [Range.to] inclusive.
///
/// This is a plain record rather than a class, so any pair of same-typed
/// values can be used as a [Range] without an explicit constructor. It
/// underlies both the compact fifths intervals in [ScaleDegree] tables and
/// the collapsed groupings produced by
/// `IterableExtension.compact`/`RangeExtension.explode`
/// (e.g., turning a scattered set of `Note`s into readable spans like
/// `C–E♭` instead of listing every semitone in between).
///
/// Example:
/// ```dart
/// const Range<int> fromOneToTen = (from: 1, to: 10);
/// const (from: Note.c, to: Note.e) = someRange; // destructuring
/// ```
typedef Range<E> = ({E from, E to});
