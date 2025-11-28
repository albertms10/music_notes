import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Key', () {
    group('EnglishKeyNotation', () {
      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => Key.parse('C'), throwsFormatException);
          expect(() => Key.parse('major'), throwsFormatException);
          expect(() => Key.parse('C major minor'), throwsFormatException);
          expect(() => Key.parse(''), throwsFormatException);
        });

        test('parses source as a Key', () {
          expect(Key.parse('C major'), Note.c.major);
          expect(Key.parse('D major'), Note.d.major);
          expect(Key.parse('F♯ major'), Note.f.sharp.major);
          expect(Key.parse('A minor'), Note.a.minor);
          expect(Key.parse('D minor'), Note.d.minor);
          expect(Key.parse('C♯ minor'), Note.c.sharp.minor);
        });

        test('.toString() and .parse() are inverses', () {
          final testKeys = [
            Note.c.major,
            Note.a.minor,
            Note.f.sharp.major,
            Note.b.flat.minor,
          ];

          for (final key in testKeys) {
            expect(key, Key.parse(key.toString()));
          }
        });
      });

      group('.toString() ', () {
        test('returns the string representation of this Key', () {
          expect(Note.c.major.toString(), 'C major');
          expect(Note.d.minor.toString(), 'D minor');
          expect(Note.a.flat.major.toString(), 'A♭ major');
          expect(Note.f.sharp.minor.toString(), 'F♯ minor');
          expect(Note.g.sharp.sharp.major.toString(), 'G𝄪 major');
          expect(Note.e.flat.flat.minor.toString(), 'E𝄫 minor');
        });
      });
    });

    group('GermanKeyNotation', () {
      const formatter = GermanKeyNotation();
      const chain = [formatter];

      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => Key.parse('C', chain: chain), throwsFormatException);
          expect(() => Key.parse('dur', chain: chain), throwsFormatException);
          expect(
            () => Key.parse('C-dur-moll', chain: chain),
            throwsFormatException,
          );
          expect(() => Key.parse('', chain: chain), throwsFormatException);
        });

        test('parses source as a Key', () {
          expect(Key.parse('C-dur', chain: chain), Note.c.major);
          expect(Key.parse('B-dur', chain: chain), Note.b.flat.major);
          expect(Key.parse('b-dur', chain: chain), Note.b.flat.major);
          expect(Key.parse('H-moll', chain: chain), Note.b.minor);
          expect(Key.parse('D-dur', chain: chain), Note.d.major);
          expect(
            Key.parse('Gisis-dur', chain: chain),
            Note.g.sharp.sharp.major,
          );
          expect(Key.parse('a-moll', chain: chain), Note.a.minor);
          expect(Key.parse('as-moll', chain: chain), Note.a.flat.minor);
          expect(Key.parse('d-moll', chain: chain), Note.d.minor);
        });

        test('.toString() and .parse() are inverses', () {
          final testKeys = [
            Note.c.major,
            Note.a.minor,
            Note.f.sharp.major,
            Note.b.flat.minor,
          ];

          for (final key in testKeys) {
            expect(
              key,
              Key.parse(key.toString(formatter: formatter), chain: chain),
            );
          }
        });
      });

      group('.toString()', () {
        test('returns the string representation of this Key', () {
          expect(Note.c.major.toString(formatter: formatter), 'C-dur');
          expect(Note.d.minor.toString(formatter: formatter), 'd-moll');
          expect(Note.a.flat.major.toString(formatter: formatter), 'As-dur');
          expect(Note.f.sharp.minor.toString(formatter: formatter), 'fis-moll');
          expect(
            Note.g.sharp.sharp.major.toString(formatter: formatter),
            'Gisis-dur',
          );
          expect(
            Note.e.flat.flat.minor.toString(formatter: formatter),
            'eses-moll',
          );
        });
      });
    });

    group('RomanceKeyNotation', () {
      const textual = RomanceKeyNotation();
      const symbol = RomanceKeyNotation.symbol();
      const chain = [textual, symbol];

      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => Key.parse('Do', chain: chain), throwsFormatException);
          expect(
            () => Key.parse('maggiore', chain: chain),
            throwsFormatException,
          );
          expect(
            () => Key.parse('Do maggiore minore', chain: chain),
            throwsFormatException,
          );
          expect(() => Key.parse('', chain: chain), throwsFormatException);
        });

        test('parses source as a Key', () {
          expect(Key.parse('Do maggiore', chain: chain), Note.c.major);
          expect(Key.parse('Sol# maggiore', chain: chain), Note.g.sharp.major);
          expect(
            Key.parse('Fa diesis minore', chain: chain),
            Note.f.sharp.minor,
          );
          expect(Key.parse('Re maggiore', chain: chain), Note.d.major);
          expect(Key.parse('Lab minore', chain: chain), Note.a.flat.minor);
          expect(
            Key.parse('La bemolle minore', chain: chain),
            Note.a.flat.minor,
          );
          expect(Key.parse('La minore', chain: chain), Note.a.minor);
          expect(Key.parse('Re minore', chain: chain), Note.d.minor);
        });

        test('.toString() and .parse() are inverses', () {
          final testKeys = [
            Note.c.major,
            Note.a.minor,
            Note.f.sharp.major,
            Note.b.flat.minor,
          ];

          for (final key in testKeys) {
            expect(
              key,
              Key.parse(key.toString(formatter: symbol), chain: chain),
            );
          }
        });
      });

      group('.toString()', () {
        test('returns the string representation of this Key', () {
          expect(Note.c.major.toString(formatter: symbol), 'Do maggiore');
          expect(Note.d.minor.toString(formatter: symbol), 'Re minore');
          expect(
            Note.a.flat.major.toString(formatter: textual),
            'La bemolle maggiore',
          );
          expect(
            Note.a.flat.major.toString(formatter: symbol),
            'La♭ maggiore',
          );
          expect(
            Note.f.sharp.minor.toString(formatter: symbol),
            'Fa♯ minore',
          );
          expect(
            Note.g.sharp.sharp.major.toString(formatter: symbol),
            'Sol𝄪 maggiore',
          );
          expect(
            Note.a.sharp.sharp.major.toString(formatter: textual),
            'La doppio diesis maggiore',
          );
          expect(
            Note.e.flat.flat.minor.toString(formatter: symbol),
            'Mi𝄫 minore',
          );
        });
      });
    });

    group('.relative', () {
      test('returns the relative of this Key', () {
        expect(Note.c.major.relative, Note.a.minor);
        expect(Note.f.major.relative, Note.d.minor);
        expect(Note.b.minor.relative, Note.d.major);
        expect(Note.g.sharp.minor.relative, Note.b.major);
        expect(Note.a.flat.minor.relative, Note.c.flat.major);
      });
    });

    group('.parallel', () {
      test('returns the parallel of this Key', () {
        expect(Note.c.major.parallel, Note.c.minor);
        expect(Note.f.major.parallel, Note.f.minor);
        expect(Note.b.minor.parallel, Note.b.major);
        expect(Note.g.sharp.minor.parallel, Note.g.sharp.major);
        expect(Note.a.flat.major.parallel, Note.a.flat.minor);
      });
    });

    group('.signature', () {
      test('returns the KeySignature of this Key', () {
        expect(Note.c.major.signature, KeySignature.empty);
        expect(Note.a.minor.signature, KeySignature.empty);

        expect(Note.g.major.signature, KeySignature([.f.sharp]));
        expect(Note.e.minor.signature, KeySignature([.f.sharp]));
        expect(Note.f.major.signature, KeySignature([.b.flat]));
        expect(Note.d.minor.signature, KeySignature([.b.flat]));

        expect(
          Note.b.major.signature,
          KeySignature([.f.sharp, .c.sharp, .g.sharp, .d.sharp, .a.sharp]),
        );
        expect(
          Note.g.sharp.minor.signature,
          KeySignature([.f.sharp, .c.sharp, .g.sharp, .d.sharp, .a.sharp]),
        );
        expect(
          Note.d.flat.major.signature,
          KeySignature([.b.flat, .e.flat, .a.flat, .d.flat, .g.flat]),
        );
        expect(
          Note.b.flat.minor.signature,
          KeySignature([.b.flat, .e.flat, .a.flat, .d.flat, .g.flat]),
        );
      });
    });

    group('.isTheoretical', () {
      test('returns whether this Key is theoretical', () {
        expect(Note.c.flat.major.isTheoretical, false);
        expect(Note.a.flat.minor.isTheoretical, false);
        expect(Note.c.minor.isTheoretical, false);
        expect(Note.e.major.isTheoretical, false);
        expect(Note.c.sharp.major.isTheoretical, false);
        expect(Note.a.sharp.minor.isTheoretical, false);

        expect(Note.f.flat.major.isTheoretical, true);
        expect(Note.d.flat.minor.isTheoretical, true);
        expect(Note.c.sharp.sharp.minor.isTheoretical, true);
        expect(Note.a.flat.flat.major.isTheoretical, true);
        expect(Note.g.sharp.major.isTheoretical, true);
        expect(Note.e.sharp.minor.isTheoretical, true);
      });
    });

    group('.scale', () {
      test('returns the scale notes of this Key', () {
        expect(
          Note.d.major.scale,
          Scale<Note>([.d, .e, .f.sharp, .g, .a, .b, .c.sharp, .d]),
        );
        expect(
          Note.c.minor.scale,
          Scale<Note>([.c, .d, .e.flat, .f, .g, .a.flat, .b.flat, .c]),
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Key instances in a Set', () {
        final collection = {
          Note.d.major,
          Note.f.sharp.minor,
          Note.g.sharp.minor,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.d.major,
          Note.f.sharp.minor,
          Note.g.sharp.minor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts Keys in a collection', () {
        final orderedSet = SplayTreeSet<Key>.of({
          Note.f.sharp.minor,
          Note.c.minor,
          Note.d.major,
          Note.c.major,
          Note.d.flat.major,
          Note.e.flat.major,
        });
        expect(orderedSet.toList(), [
          Note.c.major,
          Note.c.minor,
          Note.d.flat.major,
          Note.d.major,
          Note.e.flat.major,
          Note.f.sharp.minor,
        ]);
      });
    });
  });
}
