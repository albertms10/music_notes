import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Pitch', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Pitch.parse('x'), throwsFormatException);
        expect(() => Pitch.parse("A,'"), throwsFormatException);
        expect(() => Pitch.parse('bb,'), throwsFormatException);
        expect(() => Pitch.parse("F#'"), throwsFormatException);
        expect(() => Pitch.parse("g''h"), throwsFormatException);
        expect(() => Pitch.parse('C,d'), throwsFormatException);

        expect(() => Pitch.parse('D5,'), throwsFormatException);
        expect(() => Pitch.parse("d7'"), throwsFormatException);
        expect(() => Pitch.parse("e'4"), throwsFormatException);
        expect(() => Pitch.parse("'E3"), throwsFormatException);
        expect(() => Pitch.parse('2a'), throwsFormatException);
        expect(() => Pitch.parse('3B,'), throwsFormatException);
      });

      test('parses source as a Pitch and return its value', () {
        expect(Pitch.parse('A4'), Note.a.inOctave(4));
        expect(Pitch.parse('d3'), Note.d.inOctave(3));
        expect(Pitch.parse('C-1'), Note.c.inOctave(-1));
        expect(Pitch.parse('bb-1'), Note.b.flat.inOctave(-1));
        expect(Pitch.parse('G#6'), Note.g.sharp.inOctave(6));
        expect(Pitch.parse('Bx12'), Note.b.sharp.sharp.inOctave(12));

        expect(Pitch.parse('C͵͵͵'), Note.c.inOctave(-1));
        expect(Pitch.parse('C,,'), Note.c.inOctave(0));
        expect(Pitch.parse('Gb,'), Note.g.flat.inOctave(1));
        expect(Pitch.parse('A'), Note.a.inOctave(2));
        expect(Pitch.parse('f'), Note.f.inOctave(3));
        expect(Pitch.parse("d#'"), Note.d.sharp.inOctave(4));
        expect(Pitch.parse("ebb''"), Note.e.flat.flat.inOctave(5));
        expect(Pitch.parse('gx′′′'), Note.g.sharp.sharp.inOctave(6));

        var pitch = Note.b.flat.flat.inOctave(-2);
        expect(Pitch.parse(pitch.toString()), pitch);

        pitch = Note.a.sharp.inOctave(7);
        expect(
          Pitch.parse(pitch.toString(system: PitchNotation.helmholtz)),
          pitch,
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
        expect(
          Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)),
          7,
        );
        expect(
          Note.d.sharp.inOctave(4).difference(Note.a.sharp.inOctave(4)),
          7,
        );
        expect(Note.d.inOctave(4).difference(Note.a.sharp.inOctave(4)), 8);
        expect(
          Note.c.sharp.inOctave(4).difference(Note.b.flat.inOctave(4)),
          9,
        );
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
          Chord([
            Note.c.inOctave(4),
            Note.e.inOctave(4),
            Note.g.inOctave(4),
          ]),
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
          Chord([
            Note.a.inOctave(3),
            Note.c.inOctave(4),
            Note.e.inOctave(4),
          ]),
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
          Chord([
            Note.b.inOctave(5),
            Note.d.inOctave(6),
            Note.f.inOctave(6),
          ]),
        );
      });
    });

    group('.respellByBaseNote()', () {
      test('returns this Pitch respelled by BaseNote', () {
        expect(
          Note.c.sharp.inOctave(4).respellByBaseNote(BaseNote.d),
          Note.d.flat.inOctave(4),
        );
        expect(
          Note.e.flat.inOctave(3).respellByBaseNote(BaseNote.d),
          Note.d.sharp.inOctave(3),
        );
        expect(
          Note.e.sharp.inOctave(6).respellByBaseNote(BaseNote.f),
          Note.f.inOctave(6),
        );
        expect(
          Note.f.flat.inOctave(4).respellByBaseNote(BaseNote.e),
          Note.e.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).respellByBaseNote(BaseNote.b),
          Note.b.sharp.inOctave(3),
        );
        expect(
          Note.c.inOctave(5).respellByBaseNote(BaseNote.d),
          Note.d.flat.flat.inOctave(5),
        );
        expect(
          Note.b.inOctave(4).respellByBaseNote(BaseNote.c),
          Note.c.flat.inOctave(5),
        );
        expect(
          Note.b.inOctave(4).respellByBaseNote(BaseNote.a),
          Note.a.sharp.sharp.inOctave(4),
        );
      });
    });

    group('.respellByBaseNoteDistance()', () {
      test('returns this Pitch respelled by BaseNote', () {
        expect(
          Note.c.sharp.inOctave(4).respellByBaseNoteDistance(1),
          Note.d.flat.inOctave(4),
        );
        expect(
          Note.c.sharp.inOctave(4).respellByBaseNoteDistance(-1),
          Note.b.sharp.sharp.inOctave(3),
        );
        expect(
          Note.d.flat.inOctave(4).respellByBaseNoteDistance(-1),
          Note.c.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).respellByBaseNoteDistance(1),
          Note.d.flat.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(3).respellByBaseNoteDistance(-1),
          Note.b.sharp.inOctave(2),
        );
        expect(
          Note.c.flat.inOctave(4).respellByBaseNoteDistance(-1),
          Note.b.inOctave(3),
        );
        expect(
          Note.d.inOctave(4).respellByBaseNoteDistance(-1),
          Note.c.sharp.sharp.inOctave(4),
        );
        expect(
          Note.g.flat.inOctave(4).respellByBaseNoteDistance(-1),
          Note.f.sharp.inOctave(4),
        );
        expect(
          Note.e.sharp.inOctave(4).respellByBaseNoteDistance(2),
          Note.g.flat.flat.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).respellByBaseNoteDistance(7),
          Note.f.inOctave(4),
        );

        expect(
          Note.f.inOctave(4).respellByBaseNoteDistance(2),
          const Note(BaseNote.a, Accidental(-4)).inOctave(4),
        );
        expect(
          Note.g.inOctave(4).respellByBaseNoteDistance(3),
          const Note(BaseNote.c, Accidental(-5)).inOctave(5),
        );
        expect(
          Note.f.inOctave(4).respellByBaseNoteDistance(4),
          const Note(BaseNote.c, Accidental(5)).inOctave(4),
        );
        expect(
          Note.d.inOctave(4).respellByBaseNoteDistance(-3),
          const Note(BaseNote.a, Accidental(5)).inOctave(3),
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

    group('.respellByBaseAccidental()', () {
      test('returns this Pitch respelled by Accidental', () {
        expect(
          Note.a.sharp.inOctave(4).respellByAccidental(Accidental.flat),
          Note.b.flat.inOctave(4),
        );
        expect(
          Note.g.flat.inOctave(3).respellByAccidental(Accidental.sharp),
          Note.f.sharp.inOctave(3),
        );
        expect(
          Note.c.flat.inOctave(2).respellByAccidental(Accidental.natural),
          Note.b.inOctave(1),
        );
        expect(
          Note.b.sharp.inOctave(5).respellByAccidental(Accidental.natural),
          Note.c.inOctave(6),
        );
        expect(
          Note.f.flat.inOctave(7).respellByAccidental(Accidental.natural),
          Note.e.inOctave(7),
        );
        expect(
          Note.e.sharp.inOctave(4).respellByAccidental(Accidental.natural),
          Note.f.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).respellByAccidental(Accidental.doubleFlat),
          Note.g.flat.flat.inOctave(4),
        );
        expect(
          Note.a.inOctave(3).respellByAccidental(Accidental.doubleSharp),
          Note.g.sharp.sharp.inOctave(3),
        );
      });

      test('returns null when no respelling is possible', () {
        expect(
          Note.d.inOctave(4).respellByAccidental(Accidental.sharp),
          isNull,
        );
        expect(Note.d.inOctave(2).respellByAccidental(Accidental.flat), isNull);
        expect(
          Note.e.inOctave(3).respellByAccidental(Accidental.doubleFlat),
          isNull,
        );
        expect(
          Note.f.inOctave(-1).respellByAccidental(Accidental.doubleSharp),
          isNull,
        );
        expect(
          Note.b.inOctave(0).respellByAccidental(Accidental.doubleFlat),
          isNull,
        );
        expect(
          Note.c.inOctave(7).respellByAccidental(Accidental.doubleSharp),
          isNull,
        );
      });
    });

    group('.respelledSimple', () {
      test('returns this Pitch with the simplest Accidental spelling', () {
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

        expect(
          skip: true,
          () => Note.c.inOctave(4).interval(Note.b.sharp.inOctave(3)),
          const Interval.perfect(Size(29)),
        );
      });
    });

    group('.transposeBy()', () {
      test('transposes this Pitch by Interval', () {
        expect(
          Note.c.inOctave(4).transposeBy(Interval.d1),
          Note.c.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.d1),
          Note.c.sharp.inOctave(4),
        );
        expect(Note.c.inOctave(3).transposeBy(Interval.P1), Note.c.inOctave(3));
        expect(
          Note.c.inOctave(3).transposeBy(-Interval.P1),
          Note.c.inOctave(3),
        );
        expect(
          Note.c.inOctave(5).transposeBy(Interval.A1),
          Note.c.sharp.inOctave(5),
        );
        expect(
          Note.c.inOctave(5).transposeBy(-Interval.A1),
          Note.c.flat.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d2),
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
        expect(
          Note.c.inOctave(6).transposeBy(Interval.m2),
          Note.d.flat.inOctave(6),
        );
        expect(
          Note.c.inOctave(6).transposeBy(-Interval.m2),
          Note.b.inOctave(5),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(Interval.M2),
          Note.d.inOctave(-1),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(-Interval.M2),
          Note.b.flat.inOctave(-2),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A2),
          Note.d.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A2),
          Note.b.flat.flat.inOctave(3),
        );

        expect(Note.e.inOctave(2).transposeBy(Interval.m3), Note.g.inOctave(2));
        expect(
          Note.e.inOctave(2).transposeBy(-Interval.m3),
          Note.c.sharp.inOctave(2),
        );
        expect(
          Note.e.inOctave(4).transposeBy(Interval.M3),
          Note.g.sharp.inOctave(4),
        );
        expect(
          Note.e.inOctave(4).transposeBy(-Interval.M3),
          Note.c.inOctave(4),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(Interval.m3),
          Note.c.flat.inOctave(5),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.m3),
          Note.f.inOctave(4),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(Interval.M3),
          Note.c.inOctave(5),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.M3),
          Note.f.flat.inOctave(4),
        );

        expect(
          Note.f.inOctave(4).transposeBy(Interval.d4),
          Note.b.flat.flat.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.d4),
          Note.c.sharp.inOctave(4),
        );
        expect(
          Note.f.inOctave(3).transposeBy(Interval.P4),
          Note.b.flat.inOctave(3),
        );
        expect(
          Note.f.inOctave(3).transposeBy(-Interval.P4),
          Note.c.inOctave(3),
        );
        expect(Note.f.inOctave(4).transposeBy(Interval.A4), Note.b.inOctave(4));
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.A4),
          Note.c.flat.inOctave(4),
        );
        expect(
          Note.a.inOctave(6).transposeBy(Interval.d4),
          Note.d.flat.inOctave(7),
        );
        expect(
          Note.a.inOctave(6).transposeBy(-Interval.d4),
          Note.e.sharp.inOctave(6),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(Interval.P4),
          Note.d.inOctave(-1),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(-Interval.P4),
          Note.e.inOctave(-2),
        );
        expect(
          Note.a.inOctave(7).transposeBy(Interval.A4),
          Note.d.sharp.inOctave(8),
        );
        expect(
          Note.a.inOctave(7).transposeBy(-Interval.A4),
          Note.e.flat.inOctave(7),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.d5),
          Note.a.flat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.d5),
          Note.g.sharp.inOctave(3),
        );
        expect(Note.d.inOctave(1).transposeBy(Interval.P5), Note.a.inOctave(1));
        expect(
          Note.d.inOctave(1).transposeBy(-Interval.P5),
          Note.g.inOctave(0),
        );
        expect(
          Note.d.inOctave(2).transposeBy(Interval.A5),
          Note.a.sharp.inOctave(2),
        );
        expect(
          Note.d.inOctave(2).transposeBy(-Interval.A5),
          Note.g.flat.inOctave(1),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.m6),
          Note.b.flat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.m6),
          Note.f.sharp.inOctave(3),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(Interval.M6),
          Note.b.inOctave(-2),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(-Interval.M6),
          Note.f.inOctave(-3),
        );
        expect(
          Note.f.sharp.inOctave(4).transposeBy(Interval.m6),
          Note.d.inOctave(5),
        );
        expect(
          Note.f.sharp.inOctave(4).transposeBy(-Interval.m6),
          Note.a.sharp.inOctave(3),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(Interval.M6),
          Note.d.sharp.inOctave(0),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(-Interval.M6),
          Note.a.inOctave(-2),
        );

        expect(
          Note.c.inOctave(0).transposeBy(Interval.m7),
          Note.b.flat.inOctave(0),
        );
        expect(
          Note.c.inOctave(0).transposeBy(-Interval.m7),
          Note.d.inOctave(-1),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.M7), Note.b.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.M7),
          Note.d.flat.inOctave(3),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A7),
          Note.b.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A7),
          Note.d.flat.flat.inOctave(3),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d8),
          Note.c.flat.inOctave(5),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.P8), Note.c.inOctave(5));
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A8),
          Note.c.sharp.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.m9),
          Note.d.flat.inOctave(5),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.M9), Note.d.inOctave(5));

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d11),
          Note.f.flat.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.P11),
          Note.f.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A11),
          Note.f.sharp.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.m13),
          Note.a.flat.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.M13),
          Note.a.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(const Interval.perfect(Size(15))),
          Note.c.inOctave(6),
        );

        expect(
          Note.c.inOctave(4).transposeBy(const Interval.perfect(Size(22))),
          Note.c.inOctave(7),
        );

        expect(
          Note.c.inOctave(4).transposeBy(const Interval.perfect(Size(29))),
          Note.c.inOctave(8),
        );
      });
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
      });

      test('returns the Frequency of this Pitch at 438 Hz', () {
        const frequency = Frequency(438);
        expect(
          Note.c.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(260.4363581855959),
        );
        expect(
          Note.c.sharp.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(275.92270992697723),
        );
        expect(
          Note.d.flat.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(275.92270992697723),
        );
        expect(
          Note.d.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(292.3299280632375),
        );
        expect(
          Note.d.sharp.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(309.7127701597078),
        );
        expect(
          Note.e.flat.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(309.7127701597078),
        );
        expect(
          Note.e.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(328.1292498359933),
        );
        expect(
          Note.f.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(347.6408303810357),
        );
        expect(
          Note.f.sharp.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(368.31262988112695),
        );
        expect(
          Note.g.flat.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(368.31262988112695),
        );
        expect(
          Note.g.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(390.2136385454686),
        );
        expect(
          Note.g.sharp.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(413.41694895458176),
        );
        expect(
          Note.a.flat.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(413.41694895458176),
        );
        expect(
          Note.a.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(438),
        );
        expect(
          Note.a.sharp.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(464.0448353293713),
        );
        expect(
          Note.b.flat.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(464.0448353293713),
        );
        expect(
          Note.b.inOctave(4).frequency(referenceFrequency: frequency),
          const Frequency(491.63837715950535),
        );
      });

      test('returns the Frequency of this Pitch from 256 Hz (C4)', () {
        const frequency = Frequency(256);
        expect(
          Note.c.inOctave(4).frequency(
                referenceFrequency: frequency,
                tuningSystem: EqualTemperament.edo12(
                  referencePitch: Note.c.inOctave(4),
                ),
              ),
          const Frequency(256),
        );
        expect(
          Note.a.inOctave(4).frequency(
                referenceFrequency: frequency,
                tuningSystem: EqualTemperament.edo12(
                  referencePitch: Note.c.inOctave(4),
                ),
              ),
          const Frequency(430.5389646099018),
        );
      });
    });

    group('.harmonics()', () {
      test('returns the ClosestPitch set of harmonic series', () {
        expect(
          Note.c.inOctave(1).harmonics(upToIndex: 15).toString(),
          '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, D4+4, '
          'E4-14, F♯4-49, G4+2, A♭4+41, A♯4-31, B4-12, C5}',
        );
      });
    });

    group('.toString()', () {
      test('returns the scientific string representation of this Pitch', () {
        expect(Note.g.sharp.inOctave(-1).toString(), 'G♯-1');
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

      test('returns the English Helmholtz string representation', () {
        expect(
          Note.g.sharp.inOctave(-1).toString(system: PitchNotation.helmholtz),
          'G♯͵͵͵',
        );
        expect(
          Note.d.inOctave(0).toString(system: PitchNotation.helmholtz),
          'D͵͵',
        );
        expect(
          Note.b.flat.inOctave(1).toString(system: PitchNotation.helmholtz),
          'B♭͵',
        );
        expect(
          Note.g.inOctave(2).toString(system: PitchNotation.helmholtz),
          'G',
        );
        expect(
          Note.a.inOctave(3).toString(system: PitchNotation.helmholtz),
          'a',
        );
        expect(
          Note.c.inOctave(4).toString(system: PitchNotation.helmholtz),
          'c′',
        );
        expect(
          Note.c.sharp.inOctave(4).toString(system: PitchNotation.helmholtz),
          'c♯′',
        );
        expect(
          Note.a.inOctave(4).toString(system: PitchNotation.helmholtz),
          'a′',
        );
        expect(
          Note.f.sharp.inOctave(5).toString(system: PitchNotation.helmholtz),
          'f♯′′',
        );
        expect(
          Note.e.inOctave(7).toString(system: PitchNotation.helmholtz),
          'e′′′′',
        );
      });

      test('returns the German Helmholtz string representation', () {
        expect(
          Note.g.sharp
              .inOctave(-1)
              .toString(system: HelmholtzPitchNotation.german),
          'Gis͵͵͵',
        );
        expect(
          Note.d.flat
              .inOctave(0)
              .toString(system: HelmholtzPitchNotation.german),
          'Des͵͵',
        );
        expect(
          Note.b.flat
              .inOctave(1)
              .toString(system: HelmholtzPitchNotation.german),
          'B͵',
        );
        expect(
          Note.g.inOctave(2).toString(system: HelmholtzPitchNotation.german),
          'G',
        );
        expect(
          Note.a.inOctave(3).toString(system: HelmholtzPitchNotation.german),
          'a',
        );
        expect(
          Note.c.inOctave(4).toString(system: HelmholtzPitchNotation.german),
          'c′',
        );
        expect(
          Note.c.sharp
              .inOctave(4)
              .toString(system: HelmholtzPitchNotation.german),
          'cis′',
        );
        expect(
          Note.a.inOctave(4).toString(system: HelmholtzPitchNotation.german),
          'a′',
        );
        expect(
          Note.a.flat
              .inOctave(5)
              .toString(system: HelmholtzPitchNotation.german),
          'as′′',
        );
        expect(
          Note.e.inOctave(7).toString(system: HelmholtzPitchNotation.german),
          'e′′′′',
        );
      });

      test('returns the Romance Helmholtz string representation', () {
        expect(
          Note.g.sharp
              .inOctave(-1)
              .toString(system: HelmholtzPitchNotation.romance),
          'Sol♯͵͵͵',
        );
        expect(
          Note.d.flat
              .inOctave(0)
              .toString(system: HelmholtzPitchNotation.romance),
          'Re♭͵͵',
        );
        expect(
          Note.b.flat
              .inOctave(1)
              .toString(system: HelmholtzPitchNotation.romance),
          'Si♭͵',
        );
        expect(
          Note.g.inOctave(2).toString(system: HelmholtzPitchNotation.romance),
          'Sol',
        );
        expect(
          Note.a.inOctave(3).toString(system: HelmholtzPitchNotation.romance),
          'la',
        );
        expect(
          Note.c.inOctave(4).toString(system: HelmholtzPitchNotation.romance),
          'do′',
        );
        expect(
          Note.c.sharp
              .inOctave(4)
              .toString(system: HelmholtzPitchNotation.romance),
          'do♯′',
        );
        expect(
          Note.a.inOctave(4).toString(system: HelmholtzPitchNotation.romance),
          'la′',
        );
        expect(
          Note.a.flat
              .inOctave(5)
              .toString(system: HelmholtzPitchNotation.romance),
          'la♭′′',
        );
        expect(
          Note.e.inOctave(7).toString(system: HelmholtzPitchNotation.romance),
          'mi′′′′',
        );
      });

      test('returns the string representation extending PitchNotation', () {
        expect(
          () => Note.a.inOctave(4).toString(system: _SubPitchNotation()),
          throwsUnimplementedError,
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
      test('subtracts Cent to this Pitch', () {
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

        expect(Note.a.flat.inOctave(4) <= Note.a.flat.inOctave(3), isFalse);
        expect(Note.a.inOctave(4) <= Note.f.inOctave(4), isFalse);
      });
    });

    group('operator >()', () {
      test('returns whether this Pitch is higher than other', () {
        expect(Note.a.inOctave(4) > Note.a.inOctave(3), isTrue);
        expect(Note.a.inOctave(4) > Note.g.flat.inOctave(4), isTrue);

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

        expect(Note.a.flat.inOctave(3) >= Note.a.flat.inOctave(4), isFalse);
        expect(Note.f.inOctave(4) >= Note.a.inOctave(4), isFalse);
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal Pitches', () {
        expect(Note.c.inOctave(4).hashCode, Note.c.inOctave(4).hashCode);
        expect(
          // ignore: prefer_const_constructors
          Pitch(Note.a, octave: 3).hashCode,
          // ignore: prefer_const_constructors
          Pitch(Note.a, octave: 3).hashCode,
        );
      });

      test('returns different hashCodes for different Pitches', () {
        expect(
          Note.c.inOctave(4).hashCode,
          isNot(Note.c.inOctave(5).hashCode),
        );
        expect(
          const Pitch(Note.a, octave: 3).hashCode,
          isNot(const Pitch(Note.b, octave: 3).hashCode),
        );
        expect(
          Note.d.inOctave(6).hashCode,
          isNot(Note.c.inOctave(5).hashCode),
        );
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
}

final class _SubPitchNotation extends PitchNotation {
  @override
  String pitch(Pitch pitch) => throw UnimplementedError();
}
