import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('TuningFork', () {
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

        const compactSystem = CompactTuningForkNotation(referenceOctave: 3);
        expect(TuningFork.a440.toString(system: compactSystem), 'A4 440');
        expect(TuningFork.c256.toString(system: compactSystem), 'C4 256');
        expect(
          Note.d
              .inOctave(3)
              .at(const Frequency(314))
              .toString(system: compactSystem),
          'D314',
        );

        expect(
          TuningFork.a440.toString(system: TuningForkNotation.scientific),
          'A4 = 440 Hz',
        );
        expect(
          TuningFork(
            Note.f.sharp.inOctave(4),
            const Frequency(402.3),
          ).toString(system: TuningForkNotation.scientific),
          'F♯4 = 402.3 Hz',
        );
        expect(
          TuningFork(
            Note.a.flat.inOctave(3),
            const Frequency(437.15),
          ).toString(system: TuningForkNotation.scientific),
          'A♭3 = 437.15 Hz',
        );
      });
    });
  });
}
