import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {
          const Interval(Intervals.second, Qualities.major),
          const Interval(Intervals.fourth, Qualities.perfect),
        };
        collection.addAll(collection);
        expect(collection, {
          const Interval(Intervals.second, Qualities.major),
          const Interval(Intervals.fourth, Qualities.perfect),
        });
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of([
          const Interval(Intervals.second, Qualities.minor),
          const Interval(Intervals.octave, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.augmented),
        ]);
        expect(orderedSet.toList(), [
          const Interval(Intervals.unison, Qualities.perfect),
          const Interval(Intervals.unison, Qualities.augmented),
          const Interval(Intervals.second, Qualities.minor),
          const Interval(Intervals.octave, Qualities.perfect),
        ]);
      });
    });
  });
}
