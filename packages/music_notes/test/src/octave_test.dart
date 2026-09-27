import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Octave', () {
    group('as an int', () {
      test('can be used wherever a plain octave int is expected', () {
        expect(Note.a.inOctave(Octave.great), Note.a.inOctave(2));
        expect(Note.c.inOctave(Octave.reference), Note.c.inOctave(4));
      });
    });

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Octave.parse('x'), throwsFormatException);
      });

      test('parses source as an Octave', () {
        expect(Octave.parse('4'), Octave.reference);
        expect(Octave.parse('-1'), const Octave(-1));
        expect(Octave.parse('0'), Octave.subContra);
        expect(Octave.parse('große'), Octave.great);
        expect(Octave.parse(''), Octave.small);
        expect(Octave.parse("'"), Octave.oneLine);
        expect(Octave.parse(','), Octave.contra);
      });
    });

    group('.format()', () {
      test('returns the scientific string representation by default', () {
        expect(Octave.reference.format(), '4');
        expect(const Octave(-1).format(), '-1');
      });

      test('returns the German named representation', () {
        const german = GermanNamedOctaveNotation();
        expect(Octave.great.format(german), 'große');
        expect(Octave.oneLine.format(german), 'eingestrichene');
      });
    });
  });

  group('ScientificOctaveNotation', () {
    group('.parse()', () {
      test('parses source as an Octave', () {
        const chain = [ScientificOctaveNotation()];
        expect(Octave.parse('4', chain: chain), const Octave(4));
        expect(Octave.parse('−1', chain: chain), const Octave(-1));
      });
    });
  });

  group('GermanNamedOctaveNotation', () {
    const formatter = GermanNamedOctaveNotation();
    const chain = [formatter];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Octave.parse('x', chain: chain), throwsFormatException);
      });

      test('parses source as an Octave', () {
        expect(Octave.parse('subkontra', chain: chain), Octave.subContra);
        expect(Octave.parse('kontra', chain: chain), Octave.contra);
        expect(Octave.parse('große', chain: chain), Octave.great);
        expect(Octave.parse('Kleine', chain: chain), Octave.small);
        expect(Octave.parse('eingestrichene', chain: chain), Octave.oneLine);
        expect(Octave.parse('Zweigestrichene', chain: chain), Octave.twoLine);
      });
    });

    group('.format()', () {
      test('throws an UnsupportedError for octaves without a German name', () {
        expect(
          () => const Octave(9).format(formatter),
          throwsUnsupportedError,
        );
        expect(
          () => const Octave(-1).format(formatter),
          throwsUnsupportedError,
        );
      });

      test('returns the German named string representation', () {
        expect(Octave.subContra.format(formatter), 'subkontra');
        expect(Octave.contra.format(formatter), 'kontra');
        expect(Octave.great.format(formatter), 'große');
        expect(Octave.small.format(formatter), 'kleine');
        expect(Octave.oneLine.format(formatter), 'eingestrichene');
        expect(Octave.fiveLine.format(formatter), 'fünfgestrichene');
      });
    });
  });

  group('HelmholtzOctaveNotation', () {
    test('formats marks in isolation from Pitch/Note', () {
      const bass = HelmholtzOctaveNotation(isBass: true);
      const treble = HelmholtzOctaveNotation();

      expect(treble.format(Octave.small), '');
      expect(bass.format(Octave.great), '');
      expect(treble.format(Octave.reference), '′');
      expect(bass.format(const Octave(1)), '͵');
    });
  });
}
