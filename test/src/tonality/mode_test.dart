import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Mode', () {
    group('.compareTo', () {
      test('should correctly sort Mode items in a collection', () {
        final orderedSet = SplayTreeSet<Mode>.of({
          TonalMode.minor,
          ModalMode.phrygian,
          ModalMode.ionian,
          TonalMode.major,
          ModalMode.aeolian,
          ModalMode.lydian,
        });
        expect(orderedSet.toList(), const [
          ModalMode.phrygian,
          ModalMode.aeolian,
          TonalMode.minor,
          ModalMode.ionian,
          TonalMode.major,
          ModalMode.lydian,
        ]);
      });
    });
  });

  group('TonalMode', () {
    group('.opposite', () {
      test('should return the correct opposite TonalMode', () {
        expect(TonalMode.major.opposite, TonalMode.minor);
        expect(TonalMode.minor.opposite, TonalMode.major);
      });
    });

    group('.toString()', () {
      test('should return the string representation of this TonalMode', () {
        expect(TonalMode.major.toString(), 'major');
        expect(TonalMode.minor.toString(), 'minor');

        expect(TonalMode.major.toString(system: NotationSystem.german), 'dur');
        expect(TonalMode.minor.toString(system: NotationSystem.german), 'moll');

        expect(
          TonalMode.major.toString(system: NotationSystem.catalan),
          'major',
        );
        expect(
          TonalMode.minor.toString(system: NotationSystem.catalan),
          'menor',
        );

        expect(
          TonalMode.major.toString(system: NotationSystem.french),
          'majeur',
        );
        expect(
          TonalMode.minor.toString(system: NotationSystem.french),
          'mineur',
        );
      });
    });
  });

  group('ModalMode', () {
    group('.mirrored', () {
      test('should return the mirrored version of this ModalMode', () {
        expect(ModalMode.dorian.mirrored, ModalMode.dorian);
        expect(ModalMode.mixolydian.mirrored, ModalMode.aeolian);
        expect(ModalMode.ionian.mirrored, ModalMode.phrygian);
        expect(ModalMode.locrian.mirrored, ModalMode.lydian);
        expect(ModalMode.lydian.mirrored, ModalMode.locrian);
      });
    });
  });
}
