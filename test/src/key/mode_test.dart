import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Mode', () {
    group('.compareTo', () {
      test('sorts Modes in a collection', () {
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
    group('EnglishTonalModeNotation', () {
      group('.parse()', () {
        test('throws FormatException for invalid input', () {
          expect(() => TonalMode.parse('invalid'), throwsFormatException);
          expect(() => TonalMode.parse(''), throwsFormatException);
        });

        test('parses a TonalMode from source', () {
          expect(TonalMode.parse('major'), TonalMode.major);
          expect(TonalMode.parse('minor'), TonalMode.minor);
          expect(TonalMode.parse('Major'), TonalMode.major);
          expect(TonalMode.parse('MINOR'), TonalMode.minor);
        });
      });

      group('.toString()', () {
        test('returns the string representation of this TonalMode', () {
          expect(TonalMode.major.toString(), 'major');
          expect(TonalMode.minor.toString(), 'minor');
        });
      });
    });

    group('GermanTonalModeNotation', () {
      const formatter = GermanTonalModeNotation();
      const chain = [formatter];

      group('.parse()', () {
        test('throws FormatException for invalid input', () {
          expect(
            () => TonalMode.parse('invalid', chain: chain),
            throwsFormatException,
          );
          expect(
            () => TonalMode.parse('', chain: chain),
            throwsFormatException,
          );
        });

        test('parses a TonalMode from source', () {
          expect(TonalMode.parse('dur', chain: chain), TonalMode.major);
          expect(TonalMode.parse('moll', chain: chain), TonalMode.minor);
          expect(TonalMode.parse('Dur', chain: chain), TonalMode.major);
          expect(TonalMode.parse('Moll', chain: chain), TonalMode.minor);
        });
      });

      group('.toString()', () {
        test('returns the string representation of this TonalMode', () {
          expect(TonalMode.major.toString(formatter: formatter), 'Dur');
          expect(TonalMode.minor.toString(formatter: formatter), 'Moll');
        });
      });
    });

    group('RomanceTonalModeNotation', () {
      const formatter = RomanceTonalModeNotation();
      const chain = [formatter];

      group('.parse()', () {
        test('throws FormatException for invalid input', () {
          expect(
            () => TonalMode.parse('invalid', chain: chain),
            throwsFormatException,
          );
          expect(
            () => TonalMode.parse('', chain: chain),
            throwsFormatException,
          );
        });

        test('parses a TonalMode from source', () {
          expect(TonalMode.parse('maggiore', chain: chain), TonalMode.major);
          expect(TonalMode.parse('minore', chain: chain), TonalMode.minor);
          expect(TonalMode.parse('Maggiore', chain: chain), TonalMode.major);
          expect(TonalMode.parse('Minore', chain: chain), TonalMode.minor);
        });
      });

      group('.toString()', () {
        test('returns the string representation of this TonalMode', () {
          expect(TonalMode.major.toString(formatter: formatter), 'maggiore');
          expect(TonalMode.minor.toString(formatter: formatter), 'minore');
        });
      });
    });

    group('.parallel', () {
      test('returns the correct parallel TonalMode', () {
        expect(TonalMode.major.parallel, TonalMode.minor);
        expect(TonalMode.minor.parallel, TonalMode.major);
      });
    });
  });

  group('ModalMode', () {
    group('.mirrored', () {
      test('returns the mirrored version of this ModalMode', () {
        expect(ModalMode.dorian.mirrored, ModalMode.dorian);
        expect(ModalMode.mixolydian.mirrored, ModalMode.aeolian);
        expect(ModalMode.ionian.mirrored, ModalMode.phrygian);
        expect(ModalMode.locrian.mirrored, ModalMode.lydian);
        expect(ModalMode.lydian.mirrored, ModalMode.locrian);
      });
    });
  });
}
