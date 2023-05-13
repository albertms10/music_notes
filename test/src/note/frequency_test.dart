import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Frequency', () {
    group('.isHumanAudible', () {
      test('should return whether the frequency is audible by humans', () {
        expect(const Frequency(0).isHumanAudible, isFalse);
        expect(const Frequency(100).isHumanAudible, isTrue);
        expect(const Frequency(400).isHumanAudible, isTrue);
        expect(const Frequency(15000).isHumanAudible, isTrue);
        expect(const Frequency(100000).isHumanAudible, isFalse);
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Frequency', () {
        expect(const Frequency(440).toString(), '440.0 Hz');
        expect(const Frequency(415.62).toString(), '415.62 Hz');
        expect(const Frequency(2200.2968).toString(), '2200.2968 Hz');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Frequency instances in a Set', () {
        final collection = {
          const Frequency(432),
          const Frequency(440),
          const Frequency(467),
        };
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [Frequency(432), Frequency(440), Frequency(467)],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Note items in a collection', () {
        final orderedSet = SplayTreeSet<Frequency>.of(const [
          Frequency(2000),
          Frequency(10),
          Frequency(400),
          Frequency(500),
        ]);
        expect(orderedSet.toList(), const [
          Frequency(10),
          Frequency(400),
          Frequency(500),
          Frequency(2000),
        ]);
      });
    });
  });
}
