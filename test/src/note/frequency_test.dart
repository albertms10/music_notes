import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Frequency', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(() => Frequency(-0.1), throwsA(isA<AssertionError>()));
      });
    });

    group('.isHumanAudible', () {
      test('should return whether the frequency is audible by humans', () {
        expect(const Frequency(0).isHumanAudible, isFalse);
        expect(const Frequency(100).isHumanAudible, isTrue);
        expect(const Frequency(400).isHumanAudible, isTrue);
        expect(const Frequency(15000).isHumanAudible, isTrue);
        expect(const Frequency(100000).isHumanAudible, isFalse);
      });
    });

    group('.closestPositionedNote()', () {
      test('should return the closest PositionedNote to this Frequency', () {
        expect(
          const Frequency(440).closestPositionedNote(),
          (Note.a.inOctave(4), cents: 0.0, hertz: 0.0),
        );
        expect(
          const Frequency(467).closestPositionedNote(),
          (
            Note.a.sharp.inOctave(4),
            cents: 3.1028314220028586,
            hertz: 0.8362384819100726,
          ),
        );
        expect(
          const Frequency(256).closestPositionedNote(),
          (
            Note.c.inOctave(4),
            cents: -37.63165622959142,
            hertz: -5.625565300598623,
          ),
        );

        expect(
          const Frequency(440)
              .closestPositionedNote(referenceFrequency: const Frequency(415)),
          (
            Note.a.sharp.inOctave(4),
            cents: 1.270624748447127,
            hertz: 0.32281584089247417,
          ),
        );
        expect(
          const Frequency(512).closestPositionedNote(
            referenceFrequency: const Frequency(512),
            referenceNote: Note.c.inOctave(5),
          ),
          (Note.c.inOctave(5), cents: 0.0, hertz: 0.0),
        );
        expect(
          const Frequency(440).closestPositionedNote(
            referenceFrequency: const Frequency(512),
            referenceNote: Note.c.inOctave(5),
          ),
          (
            Note.a.inOctave(4),
            cents: 37.63165622959145,
            hertz: 9.461035390098175,
          ),
        );
      });
    });

    group('operator +()', () {
      test('should add other to this Frequency', () {
        expect(
          const Frequency(0) + const Frequency(1200),
          const Frequency(1200),
        );
        expect(
          const Frequency(277.18) + const Frequency(415.3),
          const Frequency(692.48),
        );
        expect(
          const Frequency(440) + const Frequency(220),
          const Frequency(660),
        );
      });
    });

    group('operator -()', () {
      test('should subtract other from this Frequency', () {
        expect(
          const Frequency(20000.12) - const Frequency(0),
          const Frequency(20000.12),
        );
        expect(
          const Frequency(415.3) - const Frequency(277.18),
          const Frequency(138.12),
        );
        expect(
          const Frequency(440) - const Frequency(220),
          const Frequency(220),
        );
      });
    });

    group('operator *()', () {
      test('should multiply this Frequency by factor', () {
        expect(const Frequency(467) * 0, const Frequency(0));
        expect(const Frequency(2200.2) * 1, const Frequency(2200.2));
        expect(const Frequency(415.3) * 2, const Frequency(830.6));
        expect(const Frequency(440) * 0.5, const Frequency(220));
      });
    });

    group('operator /()', () {
      test('should divide this Frequency by factor', () {
        expect(const Frequency(467) / 1, const Frequency(467));
        expect(const Frequency(415.3) / 2, const Frequency(207.65));
        expect(const Frequency(440) / 0.5, const Frequency(880));
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
      test('should correctly sort Frequency items in a collection', () {
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
