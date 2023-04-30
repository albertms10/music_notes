import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('TonalMode', () {
    group('.opposite', () {
      test('should return the correct opposite mode', () {
        expect(TonalMode.major.opposite, TonalMode.minor);
        expect(TonalMode.minor.opposite, TonalMode.major);
      });
    });

    group('.compareTo', () {
      test('should correctly sort Mode items in a collection', () {
        final orderedSet = SplayTreeSet<Mode>.of(const [
          TonalMode.minor,
          ModalMode.phrygian,
          ModalMode.ionian,
          TonalMode.major,
          ModalMode.aeolian,
          ModalMode.lydian,
        ]);
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
}
