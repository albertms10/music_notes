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
