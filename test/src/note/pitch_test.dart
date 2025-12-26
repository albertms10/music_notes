import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' show XmlParserException;

void main() {
  group('Pitch', () {
    group('.fromMidi()', () {
      test('throws an ArgumentError if the MIDI number is out of range', () {
        expect(() => Pitch.fromMidi(-1), throwsArgumentError);
        expect(() => Pitch.fromMidi(128), throwsArgumentError);
      });

      test('creates a new Pitch from the given MIDI number', () {
        expect(Pitch.fromMidi(0), Note.c.inOctave(-1));
        expect(Pitch.fromMidi(61), Note.c.sharp.inOctave(4));
        expect(Pitch.fromMidi(127), Note.g.inOctave(9));
      });
    });

    group('.inOctave()', () {
      test('changes the octave of each Pitch in this list', () {
        expect(const <Pitch>[].inOctave(2), const <Pitch>[]);

        expect([Note.f.sharp.inOctave(1)].inOctave(5), [
          Note.f.sharp.inOctave(5),
        ]);

        expect(
          [
            Note.c.inOctave(3),
            Note.e.inOctave(-1),
            Note.g.flat.inOctave(6),
          ].inOctave(4),
          [Note.c.inOctave(4), Note.e.inOctave(4), Note.g.flat.inOctave(4)],
        );
      });
    });

    group('.octaveFromSemitones', () {
      test(
        'returns the octave that corresponds to the semitones from root height',
        () {
          expect(Pitch.octaveFromSemitones(-37), -4);
          expect(Pitch.octaveFromSemitones(-36), -3);
          expect(Pitch.octaveFromSemitones(-25), -3);
          expect(Pitch.octaveFromSemitones(-24), -2);
          expect(Pitch.octaveFromSemitones(-23), -2);
          expect(Pitch.octaveFromSemitones(-12), -1);
          expect(Pitch.octaveFromSemitones(-11), -1);
          expect(Pitch.octaveFromSemitones(-1), -1);
          expect(Pitch.octaveFromSemitones(0), 0); // root C
          expect(Pitch.octaveFromSemitones(1), 0);
          expect(Pitch.octaveFromSemitones(11), 0);
          expect(Pitch.octaveFromSemitones(12), 1);
          expect(Pitch.octaveFromSemitones(13), 1);
          expect(Pitch.octaveFromSemitones(24), 2);
          expect(Pitch.octaveFromSemitones(34), 2);
          expect(Pitch.octaveFromSemitones(58), 4);
        },
      );
    });

    group('.semitones', () {
      test('returns the semitones of this Pitch from C0', () {
        expect(Note.c.inOctave(-4).semitones, -48);
        expect(Note.a.inOctave(-4).semitones, -39);
        expect(Note.c.inOctave(-3).semitones, -36);
        expect(Note.c.inOctave(-2).semitones, -24);
        expect(Note.c.inOctave(-1).semitones, -12);
        expect(Note.d.inOctave(-1).semitones, -10);
        expect(Note.e.inOctave(-1).semitones, -8);
        expect(Note.f.inOctave(-1).semitones, -7);
        expect(Note.g.inOctave(-1).semitones, -5);
        expect(Note.a.inOctave(-1).semitones, -3);
        expect(Note.b.inOctave(-1).semitones, -1);
        expect(Note.c.inOctave(0).semitones, 0);
        expect(Note.d.inOctave(0).semitones, 2);
        expect(Note.e.inOctave(0).semitones, 4);
        expect(Note.f.sharp.inOctave(0).semitones, 6);
        expect(Note.g.flat.inOctave(0).semitones, 6);
        expect(Note.a.inOctave(0).semitones, 9);
        expect(Note.b.inOctave(0).semitones, 11);
        expect(Note.c.inOctave(1).semitones, 12);
        expect(Note.c.inOctave(2).semitones, 24);
        expect(Note.a.inOctave(2).semitones, 33);
        expect(Note.c.inOctave(3).semitones, 36);
        expect(Note.a.inOctave(4).semitones, 57);
      });
    });

    group('.midiNumber', () {
      test('returns the MIDI key of this Pitch', () {
        expect(Note.c.flat.inOctave(-1).midiNumber, isNull);
        expect(Note.c.inOctave(-1).midiNumber, 0);
        expect(Note.c.inOctave(0).midiNumber, 12);
        expect(Note.c.inOctave(1).midiNumber, 24);
        expect(Note.c.inOctave(4).midiNumber, 60);
        expect(Note.a.inOctave(4).midiNumber, 69);
        expect(Note.g.inOctave(9).midiNumber, 127);
        expect(Note.g.sharp.inOctave(9).midiNumber, isNull);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another Pitch', () {
        expect(Note.c.inOctave(4).difference(Note.c.inOctave(4)), 0);
        expect(Note.e.sharp.inOctave(4).difference(Note.f.inOctave(4)), 0);
        expect(Note.c.inOctave(4).difference(Note.d.flat.inOctave(4)), 1);
        expect(Note.c.inOctave(4).difference(Note.c.sharp.inOctave(4)), 1);
        expect(Note.b.inOctave(4).difference(Note.c.inOctave(5)), 1);
        expect(Note.f.inOctave(4).difference(Note.g.inOctave(4)), 2);
        expect(Note.f.inOctave(4).difference(Note.a.flat.inOctave(4)), 3);
        expect(Note.e.inOctave(4).difference(Note.a.flat.inOctave(4)), 4);
        expect(Note.a.inOctave(4).difference(Note.d.inOctave(5)), 5);
        expect(Note.d.inOctave(4).difference(Note.a.flat.inOctave(4)), 6);
        expect(Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)), 7);
        expect(
          Note.d.sharp.inOctave(4).difference(Note.a.sharp.inOctave(4)),
          7,
        );
        expect(Note.d.inOctave(4).difference(Note.a.sharp.inOctave(4)), 8);
        expect(Note.c.sharp.inOctave(4).difference(Note.b.flat.inOctave(4)), 9);
        expect(Note.c.sharp.inOctave(4).difference(Note.b.inOctave(4)), 10);
        expect(Note.d.flat.inOctave(4).difference(Note.b.inOctave(4)), 10);
        expect(Note.c.inOctave(4).difference(Note.b.inOctave(4)), 11);
      });
    });

    group('.augmentedTriad', () {
      test('returns the augmented triad on this Pitch', () {
        expect(
          Note.c.inOctave(4).augmentedTriad,
          Chord([
            Note.c.inOctave(4),
            Note.e.inOctave(4),
            Note.g.sharp.inOctave(4),
          ]),
        );
        expect(
          Note.a.inOctave(3).augmentedTriad,
          Chord([
            Note.a.inOctave(3),
            Note.c.sharp.inOctave(4),
            Note.e.sharp.inOctave(4),
          ]),
        );
        expect(
          Note.b.inOctave(5).augmentedTriad,
          Chord([
            Note.b.inOctave(5),
            Note.d.sharp.inOctave(6),
            Note.f.sharp.sharp.inOctave(6),
          ]),
        );
      });
    });

    group('.majorTriad', () {
      test('returns the major triad on this Pitch', () {
        expect(
          Note.c.inOctave(4).majorTriad,
          Chord([Note.c.inOctave(4), Note.e.inOctave(4), Note.g.inOctave(4)]),
        );
        expect(
          Note.e.flat.inOctave(3).majorTriad,
          Chord([
            Note.e.flat.inOctave(3),
            Note.g.inOctave(3),
            Note.b.flat.inOctave(3),
          ]),
        );
        expect(
          Note.b.inOctave(3).majorTriad,
          Chord([
            Note.b.inOctave(3),
            Note.d.sharp.inOctave(4),
            Note.f.sharp.inOctave(4),
          ]),
        );
      });
    });

    group('.minorTriad', () {
      test('returns the minor triad on this Pitch', () {
        expect(
          Note.d.flat.inOctave(5).minorTriad,
          Chord([
            Note.d.flat.inOctave(5),
            Note.f.flat.inOctave(5),
            Note.a.flat.inOctave(5),
          ]),
        );
        expect(
          Note.g.sharp.inOctave(4).minorTriad,
          Chord([
            Note.g.sharp.inOctave(4),
            Note.b.inOctave(4),
            Note.d.sharp.inOctave(5),
          ]),
        );
        expect(
          Note.a.inOctave(3).minorTriad,
          Chord([Note.a.inOctave(3), Note.c.inOctave(4), Note.e.inOctave(4)]),
        );
      });
    });

    group('.diminishedTriad', () {
      test('returns the diminished triad on this Pitch', () {
        expect(
          Note.e.inOctave(4).diminishedTriad,
          Chord([
            Note.e.inOctave(4),
            Note.g.inOctave(4),
            Note.b.flat.inOctave(4),
          ]),
        );
        expect(
          Note.g.flat.inOctave(2).diminishedTriad,
          Chord([
            Note.g.flat.inOctave(2),
            Note.b.flat.flat.inOctave(2),
            Note.d.flat.flat.inOctave(3),
          ]),
        );
        expect(
          Note.b.inOctave(5).diminishedTriad,
          Chord([Note.b.inOctave(5), Note.d.inOctave(6), Note.f.inOctave(6)]),
        );
      });
    });

    group('.respellByNoteName()', () {
      test('returns this Pitch respelled by NoteName', () {
        expect(
          Note.c.sharp.inOctave(4).respellByNoteName(.d),
          Note.d.flat.inOctave(4),
        );
        expect(
          Note.e.flat.inOctave(3).respellByNoteName(.d),
          Note.d.sharp.inOctave(3),
        );
        expect(
          Note.e.sharp.inOctave(6).respellByNoteName(.f),
          Note.f.inOctave(6),
        );
        expect(
          Note.f.flat.inOctave(4).respellByNoteName(.e),
          Note.e.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).respellByNoteName(.b),
          Note.b.sharp.inOctave(3),
        );
        expect(
          Note.c.inOctave(5).respellByNoteName(.d),
          Note.d.flat.flat.inOctave(5),
        );
        expect(
          Note.b.inOctave(4).respellByNoteName(.c),
          Note.c.flat.inOctave(5),
        );
        expect(
          Note.b.inOctave(4).respellByNoteName(.a),
          Note.a.sharp.sharp.inOctave(4),
        );
      });
    });

    group('.respellByOrdinalDistance()', () {
      test('returns this Pitch respelled by ordinal distance', () {
        expect(
          Note.c.sharp.inOctave(4).respellByOrdinalDistance(1),
          Note.d.flat.inOctave(4),
        );
        expect(
          Note.c.sharp.inOctave(4).respellByOrdinalDistance(-1),
          Note.b.sharp.sharp.inOctave(3),
        );
        expect(
          Note.d.flat.inOctave(4).respellByOrdinalDistance(-1),
          Note.c.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).respellByOrdinalDistance(1),
          Note.d.flat.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(3).respellByOrdinalDistance(-1),
          Note.b.sharp.inOctave(2),
        );
        expect(
          Note.c.flat.inOctave(4).respellByOrdinalDistance(-1),
          Note.b.inOctave(3),
        );
        expect(
          Note.d.inOctave(4).respellByOrdinalDistance(-1),
          Note.c.sharp.sharp.inOctave(4),
        );
        expect(
          Note.g.flat.inOctave(4).respellByOrdinalDistance(-1),
          Note.f.sharp.inOctave(4),
        );
        expect(
          Note.e.sharp.inOctave(4).respellByOrdinalDistance(2),
          Note.g.flat.flat.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).respellByOrdinalDistance(7),
          Note.f.inOctave(4),
        );

        expect(
          Note.f.inOctave(4).respellByOrdinalDistance(2),
          const Note(.a, Accidental(-4)).inOctave(4),
        );
        expect(
          Note.g.inOctave(4).respellByOrdinalDistance(3),
          const Note(.c, Accidental(-5)).inOctave(5),
        );
        expect(
          Note.f.inOctave(4).respellByOrdinalDistance(4),
          const Note(.c, Accidental(5)).inOctave(4),
        );
        expect(
          Note.d.inOctave(4).respellByOrdinalDistance(-3),
          const Note(.a, Accidental(5)).inOctave(3),
        );
      });
    });

    group('.respelledUpwards', () {
      test('returns this Pitch respelled upwards', () {
        expect(
          Note.c.inOctave(4).respelledUpwards,
          Note.d.flat.flat.inOctave(4),
        );
        expect(
          Note.c.sharp.inOctave(4).respelledUpwards,
          Note.d.flat.inOctave(4),
        );
        expect(
          Note.d.flat.inOctave(6).respelledUpwards,
          Note.e.flat.flat.flat.inOctave(6),
        );
        expect(
          Note.c.sharp.sharp.inOctave(8).respelledUpwards,
          Note.d.inOctave(8),
        );
        expect(Note.b.sharp.inOctave(4).respelledUpwards, Note.c.inOctave(5));
      });
    });

    group('.respelledDownwards', () {
      test('returns this Pitch respelled downwards', () {
        expect(Note.c.inOctave(4).respelledDownwards, Note.b.sharp.inOctave(3));
        expect(
          Note.c.sharp.inOctave(3).respelledDownwards,
          Note.b.sharp.sharp.inOctave(2),
        );
        expect(
          Note.d.flat.inOctave(5).respelledDownwards,
          Note.c.sharp.inOctave(5),
        );
        expect(
          Note.d.flat.flat.inOctave(4).respelledDownwards,
          Note.c.inOctave(4),
        );
        expect(Note.c.flat.inOctave(7).respelledDownwards, Note.b.inOctave(6));
      });
    });

    group('.respellByAccidental()', () {
      test('returns this Pitch respelled by Accidental', () {
        expect(
          Note.a.sharp.inOctave(4).respellByAccidental(.flat),
          Note.b.flat.inOctave(4),
        );
        expect(
          Note.g.flat.inOctave(3).respellByAccidental(.sharp),
          Note.f.sharp.inOctave(3),
        );
        expect(
          Note.c.flat.inOctave(2).respellByAccidental(.natural),
          Note.b.inOctave(1),
        );
        expect(
          Note.b.sharp.inOctave(5).respellByAccidental(.natural),
          Note.c.inOctave(6),
        );
        expect(
          Note.f.flat.inOctave(7).respellByAccidental(.natural),
          Note.e.inOctave(7),
        );
        expect(
          Note.e.sharp.inOctave(4).respellByAccidental(.natural),
          Note.f.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).respellByAccidental(.doubleFlat),
          Note.g.flat.flat.inOctave(4),
        );
        expect(
          Note.a.inOctave(3).respellByAccidental(.doubleSharp),
          Note.g.sharp.sharp.inOctave(3),
        );
      });

      test('returns the next closest spelling when no possible respelling', () {
        expect(
          Note.d.flat.inOctave(3).respellByAccidental(.natural),
          Note.d.flat.inOctave(3),
        );
        expect(
          Note.g.sharp.inOctave(2).respellByAccidental(.natural),
          Note.g.sharp.inOctave(2),
        );
        expect(
          Note.e.flat.flat.flat.inOctave(5).respellByAccidental(.natural),
          Note.d.flat.inOctave(5),
        );
        expect(
          Note.e.sharp.sharp.inOctave(-1).respellByAccidental(.natural),
          Note.f.sharp.inOctave(-1),
        );

        expect(
          Note.g.sharp.inOctave(2).respellByAccidental(.natural),
          Note.g.sharp.inOctave(2),
        );
        expect(
          Note.d.inOctave(4).respellByAccidental(.sharp),
          Note.c.sharp.sharp.inOctave(4),
        );
        expect(
          Note.d.inOctave(2).respellByAccidental(.flat),
          Note.e.flat.flat.inOctave(2),
        );
        expect(
          Note.e.inOctave(3).respellByAccidental(.doubleFlat),
          Note.g.flat.flat.flat.inOctave(3),
        );
        expect(
          Note.f.inOctave(-1).respellByAccidental(.doubleSharp),
          Note.d.sharp.sharp.sharp.inOctave(-1),
        );
        expect(
          Note.b.inOctave(0).respellByAccidental(.doubleFlat),
          Note.d.flat.flat.flat.inOctave(1),
        );
        expect(
          Note.c.inOctave(7).respellByAccidental(.doubleSharp),
          Note.a.sharp.sharp.sharp.inOctave(6),
        );
      });
    });

    group('.respelledSimple', () {
      test('returns the simplest spelling for this Pitch', () {
        expect(Note.c.inOctave(4).respelledSimple, Note.c.inOctave(4));
        expect(Note.b.inOctave(5).respelledSimple, Note.b.inOctave(5));
        expect(
          Note.d.flat.inOctave(7).respelledSimple,
          Note.d.flat.inOctave(7),
        );
        expect(
          Note.c.sharp.inOctave(3).respelledSimple,
          Note.c.sharp.inOctave(3),
        );
        expect(Note.e.sharp.inOctave(4).respelledSimple, Note.f.inOctave(4));
        expect(Note.c.flat.inOctave(4).respelledSimple, Note.b.inOctave(3));
        expect(Note.b.sharp.inOctave(2).respelledSimple, Note.c.inOctave(3));
        expect(
          Note.g.sharp.sharp.inOctave(5).respelledSimple,
          Note.a.inOctave(5),
        );
        expect(
          Note.a.flat.flat.flat.inOctave(4).respelledSimple,
          Note.g.flat.inOctave(4),
        );
        expect(
          Note.f.sharp.sharp.sharp.inOctave(4).respelledSimple,
          Note.g.sharp.inOctave(4),
        );
      });
    });

    group('.interval()', () {
      test('returns the Interval between this Pitch and other', () {
        expect(Note.c.inOctave(4).interval(Note.c.inOctave(4)), Interval.P1);
        expect(
          Note.c.inOctave(3).interval(Note.c.sharp.inOctave(3)),
          Interval.A1,
        );
        expect(
          Note.f.flat.inOctave(2).interval(Note.f.inOctave(2)),
          Interval.A1,
        );

        expect(
          Note.c.inOctave(4).interval(Note.b.sharp.inOctave(3)),
          -Interval.d2,
        );
        expect(
          Note.b.sharp.inOctave(3).interval(Note.c.inOctave(4)),
          Interval.d2,
        );
        expect(
          Note.c.inOctave(3).interval(Note.d.flat.flat.inOctave(3)),
          Interval.d2,
        );
        expect(
          Note.f.flat.inOctave(4).interval(Note.g.flat.flat.inOctave(4)),
          Interval.m2,
        );
        expect(Note.c.inOctave(5).interval(Note.b.inOctave(4)), -Interval.m2);
        expect(
          Note.c.inOctave(5).interval(Note.d.flat.inOctave(5)),
          Interval.m2,
        );
        expect(Note.c.inOctave(4).interval(Note.d.inOctave(4)), Interval.M2);
        expect(Note.d.inOctave(4).interval(Note.c.inOctave(4)), -Interval.M2);
        expect(
          Note.c.inOctave(4).interval(Note.d.sharp.inOctave(4)),
          Interval.A2,
        );

        expect(
          Note.c.inOctave(4).interval(Note.e.flat.flat.inOctave(4)),
          Interval.d3,
        );
        expect(
          Note.c.inOctave(4).interval(Note.e.flat.inOctave(4)),
          Interval.m3,
        );
        expect(Note.c.inOctave(4).interval(Note.e.inOctave(4)), Interval.M3);
        expect(Note.g.inOctave(4).interval(Note.b.inOctave(4)), Interval.M3);
        expect(
          Note.b.flat.inOctave(4).interval(Note.d.inOctave(5)),
          Interval.M3,
        );
        expect(
          Note.c.inOctave(4).interval(Note.e.sharp.inOctave(4)),
          Interval.A3,
        );

        expect(
          Note.c.inOctave(4).interval(Note.f.flat.inOctave(4)),
          Interval.d4,
        );
        expect(Note.c.inOctave(4).interval(Note.f.inOctave(4)), Interval.P4);
        expect(
          Note.g.sharp.inOctave(4).interval(Note.c.sharp.inOctave(5)),
          Interval.P4,
        );
        expect(
          Note.a.flat.inOctave(4).interval(Note.d.inOctave(5)),
          Interval.A4,
        );
        expect(
          Note.c.inOctave(4).interval(Note.f.sharp.inOctave(4)),
          Interval.A4,
        );

        expect(
          Note.c.inOctave(4).interval(Note.g.flat.inOctave(4)),
          Interval.d5,
        );
        expect(Note.c.inOctave(4).interval(Note.g.inOctave(4)), Interval.P5);
        expect(
          Note.c.inOctave(4).interval(Note.g.sharp.inOctave(4)),
          Interval.A5,
        );

        expect(
          Note.c.inOctave(4).interval(Note.a.flat.flat.inOctave(4)),
          Interval.d6,
        );
        expect(
          Note.c.inOctave(4).interval(Note.a.flat.inOctave(4)),
          Interval.m6,
        );
        expect(Note.c.inOctave(4).interval(Note.a.inOctave(4)), Interval.M6);
        expect(
          Note.c.inOctave(4).interval(Note.a.sharp.inOctave(4)),
          Interval.A6,
        );

        expect(
          Note.c.inOctave(4).interval(Note.b.flat.flat.inOctave(4)),
          Interval.d7,
        );
        expect(
          Note.c.inOctave(4).interval(Note.b.flat.inOctave(4)),
          Interval.m7,
        );
        expect(Note.c.inOctave(4).interval(Note.b.inOctave(4)), Interval.M7);
        expect(
          Note.b.inOctave(4).interval(Note.a.sharp.inOctave(5)),
          Interval.M7,
        );
        expect(
          Note.c.inOctave(4).interval(Note.b.sharp.inOctave(4)),
          Interval.A7,
        );

        expect(Note.c.inOctave(3).interval(Note.c.inOctave(4)), Interval.P8);
        expect(Note.c.inOctave(5).interval(Note.b.inOctave(3)), -Interval.m9);

        expect(
          Note.c.inOctave(3).interval(Note.c.inOctave(5)),
          const Interval.perfect(Size(15)),
        );

        expect(
          Note.c.inOctave(3).interval(Note.c.inOctave(6)),
          const Interval.perfect(Size(22)),
        );

        expect(
          Note.c.inOctave(2).interval(Note.c.inOctave(6)),
          const Interval.perfect(Size(29)),
        );
      });
    });

    group('.transposeBy()', () {
      test('transposes this Pitch by Interval', () {
        expect(Note.c.inOctave(4).transposeBy(.d1), Note.c.flat.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.d1),
          Note.c.sharp.inOctave(4),
        );
        expect(Note.c.inOctave(3).transposeBy(.P1), Note.c.inOctave(3));
        expect(
          Note.c.inOctave(3).transposeBy(-Interval.P1),
          Note.c.inOctave(3),
        );
        expect(Note.c.inOctave(5).transposeBy(.A1), Note.c.sharp.inOctave(5));
        expect(
          Note.c.inOctave(5).transposeBy(-Interval.A1),
          Note.c.flat.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(.d2),
          Note.d.flat.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.d2),
          Note.b.sharp.inOctave(3),
        );
        expect(
          Note.c.flat.inOctave(4).transposeBy(-Interval.d2),
          Note.b.inOctave(3),
        );
        expect(Note.c.inOctave(6).transposeBy(.m2), Note.d.flat.inOctave(6));
        expect(
          Note.c.inOctave(6).transposeBy(-Interval.m2),
          Note.b.inOctave(5),
        );
        expect(Note.c.inOctave(-1).transposeBy(.M2), Note.d.inOctave(-1));
        expect(
          Note.c.inOctave(-1).transposeBy(-Interval.M2),
          Note.b.flat.inOctave(-2),
        );
        expect(Note.c.inOctave(4).transposeBy(.A2), Note.d.sharp.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A2),
          Note.b.flat.flat.inOctave(3),
        );

        expect(Note.e.inOctave(2).transposeBy(.m3), Note.g.inOctave(2));
        expect(
          Note.e.inOctave(2).transposeBy(-Interval.m3),
          Note.c.sharp.inOctave(2),
        );
        expect(Note.e.inOctave(4).transposeBy(.M3), Note.g.sharp.inOctave(4));
        expect(
          Note.e.inOctave(4).transposeBy(-Interval.M3),
          Note.c.inOctave(4),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(.m3),
          Note.c.flat.inOctave(5),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.m3),
          Note.f.inOctave(4),
        );
        expect(Note.a.flat.inOctave(4).transposeBy(.M3), Note.c.inOctave(5));
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.M3),
          Note.f.flat.inOctave(4),
        );

        expect(
          Note.f.inOctave(4).transposeBy(.d4),
          Note.b.flat.flat.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.d4),
          Note.c.sharp.inOctave(4),
        );
        expect(Note.f.inOctave(3).transposeBy(.P4), Note.b.flat.inOctave(3));
        expect(
          Note.f.inOctave(3).transposeBy(-Interval.P4),
          Note.c.inOctave(3),
        );
        expect(Note.f.inOctave(4).transposeBy(.A4), Note.b.inOctave(4));
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.A4),
          Note.c.flat.inOctave(4),
        );
        expect(Note.a.inOctave(6).transposeBy(.d4), Note.d.flat.inOctave(7));
        expect(
          Note.a.inOctave(6).transposeBy(-Interval.d4),
          Note.e.sharp.inOctave(6),
        );
        expect(Note.a.inOctave(-2).transposeBy(.P4), Note.d.inOctave(-1));
        expect(
          Note.a.inOctave(-2).transposeBy(-Interval.P4),
          Note.e.inOctave(-2),
        );
        expect(Note.a.inOctave(7).transposeBy(.A4), Note.d.sharp.inOctave(8));
        expect(
          Note.a.inOctave(7).transposeBy(-Interval.A4),
          Note.e.flat.inOctave(7),
        );

        expect(Note.d.inOctave(4).transposeBy(.d5), Note.a.flat.inOctave(4));
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.d5),
          Note.g.sharp.inOctave(3),
        );
        expect(Note.d.inOctave(1).transposeBy(.P5), Note.a.inOctave(1));
        expect(
          Note.d.inOctave(1).transposeBy(-Interval.P5),
          Note.g.inOctave(0),
        );
        expect(Note.d.inOctave(2).transposeBy(.A5), Note.a.sharp.inOctave(2));
        expect(
          Note.d.inOctave(2).transposeBy(-Interval.A5),
          Note.g.flat.inOctave(1),
        );

        expect(Note.d.inOctave(4).transposeBy(.m6), Note.b.flat.inOctave(4));
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.m6),
          Note.f.sharp.inOctave(3),
        );
        expect(Note.d.inOctave(-2).transposeBy(.M6), Note.b.inOctave(-2));
        expect(
          Note.d.inOctave(-2).transposeBy(-Interval.M6),
          Note.f.inOctave(-3),
        );
        expect(Note.f.sharp.inOctave(4).transposeBy(.m6), Note.d.inOctave(5));
        expect(
          Note.f.sharp.inOctave(4).transposeBy(-Interval.m6),
          Note.a.sharp.inOctave(3),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(.M6),
          Note.d.sharp.inOctave(0),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(-Interval.M6),
          Note.a.inOctave(-2),
        );

        expect(Note.c.inOctave(0).transposeBy(.m7), Note.b.flat.inOctave(0));
        expect(
          Note.c.inOctave(0).transposeBy(-Interval.m7),
          Note.d.inOctave(-1),
        );
        expect(Note.c.inOctave(4).transposeBy(.M7), Note.b.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.M7),
          Note.d.flat.inOctave(3),
        );
        expect(Note.c.inOctave(4).transposeBy(.A7), Note.b.sharp.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A7),
          Note.d.flat.flat.inOctave(3),
        );

        expect(Note.c.inOctave(4).transposeBy(.d8), Note.c.flat.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.P8), Note.c.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.A8), Note.c.sharp.inOctave(5));

        expect(Note.c.inOctave(4).transposeBy(.m9), Note.d.flat.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.M9), Note.d.inOctave(5));

        expect(Note.c.inOctave(4).transposeBy(.d11), Note.f.flat.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.P11), Note.f.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.A11), Note.f.sharp.inOctave(5));

        expect(Note.c.inOctave(4).transposeBy(.m13), Note.a.flat.inOctave(5));
        expect(Note.c.inOctave(4).transposeBy(.M13), Note.a.inOctave(5));

        expect(
          Note.c.inOctave(4).transposeBy(const .perfect(Size(15))),
          Note.c.inOctave(6),
        );

        expect(
          Note.c.inOctave(4).transposeBy(const .perfect(Size(22))),
          Note.c.inOctave(7),
        );

        expect(
          Note.c.inOctave(4).transposeBy(const .perfect(Size(29))),
          Note.c.inOctave(8),
        );
      });
    });

    group('.toClass()', () {
      test('creates a new PitchClass from semitones', () {
        expect(Note.a.inOctave(4).toClass(), PitchClass.a);
        expect(Note.a.sharp.inOctave(2).toClass(), PitchClass.aSharp);
        expect(Note.e.flat.inOctave(-1).toClass(), PitchClass.dSharp);
        expect(Note.b.sharp.sharp.inOctave(7).toClass(), PitchClass.cSharp);
      });
    });

    group('.isEnharmonicWith()', () {
      test(
        'returns whether this Pitch is enharmonically equivalent to other',
        () {
          expect(
            Note.e.inOctave(4).isEnharmonicWith(Note.e.inOctave(4)),
            isTrue,
          );
          expect(
            Note.a.sharp.inOctave(4).isEnharmonicWith(Note.b.flat.inOctave(4)),
            isTrue,
          );
          expect(
            Note.a.inOctave(2).isEnharmonicWith(Note.b.flat.inOctave(4)),
            isFalse,
          );
          expect(
            Note.e.flat.inOctave(-1).isEnharmonicWith(Note.e.flat.inOctave(3)),
            isFalse,
          );
          expect(
            Note.b.sharp.inOctave(3).isEnharmonicWith(Note.c.inOctave(4)),
            isTrue,
          );
        },
      );
    });

    group('.frequency()', () {
      test('returns the Frequency of this Pitch at 440 Hz', () {
        expect(
          Note.c.inOctave(4).frequency(),
          const Frequency(261.6255653005986),
        );
        expect(
          Note.c.sharp.inOctave(4).frequency(),
          const Frequency(277.1826309768721),
        );
        expect(
          Note.d.flat.inOctave(4).frequency(),
          const Frequency(277.1826309768721),
        );
        expect(
          Note.d.inOctave(4).frequency(),
          const Frequency(293.6647679174076),
        );
        expect(
          Note.d.sharp.inOctave(4).frequency(),
          const Frequency(311.1269837220809),
        );
        expect(
          Note.e.flat.inOctave(4).frequency(),
          const Frequency(311.1269837220809),
        );
        expect(
          Note.e.inOctave(4).frequency(),
          const Frequency(329.6275569128699),
        );
        expect(
          Note.f.inOctave(4).frequency(),
          const Frequency(349.2282314330039),
        );
        expect(
          Note.f.sharp.inOctave(4).frequency(),
          const Frequency(369.9944227116344),
        );
        expect(
          Note.g.flat.inOctave(4).frequency(),
          const Frequency(369.9944227116344),
        );
        expect(
          Note.g.inOctave(4).frequency(),
          const Frequency(391.99543598174927),
        );
        expect(
          Note.g.sharp.inOctave(4).frequency(),
          const Frequency(415.3046975799451),
        );
        expect(
          Note.a.flat.inOctave(4).frequency(),
          const Frequency(415.3046975799451),
        );
        expect(Note.a.inOctave(4).frequency(), const Frequency(440));
        expect(
          Note.a.sharp.inOctave(4).frequency(),
          const Frequency(466.1637615180899),
        );
        expect(
          Note.b.flat.inOctave(4).frequency(),
          const Frequency(466.1637615180899),
        );
        expect(
          Note.b.inOctave(4).frequency(),
          const Frequency(493.8833012561241),
        );

        expect(
          Note.a.inOctave(4).frequency(temperature: const Celsius(18)),
          const Frequency(438.4619866006409),
        );
        expect(
          Note.a.inOctave(4).frequency(temperature: const Celsius(24)),
          const Frequency(443.07602679871826),
        );
        expect(
          Note.c.inOctave(4).frequency(temperature: const Celsius(18)),
          const Frequency(260.71105706185494),
        );
      });

      test('returns the Frequency of this Pitch at 438 Hz', () {
        const tuningSystem = EqualTemperament.edo12(
          fork: TuningFork(.reference, Frequency(438)),
        );
        expect(
          Note.c.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(260.4363581855959),
        );
        expect(
          Note.c.sharp.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(275.92270992697723),
        );
        expect(
          Note.d.flat.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(275.92270992697723),
        );
        expect(
          Note.d.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(292.3299280632375),
        );
        expect(
          Note.d.sharp.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(309.7127701597078),
        );
        expect(
          Note.e.flat.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(309.7127701597078),
        );
        expect(
          Note.e.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(328.1292498359933),
        );
        expect(
          Note.f.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(347.6408303810357),
        );
        expect(
          Note.f.sharp.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(368.31262988112695),
        );
        expect(
          Note.g.flat.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(368.31262988112695),
        );
        expect(
          Note.g.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(390.2136385454686),
        );
        expect(
          Note.g.sharp.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(413.41694895458176),
        );
        expect(
          Note.a.flat.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(413.41694895458176),
        );
        expect(
          Note.a.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(438),
        );
        expect(
          Note.a.sharp.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(464.0448353293713),
        );
        expect(
          Note.b.flat.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(464.0448353293713),
        );
        expect(
          Note.b.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(491.63837715950535),
        );
      });

      test('returns the Frequency of this Pitch from 256 Hz (C4)', () {
        const tuningSystem = EqualTemperament.edo12(fork: .c256);
        expect(
          Note.c.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(256),
        );
        expect(
          Note.a.inOctave(4).frequency(tuningSystem: tuningSystem),
          const Frequency(430.5389646099018),
        );
      });
    });

    group('.harmonics()', () {
      test('returns the ClosestPitch set of harmonic series', () {
        expect(
          Note.c.inOctave(1).harmonics().take(16).toSet().toString(),
          '{C1±0, C2±0, G2+2, C3±0, E3−14, G3+2, A♯3−31, C4±0, D4+4, '
          'E4−14, F♯4−49, G4+2, A♭4+41, A♯4−31, B4−12, C5±0}',
        );

        expect(
          Note.c
              .inOctave(1)
              .harmonics(
                tuningSystem: const EqualTemperament.edo12(
                  fork: TuningFork(.reference, Frequency(438)),
                ),
              )
              .take(16)
              .toSet()
              .toString(),
          '{C1±0, C2±0, G2+2, C3±0, E3−14, G3+2, A♯3−31, C4±0, D4+4, '
          'E4−14, F♯4−49, G4+2, A♭4+41, A♯4−31, B4−12, C5±0}',
        );

        expect(
          Note.c
              .inOctave(1)
              .harmonics(
                tuningSystem: const EqualTemperament.edo12(fork: .c256),
              )
              .take(16)
              .toSet()
              .toString(),
          '{C1±0, C2±0, G2+2, C3±0, E3−14, G3+2, A♯3−31, C4±0, D4+4, '
          'E4−14, F♯4−49, G4+2, A♭4+41, A♯4−31, B4−12, C5±0}',
        );

        expect(
          Note.c
              .inOctave(1)
              .harmonics(temperature: const Celsius(18))
              .take(16)
              .toSet()
              .toString(),
          '{C1+6, C2+6, G2+8, C3+6, E3−8, G3+8, A♯3−25, C4+6, D4+10, '
          'E4−8, F♯4−43, G4+8, A♭4+47, A♯4−25, B4−6, C5+6}',
        );
      });
    });

    group('operator +()', () {
      test('adds Cent to this Pitch', () {
        expect(
          Note.a.inOctave(4) + const Cent(12),
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(12)),
        );
        expect(
          Note.c.sharp.inOctave(3) + const Cent(-12),
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-12)),
        );
      });
    });

    group('operator -()', () {
      test('subtracts Cents from this Pitch', () {
        expect(
          Note.a.inOctave(4) - const Cent(12),
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(-12)),
        );
        expect(
          Note.e.flat.inOctave(5) - const Cent(-12),
          ClosestPitch(Note.e.flat.inOctave(5), cents: const Cent(12)),
        );
      });
    });

    group('operator <()', () {
      test('returns whether this Pitch is lower than other', () {
        expect(Note.a.inOctave(3) < Note.a.inOctave(4), isTrue);
        expect(Note.f.sharp.inOctave(4) < Note.a.inOctave(4), isTrue);
        expect(Note.g.sharp.inOctave(4) < Note.a.flat.inOctave(4), isTrue);

        expect(Note.a.inOctave(4) < Note.a.inOctave(4), isFalse);
        expect(Note.a.flat.inOctave(4) < Note.a.flat.inOctave(3), isFalse);
        expect(Note.a.inOctave(4) < Note.f.inOctave(4), isFalse);
      });
    });

    group('operator <=()', () {
      test('returns whether this Pitch is lower than or equal to other', () {
        expect(Note.a.inOctave(3) <= Note.a.inOctave(4), isTrue);
        expect(Note.f.sharp.inOctave(4) <= Note.a.inOctave(4), isTrue);
        expect(Note.a.inOctave(4) <= Note.a.inOctave(4), isTrue);
        expect(Note.g.sharp.inOctave(4) <= Note.a.flat.inOctave(4), isTrue);

        expect(Note.a.flat.inOctave(4) <= Note.a.flat.inOctave(3), isFalse);
        expect(Note.a.inOctave(4) <= Note.f.inOctave(4), isFalse);
      });
    });

    group('operator >()', () {
      test('returns whether this Pitch is higher than other', () {
        expect(Note.a.inOctave(4) > Note.a.inOctave(3), isTrue);
        expect(Note.a.inOctave(4) > Note.g.flat.inOctave(4), isTrue);
        expect(Note.a.flat.inOctave(4) > Note.g.sharp.inOctave(4), isTrue);

        expect(Note.a.inOctave(4) > Note.a.inOctave(4), isFalse);
        expect(Note.a.flat.inOctave(3) > Note.a.flat.inOctave(4), isFalse);
        expect(Note.f.inOctave(4) > Note.a.inOctave(4), isFalse);
      });
    });

    group('operator >=()', () {
      test('returns whether this Pitch is higher than or equal to other', () {
        expect(Note.a.inOctave(4) >= Note.a.inOctave(3), isTrue);
        expect(Note.a.inOctave(4) >= Note.f.sharp.inOctave(4), isTrue);
        expect(Note.a.inOctave(4) >= Note.a.inOctave(4), isTrue);
        expect(Note.a.flat.inOctave(4) >= Note.g.sharp.inOctave(3), isTrue);

        expect(Note.a.flat.inOctave(3) >= Note.a.flat.inOctave(4), isFalse);
        expect(Note.f.inOctave(4) >= Note.a.inOctave(4), isFalse);
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal Pitches', () {
        expect(Note.c.inOctave(4).hashCode, Note.c.inOctave(4).hashCode);
        // ignore: prefer_const_constructors test
        expect(Pitch(.a, octave: 3).hashCode, Pitch(.a, octave: 3).hashCode);
      });

      test('returns different hashCodes for different Pitches', () {
        expect(Note.c.inOctave(4).hashCode, isNot(Note.c.inOctave(5).hashCode));
        expect(
          const Pitch(.a, octave: 3).hashCode,
          isNot(const Pitch(.b, octave: 3).hashCode),
        );
        expect(Note.d.inOctave(6).hashCode, isNot(Note.c.inOctave(5).hashCode));
      });

      test('ignores equal Pitch instances in a Set', () {
        final collection = {
          Note.c.inOctave(4),
          Note.a.flat.inOctave(2),
          Note.d.inOctave(4),
          Note.g.sharp.inOctave(5),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.c.inOctave(4),
          Note.a.flat.inOctave(2),
          Note.d.inOctave(4),
          Note.g.sharp.inOctave(5),
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts Pitches in a collection', () {
        final orderedSet = SplayTreeSet<Pitch>.of({
          Note.a.flat.inOctave(4),
          Note.b.flat.inOctave(5),
          Note.c.inOctave(4),
          Note.b.inOctave(4),
          Note.d.inOctave(2),
          Note.b.flat.inOctave(4),
          Note.g.sharp.inOctave(4),
          Note.b.sharp.inOctave(4),
        });
        expect(orderedSet.toList(), [
          Note.d.inOctave(2),
          Note.c.inOctave(4),
          Note.g.sharp.inOctave(4),
          Note.a.flat.inOctave(4),
          Note.b.flat.inOctave(4),
          Note.b.inOctave(4),
          Note.b.sharp.inOctave(4),
          Note.b.flat.inOctave(5),
        ]);
      });
    });
  });

  group('ScientificPitchNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Pitch.parse('x'), throwsFormatException);
        expect(() => Pitch.parse('aa'), throwsFormatException);
        expect(() => Pitch.parse('D5,'), throwsFormatException);
        expect(() => Pitch.parse('ba'), throwsFormatException);
        expect(() => Pitch.parse("d7'"), throwsFormatException);
        expect(() => Pitch.parse("e'4"), throwsFormatException);
        expect(() => Pitch.parse("'Eb3"), throwsFormatException);
        expect(() => Pitch.parse('2a'), throwsFormatException);
        expect(() => Pitch.parse('3B,'), throwsFormatException);
      });

      test('parses source as a Pitch', () {
        expect(Pitch.parse('A4'), Note.a.inOctave(4));
        expect(Pitch.parse('d3'), Note.d.inOctave(3));
        expect(Pitch.parse('C-1'), Note.c.inOctave(-1));
        expect(Pitch.parse('bb-1'), Note.b.flat.inOctave(-1));
        expect(Pitch.parse('G#6'), Note.g.sharp.inOctave(6));
        expect(Pitch.parse('Bx12'), Note.b.sharp.sharp.inOctave(12));
        expect(Pitch.parse('G♯−1'), Note.g.sharp.inOctave(-1));

        final pitch = Note.b.flat.flat.inOctave(-2);
        expect(Pitch.parse(pitch.toString()), pitch);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Pitch', () {
        expect(Note.g.sharp.inOctave(-1).toString(), 'G♯−1');
        expect(Note.d.inOctave(0).toString(), 'D0');
        expect(Note.b.flat.inOctave(1).toString(), 'B♭1');
        expect(Note.g.inOctave(2).toString(), 'G2');
        expect(Note.a.inOctave(3).toString(), 'A3');
        expect(Note.c.inOctave(4).toString(), 'C4');
        expect(Note.c.sharp.inOctave(4).toString(), 'C♯4');
        expect(Note.a.inOctave(4).toString(), 'A4');
        expect(Note.f.sharp.inOctave(5).toString(), 'F♯5');
        expect(Note.e.inOctave(7).toString(), 'E7');
      });

      test('returns the ASCII scientific string representation', () {
        const formatter = ScientificPitchNotation.ascii();
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: formatter),
          'G#-1',
        );
        expect(Note.d.inOctave(0).toString(formatter: formatter), 'D0');
        expect(Note.b.flat.inOctave(1).toString(formatter: formatter), 'Bb1');
        expect(
          Note.c.sharp.inOctave(4).toString(formatter: formatter),
          'C#4',
        );
        expect(
          Note.f.sharp.inOctave(5).toString(formatter: formatter),
          'F#5',
        );
      });
    });
  });

  group('HelmholtzPitchNotation', () {
    const english = HelmholtzPitchNotation.english;
    const german = HelmholtzPitchNotation.german;
    const romance = HelmholtzPitchNotation.romance;
    const ascii = HelmholtzPitchNotation.ascii();
    const numbered = HelmholtzPitchNotation.numbered();
    const chain = [english, german, romance, ascii, numbered];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Pitch.parse('x', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('aa', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('re,', chain: chain), throwsFormatException);
        expect(() => Pitch.parse("A,'", chain: chain), throwsFormatException);
        expect(() => Pitch.parse("A'", chain: chain), throwsFormatException);
        expect(
          () => Pitch.parse("Sol'", chain: chain),
          throwsFormatException,
        );
        expect(() => Pitch.parse('bb,', chain: chain), throwsFormatException);
        expect(() => Pitch.parse("F#'", chain: chain), throwsFormatException);
        expect(
          () => Pitch.parse("g''h", chain: chain),
          throwsFormatException,
        );
        expect(() => Pitch.parse('C,d', chain: chain), throwsFormatException);
        expect(() => Pitch.parse("d′'", chain: chain), throwsFormatException);
        expect(() => Pitch.parse('f″″', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('e-2', chain: chain), throwsFormatException);
        expect(
          () => Pitch.parse('Dis-2', chain: chain),
          throwsFormatException,
        );
        expect(() => Pitch.parse('2H', chain: chain), throwsFormatException);
        expect(
          () => Pitch.parse('2fis', chain: chain),
          throwsFormatException,
        );
        expect(
          () => Pitch.parse('-2ais', chain: chain),
          throwsFormatException,
        );
        expect(
          () => Pitch.parse('-1Ges', chain: chain),
          throwsFormatException,
        );
        expect(() => Pitch.parse('0A', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('0b', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('F0', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('g0', chain: chain), throwsFormatException);
        expect(() => Pitch.parse('h00', chain: chain), throwsFormatException);
        expect(() => Pitch.parse("g1'", chain: chain), throwsFormatException);
        expect(
          () => Pitch.parse("ais'1", chain: chain),
          throwsFormatException,
        );
      });

      test('parses source as a Pitch', () {
        expect(Pitch.parse('Do͵͵͵', chain: chain), Note.c.inOctave(-1));
        expect(Pitch.parse('C͵͵͵', chain: chain), Note.c.inOctave(-1));
        expect(Pitch.parse('Cis,,', chain: chain), Note.c.sharp.inOctave(0));
        expect(Pitch.parse('C,,', chain: chain), Note.c.inOctave(0));
        expect(Pitch.parse('Gb,', chain: chain), Note.g.flat.inOctave(1));
        expect(Pitch.parse('A', chain: chain), Note.a.inOctave(2));
        expect(Pitch.parse('As', chain: chain), Note.a.flat.inOctave(2));
        expect(Pitch.parse('Ais', chain: chain), Note.a.sharp.inOctave(2));
        expect(Pitch.parse('H', chain: chain), Note.b.inOctave(2));
        expect(Pitch.parse('Si', chain: chain), Note.b.inOctave(2));
        expect(Pitch.parse('h', chain: chain), Note.b.inOctave(3));
        expect(Pitch.parse('his', chain: chain), Note.b.sharp.inOctave(3));
        expect(Pitch.parse('sol', chain: chain), Note.g.inOctave(3));
        expect(Pitch.parse('f', chain: chain), Note.f.inOctave(3));
        expect(Pitch.parse('fis', chain: chain), Note.f.sharp.inOctave(3));
        expect(Pitch.parse("d#'", chain: chain), Note.d.sharp.inOctave(4));
        expect(Pitch.parse("fa#'", chain: chain), Note.f.sharp.inOctave(4));
        expect(Pitch.parse("es''", chain: chain), Note.e.flat.inOctave(5));
        expect(
          Pitch.parse("ebb''", chain: chain),
          Note.e.flat.flat.inOctave(5),
        );
        expect(Pitch.parse('b#′′', chain: chain), Note.b.sharp.inOctave(5));
        expect(
          Pitch.parse('gx‴', chain: chain),
          Note.g.sharp.sharp.inOctave(6),
        );
        expect(
          Pitch.parse('gisis‴', chain: chain),
          Note.g.sharp.sharp.inOctave(6),
        );
        const chain2 = [numbered];
        expect(
          Pitch.parse('Ais10', chain: chain2),
          Note.a.sharp.inOctave(-8),
        );
        expect(Pitch.parse('Gis3', chain: chain2), Note.g.sharp.inOctave(-1));
        expect(Pitch.parse('Des2', chain: chain2), Note.d.flat.inOctave(0));
        expect(Pitch.parse('B1', chain: chain2), Note.b.flat.inOctave(1));
        expect(Pitch.parse('H', chain: chain2), Note.b.inOctave(2));
        expect(Pitch.parse('a', chain: chain2), Note.a.inOctave(3));
        expect(Pitch.parse('c1', chain: chain2), Note.c.inOctave(4));
        expect(Pitch.parse('cis1', chain: chain2), Note.c.sharp.inOctave(4));
        expect(Pitch.parse('a1', chain: chain2), Note.a.inOctave(4));
        expect(Pitch.parse('as2', chain: chain2), Note.a.flat.inOctave(5));
        expect(Pitch.parse('e3', chain: chain2), Note.e.inOctave(6));
        expect(
          Pitch.parse('fis10', chain: chain2),
          Note.f.sharp.inOctave(13),
        );

        final pitch = Note.a.sharp.inOctave(7);
        expect(Pitch.parse(pitch.toString(formatter: english)), pitch);
      });
    });

    group('.toString()', () {
      test('returns the English Helmholtz string representation', () {
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: english),
          'G♯͵͵͵',
        );
        expect(Note.d.inOctave(0).toString(formatter: english), 'D͵͵');
        expect(Note.b.flat.inOctave(1).toString(formatter: english), 'B♭͵');
        expect(Note.g.inOctave(2).toString(formatter: english), 'G');
        expect(Note.a.inOctave(3).toString(formatter: english), 'a');
        expect(Note.c.inOctave(4).toString(formatter: english), 'c′');
        expect(Note.c.sharp.inOctave(4).toString(formatter: english), 'c♯′');
        expect(Note.a.inOctave(4).toString(formatter: english), 'a′');
        expect(Note.f.sharp.inOctave(5).toString(formatter: english), 'f♯″');
        expect(Note.e.inOctave(7).toString(formatter: english), 'e⁗');
        expect(
          Note.b.flat.inOctave(8).toString(formatter: english),
          'b♭′′′′′',
        );
      });

      test('returns the German Helmholtz string representation', () {
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: german),
          'Gis͵͵͵',
        );
        expect(Note.d.flat.inOctave(0).toString(formatter: german), 'Des͵͵');
        expect(Note.b.flat.inOctave(1).toString(formatter: german), 'B͵');
        expect(Note.g.inOctave(2).toString(formatter: german), 'G');
        expect(Note.a.inOctave(3).toString(formatter: german), 'a');
        expect(Note.c.inOctave(4).toString(formatter: german), 'c′');
        expect(Note.c.sharp.inOctave(4).toString(formatter: german), 'cis′');
        expect(Note.a.inOctave(4).toString(formatter: german), 'a′');
        expect(Note.a.flat.inOctave(5).toString(formatter: german), 'as″');
        expect(Note.e.inOctave(7).toString(formatter: german), 'e⁗');
      });

      test('returns the Romance Helmholtz string representation', () {
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: romance),
          'Sol♯͵͵͵',
        );
        expect(Note.d.flat.inOctave(0).toString(formatter: romance), 'Re♭͵͵');
        expect(Note.b.flat.inOctave(1).toString(formatter: romance), 'Si♭͵');
        expect(Note.g.inOctave(2).toString(formatter: romance), 'Sol');
        expect(Note.a.inOctave(3).toString(formatter: romance), 'la');
        expect(Note.c.inOctave(4).toString(formatter: romance), 'do′');
        expect(Note.c.sharp.inOctave(4).toString(formatter: romance), 'do♯′');
        expect(Note.a.inOctave(4).toString(formatter: romance), 'la′');
        expect(Note.a.flat.inOctave(5).toString(formatter: romance), 'la♭″');
        expect(Note.e.inOctave(6).toString(formatter: romance), 'mi‴');
      });

      test('returns the ASCII Helmholtz string representation', () {
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: ascii),
          'G#,,,',
        );
        expect(Note.a.flat.inOctave(1).toString(formatter: ascii), 'Ab,');
        expect(Note.g.inOctave(2).toString(formatter: ascii), 'G');
        expect(Note.c.inOctave(4).toString(formatter: ascii), "c'");
        expect(Note.f.sharp.inOctave(5).toString(formatter: ascii), "f#''");
        expect(Note.e.inOctave(7).toString(formatter: ascii), "e''''");
        expect(
          Note.b.flat.inOctave(8).toString(formatter: ascii),
          "bb'''''",
        );

        const romance = HelmholtzPitchNotation.ascii(
          noteNotation: RomanceNoteNotation.ascii(),
        );

        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: romance),
          'Sol#,,,',
        );
        expect(Note.a.flat.inOctave(1).toString(formatter: romance), 'Lab,');
        expect(Note.g.inOctave(2).toString(formatter: romance), 'Sol');
        expect(Note.c.inOctave(4).toString(formatter: romance), "do'");
        expect(
          Note.f.sharp.inOctave(5).toString(formatter: romance),
          "fa#''",
        );
        expect(Note.e.inOctave(7).toString(formatter: romance), "mi''''");
        expect(
          Note.b.flat.inOctave(8).toString(formatter: romance),
          "sib'''''",
        );
      });

      test('returns the numbered German Helmholtz string representation', () {
        expect(
          Note.a.sharp.inOctave(-8).toString(formatter: numbered),
          'Ais10',
        );
        expect(
          Note.g.sharp.inOctave(-1).toString(formatter: numbered),
          'Gis3',
        );
        expect(Note.d.flat.inOctave(0).toString(formatter: numbered), 'Des2');
        expect(Note.b.flat.inOctave(1).toString(formatter: numbered), 'B1');
        expect(Note.b.inOctave(2).toString(formatter: numbered), 'H');
        expect(Note.a.inOctave(3).toString(formatter: numbered), 'a');
        expect(Note.c.inOctave(4).toString(formatter: numbered), 'c1');
        expect(
          Note.c.sharp.inOctave(4).toString(formatter: numbered),
          'cis1',
        );
        expect(Note.a.inOctave(4).toString(formatter: numbered), 'a1');
        expect(Note.a.flat.inOctave(5).toString(formatter: numbered), 'as2');
        expect(Note.e.inOctave(6).toString(formatter: numbered), 'e3');
        expect(
          Note.f.sharp.inOctave(13).toString(formatter: numbered),
          'fis10',
        );
      });
    });
  });

  group('MusicXmlPitchNotation', () {
    const formatter = StringXmlNotationSystem(MusicXmlPitchNotation());
    const chain = [formatter];

    group('.parse()', () {
      test('throws ArgumentError when source is invalid', () {
        expect(() => Pitch.parse('', chain: chain), throwsArgumentError);
        expect(
          () => Pitch.parse('x', chain: chain),
          throwsA(isA<XmlParserException>()),
        );
        expect(
          () => Pitch.parse('<note></note>', chain: chain),
          throwsArgumentError,
        );
        expect(
          () => Pitch.parse('<pitch></pitch>', chain: chain),
          throwsArgumentError,
        );
        expect(
          () => Pitch.parse('''
              <pitch>
                <step>C</step>
              </pitch>
            ''', chain: chain),
          throwsArgumentError,
        );
        expect(
          () => Pitch.parse('''
              <pitch>
                <octave>4</octave>
              </pitch>
            ''', chain: chain),
          throwsArgumentError,
        );
      });

      test('parses source as a Pitch', () {
        expect(
          Pitch.parse(
            '<pitch><step>C</step><alter>-1</alter><octave>4</octave></pitch>',
            chain: chain,
          ),
          Note.c.flat.inOctave(4),
        );
        expect(
          Pitch.parse('''
              <pitch>
                <step>D</step>
                <octave>3</octave>
              </pitch>
            ''', chain: chain),
          Note.d.inOctave(3),
        );
        expect(
          Pitch.parse('''
              <pitch>
                <step> F</step>
                <alter>  1</alter>
                <octave>5 </octave>
              </pitch>
            ''', chain: chain),
          Note.f.sharp.inOctave(5),
        );
      });
    });

    group('.format()', () {
      test('returns the MusicXML string representation of this Pitch', () {
        expect(
          Note.c.flat.inOctave(4).toString(formatter: formatter),
          '''
<pitch>
  <step>C</step>
  <alter>-1</alter>
  <octave>4</octave>
</pitch>''',
        );
        expect(
          Note.d.inOctave(3).toString(formatter: formatter),
          '''
<pitch>
  <step>D</step>
  <alter>0</alter>
  <octave>3</octave>
</pitch>''',
        );
        expect(
          Note.f.sharp.inOctave(5).toString(formatter: formatter),
          '''
<pitch>
  <step>F</step>
  <alter>1</alter>
  <octave>5</octave>
</pitch>''',
        );
      });
    });
  });
}
