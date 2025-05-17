import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Accidental', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
      });

      test('parses source as an Accidental', () {
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
      test('returns whether this Accidental is flat', () {
        expect(Accidental.doubleSharp.isFlat, isFalse);
        expect(Accidental.sharp.isFlat, isFalse);
        expect(Accidental.natural.isFlat, isFalse);
        expect(Accidental.flat.isFlat, isTrue);
        expect(Accidental.doubleFlat.isFlat, isTrue);
      });
    });

    group('.isNatural', () {
      test('returns whether this Accidental is natural', () {
        expect(Accidental.doubleSharp.isNatural, isFalse);
        expect(Accidental.sharp.isNatural, isFalse);
        expect(Accidental.natural.isNatural, isTrue);
        expect(Accidental.flat.isNatural, isFalse);
        expect(Accidental.doubleFlat.isNatural, isFalse);
      });
    });

    group('.isSharp', () {
      test('returns whether this Accidental is sharp', () {
        expect(Accidental.doubleSharp.isSharp, isTrue);
        expect(Accidental.sharp.isSharp, isTrue);
        expect(Accidental.natural.isSharp, isFalse);
        expect(Accidental.flat.isSharp, isFalse);
        expect(Accidental.doubleFlat.isSharp, isFalse);
      });
    });

    group('.name', () {
      test('returns the name of this Accidental', () {
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
      test('returns the symbol string of this Accidental', () {
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
      test('returns the incremented Accidental', () {
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
      test('returns the string representation of this Accidental', () {
        expect(const Accidental(5).toString(), '♯𝄪𝄪');
        expect(const Accidental(4).toString(), '𝄪𝄪');
        expect(Accidental.tripleSharp.toString(), '♯𝄪');
        expect(Accidental.doubleSharp.toString(), '𝄪');
        expect(Accidental.sharp.toString(), '♯');
        expect(Accidental.natural.toString(), '♮');
        expect(Accidental.flat.toString(), '♭');
        expect(Accidental.doubleFlat.toString(), '𝄫');
        expect(Accidental.tripleFlat.toString(), '♭𝄫');
        expect(const Accidental(-4).toString(), '𝄫𝄫');
        expect(const Accidental(-5).toString(), '♭𝄫𝄫');
      });
    });

    group('operator +()', () {
      test('adds semitones to this Accidental', () {
        expect(Accidental.sharp + 1, Accidental.doubleSharp);
        expect(Accidental.flat + 2, Accidental.sharp);
        expect(Accidental.doubleFlat + 1, Accidental.flat);
      });
    });

    group('operator -()', () {
      test('subtracts semitones from this Accidental', () {
        expect(Accidental.sharp - 1, Accidental.natural);
        expect(Accidental.flat - 2, Accidental.tripleFlat);
        expect(Accidental.doubleSharp - 1, Accidental.sharp);
      });
    });

    group('.hashCode', () {
      test('ignores equal Accidental instances in a Set', () {
        final collection = {Accidental.natural, Accidental.flat};
        collection.addAll(collection);
        expect(collection.toList(), const [
          Accidental.natural,
          Accidental.flat,
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts Accidentals in a collection', () {
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
