import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Quality', () {
    group('.fromInterval()', () {
      test('should create a new Quality from an Interval size', () {
        expect(Quality.fromInterval(1, -1), PerfectQuality.diminished);
        expect(Quality.fromInterval(1, 0), PerfectQuality.perfect);
        expect(Quality.fromInterval(1, 1), PerfectQuality.augmented);

        expect(Quality.fromInterval(2, -1), ImperfectQuality.diminished);
        expect(Quality.fromInterval(2, 0), ImperfectQuality.minor);
        expect(Quality.fromInterval(2, 1), ImperfectQuality.major);
        expect(Quality.fromInterval(2, 2), ImperfectQuality.augmented);

        expect(Quality.fromInterval(3, -1), ImperfectQuality.diminished);
        expect(Quality.fromInterval(3, 0), ImperfectQuality.minor);
        expect(Quality.fromInterval(3, 1), ImperfectQuality.major);
        expect(Quality.fromInterval(3, 2), ImperfectQuality.augmented);

        expect(Quality.fromInterval(4, -1), PerfectQuality.diminished);
        expect(Quality.fromInterval(4, 0), PerfectQuality.perfect);
        expect(Quality.fromInterval(4, 1), PerfectQuality.augmented);

        expect(Quality.fromInterval(5, -1), PerfectQuality.diminished);
        expect(Quality.fromInterval(5, 0), PerfectQuality.perfect);
        expect(Quality.fromInterval(5, 1), PerfectQuality.augmented);

        expect(Quality.fromInterval(6, -1), ImperfectQuality.diminished);
        expect(Quality.fromInterval(6, 0), ImperfectQuality.minor);
        expect(Quality.fromInterval(6, 1), ImperfectQuality.major);
        expect(Quality.fromInterval(6, 2), ImperfectQuality.augmented);

        expect(Quality.fromInterval(7, -1), ImperfectQuality.diminished);
        expect(Quality.fromInterval(7, 0), ImperfectQuality.minor);
        expect(Quality.fromInterval(7, 1), ImperfectQuality.major);
        expect(Quality.fromInterval(7, 2), ImperfectQuality.augmented);

        expect(Quality.fromInterval(8, -1), PerfectQuality.diminished);
        expect(Quality.fromInterval(8, 0), PerfectQuality.perfect);
        expect(Quality.fromInterval(8, 1), PerfectQuality.augmented);

        expect(Quality.fromInterval(13, -1), ImperfectQuality.diminished);
        expect(Quality.fromInterval(13, 0), ImperfectQuality.minor);
        expect(Quality.fromInterval(13, 1), ImperfectQuality.major);
        expect(Quality.fromInterval(13, 2), ImperfectQuality.augmented);
      });
    });

    group('.inverted', () {
      test('should return the inverted of this Quality', () {
        expect(
          PerfectQuality.triplyDiminished.inverted,
          PerfectQuality.triplyAugmented,
        );
        expect(PerfectQuality.diminished.inverted, PerfectQuality.augmented);
        expect(PerfectQuality.perfect.inverted, PerfectQuality.perfect);
        expect(PerfectQuality.augmented.inverted, PerfectQuality.diminished);
        expect(
          PerfectQuality.triplyAugmented.inverted,
          PerfectQuality.triplyDiminished,
        );

        expect(
          ImperfectQuality.doublyDiminished.inverted,
          ImperfectQuality.doublyAugmented,
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
          ImperfectQuality.doublyAugmented.inverted,
          ImperfectQuality.doublyDiminished,
        );
      });
    });

    group('.toString()', () {
      test('should return a string representation of this Quality', () {
        expect(PerfectQuality.triplyDiminished.toString(), 'ddd (-3)');
        expect(PerfectQuality.doublyDiminished.toString(), 'dd (-2)');
        expect(PerfectQuality.diminished.toString(), 'd (-1)');
        expect(PerfectQuality.perfect.toString(), 'P (+0)');
        expect(PerfectQuality.augmented.toString(), 'A (+1)');
        expect(PerfectQuality.doublyAugmented.toString(), 'AA (+2)');
        expect(PerfectQuality.triplyAugmented.toString(), 'AAA (+3)');

        expect(ImperfectQuality.triplyDiminished.toString(), 'ddd (-3)');
        expect(ImperfectQuality.doublyDiminished.toString(), 'dd (-2)');
        expect(ImperfectQuality.diminished.toString(), 'd (-1)');
        expect(ImperfectQuality.minor.toString(), 'm (+0)');
        expect(ImperfectQuality.major.toString(), 'M (+1)');
        expect(ImperfectQuality.augmented.toString(), 'A (+2)');
        expect(ImperfectQuality.doublyAugmented.toString(), 'AA (+3)');
        expect(ImperfectQuality.triplyAugmented.toString(), 'AAA (+4)');
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
        expect(collection.toList(), const [
          PerfectQuality(5),
          ImperfectQuality(5),
          PerfectQuality.diminished,
          PerfectQuality.perfect,
          ImperfectQuality.minor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Quality items in a collection', () {
        final orderedSet = SplayTreeSet<Quality>.of(const [
          PerfectQuality(5),
          ImperfectQuality(5),
          ImperfectQuality.major,
          PerfectQuality.perfect,
          PerfectQuality.diminished,
          ImperfectQuality.diminished,
          ImperfectQuality.augmented,
        ]);
        expect(orderedSet.toList(), const [
          ImperfectQuality.diminished,
          PerfectQuality.diminished,
          PerfectQuality.perfect,
          ImperfectQuality.major,
          ImperfectQuality.augmented,
          ImperfectQuality(5),
          PerfectQuality(5),
        ]);
      });
    });
  });
}
