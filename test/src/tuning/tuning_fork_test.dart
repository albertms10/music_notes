import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('CompactTuningForkNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => TuningFork.parse(''), throwsFormatException);
        expect(() => TuningFork.parse('X'), throwsFormatException);
        expect(() => TuningFork.parse('440'), throwsFormatException);
        expect(() => TuningFork.parse('Z440'), throwsFormatException);
        expect(() => TuningFork.parse('A+440'), throwsFormatException);
      });

      test('parses source as a TuningFork', () {
        expect(TuningFork.parse('A440'), TuningFork.a440);
        expect(TuningFork.parse('a4 440'), TuningFork.a440);
        expect(TuningFork.parse('C256 Hz'), TuningFork.c256);
        expect(
          TuningFork.parse('db5  256.14'),
          TuningFork(Note.d.flat.inOctave(5), const Frequency(256.14)),
        );
        expect(
          skip: 'Support Helmholtz pitch notation',
          () => TuningFork.parse("db'' 223.9"),
          TuningFork(Note.d.flat.inOctave(5), const Frequency(223.9)),
        );
        expect(
          TuningFork.parse('fx-2 314.1 hz'),
          TuningFork(Note.f.sharp.sharp.inOctave(-2), const Frequency(314.1)),
        );

        const formatter = CompactTuningForkNotation(referenceOctave: 3);
        expect(
          TuningFork.parse('C# 256.44', chain: const [formatter]),
          TuningFork(Note.c.sharp.inOctave(3), const Frequency(256.44)),
        );
        expect(
          TuningFork.parse('A4 440hz', chain: const [formatter]),
          TuningFork.a440,
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this TuningFork', () {
        expect(TuningFork.a440.toString(), 'A440');
        expect(TuningFork.a415.toString(), 'A415');
        expect(TuningFork.c256.toString(), 'C256');
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).toString(),
          'F♯402.3',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).toString(),
          'A♭3 437.15',
        );

        const formatter = CompactTuningForkNotation(referenceOctave: 3);
        expect(TuningFork.a440.toString(formatter: formatter), 'A4 440');
        expect(TuningFork.c256.toString(formatter: formatter), 'C4 256');
        expect(
          Note.d
              .inOctave(3)
              .at(const Frequency(314))
              .toString(formatter: formatter),
          'D314',
        );
      });
    });
  });

  group('ScientificTuningForkNotation', () {
    const formatter = ScientificTuningForkNotation.english;
    const chain = [formatter];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(
          () => TuningFork.parse('', chain: chain),
          throwsFormatException,
        );
        expect(
          () => TuningFork.parse('X', chain: chain),
          throwsFormatException,
        );
        expect(
          () => TuningFork.parse('A=440', chain: chain),
          throwsFormatException,
        );
        expect(
          () => TuningFork.parse('A=440Hz', chain: chain),
          throwsFormatException,
        );
      });

      test('parses source as a TuningFork', () {
        expect(TuningFork.parse('A4 = 440 Hz'), TuningFork.a440);
        expect(TuningFork.parse('A4=415hz'), TuningFork.a415);
        expect(TuningFork.parse("a' = 415hz"), TuningFork.a415);
        expect(
          TuningFork.parse('C2 =  256.9'),
          TuningFork(Note.c.inOctave(2), const Frequency(256.9)),
        );
        expect(
          TuningFork.parse('Cis =  256.9'),
          TuningFork(Note.c.sharp.inOctave(2), const Frequency(256.9)),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this TuningFork', () {
        const english = ScientificTuningForkNotation.english;
        expect(TuningFork.a440.toString(formatter: english), 'A4 = 440 Hz');
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).toString(formatter: english),
          'F♯4 = 402.3 Hz',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).toString(formatter: english),
          'A♭3 = 437.15 Hz',
        );

        const germanHelmholtz = ScientificTuningForkNotation.germanHelmholtz;
        expect(
          TuningFork.a440.toString(formatter: germanHelmholtz),
          'a′ = 440 Hz',
        );
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).toString(formatter: germanHelmholtz),
          'fis′ = 402.3 Hz',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).toString(formatter: germanHelmholtz),
          'as = 437.15 Hz',
        );
      });
    });
  });
}
