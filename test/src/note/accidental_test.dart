// ignore_for_file: use_named_constants

import 'dart:collection' show SplayTreeSet;

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

    group('.parse()', () {
      test('should throw a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
      });

      test('should parse source as an Accidental and return its value', () {
        expect(Accidental.parse('♯𝄪𝄪'), const Accidental(5));
        expect(Accidental.parse('#xx'), const Accidental(5));
        expect(Accidental.parse('𝄪𝄪'), const Accidental(4));
        expect(Accidental.parse('xx'), const Accidental(4));
        expect(Accidental.parse('♯𝄪'), Accidental.tripleSharp);
        expect(Accidental.parse('#x'), Accidental.tripleSharp);
        expect(Accidental.parse('𝄪'), Accidental.doubleSharp);
        expect(Accidental.parse('x'), Accidental.doubleSharp);
        expect(Accidental.parse('♯'), Accidental.sharp);
        expect(Accidental.parse('#'), Accidental.sharp);

        expect(Accidental.parse(''), Accidental.natural);
        expect(Accidental.parse('♮'), Accidental.natural);

        expect(Accidental.parse('♭'), Accidental.flat);
        expect(Accidental.parse('b'), Accidental.flat);
        expect(Accidental.parse('𝄫'), Accidental.doubleFlat);
        expect(Accidental.parse('bb'), Accidental.doubleFlat);
        expect(Accidental.parse('♭𝄫'), Accidental.tripleFlat);
        expect(Accidental.parse('bbb'), Accidental.tripleFlat);
        expect(Accidental.parse('𝄫𝄫'), const Accidental(-4));
        expect(Accidental.parse('bbbb'), const Accidental(-4));
        expect(Accidental.parse('♭𝄫𝄫'), const Accidental(-5));
        expect(Accidental.parse('bbbbb'), const Accidental(-5));
      });
    });

    group('.isFlat', () {
      test('should return whether this Accidental is flat', () {
        expect(Accidental.doubleSharp.isFlat, isFalse);
        expect(Accidental.sharp.isFlat, isFalse);
        expect(Accidental.natural.isFlat, isFalse);
        expect(Accidental.flat.isFlat, isTrue);
        expect(Accidental.doubleFlat.isFlat, isTrue);
      });
    });

    group('.isNatural', () {
      test('should return whether this Accidental is natural', () {
        expect(Accidental.doubleSharp.isNatural, isFalse);
        expect(Accidental.sharp.isNatural, isFalse);
        expect(Accidental.natural.isNatural, isTrue);
        expect(Accidental.flat.isNatural, isFalse);
        expect(Accidental.doubleFlat.isNatural, isFalse);
      });
    });

    group('.isSharp', () {
      test('should return whether this Accidental is sharp', () {
        expect(Accidental.doubleSharp.isSharp, isTrue);
        expect(Accidental.sharp.isSharp, isTrue);
        expect(Accidental.natural.isSharp, isFalse);
        expect(Accidental.flat.isSharp, isFalse);
        expect(Accidental.doubleFlat.isSharp, isFalse);
      });
    });

    group('.name', () {
      test('should return the name of this Accidental', () {
        expect(const Accidental(8).name, '×8 sharp');
        expect(const Accidental(4).name, '×4 sharp');
        expect(Accidental.tripleSharp.name, 'Triple sharp');
        expect(Accidental.doubleSharp.name, 'Double sharp');
        expect(Accidental.sharp.name, 'Sharp');
        expect(Accidental.natural.name, 'Natural');
        expect(Accidental.flat.name, 'Flat');
        expect(Accidental.doubleFlat.name, 'Double flat');
        expect(Accidental.tripleFlat.name, 'Triple flat');
        expect(const Accidental(-5).name, '×5 flat');
        expect(const Accidental(-7).name, '×7 flat');
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

    group('.incrementBy()', () {
      test('should return the incremented Accidental', () {
        expect(Accidental.flat.incrementBy(-2), Accidental.sharp);
        expect(Accidental.flat.incrementBy(-1), Accidental.natural);
        expect(Accidental.flat.incrementBy(0), Accidental.flat);
        expect(Accidental.flat.incrementBy(1), Accidental.doubleFlat);
        expect(Accidental.flat.incrementBy(2), Accidental.tripleFlat);

        expect(Accidental.natural.incrementBy(-2), Accidental.doubleFlat);
        expect(Accidental.natural.incrementBy(-1), Accidental.flat);
        expect(Accidental.natural.incrementBy(0), Accidental.natural);
        expect(Accidental.natural.incrementBy(1), Accidental.sharp);
        expect(Accidental.natural.incrementBy(2), Accidental.doubleSharp);

        expect(Accidental.sharp.incrementBy(-2), Accidental.flat);
        expect(Accidental.sharp.incrementBy(-1), Accidental.natural);
        expect(Accidental.sharp.incrementBy(0), Accidental.sharp);
        expect(Accidental.sharp.incrementBy(1), Accidental.doubleSharp);
        expect(Accidental.sharp.incrementBy(2), Accidental.tripleSharp);
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Accidental', () {
        expect(const Accidental(5).toString(), '×5 sharp (♯𝄪𝄪)');
        expect(const Accidental(4).toString(), '×4 sharp (𝄪𝄪)');
        expect(Accidental.tripleSharp.toString(), 'Triple sharp (♯𝄪)');
        expect(Accidental.doubleSharp.toString(), 'Double sharp (𝄪)');
        expect(Accidental.sharp.toString(), 'Sharp (♯)');
        expect(Accidental.natural.toString(), 'Natural (♮)');
        expect(Accidental.flat.toString(), 'Flat (♭)');
        expect(Accidental.doubleFlat.toString(), 'Double flat (𝄫)');
        expect(Accidental.tripleFlat.toString(), 'Triple flat (♭𝄫)');
        expect(const Accidental(-4).toString(), '×4 flat (𝄫𝄫)');
        expect(const Accidental(-5).toString(), '×5 flat (♭𝄫𝄫)');
      });
    });

    group('operator +()', () {
      test('should add semitones to this Accidental', () {
        expect(Accidental.sharp + 1, Accidental.doubleSharp);
        expect(Accidental.flat + 2, Accidental.sharp);
        expect(Accidental.doubleFlat + 1, Accidental.flat);
      });
    });

    group('operator -()', () {
      test('should subtract semitones from this Accidental', () {
        expect(Accidental.sharp - 1, Accidental.natural);
        expect(Accidental.flat - 2, Accidental.tripleFlat);
        expect(Accidental.doubleSharp - 1, Accidental.sharp);
      });
    });

    group('.hashCode', () {
      test('should ignore equal Accidental instances in a Set', () {
        final collection = {Accidental.natural, Accidental.flat};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [Accidental.natural, Accidental.flat],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Accidental items in a collection', () {
        final orderedSet = SplayTreeSet<Accidental>.of({
          Accidental.doubleSharp,
          Accidental.natural,
          Accidental.flat,
        });
        expect(orderedSet.toList(), const [
          Accidental.flat,
          Accidental.natural,
          Accidental.doubleSharp,
        ]);
      });
    });
  });
}
