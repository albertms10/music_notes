import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.semitones', () {
      test('should return the semitones value of this Note', () {
        expect(const Note(Notes.si, Accidental.sharp).semitones, 1);
        expect(const Note(Notes.ut).semitones, 1);
        expect(const Note(Notes.ut, Accidental.sharp).semitones, 2);
        expect(const Note(Notes.re, Accidental.flat).semitones, 2);
        expect(const Note(Notes.re).semitones, 3);
        expect(const Note(Notes.re, Accidental.sharp).semitones, 4);
        expect(const Note(Notes.mi, Accidental.flat).semitones, 4);
        expect(const Note(Notes.mi).semitones, 5);
        expect(const Note(Notes.fa).semitones, 6);
        expect(const Note(Notes.fa, Accidental.sharp).semitones, 7);
        expect(const Note(Notes.sol, Accidental.flat).semitones, 7);
        expect(const Note(Notes.sol).semitones, 8);
        expect(const Note(Notes.sol, Accidental.sharp).semitones, 9);
        expect(const Note(Notes.la, Accidental.flat).semitones, 9);
        expect(const Note(Notes.la).semitones, 10);
        expect(const Note(Notes.la, Accidental.sharp).semitones, 11);
        expect(const Note(Notes.si, Accidental.flat).semitones, 11);
        expect(const Note(Notes.si).semitones, 12);
        expect(const Note(Notes.ut, Accidental.flat).semitones, 12);
      });
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another Note',
        () {
          expect(const Note(Notes.ut).difference(const Note(Notes.ut)), 0);
          expect(
            const Note(Notes.mi, Accidental.sharp)
                .difference(const Note(Notes.fa)),
            0,
          );
          expect(
            const Note(Notes.re)
                .difference(const Note(Notes.la, Accidental.flat)),
            6,
          );
        },
      );
    });
  });
}
