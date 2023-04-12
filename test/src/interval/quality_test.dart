import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Quality', () {
    group('.inverted', () {
      test('should return the inverted of this Quality', () {
        expect(const PerfectQuality(-3).inverted, const PerfectQuality(3));
        expect(PerfectQuality.diminished.inverted, PerfectQuality.augmented);
        expect(PerfectQuality.perfect.inverted, PerfectQuality.perfect);
        expect(PerfectQuality.augmented.inverted, PerfectQuality.diminished);
        expect(const PerfectQuality(3).inverted, const PerfectQuality(-3));

        expect(
          ImperfectQuality.doubleDiminished.inverted,
          ImperfectQuality.doubleAugmented,
        );
        expect(
          ImperfectQuality.diminished.inverted,
          ImperfectQuality.augmented,
        );
        expect(ImperfectQuality.minor.inverted, ImperfectQuality.major);
        expect(ImperfectQuality.major.inverted, ImperfectQuality.minor);
        expect(
          ImperfectQuality.augmented.inverted,
          ImperfectQuality.diminished,
        );
        expect(
          ImperfectQuality.doubleAugmented.inverted,
          ImperfectQuality.doubleDiminished,
        );
      });
    });

    group('.toString()', () {
      test('should return a string representation of this Quality', () {
        expect(PerfectQuality.doubleDiminished.toString(), 'dd (-2)');
        expect(PerfectQuality.diminished.toString(), 'd (-1)');
        expect(PerfectQuality.perfect.toString(), 'P (+0)');
        expect(PerfectQuality.augmented.toString(), 'A (+1)');
        expect(PerfectQuality.doubleAugmented.toString(), 'AA (+2)');

        expect(ImperfectQuality.doubleDiminished.toString(), 'dd (-2)');
        expect(ImperfectQuality.diminished.toString(), 'd (-1)');
        expect(ImperfectQuality.minor.toString(), 'm (+0)');
        expect(ImperfectQuality.major.toString(), 'M (+1)');
        expect(ImperfectQuality.augmented.toString(), 'A (+2)');
        expect(ImperfectQuality.doubleAugmented.toString(), 'AA (+3)');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Quality instances in a Set', () {
        final collection = {
          const PerfectQuality(5),
          const ImperfectQuality(5),
          PerfectQuality.diminished,
          PerfectQuality.perfect,
          ImperfectQuality.minor,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const PerfectQuality(5),
          const ImperfectQuality(5),
          PerfectQuality.diminished,
          PerfectQuality.perfect,
          ImperfectQuality.minor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Quality items in a collection', () {
        final orderedSet = SplayTreeSet<Quality>.of([
          const PerfectQuality(5),
          const ImperfectQuality(5),
          ImperfectQuality.major,
          PerfectQuality.perfect,
          PerfectQuality.diminished,
          ImperfectQuality.diminished,
          ImperfectQuality.augmented,
        ]);
        expect(orderedSet.toList(), [
          ImperfectQuality.diminished,
          PerfectQuality.diminished,
          PerfectQuality.perfect,
          ImperfectQuality.major,
          ImperfectQuality.augmented,
          const ImperfectQuality(5),
          const PerfectQuality(5),
        ]);
      });
    });
  });
}
