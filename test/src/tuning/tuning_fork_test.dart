import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('TuningFork', () {
    group('.toString()', () {
      test(
        'returns the verbose string representation of this TuningFork',
        () {
          expect(
            Note.a.sharp.inOctave(4).at(const Frequency(440)).toString(),
            'TuningFork(pitch: Pitch(note: '
            'Note(noteName: NoteName.a, accidental: Accidental(semitones: 1)), '
            'octave: 4), frequency: 440)',
          );
          expect(
            Note.c.inOctave(3).at(const Frequency(256.5)).toString(),
            'TuningFork(pitch: Pitch(note: '
            'Note(noteName: NoteName.c, accidental: Accidental(semitones: 0)), '
            'octave: 3), frequency: 256.5)',
          );
        },
      );
    });
  });

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

    group('.format()', () {
      test('returns the string representation of this TuningFork', () {
        expect(TuningFork.a440.format(), 'A440');
        expect(TuningFork.a415.format(), 'A415');
        expect(TuningFork.c256.format(), 'C256');
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).format(),
          'F♯402.3',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).format(),
          'A♭3 437.15',
        );

        const formatter = CompactTuningForkNotation(referenceOctave: 3);
        expect(TuningFork.a440.format(formatter), 'A4 440');
        expect(TuningFork.c256.format(formatter), 'C4 256');
        expect(
          Note.d.inOctave(3).at(const Frequency(314)).format(formatter),
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

    group('.format()', () {
      test('returns the string representation of this TuningFork', () {
        const english = ScientificTuningForkNotation.english;
        expect(TuningFork.a440.format(english), 'A4 = 440 Hz');
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).format(english),
          'F♯4 = 402.3 Hz',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).format(english),
          'A♭3 = 437.15 Hz',
        );

        const germanHelmholtz = ScientificTuningForkNotation.germanHelmholtz;
        expect(
          TuningFork.a440.format(germanHelmholtz),
          'a′ = 440 Hz',
        );
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).format(germanHelmholtz),
          'fis′ = 402.3 Hz',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).format(germanHelmholtz),
          'as = 437.15 Hz',
        );
      });
    });
  });
}
