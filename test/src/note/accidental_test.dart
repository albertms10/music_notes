// ignore_for_file: use_named_constants

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Accidental', () {
    group('constructor', () {
      test('should create a new Accidental from static constants', () {
        expect(Accidental.tripleSharp, const Accidental(3));
        expect(Accidental.doubleSharp, const Accidental(2));
        expect(Accidental.sharp, const Accidental(1));
        expect(Accidental.natural, const Accidental(0));
        expect(Accidental.flat, const Accidental(-1));
        expect(Accidental.doubleFlat, const Accidental(-2));
        expect(Accidental.tripleFlat, const Accidental(-3));
      });
    });

    group('.symbol', () {
      test('should return the symbol string of this Accidental', () {
        expect(const Accidental(5).symbol, '♯𝄪𝄪');
        expect(const Accidental(4).symbol, '𝄪𝄪');
        expect(Accidental.tripleSharp.symbol, '♯𝄪');
        expect(Accidental.doubleSharp.symbol, '𝄪');
        expect(Accidental.sharp.symbol, '♯');
        expect(Accidental.natural.symbol, '♮');
        expect(Accidental.flat.symbol, '♭');
        expect(Accidental.doubleFlat.symbol, '𝄫');
        expect(Accidental.tripleFlat.symbol, '♭𝄫');
        expect(const Accidental(-4).symbol, '𝄫𝄫');
        expect(const Accidental(-5).symbol, '♭𝄫𝄫');
      });
    });

    group('.increment()', () {
      test('should return the incremented Accidental', () {
        expect(Accidental.flat.increment(-2), Accidental.sharp);
        expect(Accidental.flat.increment(-1), Accidental.natural);
        expect(Accidental.flat.increment(0), Accidental.flat);
        expect(Accidental.flat.increment(1), Accidental.doubleFlat);
        expect(Accidental.flat.increment(2), Accidental.tripleFlat);

        expect(Accidental.natural.increment(-2), Accidental.doubleFlat);
        expect(Accidental.natural.increment(-1), Accidental.flat);
        expect(Accidental.natural.increment(0), Accidental.natural);
        expect(Accidental.natural.increment(1), Accidental.sharp);
        expect(Accidental.natural.increment(2), Accidental.doubleSharp);

        expect(Accidental.sharp.increment(-2), Accidental.flat);
        expect(Accidental.sharp.increment(-1), Accidental.natural);
        expect(Accidental.sharp.increment(0), Accidental.sharp);
        expect(Accidental.sharp.increment(1), Accidental.doubleSharp);
        expect(Accidental.sharp.increment(2), Accidental.tripleSharp);
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Accidental', () {
        expect(const Accidental(5).toString(), '♯𝄪𝄪 (5)');
        expect(const Accidental(4).toString(), '𝄪𝄪 (4)');
        expect(Accidental.tripleSharp.toString(), '♯𝄪 (3)');
        expect(Accidental.doubleSharp.toString(), '𝄪 (2)');
        expect(Accidental.sharp.toString(), '♯ (1)');
        expect(Accidental.natural.toString(), '♮ (0)');
        expect(Accidental.flat.toString(), '♭ (-1)');
        expect(Accidental.doubleFlat.toString(), '𝄫 (-2)');
        expect(Accidental.tripleFlat.toString(), '♭𝄫 (-3)');
        expect(const Accidental(-4).toString(), '𝄫𝄫 (-4)');
        expect(const Accidental(-5).toString(), '♭𝄫𝄫 (-5)');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Accidental instances in a Set', () {
        final collection = {
          Accidental.natural,
          Accidental.flat,
        }..add(Accidental.natural);
        expect(collection.length, 2);
      });
    });
  });
}
