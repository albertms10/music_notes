import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Accidental', () {
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
        final collection = <Accidental>{.natural, .flat};
        collection.addAll(collection);
        expect(collection.toList(), const <Accidental>[.natural, .flat]);
      });
    });

    group('.compareTo()', () {
      test('sorts Accidentals in a collection', () {
        final orderedSet = SplayTreeSet<Accidental>.of({
          .doubleSharp,
          .natural,
          .flat,
        });
        expect(orderedSet.toList(), const <Accidental>[
          .flat,
          .natural,
          .doubleSharp,
        ]);
      });
    });
  });

  group('SymbolAccidentalNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
        expect(() => Accidental.parse('z'), throwsFormatException);
      });

      test('parses source as an Accidental', () {
        expect(Accidental.parse('♯𝄪𝄪'), const Accidental(5));
        expect(Accidental.parse('𝄪𝄪♯'), const Accidental(5));
        expect(Accidental.parse('#xx'), const Accidental(5));
        expect(Accidental.parse('xx#'), const Accidental(5));
        expect(Accidental.parse('𝄪𝄪'), const Accidental(4));
        expect(Accidental.parse('xx'), const Accidental(4));
        expect(Accidental.parse('♯𝄪'), Accidental.tripleSharp);
        expect(Accidental.parse('𝄪♯'), Accidental.tripleSharp);
        expect(Accidental.parse('#x'), Accidental.tripleSharp);
        expect(Accidental.parse('x#'), Accidental.tripleSharp);
        expect(Accidental.parse('𝄪'), Accidental.doubleSharp);
        expect(Accidental.parse('x'), Accidental.doubleSharp);
        expect(Accidental.parse('♯'), Accidental.sharp);
        expect(Accidental.parse('#'), Accidental.sharp);
        expect(Accidental.parse('is'), Accidental.sharp);

        expect(Accidental.parse(''), Accidental.natural);
        expect(Accidental.parse('♮'), Accidental.natural);
        expect(Accidental.parse('n'), Accidental.natural);

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

        const hideNatural = SymbolAccidentalNotation(showNatural: false);
        expect(Accidental.sharp.toString(formatter: hideNatural), '♯');
        expect(Accidental.natural.toString(formatter: hideNatural), '');
        expect(Accidental.flat.toString(formatter: hideNatural), '♭');
      });

      test('returns the ASCII string representation of this Accidental', () {
        const formatter = SymbolAccidentalNotation.ascii();
        expect(const Accidental(5).toString(formatter: formatter), '#xx');
        expect(const Accidental(4).toString(formatter: formatter), 'xx');
        expect(Accidental.tripleSharp.toString(formatter: formatter), '#x');
        expect(Accidental.doubleSharp.toString(formatter: formatter), 'x');
        expect(Accidental.sharp.toString(formatter: formatter), '#');
        expect(Accidental.natural.toString(formatter: formatter), 'n');
        expect(Accidental.flat.toString(formatter: formatter), 'b');
        expect(Accidental.doubleFlat.toString(formatter: formatter), 'bb');
        expect(Accidental.tripleFlat.toString(formatter: formatter), 'bbb');
        expect(const Accidental(-4).toString(formatter: formatter), 'bbbb');
        expect(const Accidental(-5).toString(formatter: formatter), 'bbbbb');

        const hideNatural = SymbolAccidentalNotation.ascii(
          showNatural: false,
        );
        expect(Accidental.sharp.toString(formatter: hideNatural), '#');
        expect(Accidental.natural.toString(formatter: hideNatural), '');
        expect(Accidental.flat.toString(formatter: hideNatural), 'b');
      });
    });
  });

  group('EnglishAccidentalNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
        expect(() => Accidental.parse('z'), throwsFormatException);
      });

      test('parses source as an Accidental', () {
        expect(Accidental.parse('triple sharp'), Accidental.tripleSharp);
        expect(Accidental.parse('Double Sharp'), Accidental.doubleSharp);
        expect(Accidental.parse('sharp'), Accidental.sharp);
        expect(Accidental.parse('natural'), Accidental.natural);
        expect(Accidental.parse(''), Accidental.natural);
        expect(Accidental.parse('flat'), Accidental.flat);
        expect(Accidental.parse('double Flat'), Accidental.doubleFlat);
        expect(Accidental.parse('Triple flat'), Accidental.tripleFlat);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Accidental', () {
        const formatter = EnglishAccidentalNotation();

        expect(
          const Accidental(4).toString(formatter: formatter),
          '×4 sharp',
        );
        expect(
          Accidental.tripleSharp.toString(formatter: formatter),
          'triple sharp',
        );
        expect(
          Accidental.doubleSharp.toString(formatter: formatter),
          'double sharp',
        );
        expect(Accidental.sharp.toString(formatter: formatter), 'sharp');
        expect(Accidental.natural.toString(formatter: formatter), 'natural');
        expect(Accidental.flat.toString(formatter: formatter), 'flat');
        expect(
          Accidental.doubleFlat.toString(formatter: formatter),
          'double flat',
        );
        expect(
          Accidental.tripleFlat.toString(formatter: formatter),
          'triple flat',
        );
        expect(
          const Accidental(-4).toString(formatter: formatter),
          '×4 flat',
        );

        const hideNatural = EnglishAccidentalNotation(showNatural: false);
        expect(Accidental.sharp.toString(formatter: hideNatural), 'sharp');
        expect(Accidental.natural.toString(formatter: hideNatural), '');
        expect(Accidental.flat.toString(formatter: hideNatural), 'flat');
      });
    });
  });

  group('GermanAccidentalNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
        expect(() => Accidental.parse('z'), throwsFormatException);
      });

      test('parses source as an Accidental', () {
        expect(Accidental.parse('isisis'), Accidental.tripleSharp);
        expect(Accidental.parse('isis'), Accidental.doubleSharp);
        expect(Accidental.parse('is'), Accidental.sharp);
        expect(Accidental.parse(''), Accidental.natural);
        expect(Accidental.parse('s'), Accidental.flat);
        expect(Accidental.parse('es'), Accidental.flat);
        expect(Accidental.parse('eses'), Accidental.doubleFlat);
        expect(Accidental.parse('eseses'), Accidental.tripleFlat);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Accidental', () {
        const formatter = GermanAccidentalNotation();

        expect(
          const Accidental(4).toString(formatter: formatter),
          'isisisis',
        );
        expect(
          Accidental.tripleSharp.toString(formatter: formatter),
          'isisis',
        );
        expect(Accidental.doubleSharp.toString(formatter: formatter), 'isis');
        expect(Accidental.sharp.toString(formatter: formatter), 'is');
        expect(Accidental.natural.toString(formatter: formatter), '');
        expect(Accidental.flat.toString(formatter: formatter), 'es');
        expect(Accidental.doubleFlat.toString(formatter: formatter), 'eses');
        expect(
          Accidental.tripleFlat.toString(formatter: formatter),
          'eseses',
        );
        expect(
          const Accidental(-4).toString(formatter: formatter),
          'eseseses',
        );
      });
    });
  });

  group('RomanceAccidentalNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Accidental.parse('invalid'), throwsFormatException);
        expect(() => Accidental.parse('z'), throwsFormatException);
      });

      test('parses source as an Accidental', () {
        expect(Accidental.parse('triplo diesis'), Accidental.tripleSharp);
        expect(Accidental.parse('Doppio Diesis'), Accidental.doubleSharp);
        expect(Accidental.parse('diesis'), Accidental.sharp);
        expect(Accidental.parse('naturale'), Accidental.natural);
        expect(Accidental.parse(''), Accidental.natural);
        expect(Accidental.parse('bemolle'), Accidental.flat);
        expect(Accidental.parse('doppio Bemolle'), Accidental.doubleFlat);
        expect(Accidental.parse('Triplo bemolle'), Accidental.tripleFlat);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Accidental', () {
        const formatter = RomanceAccidentalNotation();

        expect(
          const Accidental(4).toString(formatter: formatter),
          '×4 diesis',
        );
        expect(
          Accidental.tripleSharp.toString(formatter: formatter),
          'triplo diesis',
        );
        expect(
          Accidental.doubleSharp.toString(formatter: formatter),
          'doppio diesis',
        );
        expect(Accidental.sharp.toString(formatter: formatter), 'diesis');
        expect(Accidental.natural.toString(formatter: formatter), 'naturale');
        expect(Accidental.flat.toString(formatter: formatter), 'bemolle');
        expect(
          Accidental.doubleFlat.toString(formatter: formatter),
          'doppio bemolle',
        );
        expect(
          Accidental.tripleFlat.toString(formatter: formatter),
          'triplo bemolle',
        );
        expect(
          const Accidental(-4).toString(formatter: formatter),
          '×4 bemolle',
        );

        const hideNatural = RomanceAccidentalNotation(showNatural: false);
        expect(Accidental.sharp.toString(formatter: hideNatural), 'diesis');
        expect(Accidental.natural.toString(formatter: hideNatural), '');
        expect(Accidental.flat.toString(formatter: hideNatural), 'bemolle');
      });
    });
  });
}
